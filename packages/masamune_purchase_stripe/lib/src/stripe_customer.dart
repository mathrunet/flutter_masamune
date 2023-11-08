part of '/masamune_purchase_stripe.dart';

/// Create a stripe customer (payment account).
///
/// Basically, the payment account and payment information are created together.
///
/// You can make payments within Stripe by creating a payment account.
///
/// ストライプのカスタマー（支払いアカウント）を作成します。
///
/// 基本的には支払いアカウントと支払い情報を一緒に作成します。
///
/// 支払いアカウントを作成することでStripe内で決済を行うことが可能です。
class StripeCustomer
    extends MasamuneControllerBase<void, StripePurchaseMasamuneAdapter> {
  /// Create a stripe customer (payment account).
  ///
  /// Basically, the payment account and payment information are created together.
  ///
  /// You can make payments within Stripe by creating a payment account.
  ///
  /// ストライプのカスタマー（支払いアカウント）を作成します。
  ///
  /// 基本的には支払いアカウントと支払い情報を一緒に作成します。
  ///
  /// 支払いアカウントを作成することでStripe内で決済を行うことが可能です。
  StripeCustomer({super.adapter});

  /// Query for StripeCustomer.
  ///
  /// ```dart
  /// appRef.controller(StripeCustomer.query(parameters));     // Get from application scope.
  /// ref.app.controller(StripeCustomer.query(parameters));    // Watch at application scope.
  /// ref.page.controller(StripeCustomer.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$StripeCustomerQuery();

  /// Use this to retrieve the relevant [StripeUserModel] documentation.
  ///
  /// 関連する[StripeUserModel]のドキュメントを取得する場合はこちらを利用してください。
  static const document = StripeUserModel.document;

  /// Use this to retrieve the related [StripeUserModel] collection.
  ///
  /// 関連する[StripeUserModel]のコレクションを取得する場合はこちらを利用してください。
  static const collection = StripeUserModel.collection;

  @override
  StripePurchaseMasamuneAdapter get primaryAdapter =>
      StripePurchaseMasamuneAdapter.primary;

  Completer<void>? _completer;

  /// Create a stripe customer (payment account) associated with [userId].
  ///
  /// Create a screen using the WebView passed from [builder].
  ///
  /// The [onClosed] option allows you to specify what to do when the screen is closed.
  ///
  /// [userId]に関連するストライプのカスタマー（支払いアカウント）を作成します。
  ///
  /// [builder]から渡されるWebViewを利用して画面を作成してください。
  ///
  /// [onClosed]で画面が閉じられた場合の処理を指定することができます。
  Future<void> create({
    required String userId,
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
      final modelQuery = document(userId).modelQuery;
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
        StripeCreateCustomerAndPaymentAction(
          userId: userId,
          successUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.successOnCreateCustormerAndPayment.trimString("/")}"),
          cancelUrl: Uri.parse(
              "$callbackHost/${returnPathOptions.cancelOnCreateCustormerAndPayment.trimString("/")}"),
        ),
      );

      if (response.customerId.isEmpty) {
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
        await userDocument.reload();
        return userDocument.value?.customerId.isNotEmpty ?? false;
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

  /// Delete the created [customer].
  ///
  /// 作成された[customer]を削除します。
  Future<void> delete({
    required DocumentBase<StripeUserModel> customer,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_completer != null) {
      return _completer!.future;
    }
    _completer = Completer<void>();
    try {
      final value = customer.value;
      if (value == null || value.customerId.isEmpty) {
        throw Exception(
          "Customer information is empty. Please run [create] method.",
        );
      }
      final modelQuery = document(value.userId).modelQuery;
      final userDocument = StripeUserModelDocument(modelQuery);
      final functionsAdapter =
          StripePurchaseMasamuneAdapter.primary.functionsAdapter ??
              FunctionsAdapter.primary;

      await functionsAdapter.execute(
        StripeDeleteCustomerAction(
          userId: value.userId,
        ),
      );
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        await userDocument.reload();
        return userDocument.value?.customerId.isNotEmpty ?? false;
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
class _$StripeCustomerQuery {
  const _$StripeCustomerQuery();

  @useResult
  _$_StripeCustomerQuery call() => _$_StripeCustomerQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_StripeCustomerQuery extends ControllerQueryBase<StripeCustomer> {
  const _$_StripeCustomerQuery(this._name);

  final String _name;

  @override
  StripeCustomer Function() call(Ref ref) {
    return () => StripeCustomer();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
