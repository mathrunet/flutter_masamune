part of '/katana_auth.dart';

const _kAnonymouslyAuthProviderId = "anonymous";

/// {@template anonymously_auth}
/// An `AuthQuery` for anonymous authentication.
///
/// No email address, etc. will be created, only a user ID.
///
/// Basically, if you log out or reinstall the application, you cannot log in again.
///
/// 匿名認証を行うための`AuthQuery`。
///
/// メールアドレス等は作成されず、ユーザーIDのみが作成されます。
///
/// 基本的にログアウトしたりアプリを再インストールした場合、再ログインすることはできません。
/// {@endtemplate}
class AnonymouslyAuthQuery {
  const AnonymouslyAuthQuery._();

  /// {@macro sign_in_auth_provider}
  ///
  /// {@macro anonymously_auth}
  static AnonymouslySignInAuthProvider signIn() {
    return const AnonymouslySignInAuthProvider();
  }
}

/// {@macro sign_in_auth_provider}
///
/// {@macro anonymously_auth}
class AnonymouslySignInAuthProvider extends SignInAuthProvider {
  /// {@macro sign_in_auth_provider}
  ///
  /// {@macro anonymously_auth}
  const AnonymouslySignInAuthProvider();
  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kAnonymouslyAuthProviderId;
}
