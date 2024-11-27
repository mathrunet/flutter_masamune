part of '/masamune_model_firestore_builder.dart';

/// Class for storing index values.
///
/// インデックスの値を格納するためのクラス。
class IndexValue {
  /// Class for storing index values.
  ///
  /// インデックスの値を格納するためのクラス。
  const IndexValue({
    required this.collectionId,
    this.queryScope = IndexScopeType.collection,
    this.fields = const [],
  });

  /// Collection ID.
  ///
  /// コレクションID。
  final String collectionId;

  /// Scope type of collection.
  ///
  /// コレクションのスコープタイプ。
  final IndexScopeType queryScope;

  /// Field Settings.
  ///
  /// フィールドの設定。
  final List<IndexFieldValue> fields;

  /// Convert to JSON.
  ///
  /// JSONに変換します。
  DynamicMap toJson() {
    return <String, dynamic>{
      "collectionGroup": collectionId,
      "queryScope": queryScope.label,
      "fields": fields.map((e) => e.toJson()).toList()
    };
  }

  @override
  int get hashCode =>
      collectionId.hashCode ^ queryScope.hashCode ^ fields.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is IndexValue) {
      return collectionId == other.collectionId &&
          queryScope == other.queryScope &&
          fields.equalsTo(other.fields);
    }
    return false;
  }
}

/// Value of the field in the index.
///
/// インデックスのフィールドの値。
class IndexFieldValue {
  /// Value of the field in the index.
  ///
  /// インデックスのフィールドの値。
  const IndexFieldValue({
    required this.name,
    this.order = IndexOrderType.asc,
    this.isArray = false,
  });

  /// Field name.
  ///
  /// フィールド名。
  final String name;

  /// Order type.
  ///
  /// オーダータイプ。
  final IndexOrderType order;

  /// `True` for arrays.
  ///
  /// 配列の場合は`true`。
  final bool isArray;

  /// Convert to JSON.
  ///
  /// JSONに変換します。
  DynamicMap toJson() {
    return <String, dynamic>{
      "fieldPath": name,
      if (isArray) "arrayConfig": "CONTAINS" else "order": order.label,
    };
  }

  @override
  int get hashCode => name.hashCode ^ order.hashCode ^ isArray.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is IndexFieldValue) {
      return name == other.name &&
          order == other.order &&
          isArray == other.isArray;
    }
    return false;
  }
}
