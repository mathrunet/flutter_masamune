part of "test.dart";

/// Executing implementation debugging for Golden Tests (Golden Test image generation without Docker).
///
/// ゴールデンテストの実装デバッグ（Dockerを使わないゴールデンテスト画像生成）を実行します。
class TestDebugCliCommand extends CliCommand {
  /// Executing implementation debugging for Golden Tests (Golden Test image generation without Docker).
  ///
  /// ゴールデンテストの実装デバッグ（Dockerを使わないゴールデンテスト画像生成）を実行します。
  const TestDebugCliCommand();

  @override
  String get description =>
      "Executing implementation debugging for Golden Tests (Golden Test image generation without Docker). ゴールデンテストの実装デバッグ（Dockerを使わないゴールデンテスト画像生成）を実行します。";

  @override
  String? get example => "katana test update";

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
    await command(
      "Update the golden test images.",
      [
        flutter,
        "test",
        "--dart-define=CI=false",
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
