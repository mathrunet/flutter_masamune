import "dart:io";

import "package:katana_cli/src/framework.dart";

Future<void> main() async {
  final previous = Directory.current;
  final fixture = Directory.systemTemp.createTempSync("katana-flutter-import-");
  try {
    Directory.current = fixture;
    final commandFile = File("flutter-args.txt");
    final flutter = File("fake-flutter.sh");
    flutter.writeAsStringSync(
      "#!/bin/sh\n"
      "printf '%s\\n' \"\$@\" > \"${commandFile.absolute.path}\"\n",
    );
    final chmod = Process.runSync("chmod", ["+x", flutter.path]);
    if (chmod.exitCode != 0) {
      throw StateError("Could not prepare fixture.");
    }

    File("pubspec.yaml").writeAsStringSync("""
name: fixture
dependencies:
  masamune_model_turso: ^3.3.0
  katana: ^3.4.1
""");
    await addFlutterImport(
      ["masamune_model_turso:^3.9.0"],
      flutterCommand: flutter.absolute.path,
    );
    _expect(
      commandFile.readAsLinesSync().join(" ") ==
          "pub add masamune_model_turso:^3.9.0",
      "An explicit constraint must update an existing dependency.",
    );

    commandFile.deleteSync();
    File("pubspec.yaml").writeAsStringSync("""
name: fixture
dependencies:
  masamune_model_turso: ^3.9.0
  katana: ^3.4.1
""");
    await addFlutterImport(
      ["masamune_model_turso:^3.9.0", "katana"],
      flutterCommand: flutter.absolute.path,
    );
    _expect(!commandFile.existsSync(),
        "Matching and unversioned dependencies must stay untouched.");
  } finally {
    Directory.current = previous;
    fixture.deleteSync(recursive: true);
  }
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}
