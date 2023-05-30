part of masamune_purchase_stripe;

class StripeAccount extends ChangeNotifier {
  StripeAccount();

  static Completer<void>? _completer;

  static const documentQuery = StripeUserModel.document;
  static const collectionQuery = StripeUserModel.collection;

  Future<void> create({
    required String userId,
    Locale locale = const Locale("en", "US"),
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
      if (userId.isEmpty) {
        throw Exception("UserId is empty.");
      }
      final modelQuery = documentQuery(userId).modelQuery;
      final userDocument = $StripeUserModelDocument(modelQuery);
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
        action: StripeCreateAccountAction(
          userId: userId,
          locale: locale,
          refreshUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.refreshOnCreateAccount.trimString("/")}"),
          returnUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.successOnCreateAccount.trimString("/")}"),
        ),
      );

      if (response == null) {
        throw Exception("Response is invalid.");
      }
      if (response.accountId.isEmpty) {
        throw Exception("Response is invalid.");
      }
      if (response.nextAction ==
          StripeCreateAccountNextActionType.registration) {
        final endpoint = response.endpoint;
        if (endpoint == null) {
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
          endpoint,
          shouldOverrideUrlLoading: (url) {
            final path = url.trimQuery().replaceAll(callbackHost, "");

            if (path ==
                "/${returnPathOptions.successOnCreateAccount.trimString("/")}") {
              onClosed?.call();
              onSuccess.call();
              return StripeNavigationActionPolicy.cancel;
            } else if (path ==
                "/${returnPathOptions.refreshOnCreateAccount.trimString("/")}") {
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
        builder.call(endpoint, webView, onSuccess, onCancel);
        if (!kIsWeb) {
          await internalCompleter!.future;
          await Future.doWhile(() async {
            await Future.delayed(const Duration(milliseconds: 100));
            await userDocument.reload();
            return userDocument.value?.registered ?? false;
          }).timeout(timeout);
        }
        _completer?.complete();
        _completer = null;
      } else {
        _completer?.completeError(StripeAlreadyRegisteredException());
        _completer = null;
      }
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

  Future<void> delete({
    required DocumentBase<StripeUserModel> account,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final value = account.value;
      if (value == null || value.accountId.isEmpty) {
        throw Exception(
          "Account information is empty. Please run [create] method.",
        );
      }
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeDeleteAccountAction(
          userId: value.userId,
        ),
      );
      if (response == null) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await account.reload();
        return account.value?.accountId.isNotEmpty ?? false;
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

  Future<void> dashboard({
    required DocumentBase<StripeUserModel> account,
    required void Function(
      Uri endpoint,
      Widget webView,
      VoidCallback onClosed,
    ) builder,
    VoidCallback? onClosed,
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    Completer<void>? internalCompleter = Completer<void>();
    try {
      final value = account.value;
      if (value == null || value.accountId.isEmpty) {
        throw Exception(
          "Account information is empty. Please run [create] method.",
        );
      }
      if (!value.registered) {
        throw Exception("Your account has not been registered yet.");
      }
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;
      final callbackHost = StripePurchaseMasamuneAdapter
          .primary.callbackURLSchemeOrHost
          .toString()
          .trimQuery()
          .trimString("/");

      final response = await functionsAdapter.stipe(
        action: StripeDashboardAccountAction(
          userId: value.userId,
        ),
      );
      if (response == null) {
        throw Exception("Response is invalid.");
      }
      onCompleted() {
        internalCompleter?.complete();
        internalCompleter = null;
      }

      final webView = StripeWebview(
        response.endpoint,
        shouldOverrideUrlLoading: (url) {
          final path = url.trimQuery().replaceAll(callbackHost, "");
          switch (path) {
            case "/dashboard/finished":
            case "https://connect.stripe.com/express_login":
              onClosed?.call();
              onCompleted.call();
              return StripeNavigationActionPolicy.cancel;
          }
          return StripeNavigationActionPolicy.allow;
        },
        onCloseWindow: () {
          onCompleted.call();
        },
      );
      if (!kIsWeb) {
        builder.call(response.endpoint, webView, onCompleted);
        await internalCompleter!.future;
      }
      internalCompleter?.complete();
      internalCompleter = null;
      _completer?.complete();
      _completer = null;
      notifyListeners();
    } catch (e) {
      internalCompleter?.completeError(e);
      internalCompleter = null;
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      internalCompleter?.complete();
      internalCompleter = null;
      _completer?.complete();
      _completer = null;
    }
  }
}
