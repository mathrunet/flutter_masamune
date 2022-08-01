part of masamune_firebase;

/// Log in using your phone number.
class SMSAuth {
  const SMSAuth();

  /// Gets the options for the provider.
  static const AuthProviderOptions options = AuthProviderOptions(
    id: "phone",
    provider: _provider,
    title: "Phone number SignIn",
    text: "Enter your phone number to sign in.",
  );
  static Future<FirebaseAuthModel> _provider(
    BuildContext context,
    Duration timeout,
  ) async {
    String? phoneNumber;
    final auth = readProvider(firebaseAuthProvider);
    await UISMSFormDialog.show(
      context,
      defaultSubmitAction: (m) {
        phoneNumber = m;
      },
    );
    if (phoneNumber.isEmpty) {
      return auth;
    }
    await auth.sendSMS(phoneNumber!, timeout: timeout);
    return auth;
  }

  /// Authenticate by sending a code to your [phoneNumber].
  ///
  /// You can specify the language of the email to be sent by [locale]
  static Future<FirebaseAuthModel> send(
    String phoneNumber, {
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.sendSMS(phoneNumber, locale: locale, timeout: timeout);
    return auth;
  }

  /// Authenticate by sending a code to your phone number.
  ///
  /// First, run [sendSMS] to send an SMS.
  ///
  /// You can login by specifying the code sent to sms with [smsCode].
  static Future<FirebaseAuthModel> signIn(
    String smsCode, {
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.signInSMS(smsCode, locale: locale, timeout: timeout);
    return auth;
  }

  /// Update your phone number.
  ///
  /// You need to send an SMS with [sendSMS] in advance.
  ///
  /// You can login by specifying the code sent to sms with [smsCode].
  static Future<FirebaseAuthModel> changePhoneNumber(
    String smsCode, {
    String? locale,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final auth = readProvider(firebaseAuthProvider);
    await auth.changePhoneNumber(smsCode, locale: locale, timeout: timeout);
    return auth;
  }
}
