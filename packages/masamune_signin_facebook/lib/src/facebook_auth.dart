part of masamune_signin_facebook;

/// Sign in to Firebase using Facebook Login.
class FacebookAuth {
  const FacebookAuth._();

  /// Gets the options for the provider.
  static const AuthProviderOptions options = AuthProviderOptions(
    id: "facebook.com",
    provider: _provider,
    title: "Facebook SignIn",
    text: "Sign in with your Facebook account.",
  );
  static Future<FirebaseAuthModel> _provider(
    BuildContext context,
    Duration timeout,
  ) {
    return signIn(timeout: timeout);
  }

  /// Sign in to Firebase using Facebook Login.
  ///
  /// [timeout]: Timeout time.
  static Future<FirebaseAuthModel> signIn({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.signInWithProvider(
      providerCallback: (timeout) async {
        final result = await fb.FacebookAuth.instance.login();
        switch (result.status) {
          case fb.LoginStatus.cancelled:
            throw Exception("Login canceled");
          case fb.LoginStatus.failed:
            throw Exception("Login terminated with error: ${result.message}");
          default:
            break;
        }
        if (result.accessToken == null || result.accessToken!.token.isEmpty) {
          throw Exception("Login terminated with error: Token is empty.");
        }
        return FacebookAuthProvider.credential(result.accessToken!.token);
      },
      providerId: FacebookAuthProvider.PROVIDER_ID,
      timeout: timeout,
    );
    return auth;
  }

  /// Sign out from Firebase using Facebook Login.
  static Future<void> signOut() async {
    try {
      final auth = readProvider(firebaseAuthProvider);
      await auth.signOut();
      await fb.FacebookAuth.instance.logOut();
    } catch (e) {
      rethrow;
    }
  }
}
