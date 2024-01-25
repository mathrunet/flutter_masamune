part of '/masamune_model_firestore_builder.dart';

/// Firestore rule value type.
///
/// Firestoreのルールの値の型。
enum RuleType {
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

  /// Get the label.
  ///
  /// ラベルを取得します。
  String get label {
    switch (this) {
      case RuleType.undefined:
        return "Undefined";
      case RuleType.nullOrUndefined:
        return "NullOrUndefined";
      case RuleType.string:
        return "String";
      case RuleType.bool:
        return "Bool";
      case RuleType.int:
        return "Int";
      case RuleType.double:
        return "Double";
      case RuleType.list:
        return "List";
      case RuleType.map:
        return "Map";
      case RuleType.timestamp:
        return "Timestamp";
      case RuleType.geo:
        return "GeoPoint";
      case RuleType.reference:
        return "Reference";
      case RuleType.enumType:
        return "Enum";
    }
  }

  /// Get the code.
  ///
  /// コードを取得します。
  String get code {
    switch (this) {
      case RuleType.undefined:
        return "!data.keys().hasAll([field])";
      case RuleType.nullOrUndefined:
        return "isUndefined(data, field) || data[field] == null";
      case RuleType.string:
      case RuleType.enumType:
        return "data[field] is string";
      case RuleType.bool:
        return "data[field] is bool";
      case RuleType.int:
        return "data[field] is int";
      case RuleType.double:
        return "data[field] is number";
      case RuleType.list:
        return "data[field] is list";
      case RuleType.map:
        return "data[field] is map";
      case RuleType.timestamp:
        return "data[field] is timestamp";
      case RuleType.geo:
        return "data[field] is latlng";
      case RuleType.reference:
        return "data[field] is path";
    }
  }

  /// Apply to [StringBuffer].
  ///
  /// [StringBuffer]に適用します。
  StringBuffer apply(StringBuffer buffer) {
    switch (this) {
      case RuleType.undefined:
      case RuleType.nullOrUndefined:
        buffer = createFunction(
          buffer,
          functionName: "is$label",
          parameters: "data, field",
          body: "return $code;",
        );
        break;
      default:
        buffer = createFunction(
          buffer,
          functionName: "is$label",
          parameters: "data, field",
          body:
              "return !is${RuleType.nullOrUndefined.label}(data, field) && $code;",
        );
        buffer = createFunction(
          buffer,
          functionName: "isNullable$label",
          parameters: "data, field",
          body:
              "return is${RuleType.nullOrUndefined.label}(data, field) || $code;",
        );
        break;
    }
    return buffer;
  }
}

/// The type of [ModelFieldValue] in the Firestore rules.
///
/// Firestoreのルールの[ModelFieldValue]の型。
enum RuleModelFieldValueType {
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

  /// [ModelCommand].
  ///
  /// [ModelCommand]。
  modelCommand,

  /// [ModelGeoValue].
  ///
  /// [ModelGeoValue]。
  modelGeoValue,

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
      case RuleModelFieldValueType.modelCounter:
        return "ModelCounter";
      case RuleModelFieldValueType.modelTimestamp:
        return "ModelTimestamp";
      case RuleModelFieldValueType.modelDate:
        return "ModelDate";
      case RuleModelFieldValueType.modelCommand:
        return "ModelCommand";
      case RuleModelFieldValueType.modelGeoValue:
        return "ModelGeoValue";
      case RuleModelFieldValueType.modelUri:
        return "ModelUri";
      case RuleModelFieldValueType.modelImageUri:
        return "ModelImageUri";
      case RuleModelFieldValueType.modelVideoUri:
        return "ModelVideoUri";
      case RuleModelFieldValueType.modelLocale:
        return "ModelLocale";
      case RuleModelFieldValueType.modelLocalizedValue:
        return "ModelLocalizedValue";
      case RuleModelFieldValueType.modelRef:
        return "ModelRef";
      case RuleModelFieldValueType.modelSearch:
        return "ModelSearch";
      case RuleModelFieldValueType.modelToken:
        return "ModelToken";
    }
  }

  /// Get the code.
  ///
  /// コードを取得します。
  String get code {
    switch (this) {
      case RuleModelFieldValueType.modelCounter:
        return "isDouble(data, field) && isMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelTimestamp:
        return "isTimestamp(data, field) && isMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelDate:
        return "isTimestamp(data, field) && isMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelCommand:
        return "isString(data, field) && isMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelGeoValue:
        return "isString(data, field) && isMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelUri:
        return "isString(data, field) && isMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelImageUri:
        return "isString(data, field) && isMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelVideoUri:
        return "isString(data, field) && isMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelLocale:
        return "isString(data, field) && isMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelLocalizedValue:
        return "isList(data, field) && isMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelRef:
        return "isNullableReference(data, field)";
      case RuleModelFieldValueType.modelSearch:
        return "isList(data, field) && isMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelToken:
        return "isList(data, field) && isMap(data, \"#\" + field)";
    }
  }

  /// Get [Null]-able codes.
  ///
  /// [Null]可能なコードを取得します。
  String get nullableCode {
    switch (this) {
      case RuleModelFieldValueType.modelCounter:
        return "isNullableDouble(data, field) && isNullableMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelTimestamp:
        return "isNullableTimestamp(data, field) && isNullableMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelDate:
        return "isNullableTimestamp(data, field) && isNullableMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelCommand:
        return "isNullableString(data, field) && isNullableMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelGeoValue:
        return "isNullableString(data, field) && isNullableMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelUri:
        return "isNullableString(data, field) && isNullableMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelImageUri:
        return "isNullableString(data, field) && isNullableMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelVideoUri:
        return "isNullableString(data, field) && isNullableMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelLocale:
        return "isNullableString(data, field) && isNullableMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelLocalizedValue:
        return "isNullableList(data, field) && isNullableMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelRef:
        return "isNullableReference(data, field)";
      case RuleModelFieldValueType.modelSearch:
        return "isNullableList(data, field) && isNullableMap(data, \"#\" + field)";
      case RuleModelFieldValueType.modelToken:
        return "isNullableList(data, field) && isNullableMap(data, \"#\" + field)";
    }
  }

  /// Apply to [StringBuffer].
  ///
  /// [StringBuffer]に適用します。
  StringBuffer apply(StringBuffer buffer) {
    buffer = createFunction(
      buffer,
      functionName: "is$label",
      parameters: "data, field",
      body: "return $code;",
    );
    buffer = createFunction(
      buffer,
      functionName: "isNullable$label",
      parameters: "data, field",
      body: "return $nullableCode;",
    );
    return buffer;
  }
}
