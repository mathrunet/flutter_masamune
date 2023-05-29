part of masamune_purchase_stripe;

@immutable
class StripeReturnPathOptions {
  const StripeReturnPathOptions({
    this.refreshOnCreateAccount = "/create_account/refresh",
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

  final String refreshOnCreateAccount;
  final String successOnCreateAccount;
  final String finishedOnAuthorization;
  final String successOnCreateCustormerAndPayment;
  final String cancelOnCreateCustormerAndPayment;
  final String finishedOnConfirmPurchase;
  final String successOnCreateSubscription;
  final String cancelOnCreateSubscription;
}
