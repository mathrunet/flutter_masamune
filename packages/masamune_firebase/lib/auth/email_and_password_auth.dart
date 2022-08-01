part of masamune_firebase;

/// Log in using your email and password.
class EmailAndPasswordAuth {
  const EmailAndPasswordAuth._();

  /// Gets the options for the provider.
  static const AuthProviderOptions options = AuthProviderOptions(
    id: "password",
    provider: _provider,
    title: "Email & Password SignIn",
    text: "Enter your email and password to sign in.",
  );
  static Future<FirebaseAuthModel> _provider(
    BuildContext context,
    Duration timeout,
  ) async {
    String? email, password;
    final auth = readProvider(firebaseAuthProvider);
    await UIEmailAndPasswordFormDialog.show(
      context,
      defaultSubmitAction: (m, p) {
        email = m;
        password = p;
      },
    );
    if (email.isEmpty || password.isEmpty) {
      return auth;
    }
    await auth.signInEmailAndPassword(
      email: email!,
      password: password!,
      timeout: timeout,
    );
    return auth;
  }

  /// Register using your email and password.
  ///
  /// It is possible to register by specifying [email] and [password].
  ///
  /// If you specify [locale],
  /// you can specify the language in the confirmation email.
  static Future<FirebaseAuthModel> register({
    required String email,
    required String password,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.registerInEmailAndPassword(
      email: email,
      password: password,
      locale: locale,
    );
    return auth;
  }

  /// Log in using your email and password.
  ///
  /// It is possible to login by specifying [email] and [password].
  static Future<FirebaseAuthModel> signIn({
    required String email,
    required String password,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.signInEmailAndPassword(
      email: email,
      password: password,
      timeout: timeout,
    );
    return auth;
  }

  /// Re-authenticate using your email address and password.
  ///
  /// You can re-login by specifying [password].
  static Future<FirebaseAuthModel> reauth({
    required String password,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.reauthInEmailAndPassword(password: password, timeout: timeout);
    return auth;
  }

  /// Resend the email for email address verification.
  ///
  /// If you specify [locale],
  /// you can specify the language in the confirmation email.
  static Future<FirebaseAuthModel> sendEmailVerification({
    Duration timeout = const Duration(seconds: 60),
    String? locale,
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.sendEmailVerification(timeout: timeout, locale: locale);
    return auth;
  }

  /// Send you an email to reset your password.
  ///
  /// Sends an email to the address specified in [email].
  ///
  /// If you specify [locale],
  /// you can specify the language in the reset email.
  static Future<FirebaseAuthModel> sendPasswordResetEmail({
    required String email,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.sendPasswordResetEmail(
      email: email,
      locale: locale,
      timeout: timeout,
    );
    return auth;
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
  static Future<FirebaseAuthModel> changeEmail({
    required String email,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.changeEmail(email: email, locale: locale, timeout: timeout);
    return auth;
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
  static Future<FirebaseAuthModel> changePassword({
    required String password,
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.changePassword(
      password: password,
      locale: locale,
      timeout: timeout,
    );
    return auth;
  }
}
