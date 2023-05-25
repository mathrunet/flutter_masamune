part of masamune_purchase_stripe;

enum StripeCreateAccountNextActionType {
  none,
  registration,
}

class StripeCreateAccountAction
    extends StripeAction<StripeCreateAccountActionResponse> {
  const StripeCreateAccountAction({
    required this.userId,
    this.locale = const Locale("en", "US"),
    required this.refreshUrl,
    required this.returnUrl,
  });
  final String userId;
  final Locale locale;
  final Uri refreshUrl;
  final Uri returnUrl;

  @override
  final String mode = "create_account";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "locale": "${locale.languageCode}_${locale.countryCode}",
    };
  }

  @override
  StripeCreateAccountActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return StripeCreateAccountActionResponse(
      nextAction: StripeCreateAccountNextActionType.values.firstWhere(
        (e) => e.name == map.get("next", ""),
        orElse: () => StripeCreateAccountNextActionType.none,
      ),
      endpoint: Uri.tryParse(map.get("endpoint", "")),
      accountId: map.get<String?>("accountId", null),
    );
  }
}

class StripeCreateAccountActionResponse extends StripeActionResponse {
  const StripeCreateAccountActionResponse({
    this.nextAction = StripeCreateAccountNextActionType.none,
    this.endpoint,
    this.accountId,
  });

  final StripeCreateAccountNextActionType nextAction;
  final Uri? endpoint;
  final String? accountId;
}
