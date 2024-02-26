part of "web.dart";

/// Initial setup for handling InAppPurchase on mobile [MasamuneAdapter].
///
/// Define all billable items to be used in the app in [products].
///
/// モバイルでのInAppPurchaseを取り扱うための初期設定を行う[MasamuneAdapter]。
///
/// [products]にアプリ内で利用するすべての課金用のアイテムを定義してください。
class MobilePurchaseMasamuneAdapter extends PurchaseMasamuneAdapter {
  /// Initial setup for handling InAppPurchase on mobile [MasamuneAdapter].
  ///
  /// Define all billable items to be used in the app in [products].
  ///
  /// モバイルでのInAppPurchaseを取り扱うための初期設定を行う[MasamuneAdapter]。
  ///
  /// [products]にアプリ内で利用するすべての課金用のアイテムを定義してください。
  const MobilePurchaseMasamuneAdapter({
    super.functionsAdapter,
    super.modelAdapter,
    required super.products,
    this.automaticallyConsumeOnAndroid = true,
    this.iosSandboxTesting = false,
    required super.onRetrieveUserId,
    super.purchase,
  });

  /// If you are using an Android device, set to `true` to automatically consume charged items.
  ///
  /// Android端末を利用している場合、課金アイテムを自動的に消費する場合`true`に設定します。
  final bool automaticallyConsumeOnAndroid;

  /// Set to `true` if you want to debug with SandboxTesting if you are using an IOS terminal.
  ///
  /// IOS端末を利用している場合SandboxTestingでデバッグをしたい場合`true`を設定します。
  final bool iosSandboxTesting;

  @override
  Future<List<PurchaseProduct>> getProducts({
    required String? Function() onRetrieveUserId,
  }) async {
    throw UnsupportedError("Purchasing function is not supported.");
  }

  @override
  StreamSubscription? listenPurchase({
    required List<PurchaseProduct> products,
    required VoidCallback onDone,
    required VoidCallback onDisposed,
    required void Function(Object e, StackTrace? stacktrace) onError,
  }) {
    throw UnsupportedError("Purchasing function is not supported.");
  }

  @override
  Future<void> initialize() {
    throw UnsupportedError("Purchasing function is not supported.");
  }

  @override
  Future<void> restore(List<PurchaseProduct> products) {
    throw UnsupportedError("Purchasing function is not supported.");
  }

  @override
  Future<void> purchase({
    required PurchaseProduct product,
    required VoidCallback onDone,
    PurchaseProduct? replacedProduct,
  }) async {
    throw UnsupportedError("Purchasing function is not supported.");
  }
}
