part of "/masamune_ai.dart";

/// A schema for the data type of the AI.
///
/// AIのデータ型のスキーマ。
class AISchema {
  const AISchema._(
    this.type, {
    this.format,
    this.description,
    this.nullable,
    this.enumValues,
    this.items,
    this.properties,
    this.optionalProperties,
  });

  /// Construct a schema for an object with one or more properties.
  ///
  /// 一つ以上のプロパティを持つオブジェクトのスキーマ。
  const AISchema.map({
    required Map<String, AISchema> properties,
    List<String>? optionalProperties,
    String? description,
    bool? nullable,
  }) : this._(
          AISchemaType.map,
          properties: properties,
          optionalProperties: optionalProperties,
          description: description,
          nullable: nullable,
        );

  /// Construct a schema for an array of values with a specified type.
  ///
  /// 指定された型の値の配列のスキーマ。
  const AISchema.list({
    required AISchema items,
    String? description,
    bool? nullable,
  }) : this._(
          AISchemaType.list,
          description: description,
          nullable: nullable,
          items: items,
        );

  /// Construct a schema for bool value.
  ///
  /// 真偽値のスキーマ。
  const AISchema.boolean({
    String? description,
    bool? nullable,
  }) : this._(
          AISchemaType.boolean,
          description: description,
          nullable: nullable,
        );

  /// Construct a schema for an integer number.
  ///
  /// 整数のスキーマ。
  const AISchema.int({
    String? description,
    bool? nullable,
    String? format,
  }) : this._(
          AISchemaType.int,
          description: description,
          nullable: nullable,
          format: "int64",
        );

  /// Construct a schema for a non-integer number.
  ///
  /// 整数でない数のスキーマ。
  const AISchema.double({
    String? description,
    bool? nullable,
    String? format,
  }) : this._(
          AISchemaType.double,
          description: description,
          nullable: nullable,
          format: "double",
        );

  /// Construct a schema for String value with enumerated possible values.
  ///
  /// 列挙可能な値を持つ文字列のスキーマ。
  const AISchema.enumString({
    required List<String> enumValues,
    String? description,
    bool? nullable,
  }) : this._(
          AISchemaType.string,
          enumValues: enumValues,
          description: description,
          nullable: nullable,
          format: "enum",
        );

  /// Construct a schema for a String value.
  ///
  /// 文字列のスキーマ。
  const AISchema.string({
    String? description,
    bool? nullable,
    String? format,
  }) : this._(
          AISchemaType.string,
          description: description,
          nullable: nullable,
          format: format,
        );

  /// The type of this value.
  ///
  /// この値の型。
  final AISchemaType type;

  /// The format of the data.
  ///
  /// This is used only for primitive datatypes.
  ///
  /// Supported formats:
  ///  for [AISchemaType.double] type: float, double
  ///  for [AISchemaType.int] type: int32, int64
  ///  for [AISchemaType.string] type: enum. See [enumValues]
  ///
  /// データの形式。
  ///
  /// これはプリミティブなデータ型にのみ使用されます。
  ///
  /// サポートされる形式:
  ///  for [AISchemaType.double] type: float, double
  ///  for [AISchemaType.int] type: int32, int64
  ///  for [AISchemaType.string] type: enum. See [enumValues]
  final String? format;

  /// A brief description of the parameter.
  ///
  /// This could contain examples of use.
  /// Parameter description may be formatted as Markdown.
  ///
  /// パラメータの簡単な説明。
  ///
  /// これには使用例が含まれる場合があります。
  /// パラメータの説明はMarkdown形式で記述される場合があります。
  final String? description;

  /// Whether the value may be null.
  ///
  /// 値がnullである可能性があるかどうか。
  final bool? nullable;

  /// Possible values if this is a [AISchemaType.string] with an enum format.
  ///
  /// これが enum 形式の [AISchemaType.string] の場合に可能な値。
  final List<String>? enumValues;

  /// Schema for the elements if this is a [AISchemaType.list].
  ///
  /// これが[AISchemaType.list]の場合の要素のスキーマ。
  final AISchema? items;

  /// Properties of this type if this is a [AISchemaType.map].
  ///
  /// これが[AISchemaType.map]の場合のプロパティ。
  final Map<String, AISchema>? properties;

  /// Optional Properties if this is a [AISchemaType.map].
  ///
  /// The keys from [properties] for properties that are optional if this is a
  /// [AISchemaType.map]. Any properties that's not listed in optional will be
  /// treated as required properties
  ///
  /// これが[AISchemaType.map]の場合のオプションのプロパティ。
  ///
  /// これが [AISchemaType.map] の場合はオプションのプロパティの [properties] からのキー。
  /// オプションにリストされていないプロパティは必須プロパティとして扱われます。
  final List<String>? optionalProperties;

  /// Convert the schema to a JSON object.
  ///
  /// スキーマをJSONオブジェクトに変換します。
  DynamicMap toJson() {
    return {
      "type": type.label,
      if (description != null) "description": description,
      if (format != null) "format": format,
      if (nullable != null) "nullable": nullable,
      if (enumValues != null) "enum": enumValues,
      if (items != null) "items": items?.toJson(),
      if (properties != null)
        "properties":
            properties?.map((key, value) => MapEntry(key, value.toJson())),
      if (optionalProperties != null) "optionalProperties": optionalProperties,
    };
  }

  @override
  String toString() {
    return "AISchema(type: $type, format: $format, description: $description, nullable: $nullable, enumValues: $enumValues, items: $items, properties: $properties, optionalProperties: $optionalProperties)";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is! AISchema) {
      return false;
    }
    return type == other.type &&
        format == other.format &&
        description == other.description &&
        nullable == other.nullable &&
        enumValues == other.enumValues &&
        items == other.items &&
        properties == other.properties &&
        optionalProperties == other.optionalProperties;
  }

  @override
  int get hashCode {
    return Object.hash(type, format, description, nullable, enumValues, items,
        properties, optionalProperties);
  }
}
