part of '/masamune_ai.dart';

/// The value type of a [AISchema].
///
/// [AISchema]の値の型。
enum AISchemaType {
  /// string type.
  ///
  /// 文字列型。
  string,

  /// double type
  ///
  /// 浮動小数点型。
  double,

  /// integer type
  ///
  /// 整数型。
  int,

  /// boolean type
  ///
  /// 真偽値型。
  boolean,

  /// list type
  ///
  /// リスト型。
  list,

  /// map type
  ///
  /// マップ型。
  map;

  /// The name of the schema type.
  ///
  /// スキーマの型名。
  String get label {
    switch (this) {
      case string:
        return "string";
      case double:
        return "number";
      case int:
        return "integer";
      case boolean:
        return "boolean";
      case list:
        return "array";
      case map:
        return "object";
    }
  }
}
