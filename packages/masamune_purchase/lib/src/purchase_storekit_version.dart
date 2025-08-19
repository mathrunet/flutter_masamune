part of "/masamune_purchase.dart";

/// The version of StoreKit.
///
/// StoreKitのバージョン。
enum PurchaseStoreKitVersion {
  /// StoreKit 1.
  ///
  /// StoreKit 1.
  storeKit1,

  /// StoreKit 2.
  ///
  /// StoreKit 2.
  storeKit2;

  /// Get the version of StoreKit.
  ///
  /// StoreKitのバージョンを取得します。
  int get version {
    switch (this) {
      case storeKit1:
        return 1;
      case storeKit2:
        return 2;
    }
  }
}
