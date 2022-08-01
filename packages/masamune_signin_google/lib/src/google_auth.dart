part of masamune_signin_google;

/// Sign in to Firebase using Google OAuth.
class GoogleAuth {
  const GoogleAuth._();

  /// Gets the options for the provider.
  static const AuthProviderOptions options = AuthProviderOptions(
    id: "google.com",
    provider: _provider,
    title: "Google SignIn",
    text: "Sign in with your Google account.",
  );
  static Future<FirebaseAuthModel> _provider(
    BuildContext context,
    Duration timeout,
  ) {
    return signIn(timeout: timeout);
  }

  /// Sign in to Firebase using Google OAuth.
  ///
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<FirebaseAuthModel> signIn({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.signInWithProvider(
      providerCallback: (timeout) async {
        final google = GoogleSignIn();
        GoogleSignInAccount? googleCurrentUser = google.currentUser;
        googleCurrentUser ??= await google.signInSilently().timeout(timeout);
        googleCurrentUser ??= await google.signIn().timeout(timeout);
        if (googleCurrentUser == null) {
          throw Exception("Google user could not get.");
        }
        final googleAuth = await googleCurrentUser.authentication;
        return GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      },
      providerId: GoogleAuthProvider.PROVIDER_ID,
      timeout: timeout,
    );
    return auth;
  }

  /// Sign out from Firebase using Google OAuth.
  static Future<void> signOut() async {
    try {
      final auth = readProvider(firebaseAuthProvider);
      final google = GoogleSignIn();
      await auth.signOut();
      await google.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
