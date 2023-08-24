part of masamune_purchase_stripe;

/// Manage your stripe account (revenue receiver).
///
/// By creating this account, you can receive earnings from other users.
///
/// You can check your account information on the [dashboard].
///
/// ストライプのアカウント（収益受け取り側）を管理します。
///
/// このアカウントを作成することで他ユーザーからの収益を受け取ることができます。
///
/// [dashboard]でアカウントの情報を確認することができます。
class StripeAccount
    extends MasamuneControllerBase<void, StripePurchaseMasamuneAdapter> {
  /// Manage your stripe account (revenue receiver).
  ///
  /// By creating this account, you can receive earnings from other users.
  ///
  /// You can check your account information on the [dashboard].
  ///
  /// ストライプのアカウント（収益受け取り側）を管理します。
  ///
  /// このアカウントを作成することで他ユーザーからの収益を受け取ることができます。
  ///
  /// [dashboard]でアカウントの情報を確認することができます。
  StripeAccount({super.adapter});

  /// Query for StripeAccount.
  ///
  /// ```dart
  /// appRef.controller(StripeAccount.query(parameters));     // Get from application scope.
  /// ref.app.controller(StripeAccount.query(parameters));    // Watch at application scope.
  /// ref.page.controller(StripeAccount.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$StripeAccountQuery();

  /// Use this to retrieve the relevant [StripeUserModel] documentation.
  ///
  /// 関連する[StripeUserModel]のドキュメントを取得する場合はこちらを利用してください。
  static const documentQuery = StripeUserModel.document;

  /// Use this to retrieve the related [StripeUserModel] collection.
  ///
  /// 関連する[StripeUserModel]のコレクションを取得する場合はこちらを利用してください。
  static const collectionQuery = StripeUserModel.collection;

  @override
  StripePurchaseMasamuneAdapter get primaryAdapter =>
      StripePurchaseMasamuneAdapter.primary;

  Completer<void>? _completer;

  /// Create a new stripe account (revenue receiver).
  ///
  /// Specify the [userId] of the associated app.
  ///
  /// Specify [builder] to specify how to display WebView.
  ///
  /// If [onClosed] is specified, it is called when WebView is closed.
  ///
  /// 新しくストライプのアカウント（収益受け取り側）を作成します。
  ///
  /// 関連するアプリの[userId]を指定してください。
  ///
  /// [builder]を指定して、WebViewを表示する方法を指定してください。
  ///
  /// [onClosed]を指定すると、WebViewが閉じられた時に呼び出されます。
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
      final userDocument = StripeUserModelDocument(modelQuery);
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

      final response = await functionsAdapter.execute(
        StripeCreateAccountAction(
          userId: userId,
          locale: locale,
          refreshUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.cancelOnCreateAccount.trimString("/")}"),
          returnUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.successOnCreateAccount.trimString("/")}"),
        ),
      );

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
                "/${returnPathOptions.cancelOnCreateAccount.trimString("/")}") {
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

  /// Delete the created [account].
  ///
  /// 作成された[account]を削除します。
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

      await functionsAdapter.execute(
        StripeDeleteAccountAction(
          userId: value.userId,
        ),
      );
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

  /// Open the registered [account] in the dashboard.
  ///
  /// In [builder], the URL of the dashboard, a widget for displaying the WebView, and a callback when the WebView is closed are passed, so display the WebView based on these.
  ///
  /// If [onClosed] is specified, it is called when WebView is closed.
  ///
  /// 登録された[account]をダッシュボードで開きます。
  ///
  /// [builder]には、ダッシュボードのURLと、WebViewを表示するためのWidget、WebViewを閉じた時のコールバックを渡されるのでそれを元にWebViewを表示してください。
  ///
  /// [onClosed]を指定すると、WebViewが閉じられた時に呼び出されます。
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

      final response = await functionsAdapter.execute(
        StripeDashboardAccountAction(
          userId: value.userId,
        ),
      );
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

@immutable
class _$StripeAccountQuery {
  const _$StripeAccountQuery();

  @useResult
  _$_StripeAccountQuery call() => _$_StripeAccountQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_StripeAccountQuery extends ControllerQueryBase<StripeAccount> {
  const _$_StripeAccountQuery(
    this._name,
  );

  final String _name;

  @override
  StripeAccount Function() call(Ref ref) {
    return () => StripeAccount();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
