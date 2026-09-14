// Dart imports:
import "dart:io";

Future<void> main() async {
  final packageRoot = File.fromUri(Platform.script).parent.parent;
  final cli = File("${packageRoot.path}/bin/katana.dart");

  await _verifyHelpHasNoSideEffects(cli, "--help");
  await _verifyHelpHasNoSideEffects(cli, "-h");
  await _verifyUnknownArgumentHasNoSideEffects(cli);

  stdout.writeln("All apply help regression checks passed.");
}

Future<void> _verifyHelpHasNoSideEffects(File cli, String helpFlag) async {
  final fixture = await _createFixture();
  try {
    final before = await _snapshot(fixture.root);
    final result = await _runCli(cli, fixture.root, ["apply", helpFlag]);
    final after = await _snapshot(fixture.root);

    _expectEqual(result.exitCode, 0, "$helpFlag exits successfully");
    _expect(
      result.stdout.toString().contains("Usage: katana apply"),
      "$helpFlag displays apply usage",
    );
    _expectEqual(
      after.toString(),
      before.toString(),
      "$helpFlag does not generate or update files",
    );
    _expect(
      !fixture.externalCommandMarker.existsSync(),
      "$helpFlag does not execute configured external commands",
    );
  } finally {
    await fixture.root.delete(recursive: true);
  }
}

Future<void> _verifyUnknownArgumentHasNoSideEffects(File cli) async {
  final fixture = await _createFixture();
  try {
    final before = await _snapshot(fixture.root);
    final result = await _runCli(
      cli,
      fixture.root,
      ["apply", "--unknown-option"],
    );
    final after = await _snapshot(fixture.root);

    _expect(result.exitCode != 0, "an unknown apply option fails");
    _expect(
      result.stderr.toString().contains("Unknown argument"),
      "an unknown apply option reports the invalid argument",
    );
    _expectEqual(
      after.toString(),
      before.toString(),
      "an unknown apply option does not generate or update files",
    );
    _expect(
      !fixture.externalCommandMarker.existsSync(),
      "an unknown apply option does not execute configured external commands",
    );
  } finally {
    await fixture.root.delete(recursive: true);
  }
}

Future<_Fixture> _createFixture() async {
  final root = await Directory.systemTemp.createTemp("katana_apply_help_");
  final externalCommandMarker = File("${root.path}/external-command-called");
  final fakeWrangler = File("${root.path}/fake-wrangler.sh");
  await fakeWrangler.writeAsString("""
#!/bin/sh
touch "${externalCommandMarker.path}"
exit 1
""");
  final chmod = await Process.run("chmod", ["+x", fakeWrangler.path]);
  _expectEqual(chmod.exitCode, 0, "the fake external command is executable");
  await File("${root.path}/pubspec.yaml").writeAsString("name: fixture\n");
  await File("${root.path}/katana.yaml").writeAsString("""
bin:
  wrangler: ${fakeWrangler.path}
cloudflare:
  project_id: fixture
  workers:
    enable: true
""");
  return _Fixture(
    root: root,
    externalCommandMarker: externalCommandMarker,
  );
}

Future<ProcessResult> _runCli(
  File cli,
  Directory workingDirectory,
  List<String> arguments,
) {
  return Process.run(
    Platform.resolvedExecutable,
    [cli.path, ...arguments],
    workingDirectory: workingDirectory.path,
  );
}

Future<Map<String, String>> _snapshot(Directory root) async {
  final snapshot = <String, String>{};
  await for (final entity in root.list(recursive: true, followLinks: false)) {
    final relativePath = entity.path.substring(root.path.length + 1);
    if (entity is File) {
      snapshot[relativePath] = await entity.readAsString();
    } else if (entity is Directory) {
      snapshot["$relativePath/"] = "";
    }
  }
  return Map.fromEntries(
    snapshot.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

void _expectEqual(Object? actual, Object? expected, String message) {
  if (actual != expected) {
    throw StateError("$message: expected <$expected>, actual <$actual>");
  }
}

class _Fixture {
  const _Fixture({
    required this.root,
    required this.externalCommandMarker,
  });

  final Directory root;
  final File externalCommandMarker;
}
