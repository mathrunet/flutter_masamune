import "dart:io";
import "package:katana_cli/action/firebase/messaging.dart";

Future<void> main(List<String> arguments) async {
  final fixture = arguments.isEmpty
      ? _runnerFixture
      : File(arguments.single).readAsStringSync();
  final root = Directory.systemTemp.createTempSync("messaging_order_");
  final original = Directory.current;
  const reference =
      "F17EBA5E0000000000000002 /* Set Dev Firebase Messaging Auto-Init */,";
  String phases(String source) {
    final start = source.indexOf("/* Runner */ = {",
        source.indexOf("/* Begin PBXNativeTarget section */"));
    final rest = source.substring(start);
    return rest.substring(
        rest.indexOf("buildPhases = ("), rest.indexOf("\n\t\t\t);"));
  }

  void check(bool ok, String message) {
    if (!ok) {
      throw StateError(message);
    }
  }

  try {
    Directory.current = root;
    final file = File("ios/Runner.xcodeproj/project.pbxproj")
      ..createSync(recursive: true);
    for (final variant in [
      fixture,
      fixture.replaceFirst(reference, "$reference\n\t\t\t\t$reference"),
      fixture.replaceAll(reference, "")
    ]) {
      file.writeAsStringSync(variant);
      await const FirebaseMessagingCliAction()
          .synchronizeDevSdkCollectionBuildPhase(disableCollection: true);
      final once = file.readAsStringSync();
      check(reference.allMatches(phases(once)).length == 1,
          "Exactly one Runner reference");
      check(
          phases(once)
                  .replaceAll(reference, "")
                  .replaceAll(RegExp(r"\s+"), "") ==
              phases(variant)
                  .replaceAll(reference, "")
                  .replaceAll(RegExp(r"\s+"), ""),
          "Preserve other phases");
      if (variant == fixture) {
        check(phases(once) == phases(fixture),
            "Keep original reference position");
      }
      check(
          once.contains("FIREBASE_ANALYTICS_COLLECTION_ENABLED") &&
              once.contains(r'if [ \"$FLAVOR\" = \"dev\" ]'),
          "Dev-only collection guard");
      check(once.contains(r"$(TARGET_BUILD_DIR)/$(INFOPLIST_PATH)"),
          "Keep built plist input");
      await const FirebaseMessagingCliAction()
          .synchronizeDevSdkCollectionBuildPhase(disableCollection: true);
      check(file.readAsStringSync() == once, "Second sync is byte-idempotent");
    }
  } finally {
    Directory.current = original;
    root.deleteSync(recursive: true);
  }
  stdout.writeln(
      "Messaging phase position, duplicate normalization, insertion, dev guard, idempotence PASS");
}

// Mirrors the Runner ordering where Messaging precedes Copy Pods Resources.
const _runnerFixture = r'''
/* Begin PBXNativeTarget section */
ABC123 /* Runner */ = {
			isa = PBXNativeTarget;
			buildPhases = (
				AAA111 /* Check Pods Manifest.lock */,
				F17EBA5E0000000000000001 /* Select Katana Firebase Configuration */,
				AAA222 /* Run Script */,
				AAA333 /* Thin Binary */,
				F17EBA5E0000000000000002 /* Set Dev Firebase Messaging Auto-Init */,
				AAA444 /* [CP] Copy Pods Resources */,
			);
		};
/* End PBXNativeTarget section */
/* Begin PBXShellScriptBuildPhase section */
F17EBA5E0000000000000002 /* Set Dev Firebase Messaging Auto-Init */ = {
			isa = PBXShellScriptBuildPhase;
			inputPaths = ();
			outputPaths = ();
			shellScript = "old";
		};
/* End PBXShellScriptBuildPhase section */
''';
