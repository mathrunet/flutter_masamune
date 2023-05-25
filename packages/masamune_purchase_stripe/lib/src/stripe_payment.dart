part of masamune_purchase_stripe;

class StripePayment extends ChangeNotifier {
  StripePayment({required this.userId});

  final String userId;

  static Completer<void>? _completer;

  static const documentQuery = StripePaymentModel.document;
  static const collectionQuery = StripePaymentModel.collection;

  Future<void> create({
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
      if (userId.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      final modelQuery = collectionQuery(userId: userId).modelQuery;
      final paymentCollection = $StripePaymentModelCollection(modelQuery);
      await paymentCollection.load();
      final length = paymentCollection.length;
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;
      final callbackHost = StripePurchaseMasamuneAdapter.primary.callbackHost
          .toString()
          .trimQuery()
          .trimString("/");

      final response = await functionsAdapter.stipe(
        action: StripeCreateCustomerAndPaymentAction(
          userId: userId,
          successUrl: Uri.parse("$callbackHost/create_payment/success"),
          cancelUrl: Uri.parse("$callbackHost/create_payment/cancel"),
        ),
      );

      if (response == null || response.customerId.isEmpty) {
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
            case "/create_payment/success":
              onClosed?.call();
              onSuccess.call();
              return NavigationActionPolicy.CANCEL;
            case "/create_payment/cancel":
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
        await paymentCollection.load();
        if (length == paymentCollection.length) {
          return true;
        }
        return !paymentCollection
            .any((element) => element.value?.isDefault ?? false);
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

  Future<void> setDefault({
    required StripePaymentModel payment,
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeSetCustomerDefaultPaymentAction(
          userId: userId,
          paymentId: payment.paymentId,
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

  Future<void> delete({
    required StripePaymentModel payment,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final modelQuery = collectionQuery(userId: userId).modelQuery;
      final paymentCollection = $StripePaymentModelCollection(modelQuery);
      await paymentCollection.load();
      final length = paymentCollection.length;
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeDeletePaymentAction(
          userId: userId,
          paymentId: payment.paymentId,
        ),
      );
      if (response == null) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await paymentCollection.load();
        return length == paymentCollection.length;
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
