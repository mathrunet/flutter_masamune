part of masamune_purchase_stripe;

/// Controller for stripe authorization.
///
/// [authorization] to authorize the user associated with [userId].
///
/// [Exception] will be raised if the payment information associated with [userId] is not set.
///
/// ストライプのオーソリを行うためのコントローラー。
///
/// [authorization]を実行することで[userId]に関連するユーザーのオーソリを行います。
///
/// [userId]に関連付けられた支払い情報が設定されていない場合は[Exception]が発生します。
class StripeAuthorization
    extends MasamuneControllerBase<void, StripePurchaseMasamuneAdapter> {
  /// Controller for stripe authorization.
  ///
  /// [authorization] to authorize the user associated with [userId].
  ///
  /// [Exception] will be raised if the payment information associated with [userId] is not set.
  ///
  /// ストライプのオーソリを行うためのコントローラー。
  ///
  /// [authorization]を実行することで[userId]に関連するユーザーのオーソリを行います。
  ///
  /// [userId]に関連付けられた支払い情報が設定されていない場合は[Exception]が発生します。
  StripeAuthorization({required this.userId});

  /// Query for StripeAuthorization.
  ///
  /// ```dart
  /// appRef.conroller(StripeAuthorization.query(parameters));   // Get from application scope.
  /// ref.app.conroller(StripeAuthorization.query(parameters));  // Watch at application scope.
  /// ref.page.conroller(StripeAuthorization.query(parameters)); // Watch at page scope.
  /// ```
  static const query = _$StripeAuthorizationQuery();

  @override
  StripePurchaseMasamuneAdapter get primaryAdapter =>
      StripePurchaseMasamuneAdapter.primary;

  /// User ID in the application.
  ///
  /// アプリ内のユーザーID。
  final String userId;

  Completer<void>? _completer;

  /// Check if [priceAmount] is available for payment.
  ///
  /// If an error occurs, [Exception] is returned.
  ///
  /// If you set [online] to `true`, WebView will be passed to [builder] when credit card 3D secure authentication is required and authentication can continue.
  ///
  /// If [online] is `false`, you can authenticate by e-mail.
  ///
  /// [priceAmount]が支払い可能かどうかをチェックします。
  ///
  /// エラーが発生した場合は[Exception]が返されます。
  ///
  /// [online]を`true`にすると、クレジットカードの3Dセキュア認証が必要な場合[builder]にWebViewが渡され認証を続けることができます。
  ///
  /// [online]が`false`の場合、メールにて認証を行うことができます。
  Future<void> authorization({
    required double priceAmount,
    Locale locale = const Locale("en", "US"),
    bool online = true,
    required void Function(
      Uri endpoint,
      Widget webView,
      VoidCallback onClosed,
    ) builder,
    VoidCallback? onClosed,
    String? emailTitleOnRequired3DSecure,
    String? emailContentOnRequired3DSecure,
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    Completer<void>? internalCompleter = Completer<void>();
    try {
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;
      final callbackHost = StripePurchaseMasamuneAdapter
          .primary.callbackURLSchemeOrHost
          .toString()
          .trimQuery()
          .trimString("/");
      final returnPathOptions =
          StripePurchaseMasamuneAdapter.primary.returnPathOptions;

      final response = await functionsAdapter.stipe(
        action: StripeAuthorizationAction(
          userId: userId,
          priceAmount: priceAmount,
          online: online,
          currency: StripePurchaseMasamuneAdapter.primary.currency,
          email: StripeMail(
            from: StripePurchaseMasamuneAdapter.primary.supportEmail,
            title: emailTitleOnRequired3DSecure ??
                StripePurchaseMasamuneAdapter
                    .primary.threeDSecureOptions.emailTitle,
            content: emailContentOnRequired3DSecure ??
                StripePurchaseMasamuneAdapter
                    .primary.threeDSecureOptions.emailContent,
          ),
          returnUrl: online
              ? Uri.parse(
                  "$callbackHost/${returnPathOptions.finishedOnAuthorization.trimString("/")}")
              : Uri.parse(
                  "${functionsAdapter.endpoint}/${StripePurchaseMasamuneAdapter.primary.threeDSecureOptions.redirectFunctionPath}"),
        ),
      );

      if (response == null || response.authorizedId.isEmpty) {
        throw Exception("Response is invalid.");
      }
      bool authenticated = true;
      onCompleted() {
        if (authenticated) {
          internalCompleter?.complete();
          internalCompleter = null;
        } else {
          internalCompleter
              ?.completeError(Exception("3D Secure authentication failed."));
          internalCompleter = null;
        }
      }

      if (response.nextActionUrl != null) {
        final webView = StripeWebview(
          response.nextActionUrl!,
          shouldOverrideUrlLoading: (url) {
            final path = url.trimQuery().replaceAll(callbackHost, "");
            if (path ==
                "/${returnPathOptions.finishedOnAuthorization.trimString("/")}") {
              onClosed?.call();
              onCompleted.call();
              return StripeNavigationActionPolicy.cancel;
            }
            final uri = Uri.parse(url);
            if (uri.host == "hooks.stripe.com" &&
                uri.queryParameters.containsKey("authenticated")) {
              authenticated = uri.queryParameters["authenticated"] == "true";
            }
            return StripeNavigationActionPolicy.allow;
          },
          onCloseWindow: () {
            onCompleted();
          },
        );
        builder.call(response.nextActionUrl!, webView, onCompleted);
        await internalCompleter!.future;
      }
      final responseConfirm = await functionsAdapter.stipe(
        action: StripeConfirmAuthorizationAction(
          authorizedId: response.authorizedId,
        ),
      );
      if (responseConfirm == null) {
        throw Exception("Response is invalid.");
      }
      _completer?.complete();
      _completer = null;
      internalCompleter?.complete();
      internalCompleter = null;
      notifyListeners();
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      internalCompleter?.completeError(e);
      internalCompleter = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
      internalCompleter?.complete();
      internalCompleter = null;
    }
  }
}

@immutable
class _$StripeAuthorizationQuery {
  const _$StripeAuthorizationQuery();

  @useResult
  _$_StripeAuthorizationQuery call({
    required String userId,
  }) =>
      _$_StripeAuthorizationQuery(
        hashCode.toString(),
        userId: userId,
      );
}

@immutable
class _$_StripeAuthorizationQuery
    extends ControllerQueryBase<StripeAuthorization> {
  const _$_StripeAuthorizationQuery(
    this._name, {
    required this.userId,
  });

  final String _name;
  final String userId;

  @override
  StripeAuthorization Function() call(Ref ref) {
    return () => StripeAuthorization(userId: userId);
  }

  @override
  String get name => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
