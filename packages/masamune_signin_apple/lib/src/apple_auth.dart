part of masamune_signin_apple;

/// Sign in to Firebase using Apple SignIn.
class AppleAuth {
  const AppleAuth._();

  static String? _clientId;
  static String? _redirectUri;

  /// Set options for authentication.
  ///
  /// [clientId]: Service ID created in Apple Developer Program.
  /// [redirectUri]: The same redirect URL that you registered for your Service ID.
  static void initialize({
    required String clientId,
    required String redirectUri,
  }) {
    _clientId = clientId;
    _redirectUri = redirectUri;
  }

  /// Gets the options for the provider.
  static const AuthProviderOptions options = AuthProviderOptions(
    id: "apple.com",
    provider: _provider,
    title: "Apple SignIn",
    text: "Sign in with your Apple account.",
  );
  static Future<FirebaseAuthModel> _provider(
    BuildContext context,
    Duration timeout,
  ) async {
    if (!Config.isIOS && (_clientId.isEmpty || _redirectUri.isEmpty)) {
      throw Exception("Unable to read required information.");
    }
    return signIn(timeout: timeout);
  }

  /// Sign in to Firebase using Apple SignIn.
  ///
  /// [timeout]: Timeout time.
  static Future<FirebaseAuthModel> signIn({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (!Config.isIOS && (_clientId.isEmpty || _redirectUri.isEmpty)) {
      throw Exception("Unable to read required information.");
    }
    final auth = readProvider(firebaseAuthProvider);
    await auth.signInWithProvider(
      providerCallback: (timeout) async {
        try {
          if (Config.isWeb) {
            if (_clientId.isEmpty || _redirectUri.isEmpty) {
              throw Exception("ClientId and RedirectUri is empty.");
            }
            final appleResult = await SignInWithApple.getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
              ],
              webAuthenticationOptions: WebAuthenticationOptions(
                clientId: _clientId!,
                redirectUri: Uri.parse(
                  _redirectUri!,
                ),
              ),
            );
            if (appleResult.identityToken != null) {
              return OAuthProvider(options.id).credential(
                idToken: appleResult.identityToken,
                accessToken: appleResult.authorizationCode,
              );
            } else {
              throw Exception(
                "Login failed because the authentication information cannot be found.",
              );
            }
          } else {
            final info = Config.packageInfo;
            if (info == null) {
              throw Exception("Package information is not found.");
            }
            final appleResult = await SignInWithApple.getAppleIDCredential(
              scopes: [
                AppleIDAuthorizationScopes.email,
                AppleIDAuthorizationScopes.fullName,
              ],
              webAuthenticationOptions:
                  _clientId.isNotEmpty && _redirectUri.isNotEmpty
                      ? WebAuthenticationOptions(
                          clientId: _clientId!,
                          redirectUri: Uri.parse(
                            _redirectUri!
                                .replaceAll("[PackageName]", info.packageName),
                          ),
                        )
                      : null,
            );
            if (appleResult.identityToken != null) {
              return OAuthProvider(options.id).credential(
                idToken: appleResult.identityToken,
                accessToken: appleResult.authorizationCode,
              );
            } else {
              throw Exception(
                "Login failed because the authentication information cannot be found.",
              );
            }
          }
        } catch (e) {
          rethrow;
        }
      },
      providerId: "apple.com",
      timeout: timeout,
    );
    return auth;
  }

  /// Sign out from Firebase using Apple SignIn.
  static Future<void> signOut() async {
    try {
      if (!Config.isIOS && (_clientId.isEmpty || _redirectUri.isEmpty)) {
        throw Exception("Unable to read required information.");
      }
      final auth = readProvider(firebaseAuthProvider);
      await auth.signOut();
    } catch (e) {
      rethrow;
    }
  }
}
