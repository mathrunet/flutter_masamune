part of masamune_signin_apple;

class AppleSignInAdapter extends SignInAdapter {
  const AppleSignInAdapter({
    this.clientId,
    this.redirectUri,
    bool visible = true,
  }) : _visible = visible;

  final String? clientId;
  final String? redirectUri;

  @override
  String get provider => AppleAuth.options.id;

  /// If `true`, display.
  @override
  bool get visible {
    if (!_visible) {
      return false;
    }
    return Config.isIOS || (clientId.isNotEmpty && redirectUri.isNotEmpty);
  }

  final bool _visible;

  @override
  Future<void> signIn() {
    if (!Config.isIOS) {
      assert(
        clientId.isNotEmpty && redirectUri.isNotEmpty,
        "For non-IOS use, [clientId] and [redirectUri] need to be specified.",
      );
      AppleAuth.initialize(
        clientId: clientId!,
        redirectUri: redirectUri!,
      );
    }
    return AppleAuth.signIn();
  }

  @override
  Future<void> signOut() {
    if (!Config.isIOS) {
      assert(
        clientId.isNotEmpty && redirectUri.isNotEmpty,
        "For non-IOS use, [clientId] and [redirectUri] need to be specified.",
      );
      AppleAuth.initialize(
        clientId: clientId!,
        redirectUri: redirectUri!,
      );
    }
    return AppleAuth.signOut();
  }

  /// Run it the first time the app is launched.
  @override
  @mustCallSuper
  Future<void> onInit(BuildContext context) async {
    super.onInit(context);
    if (!Config.isIOS && clientId.isNotEmpty && redirectUri.isNotEmpty) {
      AppleAuth.initialize(
        clientId: clientId!,
        redirectUri: redirectUri!,
      );
    }
  }
}
