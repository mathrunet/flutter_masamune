part of masamune_firebase;

class AnonymousSignInAdapter extends SignInAdapter {
  const AnonymousSignInAdapter({
    this.visible = true,
  });

  @override
  String get provider => "anonymous";

  /// If `true`, display.
  @override
  final bool visible;

  @override
  Future<void> signIn() {
    return AnonymousAuth.signIn();
  }

  @override
  Future<void> signOut() {
    return AnonymousAuth.signOut();
  }
}
