part of masamune_signin_twitter;

/// Sign in to Firebase using Twitter Login.
class TwitterAuth {
  const TwitterAuth._();

  static bool _initialized = false;
  static late final String _twitterAPIKey;
  static late final String _twitterAPISecret;
  static late final String _urlSchemeId;

  static const String _idKey = "2d53f333956a4c99a391e39af917927f";
  static const String _nameKey = "c17c823c9cc14d1a981ff0d0d483af29";
  static const String _imageKey = "6bf5ca08228b48ed92441a06f43ad3b5";
  static const String _accessTokenKey = "b61d443518304dfa80b2d30731d75018";
  static const String _accessSecretKey = "82d135df1b1c4dda8f9a890444f66d6a";

  /// Set options for authentication.
  ///
  /// [twitterAPIKey]: Twitter API Key.
  /// [twitterAPISecret]: Twitter API Secret.
  static void initialize({
    required String twitterAPIKey,
    required String twitterAPISecret,
    required String urlSchemeId,
  }) {
    if (_initialized) {
      return;
    }
    _initialized = true;
    _twitterAPIKey = twitterAPIKey;
    _twitterAPISecret = twitterAPISecret;
    _urlSchemeId = urlSchemeId;
  }

  /// Gets the options for the provider.
  static const AuthProviderOptions options = AuthProviderOptions(
    id: "twitter.com",
    provider: _provider,
    title: "Twitter SignIn",
    text: "Sign in with your Twitter account.",
  );
  static Future<FirebaseAuthModel> _provider(
    BuildContext context,
    Duration timeout,
  ) {
    return signIn(timeout: timeout);
  }

  /// Twitter name.
  static String get name {
    if (!_initialized) {
      return "";
    }
    return Prefs.get("$_urlSchemeId$_nameKey", "");
  }

  /// Twitter id.
  static String get id {
    if (!_initialized) {
      return "";
    }
    return Prefs.get("$_urlSchemeId$_idKey", "");
  }

  /// Twitter thumnail image.
  static String get image {
    if (!_initialized) {
      return "";
    }
    return Prefs.get("$_urlSchemeId$_imageKey", "");
  }

  /// Twitter access token.
  static String get accessToken {
    if (!_initialized) {
      return "";
    }
    return Prefs.get("$_urlSchemeId$_accessTokenKey", "");
  }

  /// Twitter access secret.
  static String get accessSecret {
    if (!_initialized) {
      return "";
    }
    return Prefs.get("$_urlSchemeId$_accessSecretKey", "");
  }

  /// Sign in to Firebase using Twitter Login.
  ///
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<FirebaseAuthModel> signIn({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (_twitterAPIKey.isEmpty ||
        _twitterAPISecret.isEmpty ||
        _urlSchemeId.isEmpty) {
      throw Exception(
        "There is no API key or other information. Please initialize it with [initialize].",
      );
    }
    final auth = readProvider(firebaseAuthProvider);
    await auth.signInWithProvider(
      providerCallback: (timeout) async {
        final twitter = TwitterLogin(
          apiKey: _twitterAPIKey,
          apiSecretKey: _twitterAPISecret,
          redirectURI: _urlSchemeId,
        );
        final result = await twitter.login();
        switch (result.status) {
          case TwitterLoginStatus.cancelledByUser:
            throw Exception("Login canceled");
          case TwitterLoginStatus.error:
            throw Exception(
              "Login terminated with error: ${result.errorMessage}",
            );
          default:
            break;
        }
        if (result.authToken.isEmpty || result.authTokenSecret.isEmpty) {
          throw Exception("Login terminated with error: Token is empty.");
        }
        final name = result.user?.name;
        final image = result.user?.thumbnailImage;
        final screenName = result.user?.screenName;
        final accessToken = result.authToken;
        final accessSecret = result.authTokenSecret;
        Prefs.set("$_urlSchemeId$_nameKey", name);
        Prefs.set("$_urlSchemeId$_idKey", screenName);
        Prefs.set("$_urlSchemeId$_imageKey", image);
        Prefs.set("$_urlSchemeId$_accessTokenKey", accessToken);
        Prefs.set("$_urlSchemeId$_accessSecretKey", accessSecret);
        return TwitterAuthProvider.credential(
          accessToken: result.authToken!,
          secret: result.authTokenSecret!,
        );
      },
      providerId: TwitterAuthProvider.PROVIDER_ID,
      timeout: timeout,
    );
    return auth;
  }

  /// Sign out from Firebase using Twitter Login.
  static Future<void> signOut() async {
    try {
      final auth = readProvider(firebaseAuthProvider);
      await auth.signOut();
      Prefs.remove("$_urlSchemeId$_nameKey");
      Prefs.remove("$_urlSchemeId$_idKey");
      Prefs.remove("$_urlSchemeId$_imageKey");
      Prefs.remove("$_urlSchemeId$_accessTokenKey");
      Prefs.remove("$_urlSchemeId$_accessSecretKey");
    } catch (e) {
      rethrow;
    }
  }
}
