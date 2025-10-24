part of "/masamune_model_docs_builder.dart";

/// Firestore rule value type.
///
/// Firestoreのルールの値の型。
enum DocsType {
  /// String.
  ///
  /// 文字列。
  string,

  /// Bool.
  ///
  /// 真偽値。
  bool,

  /// Int.
  ///
  /// 整数。
  int,

  /// Double.
  ///
  /// 小数。
  double,

  /// List.
  ///
  /// リスト。
  list,

  /// Map.
  ///
  /// マップ。
  map,

  /// Timestamp.
  ///
  /// タイムスタンプ。
  timestamp,

  /// GeoPoint.
  ///
  /// ジオポイント。
  geo,

  /// Reference.
  ///
  /// リファレンス。
  reference,

  /// Enum type.
  ///
  /// Enum型。
  enumType,

  /// Null or undefined.
  ///
  /// Nullまたは未定義。
  nullOrUndefined,

  /// Undefined.
  ///
  /// 未定義。
  undefined;

  /// Obtain a label for the application.
  ///
  /// アプリ用のラベルを取得します。
  String get app {
    switch (this) {
      case DocsType.undefined:
        return "undefined";
      case DocsType.nullOrUndefined:
        return "null | undefined";
      case DocsType.string:
        return "string";
      case DocsType.bool:
        return "bool";
      case DocsType.int:
        return "int";
      case DocsType.double:
        return "double";
      case DocsType.list:
        return "List";
      case DocsType.map:
        return "Map";
      case DocsType.timestamp:
        return "DateTime";
      case DocsType.geo:
        return "GeoValue";
      case DocsType.reference:
        return "ModelRef";
      case DocsType.enumType:
        return "Enum";
    }
  }

  /// Obtain labels for NoSQL.
  ///
  /// NoSQL用のラベルを取得します。
  String get nosql {
    switch (this) {
      case DocsType.undefined:
        return "null";
      case DocsType.nullOrUndefined:
        return "null";
      case DocsType.string:
        return "string";
      case DocsType.bool:
        return "bool";
      case DocsType.int:
        return "number";
      case DocsType.double:
        return "number";
      case DocsType.list:
        return "array";
      case DocsType.map:
        return "map";
      case DocsType.timestamp:
        return "timestamp";
      case DocsType.geo:
        return "geo";
      case DocsType.reference:
        return "reference";
      case DocsType.enumType:
        return "string";
    }
  }

  /// Obtain labels for RDB.
  ///
  /// RDB用のラベルを取得します。
  String get rdb {
    switch (this) {
      case DocsType.undefined:
        return "null";
      case DocsType.nullOrUndefined:
        return "null";
      case DocsType.string:
        return "string";
      case DocsType.bool:
        return "bool";
      case DocsType.int:
        return "int";
      case DocsType.double:
        return "float";
      case DocsType.list:
        return "json";
      case DocsType.map:
        return "json";
      case DocsType.timestamp:
        return "timestamp / datetime";
      case DocsType.geo:
        return "json";
      case DocsType.reference:
        return "reference";
      case DocsType.enumType:
        return "string";
    }
  }
}

/// The type of [ModelFieldValue] in the Firestore rules.
///
/// Firestoreのルールの[ModelFieldValue]の型。
enum DocsModelFieldValueType {
  /// [ModelCounter].
  ///
  /// [ModelCounter]。
  modelCounter,

  /// [ModelTimestamp].
  ///
  /// [ModelTimestamp]。
  modelTimestamp,

  /// [ModelDate].
  ///
  /// [ModelDate]。
  modelDate,

  /// [ModelTime].
  ///
  /// [ModelTime]。
  modelTime,

  /// [ModelTimestampRange].
  ///
  /// [ModelTimestampRange]。
  modelTimestampRange,

  /// [ModelDateRange].
  ///
  /// [ModelDateRange]。
  modelDateRange,

  /// [ModelTimeRange].
  ///
  /// [ModelTimeRange]。
  modelTimeRange,

  /// [ModelCommand].
  ///
  /// [ModelCommand]。
  modelCommand,

  /// [ModelGeoValue].
  ///
  /// [ModelGeoValue]。
  modelGeoValue,

  /// [ModelVectorValue].
  ///
  /// [ModelVectorValue]。
  modelVectorValue,

  /// [ModelUri].
  ///
  /// [ModelUri]。
  modelUri,

  /// [ModelImageUri].
  ///
  /// [ModelImageUri]。
  modelImageUri,

  /// [ModelVideoUri].
  ///
  /// [ModelVideoUri]。
  modelVideoUri,

  /// [ModelLocale].
  ///
  /// [ModelLocale]。
  modelLocale,

  /// [ModelLocalizedValue].
  ///
  /// [ModelLocalizedValue]。
  modelLocalizedValue,

  /// [ModelRef].
  ///
  /// [ModelRef]。
  modelRef,

  /// [ModelSearch].
  ///
  /// [ModelSearch]。
  modelSearch,

  /// [ModelToken].
  ///
  /// [ModelToken]。
  modelToken;

  /// Obtain a label for the application.
  ///
  /// アプリ用のラベルを取得します。
  String get app {
    switch (this) {
      case DocsModelFieldValueType.modelCounter:
        return "ModelCounter";
      case DocsModelFieldValueType.modelTimestamp:
        return "ModelTimestamp";
      case DocsModelFieldValueType.modelDate:
        return "ModelDate";
      case DocsModelFieldValueType.modelTime:
        return "ModelTime";
      case DocsModelFieldValueType.modelTimestampRange:
        return "ModelTimestampRange";
      case DocsModelFieldValueType.modelDateRange:
        return "ModelDateRange";
      case DocsModelFieldValueType.modelTimeRange:
        return "ModelTimeRange";
      case DocsModelFieldValueType.modelCommand:
        return "ModelCommand";
      case DocsModelFieldValueType.modelGeoValue:
        return "ModelGeoValue";
      case DocsModelFieldValueType.modelVectorValue:
        return "ModelVectorValue";
      case DocsModelFieldValueType.modelUri:
        return "ModelUri";
      case DocsModelFieldValueType.modelImageUri:
        return "ModelImageUri";
      case DocsModelFieldValueType.modelVideoUri:
        return "ModelVideoUri";
      case DocsModelFieldValueType.modelLocale:
        return "ModelLocale";
      case DocsModelFieldValueType.modelLocalizedValue:
        return "ModelLocalizedValue";
      case DocsModelFieldValueType.modelRef:
        return "ModelRef";
      case DocsModelFieldValueType.modelSearch:
        return "ModelSearch";
      case DocsModelFieldValueType.modelToken:
        return "ModelToken";
    }
  }

  /// Obtain labels for NoSQL.
  ///
  /// NoSQL用のラベルを取得します。
  String get nosql {
    switch (this) {
      case DocsModelFieldValueType.modelCounter:
        return "number";
      case DocsModelFieldValueType.modelTimestamp:
        return "timestamp";
      case DocsModelFieldValueType.modelDate:
        return "timestamp";
      case DocsModelFieldValueType.modelTime:
        return "timestamp";
      case DocsModelFieldValueType.modelTimestampRange:
        return "string";
      case DocsModelFieldValueType.modelDateRange:
        return "string";
      case DocsModelFieldValueType.modelTimeRange:
        return "string";
      case DocsModelFieldValueType.modelCommand:
        return "string";
      case DocsModelFieldValueType.modelGeoValue:
        return "geo";
      case DocsModelFieldValueType.modelVectorValue:
        return "vector";
      case DocsModelFieldValueType.modelUri:
        return "string";
      case DocsModelFieldValueType.modelImageUri:
        return "string";
      case DocsModelFieldValueType.modelVideoUri:
        return "string";
      case DocsModelFieldValueType.modelLocale:
        return "string";
      case DocsModelFieldValueType.modelLocalizedValue:
        return "array";
      case DocsModelFieldValueType.modelRef:
        return "reference";
      case DocsModelFieldValueType.modelSearch:
        return "array";
      case DocsModelFieldValueType.modelToken:
        return "array";
    }
  }

  /// Obtain labels for auxiliary NoSQL.
  ///
  /// 補助用のNoSQL用のラベルを取得します。
  String? get subNosql {
    switch (this) {
      case DocsModelFieldValueType.modelCounter:
        return "map";
      case DocsModelFieldValueType.modelTimestamp:
        return "map";
      case DocsModelFieldValueType.modelDate:
        return "map";
      case DocsModelFieldValueType.modelTime:
        return "map";
      case DocsModelFieldValueType.modelTimestampRange:
        return "map";
      case DocsModelFieldValueType.modelDateRange:
        return "map";
      case DocsModelFieldValueType.modelTimeRange:
        return "map";
      case DocsModelFieldValueType.modelCommand:
        return "map";
      case DocsModelFieldValueType.modelGeoValue:
        return "map";
      case DocsModelFieldValueType.modelVectorValue:
        return "map";
      case DocsModelFieldValueType.modelUri:
        return "map";
      case DocsModelFieldValueType.modelImageUri:
        return "map";
      case DocsModelFieldValueType.modelVideoUri:
        return "map";
      case DocsModelFieldValueType.modelLocale:
        return "map";
      case DocsModelFieldValueType.modelLocalizedValue:
        return "map";
      case DocsModelFieldValueType.modelRef:
        return null;
      case DocsModelFieldValueType.modelSearch:
        return "map";
      case DocsModelFieldValueType.modelToken:
        return "map";
    }
  }

  /// Obtain labels for RDB.
  ///
  /// RDB用のラベルを取得します。
  String get rdb {
    switch (this) {
      case DocsModelFieldValueType.modelCounter:
        return "json";
      case DocsModelFieldValueType.modelTimestamp:
        return "json";
      case DocsModelFieldValueType.modelDate:
        return "json";
      case DocsModelFieldValueType.modelTime:
        return "json";
      case DocsModelFieldValueType.modelTimestampRange:
        return "json";
      case DocsModelFieldValueType.modelDateRange:
        return "json";
      case DocsModelFieldValueType.modelTimeRange:
        return "json";
      case DocsModelFieldValueType.modelCommand:
        return "json";
      case DocsModelFieldValueType.modelGeoValue:
        return "json";
      case DocsModelFieldValueType.modelVectorValue:
        return "json";
      case DocsModelFieldValueType.modelUri:
        return "json";
      case DocsModelFieldValueType.modelImageUri:
        return "json";
      case DocsModelFieldValueType.modelVideoUri:
        return "json";
      case DocsModelFieldValueType.modelLocale:
        return "json";
      case DocsModelFieldValueType.modelLocalizedValue:
        return "json";
      case DocsModelFieldValueType.modelRef:
        return "json";
      case DocsModelFieldValueType.modelSearch:
        return "json";
      case DocsModelFieldValueType.modelToken:
        return "json";
    }
  }
}
