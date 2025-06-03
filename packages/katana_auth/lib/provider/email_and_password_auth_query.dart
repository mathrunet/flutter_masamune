part of "/katana_auth.dart";

const _kPasswordAuthProviderId = "password";

/// {@template email_and_password_auth}
/// An `AuthQuery` to authenticate by email and password.
///
/// Unlike other forms of authentication, it is necessary to register first.
///
/// You will then be able to log in and change your email address and password.
///
/// If you forget your password, we can also send you a reset e-mail.
///
/// Eメールとパスワードでの認証を行うための`AuthQuery`。
///
/// 他の認証とは違い、最初に登録を行う必要があります。
///
/// その後、ログインを行ったりメールアドレスやパスワードの変更が可能になります。
///
/// また、パスワードを忘れた場合、リセットメールを送ることも可能です。
/// {@endtemplate}
class EmailAndPasswordAuthQuery {
  const EmailAndPasswordAuthQuery._();

  /// ID that defines the provider's process.
  ///
  /// Basically, it is defined based on firebase's `PROVIDER_ID`.
  ///
  /// プロバイダーの処理を定義したID。
  ///
  /// 基本的にfirebaseの`PROVIDER_ID`をベースに定義されます。
  static const String providerId = _kPasswordAuthProviderId;

  /// {@macro create_auth_provider}
  ///
  /// Please give us your email address in [email] and your password in [password].
  ///
  /// [email]にメールアドレス、[password]にパスワードを渡してください。
  ///
  /// {@macro email_and_password_auth}
  static EmailAndPasswordCreateAuthProvider create({
    required String email,
    required String password,
  }) {
    return EmailAndPasswordCreateAuthProvider(
      email: email,
      password: password,
    );
  }

  /// {@macro register_auth_provider}
  ///
  /// Please give us your email address in [email] and your password in [password].
  ///
  /// [email]にメールアドレス、[password]にパスワードを渡してください。
  ///
  /// {@macro email_and_password_auth}
  static EmailAndPasswordRegisterAuthProvider register({
    required String email,
    required String password,
  }) {
    return EmailAndPasswordRegisterAuthProvider(
      email: email,
      password: password,
    );
  }

  /// {@macro sign_in_auth_provider}
  ///
  /// Please give us your email address in [email] and your password in [password].
  ///
  /// [email]にメールアドレス、[password]にパスワードを渡してください。
  ///
  /// {@macro email_and_password_auth}
  static EmailAndPasswordSignInAuthProvider signIn({
    required String email,
    required String password,
  }) {
    return EmailAndPasswordSignInAuthProvider(email: email, password: password);
  }

  /// {@macro re_auth_provider}
  ///
  /// Pass the password to [password].
  ///
  /// [password]にパスワードを渡してください。
  ///
  /// {@macro email_and_password_auth}
  static EmailAndPasswordReAuthProvider reauth({
    required String password,
  }) {
    return EmailAndPasswordReAuthProvider(password: password);
  }

  /// {@macro reset_auth_provider}
  ///
  /// Pass the email address in [email] and the language setting of the email for the reset in [locale].
  ///
  /// [email]にメールアドレス、[locale]にリセット用のEメールの言語設定を渡します。
  ///
  /// {@macro email_and_password_auth}
  static EmailAndPasswordResetAuthProvider reset({
    required String email,
    Locale? locale,
  }) {
    return EmailAndPasswordResetAuthProvider(email: email, locale: locale);
  }

  /// {@macro verify_auth_provider}
  ///
  /// Pass the language setting of the authentication email to [locale].
  ///
  /// [locale]に認証用のEメールの言語設定を渡します。
  ///
  /// {@macro email_and_password_auth}
  static EmailAndPasswordVerifyAuthProvider verify({
    Locale? locale,
  }) {
    return EmailAndPasswordVerifyAuthProvider(locale: locale);
  }

  /// {@macro change_email_auth_provider}
  ///
  /// Pass the email address in [email] and the language setting of the email for the change in [locale].
  ///
  /// [email]にメールアドレス、[locale]に変更用のEメールの言語設定を渡します。
  ///
  /// {@macro email_and_password_auth}
  static EmailAndPasswordChangeEmailAuthProvider changeEmail({
    required String email,
    Locale? locale,
  }) {
    return EmailAndPasswordChangeEmailAuthProvider(
      email: email,
      locale: locale,
    );
  }

  /// {@macro change_password_auth_provider}
  ///
  /// Pass the password in [password] and the language setting of the email to change in [locale].
  ///
  /// [password]にパスワード、[locale]に変更用のEメールの言語設定を渡します。
  ///
  /// {@macro email_and_password_auth}
  static EmailAndPasswordChangePasswordAuthProvider changePassword({
    required String password,
    Locale? locale,
  }) {
    return EmailAndPasswordChangePasswordAuthProvider(
      password: password,
      locale: locale,
    );
  }
}

/// {@macro create_auth_provider}
///
/// Pass the email address in [email], the password in [password], and the language setting of the registration email in [locale].
///
/// [email]にメールアドレス、[password]にパスワード、[locale]に登録用のEメールの言語設定を渡します。
///
/// {@macro email_and_password_auth}
class EmailAndPasswordCreateAuthProvider extends CreateAuthProvider {
  /// {@macro create_auth_provider}
  ///
  /// Pass the email address in [email], the password in [password], and the language setting of the registration email in [locale].
  ///
  /// [email]にメールアドレス、[password]にパスワード、[locale]に登録用のEメールの言語設定を渡します。
  ///
  /// {@macro email_and_password_auth}
  const EmailAndPasswordCreateAuthProvider({
    required this.email,
    required this.password,
    this.locale,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPasswordAuthProviderId;

  /// Email address.
  ///
  /// メールアドレス。
  final String email;

  /// Password.
  ///
  /// パスワード。
  final String password;

  /// Language preference for registration e-mails.
  ///
  /// 登録用のEメールの言語設定。
  final Locale? locale;
}

/// {@macro register_auth_provider}
///
/// Pass the email address in [email], the password in [password], and the language setting of the registration email in [locale].
///
/// [email]にメールアドレス、[password]にパスワード、[locale]に登録用のEメールの言語設定を渡します。
///
/// {@macro email_and_password_auth}
class EmailAndPasswordRegisterAuthProvider extends RegisterAuthProvider {
  /// {@macro register_auth_provider}
  ///
  /// Pass the email address in [email], the password in [password], and the language setting of the registration email in [locale].
  ///
  /// [email]にメールアドレス、[password]にパスワード、[locale]に登録用のEメールの言語設定を渡します。
  ///
  /// {@macro email_and_password_auth}
  const EmailAndPasswordRegisterAuthProvider({
    required this.email,
    required this.password,
    this.locale,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPasswordAuthProviderId;

  /// Email address.
  ///
  /// メールアドレス。
  final String email;

  /// Password.
  ///
  /// パスワード。
  final String password;

  /// Language preference for registration e-mails.
  ///
  /// 登録用のEメールの言語設定。
  final Locale? locale;
}

/// {@macro sign_in_auth_provider}
///
/// Please give us your email address in [email] and your password in [password].
///
/// [email]にメールアドレス、[password]にパスワードを渡してください。
///
/// {@macro email_and_password_auth}
class EmailAndPasswordSignInAuthProvider extends SignInAuthProvider {
  /// {@macro sign_in_auth_provider}
  ///
  /// Please give us your email address in [email] and your password in [password].
  ///
  /// [email]にメールアドレス、[password]にパスワードを渡してください。
  ///
  /// {@macro email_and_password_auth}
  const EmailAndPasswordSignInAuthProvider({
    required this.email,
    required this.password,
    super.allowMultiProvider = true,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPasswordAuthProviderId;

  /// Email address.
  ///
  /// メールアドレス。
  final String email;

  /// Password.
  ///
  /// パスワード。
  final String password;
}

/// {@macro re_auth_provider}
///
/// Pass the password to [password].
///
/// [password]にパスワードを渡してください。
///
/// {@macro email_and_password_auth}
class EmailAndPasswordReAuthProvider extends ReAuthProvider {
  /// {@macro re_auth_provider}
  ///
  /// Pass the password to [password].
  ///
  /// [password]にパスワードを渡してください。
  ///
  /// {@macro email_and_password_auth}
  const EmailAndPasswordReAuthProvider({
    required this.password,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPasswordAuthProviderId;

  /// Password.
  ///
  /// パスワード。
  final String password;
}

/// {@macro reset_auth_provider}
///
/// Pass the email address in [email], the language setting of the reset email in [locale], and the URL to be guided after the password reset in [continueUrl].
///
/// [email]にメールアドレス、[locale]にリセット用のEメールの言語設定、[continueUrl]にパスワードリセット後に案内するURLを渡します。
///
/// {@macro email_and_password_auth}
class EmailAndPasswordResetAuthProvider extends ResetAuthProvider {
  /// {@macro reset_auth_provider}
  ///
  /// Pass the email address in [email], the language setting of the reset email in [locale], and the URL to be guided after the password reset in [continueUrl].
  ///
  /// [email]にメールアドレス、[locale]にリセット用のEメールの言語設定、[continueUrl]にパスワードリセット後に案内するURLを渡します。
  ///
  /// {@macro email_and_password_auth}
  const EmailAndPasswordResetAuthProvider({
    required this.email,
    this.locale,
    this.continueUrl,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPasswordAuthProviderId;

  /// Email address.
  ///
  /// メールアドレス。
  final String email;

  /// URL to be guided after password reset.
  ///
  /// パスワードリセット後に案内するURL。
  final String? continueUrl;

  /// Email language settings for reset.
  ///
  /// リセット用のEメールの言語設定。
  final Locale? locale;
}

/// {@macro verify_auth_provider}
///
/// Pass the language setting of the authentication email to [locale].
///
/// [locale]に認証用のEメールの言語設定を渡します。
///
/// {@macro email_and_password_auth}
class EmailAndPasswordVerifyAuthProvider extends VerifyAuthProvider {
  /// {@macro verify_auth_provider}
  ///
  /// Pass the language setting of the authentication email to [locale].
  ///
  /// [locale]に認証用のEメールの言語設定を渡します。
  ///
  /// {@macro email_and_password_auth}
  const EmailAndPasswordVerifyAuthProvider({
    this.locale,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPasswordAuthProviderId;

  /// Language settings for authentication e-mails.
  ///
  /// 認証用のEメールの言語設定。
  final Locale? locale;
}

/// {@macro change_email_auth_provider}
///
/// Pass the email address in [email] and the language setting of the email for the change in [locale].
///
/// [email]にメールアドレス、[locale]に変更用のEメールの言語設定を渡します。
///
/// {@macro email_and_password_auth}
class EmailAndPasswordChangeEmailAuthProvider extends ChangeEmailAuthProvider {
  /// {@macro change_email_auth_provider}
  ///
  /// Pass the email address in [email] and the language setting of the email for the change in [locale].
  ///
  /// [email]にメールアドレス、[locale]に変更用のEメールの言語設定を渡します。
  ///
  /// {@macro email_and_password_auth}
  const EmailAndPasswordChangeEmailAuthProvider({
    required this.email,
    this.locale,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPasswordAuthProviderId;

  @override
  final String email;
  @override
  final Locale? locale;
}

/// {@macro change_password_auth_provider}
///
/// Pass the password in [password] and the language setting of the email to change in [locale].
///
/// [password]にパスワード、[locale]に変更用のEメールの言語設定を渡します。
///
/// {@macro email_and_password_auth}
class EmailAndPasswordChangePasswordAuthProvider
    extends ChangePasswordAuthProvider {
  /// {@macro change_password_auth_provider}
  ///
  /// Pass the password in [password] and the language setting of the email to change in [locale].
  ///
  /// [password]にパスワード、[locale]に変更用のEメールの言語設定を渡します。
  ///
  /// {@macro email_and_password_auth}
  const EmailAndPasswordChangePasswordAuthProvider({
    required this.password,
    this.locale,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPasswordAuthProviderId;

  @override
  final String password;
  @override
  final Locale? locale;
}
