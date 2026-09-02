import "dart:io";

import "package:katana_cli/katana_cli.dart";

Future<void> main() async {
  final originalDirectory = Directory.current;
  final temporaryDirectory = await Directory.systemTemp.createTemp(
    "katana_app_gradle_managed_block_",
  );
  try {
    Directory.current = temporaryDirectory;
    final gradleFile = File("android/app/build.gradle.kts");
    await gradleFile.parent.create(recursive: true);
    await gradleFile.writeAsString('''
import java.util.Properties

${AndroidNativeEnvironmentSynchronizer.beginMarker}
val katanaAndroidApplicationId: String? = null
${AndroidNativeEnvironmentSynchronizer.endMarker}

plugins {
    id("com.android.application")
}

android {
    namespace = "com.example.shared"
    compileSdk = 35

    defaultConfig {
        applicationId = katanaAndroidApplicationId ?: "com.example.shared"
        minSdk = 24
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"
    }
}
''');

    final gradle = AppGradle();
    await gradle.load();
    gradle.android?.compileSdkVersion = "36";
    await gradle.save();

    final saved = await gradleFile.readAsString();
    if (!saved.contains(AndroidNativeEnvironmentSynchronizer.beginMarker) ||
        !saved.contains(AndroidNativeEnvironmentSynchronizer.endMarker)) {
      throw StateError(
          "AppGradle.save must preserve the managed native block.");
    }
    if (!saved.contains("compileSdk = 36")) {
      throw StateError("AppGradle.save must still apply Android changes.");
    }
  } finally {
    Directory.current = originalDirectory;
    await temporaryDirectory.delete(recursive: true);
  }
}
