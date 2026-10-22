// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/app/keystore.dart";
import "package:katana_cli/katana_cli.dart";

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

int _count(String source, String pattern) {
  return pattern.allMatches(source).length;
}

// Custom content that is not modeled by AppGradle must survive every save.
const _kotlinGradle = r'''
import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

val configProperties = Properties()
rootProject.file("config.properties").let { configPropertiesFile ->
    if (configPropertiesFile.exists()) {
        configPropertiesFile.inputStream().use { stream ->
            configProperties.load(stream)
        }
    }
}

// KATANA DART DEFINE MANIFEST PLACEHOLDERS:START
val katanaManifestPlaceholders = mapOf("MAPS_API_KEY" to "value")
// KATANA DART DEFINE MANIFEST PLACEHOLDERS:END

// Keep rules contain braces inside a raw string.
val customKeepRules = layout.buildDirectory.file("generated/proguard-rules.pro").get().asFile
customKeepRules.parentFile.mkdirs()
customKeepRules.writeText("""
-keep class com.example.Foo { public static *** getInstance(); }
-keep interface com.example.Listener { *; }
""".trimIndent())

android {
    namespace = "net.mathru.test"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    buildFeatures {
        resValues = true
    }

    defaultConfig {
        applicationId = "net.mathru.test"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue("string", "app_label", "Test")

        // Manifest placeholders.
        manifestPlaceholders.putAll(katanaManifestPlaceholders)
    }

    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }

    buildTypes {
        release {
            proguardFile(customKeepRules)
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.0.0"))
}

afterEvaluate {
    tasks.matching { it.name.endsWith("GoogleServices") }.configureEach {
        println("custom")
    }
}
''';

const _kotlinCustomLines = [
  "// KATANA DART DEFINE MANIFEST PLACEHOLDERS:START",
  "val katanaManifestPlaceholders",
  "-keep class com.example.Foo { public static *** getInstance(); }",
  "-keep interface com.example.Listener { *; }",
  '""".trimIndent())',
  "kotlinOptions {",
  "jvmTarget = JavaVersion.VERSION_17.toString()",
  "manifestPlaceholders.putAll(katanaManifestPlaceholders)",
  "// Manifest placeholders.",
  'excludes += "/META-INF/{AL2.0,LGPL2.1}"',
  "proguardFile(customKeepRules)",
  "kotlin {",
  "compilerOptions {",
  'implementation(platform("com.google.firebase:firebase-bom:33.0.0"))',
  'println("custom")',
];

const _groovyGradle = '''
plugins {
    id "com.android.application"
    id "dev.flutter.flutter-gradle-plugin"
}

def localProperties = new Properties()
def localPropertiesFile = rootProject.file('local.properties')
if (localPropertiesFile.exists()) {
    localPropertiesFile.withReader('UTF-8') { reader ->
        localProperties.load(reader)
    }
}

android {
    namespace "net.mathru.test"
    compileSdk flutter.compileSdkVersion

    kotlinOptions {
        jvmTarget = '17'
    }

    defaultConfig {
        applicationId "net.mathru.test"
        minSdkVersion flutter.minSdkVersion
        manifestPlaceholders = [mapsKey: "value"]
    }

    buildTypes {
        release {
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
            signingConfig signingConfigs.debug
        }
    }
}

flutter {
    source '../..'
}
''';

const _groovyCustomLines = [
  "kotlinOptions {",
  "jvmTarget = '17'",
  'manifestPlaceholders = [mapsKey: "value"]',
  "minifyEnabled true",
  "proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'",
];

Future<String> _withGradle(
  String fileName,
  String source,
  Future<void> Function(File file) action,
) async {
  final temporary = await Directory.systemTemp.createTemp("katana_gradle");
  final current = Directory.current;
  try {
    Directory.current = temporary;
    final file = File("android/app/$fileName");
    await file.create(recursive: true);
    await file.writeAsString(source);
    await action(file);
    return await file.readAsString();
  } finally {
    Directory.current = current;
    await temporary.delete(recursive: true);
  }
}

void _checkCustomLines(String source, List<String> lines, String label) {
  for (final line in lines) {
    _check(source.contains(line), "$label should keep `$line`.");
  }
}

Future<void> main() async {
  // A round trip without changes keeps the file byte for byte.
  for (final entry in {
    "build.gradle.kts": _kotlinGradle,
    "build.gradle": _groovyGradle,
  }.entries) {
    final saved = await _withGradle(entry.key, entry.value, (file) async {
      final gradle = AppGradle();
      await gradle.load();
      await gradle.save();
    });
    _check(
      saved == entry.value,
      "${entry.key} should not change when nothing is modified.",
    );
  }

  // Parsing reads nested blocks correctly.
  await _withGradle("build.gradle.kts", _kotlinGradle, (file) async {
    final gradle = AppGradle();
    await gradle.load();
    final android = gradle.android!;
    _check(
      android.defaultConfig.applicationId == '"net.mathru.test"' &&
          android.defaultConfig.minSdkVersion == "flutter.minSdkVersion",
      "defaultConfig should be parsed.",
    );
    _check(
      android.buildTypes.release?.signingConfig ==
          'signingConfigs.getByName("debug")',
      "The release build type should be parsed.",
    );
    _check(
      gradle.dependencies.length == 1 && gradle.plugins.length == 2,
      "Top-level dependencies and plugins should be parsed.",
    );
  });

  // Applying the keystore keeps custom content and is idempotent.
  late String firstKotlin;
  final secondKotlin =
      await _withGradle("build.gradle.kts", _kotlinGradle, (file) async {
    await AppKeystoreCliAction.applyGradle("alias");
    firstKotlin = await file.readAsString();
    await AppKeystoreCliAction.applyGradle("alias");
  });
  _checkCustomLines(firstKotlin, _kotlinCustomLines, "Kotlin keystore");
  _check(
    secondKotlin == firstKotlin,
    "Applying the keystore twice should not change the Kotlin file.",
  );
  _check(
    _count(firstKotlin, AndroidSigningEnvironment.beginMarker) == 1 &&
        _count(firstKotlin, "import java.util.Base64") == 1 &&
        _count(firstKotlin, "import java.util.Properties") == 1 &&
        _count(firstKotlin, "val keyProperties = Properties()") == 1,
    "The signing section and its imports should be added once.",
  );
  _check(
    firstKotlin.contains(
          'proguardFile(customKeepRules)\n            signingConfig = signingConfigs.getByName("release")',
        ) &&
        firstKotlin.contains(
          'debug {\n            signingConfig = signingConfigs.getByName("debug")\n        }',
        ),
    "Only signingConfig should change in the build types.",
  );
  _check(
    firstKotlin.indexOf("signingConfigs {") <
            firstKotlin.indexOf("buildTypes {") &&
        firstKotlin.contains(
          'create("release") {\n            keyAlias = ${AndroidSigningEnvironment.keyAliasExpression}',
        ),
    "signingConfigs should be inserted before buildTypes.",
  );
  _check(
    firstKotlin.indexOf("val configProperties") <
            firstKotlin.indexOf("val keyProperties") &&
        firstKotlin.indexOf("val keyProperties") <
            firstKotlin.indexOf("// KATANA DART DEFINE MANIFEST"),
    "keyProperties should follow the existing properties loader.",
  );

  final secondGroovy =
      await _withGradle("build.gradle", _groovyGradle, (file) async {
    await AppKeystoreCliAction.applyGradle("alias");
    final first = await file.readAsString();
    _checkCustomLines(first, _groovyCustomLines, "Groovy keystore");
    _check(
      first.contains("signingConfig signingConfigs.release") &&
          _count(first, "signingConfig ") == 2 &&
          first.contains("    signingConfigs {\n        release {"),
      "Groovy signing should reuse the existing signingConfig line.",
    );
    await AppKeystoreCliAction.applyGradle("alias");
    _check(
      await file.readAsString() == first,
      "Applying the keystore twice should not change the Groovy file.",
    );
  });
  _checkCustomLines(secondGroovy, _groovyCustomLines, "Groovy keystore");

  // Other edits only touch the targeted lines.
  final edited =
      await _withGradle("build.gradle.kts", _kotlinGradle, (file) async {
    final gradle = AppGradle();
    await gradle.load();
    gradle.android!.defaultConfig.minSdkVersion =
        'configProperties["flutter.minSdkVersion"].toString().toInt()';
    gradle.android!.defaultConfig.multiDexEnabled = "true";
    gradle.android!.defaultConfig.resValues.add(
      '("string", "notification_channel_id", "default")',
    );
    gradle.android!.compileOptions.coreLibraryDesugaringEnabled = true;
    gradle.plugins.add(
      GradlePlugin(plugin: "com.google.gms.google-services", isKotlin: true),
    );
    gradle.dependencies.add(
      GradleDependencies(
        group: "coreLibraryDesugaring",
        packageName: "com.android.tools:desugar_jdk_libs:2.1.4",
        isKotlin: true,
      ),
    );
    await gradle.save();
  });
  _checkCustomLines(edited, _kotlinCustomLines, "Edited Kotlin");
  _check(
    edited.contains(
          '        minSdk = configProperties["flutter.minSdkVersion"].toString().toInt()\n',
        ) &&
        edited.contains(
          '        manifestPlaceholders.putAll(katanaManifestPlaceholders)\n        multiDexEnabled = true\n        resValue("string", "notification_channel_id", "default")\n    }',
        ),
    "defaultConfig should be edited in place.",
  );
  _check(
    edited.contains(
          "targetCompatibility = JavaVersion.VERSION_17\n        isCoreLibraryDesugaringEnabled = true\n    }",
        ) &&
        edited.contains(
          '    id("dev.flutter.flutter-gradle-plugin")\n    id("com.google.gms.google-services")\n}',
        ) &&
        edited.contains(
          'firebase-bom:33.0.0"))\n    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")\n}',
        ),
    "compileOptions, plugins and dependencies should be appended.",
  );
  final expectedLines = _kotlinGradle.split("\n").length + 5;
  _check(
    edited.split("\n").length == expectedLines,
    "Only the edited lines should be added.",
  );

  stdout.writeln("app_gradle_test: all checks passed.");
}
