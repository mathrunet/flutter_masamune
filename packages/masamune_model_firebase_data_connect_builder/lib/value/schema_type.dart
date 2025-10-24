part of "/masamune_model_firebase_data_connect_builder.dart";

/// FirebaseDataConnect rule value type.
///
/// FirebaseDataConnectのルールの値の型。
enum SchemaType {
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
  float,

  /// Other (JSON).
  ///
  /// その他（JSON)。
  any,

  /// Date.
  ///
  /// 日付。
  date,

  /// Timestamp.
  ///
  /// タイムスタンプ。
  timestamp,

  /// Null or undefined.
  ///
  /// Nullまたは未定義。
  nullOrUndefined,

  /// Undefined.
  ///
  /// 未定義。
  undefined;

  /// Get the label.
  ///
  /// ラベルを取得します。
  String get label {
    switch (this) {
      case SchemaType.undefined:
        return "Undefined";
      case SchemaType.nullOrUndefined:
        return "NullOrUndefined";
      case SchemaType.string:
        return "String";
      case SchemaType.bool:
        return "Boolean";
      case SchemaType.int:
        return "Int";
      case SchemaType.float:
        return "Float";
      case SchemaType.any:
        return "Any";
      case SchemaType.date:
        return "Date";
      case SchemaType.timestamp:
        return "Timestamp";
    }
  }

  /// Get the label for dart.
  ///
  /// Dart向けのラベルを取得します。
  String get dartLabel {
    switch (this) {
      case SchemaType.undefined:
        return "null";
      case SchemaType.nullOrUndefined:
        return "null";
      case SchemaType.string:
        return "String";
      case SchemaType.bool:
        return "bool";
      case SchemaType.int:
        return "int";
      case SchemaType.float:
        return "double";
      case SchemaType.any:
        return "dynamic";
      case SchemaType.date:
        return "DateTime";
      case SchemaType.timestamp:
        return "DateTime";
    }
  }
}

/// The type of [ModelFieldValue] in the FirebaseDataConnect rules.
///
/// FirebaseDataConnectのルールの[ModelFieldValue]の型。
enum SchemaModelFieldValueType {
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

  /// Get the label.
  ///
  /// ラベルを取得します。
  String get label {
    switch (this) {
      case SchemaModelFieldValueType.modelCounter:
        return "ModelCounter";
      case SchemaModelFieldValueType.modelTimestamp:
        return "ModelTimestamp";
      case SchemaModelFieldValueType.modelDate:
        return "ModelDate";
      case SchemaModelFieldValueType.modelTime:
        return "ModelTime";
      case SchemaModelFieldValueType.modelTimestampRange:
        return "ModelTimestampRange";
      case SchemaModelFieldValueType.modelDateRange:
        return "ModelDateRange";
      case SchemaModelFieldValueType.modelTimeRange:
        return "ModelTimeRange";
      case SchemaModelFieldValueType.modelCommand:
        return "ModelCommand";
      case SchemaModelFieldValueType.modelGeoValue:
        return "ModelGeoValue";
      case SchemaModelFieldValueType.modelVectorValue:
        return "ModelVectorValue";
      case SchemaModelFieldValueType.modelUri:
        return "ModelUri";
      case SchemaModelFieldValueType.modelImageUri:
        return "ModelImageUri";
      case SchemaModelFieldValueType.modelVideoUri:
        return "ModelVideoUri";
      case SchemaModelFieldValueType.modelLocale:
        return "ModelLocale";
      case SchemaModelFieldValueType.modelLocalizedValue:
        return "ModelLocalizedValue";
      case SchemaModelFieldValueType.modelRef:
        return "ModelRef";
      case SchemaModelFieldValueType.modelSearch:
        return "ModelSearch";
      case SchemaModelFieldValueType.modelToken:
        return "ModelToken";
    }
  }
}
