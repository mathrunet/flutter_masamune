// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/src/android_manifest.dart";

Future<void> main() async {
  _verifyJavaCompatibilityVersions();
  await _verifyGradleRoundTrips();
  stdout.writeln("All Gradle regression checks passed.");
}

void _verifyJavaCompatibilityVersions() {
  const cases = <String, String>{
    "JavaVersion.VERSION_1_8": "JavaVersion.VERSION_11",
    "JavaVersion.VERSION_11": "JavaVersion.VERSION_11",
    "JavaVersion.VERSION_17": "JavaVersion.VERSION_17",
    "JavaVersion.VERSION_21": "JavaVersion.VERSION_21",
    "8": "JavaVersion.VERSION_11",
    "1.8": "JavaVersion.VERSION_11",
    "17": "17",
    '"8"': "JavaVersion.VERSION_11",
    '"17"': '"17"',
    '"1.8"': "JavaVersion.VERSION_11",
    'JavaVersion.toVersion("1.8")': "JavaVersion.VERSION_11",
    'JavaVersion.toVersion("17")': 'JavaVersion.toVersion("17")',
    "JavaVersion.toVersion(17)": "JavaVersion.toVersion(17)",
    "libs.versions.java.get()": "libs.versions.java.get()",
    "": "JavaVersion.VERSION_11",
  };
  for (final entry in cases.entries) {
    final options = GradleAndroidCompileOptions(
      sourceCompatibility: entry.key,
      targetCompatibility: entry.key,
    );
    options.ensureMinimumJavaVersion(11);
    _expectEqual(
      options.sourceCompatibility,
      entry.value,
      "sourceCompatibility: ${entry.key}",
    );
    _expectEqual(
      options.targetCompatibility,
      entry.value,
      "targetCompatibility: ${entry.key}",
    );
  }
}

Future<void> _verifyGradleRoundTrips() async {
  final originalDirectory = Directory.current;
  final temporaryRoot =
      await Directory.systemTemp.createTemp("katana_cli_gradle_test_");
  try {
    const scenarios = <String, String>{
      "existing_false": """
    buildFeatures {
        viewBinding = true
        resValues = false
        compose = true
    }
""",
      "existing_true": """
    buildFeatures {
        dataBinding = true
        resValues = true
    }
""",
      "missing": "",
    };
    for (final scenario in scenarios.entries) {
      final project = Directory("${temporaryRoot.path}/${scenario.key}");
      await Directory("${project.path}/android/app").create(recursive: true);
      final gradleFile = File(
        "${project.path}/android/app/build.gradle.kts",
      );
      await gradleFile.writeAsString(_fixture(scenario.value));
      final manifestFile = File(
        "${project.path}/android/app/src/main/AndroidManifest.xml",
      );
      await manifestFile.parent.create(recursive: true);
      await manifestFile.writeAsString(_manifestFixture);
      Directory.current = project;

      await const AndroidManifestPlaceholderSynchronizer().apply();

      final first = await _applyMessagingGradleSettings();
      final second = await _applyMessagingGradleSettings();

      _expectEqual(second, first, "${scenario.key}: second save is idempotent");
      _expectContains(
        second,
        "resValues = true",
        "${scenario.key}: resValues is enabled",
      );
      _expectNotContains(
        second,
        "resValues = false",
        "${scenario.key}: false resValues is removed",
      );
      _expectContains(
        second,
        "JavaVersion.VERSION_17",
        "${scenario.key}: Java 17 is preserved",
      );
      _expectContains(
        second,
        "isCoreLibraryDesugaringEnabled = true",
        "${scenario.key}: desugaring is enabled",
      );
      _expectCount(
        second,
        'applicationId = "com.example.app"',
        1,
        "${scenario.key}: applicationId is preserved once",
      );
      _expectCount(
        second,
        "targetSdk = 35",
        1,
        "${scenario.key}: targetSdk is preserved once",
      );
      _expectCount(
        second,
        "android {",
        1,
        "${scenario.key}: android block is preserved once",
      );
      _expectCount(
        second,
        'resValue("string", "existing_name", "existing_value")',
        1,
        "${scenario.key}: existing resValue is preserved once",
      );
      _expectCount(
        second,
        'resValue("string", "notification_channel_id", '
            'configProperties["notificationChannelId"].toString())',
        1,
        "${scenario.key}: messaging resValue is not duplicated",
      );
      _expectCount(
        second,
        'coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")',
        1,
        "${scenario.key}: desugaring dependency is not duplicated",
      );
      if (scenario.key == "existing_false") {
        _expectContains(
          second,
          "viewBinding = true",
          "unknown viewBinding setting is preserved",
        );
        _expectContains(
          second,
          "compose = true",
          "unknown compose setting is preserved",
        );
      } else if (scenario.key == "existing_true") {
        _expectContains(
          second,
          "dataBinding = true",
          "unknown dataBinding setting is preserved",
        );
      } else {
        _expectContains(
          second,
          "buildFeatures {",
          "missing buildFeatures block is added",
        );
      }
    }
  } finally {
    Directory.current = originalDirectory;
    await temporaryRoot.delete(recursive: true);
  }
}

const _manifestFixture = r'''
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application android:name="${applicationName}">
        <meta-data android:name="example.API_TOKEN" android:value="${API_TOKEN}" />
    </application>
</manifest>
''';

Future<String> _applyMessagingGradleSettings() async {
  final gradle = AppGradle();
  await gradle.load();
  final android = gradle.android;
  if (android == null) {
    throw StateError("android block was not loaded");
  }
  const notificationResValue = '("string", "notification_channel_id", '
      'configProperties["notificationChannelId"].toString())';
  if (!android.defaultConfig.resValues.any(
    (value) => value.startsWith('("string", "notification_channel_id"'),
  )) {
    android.defaultConfig.resValues.add(notificationResValue);
  }
  android.compileOptions
    ..ensureMinimumJavaVersion(11)
    ..coreLibraryDesugaringEnabled = true;
  android.defaultConfig.multiDexEnabled = "true";
  if (!gradle.dependencies.any(
    (dependency) =>
        dependency.group == "coreLibraryDesugaring" &&
        dependency.packageName == "com.android.tools:desugar_jdk_libs:2.1.4",
  )) {
    gradle.dependencies.add(
      GradleDependencies(
        group: "coreLibraryDesugaring",
        packageName: "com.android.tools:desugar_jdk_libs:2.1.4",
        isKotlin: gradle.isKotlin,
      ),
    );
  }
  await gradle.save();
  return File("android/app/build.gradle.kts").readAsString();
}

String _fixture(String buildFeatures) {
  return """
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.example.app"
    compileSdk = 35

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
$buildFeatures
    defaultConfig {
        applicationId = "com.example.app"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
        resValue("string", "existing_name", "existing_value")
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation("org.jetbrains.kotlin:kotlin-stdlib")
}
""";
}

void _expectContains(String actual, String expected, String description) {
  if (!actual.contains(expected)) {
    throw StateError("$description\nExpected to contain: $expected\n$actual");
  }
}

void _expectNotContains(String actual, String expected, String description) {
  if (actual.contains(expected)) {
    throw StateError(
        "$description\nExpected not to contain: $expected\n$actual");
  }
}

void _expectCount(
  String actual,
  String pattern,
  int expected,
  String description,
) {
  final count = pattern.allMatches(actual).length;
  if (count != expected) {
    throw StateError(
      "$description\nExpected count: $expected, actual count: $count\n$actual",
    );
  }
}

void _expectEqual(Object? actual, Object? expected, String description) {
  if (actual != expected) {
    throw StateError(
      "$description\nExpected: $expected\nActual: $actual",
    );
  }
}
