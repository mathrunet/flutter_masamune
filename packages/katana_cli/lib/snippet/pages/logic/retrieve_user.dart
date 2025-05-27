// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Page logic for obtaining a user ID.
///
/// ユーザーIDを取得するためのページロジック。
class PagesLogicRetrieveUserCliCodeSnippet extends CliCodeSnippet {
  /// Page logic for obtaining a user ID.
  ///
  /// ユーザーIDを取得するためのページロジック。
  const PagesLogicRetrieveUserCliCodeSnippet();

  @override
  String get name => "PagesLogicRetrieveUser";

  @override
  String get prefix => "@pages/logic/retrieve_user";

  @override
  String get description =>
      "Page logic for obtaining a user ID. ユーザーIDを取得するためのページロジック。";

  @override
  String body(String path, String baseName, String className) {
    return """final userId = appAuth.userId;
if (userId == null) {
  return const Empty();
}
final user = ref.app.model(UserModel.document(userId))..load();
""";
  }
}
