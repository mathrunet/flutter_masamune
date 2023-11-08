part of '/masamune_purchase_stripe.dart';

/// Set `return_url` when used with Stripe's WebView.
///
/// Mobile is basically used by default, but for the Web, etc., it is possible to set this to direct the user to a specific URL.
///
/// StripeのWebViewで用いる場合の`return_url`の設定。
///
/// モバイルは基本的にデフォルトで利用しますが、Web等の場合こちらを設定して特定のURLに誘導することが可能です。
@immutable
class StripeReturnPathOptions {
  /// Set `return_url` when used with Stripe's WebView.
  ///
  /// Mobile is basically used by default, but for the Web, etc., it is possible to set this to direct the user to a specific URL.
  ///
  /// StripeのWebViewで用いる場合の`return_url`の設定。
  ///
  /// モバイルは基本的にデフォルトで利用しますが、Web等の場合こちらを設定して特定のURLに誘導することが可能です。
  const StripeReturnPathOptions({
    this.cancelOnCreateAccount = "/create_account/cancel",
    this.successOnCreateAccount = "/create_account/success",
    this.finishedOnAuthorization = "/authorization/finished",
    this.successOnCreateCustormerAndPayment =
        "/create_custormer_and_payment/success",
    this.cancelOnCreateCustormerAndPayment =
        "/create_custormer_and_payment/cancel",
    this.finishedOnConfirmPurchase = "/confirm_purchase/finished",
    this.successOnCreateSubscription = "/create_subscription/success",
    this.cancelOnCreateSubscription = "/create_subscription/cancel",
  });

  /// The URL to cancel the account if it was created.
  ///
  /// アカウントを作成した場合のキャンセルURL。
  final String cancelOnCreateAccount;

  /// Success URL for the account created.
  ///
  /// アカウントを作成した場合の成功URL。
  final String successOnCreateAccount;

  /// The URL of the completed authorization.
  ///
  /// オーソリを完了したときのURL。
  final String finishedOnAuthorization;

  /// URL of successfully created customer and payment methods.
  ///
  /// カスタマーおよび支払い方法の作成に成功したときのURL。
  final String successOnCreateCustormerAndPayment;

  /// URL for failed attempts to create customer and payment methods.
  ///
  /// カスタマーおよび支払い方法の作成に失敗したときのURL。
  final String cancelOnCreateCustormerAndPayment;

  /// The URL of the completed payment finalization.
  ///
  /// 支払いの確定を完了したときのURL。
  final String finishedOnConfirmPurchase;

  /// The URL of a successfully created subscription.
  ///
  /// サブスクリプションの作成に成功したときのURL。
  final String successOnCreateSubscription;

  /// The URL of the canceled subscription creation.
  ///
  /// サブスクリプションの作成をキャンセルしたときのURL。
  final String cancelOnCreateSubscription;
}
