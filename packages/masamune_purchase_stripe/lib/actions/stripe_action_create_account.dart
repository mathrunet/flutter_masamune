part of "/masamune_purchase_stripe.dart";

/// Action type after the account is created.
///
/// アカウントを作成した後のアクションタイプ。
enum StripeCreateAccountNextActionType {
  /// Nothing.
  ///
  /// なにもしない。
  none,

  /// Account Registration.
  ///
  /// アカウント登録。
  registration,
}

/// [StripeFunctionsAction] for creating a Stripe account.
///
/// Stripeのアカウント作成を行うための[StripeFunctionsAction]。
class StripeCreateAccountAction
    extends StripeFunctionsAction<StripeCreateAccountActionResponse> {
  /// [StripeFunctionsAction] for creating a Stripe account.
  ///
  /// Stripeのアカウント作成を行うための[StripeFunctionsAction]。
  const StripeCreateAccountAction({
    required this.userId,
    required this.refreshUrl,
    required this.returnUrl,
    this.locale = const Locale("en", "US"),
  });

  /// ID of the account to be created.
  ///
  /// 作成するアカウントのID。
  final String userId;

  /// Locale on the account creation screen.
  ///
  /// アカウント作成画面のロケール。
  final Locale locale;

  /// URL for canceled account creation.
  ///
  /// アカウント作成をキャンセルした場合のURL。
  final Uri refreshUrl;

  /// URL for successful account creation.
  ///
  /// アカウント作成を成功させた場合のURL。
  final Uri returnUrl;

  @override
  final String mode = "create_account";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "locale": "${locale.languageCode}_${locale.countryCode}",
      "refreshUrl": refreshUrl.toString(),
      "returnUrl": returnUrl.toString(),
    };
  }

  @override
  StripeCreateAccountActionResponse toResponse(DynamicMap map) {
    if (map.isEmpty) {
      throw Exception("Failed to get response from $mode.");
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

/// [StripeFunctionsActionResponse] for creating a Stripe account.
///
/// Stripeのアカウント作成を行うための[StripeFunctionsActionResponse]。
class StripeCreateAccountActionResponse extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] for creating a Stripe account.
  ///
  /// Stripeのアカウント作成を行うための[StripeFunctionsActionResponse]。
  const StripeCreateAccountActionResponse({
    this.nextAction = StripeCreateAccountNextActionType.none,
    this.endpoint,
    this.accountId,
  });

  /// Next Action.
  ///
  /// 次のアクション。
  final StripeCreateAccountNextActionType nextAction;

  /// Endpoints required for the action.
  ///
  /// アクションに必要なエンドポイント。
  final Uri? endpoint;

  /// Account ID created.
  ///
  /// 作成したアカウントID。
  final String? accountId;
}
