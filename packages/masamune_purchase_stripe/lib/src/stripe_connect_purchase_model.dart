part of masamune_purchase_stripe;

final stripeConnectPurchaseModelProvider = ChangeNotifierProvider(
  (_) => StripeConnectPurchaseModel(),
);

final stripeConnectPurchaseCollectionProvider =
    ChangeNotifierProvider.family<FirestoreDynamicCollectionModel, String>(
  (_, uid) => FirestoreDynamicCollectionModel(
    "${StripeConnectCore._userPath}/$uid/${StripeConnectCore._purchasePath}",
  ),
);

class StripeConnectPurchaseModel extends Model<void>
    with IterableMixin<FirestoreDynamicDocumentModel> {
  StripeConnectPurchaseModel() : super();

  @override
  Iterator<FirestoreDynamicDocumentModel> get iterator => _value.iterator;

  FirestoreDynamicCollectionModel get _value {
    if (!StripeConnectCore.isInitialized) {
      throw Exception("StripeConnectCore has not been initialized.");
    }
    final uid = StripeConnectCore._debugUserId ?? userId;
    return readProvider(stripeConnectPurchaseCollectionProvider(uid));
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
    required String orderId,
    required double amount,
    String? sourceUserId,
    String? targetUserId,
    required String description,
    String? locale,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_savingCompleter != null) {
      await _savingCompleter!.future;
      return _value.firstWhere((element) => element.uid == orderId);
    }
    _savingCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = sourceUserId ?? StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      if (_value.any((element) => element.uid == orderId)) {
        throw Exception("Billing has already been created.");
      }
      final _length = _value.length;
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.createPurchase.id,
          "orderId": orderId,
          "userId": uid,
          if (targetUserId.isNotEmpty) "targetId": targetUserId,
          "amount": amount,
          "revenue": StripeConnectCore._revenue,
          "currency": StripeConnectCore._currency.id,
          "description": description,
          "locale": locale ?? Localize.locale,
          "from": StripeConnectCore._supportEmail,
          "title": StripeConnectCore._emailTitleOnRequired3DSecure
              .localize(language: locale?.split("_").firstOrNull),
          "content": StripeConnectCore._emailContentOnRequired3DSecure
              .localize(language: locale?.split("_").firstOrNull),
        },
      );
      if (res.isEmpty) {
        throw Exception("Response is invalid.");
      }
      final paymentId = res.get("paymentId", "");
      if (paymentId.isEmpty) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        if (_length == _value.length) {
          return true;
        }
        return !_value.any((element) => element.uid == orderId);
      }).timeout(timeout);
      _savingCompleter?.complete();
      _savingCompleter = null;
      notifyListeners();
      return _value.firstWhere((element) => element.uid == orderId);
    } catch (e) {
      _savingCompleter?.completeError(e);
      _savingCompleter = null;
      rethrow;
    } finally {
      _savingCompleter?.complete();
      _savingCompleter = null;
    }
  }

  Future<void> authorization(
    BuildContext context, {
    required double amount,
    String? locale,
    bool online = true,
    required void Function(
      Widget webView,
      VoidCallback onClosed,
    )
        builder,
    bool popWhenClosedByWebview = false,
  }) async {
    if (_savingCompleter != null) {
      await saving;
      return;
    }
    _savingCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      var language = (locale ?? "en_US").split("_").first;
      if (!StripeConnectCore._threeDSecureAcceptLanguage.contains(language)) {
        language = "en";
      }
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.authorization.id,
          "userId": uid,
          "amount": amount,
          "currency": StripeConnectCore._currency.id,
          "locale": locale ?? Localize.locale,
          "from": StripeConnectCore._supportEmail,
          "title": StripeConnectCore._emailTitleOnRequired3DSecure
              .localize(language: locale?.split("_").firstOrNull),
          "content": StripeConnectCore._emailContentOnRequired3DSecure
              .localize(language: locale?.split("_").firstOrNull),
          "online": online ? "true" : "false",
          "returnUrl": online
              ? "${StripeConnectCore._callbackUrl}/authorization/finished"
              : "${FirebaseCore.functionsEndpoint}/${StripeConnectCore._threeDSecureRedirectFunctionPath}",
          "successUrl":
              "${FirebaseCore.hostingEndpoint}/$language/${StripeConnectCore._threeDSecureSuccessPath}",
          "failureUrl":
              "${FirebaseCore.hostingEndpoint}/$language/${StripeConnectCore._threeDSecureFailurePath}",
        },
      );
      if (res.isEmpty) {
        throw Exception("Response is invalid.");
      }
      final paymentId = res.get("paymentId", "");
      if (paymentId.isEmpty) {
        throw Exception("Response is invalid.");
      }
      var authenticated = true;
      final url = res.get("url", "");
      final onClosed = () {
        if (authenticated) {
          _savingCompleter?.complete();
          _savingCompleter = null;
        } else {
          _savingCompleter
              ?.completeError(Exception("3D Secure authentication failed."));
          _savingCompleter = null;
        }
      };
      if (url.isNotEmpty) {
        final webView = _StripeConnectWebview(
          Uri.parse(url),
          shouldOverrideUrlLoading: (controller, url) {
            final path =
                url.trimQuery().replaceAll(StripeConnectCore._callbackUrl, "");
            switch (path) {
              case "/authorization/finished":
                if (popWhenClosedByWebview) {
                  context.navigator.pop();
                }
                onClosed.call();
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
            onClosed.call();
          },
        );
        builder.call(webView, onClosed);
        await _savingCompleter!.future;
      }
      await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.confirmAuthorization.id,
          "paymentId": paymentId,
        },
      );
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

  Future<void> refresh(
    BuildContext context, {
    required String orderId,
  }) async {
    if (_savingCompleter != null) {
      await saving;
      return;
    }
    _savingCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      final found =
          _value.firstWhereOrNull((element) => element.uid == orderId);
      if (found == null) {
        throw Exception(
          "The charge has not been created. Please use [create] to create the billing.",
        );
      }
      if (found.get("success", false)) {
        throw Exception("The payment has already been succeed.");
      }
      if (!found.get("error", false)) {
        return;
      }
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.refreshPurchase.id,
          "orderId": orderId,
          "userId": uid,
        },
      );
      if (res.isEmpty) {
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

  Future<void> capture(
    BuildContext context, {
    required String orderId,
    bool online = true,
    double? amount,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_savingCompleter != null) {
      await saving;
      return;
    }
    _savingCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      final found =
          _value.firstWhereOrNull((element) => element.uid == orderId);
      if (found == null) {
        throw Exception(
          "The charge has not been created. Please use [create] to create the billing.",
        );
      }
      if (found.get("error", false)) {
        throw Exception(
          "There has been an error with your payment. Please check and Refresh your payment information once.",
        );
      }
      if (found.get("cancel", false)) {
        throw Exception("This purchase has already canceled.");
      }
      if (!found.get("confirm", false) || !found.get("verify", false)) {
        throw Exception(
          "The payment has not been confirmed yet. Please confirm the payment by clicking [confirm] and then execute.",
        );
      }
      if (found.get("capture", false)) {
        throw Exception("This purchase has already captured.");
      }
      if (amount != null && found.get("amount", 0) < amount) {
        throw Exception(
          "You cannot capture an amount higher than the billing amount already saved.",
        );
      }
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.capturePurchase.id,
          "orderId": orderId,
          "userId": uid,
          "online": online ? "true" : "false",
          if (amount != null) "amount": amount,
        },
      );
      if (res.isEmpty) {
        throw Exception("Response is invalid.");
      }
      final paymentId = res.get("paymentId", "");
      if (paymentId.isEmpty) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return !_value.any(
          (element) => element.uid == orderId && element.get("capture", false),
        );
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

  Future<void> confirm(
    BuildContext context, {
    required String orderId,
    bool online = true,
    required void Function(
      Widget webView,
      VoidCallback onClosed,
    )
        builder,
    bool popWhenClosedByWebview = false,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_savingCompleter != null) {
      await saving;
      return;
    }
    _savingCompleter = Completer<void>();
    Completer<void>? _internalCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      final found =
          _value.firstWhereOrNull((element) => element.uid == orderId);
      if (found == null) {
        throw Exception(
          "The charge has not been created. Please use [create] to create the billing.",
        );
      }
      if (found.get("error", false)) {
        throw Exception(
          "There has been an error with your payment. Please check and Refresh your payment information once.",
        );
      }
      if (found.get("cancel", false)) {
        throw Exception("This purchase has already canceled.");
      }
      if (found.get("confirm", false) && found.get("verify", false)) {
        throw Exception("This purchase has already confirmed.");
      }
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      var language = found.get("locale", "en_US").split("_").first;
      if (!StripeConnectCore._threeDSecureAcceptLanguage.contains(language)) {
        language = "en";
      }
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.confirmPurchase.id,
          "orderId": orderId,
          "userId": uid,
          "online": online ? "true" : "false",
          "returnUrl": online
              ? "${StripeConnectCore._callbackUrl}/confirm_payment/finished"
              : "${FirebaseCore.functionsEndpoint}/${StripeConnectCore._threeDSecureRedirectFunctionPath}",
          "successUrl":
              "${FirebaseCore.hostingEndpoint}/$language/${StripeConnectCore._threeDSecureSuccessPath}",
          "failureUrl":
              "${FirebaseCore.hostingEndpoint}/$language/${StripeConnectCore._threeDSecureFailurePath}",
        },
      );
      if (res.isEmpty) {
        throw Exception("Response is invalid.");
      }
      final paymentId = res.get("paymentId", "");
      if (paymentId.isEmpty) {
        throw Exception("Response is invalid.");
      }
      var authenticated = true;
      final url = res.get("url", "");
      final onClosed = () {
        if (authenticated) {
          _internalCompleter?.complete();
          _internalCompleter = null;
        } else {
          _internalCompleter
              ?.completeError(Exception("3D Secure authentication failed."));
          _internalCompleter = null;
        }
      };
      if (url.isNotEmpty) {
        final webView = _StripeConnectWebview(
          Uri.parse(url),
          shouldOverrideUrlLoading: (controller, url) {
            final path =
                url.trimQuery().replaceAll(StripeConnectCore._callbackUrl, "");
            switch (path) {
              case "/confirm_payment/finished":
                if (popWhenClosedByWebview) {
                  context.navigator.pop();
                }
                onClosed.call();
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
            onClosed.call();
          },
        );
        builder.call(webView, onClosed);
        await _internalCompleter!.future;
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return !_value.any(
          (element) =>
              element.uid == orderId &&
              element.get("confirm", false) &&
              element.get("verify", false),
        );
      }).timeout(timeout);
      _savingCompleter?.complete();
      _savingCompleter = null;
      _internalCompleter?.complete();
      _internalCompleter = null;
      notifyListeners();
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

  Future<void> cancel(
    BuildContext context, {
    required String orderId,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_savingCompleter != null) {
      await saving;
      return;
    }
    _savingCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      final found =
          _value.firstWhereOrNull((element) => element.uid == orderId);
      if (found == null) {
        throw Exception(
          "The charge has not been created. Please use [create] to create the billing.",
        );
      }
      if (found.get("cancel", false)) {
        throw Exception("This purchase has already canceled.");
      }
      if (found.get("capture", false) || found.get("success", false)) {
        throw Exception("The payment has already been completed.");
      }
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.cancelPurchase.id,
          "orderId": orderId,
          "userId": uid,
        },
      );
      if (res.isEmpty) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return !_value.any(
          (element) => element.uid == orderId && element.get("cancel", false),
        );
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

  Future<void> refund(
    BuildContext context, {
    required String orderId,
    double? amount,
  }) async {
    if (_savingCompleter != null) {
      await saving;
      return;
    }
    _savingCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      final found =
          _value.firstWhereOrNull((element) => element.uid == orderId);
      if (found == null) {
        throw Exception(
          "The charge has not been created. Please use [create] to create the billing.",
        );
      }
      if (!found.get("capture", false) || !found.get("success", false)) {
        throw Exception("The payment is not yet in your jurisdiction.");
      }
      if (amount != null && found.get("amount", 0) < amount) {
        throw Exception(
          "The amount to be refunded exceeds the original amount.",
        );
      }
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.refundPurchase.id,
          "orderId": orderId,
          "userId": uid,
          if (amount != null) "amount": amount,
        },
      );
      if (res.isEmpty) {
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

  @override
  void dispose() {
    super.dispose();
    _value.removeListener(_handledOnUpdate);
  }
}
