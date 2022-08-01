part of masamune_signin_apple;

class AppleSignInAdapter extends SignInAdapter {
  const AppleSignInAdapter({
    this.clientId,
    this.redirectUri,
    this.onlyIOS = true,
    this.visible = true,
  });

  final String? clientId;
  final String? redirectUri;
  final bool onlyIOS;

  @override
  String get provider => AppleAuth.options.id;

  /// If `true`, display.
  @override
  final bool visible;

  @override
  Future<void> signIn() {
    if (!onlyIOS) {
      assert(
        clientId.isNotEmpty && redirectUri.isNotEmpty,
        "For non-IOS use, [clientId] and [redirectUri] need to be specified.",
      );
      AppleAuth.initialize(
        clientId: clientId!,
        redirectUri: redirectUri!,
        onlyIOS: false,
      );
    }
    return AppleAuth.signIn();
  }

  @override
  Future<void> signOut() {
    if (!onlyIOS) {
      assert(
        clientId.isNotEmpty && redirectUri.isNotEmpty,
        "For non-IOS use, [clientId] and [redirectUri] need to be specified.",
      );
      AppleAuth.initialize(
        clientId: clientId!,
        redirectUri: redirectUri!,
        onlyIOS: false,
      );
    }
    return AppleAuth.signOut();
  }

  /// Run it the first time the app is launched.
  @override
  @mustCallSuper
  Future<void> onInit(BuildContext context) async {
    super.onInit(context);
    if (!onlyIOS) {
      assert(
        clientId.isNotEmpty && redirectUri.isNotEmpty,
        "For non-IOS use, [clientId] and [redirectUri] need to be specified.",
      );
      AppleAuth.initialize(
        clientId: clientId!,
        redirectUri: redirectUri!,
        onlyIOS: false,
      );
    }
  }
}
