part of '/katana_auth.dart';

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

  /// ID that defines the provider's process.
  ///
  /// Basically, it is defined based on firebase's `PROVIDER_ID`.
  ///
  /// プロバイダーの処理を定義したID。
  ///
  /// 基本的にfirebaseの`PROVIDER_ID`をベースに定義されます。
  static const String providerId = _kPhoneAuthProviderId;

  /// {@macro sign_in_auth_provider}
  ///
  /// Pass the phone number in [phoneNumber] and the SMS language setting in [locale].
  ///
  /// If you specify `[countryNumber]', the prefix ` [countryNumber]` is added to [phoneNumber].
  ///
  /// [phoneNumber]で電話番号、[locale]にSMSの言語設定を渡します。
  ///
  /// [countryNumber]を指定すると`+[countryNumber]`というプレフィックスが[phoneNumber]に付与されます。
  ///
  /// {@macro sms_auth}
  static SmsSignInAuthProvider signIn({
    required String phoneNumber,
    required String countryNumber,
    Locale? locale,
  }) {
    return SmsSignInAuthProvider(
      phoneNumber: phoneNumber,
      locale: locale,
      countryNumber: countryNumber,
    );
  }

  /// {@macro confirm_sign_in_auth_provider}
  ///
  /// Pass the code sent by SMS at [code].
  ///
  /// [code]でSMSで送られたコードを渡します。
  ///
  /// {@macro sms_auth}
  static SmsConfirmSignInAuthProvider confirmSignIn({
    required String code,
  }) {
    return SmsConfirmSignInAuthProvider(code: code);
  }

  /// {@macro change_phone_number_auth_provider}
  ///
  /// Pass the phone number in [phoneNumber] and the SMS language setting in [locale].
  ///
  /// If you specify `[countryNumber]', the prefix ` [countryNumber]` is added to [phoneNumber].
  ///
  /// [phoneNumber]で電話番号、[locale]にSMSの言語設定を渡します。
  ///
  /// [countryNumber]を指定すると`+[countryNumber]`というプレフィックスが[phoneNumber]に付与されます。
  ///
  /// {@macro sms_auth}
  static SmsChangePhoneNumberAuthProvider changePhoneNumber({
    required String phoneNumber,
    required String countryNumber,
    Locale? locale,
    VoidCallback? onAutoVerificationCompleted,
    void Function(Exception error)? onAutoVerificationFailed,
  }) {
    return SmsChangePhoneNumberAuthProvider(
      phoneNumber: phoneNumber,
      locale: locale,
      countryNumber: countryNumber,
      onAutoVerificationCompleted: onAutoVerificationCompleted,
      onAutoVerificationFailed: onAutoVerificationFailed,
    );
  }

  /// {@macro confirm_change_phone_number_auth_provider}
  ///
  /// Pass the code sent by SMS at [code].
  ///
  /// [code]でSMSで送られたコードを渡します。
  ///
  /// {@macro sms_auth}
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
/// If you specify `[countryNumber]', the prefix ` [countryNumber]` is added to [phoneNumber].
///
/// [phoneNumber]で電話番号、[locale]にSMSの言語設定を渡します。
///
/// [countryNumber]を指定すると`+[countryNumber]`というプレフィックスが[phoneNumber]に付与されます。
///
/// {@macro sms_auth}
class SmsSignInAuthProvider extends SignInAuthProvider {
  const SmsSignInAuthProvider({
    required this.phoneNumber,
    required this.countryNumber,
    this.locale,
    this.onAutoVerificationCompleted,
    this.onAutoVerificationFailed,
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

  /// Callback for automatically entering the code when an SMS code is received.
  ///
  /// Some terminals do not function.
  ///
  /// SMSのコードを受信したときに自動的にコードを入力する場合のコールバック。
  ///
  /// 機能しない端末もあります。
  final VoidCallback? onAutoVerificationCompleted;

  /// Callback if the code is wrong when the SMS code is received.
  ///
  /// Some terminals do not function.
  ///
  /// SMSのコードを受信したときにコードが違っていた場合のコールバック。
  ///
  /// 機能しない端末もあります。
  final void Function(Exception error)? onAutoVerificationFailed;

  /// Country code.
  ///
  /// If you specify `[countryNumber]', the prefix ` [countryNumber]` is added to [phoneNumber].
  ///
  /// 国の番号。
  ///
  /// [countryNumber]を指定すると`+[countryNumber]`というプレフィックスが[phoneNumber]に付与されます。
  final String countryNumber;
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
    required this.countryNumber,
    this.onAutoVerificationCompleted,
    this.onAutoVerificationFailed,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPhoneAuthProviderId;

  @override
  final String phoneNumber;
  @override
  final Locale? locale;
  @override
  final String countryNumber;
  @override
  final VoidCallback? onAutoVerificationCompleted;
  @override
  final void Function(Exception error)? onAutoVerificationFailed;
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
