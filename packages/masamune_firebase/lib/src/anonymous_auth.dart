part of masamune_firebase;

/// Sign in to Firebase using Anonymous SignIn.
class AnonymousAuth {
  const AnonymousAuth._();

  /// Sign in to Firebase using Anonymous SignIn.
  ///
  /// [timeout]: Timeout time.
  static Future<FirebaseAuthModel> signIn({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    // try {
    final auth = readProvider(firebaseAuthProvider);
    await auth.signInAnonymously();
    return auth;
    // } catch (e) {
    //   rethrow;
    // }
  }

  /// Sign out from Firebase using Anonymous SignIn.
  static Future<void> signOut() async {
    try {
      final auth = readProvider(firebaseAuthProvider);
      await auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
