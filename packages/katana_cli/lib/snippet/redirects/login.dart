// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Login page template.
///
/// ログインページのテンプレート。
class RedirectsLoginCliCodeSnippet extends CliCodeSnippet {
  /// Login page template.
  ///
  /// ログインページのテンプレート。
  const RedirectsLoginCliCodeSnippet();

  @override
  String get name => "RedirectsLogin";

  @override
  String get prefix => "@redirects/login";

  @override
  String get description =>
      "Create a RedirectQuery for login. ログイン用のRedirectQueryを作成。";

  @override
  String body(String path, String baseName, String className) {
    return r"""
// Handle the case where the user data does not exist.
Future<RouteQuery> handleUserDataIsEmpty(UserModelDocument user) async {
  ${1}
  return source;
}

var userId = appAuth.userId;
if (userId != null) {
  final user = appRef.model(UserModel.document(userId));
  await user.load();
  if (user.value == null) {
    return await handleUserDataIsEmpty(user);
  }
  return source;
}
await appAuth.tryRestoreAuth();
userId = appAuth.userId;
if (userId != null) {
  final user = appRef.model(UserModel.document(userId));
  await user.load();
  if (user.value == null) {
    return await handleUserDataIsEmpty(user);
  }
  return source;
}
return LoginPage.query();
""";
  }
}
