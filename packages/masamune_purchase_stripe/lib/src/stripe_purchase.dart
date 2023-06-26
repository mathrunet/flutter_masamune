part of masamune_purchase_stripe;

/// Controller for the actual payment by the customer with the payment method created in [StripePayment.create].
///
/// Execute [create]->[confirm]->[capture] in that order to cause the actual movement of money.
///
/// The [cancel] and [refund] buttons can be used to cancel a transaction or to refund money after it has been transferred.
///
/// [StripePayment.create]で作成した支払い方法を持つカスタマーが実際の支払いを行うためのコントローラー。
///
/// [create]->[confirm]->[capture]の順で実行すると実際の金銭の移動が発生します。
///
/// [cancel]や[refund]によって途中のキャンセルや金銭の移動後の返金処理を実行可能です。
class StripePurchase
    extends MasamuneControllerBase<void, StripePurchaseMasamuneAdapter> {
  /// Controller for the actual payment by the customer with the payment method created in [StripePayment.create].
  ///
  /// Execute [create]->[confirm]->[capture] in that order to cause the actual movement of money.
  ///
  /// The [cancel] and [refund] buttons can be used to cancel a transaction or to refund money after it has been transferred.
  ///
  /// [StripePayment.create]で作成した支払い方法を持つカスタマーが実際の支払いを行うためのコントローラー。
  ///
  /// [create]->[confirm]->[capture]の順で実行すると実際の金銭の移動が発生します。
  ///
  /// [cancel]や[refund]によって途中のキャンセルや金銭の移動後の返金処理を実行可能です。
  StripePurchase({required this.userId});

  /// Query for StripePurchase.
  ///
  /// ```dart
  /// appRef.conroller(StripePurchase.query(parameters));   // Get from application scope.
  /// ref.app.conroller(StripePurchase.query(parameters));  // Watch at application scope.
  /// ref.page.conroller(StripePurchase.query(parameters)); // Watch at page scope.
  /// ```
  static const query = _$StripePurchaseQuery();

  /// Use this to retrieve the relevant [StripePurchaseModel] documentation.
  ///
  /// 関連する[StripePurchaseModel]のドキュメントを取得する場合はこちらを利用してください。
  static const documentQuery = StripePurchaseModel.document;

  /// Use this to retrieve the related [StripePurchaseModel] collection.
  ///
  /// 関連する[StripePurchaseModel]のコレクションを取得する場合はこちらを利用してください。
  static const collectionQuery = StripePurchaseModel.collection;

  @override
  StripePurchaseMasamuneAdapter get primaryAdapter =>
      StripePurchaseMasamuneAdapter.primary;

  /// User ID in the application.
  ///
  /// アプリ内のユーザーID。
  final String userId;

  Completer<void>? _completer;

  /// Specify [orderId] and create payment information for the amount in [priceAmount].
  ///
  /// Specifying [targetUserId] will make the payment to that user.
  /// If this is not specified, everything is paid to the operator.
  ///
  /// If this is done, no settlement is made. Then [confirm] to confirm the settlement, and [capture] to generate the actual flow of money.
  ///
  /// [orderId]を指定して[priceAmount]の金額の決済情報を作成します。
  ///
  /// [targetUserId]を指定することでそのユーザーに支払いを行います。
  /// これが指定されてない場合はすべて運営側に支払われます。
  ///
  /// これを行った場合に決済は行われません。その後[confirm]を行い決済を確定、[capture]で実際のお金の流れが発生します。
  Future<void> create({
    required String orderId,
    required double priceAmount,
    String? targetUserId,
    String? description,
    Locale locale = const Locale("en", "US"),
    Duration timeout = const Duration(seconds: 15),
    String? emailTitleOnRequired3DSecure,
    String? emailContentOnRequired3DSecure,
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final modelQuery = collectionQuery(userId: userId).modelQuery;
      final purchaseCollection = $StripePurchaseModelCollection(
        modelQuery.equal(
            StripePurchaseModelCollectionKey.orderId.name, orderId),
      );
      await purchaseCollection.load();
      if (purchaseCollection.isNotEmpty) {
        throw Exception("Billing has already been created.");
      }
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeCreatePurchaseAction(
          userId: userId,
          priceAmount: priceAmount,
          revenueAmount: StripePurchaseMasamuneAdapter.primary.revenueRatio,
          currency: StripePurchaseMasamuneAdapter.primary.currency,
          targetUserId: targetUserId,
          orderId: orderId,
          description: description,
          email: StripeMail(
            from: StripePurchaseMasamuneAdapter.primary.supportEmail,
            title: emailTitleOnRequired3DSecure ??
                StripePurchaseMasamuneAdapter
                    .primary.threeDSecureOptions.emailTitle,
            content: emailContentOnRequired3DSecure ??
                StripePurchaseMasamuneAdapter
                    .primary.threeDSecureOptions.emailContent,
          ),
          locale: locale,
        ),
      );

      if (response == null || response.purchaseId.isEmpty) {
        throw Exception("Response is invalid.");
      }

      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await purchaseCollection.reload();
        return purchaseCollection.isNotEmpty;
      }).timeout(timeout);
      _completer?.complete();
      _completer = null;
      notifyListeners();
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Change the [purchase] payment method to the default set in the app.
  ///
  /// If an existing payment fails, run [StripePayment.setDefault] to change the payment method and then run this.
  ///
  /// [purchase]の支払い方法をアプリ内で設定されているデフォルトに変更します。
  ///
  /// 既存の支払いに失敗した際に[StripePayment.setDefault]を実行し支払い方法を変更した後こちらを実行してください。
  Future<void> refresh({
    required StripePurchaseModel purchase,
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      if (purchase.success) {
        throw Exception("The payment has already been succeed.");
      }
      if (!purchase.error) {
        return;
      }
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeRefreshPurchaseAction(
          userId: userId,
          orderId: purchase.orderId,
        ),
      );

      if (response == null) {
        throw Exception("Response is invalid.");
      }
      _completer?.complete();
      _completer = null;
      notifyListeners();
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Confirm [purchase].
  ///
  /// 3D Secure authentication of your credit card is performed at this point.
  ///
  /// If [online] is `true`, WebView is displayed by [builder] if 3D Secure authentication is enabled.
  ///
  /// If [online] is `false`, you will be notified by email.
  ///
  /// [onClosed] is called when the WebView displayed by [builder] is closed.
  ///
  /// [purchase]を確定させます。
  ///
  /// クレジットカードの3Dセキュア認証をこの時点で行います。
  ///
  /// [online]が`true`の場合は、3Dセキュア認証が有効な場合[builder]によってWebViewが表示されます。
  ///
  /// [online]が`false`の場合は、メールによって通知が届きます。
  ///
  /// [onClosed]は[builder]によって表示されたWebViewが閉じられた際に呼び出されます。
  Future<void> confirm({
    required DocumentBase<StripePurchaseModel> purchase,
    bool online = true,
    required void Function(
      Uri endpoint,
      Widget webView,
      VoidCallback onClosed,
    ) builder,
    VoidCallback? onClosed,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    Completer<void>? internalCompleter = Completer<void>();
    try {
      final value = purchase.value;
      if (value == null) {
        throw Exception(
          "Purchase information is empty. Please run [create] method.",
        );
      }
      if (value.error) {
        throw Exception(
          "There has been an error with your payment. Please check and Refresh your payment information once.",
        );
      }
      if (value.canceled) {
        throw Exception("This purchase has already canceled.");
      }
      if (value.confirm && value.verified) {
        throw Exception("This purchase has already confirmed.");
      }
      var language = value.locale?.split("_").firstOrNull;
      if (!StripePurchaseMasamuneAdapter
          .primary.threeDSecureOptions.acceptLanguage
          .contains(language)) {
        language = StripePurchaseMasamuneAdapter
            .primary.threeDSecureOptions.acceptLanguage.first;
      }
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;
      final callbackHost = StripePurchaseMasamuneAdapter
          .primary.callbackURLSchemeOrHost
          .toString()
          .trimQuery()
          .trimString("/");
      final hostingEndpoint = StripePurchaseMasamuneAdapter
              .primary.hostingEndpoint
              ?.call(language!) ??
          callbackHost;
      final returnPathOptions =
          StripePurchaseMasamuneAdapter.primary.returnPathOptions;

      final response = await functionsAdapter.stipe(
        action: StripeConfirmPurchaseAction(
          userId: userId,
          orderId: value.orderId,
          returnUrl: online
              ? Uri.parse(
                  "$callbackHost/${returnPathOptions.finishedOnConfirmPurchase.trimString("/")}")
              : Uri.parse(
                  "${functionsAdapter.endpoint}/${StripePurchaseMasamuneAdapter.primary.threeDSecureOptions.redirectFunctionPath}"),
          failureUrl: Uri.parse(
              "$hostingEndpoint/${StripePurchaseMasamuneAdapter.primary.threeDSecureOptions.failurePath}"),
          successUrl: Uri.parse(
              "$hostingEndpoint/${StripePurchaseMasamuneAdapter.primary.threeDSecureOptions.successPath}"),
        ),
      );

      if (response == null || response.purchaseId.isEmpty) {
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

      final nextAction = response.nextActionUrl?.toString();
      if (nextAction.isNotEmpty) {
        final webView = StripeWebview(
          response.nextActionUrl!,
          shouldOverrideUrlLoading: (url) {
            final path = url.trimQuery().replaceAll(callbackHost, "");
            if (path ==
                "/${returnPathOptions.finishedOnConfirmPurchase.trimString("/")}") {
              onClosed?.call();
              onCompleted();
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
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await purchase.reload();
        return purchase.value != null &&
            (!purchase.value!.confirm || !purchase.value!.verified);
      }).timeout(timeout);
      _completer?.complete();
      _completer = null;
      internalCompleter?.complete();
      internalCompleter = null;
      notifyListeners();
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      internalCompleter?.complete();
      internalCompleter = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
      internalCompleter?.complete();
      internalCompleter = null;
    }
  }

  /// Executed when the actual flow of money is generated after [confirm].
  ///
  /// You can override the payment amount by specifying [priceAmountOverride].
  ///
  /// However, this amount should be set to be less than the amount specified at [purchase].
  ///
  /// [confirm]後に実際の金銭の流れを発生させる際に実行します。
  ///
  /// [priceAmountOverride]を指定すると支払金額を上書きできます。
  ///
  /// ただし、この金額は[purchase]時に指定した金額を下回るように設定してください。
  Future<void> capture({
    required DocumentBase<StripePurchaseModel> purchase,
    double? priceAmountOverride,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final value = purchase.value;
      if (value == null) {
        throw Exception(
          "Purchase information is empty. Please run [create] method.",
        );
      }
      if (value.error) {
        throw Exception(
          "There has been an error with your payment. Please check and Refresh your payment information once.",
        );
      }
      if (value.canceled) {
        throw Exception("This purchase has already canceled.");
      }
      if (!value.confirm || !value.verified) {
        throw Exception(
          "The payment has not been confirmed yet. Please confirm the payment by clicking [confirm] and then execute.",
        );
      }
      if (value.captured) {
        throw Exception("This purchase has already captured.");
      }
      if (priceAmountOverride != null && value.amount < priceAmountOverride) {
        throw Exception(
          "You cannot capture an amount higher than the billing amount already saved.",
        );
      }
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeCapturePurchaseAction(
          userId: userId,
          orderId: value.orderId,
          priceAmountOverride: priceAmountOverride,
        ),
      );

      if (response == null || response.purchaseId.isEmpty) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await purchase.reload();
        return purchase.value != null && !purchase.value!.confirm;
      }).timeout(timeout);
      _completer?.complete();
      _completer = null;
      notifyListeners();
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Cancel [purchase].
  ///
  /// [purchase]をキャンセルします。
  Future<void> cancel({
    required DocumentBase<StripePurchaseModel> purchase,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final value = purchase.value;
      if (value == null) {
        throw Exception(
          "Purchase information is empty. Please run [create] method.",
        );
      }
      if (value.canceled) {
        throw Exception("This purchase has already canceled.");
      }
      if (value.captured || value.success) {
        throw Exception("The payment has already been completed.");
      }
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeCancelPurchaseAction(
          userId: userId,
          orderId: value.orderId,
        ),
      );

      if (response == null) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await purchase.reload();
        return purchase.value != null && !purchase.value!.canceled;
      }).timeout(timeout);
      _completer?.complete();
      _completer = null;
      notifyListeners();
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// [purchase] refund process.
  ///
  /// If [refundAmount] is specified, the amount will be refunded. However, the amount must be less than the amount specified at the time of [purchase].
  ///
  /// [purchase]の返金処理を行います。
  ///
  /// [refundAmount]を指定するとその金額だけ返金されます。ただし、[purchase]時に指定した金額を下回るように設定してください。
  Future<void> refund({
    required DocumentBase<StripePurchaseModel> purchase,
    double? refundAmount,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final value = purchase.value;
      if (value == null) {
        throw Exception(
          "Purchase information is empty. Please run [create] method.",
        );
      }
      if (!value.captured || !value.success) {
        throw Exception("The payment is not yet in your jurisdiction.");
      }
      if (value.refund) {
        throw Exception("The payment is already refunded.");
      }
      if (refundAmount != null && value.amount < refundAmount) {
        throw Exception(
          "The amount to be refunded exceeds the original amount.",
        );
      }
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeRefundPurchaseAction(
          userId: userId,
          orderId: value.orderId,
          refundAmount: refundAmount,
        ),
      );

      if (response == null) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await purchase.reload();
        return purchase.value != null && !purchase.value!.refund;
      }).timeout(timeout);
      _completer?.complete();
      _completer = null;
      notifyListeners();
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }
}

@immutable
class _$StripePurchaseQuery {
  const _$StripePurchaseQuery();

  @useResult
  _$_StripePurchaseQuery call({
    required String userId,
  }) =>
      _$_StripePurchaseQuery(
        hashCode.toString(),
        userId: userId,
      );
}

@immutable
class _$_StripePurchaseQuery extends ControllerQueryBase<StripePurchase> {
  const _$_StripePurchaseQuery(
    this._name, {
    required this.userId,
  });

  final String _name;
  final String userId;

  @override
  StripePurchase Function() call(Ref ref) {
    return () => StripePurchase(userId: userId);
  }

  @override
  String get name => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
