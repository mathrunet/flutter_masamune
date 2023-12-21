part of '/katana_auth.dart';

/// An adapter used to execute various methods of [Authentication].
///
/// Provides information for processing by the method defined in [providerId].
///
/// [Authentication]の各種メソッドを実行するために利用するアダプター。
///
/// [providerId]で定義された方法によって処理を行うための情報を提供します。
abstract class AuthProvider {
  /// An adapter used to execute various methods of [Authentication].
  ///
  /// Provides information for processing by the method defined in [providerId].
  ///
  /// [Authentication]の各種メソッドを実行するために利用するアダプター。
  ///
  /// [providerId]で定義された方法によって処理を行うための情報を提供します。
  const AuthProvider();

  /// ID that defines the provider's process.
  ///
  /// Basically, it is defined based on firebase's `PROVIDER_ID`.
  ///
  /// プロバイダーの処理を定義したID。
  ///
  /// 基本的にfirebaseの`PROVIDER_ID`をベースに定義されます。
  String get providerId;
}

/// {@template create_auth_provider}
/// [AuthProvider] for performing [Authentication.create].
///
/// [Authentication.create]を実行するための[AuthProvider]。
/// {@endtemplate}
abstract class CreateAuthProvider extends AuthProvider {
  /// {@template create_auth_provider}
  /// [AuthProvider] for performing [Authentication.create].
  ///
  /// [Authentication.create]を実行するための[AuthProvider]。
  /// {@endtemplate}
  const CreateAuthProvider();
}

/// {@template register_auth_provider}
/// [AuthProvider] for performing [Authentication.register].
///
/// [Authentication.register]を実行するための[AuthProvider]。
/// {@endtemplate}
abstract class RegisterAuthProvider extends AuthProvider {
  /// {@template register_auth_provider}
  /// [AuthProvider] for performing [Authentication.register].
  ///
  /// [Authentication.register]を実行するための[AuthProvider]。
  /// {@endtemplate}
  const RegisterAuthProvider();
}

/// {@template sign_in_auth_provider}
/// [AuthProvider] for performing [Authentication.signIn].
///
/// [Authentication.signIn]を実行するための[AuthProvider]。
/// {@endtemplate}
abstract class SignInAuthProvider extends AuthProvider {
  /// {@template sign_in_auth_provider}
  /// [AuthProvider] for performing [Authentication.signIn].
  ///
  /// [Authentication.signIn]を実行するための[AuthProvider]。
  /// {@endtemplate}
  const SignInAuthProvider();
}

/// {@template confirm_sign_in_auth_provider}
/// [AuthProvider] for performing [Authentication.confirmSignIn].
///
/// [Authentication.confirmSignIn]を実行するための[AuthProvider]。
/// {@endtemplate}
abstract class ConfirmSignInAuthProvider extends AuthProvider {
  /// {@template confirm_sign_in_auth_provider}
  /// [AuthProvider] for performing [Authentication.confirmSignIn].
  ///
  /// [Authentication.confirmSignIn]を実行するための[AuthProvider]。
  /// {@endtemplate}
  const ConfirmSignInAuthProvider();
}

/// {@template re_auth_provider}
/// [AuthProvider] for performing [Authentication.reauth].
///
/// [Authentication.reauth]を実行するための[AuthProvider]。
/// {@endtemplate}
abstract class ReAuthProvider extends AuthProvider {
  /// {@template re_auth_provider}
  /// [AuthProvider] for performing [Authentication.reauth].
  ///
  /// [Authentication.reauth]を実行するための[AuthProvider]。
  /// {@endtemplate}
  const ReAuthProvider();
}

/// {@template verify_auth_provider}
/// [AuthProvider] for performing [Authentication.verify].
///
/// [Authentication.verify]を実行するための[AuthProvider]。
/// {@endtemplate}
abstract class VerifyAuthProvider extends AuthProvider {
  /// {@template verify_auth_provider}
  /// [AuthProvider] for performing [Authentication.verify].
  ///
  /// [Authentication.verify]を実行するための[AuthProvider]。
  /// {@endtemplate}
  const VerifyAuthProvider();
}

/// {@template reset_auth_provider}
/// [AuthProvider] for performing [Authentication.reset].
///
/// [Authentication.reset]を実行するための[AuthProvider]。
/// {@endtemplate}
abstract class ResetAuthProvider extends AuthProvider {
  /// {@template reset_auth_provider}
  /// [AuthProvider] for performing [Authentication.reset].
  ///
  /// [Authentication.reset]を実行するための[AuthProvider]。
  /// {@endtemplate}
  const ResetAuthProvider();
}

/// {@template change_auth_provider}
/// [AuthProvider] for performing [Authentication.change].
///
/// [Authentication.change]を実行するための[AuthProvider]。
/// {@endtemplate}
abstract class ChangeAuthProvider extends AuthProvider {
  /// {@template change_auth_provider}
  /// [AuthProvider] for performing [Authentication.change].
  ///
  /// [Authentication.change]を実行するための[AuthProvider]。
  /// {@endtemplate}
  const ChangeAuthProvider();
}

/// {@template confirm_change_auth_provider}
/// [AuthProvider] for performing [Authentication.confirmChange].
///
/// [Authentication.confirmChange]を実行するための[AuthProvider]。
/// {@endtemplate}
abstract class ConfirmChangeAuthProvider extends AuthProvider {
  /// {@template confirm_change_auth_provider}
  /// [AuthProvider] for performing [Authentication.confirmChange].
  ///
  /// [Authentication.confirmChange]を実行するための[AuthProvider]。
  /// {@endtemplate}
  const ConfirmChangeAuthProvider();
}

/// {@template change_email_auth_provider}
/// [AuthProvider] for performing [Authentication.change].
///
/// Used to change your e-mail address.
///
/// [Authentication.change]を実行するための[AuthProvider]。
///
/// メールアドレスを変更する際に利用します。
/// {@endtemplate}
abstract class ChangeEmailAuthProvider extends ChangeAuthProvider {
  /// {@template change_email_auth_provider}
  /// [AuthProvider] for performing [Authentication.change].
  ///
  /// Used to change your e-mail address.
  ///
  /// [Authentication.change]を実行するための[AuthProvider]。
  ///
  /// メールアドレスを変更する際に利用します。
  /// {@endtemplate}
  const ChangeEmailAuthProvider();

  /// Changed email address.
  ///
  /// 変更後のメールアドレス。
  String get email;

  /// Locale to send email for changes.
  ///
  /// 変更用のメールを送るためのロケール。
  Locale? get locale;
}

/// {@template change_password_auth_provider}
/// [AuthProvider] for performing [Authentication.change].
///
/// Used to change your password.
///
/// [Authentication.change]を実行するための[AuthProvider]。
///
/// パスワードを変更する際に利用します。
/// {@endtemplate}
abstract class ChangePasswordAuthProvider extends ChangeAuthProvider {
  /// {@template change_password_auth_provider}
  /// [AuthProvider] for performing [Authentication.change].
  ///
  /// Used to change your password.
  ///
  /// [Authentication.change]を実行するための[AuthProvider]。
  ///
  /// パスワードを変更する際に利用します。
  /// {@endtemplate}
  const ChangePasswordAuthProvider();

  /// Changed password.
  ///
  /// 変更後のパスワード。
  String get password;

  /// Locale to send email for changes.
  ///
  /// 変更用のメールを送るためのロケール。
  Locale? get locale;
}

/// {@template change_phone_number_auth_provider}
/// [AuthProvider] for performing [Authentication.change].
///
/// Used to change phone numbers.
///
/// [Authentication.change]を実行するための[AuthProvider]。
///
/// 電話番号を変更する際に利用します。
/// {@endtemplate}
abstract class ChangePhoneNumberAuthProvider extends ChangeAuthProvider {
  /// {@template change_phone_number_auth_provider}
  /// [AuthProvider] for performing [Authentication.change].
  ///
  /// Used to change phone numbers.
  ///
  /// [Authentication.change]を実行するための[AuthProvider]。
  ///
  /// 電話番号を変更する際に利用します。
  /// {@endtemplate}
  const ChangePhoneNumberAuthProvider();

  /// Changed phone number.
  ///
  /// 変更後の電話番号。
  String get phoneNumber;

  /// Locale to send SMS for change.
  ///
  /// 変更用のSMSを送るためのロケール。
  Locale? get locale;

  /// Country code.
  ///
  /// If you specify `[countryNumber]', the prefix ` [countryNumber]` is added to [phoneNumber].
  ///
  /// 国の番号。
  ///
  /// [countryNumber]を指定すると`+[countryNumber]`というプレフィックスが[phoneNumber]に付与されます。
  String? get countryNumber;
}

/// {@template confirm_change_phone_number_auth_provider}
/// [AuthProvider] for performing [Authentication.confirmChange].
///
/// Used to finalize changes after changes have been made in [ChangePhoneNumberAuthProvider].
///
/// [Authentication.confirmChange]を実行するための[AuthProvider]。
///
/// [ChangePhoneNumberAuthProvider]で変更を行った後、変更を確定させるために利用します。
/// {@endtemplate}
abstract class ConfirmChangePhoneNumberAuthProvider
    extends ConfirmChangeAuthProvider {
  /// {@template confirm_change_phone_number_auth_provider}
  /// [AuthProvider] for performing [Authentication.confirmChange].
  ///
  /// Used to finalize changes after changes have been made in [ChangePhoneNumberAuthProvider].
  ///
  /// [Authentication.confirmChange]を実行するための[AuthProvider]。
  ///
  /// [ChangePhoneNumberAuthProvider]で変更を行った後、変更を確定させるために利用します。
  /// {@endtemplate}
  const ConfirmChangePhoneNumberAuthProvider();

  /// Authentication code sent from SMS.
  ///
  /// SMSから送られてきた認証コード。
  String get code;
}
