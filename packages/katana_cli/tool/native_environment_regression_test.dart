import "dart:io";
import "dart:convert";

import "package:katana_cli/katana_cli.dart";

void main(List<String> arguments) {
  const kotlin = '''
plugins {
    id("com.android.application")
}

android {
    defaultConfig {
        applicationId = "com.example.shared"
        minSdk = 24
    }
}
''';
  final synchronizedKotlin = AndroidNativeEnvironmentSynchronizer.synchronize(
    kotlin,
    isKotlin: true,
  );
  _expect(
    synchronizedKotlin.contains('katanaDartDefines["FLAVOR"]'),
    "Kotlin Gradle must read FLAVOR from DART_DEFINES.",
  );
  _expect(
    synchronizedKotlin.contains(
      'applicationId = katanaAndroidApplicationId ?: "com.example.shared"',
    ),
    "Kotlin Gradle must retain the shared application ID fallback.",
  );
  _expect(
    AndroidNativeEnvironmentSynchronizer.synchronize(
          synchronizedKotlin,
          isKotlin: true,
        ) ==
        synchronizedKotlin,
    "Synchronization must be idempotent.",
  );
  _expect(
    synchronizedKotlin.startsWith("import java.util.Base64\n") &&
        !synchronizedKotlin.contains("java.util.Base64.getDecoder()"),
    "Kotlin Gradle must use the imported Base64 decoder.",
  );
  final legacyKotlin = synchronizedKotlin
      .replaceFirst("import java.util.Base64\n", "")
      .replaceFirst(
        "String(Base64.getDecoder()",
        "String(java.util.Base64.getDecoder()",
      );
  _expect(
    AndroidNativeEnvironmentSynchronizer.synchronize(
          legacyKotlin,
          isKotlin: true,
        ) ==
        synchronizedKotlin,
    "Legacy fully qualified Base64 must be migrated to the imported decoder.",
  );
  const orphanedKotlin = '''
plugins {
    id("com.android.application")
}

android {
    defaultConfig {
        applicationId = katanaAndroidApplicationId ?: "com.example.shared"
    }
}
''';
  final recoveredKotlin = AndroidNativeEnvironmentSynchronizer.synchronize(
    orphanedKotlin,
    isKotlin: true,
  );
  _expect(
    recoveredKotlin.contains(AndroidNativeEnvironmentSynchronizer.beginMarker),
    "An orphaned Kotlin applicationId expression must recover its managed block.",
  );
  _expect(
    recoveredKotlin.contains(
      'applicationId = katanaAndroidApplicationId ?: "com.example.shared"',
    ),
    "Recovery must retain the Kotlin application ID fallback.",
  );
  final firebaseKotlin =
      AndroidNativeEnvironmentSynchronizer.synchronizeFirebase(
    synchronizedKotlin,
    isKotlin: true,
  );
  _expect(
    firebaseKotlin.contains(
      "src/katanaFirebase/\$katanaFlavor/google-services.json",
    ),
    "Google Services must select JSON using the same FLAVOR.",
  );
  _expect(
    AndroidNativeEnvironmentSynchronizer.synchronizeFirebase(
          firebaseKotlin,
          isKotlin: true,
        ) ==
        firebaseKotlin,
    "Firebase synchronization must be idempotent.",
  );

  const groovy = '''
plugins {
    id 'com.android.application'
}

android {
    defaultConfig {
        applicationId "com.example.shared"
        minSdkVersion 24
    }
}
''';
  final synchronizedGroovy = AndroidNativeEnvironmentSynchronizer.synchronize(
    groovy,
    isKotlin: false,
  );
  _expect(
    synchronizedGroovy.contains(
      "applicationId katanaAndroidApplicationId ?: \"com.example.shared\"",
    ),
    "Groovy Gradle must retain the shared application ID fallback.",
  );

  _expectThrows(
    () => AndroidNativeEnvironmentSynchronizer.synchronize(
      "android {}",
      isKotlin: true,
    ),
    "A project without applicationId must fail safely.",
  );

  const pbxProject = """
/* Begin PBXNativeTarget section */
    123ABC /* Runner */ = {
      isa = PBXNativeTarget;
      buildPhases = (
        AAA /* Sources */,
      );
    };
/* End PBXNativeTarget section */
/* Begin PBXShellScriptBuildPhase section */
    BBB /* Thin Binary */ = {
      isa = PBXShellScriptBuildPhase;
    };
/* End PBXShellScriptBuildPhase section */
""";
  final synchronizedProject =
      AppleFirebaseEnvironmentSynchronizer.synchronizeProject(pbxProject);
  _expect(
    synchronizedProject.contains(
      AppleFirebaseEnvironmentSynchronizer.buildPhaseName,
    ),
    "Runner must receive the Firebase selection build phase.",
  );
  _expect(
    synchronizedProject.contains(r"${DART_DEFINES:-}"),
    "The Apple script must decode Flutter DART_DEFINES.",
  );
  _expect(
    AppleFirebaseEnvironmentSynchronizer.synchronizeProject(
          synchronizedProject,
        ) ==
        synchronizedProject,
    "Xcode project synchronization must be idempotent.",
  );

  final sandbox = Directory.systemTemp.createTempSync("katana-apple-test-");
  try {
    final script = File("${sandbox.path}/select.sh")
      ..writeAsStringSync(AppleFirebaseEnvironmentSynchronizer.shellScript);
    final destination = Directory("${sandbox.path}/build/Runner.app")
      ..createSync(recursive: true);
    final stale = File("${destination.path}/GoogleService-Info.plist")
      ..writeAsStringSync("stale production configuration");
    final result = Process.runSync("/bin/sh", [
      script.path
    ], environment: {
      "DART_DEFINES": base64.encode(utf8.encode("FLAVOR=test")),
      "PROJECT_DIR": sandbox.path,
      "TARGET_BUILD_DIR": "${sandbox.path}/build",
      "UNLOCALIZED_RESOURCES_FOLDER_PATH": "Runner.app",
    });
    _expect(result.exitCode == 0,
        "Test flavor must build without Firebase: ${result.stderr}");
    _expect(
        !stale.existsSync(), "Test flavor must remove stale Firebase output.");
    for (final flavor in ["dev", "prod"]) {
      final plist = File(
          "${sandbox.path}/Runner/Firebase/$flavor/GoogleService-Info.plist");
      plist.parent.createSync(recursive: true);
      plist.writeAsStringSync(flavor);
      final selected = Process.runSync("/bin/sh", [
        script.path
      ], environment: {
        "DART_DEFINES": base64.encode(utf8.encode("FLAVOR=$flavor")),
        "PROJECT_DIR": sandbox.path,
        "TARGET_BUILD_DIR": "${sandbox.path}/build",
        "UNLOCALIZED_RESOURCES_FOLDER_PATH": "Runner.app",
      });
      _expect(selected.exitCode == 0 && stale.readAsStringSync() == flavor,
          "Each Firebase environment must select its own plist.");
    }
    for (final flavor in ["dev", "unknown", ""]) {
      final missing =
          File("${sandbox.path}/Runner/Firebase/dev/GoogleService-Info.plist");
      if (missing.existsSync()) {
        missing.deleteSync();
      }
      final rejected = Process.runSync("/bin/sh", [
        script.path
      ], environment: {
        "DART_DEFINES": base64.encode(utf8.encode("FLAVOR=$flavor")),
        "PROJECT_DIR": sandbox.path,
        "TARGET_BUILD_DIR": "${sandbox.path}/build",
        "UNLOCALIZED_RESOURCES_FOLDER_PATH": "Runner.app",
      });
      _expect(rejected.exitCode != 0,
          "Missing real Firebase configurations and invalid flavors must fail.");
    }
  } finally {
    sandbox.deleteSync(recursive: true);
  }
  final oldProject = synchronizedProject.replaceFirst(
    RegExp(r'shellScript = "[^\n]*";'),
    'shellScript = "legacy";',
  );
  _expect(
      AppleFirebaseEnvironmentSynchronizer.synchronizeProject(oldProject) ==
          synchronizedProject,
      "Existing Firebase build phases must be upgraded.");
  const legacyReferences = """
    ABC001 /* GoogleService-Info.plist in Resources */ = {isa = PBXBuildFile; fileRef = ABC002 /* GoogleService-Info.plist */; };
    ABC002 /* GoogleService-Info.plist */ = {isa = PBXFileReference; path = "Runner/GoogleService-Info.plist"; sourceTree = "<group>"; };
    ABC002 /* GoogleService-Info.plist */,
    ABC001 /* GoogleService-Info.plist in Resources */,
""";
  final migrated = AppleFirebaseEnvironmentSynchronizer.synchronizeProject(
      legacyReferences + oldProject);
  _expect(!migrated.contains("ABC001") && !migrated.contains("ABC002"),
      "Legacy plist resources and file references must be retired.");

  _expect(
      AppleFirebaseEnvironmentSynchronizer.synchronizeProject(migrated) ==
          migrated,
      "Legacy resource migration must be idempotent.");
  for (final path in arguments) {
    final source = File(path).readAsStringSync();
    if (path.endsWith("project.pbxproj")) {
      final transformed =
          AppleFirebaseEnvironmentSynchronizer.synchronizeProject(source);
      _expect(
        transformed.contains(AppleFirebaseEnvironmentSynchronizer.buildPhaseId),
        "A real Flutter Xcode project must accept the managed build phase.",
      );
    } else if (path.endsWith("build.gradle.kts")) {
      final transformed = AndroidNativeEnvironmentSynchronizer.synchronize(
        source,
        isKotlin: true,
      );
      _expect(
        transformed.contains("katanaAndroidApplicationId"),
        "A real Flutter Gradle project must accept native environment parsing.",
      );
    }
  }
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

void _expectThrows(void Function() callback, String message) {
  try {
    callback();
  } on Object {
    return;
  }
  throw StateError(message);
}
