part of katana_module;

/// Module adapter for setting up market place purchasing.
///
/// [MarketPlaceAdapter] can switch the data
/// when the module is used by passing it to [UIMaterialApp].
@immutable
abstract class MarketPlaceAdapter<
    TAccount extends MarketPlaceAccountAdapter,
    TPaymentMethod extends MarketPlacePaymentMethodAdapter,
    TPurchase extends MarketPlacePurchaseAdapter> extends AdapterModule {
  const MarketPlaceAdapter();

  /// Class for managing market place process.
  ///
  /// Initialize by first executing [initialize()].
  Future<void> initialize();

  /// Adapter for accounts.
  TAccount get account;

  /// Adapter for payment method.
  TPaymentMethod get payment;

  /// Adapter for purchase.
  TPurchase get purchase;

  /// Runs after authentication has taken place.
  ///
  /// It is also called after registration or login has been completed.
  @override
  @mustCallSuper
  Future<void> onAfterAuth(BuildContext context) async {
    await super.onAfterAuth(context);
    await initialize();
  }
}

@immutable
abstract class MarketPlaceAccountAdapter<
    TAccountDocument extends DynamicDocumentModel> {
  const MarketPlaceAccountAdapter();

  /// Retrieve the model provider.
  ChangeNotifierProvider get modelProvider;

  /// Get the provider of the document that [userId] possesses.
  ChangeNotifierProvider<TAccountDocument> documentProvider(String userId);

  /// Reload the account data.
  Future<void> reload();

  /// True if the account exists.
  bool get exists;

  /// True if account is already registered.
  bool get registered;

  /// Seller account registration.
  ///
  /// The account document will be returned.
  Future<DynamicDocumentModel> registerSeller();

  /// View the dashboard for sellers & buyers.
  Future<void> dashboard();
}

@immutable
abstract class MarketPlacePaymentMethodAdapter<
    TPaymentMethodDocument extends DynamicDocumentModel,
    TPaymentMethodCollection extends DynamicCollectionModel> {
  const MarketPlacePaymentMethodAdapter();

  /// Retrieve the model provider.
  ChangeNotifierProvider get modelProvider;

  /// Get the provider of the document that [userId] possesses.
  ChangeNotifierProvider<TPaymentMethodCollection> collectionProvider(
    String userId,
  );

  /// Reload the payment method data.
  Future<void> reload();

  /// True if at least one payment method exists.
  bool get exists;

  /// Set up your payment method with [paymentMethodId].
  ///
  /// The created PaymentMethod will be returned.
  Future<TPaymentMethodDocument> create();

  /// Set the default payment method to the one with [paymentMethodId].
  Future<void> setDefault(String paymentMethodId);

  /// Deletes the PaymentMethod with the ID of [paymentMethodId].
  Future<void> delete(String paymentMethodId);
}

@immutable
abstract class MarketPlacePurchaseAdapter<
    TProduct extends MarketPlaceProduct,
    TPurchaseDocument extends DynamicDocumentModel,
    TPurchaseCollection extends DynamicCollectionModel> {
  const MarketPlacePurchaseAdapter();

  /// Retrieve the model provider.
  ChangeNotifierProvider get modelProvider;

  /// Get the provider of the document that [userId] possesses.
  ChangeNotifierProvider<TPurchaseCollection> collectionProvider(String userId);

  /// Reload the purchase data.
  Future<void> reload();

  /// Check this [amount] to see if payment is possible.
  Future<void> authorization(double amount);

  /// Purchase the [product].
  ///
  /// Basically, after making a purchase, you must confirm the purchase by clicking [confirm].
  ///
  /// The billing is then executed by executing [capture].
  ///
  /// The created purchase will be returned.
  Future<TPurchaseDocument> purchase(TProduct product);

  /// Update the information of the purchase in [orderId].
  Future<void> refresh(String orderId);

  /// Finalize the purchase related to [orderId].
  ///
  /// If [online] is true, authentication is performed online.
  ///
  /// It is necessary that [purchase] is executed beforehand.
  Future<void> confirm(
    String orderId, {
    bool online = true,
  });

  /// Issue invoices for purchases associated with [orderId].
  ///
  /// The amount to be captured can be changed in [price].
  ///
  /// If [online] is true, authentication is performed online.
  ///
  /// It is necessary that [purchase] and [confirm] is executed beforehand.
  Future<void> capture(
    String orderId, {
    double? price,
    bool online = true,
  });

  /// Cancels the purchase for [orderId].
  Future<void> cancel(String orderId);

  /// Refund payment for the associated [orderId].
  ///
  /// The amount to be refund can be changed in [price].
  ///
  /// It is necessary that [purchase], [capture] and [confirm] is executed beforehand.
  Future<void> refund(
    String orderId, {
    double? price,
  });
}
