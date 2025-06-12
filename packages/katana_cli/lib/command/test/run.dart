part of "test.dart";

/// This command will run the golden test images.
///
/// ゴールデンテストを実行します。
class TestRunCliCommand extends CliCommand {
  /// This command will run the golden test images.
  ///
  /// ゴールデンテストを実行します。
  const TestRunCliCommand();

  @override
  String get description => "Run the golden test images. ゴールデンテストを実行します。";

  @override
  String? get example => "katana test run";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final target = context.args.get(2, "");
    final xvfb = File(".xvfb");
    await command(
      "Run the golden test images.",
      [
        if (xvfb.existsSync()) ...[
          "xvfb-run",
          "-a",
        ],
        flutter,
        "test",
        "--dart-define=CI=true",
        "--dart-define=FLAVOR=dev",
        if (target.isNotEmpty) ...[
          "--plain-name",
          target,
        ]
      ],
    );
  }
}
