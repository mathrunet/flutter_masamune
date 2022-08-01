part of masamune_purchase_stripe;

final stripeConnectPaymentModelProvider = ChangeNotifierProvider(
  (_) => StripeConnectPaymentModel(),
);

final stripeConnectPaymentCollectionProvider =
    ChangeNotifierProvider.family<FirestoreDynamicCollectionModel, String>(
  (_, uid) => FirestoreDynamicCollectionModel(
    "${StripeConnectCore._userPath}/$uid/${StripeConnectCore._paymentPath}",
  ),
);

class StripeConnectPaymentModel extends Model<void>
    with IterableMixin<FirestoreDynamicDocumentModel> {
  StripeConnectPaymentModel() : super();

  @override
  Iterator<FirestoreDynamicDocumentModel> get iterator => _value.iterator;

  FirestoreDynamicCollectionModel get _value {
    if (!StripeConnectCore.isInitialized) {
      throw Exception("StripeConnectCore has not been initialized.");
    }
    final uid = StripeConnectCore._debugUserId ?? userId;
    return readProvider(stripeConnectPaymentCollectionProvider(uid));
  }

  @override
  @protected
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> reload() async {
    await _value.load();
  }

  bool get exists {
    return _value.isNotEmpty;
  }

  /// Returns itself after the load finishes.
  Future<void>? get loading => _loadingCompleter?.future;
  Completer<void>? _loadingCompleter;

  /// Returns itself after the save finishes.
  Future<void>? get saving => _savingCompleter?.future;
  Completer<void>? _savingCompleter;

  Future<void> _initialize() async {
    _value.addListener(_handledOnUpdate);
    await _value.listen();
  }

  void _handledOnUpdate() {
    notifyListeners();
  }

  Future<FirestoreDynamicDocumentModel> create(
    BuildContext context, {
    required void Function(
      Widget webView,
      VoidCallback onSuccess,
      VoidCallback onCancel,
    )
        builder,
    bool popWhenClosedByWebview = false,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_savingCompleter != null) {
      await _savingCompleter!.future;
      return _value.firstWhere((element) => element.get("default", true));
    }
    _savingCompleter = Completer<void>();
    Completer<void>? _internalCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.createPayment.id,
          "userId": uid,
          "successUrl":
              "${StripeConnectCore._callbackUrl}/create_payment/success",
          "cancelUrl":
              "${StripeConnectCore._callbackUrl}/create_payment/cancel",
        },
      );
      if (res.isEmpty) {
        throw Exception("Response is invalid.");
      }
      final _length = _value.length;
      final endpoint = res.get("endpoint", "");
      final customerId = res.get("customerId", "");
      if (endpoint.isEmpty || customerId.isEmpty) {
        throw Exception("Response is invalid.");
      }
      final onSuccess = () {
        _internalCompleter?.complete();
        _internalCompleter = null;
      };
      final onCancel = () {
        _internalCompleter?.completeError(StripeConnectCancelException());
        _internalCompleter = null;
      };
      final webView = _StripeConnectWebview(
        Uri.parse(endpoint),
        shouldOverrideUrlLoading: (controller, url) {
          final path =
              url.trimQuery().replaceAll(StripeConnectCore._callbackUrl, "");
          switch (path) {
            case "/create_payment/success":
              if (popWhenClosedByWebview) {
                context.navigator.pop();
              }
              onSuccess.call();
              return NavigationActionPolicy.CANCEL;
            case "/create_payment/cancel":
              if (popWhenClosedByWebview) {
                context.navigator.pop();
              }
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
      await _internalCompleter!.future;
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        if (_length == _value.length) {
          return true;
        }
        return !_value.any((element) => element.get("default", true));
      }).timeout(timeout);
      _savingCompleter?.complete();
      _savingCompleter = null;
      _internalCompleter?.complete();
      _internalCompleter = null;
      notifyListeners();
      return _value.firstWhere((element) => element.get("default", true));
    } catch (e) {
      _savingCompleter?.completeError(e);
      _savingCompleter = null;
      _internalCompleter?.complete();
      _internalCompleter = null;
      rethrow;
    } finally {
      _savingCompleter?.complete();
      _savingCompleter = null;
      _internalCompleter?.complete();
      _internalCompleter = null;
    }
  }

  Future<void> setDefault(String paymentId) async {
    if (_savingCompleter != null) {
      return _savingCompleter!.future;
    }
    _savingCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.setDefaultPayment.id,
          "userId": uid,
          "paymentId": paymentId,
        },
      );
      if (res.isEmpty) {
        throw Exception("Response is invalid.");
      }
      final success = res.get("success", false);
      if (!success) {
        throw Exception("Response is invalid.");
      }
      _savingCompleter?.complete();
      _savingCompleter = null;
      notifyListeners();
    } catch (e) {
      _savingCompleter?.completeError(e);
      _savingCompleter = null;
      rethrow;
    } finally {
      _savingCompleter?.complete();
      _savingCompleter = null;
    }
  }

  Future<void> delete(
    String paymentId, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_savingCompleter != null) {
      return _savingCompleter!.future;
    }
    _savingCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      final _length = _value.length;
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.deletePayment.id,
          "userId": uid,
          "paymentId": paymentId,
        },
      );
      if (res.isEmpty) {
        throw Exception("Response is invalid.");
      }
      final success = res.get("success", false);
      if (!success) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return _length == _value.length;
      }).timeout(timeout);
      _savingCompleter?.complete();
      _savingCompleter = null;
      notifyListeners();
    } catch (e) {
      _savingCompleter?.completeError(e);
      _savingCompleter = null;
      rethrow;
    } finally {
      _savingCompleter?.complete();
      _savingCompleter = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _value.removeListener(_handledOnUpdate);
  }
}
