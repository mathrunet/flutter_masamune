part of "/masamune_storage_functions.dart";

/// A database for temporarily storing storage data obtained from Firebase Functions.
///
/// FirebaseFunctionsから取得したストレージデータを一時格納しておくためのデータベース。
class FunctionsStorageDatabase {
  /// A database for temporarily storing storage data obtained from Firebase Functions.
  ///
  /// FirebaseFunctionsから取得したストレージデータを一時格納しておくためのデータベース。
  FunctionsStorageDatabase();

  final Map<String, FunctionsStorageDatabaseItem> _items = {};

  /// Add a item to the database.
  ///
  /// データベースにアイテムを追加します。
  void add(String remoteRelativePathOrId, {Uint8List? data, DynamicMap? meta}) {
    _items[remoteRelativePathOrId] = FunctionsStorageDatabaseItem(
      remoteRelativePathOrId: remoteRelativePathOrId,
      data: data,
      meta: meta,
    );
  }

  /// Get a item from the database.
  ///
  /// データベースからアイテムを取得します。
  FunctionsStorageDatabaseItem? get(String remoteRelativePathOrId) {
    return _items[remoteRelativePathOrId];
  }

  /// Remove a item from the database.
  ///
  /// データベースからアイテムを削除します。
  void remove(String remoteRelativePathOrId) {
    _items.remove(remoteRelativePathOrId);
  }

  /// Clear the database.
  ///
  /// データベースをクリアします。
  void clear() {
    _items.clear();
  }
}

/// A item for temporarily storing storage data obtained from Firebase Functions.
///
/// FirebaseFunctionsから取得したストレージデータを一時格納しておくためのアイテム。
class FunctionsStorageDatabaseItem {
  /// A item for temporarily storing storage data obtained from Firebase Functions.
  ///
  /// FirebaseFunctionsから取得したストレージデータを一時格納しておくためのアイテム。
  const FunctionsStorageDatabaseItem({
    required this.remoteRelativePathOrId,
    this.data,
    this.meta,
  });

  /// Remote relative path or id.
  ///
  /// リモート相対パスまたはID。
  final String remoteRelativePathOrId;

  /// Data.
  ///
  /// データ。
  final Uint8List? data;

  /// Meta.
  ///
  /// メタデータ。
  final DynamicMap? meta;
}
