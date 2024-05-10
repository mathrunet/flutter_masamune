part of '/masamune_auth_facebook.dart';

const _kFacebookAuthProviderId = "facebook.com";

/// {@template facebook_auth}
/// An `AuthQuery` to authenticate with your Facebook account.
///
/// [signIn] and [reauth] are available.
///
/// [signOut] logs you out of your Facebook account rather than providing Provider.
///
/// Facebookアカウントでの認証を行うための`AuthQuery`。
///
/// [signIn]および[reauth]が利用可能です。
///
/// [signOut]はProviderを提供するのではなくFacebookアカウントからログアウトします。
/// {@endtemplate}
class FacebookAuthQuery {
  const FacebookAuthQuery._();

  /// ID that defines the provider's process.
  ///
  /// Basically, it is defined based on firebase's `PROVIDER_ID`.
  ///
  /// プロバイダーの処理を定義したID。
  ///
  /// 基本的にfirebaseの`PROVIDER_ID`をベースに定義されます。
  static const String providerId = _kFacebookAuthProviderId;

  /// [AuthProvider] for performing [Authentication.signIn].
  ///
  /// [Authentication.signIn]を実行するための[AuthProvider]。
  ///
  /// {@macro facebook_auth}
  static FacebookSignInAuthProvider signIn() {
    return const FacebookSignInAuthProvider();
  }

  /// [AuthProvider] for performing [Authentication.reauth].
  ///
  /// [Authentication.reauth]を実行するための[AuthProvider]。
  ///
  /// {@macro facebook_auth}
  static FacebookReAuthProvider reauth() {
    return const FacebookReAuthProvider();
  }

  /// Log out of your Facebook account.
  ///
  /// Facebookアカウントからログアウトします。
  ///
  /// {@macro facebook_auth}
  static Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
  }
}

/// An `AuthQuery` for Facebook's OAuth authentication.
///
/// FacebookのOAuth認証を行うための`AuthQuery`。
class FacebookSignInAuthProvider extends SnsSignInAuthProvider {
  /// An `AuthQuery` for Facebook's OAuth authentication.
  ///
  /// FacebookのOAuth認証を行うための`AuthQuery`。
  const FacebookSignInAuthProvider({super.allowMultiProvider = true});

  @override
  String get providerId => _kFacebookAuthProviderId;

  @override
  Future<Credential> credential() async {
    // final adapter = FacebookAuthMasamuneAdapter.primary;
    final result = await FacebookAuth.instance.login();
    switch (result.status) {
      case LoginStatus.cancelled:
        throw Exception("Login canceled");
      case LoginStatus.failed:
        throw Exception("Login terminated with error: ${result.message}");
      default:
        break;
    }
    if (result.accessToken == null || result.accessToken!.token.isEmpty) {
      throw Exception(
        "Login failed because the authentication information cannot be found.",
      );
    }
    return Credential(
      providerId: providerId,
      accessToken: result.accessToken!.token,
    );
  }
}

/// An `AuthQuery` for Facebook OAuth re-authentication.
///
/// FacebookのOAuth再認証を行うための`AuthQuery`。
class FacebookReAuthProvider extends SnsReAuthProvider {
  /// An `AuthQuery` for Facebook OAuth re-authentication.
  ///
  /// FacebookのOAuth再認証を行うための`AuthQuery`。
  const FacebookReAuthProvider();

  static const _signInProvider = FacebookSignInAuthProvider();

  @override
  String get providerId => _signInProvider.providerId;

  @override
  Future<Credential> credential() => _signInProvider.credential();
}
