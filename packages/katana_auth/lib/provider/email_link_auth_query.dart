part of '/katana_auth.dart';

/// {@template email_link_auth}
/// An `AuthQuery` for link authentication via email.
///
/// An email with a link is sent at [signIn], and the link is confirmed at [confirmSignIn] to log in.
///
/// No password will be required.
///
/// After logging in, you will be able to change your e-mail address.
///
/// Eメールでリンク認証を行うための`AuthQuery`。
///
/// [signIn]時にリンク付きのメールを送信し、[confirmSignIn]でリンクを確定してログインを行ないます。
///
/// パスワードが必要なくなります。
///
/// ログイン後、メールアドレスの変更が可能になります。
/// {@endtemplate}
class EmailLinkAuthQuery {
  const EmailLinkAuthQuery._();

  /// ID that defines the provider's process.
  ///
  /// Basically, it is defined based on firebase's `PROVIDER_ID`.
  ///
  /// プロバイダーの処理を定義したID。
  ///
  /// 基本的にfirebaseの`PROVIDER_ID`をベースに定義されます。
  static const String providerId = _kPasswordAuthProviderId;

  /// {@macro sign_in_auth_provider}
  ///
  /// Pass the email address in [email], the link in the email in [url], and the language setting of the authentication email in [locale].
  ///
  /// [email]にメールアドレス、[url]にメールに記載するリンク、[locale]に認証用のEメールの言語設定を渡します。
  ///
  /// {@macro email_link_auth}
  static EmailLinkSignInAuthProvider signIn({
    required String email,
    required String url,
    Locale? locale,
  }) {
    return EmailLinkSignInAuthProvider(
      email: email,
      url: url,
      locale: locale,
    );
  }

  /// {@macro confirm_sign_in_auth_provider}
  ///
  /// Pass [url] the link that was included in the email.
  ///
  /// [url]にメールに記載していたリンクを渡します。
  ///
  /// {@macro email_link_auth}
  static EmailLinkConfirmSignInAuthProvider confirmSignIn({
    required String url,
  }) {
    return EmailLinkConfirmSignInAuthProvider(
      url: url,
    );
  }

  /// {@macro verify_auth_provider}
  ///
  /// Pass the language setting of the authentication email to [locale].
  ///
  /// [locale]に認証用のEメールの言語設定を渡します。
  ///
  /// {@macro email_link_auth}
  static EmailLinkVerifyAuthProvider verify({
    Locale? locale,
  }) {
    return EmailLinkVerifyAuthProvider(locale: locale);
  }

  /// {@macro change_email_auth_provider}
  ///
  /// Pass the email address in [email] and the language setting of the authentication email in [locale].
  ///
  /// [email]にメールアドレス、[locale]に認証用のEメールの言語設定を渡します。
  ///
  /// {@macro email_link_auth}
  static EmailLinkChangeEmailAuthProvider changeEmail({
    required String email,
    Locale? locale,
  }) {
    return EmailLinkChangeEmailAuthProvider(
      email: email,
      locale: locale,
    );
  }
}

/// {@macro sign_in_auth_provider}
///
/// Pass the email address in [email], the link in the email in [url], and the language setting of the authentication email in [locale].
///
/// [email]にメールアドレス、[url]にメールに記載するリンク、[locale]に認証用のEメールの言語設定を渡します。
///
/// {@macro email_link_auth}
class EmailLinkSignInAuthProvider extends SignInAuthProvider {
  /// {@macro sign_in_auth_provider}
  ///
  /// Pass the email address in [email], the link in the email in [url], and the language setting of the authentication email in [locale].
  ///
  /// [email]にメールアドレス、[url]にメールに記載するリンク、[locale]に認証用のEメールの言語設定を渡します。
  ///
  /// {@macro email_link_auth}
  const EmailLinkSignInAuthProvider({
    required this.email,
    required this.url,
    this.locale,
    super.allowMultiProvider = true,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPasswordAuthProviderId;

  /// Email address.
  ///
  /// メールアドレス。
  final String email;

  /// A link to be included in the authentication email.
  ///
  /// 認証用メールに記載するリンク。
  final String url;

  /// Language settings for authentication e-mails.
  ///
  /// 認証用のEメールの言語設定。
  final Locale? locale;
}

/// {@macro confirm_sign_in_auth_provider}
///
/// Pass [url] the link that was included in the email.
///
/// [url]にメールに記載していたリンクを渡します。
///
/// {@macro email_link_auth}
class EmailLinkConfirmSignInAuthProvider extends ConfirmSignInAuthProvider {
  /// {@macro confirm_sign_in_auth_provider}
  ///
  /// Pass [url] the link that was included in the email.
  ///
  /// [url]にメールに記載していたリンクを渡します。
  ///
  /// {@macro email_link_auth}
  const EmailLinkConfirmSignInAuthProvider({
    required this.url,
  });

  @override
  // ignore: avoid_field_initializers_in_const_classes
  final String providerId = _kPasswordAuthProviderId;

  /// The link provided in the authentication email.
  ///
  /// 認証用メールに記載したリンク。
  final String url;
}

/// {@macro verify_auth_provider}
///
/// Pass the language setting of the authentication email to [locale].
///
/// [locale]に認証用のEメールの言語設定を渡します。
///
/// {@macro email_link_auth}
class EmailLinkVerifyAuthProvider extends VerifyAuthProvider {
  /// {@macro verify_auth_provider}
  ///
  /// Pass the language setting of the authentication email to [locale].
  ///
  /// [locale]に認証用のEメールの言語設定を渡します。
  ///
  /// {@macro email_link_auth}
  const EmailLinkVerifyAuthProvider({
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
/// Pass the email address in [email] and the language setting of the authentication email in [locale].
///
/// [email]にメールアドレス、[locale]に認証用のEメールの言語設定を渡します。
///
/// {@macro email_link_auth}
class EmailLinkChangeEmailAuthProvider extends ChangeEmailAuthProvider {
  /// {@macro change_email_auth_provider}
  ///
  /// Pass the email address in [email] and the language setting of the authentication email in [locale].
  ///
  /// [email]にメールアドレス、[locale]に認証用のEメールの言語設定を渡します。
  ///
  /// {@macro email_link_auth}
  const EmailLinkChangeEmailAuthProvider({
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
