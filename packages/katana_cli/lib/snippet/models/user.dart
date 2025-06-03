// Project imports:
import "package:katana_cli/katana_cli.dart";

/// User model template.
///
/// ユーザーモデルのテンプレート。
class ModelsUserCliCodeSnippet extends CliCodeSnippet {
  /// User model template.
  ///
  /// ユーザーモデルのテンプレート。
  const ModelsUserCliCodeSnippet();

  @override
  String get name => "ModelsUser";

  @override
  String get prefix => "@models/user";

  @override
  String get description => "Create a User model. ユーザーモデルを作成。";

  @override
  String body(String path, String baseName, String className) {
    return r"""
String? name,
String? description,
ModelImageUri? icon,
ModelToken? tokens,
@Default(ModelTimestamp.now()) ModelTimestamp createdAt,
@Default(ModelTimestamp.now()) ModelTimestamp updatedAt,
""";
  }
}
