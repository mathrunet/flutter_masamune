import "dart:io";

import "package:katana_cli/command/fix.dart";

Future<void> main() async {
  final originalDirectory = Directory.current;
  final temporary = await Directory.systemTemp.createTemp("katana-fix-test-");
  try {
    Directory.current = temporary;
    await Directory("dart_defines").create();
    await File("dart_defines/dev.env").writeAsString(
      "flavor=dev\napplicationId=com.example.app.dev\n",
    );
    await File("dart_defines/prod.env").writeAsString("FLAVOR=prod\n");
    await Directory("ios/Flutter").create(recursive: true);
    await File("ios/Flutter/DartDefine.xcconfig").writeAsString(
      "applicationId=com.example.app\n",
    );
    await Directory("android/app").create(recursive: true);
    await File("android/app/google-services.json").writeAsString(
      '{"project_info":{"project_id":"app-dev"}}',
    );
    await Directory("lib").create();
    await File("lib/firebase_options.dart").writeAsString('''
const firebaseOptions = FirebaseOptions(
  projectId: "app-dev",
);
''');
    await File("android/env.properties").writeAsString(
      "applicationId=com.example.app\n",
    );
    await File("android/app/build.gradle.kts").writeAsString('''
plugins { id("com.android.application") }
val envProperties = mapOf("applicationId" to "com.example.app")
android {
  defaultConfig {
    applicationId = envProperties["applicationId"].toString()
  }
}
''');
    final diagnostic = KatanaEnvironmentFixPlan.inspect();
    _expect(
      diagnostic.operations.contains("normalize dart_defines/dev.env"),
      "Legacy lowercase flavor must be diagnosed.",
    );
    _expect(
      File("dart_defines/dev.env").readAsStringSync().contains("flavor=dev"),
      "Diagnostic mode must not modify files.",
    );
    _expect(
      diagnostic.operations.contains(
        "inspect legacy Firebase file android/app/google-services.json",
      ),
      "Legacy Firebase files must be diagnosed without moving them.",
    );
    await diagnostic.apply(flavor: "dev", firebaseProjectId: "app-dev");
    final migrated = File("dart_defines/dev.env").readAsStringSync();
    _expect(migrated.contains("FLAVOR=dev"), "FLAVOR must be uppercase.");
    _expect(
      migrated.contains("ANDROID_APPLICATION_ID=com.example.app.dev"),
      "Legacy Android application ID must remain an optional override.",
    );
    _expect(
      !File("ios/Flutter/DartDefine.xcconfig").existsSync(),
      "The obsolete Xcode pre-copy file must be retired.",
    );
    final gradle = File("android/app/build.gradle.kts").readAsStringSync();
    _expect(
      gradle.contains("katanaAndroidApplicationId") &&
          gradle.contains('?: "com.example.app"'),
      "Legacy Gradle must use DART_DEFINES with the common ID fallback.",
    );
    _expect(
      !File("android/env.properties").existsSync(),
      "The obsolete Android pre-copy file must be retired.",
    );
    _expect(
      !File("android/app/google-services.json").existsSync() &&
          File(
            "android/app/src/katanaFirebase/dev/google-services.json",
          ).existsSync(),
      "A matching Android Firebase file must move into the selected flavor.",
    );
    _expect(
      !File("lib/firebase_options.dart").existsSync() &&
          File(
            "lib/katana/firebase/dev/firebase_options.dart",
          ).existsSync(),
      "Matching Dart Firebase options must move into the selected flavor.",
    );
    final second = KatanaEnvironmentFixPlan.inspect();
    _expect(second.operations.isEmpty, "A second migration must be a no-op.");
  } finally {
    Directory.current = originalDirectory;
    await temporary.delete(recursive: true);
  }
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}
