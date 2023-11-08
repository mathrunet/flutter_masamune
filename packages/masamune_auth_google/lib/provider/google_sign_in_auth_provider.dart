part of '/masamune_auth_google.dart';

/// An `AuthQuery` for Google's OAuth authentication.
///
/// GoogleのOAuth認証を行うための`AuthQuery`。
class GoogleSignInAuthProvider extends SnsSignInAuthProvider {
  /// An `AuthQuery` for Google's OAuth authentication.
  ///
  /// GoogleのOAuth認証を行うための`AuthQuery`。
  const GoogleSignInAuthProvider();

  @override
  String get providerId => "google.com";

  @override
  Future<Credential> credential() async {
    // final adapter = GoogleAuthMasamuneAdapter.primary;
    final google = GoogleSignIn();
    var googleCurrentUser = google.currentUser;
    googleCurrentUser ??= await google.signInSilently();
    googleCurrentUser ??= await google.signIn();
    if (googleCurrentUser == null) {
      throw Exception(
        "Login failed because the authentication information cannot be found.",
      );
    }
    final credentials = await googleCurrentUser.authentication;
    return Credential(
      providerId: providerId,
      idToken: credentials.idToken,
      accessToken: credentials.accessToken,
    );
  }
}
