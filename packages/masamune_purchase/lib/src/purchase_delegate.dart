part of '/masamune_purchase.dart';

/// Delegate to perform each process on the consumable purchase.
///
/// 消費型の購入上の各処理を行うためのデリゲート。
class ConsumablePurchaseDelegate {
  /// Delegate to perform each process on the consumable purchase.
  ///
  /// 消費型の購入上の各処理を行うためのデリゲート。
  const ConsumablePurchaseDelegate({
    this.onRetrieveUserId,
    this.onRetrieveDocument =
        StoreConsumablePurchaseProduct.defaultOnRetrieveDocument,
    this.onRetrieveValue =
        StoreConsumablePurchaseProduct.defaultOnRetrieveValue,
    this.onSaveDocument = StoreConsumablePurchaseProduct.defaultOnSaveDocument,
  });

  /// Callback to retrieve user ID. Return [Null] if the user is not logged in.
  ///
  /// ユーザーIDを取得するためのコールバック。ログインしていない場合は[Null]を返してください。
  final String? Function()? onRetrieveUserId;

  /// Callback to retrieve the document.
  ///
  /// ドキュメントを取得するためのコールバック。
  final DocumentBase? Function(PurchaseProduct product, String userId)
      onRetrieveDocument;

  /// Callback to retrieve the value.
  ///
  /// 値を取得するためのコールバック。
  final double Function(
          DocumentBase? document, PurchaseProduct product, String userId)
      onRetrieveValue;

  /// Callback to save the document.
  ///
  /// ドキュメントを保存するためのコールバック。
  final Future<void> Function(
          DocumentBase? document, PurchaseProduct product, String userId)
      onSaveDocument;
}

/// Delegate to perform each process on the non-consumable purchase.
/// 非消費型の購入上の各処理を行うためのデリゲート。
class NonConsumablePurchaseDelegate {
  /// Delegate to perform each process on the non-consumable purchase.
  ///
  /// 非消費型の購入上の各処理を行うためのデリゲート。
  const NonConsumablePurchaseDelegate({
    this.onRetrieveUserId,
    this.onRetrieveDocument =
        StoreNonConsumablePurchaseProduct.defaultOnRetrieveDocument,
    this.onRetrieveValue =
        StoreNonConsumablePurchaseProduct.defaultOnRetrieveValue,
    this.onSaveDocument =
        StoreNonConsumablePurchaseProduct.defaultOnSaveDocument,
  });

  /// Callback to retrieve user ID. Return [Null] if the user is not logged in.
  ///
  /// ユーザーIDを取得するためのコールバック。ログインしていない場合は[Null]を返してください。
  final String? Function()? onRetrieveUserId;

  /// Callback to retrieve the document.
  ///
  /// ドキュメントを取得するためのコールバック。
  final DocumentBase? Function(PurchaseProduct product, String userId)
      onRetrieveDocument;

  /// Callback to retrieve the value.
  ///
  /// 値を取得するためのコールバック。
  final bool Function(
          DocumentBase? document, PurchaseProduct product, String userId)
      onRetrieveValue;

  /// Callback to save the document.
  ///
  /// ドキュメントを保存するためのコールバック。
  final Future<void> Function(
          DocumentBase? document, PurchaseProduct product, String userId)
      onSaveDocument;
}

/// Delegate to perform each process on the subscription purchase.
///
/// 定期購入型の購入上の各処理を行うためのデリゲート。
class SubscriptionPurchaseDelegate {
  /// Delegate to perform each process on the subscription purchase.
  ///
  /// 定期購入型の購入上の各処理を行うためのデリゲート。
  const SubscriptionPurchaseDelegate({
    this.onRetrieveUserId,
    this.onRetrieveCollection =
        StoreSubscriptionPurchaseProduct.defaultOnRetrieveCollection,
    this.onRetrieveValue =
        StoreSubscriptionPurchaseProduct.defaultOnRetrieveValue,
    this.onSaveDocument =
        StoreSubscriptionPurchaseProduct.defaultOnSaveDocument,
    this.onRevokeDocument =
        StoreSubscriptionPurchaseProduct.defaultOnRevokeDocument,
  });

  /// Callback to retrieve user ID. Return [Null] if the user is not logged in.
  ///
  /// ユーザーIDを取得するためのコールバック。ログインしていない場合は[Null]を返してください。
  final String? Function()? onRetrieveUserId;

  /// Callback to retrieve the collection.
  ///
  /// コレクションを取得するためのコールバック。
  final CollectionBase? Function(PurchaseProduct product, String userId)
      onRetrieveCollection;

  /// Callback to retrieve the value.
  ///
  /// 値を取得するためのコールバック。
  final bool Function(
          CollectionBase? collection, PurchaseProduct product, String userId)
      onRetrieveValue;

  /// Callback to save the document.
  ///
  /// ドキュメントを保存するためのコールバック。
  final Future<void> Function(
    DocumentBase? document,
    PurchaseProduct product,
    String userId,
    String orderId,
    DateTime expiredTime,
  ) onSaveDocument;

  /// Callback to revoke the document.
  ///
  /// ドキュメントを削除するためのコールバック。
  final Future<void> Function(
    DocumentBase? document,
    PurchaseProduct product,
    String userId,
  ) onRevokeDocument;
}
