part of "code.dart";

/// Create UI debug images for AI.
///
/// AI用のUIデバッグ画像を作成します。
class CodeDebugCliCommand extends CliCommand {
  /// Create UI debug images for AI.
  ///
  /// AI用のUIデバッグ画像を作成します。
  const CodeDebugCliCommand();

  @override
  String get description =>
      "Create UI debug images for AI. AI用のUIデバッグ画像を作成します。";

  @override
  String? get example => "katana code debug";

  @override
  Future<void> exec(ExecContext context) async {
    if (!Directory("${Directory.current.path}/test").existsSync()) {
      // ignore: avoid_print
      print("Skipping because the test directory was not found.");
      return;
    }
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final target = context.args.get(2, "");
    if (target.isEmpty) {
      error("Target is required. e.g. `katana code debug [target]`");
      return;
    }
    await command(
      "Update the golden test images.",
      [
        flutter,
        "test",
        "--update-goldens",
        "--dart-define=CI=false",
        "--dart-define=TESTDIR=documents/debug",
        "--dart-define-from-file=dart_defines/dev.env",
        if (target.isNotEmpty) ...[
          "--plain-name",
          target,
        ]
      ],
      catchError: true,
    );
  }
}
