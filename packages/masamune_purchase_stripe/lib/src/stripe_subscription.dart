part of masamune_purchase_stripe;

class StripeSubscription extends ChangeNotifier {
  StripeSubscription({required this.userId});

  final String userId;

  static Completer<void>? _completer;

  static const documentQuery = StripePurchaseModel.document;
  static const collectionQuery = StripePurchaseModel.collection;

  Future<void> create({
    required String orderId,
    required String productId,
    required void Function(
      Uri endpoint,
      Widget webView,
      VoidCallback onSuccess,
      VoidCallback onCancel,
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
            StripePurchaseModelCollectionKey.orderId.name, orderId),
      );
      await purchaseCollection.load();
      if (purchaseCollection.isNotEmpty) {
        throw Exception("Billing has already been created.");
      }
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
        action: StripeCreateSubscriptionAction(
          userId: userId,
          orderId: orderId,
          productId: productId,
          successUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.successOnCreateSubscription.trimString("/")}"),
          cancelUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.cancelOnCreateSubscription.trimString("/")}"),
        ),
      );

      if (response == null) {
        throw Exception("Response is invalid.");
      }
      onSuccess() {
        internalCompleter?.complete();
        internalCompleter = null;
      }

      onCancel() {
        internalCompleter?.completeError(StripeCancelException());
        internalCompleter = null;
      }

      final webView = StripeWebview(
        response.endpoint,
        shouldOverrideUrlLoading: (url) {
          final path = url.trimQuery().replaceAll(callbackHost, "");
          if (path ==
              "/${returnPathOptions.successOnCreateSubscription.trimString("/")}") {
            onClosed?.call();
            onSuccess.call();
            return StripeNavigationActionPolicy.cancel;
          } else if (path ==
              "/${returnPathOptions.cancelOnCreateSubscription.trimString("/")}") {
            onClosed?.call();
            onCancel.call();
            return StripeNavigationActionPolicy.cancel;
          }
          return StripeNavigationActionPolicy.allow;
        },
        onCloseWindow: () {
          onCancel.call();
        },
      );
      builder.call(response.endpoint, webView, onSuccess, onCancel);
      await internalCompleter!.future;
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await purchaseCollection.load();
        return purchaseCollection.isNotEmpty;
      }).timeout(timeout);
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

  Future<void> delete({
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
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeDeleteSubscriptionAction(
          orderId: purchase.orderId,
        ),
      );
      if (response == null) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await purchaseCollection.load();
        return purchaseCollection.every(
          (element) =>
              element.value != null && element.value!.cancelAtPeriodEnd,
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
