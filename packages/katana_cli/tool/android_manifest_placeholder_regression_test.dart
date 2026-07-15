// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/src/android_manifest.dart";

Future<void> main() async {
  final temporaryRoot = await Directory.systemTemp
      .createTemp("katana_manifest_placeholder_test_");
  try {
    await _verifyKotlinDsl(temporaryRoot);
    await _verifyGroovy(temporaryRoot);
    stdout.writeln("All AndroidManifest placeholder checks passed.");
  } finally {
    await temporaryRoot.delete(recursive: true);
  }
}

Future<void> _verifyKotlinDsl(Directory temporaryRoot) async {
  final project = Directory("${temporaryRoot.path}/kotlin");
  final manifest = File("${project.path}/AndroidManifest.xml");
  final gradle = File("${project.path}/build.gradle.kts");
  await project.create(recursive: true);
  await manifest.writeAsString(_manifest(["API_TOKEN", "SECOND_KEY"]));
  await gradle.writeAsString(_kotlinFixture);
  final synchronizer = AndroidManifestPlaceholderSynchronizer(
    manifestPath: manifest.path,
    kotlinGradlePath: gradle.path,
    groovyGradlePath: "${project.path}/missing.gradle",
  );

  await synchronizer.apply();
  final first = await gradle.readAsString();
  await synchronizer.apply();
  final second = await gradle.readAsString();

  _expectEqual(second, first, "Kotlin DSL is idempotent");
  _expectContains(second, '    "API_TOKEN",', "first key is generated");
  _expectContains(second, '    "SECOND_KEY",', "second key is generated");
  _expectNotContains(
    second,
    '"applicationName",',
    "Flutter applicationName is ignored",
  );
  _expectNotContains(
    second,
    "googleMapsAndroidApiKey",
    "legacy Google Maps variable is removed",
  );
  _expectCount(
    second,
    "import java.util.Base64",
    1,
    "Base64 import is generated once",
  );
  _expectContains(
    second,
    "String(Base64.getDecoder().decode(encoded))",
    "imported Base64 decoder is used",
  );
  _expectNotContains(
    second,
    "java.util.Base64.getDecoder()",
    "Gradle DSL-shadowed fully qualified Base64 is not used",
  );
  _expectContains(second, "compose = true", "unknown build feature is kept");
  _expectContains(
    second,
    "useSupportLibrary = true",
    "nested defaultConfig block is kept",
  );
  _expectCount(
    second,
    "KATANA DART DEFINE MANIFEST PLACEHOLDERS:START",
    1,
    "definitions block is generated once",
  );
  _expectCount(
    second,
    "manifestPlaceholders.putAll(katanaManifestPlaceholders)",
    1,
    "assignment is generated once",
  );
  _expectContains(
    second,
    "        // KATANA MANIFEST PLACEHOLDER ASSIGNMENT:END\n    }",
    "defaultConfig closing brace keeps its indentation",
  );

  await manifest.writeAsString(_manifest(["API_TOKEN"]));
  await synchronizer.apply();
  final keyRemoved = await gradle.readAsString();
  _expectContains(keyRemoved, '    "API_TOKEN",', "remaining key is kept");
  _expectNotContains(
    keyRemoved,
    '    "SECOND_KEY",',
    "removed Manifest key is removed from Gradle",
  );

  await manifest.writeAsString(_manifest(const []));
  await synchronizer.apply();
  final allRemoved = await gradle.readAsString();
  _expectNotContains(
    allRemoved,
    "KATANA DART DEFINE MANIFEST PLACEHOLDERS",
    "definitions are removed when no keys remain",
  );
  _expectNotContains(
    allRemoved,
    "katanaManifestPlaceholders",
    "assignment is removed when no keys remain",
  );
  _expectNotContains(
    allRemoved,
    "import java.util.Base64",
    "unused managed Base64 import is removed",
  );
  _expectContains(
    allRemoved,
    "compose = true",
    "unknown Gradle content remains after cleanup",
  );
}

Future<void> _verifyGroovy(Directory temporaryRoot) async {
  final project = Directory("${temporaryRoot.path}/groovy");
  final manifest = File("${project.path}/AndroidManifest.xml");
  final gradle = File("${project.path}/build.gradle");
  await project.create(recursive: true);
  await manifest.writeAsString(_manifest(["API_TOKEN", "SECOND_KEY"]));
  await gradle.writeAsString(_groovyFixture);
  final synchronizer = AndroidManifestPlaceholderSynchronizer(
    manifestPath: manifest.path,
    kotlinGradlePath: "${project.path}/missing.gradle.kts",
    groovyGradlePath: gradle.path,
  );

  await synchronizer.apply();
  final first = await gradle.readAsString();
  await synchronizer.apply();
  final second = await gradle.readAsString();

  _expectEqual(second, first, "Groovy is idempotent");
  _expectContains(second, "encoded.decodeBase64()", "Groovy decoder is used");
  _expectContains(second, '    "API_TOKEN",', "Groovy first key is generated");
  _expectContains(
    second,
    '    "SECOND_KEY",',
    "Groovy second key is generated",
  );
  _expectNotContains(
    second,
    '"applicationName",',
    "Groovy ignores Flutter applicationName",
  );
  _expectContains(
    second,
    "customSetting true",
    "unknown Groovy content is kept",
  );
}

String _manifest(List<String> placeholders) {
  final metadata = placeholders
      .map(
        (name) =>
            '        <meta-data android:name="example.$name" android:value="\${$name}" />',
      )
      .join("\n");
  return '''
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application android:name="\${applicationName}">
$metadata
    </application>
</manifest>
''';
}

const _kotlinFixture = r'''
import java.util.Base64

plugins {
    id("com.android.application")
}

val dartDefines = sequenceOf("dart-defines", "DART_DEFINES")
    .mapNotNull { project.findProperty(it)?.toString() }
    .firstOrNull()
    .orEmpty()
    .split(',')
    .filter { it.isNotBlank() }
    .associate { encoded ->
        val decoded = String(Base64.getDecoder().decode(encoded))
        val separator = decoded.indexOf('=')
        require(separator > 0) { "Invalid dart-define entry." }
        decoded.substring(0, separator) to decoded.substring(separator + 1)
    }
val googleMapsAndroidApiKey = requireNotNull(
    dartDefines["API_TOKEN"]?.takeIf { it.isNotBlank() },
) { "API_TOKEN is required via --dart-define-from-file=dart_defines/<flavor>.env" }
val userValue = "keep-me"

android {
    namespace = "com.example.app"

    buildFeatures {
        compose = true
    }

    defaultConfig {
        applicationId = "com.example.app"
        vectorDrawables {
            useSupportLibrary = true
        }
        manifestPlaceholders["API_TOKEN"] = googleMapsAndroidApiKey
    }
}
''';

const _groovyFixture = r"""
plugins {
    id 'com.android.application'
}

android {
    namespace 'com.example.app'
    customSetting true

    defaultConfig {
        applicationId 'com.example.app'
    }
}
""";

void _expectEqual(String actual, String expected, String message) {
  if (actual != expected) {
    throw StateError("$message\nExpected:\n$expected\nActual:\n$actual");
  }
}

void _expectContains(String actual, String expected, String message) {
  if (!actual.contains(expected)) {
    throw StateError("$message: missing `$expected`");
  }
}

void _expectNotContains(String actual, String expected, String message) {
  if (actual.contains(expected)) {
    throw StateError("$message: unexpected `$expected`");
  }
}

void _expectCount(
  String actual,
  String expected,
  int count,
  String message,
) {
  final actualCount = expected.allMatches(actual).length;
  if (actualCount != count) {
    throw StateError("$message: expected $count, got $actualCount");
  }
}
