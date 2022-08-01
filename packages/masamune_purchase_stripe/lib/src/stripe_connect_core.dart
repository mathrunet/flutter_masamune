part of masamune_purchase_stripe;

class StripeConnectCore {
  const StripeConnectCore._();

  static late final String _serverPath;
  static late final String _callbackUrl;
  static late final String? _debugUserId;
  static late final double _revenue;
  static late final StripeCurrency _currency;
  static late final String _userPath;
  static late final String _paymentPath;
  static late final String _purchasePath;
  static late final String _accountKey;
  static late final String _capabilityKey;
  static late final String _supportEmail;
  static late final String _emailTitleOnRequired3DSecure;
  static late final String _emailContentOnRequired3DSecure;
  static late final String _threeDSecureRedirectFunctionPath;
  static late final String _threeDSecureSuccessPath;
  static late final String _threeDSecureFailurePath;
  static late final List<String> _threeDSecureAcceptLanguage;

  /// True if the data has been initialized.
  static bool get isInitialized => _isInitialized;
  static bool _isInitialized = false;

  static void initialize({
    required String serverPath,
    required double revenue,
    required String callbackUrl,
    StripeCurrency currency = StripeCurrency.usd,
    String? debugUserId,
    String userPath = "stripe/connect/user",
    String paymentPath = "payment",
    String purchasePath = "purchase",
    String accountKey = "account",
    String capabilityKey = "capability",
    required String supportEmail,
    String threeDSecureRedirectFunctionPath = "stripe_secure_webhook",
    String threeDSecureSuccessPath = "secure/success.html",
    String threeDSecureFailurePath = "secure/failure.html",
    List<String> threeDSecureAcceptLanguage = const ["ja", "en", "zh"],
    String emailTitleOnRequired3DSecure =
        "Please perform 3D Secure authentication",
    String emailContentOnRequired3DSecure =
        "Please perform 3D Secure authentication.\n\n{url}",
  }) {
    if (isInitialized) {
      return;
    }
    _serverPath = serverPath;
    _callbackUrl = callbackUrl;
    _revenue = revenue;
    _currency = currency;
    _debugUserId = debugUserId;
    _userPath = userPath;
    _paymentPath = paymentPath;
    _purchasePath = purchasePath;
    _accountKey = accountKey;
    _capabilityKey = capabilityKey;
    _supportEmail = supportEmail;
    _emailTitleOnRequired3DSecure = emailTitleOnRequired3DSecure;
    _emailContentOnRequired3DSecure = emailContentOnRequired3DSecure;
    _threeDSecureRedirectFunctionPath = threeDSecureRedirectFunctionPath;
    _threeDSecureSuccessPath = threeDSecureSuccessPath;
    _threeDSecureFailurePath = threeDSecureFailurePath;
    _threeDSecureAcceptLanguage = threeDSecureAcceptLanguage;
    final uid = _debugUserId ?? userId;
    if (uid.isEmpty) {
      throw Exception("You are not logged in. Please log in once.");
    }
    _isInitialized = true;
  }
}
