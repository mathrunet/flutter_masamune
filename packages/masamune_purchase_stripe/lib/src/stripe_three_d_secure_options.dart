part of "/masamune_purchase_stripe.dart";

/// Stripe's 3D Secure (mainly server side) setup.
///
/// This is required when sending out 3D Secure authentication information by e-mail.
///
/// ストライプの3Dセキュア（主にサーバー側）の設定。
///
/// メールで3Dセキュア認証の案内を出す際に必要になります。
@immutable
class StripeThreeDSecureOptions {
  /// Stripe's 3D Secure (mainly server side) setup.
  ///
  /// This is required when sending out 3D Secure authentication information by e-mail.
  ///
  /// ストライプの3Dセキュア（主にサーバー側）の設定。
  ///
  /// メールで3Dセキュア認証の案内を出す際に必要になります。
  const StripeThreeDSecureOptions({
    this.redirectFunctionPath = "stripe_webhook_secure",
    this.successPath = "secure/success.html",
    this.failurePath = "secure/failure.html",
    this.acceptLanguage = const ["ja", "en", "zh"],
    this.emailTitle = "Please perform 3D Secure authentication",
    this.emailContent = "Please perform 3D Secure authentication.\n\n{url}",
  });

  /// Path of Functions to redirect to.
  ///
  /// リダイレクト先のFunctionsのパス。
  final String redirectFunctionPath;

  /// Redirect URL on success.
  ///
  /// 成功時のリダイレクトURL。
  final String successPath;

  /// Redirect URL in case of failure.
  ///
  /// 失敗時のリダイレクトURL。
  final String failurePath;

  /// List of languages that implement redirect URLs.
  ///
  /// リダイレクトURLを実装する言語一覧。
  final List<String> acceptLanguage;

  /// Default 3D Secure information email title.
  ///
  /// デフォルトの3Dセキュア案内メールタイトル。
  final String emailTitle;

  /// Default 3D secure information email content.
  ///
  /// デフォルトの3Dセキュア案内メールコンテンツ。
  final String emailContent;
}
