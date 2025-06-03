part of "/masamune_model_firestore_builder.dart";

/// Type of Firestore index collection.
///
/// Firestoreのインデックスのコレクションのタイプ。
enum IndexScopeType {
  /// Collection.
  ///
  /// コレクション。
  collection,

  /// Collection group.
  ///
  /// コレクショングループ。
  collectionGroup;

  /// Get the label.
  ///
  /// ラベルを取得します。
  String get label {
    switch (this) {
      case IndexScopeType.collection:
        return "COLLECTION";
      case IndexScopeType.collectionGroup:
        return "COLLECTION_GROUP";
    }
  }
}

/// Type of Firestore index order.
///
/// Firestoreのインデックスのオーダーのタイプ。
enum IndexOrderType {
  /// ASCENDING.
  ///
  /// 昇順。
  asc,

  /// DESCENDING.
  ///
  /// 降順。
  desc;

  /// Get the label.
  ///
  /// ラベルを取得します。
  String get label {
    switch (this) {
      case IndexOrderType.asc:
        return "ASCENDING";
      case IndexOrderType.desc:
        return "DESCENDING";
    }
  }
}
