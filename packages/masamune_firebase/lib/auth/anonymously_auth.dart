part of masamune_firebase;

/// Process sign-in.
/// Perform an anonymous login.
class AnonymouslyAuth {
  const AnonymouslyAuth._();

  /// Gets the options for the provider.
  static const AuthProviderOptions options = AuthProviderOptions(
    id: "anonymous",
    provider: _provider,
    title: "Anonymous SignIn",
    text: "Sign in as a guest.",
  );
  static Future<FirebaseAuthModel> _provider(
    BuildContext context,
    Duration timeout,
  ) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.signInAnonymously(timeout: timeout);
    return auth;
  }

  /// Process sign-in.
  /// Perform an anonymous login.
  ///
  /// If you specify [timeout], you can set the timeout period.
  static Future<FirebaseAuthModel> signIn({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.signInAnonymously(timeout: timeout);
    return auth;
  }
}
