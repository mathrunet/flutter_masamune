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
      final callbackHost = StripePurchaseMasamuneAdapter.primary.callbackHost
          .toString()
          .trimQuery()
          .trimString("/");

      final response = await functionsAdapter.stipe(
        action: StripeCreateSubscriptionAction(
          userId: userId,
          orderId: orderId,
          productId: productId,
          successUrl: Uri.parse("$callbackHost/create_subscription/success"),
          cancelUrl: Uri.parse("$callbackHost/create_subscription/cancel"),
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

      final webView = _StripeWebview(
        response.endpoint,
        shouldOverrideUrlLoading: (controller, url) {
          final path = url.trimQuery().replaceAll(callbackHost, "");
          switch (path) {
            case "/create_subscription/success":
              onClosed?.call();
              onSuccess.call();
              return NavigationActionPolicy.CANCEL;
            case "/create_subscription/cancel":
              onClosed?.call();
              onCancel.call();
              return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
        onCloseWindow: (controller) {
          onCancel.call();
        },
      );
      builder.call(webView, onSuccess, onCancel);
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
