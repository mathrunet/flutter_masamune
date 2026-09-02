import "dart:io";

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
