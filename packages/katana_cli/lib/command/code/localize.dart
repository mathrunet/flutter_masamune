part of "code.dart";

/// Creating base data for translation.
///
/// 翻訳のベースデータを作成します。
class CodeLocalizeCliCommand extends CliCommand {
  /// Creating base data for translation.
  ///
  /// 翻訳のベースデータを作成します。
  const CodeLocalizeCliCommand();

  @override
  String get description =>
      "Creating base data for translation. 翻訳のベースデータを作成します。";

  @override
  String? get example => "katana code localize";

  @override
  Future<void> exec(ExecContext context) async {
    label("Generate localize.base.yaml");
    await const LocalizeYamlCliCode().generateFile("localize.base.yaml");
    if (!File("localize.app.yaml").existsSync()) {
      label("Generate localize.app.yaml");
      await const LocalizeYamlCliCode().generateFile("localize.app.yaml");
    }
  }
}
