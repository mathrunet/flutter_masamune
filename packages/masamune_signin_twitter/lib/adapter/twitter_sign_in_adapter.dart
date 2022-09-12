part of masamune_signin_twitter;

class TwitterSignInAdapter extends SignInAdapter {
  const TwitterSignInAdapter({
    required this.twitterAPIKey,
    required this.twitterAPISecret,
    required this.urlSchemeId,
    this.saveAccountInformation = false,
    this.idKey = "twitter",
    this.nameKey = Const.name,
    this.imageKey = Const.image,
    this.tokenKey = "accessToken",
    this.secretKey = "accessSecret",
    this.visible = true,
  });

  final String twitterAPIKey;
  final String twitterAPISecret;
  final String urlSchemeId;
  final bool saveAccountInformation;
  final String idKey;
  final String nameKey;
  final String imageKey;
  final String tokenKey;
  final String secretKey;

  @override
  String get provider => TwitterAuth.options.id;

  /// If `true`, display.
  @override
  final bool visible;

  @override
  Future<void> signIn() {
    assert(
      twitterAPIKey.isNotEmpty &&
          twitterAPISecret.isNotEmpty &&
          urlSchemeId.isNotEmpty,
      "[twitterAPIKey], [twitterAPISecret] and [urlSchemeId] need to be specified.",
    );
    TwitterAuth.initialize(
      twitterAPIKey: twitterAPIKey,
      twitterAPISecret: twitterAPISecret,
      urlSchemeId: urlSchemeId,
    );
    return TwitterAuth.signIn();
  }

  @override
  Future<void> signOut() {
    assert(
      twitterAPIKey.isNotEmpty &&
          twitterAPISecret.isNotEmpty &&
          urlSchemeId.isNotEmpty,
      "[twitterAPIKey], [twitterAPISecret] and [urlSchemeId] need to be specified.",
    );
    TwitterAuth.initialize(
      twitterAPIKey: twitterAPIKey,
      twitterAPISecret: twitterAPISecret,
      urlSchemeId: urlSchemeId,
    );
    return TwitterAuth.signOut();
  }

  /// Run it the first time the app is launched.
  @override
  @mustCallSuper
  Future<void> onInit(BuildContext context) async {
    super.onInit(context);
    assert(
      twitterAPIKey.isNotEmpty &&
          twitterAPISecret.isNotEmpty &&
          urlSchemeId.isNotEmpty,
      "[twitterAPIKey], [twitterAPISecret] and [urlSchemeId] need to be specified.",
    );
    TwitterAuth.initialize(
      twitterAPIKey: twitterAPIKey,
      twitterAPISecret: twitterAPISecret,
      urlSchemeId: urlSchemeId,
    );
  }

  @override
  Future<void> onAfterAuth(BuildContext context) async {
    await super.onAfterAuth(context);
    if (!saveAccountInformation) {
      return;
    }
    final userId = context.model?.userId;
    if (userId.isEmpty) {
      return;
    }
    final provider =
        readProvider(context.model!.documentProvider("user/$userId"))..fetch();
    await provider.loading;
    if (!provider.containsKey(idKey)) {
      provider[idKey] = TwitterAuth.id;
      provider[nameKey] = TwitterAuth.name;
      provider[imageKey] = TwitterAuth.image;
      provider[tokenKey] = TwitterAuth.accessToken;
      provider[secretKey] = TwitterAuth.accessSecret;
      await provider.save();
    }
  }
}
