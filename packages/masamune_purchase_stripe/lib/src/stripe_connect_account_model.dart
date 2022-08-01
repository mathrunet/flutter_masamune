part of masamune_purchase_stripe;

final stripeConnectAccountModelProvider = ChangeNotifierProvider(
  (_) => StripeConnectAccountModel(),
);

final stripeConnectAccountDocumentProvider =
    ChangeNotifierProvider.family<FirestoreDynamicDocumentModel, String>(
  (_, uid) =>
      FirestoreDynamicDocumentModel("${StripeConnectCore._userPath}/$uid"),
);

class StripeConnectAccountModel extends Model<void> {
  StripeConnectAccountModel() : super();

  @override
  @protected
  void initState() {
    super.initState();
    _initialize();
  }

  /// Returns itself after the load finishes.
  Future<void>? get loading => _loadingCompleter?.future;
  Completer<void>? _loadingCompleter;

  /// Returns itself after the save finishes.
  Future<void>? get saving => _savingCompleter?.future;
  Completer<void>? _savingCompleter;

  FirestoreDynamicDocumentModel get _value {
    if (!StripeConnectCore.isInitialized) {
      throw Exception("StripeConnectCore has not been initialized.");
    }
    final uid = StripeConnectCore._debugUserId ?? userId;
    return readProvider(stripeConnectAccountDocumentProvider(uid));
  }

  Future<void> _initialize() async {
    _value.addListener(_handledOnUpdate);
    await _value.listen();
  }

  void _handledOnUpdate() {
    notifyListeners();
  }

  Future<void> reload() async {
    await _value.load();
  }

  bool get exists {
    return _value.containsKey(StripeConnectCore._accountKey);
  }

  bool get registered {
    if (!_value.containsKey(StripeConnectCore._accountKey)) {
      return false;
    }
    return _value.containsKey(StripeConnectCore._capabilityKey) &&
        _value
            .getAsMap(StripeConnectCore._capabilityKey)
            .containsKey("transfers");
  }

  Future<void> delete() async {
    if (_savingCompleter != null) {
      return saving;
    }
    _savingCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      if (!_value.containsKey(StripeConnectCore._accountKey)) {
        throw Exception(
          "Account information is empty. Please run [create] method.",
        );
      }
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.deleteAccount.id,
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

  Future<void> dashboard(
    BuildContext context, {
    required void Function(
      Widget webView,
      VoidCallback onClosed,
    )
        builder,
    bool popWhenClosedByWebview = false,
  }) async {
    if (_loadingCompleter != null) {
      return saving;
    }
    _loadingCompleter = Completer<void>();
    try {
      await _initialize();
      final uid = StripeConnectCore._debugUserId ?? userId;
      if (uid.isEmpty) {
        throw Exception("You are not logged in. Please log in once.");
      }
      if (!_value.containsKey(StripeConnectCore._accountKey)) {
        throw Exception(
          "Account information is empty. Please run [create] method.",
        );
      }
      if (!_value.containsKey(StripeConnectCore._capabilityKey) ||
          !_value
              .getAsMap(StripeConnectCore._capabilityKey)
              .containsKey("transfers")) {
        throw Exception("Your account has not been registered yet.");
      }
      final functions = readProvider(
        functionsDocumentProvider(StripeConnectCore._serverPath),
      );
      final res = await functions.call(
        parameters: {
          "mode": _StripeConnectAPIMode.dashboard.id,
          "userId": uid,
          "returnUrl": "${StripeConnectCore._callbackUrl}/dashboard/finished",
        },
      );
      if (res.isEmpty) {
        throw Exception("Response is invalid.");
      }
      final endpoint = res.get("endpoint", "");
      if (endpoint.isEmpty) {
        throw Exception("Response is invalid.");
      }
      final onClosed = () {
        _loadingCompleter?.complete();
        _loadingCompleter = null;
      };
      final webView = _StripeConnectWebview(
        Uri.parse(endpoint),
        shouldOverrideUrlLoading: (controller, url) {
          final path =
              url.trimQuery().replaceAll(StripeConnectCore._callbackUrl, "");
          switch (path) {
            case "/dashboard/finished":
            case "https://connect.stripe.com/express_login":
              if (popWhenClosedByWebview) {
                context.navigator.pop();
              }
              onClosed.call();
              return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
        },
        onCloseWindow: (controller) {
          onClosed.call();
        },
      );
      builder.call(webView, onClosed);
      await _loadingCompleter!.future;
      _loadingCompleter?.complete();
      _loadingCompleter = null;
      notifyListeners();
    } catch (e) {
      _loadingCompleter?.completeError(e);
      _loadingCompleter = null;
      rethrow;
    } finally {
      _loadingCompleter?.complete();
      _loadingCompleter = null;
    }
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
      return _value;
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
          "mode": _StripeConnectAPIMode.createAccount.id,
          "userId": uid,
          "refreshUrl":
              "${StripeConnectCore._callbackUrl}/create_account/refresh",
          "returnUrl":
              "${StripeConnectCore._callbackUrl}/create_account/success",
        },
      );
      if (res.isEmpty) {
        throw Exception("Response is invalid.");
      }
      final accountId = res.get("accountId", "");
      if (accountId.isEmpty) {
        throw Exception("Response is invalid.");
      }
      if (res.get("next", "") == "registration") {
        final endpoint = res.get("endpoint", "");
        if (endpoint.isEmpty) {
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
              case "/create_account/success":
                if (popWhenClosedByWebview) {
                  context.navigator.pop();
                }
                onSuccess.call();
                return NavigationActionPolicy.CANCEL;
              case "/create_account/refresh":
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
          return !registered;
        }).timeout(timeout);
        _savingCompleter?.complete();
        _savingCompleter = null;
        _internalCompleter?.complete();
        _internalCompleter = null;
        notifyListeners();
        return _value;
      } else {
        _savingCompleter
            ?.completeError(StripeConnectAlreadyRegisteredException());
        _savingCompleter = null;
        _internalCompleter.complete();
        _internalCompleter = null;
        notifyListeners();
        return _value;
      }
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

  @override
  void dispose() {
    super.dispose();
    _value.removeListener(_handledOnUpdate);
  }
}
