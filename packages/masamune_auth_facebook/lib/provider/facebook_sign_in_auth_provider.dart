part of masamune_auth_facebook;

/// An `AuthQuery` for Facebook's OAuth authentication.
///
/// FacebookのOAuth認証を行うための`AuthQuery`。
class FacebookSignInAuthProvider extends SnsSignInAuthProvider {
  /// An `AuthQuery` for Facebook's OAuth authentication.
  ///
  /// FacebookのOAuth認証を行うための`AuthQuery`。
  const FacebookSignInAuthProvider();

  @override
  String get providerId => "facebook.com";

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
