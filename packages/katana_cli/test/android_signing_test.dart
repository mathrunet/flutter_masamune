// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/git/platform/android.dart";
import "package:katana_cli/katana_cli.dart";

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

int _count(String source, String pattern) {
  return pattern.allMatches(source).length;
}

const _kotlinGradle = """
plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "net.mathru.test"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "net.mathru.test"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
""";

const _groovyGradle = """
plugins {
    id "com.android.application"
    id "dev.flutter.flutter-gradle-plugin"
}

def keyProperties = new Properties()
def keyPropertiesFile = rootProject.file('key.properties')
if (keyPropertiesFile.exists()) {
    keyPropertiesFile.withReader('UTF-8') { reader ->
        keyProperties.load(reader)
    }
}

android {
    namespace "net.mathru.test"
}
""";

Future<void> main() async {
  // Environment detection.
  _check(
    AndroidSigningEnvironment.isConfigured({
      "ANDROID_KEYSTORE_B64": "AAAA",
      "ANDROID_KEYSTORE_PASSWORD": "password",
    }),
    "Keystore and password should enable environment signing.",
  );
  _check(
    !AndroidSigningEnvironment.isConfigured({
      "ANDROID_KEYSTORE_B64": "AAAA",
      "ANDROID_KEYSTORE_PASSWORD": " ",
    }),
    "A blank password should not enable environment signing.",
  );
  _check(
    !AndroidSigningEnvironment.isConfigured({
      "ANDROID_KEYSTORE_PASSWORD": "password",
    }),
    "A missing keystore should not enable environment signing.",
  );

  // Kotlin section.
  final kotlin = AndroidSigningEnvironment.synchronize(
    _kotlinGradle,
    isKotlin: true,
    alias: r'my"alias$',
  );
  _check(
    _count(kotlin, AndroidSigningEnvironment.beginMarker) == 1,
    "The Kotlin section should be inserted once.",
  );
  _check(
    kotlin.indexOf(AndroidSigningEnvironment.endMarker) <
        kotlin.indexOf("\nandroid {"),
    "The Kotlin section should precede the android block.",
  );
  _check(
    kotlin.startsWith("import java.util.Base64\n"),
    "Kotlin Gradle should import java.util.Base64.",
  );
  _check(
    kotlin.contains(r'?: "my\"alias\$"'),
    "The alias fallback should be escaped for Kotlin strings.",
  );
  _check(
    !kotlin.contains("java.util.Base64.getMimeDecoder"),
    "Kotlin Gradle cannot resolve fully qualified java.util classes.",
  );
  final kotlinAgain = AndroidSigningEnvironment.synchronize(
    kotlin,
    isKotlin: true,
    alias: "renamed",
  );
  _check(
    _count(kotlinAgain, AndroidSigningEnvironment.beginMarker) == 1 &&
        _count(kotlinAgain, "import java.util.Base64") == 1,
    "Synchronizing twice should replace the section without duplicates.",
  );
  _check(
    kotlinAgain.contains('?: "renamed"') && !kotlinAgain.contains("my"),
    "Synchronizing again should update the alias fallback.",
  );
  _check(
    AndroidSigningEnvironment.extract(kotlinAgain)!
        .endsWith(AndroidSigningEnvironment.endMarker),
    "The extracted section should end with the end marker.",
  );

  // Groovy section.
  final groovy = AndroidSigningEnvironment.synchronize(
    _groovyGradle,
    isKotlin: false,
  );
  _check(
    !groovy.contains("import java.util.Base64"),
    "Groovy Gradle should use the fully qualified decoder.",
  );
  _check(
    groovy.contains("java.util.Base64.mimeDecoder.decode") &&
        !groovy.contains('?: "'),
    "Groovy Gradle should decode the keystore and omit an empty alias.",
  );
  _check(
    groovy.indexOf("def keyProperties") <
        groovy.indexOf(AndroidSigningEnvironment.beginMarker),
    "The Groovy section should follow the keyProperties loader.",
  );

  // The section survives AppGradle round trips.
  final temporary = await Directory.systemTemp.createTemp("katana_signing");
  final current = Directory.current;
  try {
    Directory.current = temporary;
    final file = File("android/app/build.gradle.kts");
    await file.create(recursive: true);
    await file.writeAsString(_kotlinGradle);
    final gradle = AppGradle();
    await gradle.load();
    gradle.loadProperties.add(
      GradleLoadProperties(
        path: "key.properties",
        name: "keyProperties",
        file: "keyPropertiesFile",
        isKotlin: true,
      ),
    );
    gradle.android?.signingConfigs = GradleAndroidSigningConfigs(
      release: GradleAndroidSigningConfig(
        keyAlias: AndroidSigningEnvironment.keyAliasExpression,
        keyPassword: AndroidSigningEnvironment.keyPasswordExpression,
        storeFile: AndroidSigningEnvironment.storeFileExpression,
        storePassword: AndroidSigningEnvironment.storePasswordExpression,
      ),
    );
    await gradle.save();
    await file.writeAsString(
      AndroidSigningEnvironment.synchronize(
        await file.readAsString(),
        isKotlin: true,
        alias: "alias",
      ),
    );
    final roundTrip = AppGradle();
    await roundTrip.load();
    await roundTrip.save();
    final saved = await file.readAsString();
    _check(
      _count(saved, AndroidSigningEnvironment.beginMarker) == 1,
      "AppGradle.save should keep the signing section.",
    );
    _check(
      saved.indexOf("val keyProperties") <
              saved.indexOf(AndroidSigningEnvironment.beginMarker) &&
          saved.indexOf(AndroidSigningEnvironment.endMarker) <
              saved.indexOf("\nandroid {"),
      "The signing section should stay between keyProperties and android.",
    );
    _check(
      roundTrip.android?.signingConfigs?.release?.storeFile ==
          AndroidSigningEnvironment.storeFileExpression,
      "The release signing config should reference the managed section.",
    );
  } finally {
    Directory.current = current;
    await temporary.delete(recursive: true);
  }

  // GitHub Actions workflow.
  const environmentWorkflow =
      GithubActionsAndroidCliCode(useEnvironmentSigning: true);
  final environmentBody = environmentWorkflow.body("", "", "");
  _check(
    environmentBody.contains(
          "ANDROID_KEYSTORE_B64: \${{ secrets.ANDROID_KEYSTORE_B64_#### REPLACE_APP_NAME #### }}",
        ) &&
        environmentBody.contains("ANDROID_KEYSTORE_PASSWORD:") &&
        environmentBody.contains("ANDROID_KEYSTORE_ALIAS:"),
    "The environment workflow should pass the keystore to Gradle.",
  );
  _check(
    !environmentBody.contains("key.properties") &&
        !environmentBody.contains("appkey.keystore"),
    "The environment workflow should not restore keystore files.",
  );
  _check(
    environmentBody.contains("timeout-minutes: 30\n\n      # Upload"),
    "The environment workflow should keep step spacing.",
  );
  const fileWorkflow = GithubActionsAndroidCliCode();
  final fileBody = fileWorkflow.body("", "", "");
  _check(
    fileBody.contains("Create key.properties") &&
        fileBody.contains("Create appkey.keystore") &&
        !fileBody.contains("ANDROID_KEYSTORE_PASSWORD:"),
    "The file workflow should keep restoring keystore files.",
  );

  stdout.writeln("android_signing_test: all checks passed.");
}
