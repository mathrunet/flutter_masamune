part of '/katana_auth.dart';

const _kDirectAuthProviderId = "direct";

/// {@template direct_auth}
/// An `AuthQuery` for debugging authentication.
///
/// You will be logged in by specifying your user ID directly.
///
/// デバッグ認証を行うための`AuthQuery`。
///
/// ユーザーIDを直接指定してログインされます。
/// {@endtemplate}
class DirectAuthQuery {
  const DirectAuthQuery._();

  /// ID that defines the provider's process.
  ///
  /// Basically, it is defined based on firebase's `PROVIDER_ID`.
  ///
  /// プロバイダーの処理を定義したID。
  ///
  /// 基本的にfirebaseの`PROVIDER_ID`をベースに定義されます。
  static const String providerId = _kDirectAuthProviderId;

  /// {@macro sign_in_auth_provider}
  ///
  /// {@macro direct_auth}
  static DirectSignInAuthProvider signIn({
    required String userId,
  }) {
    return DirectSignInAuthProvider(userId: userId);
  }
}

/// {@macro sign_in_auth_provider}
///
/// {@macro direct_auth}
class DirectSignInAuthProvider extends SignInAuthProvider {
  /// {@macro sign_in_auth_provider}
  ///
  /// {@macro direct_auth}
  const DirectSignInAuthProvider({
    required this.userId,
  });

  /// User ID to be specified.
  ///
  /// 指定するユーザーID。
  final String userId;

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kDirectAuthProviderId;
}
