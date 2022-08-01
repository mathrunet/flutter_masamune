part of masamune_signin_facebook;

class FacebookSignInAdapter extends SignInAdapter {
  const FacebookSignInAdapter({this.visible = true});

  @override
  String get provider => FacebookAuth.options.id;

  /// If `true`, display.
  @override
  final bool visible;

  @override
  Future<void> signIn() {
    return FacebookAuth.signIn();
  }

  @override
  Future<void> signOut() {
    return FacebookAuth.signOut();
  }
}
