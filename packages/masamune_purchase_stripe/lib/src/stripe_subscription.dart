part of masamune_purchase_stripe;

/// Controller to manage subscriptions as defined in the stripe configuration screen.
///
/// [create] to start a subscription and [delete] to cancel a subscription.
///
/// ストライプの設定画面で定義されたサブスクリプションを管理するためのコントローラー。
///
/// [create]で購読開始し、[delete]で購読をキャンセルします。
class StripeSubscription
    extends MasamuneControllerBase<void, StripePurchaseMasamuneAdapter> {
  /// Controller to manage subscriptions as defined in the stripe configuration screen.
  ///
  /// [create] to start a subscription and [delete] to cancel a subscription.
  ///
  /// ストライプの設定画面で定義されたサブスクリプションを管理するためのコントローラー。
  ///
  /// [create]で購読開始し、[delete]で購読をキャンセルします。
  StripeSubscription({
    required this.userId,
    super.adapter,
  });

  /// Query for StripeSubscription.
  ///
  /// ```dart
  /// appRef.controller(StripeSubscription.query(parameters));     // Get from application scope.
  /// ref.app.controller(StripeSubscription.query(parameters));    // Watch at application scope.
  /// ref.page.controller(StripeSubscription.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$StripeSubscriptionQuery();

  /// Use this to retrieve the relevant [StripePurchaseModel] documentation.
  ///
  /// 関連する[StripePurchaseModel]のドキュメントを取得する場合はこちらを利用してください。
  static const document = StripePurchaseModel.document;

  /// Use this to retrieve the related [StripePurchaseModel] collection.
  ///
  /// 関連する[StripePurchaseModel]のコレクションを取得する場合はこちらを利用してください。
  static const collection = StripePurchaseModel.collection;

  @override
  StripePurchaseMasamuneAdapter get primaryAdapter =>
      StripePurchaseMasamuneAdapter.primary;

  /// User ID in the application.
  ///
  /// アプリ内のユーザーID。
  final String userId;

  Completer<void>? _completer;

  /// Purchase a subscription to [productId] at [orderId].
  ///
  /// Implement the subscription purchase screen by specifying [builder].
  ///
  /// If you specify [onClosed], it will be called when the purchase screen is closed.
  ///
  /// [orderId]で[productId]のサブスクリプションを購入します。
  ///
  /// [builder]を指定してサブスクリプションの購入画面を実装してください。
  ///
  /// [onClosed]を指定すると、購入画面が閉じられたときに呼び出されます。
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
      final modelQuery = collection(userId: userId).modelQuery;
      final purchaseCollection = StripePurchaseModelCollection(
        modelQuery.equal(StripePurchaseModelKeys.orderId.name, orderId),
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

      final response = await functionsAdapter.execute(
        StripeCreateSubscriptionAction(
          userId: userId,
          orderId: orderId,
          productId: productId,
          successUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.successOnCreateSubscription.trimString("/")}"),
          cancelUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.cancelOnCreateSubscription.trimString("/")}"),
        ),
      );

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
        await purchaseCollection.reload();
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

  /// Delete (cancel) a subscription to [purchase] that has been started.
  ///
  /// 開始した[purchase]のサブスクリプションを削除（キャンセル）します。
  Future<void> delete({
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
      final modelQuery = collection(userId: userId).modelQuery;
      final purchaseCollection = StripePurchaseModelCollection(
        modelQuery.equal(StripePurchaseModelKeys.orderId.name, value.orderId),
      );
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      await functionsAdapter.execute(
        StripeDeleteSubscriptionAction(
          orderId: value.orderId,
        ),
      );
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await purchaseCollection.reload();
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

@immutable
class _$StripeSubscriptionQuery {
  const _$StripeSubscriptionQuery();

  @useResult
  _$_StripeSubscriptionQuery call({
    required String userId,
  }) =>
      _$_StripeSubscriptionQuery(
        hashCode.toString(),
        userId: userId,
      );
}

@immutable
class _$_StripeSubscriptionQuery
    extends ControllerQueryBase<StripeSubscription> {
  const _$_StripeSubscriptionQuery(
    this._name, {
    required this.userId,
  });

  final String _name;
  final String userId;

  @override
  StripeSubscription Function() call(Ref ref) {
    return () => StripeSubscription(userId: userId);
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
