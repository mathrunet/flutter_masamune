part of "test.dart";

/// This command will update the golden test images.
///
/// ゴールデンテストの画像更新を行います。
class TestUpdateCliCommand extends CliCommand {
  /// This command will update the golden test images.
  ///
  /// ゴールデンテストの画像更新を行います。
  const TestUpdateCliCommand();

  @override
  String get description =>
      "Update the golden test images. ゴールデンテストの画像更新を行います。";

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
        "--update-goldens",
        "--dart-define=CI=false",
        "--dart-define-from-file=dart_defines/dev.env",
        if (target.isNotEmpty) ...[
          "--plain-name",
          target,
        ]
      ],
      catchError: true,
      failOnStderr: false,
    );
  }
}
