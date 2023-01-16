part of katana_auth;

const _kPhoneAuthProviderId = "phone";

/// {@template sms_auth}
/// An `AuthQuery` for SMS code authentication.
///
/// An SMS with a code is sent at [signIn], and the code is confirmed at [confirmSignIn] to log in.
///
/// After logging in, you will be able to change your phone number.
///
/// SMSのコード認証を行うための`AuthQuery`。
///
/// [signIn]時にコード付きのSMSを送信し、[confirmSignIn]でコードを確定してログインを行ないます。
///
/// ログイン後、電話番号の変更が可能になります。
/// {@endtemplate}
class SmsAuthQuery {
  const SmsAuthQuery._();

  static SmsSignInAuthProvider signIn({
    required String phoneNumber,
    Locale? locale,
  }) {
    return SmsSignInAuthProvider(phoneNumber: phoneNumber, locale: locale);
  }

  static SmsConfirmSignInAuthProvider confirmSignIn({
    required String code,
  }) {
    return SmsConfirmSignInAuthProvider(code: code);
  }

  static SmsChangePhoneNumberAuthProvider changePhoneNumber({
    required String phoneNumber,
    Locale? locale,
  }) {
    return SmsChangePhoneNumberAuthProvider(
      phoneNumber: phoneNumber,
      locale: locale,
    );
  }

  static SmsConfirmChangePhoneNumberAuthProvider confirmChangePhoneNumber({
    required String code,
  }) {
    return SmsConfirmChangePhoneNumberAuthProvider(
      code: code,
    );
  }
}

/// {@macro sign_in_auth_provider}
///
/// Pass the phone number in [phoneNumber] and the SMS language setting in [locale].
///
/// [phoneNumber]で電話番号、[locale]にSMSの言語設定を渡します。
///
/// {@macro sms_auth}
class SmsSignInAuthProvider extends SignInAuthProvider {
  const SmsSignInAuthProvider({
    required this.phoneNumber,
    this.locale,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPhoneAuthProviderId;

  /// Phone number to send SMS to.
  ///
  /// SMSを送る電話番号。
  final String phoneNumber;

  /// SMS language settings.
  ///
  /// SMSの言語設定。
  final Locale? locale;
}

/// {@macro confirm_sign_in_auth_provider}
///
/// Pass the code sent by SMS at [code].
///
/// [code]でSMSで送られたコードを渡します。
///
/// {@macro sms_auth}
class SmsConfirmSignInAuthProvider extends ConfirmSignInAuthProvider {
  /// {@macro confirm_sign_in_auth_provider}
  ///
  /// Pass the code sent by SMS at [code].
  ///
  /// [code]でSMSで送られたコードを渡します。
  ///
  /// {@macro sms_auth}
  const SmsConfirmSignInAuthProvider({
    required this.code,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPhoneAuthProviderId;

  /// Code sent by SMS.
  ///
  /// SMSで送られたコード。
  final String code;
}

/// {@macro change_phone_number_auth_provider}
///
/// Pass the phone number in [phoneNumber] and the SMS language setting in [locale].
///
/// [phoneNumber]で電話番号、[locale]にSMSの言語設定を渡します。
///
/// {@macro sms_auth}
class SmsChangePhoneNumberAuthProvider extends ChangePhoneNumberAuthProvider {
  /// {@macro change_phone_number_auth_provider}
  ///
  /// Pass the phone number in [phoneNumber] and the SMS language setting in [locale].
  ///
  /// [phoneNumber]で電話番号、[locale]にSMSの言語設定を渡します。
  ///
  /// {@macro sms_auth}
  const SmsChangePhoneNumberAuthProvider({
    required this.phoneNumber,
    this.locale,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPhoneAuthProviderId;

  @override
  final String phoneNumber;
  @override
  final Locale? locale;
}

/// {@macro confirm_change_phone_number_auth_provider}
///
/// Pass the code sent by SMS at [code].
///
/// [code]でSMSで送られたコードを渡します。
///
/// {@macro sms_auth}
class SmsConfirmChangePhoneNumberAuthProvider
    extends ConfirmChangePhoneNumberAuthProvider {
  /// {@macro confirm_change_phone_number_auth_provider}
  ///
  /// Pass the code sent by SMS at [code].
  ///
  /// [code]でSMSで送られたコードを渡します。
  ///
  /// {@macro sms_auth}
  const SmsConfirmChangePhoneNumberAuthProvider({
    required this.code,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPhoneAuthProviderId;

  @override
  final String code;
}
