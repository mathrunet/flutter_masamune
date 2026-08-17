// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/firebase/init.dart";

Future<void> main() async {
  const indexCode = FirebaseFunctionsIndexCliCode();
  final indexImports = indexCode.import("index.ts", "index", "Index");
  _expect(
    !indexImports.contains("firebase-admin"),
    "The generated index must delegate Firebase initialization to "
    "masamune_firebase.",
  );
  _expect(
    !indexImports.contains("initializeApp"),
    "The generated index must not initialize Firebase Admin directly.",
  );
  _expect(
    indexCode.body("index.ts", "index", "Index").contains("mf.deploy("),
    "The generated index must keep deployment registration through mf.deploy.",
  );

  final temporary = await Directory.systemTemp.createTemp(
    "katana_firebase_functions_init_",
  );
  try {
    final functionsDirectory = Directory("${temporary.path}/functions");
    await functionsDirectory.create();

    final initialPlan = FirebaseFunctionsToolingPlan.create(
      functionsDirectory: functionsDirectory,
    );
    _expect(
      initialPlan.initializeJest,
      "A missing Jest configuration must be initialized.",
    );
    final executableSuffix = Platform.isWindows ? ".cmd" : "";
    _expectEqual(
      initialPlan.initializeJestCommand,
      ["node_modules/.bin/ts-jest$executableSuffix", "config:init"],
      "Jest initialization must use the locally installed ts-jest.",
    );
    _expectEqual(
      initialPlan.fixLintCommand,
      [
        "node_modules/.bin/eslint$executableSuffix",
        "--ext",
        ".js,.ts",
        "--fix",
        ".",
      ],
      "Lint fixes must use the locally installed ESLint.",
    );
    await _writeFixtureExecutable(functionsDirectory, "ts-jest");
    await _writeFixtureExecutable(functionsDirectory, "eslint");
    await _expectLocalCommandRuns(
      initialPlan.initializeJestCommand,
      functionsDirectory,
      "ts-jest",
    );
    await _expectLocalCommandRuns(
      initialPlan.fixLintCommand,
      functionsDirectory,
      "eslint",
    );

    final existingConfig = File("${functionsDirectory.path}/jest.config.js");
    const existingContents = "module.exports = {preset: 'custom'};\n";
    await existingConfig.writeAsString(existingContents);
    final repeatedPlan = FirebaseFunctionsToolingPlan.create(
      functionsDirectory: functionsDirectory,
    );
    _expect(
      !repeatedPlan.initializeJest,
      "An existing Jest configuration must not be regenerated.",
    );
    _expectEqual(
      await existingConfig.readAsString(),
      existingContents,
      "Planning a repeated apply must preserve the Jest configuration.",
    );
  } finally {
    await temporary.delete(recursive: true);
  }
  stdout.writeln("All Firebase Functions initialization checks passed.");
}

Future<void> _writeFixtureExecutable(
  Directory functionsDirectory,
  String name,
) async {
  final binDirectory =
      Directory("${functionsDirectory.path}/node_modules/.bin");
  await binDirectory.create(recursive: true);
  final suffix = Platform.isWindows ? ".cmd" : "";
  final executable = File("${binDirectory.path}/$name$suffix");
  await executable.writeAsString(
    Platform.isWindows
        ? "@echo off\r\ntype nul > $name.called\r\n"
        : "#!/bin/sh\n: > $name.called\n",
  );
  if (!Platform.isWindows) {
    final result = await Process.run("chmod", ["+x", executable.path]);
    _expect(result.exitCode == 0, "Failed to prepare the $name fixture.");
  }
}

Future<void> _expectLocalCommandRuns(
  List<String> command,
  Directory functionsDirectory,
  String name,
) async {
  final result = await Process.run(
    command.first,
    command.sublist(1),
    workingDirectory: functionsDirectory.path,
    runInShell: true,
  );
  _expect(
    result.exitCode == 0,
    "The local $name command failed: ${result.stderr}",
  );
  _expect(
    File("${functionsDirectory.path}/$name.called").existsSync(),
    "The local $name executable was not selected.",
  );
}

void _expect(bool value, String message) {
  if (!value) {
    throw StateError(message);
  }
}

void _expectEqual(Object? actual, Object? expected, String message) {
  if (actual is List<Object?> && expected is List<Object?>) {
    if (actual.length == expected.length) {
      for (var i = 0; i < actual.length; i++) {
        if (actual[i] != expected[i]) {
          throw StateError("$message Expected $expected, got $actual.");
        }
      }
      return;
    }
  } else if (actual == expected) {
    return;
  }
  throw StateError("$message Expected $expected, got $actual.");
}
