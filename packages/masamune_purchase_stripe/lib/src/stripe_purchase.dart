part of masamune_purchase_stripe;

class StripePurchase extends ChangeNotifier {
  StripePurchase({required this.userId});

  final String userId;

  static Completer<void>? _completer;

  static const documentQuery = StripePurchaseModel.document;
  static const collectionQuery = StripePurchaseModel.collection;

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
        await purchaseCollection.load();
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

  Future<void> confirm({
    required StripePurchaseModel purchase,
    bool online = true,
    required void Function(
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
      final modelQuery = collectionQuery(userId: userId).modelQuery;
      final purchaseCollection = $StripePurchaseModelCollection(
        modelQuery.equal(
            StripePurchaseModelCollectionKey.orderId.name, purchase.orderId),
      );
      if (purchase.error) {
        throw Exception(
          "There has been an error with your payment. Please check and Refresh your payment information once.",
        );
      }
      if (purchase.canceled) {
        throw Exception("This purchase has already canceled.");
      }
      if (purchase.confirm && purchase.verified) {
        throw Exception("This purchase has already confirmed.");
      }
      var language = purchase.locale?.split("_").firstOrNull;
      if (!StripePurchaseMasamuneAdapter
          .primary.threeDSecureOptions.acceptLanguage
          .contains(language)) {
        language = StripePurchaseMasamuneAdapter
            .primary.threeDSecureOptions.acceptLanguage.first;
      }
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;
      final callbackHost = StripePurchaseMasamuneAdapter.primary.callbackHost
          .toString()
          .trimQuery()
          .trimString("/");
      final hostingEndpoint = StripePurchaseMasamuneAdapter
              .primary.hostingEndpoint
              ?.call(language!) ??
          callbackHost;

      final response = await functionsAdapter.stipe(
        action: StripeConfirmPurchaseAction(
          userId: userId,
          orderId: purchase.orderId,
          returnUrl: online
              ? Uri.parse("$callbackHost/confirm_payment/finished")
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

      if (response.nextActionUrl != null) {
        final webView = _StripeWebview(
          response.nextActionUrl!,
          shouldOverrideUrlLoading: (controller, url) {
            final path = url.trimQuery().replaceAll(callbackHost, "");
            switch (path) {
              case "/confirm_payment/finished":
                onClosed?.call();
                onCompleted();
                return NavigationActionPolicy.CANCEL;
            }
            final uri = Uri.parse(url);
            if (uri.host == "hooks.stripe.com" &&
                uri.queryParameters.containsKey("authenticated")) {
              authenticated = uri.queryParameters["authenticated"] == "true";
            }
            return NavigationActionPolicy.ALLOW;
          },
          onCloseWindow: (controller) {
            onCompleted();
          },
        );
        builder.call(webView, onCompleted);
        await internalCompleter!.future;
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await purchaseCollection.load();
        return !purchaseCollection.any(
          (element) =>
              element.value != null &&
              element.value!.confirm &&
              element.value!.verified,
        );
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

  Future<void> capture({
    required StripePurchaseModel purchase,
    double? priceAmountOverride,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final modelQuery = collectionQuery(userId: userId).modelQuery;
      final purchaseCollection = $StripePurchaseModelCollection(
        modelQuery.equal(
            StripePurchaseModelCollectionKey.orderId.name, purchase.orderId),
      );
      if (purchase.error) {
        throw Exception(
          "There has been an error with your payment. Please check and Refresh your payment information once.",
        );
      }
      if (purchase.canceled) {
        throw Exception("This purchase has already canceled.");
      }
      if (!purchase.confirm || !purchase.verified) {
        throw Exception(
          "The payment has not been confirmed yet. Please confirm the payment by clicking [confirm] and then execute.",
        );
      }
      if (purchase.captured) {
        throw Exception("This purchase has already captured.");
      }
      if (priceAmountOverride != null &&
          purchase.amount < priceAmountOverride) {
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
          orderId: purchase.orderId,
          priceAmountOverride: priceAmountOverride,
        ),
      );

      if (response == null || response.purchaseId.isEmpty) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return !purchaseCollection.any(
          (element) => element.value != null && element.value!.captured,
        );
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

  Future<void> cancel({
    required StripePurchaseModel purchase,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final modelQuery = collectionQuery(userId: userId).modelQuery;
      final purchaseCollection = $StripePurchaseModelCollection(
        modelQuery.equal(
            StripePurchaseModelCollectionKey.orderId.name, purchase.orderId),
      );
      if (purchase.canceled) {
        throw Exception("This purchase has already canceled.");
      }
      if (purchase.captured || purchase.success) {
        throw Exception("The payment has already been completed.");
      }
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeCancelPurchaseAction(
          userId: userId,
          orderId: purchase.orderId,
        ),
      );

      if (response == null) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return !purchaseCollection.any(
          (element) => element.value != null && element.value!.canceled,
        );
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

  Future<void> refund({
    required StripePurchaseModel purchase,
    double? refundAmount,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final modelQuery = collectionQuery(userId: userId).modelQuery;
      final purchaseCollection = $StripePurchaseModelCollection(
        modelQuery.equal(
            StripePurchaseModelCollectionKey.orderId.name, purchase.orderId),
      );
      if (!purchase.captured || !purchase.success) {
        throw Exception("The payment is not yet in your jurisdiction.");
      }
      if (purchase.refund) {
        throw Exception("The payment is already refunded.");
      }
      if (refundAmount != null && purchase.amount < refundAmount) {
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
          orderId: purchase.orderId,
          refundAmount: refundAmount,
        ),
      );

      if (response == null) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return !purchaseCollection.any(
          (element) => element.value != null && element.value!.refund,
        );
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
