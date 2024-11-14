part of '/masamune_builder.dart';

/// Parsed values for queries.
///
/// クエリー用のパースされた値。
@immutable
class QueryValue {
  const QueryValue._({
    this.conditions = const [],
    required this.rawValue,
    required this.name,
  });

  static final _queryValueRegExp =
      RegExp(r"ModelDatabaseQueryGroup\s*\([^\[]*\[([^\]]*)\][^\)]*\)");
  static final _nameWithSingleQuoteRegExp =
      RegExp(r"name\s*:\s*('[^']+')\s*,?");
  static final _nameWithDoubleQuoteRegExp =
      RegExp(r'name\s*:\s*("[^"]+")\s*,?');

  /// Parsed values for queries.
  ///
  /// クエリー用のパースされた値。
  static List<QueryValue>? from(String? value) {
    if (value == null) {
      return null;
    }
    final matches = _queryValueRegExp.allMatches(value);
    if (matches.isEmpty) {
      return null;
    }
    return matches.mapAndRemoveEmpty((e) {
      final match = e.group(0);
      final children = e.group(1);
      if (match == null || children == null) {
        return null;
      }
      final nameMatch = _nameWithSingleQuoteRegExp.firstMatch(match) ??
          _nameWithDoubleQuoteRegExp.firstMatch(match);
      if (nameMatch == null) {
        return null;
      }
      return QueryValue._(
        rawValue: value,
        name: nameMatch.group(1)!.trim().trimString("'").trimString('"'),
        conditions: children.trim().split(",").mapAndRemoveEmpty((e) {
          return QueryConditionValue.from(e.trim());
        }),
      );
    });
  }

  /// Raw value passed.
  ///
  /// 渡された生の値。
  final String rawValue;

  /// Query Name.
  ///
  /// クエリの名前。
  final String name;

  /// A list of each condition value.
  ///
  /// 各条件値のリスト。
  final List<QueryConditionValue> conditions;

  @override
  String toString() {
    return "$runtimeType($name, [${conditions.map((e) => e.toString()).join(",")}])";
  }

  /// Outputs the code of the conditional expression.
  ///
  /// 条件式のコードを出力。
  String toCode(String className) {
    return "return $className(modelQuery.${conditions.mapAndRemoveEmpty((e) => e.toCode()).join(".")});";
  }
}

/// Each condition value of the query.
///
/// クエリーの各条件値。
@immutable
class QueryConditionValue {
  const QueryConditionValue._({
    required this.type,
    required this.rawValue,
    this.key,
    this.parameter,
  });

  static final _queryConditionValueRegExp =
      RegExp(r"([a-zA-Z0-9_-]+)\.([a-zA-Z0-9_-]+)\(([^\)]*)\)");

  /// Parsed values for queries.
  ///
  /// クエリー用のパースされた値。
  static QueryConditionValue from(String value) {
    final match = _queryConditionValueRegExp.firstMatch(value);
    if (match == null) {
      throw ArgumentError.value(value, "value");
    }
    return QueryConditionValue._(
      rawValue: value,
      type: match.group(2)!,
      key: match.group(3)?.trim().trimString("'").trimString('"'),
    );
  }

  /// Raw value passed.
  ///
  /// 渡された生の値。
  final String rawValue;

  /// Condition type.
  ///
  /// 条件のタイプ。
  final String type;

  /// Condition key.
  ///
  /// 条件のキー。
  final String? key;

  /// Parameters.
  ///
  /// パラメーター。
  final ParamaterValue? parameter;

  /// [ParamaterValue] can be added to [QueryConditionValue].
  ///
  /// [QueryConditionValue]に[ParamaterValue]を追加できます。
  QueryConditionValue copyWith({
    ParamaterValue? parameter,
  }) {
    return QueryConditionValue._(
      type: type,
      rawValue: rawValue,
      key: key,
      parameter: parameter ?? this.parameter,
    );
  }

  @override
  String toString() {
    return "$runtimeType($type, $key)";
  }

  /// Conversion to a parameter object.
  ///
  /// パラメーターオブジェクトへの変換。
  Parameter? toParameter() {
    switch (type) {
      case "limit":
        return Parameter(
          (p) => p
            ..name = "limitTo"
            ..required = true
            ..named = true
            ..type = const Reference("int"),
        );
      case "orderByDesc":
      case "orderByAsc":
      case "isNull":
      case "isNotNull":
        return null;
      case "arrayContainsAny":
      case "whereIn":
      case "whereNotIn":
        return Parameter(
          (p) => p
            ..name = "${key ?? ""}${type.toPascalCase()}"
            ..required = true
            ..named = true
            ..type =
                Reference("List<${parameter?.type.aliasName ?? "Object?"}>"),
        );
      case "like":
        return Parameter(
          (p) => p
            ..name = "${key ?? ""}${type.toPascalCase()}"
            ..required = true
            ..named = true
            ..type = const Reference("String?"),
        );
      case "geoHash":
        return Parameter(
          (p) => p
            ..name = "${key ?? ""}${type.toPascalCase()}"
            ..required = true
            ..named = true
            ..type = const Reference("List<String>?"),
        );
      default:
        return Parameter(
          (p) => p
            ..name = "${key ?? ""}${type.toPascalCase()}"
            ..required = true
            ..named = true
            ..type = Reference(parameter?.type.aliasName ?? "Object?"),
        );
    }
  }

  /// Outputs the code of the conditional expression.
  ///
  /// 条件式のコードを出力。
  String? toCode() {
    switch (type) {
      case "equalTo":
        return "equal(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "notEqualTo":
        return "notEqual(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "lessThan":
        return "lessThan(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "greaterThan":
        return "greaterThan(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "lessThanOrEqualTo":
        return "lessThanOrEqual(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "greaterThanOrEqualTo":
        return "greaterThanOrEqual(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "arrayContains":
        return "contains(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "arrayContainsAny":
        return "containsAny(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "whereIn":
        return "where(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "whereNotIn":
        return "notWhere(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "isNull":
        return "isNull(\"${key ?? ""}\")";
      case "isNotNull":
        return "isNotNull(\"${key ?? ""}\")";
      case "like":
        return "like(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "geoHash":
        return "geo(\"${key ?? ""}\", ${key ?? ""}${type.toPascalCase()})";
      case "orderByDesc":
        return "orderByDesc(\"${key ?? ""}\")";
      case "orderByAsc":
        return "orderByAsc(\"${key ?? ""}\")";
      case "limit":
        return "limitTo(limitTo)";
    }
    return null;
  }
}
