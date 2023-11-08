part of '/masamune_auth_apple.dart';

/// An `AuthQuery` for Apple's OAuth authentication.
///
/// AppleのOAuth認証を行うための`AuthQuery`。
class AppleSignInAuthProvider extends SnsSignInAuthProvider {
  /// An `AuthQuery` for Apple's OAuth authentication.
  ///
  /// AppleのOAuth認証を行うための`AuthQuery`。
  const AppleSignInAuthProvider();

  @override
  String get providerId => "apple.com";

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
