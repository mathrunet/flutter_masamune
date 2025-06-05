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
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final target = context.args.get(2, "");
    await command(
      "Update the golden test images.",
      [
        flutter,
        "test",
        "--update-goldens",
        if (target.isNotEmpty) ...[
          "--plain-name",
          "\"$target\"",
        ]
      ],
    );
  }
}
