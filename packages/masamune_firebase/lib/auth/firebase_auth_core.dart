part of masamune_firebase;

class FirebaseAuthCore {
  FirebaseAuthCore._();

  static FirebaseAuthModel get _auth {
    return readProvider(firebaseAuthProvider);
  }

  static void addListenerOnAuthorized(
    Future<void> Function(FirebaseAuthModel auth, User user, String uid)
        callback,
  ) =>
      _auth.addListenerOnAuthorized(callback);

  static void removeListenerOnAuthorized(
    Future<void> Function(FirebaseAuthModel auth, User user, String uid)
        callback,
  ) =>
      _auth.removeListenerOnAuthorized(callback);

  static void addListenerOnUnauthorized(
    Future<void> Function(FirebaseAuthModel auth) callback,
  ) =>
      _auth.addListenerOnUnauthorized(callback);

  static void removeListenerOnUnauthorized(
    Future<void> Function(FirebaseAuthModel auth) callback,
  ) =>
      _auth.removeListenerOnUnauthorized(callback);

  /// Set options for authentication.
  ///
  /// [twitterAPIKey]: Twitter API Key.
  /// [twitterAPISecret]: Twitter API Secret.
  static void options({
    required String twitterAPIKey,
    required String twitterAPISecret,
  }) =>
      _auth.options(
        twitterAPIKey: twitterAPIKey,
        twitterAPISecret: twitterAPISecret,
      );

  /// Check if you are logged in.
  ///
  /// True if logged in.
  ///
  /// [protocol]: Protocol specification.
  /// [timeout]: Timeout time.
  /// [retryWhenTimeout]: If it times out, try again.
  static Future<bool> tryRestoreAuth({
    Duration timeout = const Duration(seconds: 60),
    bool retryWhenTimeout = false,
  }) =>
      _auth.tryRestoreAuth(
        timeout: timeout,
        retryWhenTimeout: retryWhenTimeout,
      );

  /// True if you are signed in.
  ///
  /// [protorol]: Protocol specification.
  static bool get isSignedIn => _auth.isSignedIn;

  /// You can get the UID after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  ///
  /// [protorol]: Protocol specification.
  static String get uid => _auth.uid;

  /// You can get the Email after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  ///
  /// [protorol]: Protocol specification.
  static String get email => _auth.email;

  /// You can get the status that user email is verified
  /// after authentication is completed.
  ///
  /// [protorol]: Protocol specification.
  static bool get isVerified => _auth.isVerified;

  /// You can get the PhoneNumber after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  ///
  /// [protorol]: Protocol specification.
  static String get phoneNumber => _auth.phoneNumber;

  /// You can get the PhotoURL after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  ///
  /// [protorol]: Protocol specification.
  static String get photoURL => _auth.photoURL;

  /// You can get the Display Name after authentication is completed.
  ///
  /// Null is returned if authentication is not completed.
  ///
  /// [protorol]: Protocol specification.
  static String get name => _auth.name;

  /// For anonymous logged in users, True.
  ///
  /// [protorol]: Protocol specification.
  static bool get isAnonymously => _auth.isAnonymously;

  /// Returns the ID of the currently active provider.
  static List<String> get activeProviders => _auth.activeProviders;

  /// Returns a JWT refresh token for the user.
  static String get refreshToken => _auth.refreshToken;

  /// Returns a JWT access token for the user.
  static Future<String> get accessToken => _auth.accessToken;

  /// Reload the user data.
  ///
  /// [protorol]: Protocol specification.
  static Future<void> reload() => _auth.reload();

  /// Process sign-in.
  /// Perform an anonymous login.
  ///
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<User> signInAnonymously({
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.signInAnonymously(
        timeout: timeout,
      );

  /// Sign out.
  ///
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<void> signOut({
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.signOut(
        timeout: timeout,
      );

  /// Account delete.
  ///
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<void> delete({
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.delete(
        timeout: timeout,
      );

  /// Check the user's verified status.
  ///
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<bool> updateVerifiedStatus({
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.updateVerifiedStatus(
        timeout: timeout,
      );

  /// Re-authenticate using your email address and password.
  ///
  /// [password]: Password.
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<User> reauthInEmailAndPassword({
    required String password,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.reauthInEmailAndPassword(
        password: password,
        timeout: timeout,
      );

  /// Change your email address.
  ///
  /// It is necessary to execute [reauthInEmailAndPassword]
  /// in advance to re-authenticate.
  ///
  /// [email]: Mail address.
  /// [locale]: Specify the language of the confirmation email.
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<User> changeEmail({
    required String email,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.changeEmail(
        email: email,
        locale: locale,
        timeout: timeout,
      );

  /// Change your password.
  ///
  /// It is necessary to execute [reauthInEmailAndPassword]
  /// in advance to re-authenticate.
  ///
  /// [password]: The changed password.
  /// [locale]: Specify the language of the confirmation email.
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<User> changePassword({
    required String password,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.changePassword(
        password: password,
        locale: locale,
        timeout: timeout,
      );

  /// Resend the email for email address verification.
  ///
  /// [protorol]: Protocol specification.
  /// [locale]: Specify the language of the confirmation email.
  /// [timeout]: Timeout time.
  static Future<User> sendEmailVerification({
    Duration timeout = const Duration(seconds: 60),
    String? locale,
  }) =>
      _auth.sendEmailVerification(
        timeout: timeout,
        locale: locale,
      );

  /// Send you an email to reset your password.
  ///
  /// [email]: Email.
  /// [protorol]: Protocol specification.
  /// [locale]: Specify the language of the confirmation email.
  /// [timeout]: Timeout time.
  static Future<void> sendPasswordResetEmail({
    required String email,
    String? locale,
    ActionCodeSettings? actionCodeSettings,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.sendPasswordResetEmail(
        email: email,
        locale: locale,
        timeout: timeout,
        actionCodeSettings: actionCodeSettings,
      );

  /// Send you an email to reset your password.
  ///
  /// [email]: Email.
  /// [protorol]: Protocol specification.
  /// [locale]: Specify the language of the confirmation email.
  /// [timeout]: Timeout time.
  static Future<void> confirmPasswordReset({
    required String code,
    required String password,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.confirmPasswordReset(
        code: code,
        password: password,
        locale: locale,
        timeout: timeout,
      );

  /// Link by email link.
  ///
  /// You need to do [sendEmailLink] first.
  ///
  /// Enter the link acquired by Dynamic Link.
  ///
  /// [link]: Email link.
  /// [locale]: Specify the language of the confirmation email.
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<User> signInEmailLink(
    String link, {
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.signInEmailLink(
        link,
        locale: locale,
        timeout: timeout,
      );

  /// Send an email link.
  ///
  /// [email]: Email.
  /// [url]: URL domain of the link. Specify the domain of Dynamic Link.
  /// [packageName]: App package name.
  /// [androidMinimumVersion]: Minimum version of android.
  /// [protorol]: Protocol specification.
  /// [locale]: Specify the language of the confirmation email.
  /// [timeout]: Timeout time.
  static Future<void> sendEmailLink({
    required String email,
    required String url,
    required String packageName,
    int androidMinimumVersion = 1,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.sendEmailLink(
        email: email,
        url: url,
        packageName: packageName,
        androidMinimumVersion: androidMinimumVersion,
        locale: locale,
        timeout: timeout,
      );

  /// Authenticate by sending a code to your phone number.
  ///
  /// [phoneNumber]: Telephone number (starting with the country code).
  /// [protorol]: Protocol specification.
  /// [locale]: Specify the language of the confirmation email.
  /// [timeout]: Timeout time.
  static Future<void> sendSMS(
    String phoneNumber, {
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.sendSMS(
        phoneNumber,
        locale: locale,
        timeout: timeout,
      );

  /// Authenticate by sending a code to your phone number.
  ///
  /// [smsCode]: Authentication code received from SMS.
  /// [protorol]: Protocol specification.
  /// [locale]: Specify the language of the confirmation email.
  /// [timeout]: Timeout time.
  static Future<User> signInSMS(
    String smsCode, {
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.signInSMS(
        smsCode,
        locale: locale,
        timeout: timeout,
      );

  /// Update your phone number.
  /// You need to send an SMS with [sendSMS] in advance.
  ///
  /// [smsCode]: Authentication code received from SMS.
  /// [protorol]: Protocol specification.
  /// [locale]: Specify the language of the confirmation email.
  /// [timeout]: Timeout time.
  static Future<User> changePhoneNumber(
    String smsCode, {
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.changePhoneNumber(
        smsCode,
        locale: locale,
        timeout: timeout,
      );

  /// Register using your email and password.
  ///
  /// [email]: Mail address.
  /// [password]: Password.
  /// [locale]: Specify the language of the confirmation email.
  /// [protorol]: Protocol specification.
  /// [timeout]: Timeout time.
  static Future<User> registerInEmailAndPassword({
    required String email,
    required String password,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.registerInEmailAndPassword(
        email: email,
        password: password,
        locale: locale,
        timeout: timeout,
      );

  static Future<User> signInEmailAndPassword({
    required String email,
    required String password,
    Duration timeout = const Duration(seconds: 60),
  }) =>
      _auth.signInEmailAndPassword(
        email: email,
        password: password,
        timeout: timeout,
      );
}
