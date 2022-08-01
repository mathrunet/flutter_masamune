part of katana_module;

/// Module adapter for setting up purchasing.
///
/// [PurchaseAdapter] can switch the data
/// when the module is used by passing it to [UIMaterialApp].
@immutable
abstract class PurchaseAdapter<TProduct extends PurchaseProduct>
    extends AdapterModule {
  const PurchaseAdapter();

  /// Class for managing billing process.
  ///
  /// Initialize by first executing [initialize()].
  ///
  /// Then purchasing item by executing [purchase()].
  Future<void> initialize(BuildContext context);

  /// Restore purchase.
  ///
  /// Please use it manually or immediately after user registration.
  Future<void> restore();

  /// Consume all purchased items.
  ///
  /// Please use it manually or immediately after user registration.
  Future<void> consume(TProduct product);

  /// Process the purchase.
  ///
  /// You specify the purchase product data in [product], the billing process will start.
  ///
  /// If [userId] is specified, the purchase will be made with that user ID.
  Future<void> purchase(TProduct product, {String? userId});

  /// Get the [TProduct] list.
  List<TProduct> getRegisteredProducts();

  @override
  @mustCallSuper
  Future<void> onAfterAuth(BuildContext context) async {
    await super.onAfterAuth(context);
    await initialize(context);
  }
}
