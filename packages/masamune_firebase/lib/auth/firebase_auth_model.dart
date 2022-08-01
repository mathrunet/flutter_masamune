part of masamune_firebase;

final firebaseAuthProvider = ChangeNotifierProvider((_) => FirebaseAuthModel());

/// This is the model for controlling FirebaseAuth.
///
/// The current [User] is saved in [value].
///
/// If you are not logged in, [value] will be [Null].
///
/// [tryRestoreAuth] to restore the authentication.
class FirebaseAuthModel extends Model<User?> {
  FirebaseAuthModel() : super();

  static const String _hashKey = "MBdKdx3nAHFNeaP32zu8re9rzfHSGZj3";

  /// Get an instance of [FirebaseAuth].
  @protected
  FirebaseAuth get auth {
    return FirebaseAuth.instance;
  }

  /// Registers a [callback] when a sign-in is performed.
  void addListenerOnAuthorized(
    Future<void> Function(FirebaseAuthModel auth, User user, String uid)
        callback,
  ) {
    if (_onAuthorizedCallback.contains(callback)) {
      return;
    }
    _onAuthorizedCallback.add(callback);
  }

  /// Unregisters a [callback] when a sign-in is performed.
  void removeListenerOnAuthorized(
    Future<void> Function(FirebaseAuthModel auth, User user, String uid)
        callback,
  ) {
    _onAuthorizedCallback.remove(callback);
  }

  final List<
          Future<void> Function(FirebaseAuthModel auth, User user, String uid)>
      _onAuthorizedCallback = [];

  /// Registers a [callback] when a sign-out is performed.
  void addListenerOnUnauthorized(
    Future<void> Function(FirebaseAuthModel auth) callback,
  ) {
    if (_onUnauthorizedCallback.contains(callback)) {
      return;
    }
    _onUnauthorizedCallback.add(callback);
  }

  /// Unregisters a [callback] when a sign-out is performed.
  void removeListenerOnUnauthorized(
    Future<void> Function(FirebaseAuthModel auth) callback,
  ) {
    _onUnauthorizedCallback.remove(callback);
  }

  final List<Future<void> Function(FirebaseAuthModel auth)>
      _onUnauthorizedCallback = [];

  /// Current user data.
  User? get user => auth.currentUser;

  /// Set options for authentication for twitter.
  ///
  /// [twitterAPIKey] is the Twitter API Key,
  /// and [twitterAPISecret] is the Twitter API Secret.
  void options({
    required String twitterAPIKey,
    required String twitterAPISecret,
  }) {
    _twitterAPIKey = twitterAPIKey;
    _twitterAPISecret = twitterAPISecret;
  }

  // ignore: unused_field
  String? _twitterAPIKey;
  // ignore: unused_field
  String? _twitterAPISecret;

  /// Check if you are logged in.
  ///
  /// True if logged in.
  ///
  /// If [retryWhenTimeout] is `true`,
  /// it will retry when the time specified by [timeout] is exceeded.
  Future<bool> tryRestoreAuth({
    Duration timeout = const Duration(seconds: 60),
    bool retryWhenTimeout = false,
  }) {
    return _tryRestoreAuth(timeout, retryWhenTimeout);
  }

  Future<bool> _tryRestoreAuth(
    Duration timeout,
    bool retryWhenTimeout,
  ) async {
    try {
      await FirebaseCore.initialize();
      User? user = auth.currentUser;
      user ??= await FirebaseAuth.instance.idTokenChanges().first;
      if (user != null) {
        await user.reload().timeout(timeout);
        // this.user = user;
        await Future.wait(
          [
            Config.onUserStateChanged.call(user.uid),
            ..._onAuthorizedCallback
                .mapAndRemoveEmpty((item) => item.call(this, user!, user.uid)),
          ],
        );
        return true;
      }
    } on TimeoutException {
      if (!retryWhenTimeout) {
        rethrow;
      }
      return _tryRestoreAuth(timeout, retryWhenTimeout);
    } catch (e) {
      return false;
    }
    return false;
  }

  /// True if you are signed in.
  bool get isSignedIn {
    if (user.isEmpty) {
      return false;
    }
    return true;
  }

  /// You can get the UID after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  String get uid {
    if (user.isEmpty) {
      return "";
    }
    return user!.uid;
  }

  /// You can get the Email after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  String get email {
    if (user.isEmpty) {
      return "";
    }
    return user!.email ?? "";
  }

  /// You can get the status that user email is verified
  /// after authentication is completed.
  bool get isVerified {
    if (user.isEmpty) {
      return false;
    }
    return user!.emailVerified;
  }

  /// You can get the PhoneNumber after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  String get phoneNumber {
    if (user.isEmpty) {
      return "";
    }
    return user!.phoneNumber ?? "";
  }

  /// You can get the PhotoURL after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  String get photoURL {
    if (user.isEmpty) {
      return "";
    }
    return user!.photoURL ?? "";
  }

  /// You can get the Display Name after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  String get name {
    if (user.isEmpty) {
      return "";
    }
    return user!.displayName ?? "";
  }

  /// For anonymous logged in users, True.
  bool get isAnonymously {
    if (user.isEmpty) {
      return false;
    }
    return user!.isAnonymous;
  }

  /// Returns the ID of the currently active provider.
  List<String> get activeProviders {
    if (user.isEmpty) {
      return [];
    }
    return user!.providerData.map((e) => e.providerId).toList();
  }

  /// Returns a JWT refresh token for the user.
  String get refreshToken {
    if (user.isEmpty) {
      return "";
    }
    return user!.refreshToken ?? "";
  }

  /// Returns a JWT access token for the user.
  Future<String> get accessToken {
    if (user.isEmpty) {
      return Future.value("");
    }
    return user!.getIdToken();
  }

  /// Reload the user data.
  Future<void> reload() async {
    if (user.isEmpty) {
      throw Exception(
        "Not logged in yet. Please wait until login is successful.",
      );
    }
    await user!.reload();
  }

  /// Process sign-in.
  /// Perform an anonymous login.
  Future<User> signInAnonymously({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final user = await _anonymousProcess(timeout);
    return user!;
  }

  /// Process sign-out.
  ///
  /// If you are not signed in, it will throw an Exception.
  Future<void> signOut({Duration timeout = const Duration(seconds: 60)}) async {
    if (user.isEmpty) {
      throw Exception(
        "Not logged in yet. Please wait until login is successful.",
      );
    }
    await _signOutProcess(timeout);
  }

  Future _signOutProcess(Duration timeout) async {
    await FirebaseCore.initialize();
    await auth.signOut().timeout(timeout);
    await Future.wait([
      Config.onUserStateChanged.call(null),
      ..._onUnauthorizedCallback.mapAndRemoveEmpty((item) => item.call(this)),
    ]);
    notifyListeners();
  }

  /// Account delete.
  ///
  /// If there is no account, it will spit Exception.
  Future<void> delete({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (user.isEmpty) {
      throw Exception(
        "Not logged in yet. Please wait until login is successful.",
      );
    }
    await _deleteProcess(timeout);
  }

  Future _deleteProcess(Duration timeout) async {
    await FirebaseCore.initialize();
    await user!.delete().timeout(timeout);
    // user = null;
    notifyListeners();
  }

  /// Check the user's verified status.
  Future<bool> updateVerifiedStatus({
    Duration timeout = const Duration(seconds: 60),
  }) =>
      tryRestoreAuth(timeout: timeout);

  /// Re-authenticate using your email address and password.
  ///
  /// You can re-login by specifying [password].
  Future<User> reauthInEmailAndPassword({
    required String password,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(password.isNotEmpty, "This password is invalid.");
    if (user.isEmpty) {
      throw Exception(
        "Not logged in yet. Please wait until login is successful.",
      );
    }
    await _reauthInEmailAndPasswordProcess(password, timeout);
    return user!;
  }

  Future _reauthInEmailAndPasswordProcess(
    String password,
    Duration timeout,
  ) async {
    await FirebaseCore.initialize();
    await user!.reauthenticateWithCredential(
      EmailAuthProvider.credential(email: user!.email!, password: password),
    );
    notifyListeners();
  }

  /// Change your email address.
  ///
  /// It is necessary to execute [changeEmail]
  /// in advance to re-authenticate.
  ///
  /// Sends an email to the address specified in [email].
  ///
  /// If you specify [locale],
  /// you can specify the language in the confirmation email.
  Future<User> changeEmail({
    required String email,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(email.isNotEmpty, "This email is invalid.");
    if (user.isEmpty) {
      throw Exception(
        "Not logged in yet. Please wait until login is successful.",
      );
    }
    await _changeEmailProcess(email, locale ?? Localize.locale, timeout);
    return user!;
  }

  Future<void> _changeEmailProcess(
    String email,
    String locale,
    Duration timeout,
  ) async {
    await FirebaseCore.initialize();
    await auth.setLanguageCode(locale);
    await user!.updateEmail(email);
    // user = auth.currentUser;
    await user!.reload();
    notifyListeners();
  }

  /// Change your password.
  ///
  /// It is necessary to execute [changePassword]
  /// in advance to re-authenticate.
  ///
  /// You can set a new password in [password].
  ///
  /// If you specify [locale],
  /// you can specify the language in the confirmation email.
  Future<User> changePassword({
    required String password,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(password.isNotEmpty, "This password is invalid.");
    if (user.isEmpty) {
      throw Exception(
        "Not logged in yet. Please wait until login is successful.",
      );
    }
    await _changePasswordProcess(password, locale ?? Localize.locale, timeout);
    return user!;
  }

  Future _changePasswordProcess(
    String password,
    String locale,
    Duration timeout,
  ) async {
    await FirebaseCore.initialize();
    await auth.setLanguageCode(locale);
    await user!.updatePassword(password);
    // user = auth.currentUser;
    await user!.reload();
    notifyListeners();
  }

  /// Resend the email for email address verification.
  ///
  /// If you specify [locale],
  /// you can specify the language in the confirmation email.
  Future<User> sendEmailVerification({
    Duration timeout = const Duration(seconds: 60),
    String? locale,
  }) async {
    if (user.isEmpty) {
      throw Exception(
        "Not logged in yet. Please wait until login is successful.",
      );
    }
    await _sendEmailVerificationProcess(locale ?? Localize.locale, timeout);
    return user!;
  }

  Future<void> _sendEmailVerificationProcess(
    String locale,
    Duration timeout,
  ) async {
    await FirebaseCore.initialize();
    if (user!.emailVerified) {
      throw Exception("This user has already been authenticated.");
    }
    await auth.setLanguageCode(locale);
    await user!.sendEmailVerification();
    notifyListeners();
  }

  /// Send you an email to reset your password.
  ///
  /// Sends an email to the address specified in [email].
  ///
  /// If you specify [locale],
  /// you can specify the language in the reset email.
  Future<void> sendPasswordResetEmail({
    required String email,
    ActionCodeSettings? actionCodeSettings,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(email.isNotEmpty, "This email is invalid.");
    await _sendPasswordResetEmailProcess(
      email,
      locale ?? Localize.locale,
      actionCodeSettings,
      timeout,
    );
  }

  Future<void> _sendPasswordResetEmailProcess(
    String email,
    String locale,
    ActionCodeSettings? actionCodeSettings,
    Duration timeout,
  ) async {
    await FirebaseCore.initialize();
    await auth.setLanguageCode(locale);
    await auth.sendPasswordResetEmail(
      email: email,
      actionCodeSettings: actionCodeSettings,
    );
    notifyListeners();
  }

  /// Reset your password with the [code] and new [password] sent in the email.
  ///
  /// You can specify the language of the email in [locale].
  Future<void> confirmPasswordReset({
    required String code,
    required String password,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(code.isNotEmpty, "This code is invalid.");
    assert(password.isNotEmpty, "This password is invalid.");
    await _confirmPasswordResetProcess(
      code,
      password,
      locale ?? Localize.locale,
      timeout,
    );
  }

  Future<void> _confirmPasswordResetProcess(
    String code,
    String password,
    String locale,
    Duration timeout,
  ) async {
    await FirebaseCore.initialize();
    await auth.setLanguageCode(locale);
    await auth.confirmPasswordReset(
      code: code,
      newPassword: password,
    );
    notifyListeners();
  }

  /// Link by email link.
  ///
  /// You need to do [sendEmailLink] first.
  ///
  /// Enter the [link] acquired by Dynamic Link.
  ///
  /// If you specify [locale],
  /// you can specify the language in which the mail is sent.
  Future<User> signInEmailLink(
    String link, {
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(link.isNotEmpty, "This email link is invalid.");
    final email = Prefs.getString("FirestoreSignInEmail".toSHA256(_hashKey));
    if (email.isEmpty) {
      throw Exception(
        "The processing is invalid. First create a link with [sendEmailLink].",
      );
    }
    await _linkToEmailLinkProcess(
      email,
      link,
      locale ?? Localize.locale,
      timeout,
    );
    return user!;
  }

  Future<void> _linkToEmailLinkProcess(
    String email,
    String link,
    String locale,
    Duration timeout,
  ) async {
    await _prepareProcessInternal(timeout);
    if (!auth.isSignInWithEmailLink(link)) {
      throw Exception("This email link is invalid.");
    }
    await auth.setLanguageCode(locale);
    final credential =
        EmailAuthProvider.credentialWithLink(email: email, emailLink: link);
    if (user != null) {
      await user!.linkWithCredential(credential).timeout(timeout);
    } else {
      await auth.signInWithCredential(credential).timeout(timeout);
    }
    if (user.isEmpty) {
      throw Exception("User is not found.");
    }
    Prefs.remove("FirestoreSignInEmail".toSHA256(_hashKey));
    await Future.wait(
      [
        Config.onUserStateChanged.call(user?.uid),
        ..._onAuthorizedCallback
            .mapAndRemoveEmpty((item) => item.call(this, user!, user!.uid)),
      ],
    );
    notifyListeners();
  }

  /// Send an email link.
  ///
  /// By specifying [email],
  /// an email link will be sent to that email address.
  ///
  /// It is possible to specify the domain of the link by specifying [url].
  /// Specify the domain of Dynamic Link.
  ///
  /// Specify the package name of the application in [packageName].
  ///
  /// You can specify the language of the email in [locale].
  Future<void> sendEmailLink({
    required String email,
    required String url,
    required String packageName,
    int androidMinimumVersion = 1,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(email.isNotEmpty, "This email is invalid.");
    await _sendEmailLinkProcess(
      email,
      url,
      packageName,
      androidMinimumVersion,
      locale ?? Localize.locale,
      timeout,
    );
  }

  Future<void> _sendEmailLinkProcess(
    String email,
    String url,
    String packageName,
    int androidMinimumVersion,
    String locale,
    Duration timeout,
  ) async {
    await _prepareProcessInternal(timeout);
    if (user != null &&
        user!.providerData
            .any((t) => t.providerId.contains(EmailAuthProvider.PROVIDER_ID))) {
      throw Exception("This user is already linked to a Email account.");
    }
    await auth.setLanguageCode(locale);
    await auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: ActionCodeSettings(
        androidInstallApp: true,
        url: url,
        handleCodeInApp: true,
        iOSBundleId: packageName,
        androidPackageName: packageName,
        androidMinimumVersion: androidMinimumVersion.toString(),
      ),
    );
    Prefs.set("FirestoreSignInEmail".toSHA256(_hashKey), email);
    notifyListeners();
  }

  /// Authenticate by sending a code to your [phoneNumber].
  ///
  /// You can specify the language of the email to be sent by [locale].
  Future<void> sendSMS(
    String phoneNumber, {
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(phoneNumber.isNotEmpty, "This Phone number is invalid.");
    await _sendSMS(phoneNumber, locale ?? Localize.locale, timeout);
  }

  Future<void> _sendSMS(
    String phoneNumber,
    String locale,
    Duration timeout,
  ) async {
    await _prepareProcessInternal(timeout);
    await auth.setLanguageCode(locale);
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeout,
      verificationCompleted: (credential) async {
        if (user != null) {
          if (!user!.providerData.any(
            (t) => t.providerId.contains(PhoneAuthProvider.PROVIDER_ID),
          )) {
            await user!.linkWithCredential(credential).timeout(timeout);
          }
        } else {
          await auth.signInWithCredential(credential).timeout(timeout);
        }
        if (user.isEmpty) {
          throw Exception("User is not found.");
        }
        await Future.wait(
          [
            Config.onUserStateChanged.call(user?.uid),
            ..._onAuthorizedCallback.mapAndRemoveEmpty(
              (item) => item.call(this, user!, user!.uid),
            ),
          ],
        );
        notifyListeners();
      },
      verificationFailed: (error) {
        throw error;
      },
      codeSent: (verificationCode, [code]) {
        Prefs.set(
          "FirestoreSignInPhoneNumber".toSHA256(_hashKey),
          verificationCode,
        );
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (verificationCode) {
        Prefs.set(
          "FirestoreSignInPhoneNumber".toSHA256(_hashKey),
          verificationCode,
        );
        notifyListeners();
      },
    );
  }

  /// Authenticate by sending a code to your phone number.
  ///
  /// First, run [sendSMS] to send an SMS.
  ///
  /// You can login by specifying the code sent to sms with [smsCode].
  Future<User> signInSMS(
    String smsCode, {
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(smsCode.isNotEmpty, "This SMS code is invalid.");
    final phoneNumber =
        Prefs.getString("FirestoreSignInPhoneNumber".toSHA256(_hashKey));
    if (phoneNumber.isEmpty) {
      throw Exception(
        "An authorization code has not been issued. Use [FirestoreAuth.sendSMS()] to issue the authentication code.",
      );
    }
    await _signInSMS(phoneNumber, smsCode, locale ?? Localize.locale, timeout);
    return user!;
  }

  Future<void> _signInSMS(
    String phoneNumber,
    String smsCode,
    String locale,
    Duration timeout,
  ) async {
    await _prepareProcessInternal(timeout);
    await auth.setLanguageCode(locale);
    final credential = PhoneAuthProvider.credential(
      verificationId: phoneNumber,
      smsCode: smsCode,
    );
    if (user != null) {
      if (!user!.providerData
          .any((t) => t.providerId.contains(PhoneAuthProvider.PROVIDER_ID))) {
        await user!.linkWithCredential(credential).timeout(timeout);
      }
    } else {
      await auth.signInWithCredential(credential).timeout(timeout);
    }
    if (user.isEmpty) {
      throw Exception("User is not found.");
    }
    Prefs.remove("FirestoreSignInPhoneNumber".toSHA256(_hashKey));
    await Future.wait(
      [
        Config.onUserStateChanged.call(user?.uid),
        ..._onAuthorizedCallback
            .mapAndRemoveEmpty((item) => item.call(this, user!, user!.uid)),
      ],
    );
    notifyListeners();
  }

  /// Update your phone number.
  /// You need to send an SMS with [sendSMS] in advance.
  ///
  /// You can login by specifying the code sent to sms with [smsCode].
  Future<User> changePhoneNumber(
    String smsCode, {
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(smsCode.isNotEmpty, "This SMS code is invalid.");
    final phoneNumber =
        Prefs.getString("FirestoreSignInPhoneNumber".toSHA256(_hashKey));
    if (phoneNumber.isEmpty) {
      throw Exception(
        "An authorization code has not been issued. Use [FirestoreAuth.sendSMS()] to issue the authentication code.",
      );
    }
    if (user.isEmpty) {
      throw Exception(
        "You are not logged in. You need to log in beforehand using [signInSMS].",
      );
    }
    await _changePhoneNumber(
      phoneNumber,
      smsCode,
      locale ?? Localize.locale,
      timeout,
    );
    return user!;
  }

  Future _changePhoneNumber(
    String phoneNumber,
    String smsCode,
    String locale,
    Duration timeout,
  ) async {
    await _prepareProcessInternal(timeout);
    await auth.setLanguageCode(locale);
    final credential = PhoneAuthProvider.credential(
      verificationId: phoneNumber,
      smsCode: smsCode,
    );
    if (user.isEmpty) {
      throw Exception("User is not found.");
    }
    await user!.updatePhoneNumber(credential);
    // user = auth.currentUser;
    await user!.reload();
    Prefs.remove("FirestoreSignInPhoneNumber".toSHA256(_hashKey));
    notifyListeners();
  }

  /// Register using your email and password.
  ///
  /// It is possible to register by specifying [email] and [password].
  ///
  /// If you specify [locale],
  /// you can specify the language in the confirmation email.
  Future<User> registerInEmailAndPassword({
    required String email,
    required String password,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(
      email.isNotEmpty && password.isNotEmpty,
      "This email or password is invalid.",
    );
    await _registerToEmailAndPasswordProcess(
      email,
      password,
      locale ?? Localize.locale,
      timeout,
    );
    return user!;
  }

  Future<void> _registerToEmailAndPasswordProcess(
    String email,
    String password,
    String locale,
    Duration timeout,
  ) async {
    await _prepareProcessInternal(timeout);
    if (user != null) {
      await user!
          .linkWithCredential(
            EmailAuthProvider.credential(email: email, password: password),
          )
          .timeout(timeout);
    } else {
      await auth.setLanguageCode(locale);
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .timeout(timeout);
    }
    if (user.isEmpty) {
      throw Exception("User is not found.");
    }
    await Future.wait(
      [
        Config.onUserStateChanged.call(user?.uid),
        ..._onAuthorizedCallback
            .mapAndRemoveEmpty((item) => item.call(this, user!, user!.uid)),
      ],
    );
    notifyListeners();
  }

  /// Log in using your email and password.
  ///
  /// It is possible to login by specifying [email] and [password].
  Future<User> signInEmailAndPassword({
    required String email,
    required String password,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(
      email.isNotEmpty && password.isNotEmpty,
      "This email or password is invalid.",
    );
    await _linkToEmailAndPasswordProcess(email, password, timeout);
    return user!;
  }

  Future<void> _linkToEmailAndPasswordProcess(
    String email,
    String password,
    Duration timeout,
  ) async {
    await _prepareProcessInternal(timeout);
    final credential =
        EmailAuthProvider.credential(email: email, password: password);
    if (user != null) {
      await user!.linkWithCredential(credential).timeout(timeout);
    } else {
      await auth.signInWithCredential(credential).timeout(timeout);
    }
    if (user.isEmpty) {
      throw Exception("User is not found.");
    }
    await Future.wait(
      [
        Config.onUserStateChanged.call(user?.uid),
        ..._onAuthorizedCallback
            .mapAndRemoveEmpty((item) => item.call(this, user!, user!.uid)),
      ],
    );
    notifyListeners();
  }

  /// Log in with a PROVIDER such as Google or Apple.
  ///
  /// Logging will be done with the specified provider by specifying [providerCallback] and [providerId] respectively.
  Future<User> signInWithProvider({
    required Future<AuthCredential> Function(Duration timeout) providerCallback,
    required String providerId,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    assert(providerId.isNotEmpty, "The provier ID is invalid.");
    await _linkWithProviderProcess(providerCallback, providerId, timeout);
    return user!;
  }

  Future<void> _linkWithProviderProcess(
    Future<AuthCredential> providerCallback(Duration timeout),
    String providerId,
    Duration timeout,
  ) async {
    await _prepareProcessInternal(timeout);
    if (user != null &&
        user!.providerData.any((t) => t.providerId.contains(providerId))) {
      throw Exception("This user is already linked to a $providerId account.");
    }
    final credential = await providerCallback(timeout);
    if (user != null) {
      await user!.linkWithCredential(credential).timeout(timeout);
    } else {
      await auth.signInWithCredential(credential).timeout(timeout);
    }
    if (user.isEmpty) {
      throw Exception("User is not found.");
    }
    await Future.wait(
      [
        Config.onUserStateChanged.call(user?.uid),
        ..._onAuthorizedCallback
            .mapAndRemoveEmpty((item) => item.call(this, user!, user!.uid)),
      ],
    );
    notifyListeners();
  }

  Future<User?> _anonymousProcess(Duration timeout) async {
    await _prepareProcessInternal(timeout);
    if (user != null && user!.uid.isNotEmpty) {
      return user;
    }
    await _anonymousProcessInternal(timeout);
    return user;
  }

  Future<void> _prepareProcessInternal(Duration timeout) async {
    await FirebaseCore.initialize();
    final user = auth.currentUser;
    if (user == null) {
      return;
    }
    await user.reload().timeout(timeout);
  }

  Future<void> _anonymousProcessInternal(Duration timeout) async {
    if (user != null) {
      return;
    }
    await auth.signInAnonymously().timeout(timeout);
    if (user.isEmpty) {
      throw Exception("User is not found.");
    }
    await Future.wait(
      [
        Config.onUserStateChanged.call(user?.uid),
        ..._onAuthorizedCallback
            .mapAndRemoveEmpty((item) => item.call(this, user!, user!.uid)),
      ],
    );
    notifyListeners();
  }
}
