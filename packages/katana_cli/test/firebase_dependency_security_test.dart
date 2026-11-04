import "dart:convert";
import "dart:io";

import "package:katana_cli/katana_cli.dart";

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

Future<List<String>> _apply({
  String? declaration,
  String? lockedVersion,
  String? override,
  String resolvedVersion = "7.1.0",
  int exitCode = 0,
  bool rejects = false,
  bool local = false,
}) async {
  final previous = Directory.current;
  final temporaryRoot = Directory(".tmp")..createSync(recursive: true);
  final temporary =
      temporaryRoot.createTempSync("firestore-security-").absolute;
  try {
    Directory.current = temporary;
    final pubspec = "name: fixture\ndependencies:\n"
        "  other_package: ^1.0.0\n"
        "${declaration == null ? "" : "  cloud_firestore: $declaration\n"}";
    File("pubspec.yaml").writeAsStringSync(pubspec);
    if (lockedVersion != null) {
      File("pubspec.lock").writeAsStringSync(
        "packages:\n  cloud_firestore:\n    version: '$lockedVersion'\n",
      );
    }
    if (override != null) {
      File("pubspec_overrides.yaml").writeAsStringSync(
        "dependency_overrides:\n  cloud_firestore: $override\n",
      );
    }
    if (local) {
      Directory(".dart_tool").createSync();
      File(".dart_tool/package_config.json").writeAsStringSync(jsonEncode({
        "configVersion": 2,
        "packages": [
          {"name": "cloud_firestore", "rootUri": "../"}
        ],
      }));
    }
    final flutter = File("flutter-fixture").absolute;
    flutter.writeAsStringSync(
      '#!/bin/sh\nprintf \'%s\\n\' "\$@" >> calls.log\n'
      "printf 'packages:\\n  cloud_firestore:\\n    version: \"$resolvedVersion\"\\n' > pubspec.lock\n"
      "exit $exitCode\n",
    );
    final chmod = await Process.run("chmod", ["+x", flutter.path]);
    _check(chmod.exitCode == 0, "Fixture executable could not be prepared");
    var rejected = false;
    try {
      if (local) {
        await runApplyCommands(
          () => addFlutterImport(
            ["cloud_firestore"],
            flutterCommand: flutter.path,
          ),
          local: true,
        );
      } else {
        await addFlutterImport(
          ["cloud_firestore"],
          flutterCommand: flutter.path,
        );
      }
    } on StateError {
      rejected = true;
    } on Exception {
      rejected = true;
    }
    _check(rejected == rejects, "Unexpected security validation result");
    if ((declaration?.startsWith("{") ?? false) || override != null) {
      _check(File("pubspec.yaml").readAsStringSync() == pubspec,
          "A custom dependency was overwritten");
    }
    if (local) {
      _check(File("pubspec.yaml").readAsStringSync() == pubspec,
          "Local apply changed the dependency declaration");
    }
    final log = File("calls.log");
    return log.existsSync() ? log.readAsLinesSync() : [];
  } finally {
    Directory.current = previous;
    temporary.deleteSync(recursive: true);
  }
}

Future<void> main() async {
  final old = await _apply(declaration: "^6.0.3", lockedVersion: "6.8.0");
  _check(old.any((argument) => argument.contains("7.1.0")),
      "An existing vulnerable Firestore dependency was left unchanged");

  final fresh = await _apply();
  _check(fresh.any((argument) => argument.contains("7.1.0")),
      "A fresh dependency did not receive the security minimum");

  final legacySix =
      await _apply(declaration: "^6.10.9", lockedVersion: "6.10.9");
  _check(legacySix.any((argument) => argument.contains("7.1.0")),
      "A 6.x dependency was not moved to the supported 7.1.0+ range");
  _check((await _apply(declaration: "^7.1.2", lockedVersion: "7.1.2")).isEmpty,
      "A patched 7.x dependency was downgraded");

  final unsafeSeven = await _apply(
    declaration: "^7.0.0",
    lockedVersion: "7.0.0",
    resolvedVersion: "7.1.0",
  );
  _check(unsafeSeven.any((argument) => argument.contains("7.1.0")),
      "An affected 7.0 dependency did not receive its patched minimum");

  final stale = await _apply(declaration: "^7.1.0", lockedVersion: "7.0.0");
  _check(stale.contains("upgrade") && stale.contains("cloud_firestore"),
      "A stale lockfile was not updated");

  _check(
      (await _apply(
        declaration: "{path: ../custom_firestore}",
        lockedVersion: "7.1.0",
      ))
          .isEmpty,
      "A patched path dependency was overwritten");
  await _apply(
    declaration: "{git: 'https://example.com/custom_firestore.git'}",
    lockedVersion: "6.8.0",
    rejects: true,
  );
  _check(
      (await _apply(
        declaration: "^7.1.0",
        lockedVersion: "7.1.0",
        local: true,
      ))
          .isEmpty,
      "Local apply invoked a dependency command");
  _check(
      (await _apply(
        declaration: "^6.0.3",
        lockedVersion: "6.8.0",
        local: true,
        rejects: true,
      ))
          .isEmpty,
      "Local apply attempted to update an affected dependency");
  await _apply(
    declaration: "^6.0.3",
    lockedVersion: "6.8.0",
    override: "6.8.0",
    rejects: true,
  );
  await _apply(
    declaration: "^6.0.3",
    lockedVersion: "7.1.0",
    exitCode: 42,
    rejects: true,
  );
  _check(
      (await _apply(
        declaration: "^6.0.3",
        lockedVersion: "7.1.0",
        override: "{path: ../patched_firestore}",
      ))
          .isEmpty,
      "A patched override was changed");
  await _apply(
    declaration: "^6.0.3",
    lockedVersion: "6.8.0",
    resolvedVersion: "6.8.0",
    rejects: true,
  );
  stdout.writeln("Firestore dependency security regression checks passed");
}
