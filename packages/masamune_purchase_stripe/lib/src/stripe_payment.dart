part of masamune_purchase_stripe;

/// Manage Stripe payment information.
///
/// Actual payment information should be obtained from [collectionQuery] or other sources.
///
/// Stripeの支払い情報を管理します。
///
/// 実際の支払い情報は[collectionQuery]などから取得してください。
class StripePayment
    extends MasamuneControllerBase<void, StripePurchaseMasamuneAdapter> {
  /// Manage Stripe payment information.
  ///
  /// Actual payment information should be obtained from [collectionQuery] or other sources.
  ///
  /// Stripeの支払い情報を管理します。
  ///
  /// 実際の支払い情報は[collectionQuery]などから取得してください。
  StripePayment({required this.userId});

  /// Query for StripePayment.
  ///
  /// ```dart
  /// appRef.conroller(StripePayment.query(parameters));   // Get from application scope.
  /// ref.app.conroller(StripePayment.query(parameters));  // Watch at application scope.
  /// ref.page.conroller(StripePayment.query(parameters)); // Watch at page scope.
  /// ```
  static const query = _$StripePaymentQuery();

  /// Use this to retrieve the relevant [StripePaymentModel] documentation.
  ///
  /// 関連する[StripePaymentModel]のドキュメントを取得する場合はこちらを利用してください。
  static const documentQuery = StripePaymentModel.document;

  /// Use this to retrieve the related [StripePaymentModel] collection.
  ///
  /// 関連する[StripePaymentModel]のコレクションを取得する場合はこちらを利用してください。
  static const collectionQuery = StripePaymentModel.collection;

  @override
  StripePurchaseMasamuneAdapter get primaryAdapter =>
      StripePurchaseMasamuneAdapter.primary;

  /// User ID in the application.
  ///
  /// アプリ内のユーザーID。
  final String userId;

  Completer<void>? _completer;

  /// Create new payment information.
  ///
  /// The WebView is passed to [builder], so use it to create the screen.
  ///
  /// Processing when the screen is closed can be specified with [onClosed].
  ///
  /// 支払い情報を新しく作成します。
  ///
  /// [builder]にWebViewが渡されるので、それを利用して画面を作成してください。
  ///
  /// 画面が閉じられたときの処理は[onClosed]で指定することができます。
  Future<void> create({
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
        throw Exception("You are not logged in. Please log in once.");
      }
      final modelQuery = collectionQuery(userId: userId).modelQuery;
      final paymentCollection = $StripePaymentModelCollection(modelQuery);
      await paymentCollection.load();
      final length = paymentCollection.length;
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
        action: StripeCreateCustomerAndPaymentAction(
          userId: userId,
          successUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.successOnCreateCustormerAndPayment.trimString("/")}"),
          cancelUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.cancelOnCreateCustormerAndPayment.trimString("/")}"),
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

      final webView = StripeWebview(
        response.endpoint,
        shouldOverrideUrlLoading: (url) {
          final path = url.trimQuery().replaceAll(callbackHost, "");
          if (path ==
              "/${returnPathOptions.successOnCreateCustormerAndPayment.trimString("/")}") {
            onClosed?.call();
            onSuccess.call();
            return StripeNavigationActionPolicy.cancel;
          } else if (path ==
              "/${returnPathOptions.cancelOnCreateCustormerAndPayment.trimString("/")}") {
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
        await paymentCollection.reload();
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

  /// If multiple payment information is set, set [payment] to the default payment information.
  ///
  /// 複数の支払い情報が設定されている場合[payment]をデフォルトの支払い情報に設定します。
  Future<void> setDefault({
    required DocumentBase<StripePaymentModel> payment,
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final value = payment.value;
      if (value == null) {
        throw Exception(
          "Payment information is empty. Please run [create] method.",
        );
      }
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeSetCustomerDefaultPaymentAction(
          userId: userId,
          paymentId: value.paymentId,
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

  /// Delete the created [payment].
  ///
  /// 作成した[payment]を削除します。
  Future<void> delete({
    required DocumentBase<StripePaymentModel> payment,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final value = payment.value;
      if (value == null) {
        throw Exception(
          "Payment information is empty. Please run [create] method.",
        );
      }
      final modelQuery = collectionQuery(userId: userId).modelQuery;
      final paymentCollection = $StripePaymentModelCollection(modelQuery);
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      final response = await functionsAdapter.stipe(
        action: StripeDeletePaymentAction(
          userId: userId,
          paymentId: payment.uid,
        ),
      );
      if (response == null) {
        throw Exception("Response is invalid.");
      }
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await paymentCollection.reload();
        return paymentCollection.any((e) => e.uid == payment.uid);
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
class _$StripePaymentQuery {
  const _$StripePaymentQuery();

  @useResult
  _$_StripePaymentQuery call({
    required String userId,
  }) =>
      _$_StripePaymentQuery(
        hashCode.toString(),
        userId: userId,
      );
}

@immutable
class _$_StripePaymentQuery extends ControllerQueryBase<StripePayment> {
  const _$_StripePaymentQuery(
    this._name, {
    required this.userId,
  });

  final String _name;
  final String userId;

  @override
  StripePayment Function() call(Ref ref) {
    return () => StripePayment(userId: userId);
  }

  @override
  String get name => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
