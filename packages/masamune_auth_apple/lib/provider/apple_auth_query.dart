part of '/masamune_auth_apple.dart';

const _kAppleAuthProviderId = "apple.com";

/// {@template apple_auth}
/// An `AuthQuery` to authenticate with your Apple account.
///
/// [signIn] and [reauth] are available.
///
/// Appleアカウントでの認証を行うための`AuthQuery`。
///
/// [signIn]および[reauth]が利用可能です。
/// {@endtemplate}
class AppleAuthQuery {
  const AppleAuthQuery._();

  /// ID that defines the provider's process.
  ///
  /// Basically, it is defined based on firebase's `PROVIDER_ID`.
  ///
  /// プロバイダーの処理を定義したID。
  ///
  /// 基本的にfirebaseの`PROVIDER_ID`をベースに定義されます。
  static const String providerId = _kAppleAuthProviderId;

  /// [AuthProvider] for performing [Authentication.signIn].
  ///
  /// [Authentication.signIn]を実行するための[AuthProvider]。
  ///
  /// {@macro apple_auth}
  static AppleSignInAuthProvider signIn() {
    return const AppleSignInAuthProvider();
  }

  /// [AuthProvider] for performing [Authentication.reauth].
  ///
  /// [Authentication.reauth]を実行するための[AuthProvider]。
  ///
  /// {@macro apple_auth}
  static AppleReAuthProvider reauth() {
    return const AppleReAuthProvider();
  }
}

/// An `AuthQuery` for Apple's OAuth authentication.
///
/// AppleのOAuth認証を行うための`AuthQuery`。
class AppleSignInAuthProvider extends SnsSignInAuthProvider {
  /// An `AuthQuery` for Apple's OAuth authentication.
  ///
  /// AppleのOAuth認証を行うための`AuthQuery`。
  const AppleSignInAuthProvider();

  @override
  String get providerId => _kAppleAuthProviderId;

  @override
  Future<Credential> credential() async {
    // final adapter = AppleAuthMasamuneAdapter.primary;
    final credentials = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (credentials.identityToken.isEmpty ||
        credentials.authorizationCode.isEmpty) {
      throw Exception(
        "Login failed because the authentication information cannot be found.",
      );
    }
    return Credential(
      providerId: providerId,
      idToken: credentials.identityToken,
      accessToken: credentials.authorizationCode,
    );
  }
}

/// An `AuthQuery` for Apple's OAuth re-authentication.
///
/// AppleのOAuth再認証を行うための`AuthQuery`。
class AppleReAuthProvider extends SnsReAuthProvider {
  /// An `AuthQuery` for Apple's OAuth re-authentication.
  ///
  /// AppleのOAuth再認証を行うための`AuthQuery`。
  const AppleReAuthProvider();

  static const _signInProvider = AppleSignInAuthProvider();

  @override
  String get providerId => _signInProvider.providerId;

  @override
  Future<Credential> credential() => _signInProvider.credential();
}
