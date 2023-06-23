part of masamune_purchase_stripe;

@immutable
class StripeThreeDSecureOptions {
  const StripeThreeDSecureOptions({
    this.redirectFunctionPath = "stripe_webhook_secure",
    this.successPath = "secure/success.html",
    this.failurePath = "secure/failure.html",
    this.acceptLanguage = const ["ja", "en", "zh"],
    this.emailTitle = "Please perform 3D Secure authentication",
    this.emailContent = "Please perform 3D Secure authentication.\n\n{url}",
  });

  final String redirectFunctionPath;
  final String successPath;
  final String failurePath;
  final List<String> acceptLanguage;
  final String emailTitle;
  final String emailContent;
}
