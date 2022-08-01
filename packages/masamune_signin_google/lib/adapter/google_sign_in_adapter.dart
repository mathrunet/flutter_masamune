part of masamune_signin_google;

class GoogleSignInAdapter extends SignInAdapter {
  const GoogleSignInAdapter({
    this.visible = true,
  });

  @override
  String get provider => GoogleAuth.options.id;

  /// If `true`, display.
  @override
  final bool visible;

  @override
  Future<void> signIn() {
    return GoogleAuth.signIn();
  }

  @override
  Future<void> signOut() {
    return GoogleAuth.signOut();
  }
}
