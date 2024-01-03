part of '/masamune_model_planetscale_builder.dart';

const _planetScaleUniqueFieldChecker =
    TypeChecker.fromRuntime(PlanetScaleUniqueField);
const _planetScaleAutoIncrementFieldChecker =
    TypeChecker.fromRuntime(PlanetScaleAutoIncrementField);
const _planetScalePrimaryFieldChecker =
    TypeChecker.fromRuntime(PlanetScalePrimaryField);
const _jsonKeyChecker = TypeChecker.fromRuntime(JsonKey);
const _refParamChecker = TypeChecker.fromRuntime(RefParam);

/// Parameter Value.
///
/// Specify the parameter element in [element].
///
/// パラメーターの値。
///
/// [element]にパラメーターエレメントを指定します。
class ParamaterValue {
  /// Parameter Value.
  ///
  /// Specify the parameter element in [element].
  ///
  /// パラメーターの値。
  ///
  /// [element]にパラメーターエレメントを指定します。
  ParamaterValue(this.element) {
    name = element.displayName;
    type = element.type;
    required = element.isRequired;
    isUnique = _planetScaleUniqueFieldChecker.hasAnnotationOfExact(element);
    isAutoIncrement =
        _planetScaleAutoIncrementFieldChecker.hasAnnotationOfExact(element);
    isPrimary = _planetScalePrimaryFieldChecker.hasAnnotationOfExact(element);
    jsonKey = _jsonKeyChecker
            .firstAnnotationOfExact(element)
            ?.getField("name")
            ?.toStringValue() ??
        name;
    if (_refParamChecker.hasAnnotationOfExact(element)) {
      String? res;
      for (final item in element.metadata) {
        final match = _refParamRegExp.firstMatch(item.toSource());
        if (match != null) {
          res = match.group(1);
          break;
        }
      }
      reference = res?.trim();
    } else {
      reference = null;
    }
  }

  /// Typescript用のタイプに変換します。
  String toTypescriptType() {
    final res = <String>[];
    final typeString = type.aliasName;
    if (reference != null) {
      res.add("Prisma.JsonValue");
      res.add("undefined");
    } else if (type.isDartCoreMap) {
      res.add("Prisma.JsonValue");
    } else if (type.isDartCoreList ||
        type.isDartCoreIterable ||
        type.isDartCoreSet) {
      res.add("Prisma.JsonArray");
    } else if (type.isDartCoreString) {
      res.add("string");
    } else if (type.isDartCoreInt) {
      res.add("number");
    } else if (type.isDartCoreDouble) {
      res.add("number");
    } else if (type.isDartCoreNum) {
      res.add("number");
    } else if (type.isDartCoreBool) {
      res.add("boolean");
    } else if (type.isDartCoreNull) {
      res.add("undefined");
    } else if (typeString.startsWith("ModelTimestamp")) {
      res.add("Date");
    } else if (typeString.startsWith("ModelCounter")) {
      res.add("number");
    } else if (typeString.startsWith("ModelUri")) {
      res.add("string");
    } else if (typeString.startsWith("ModelImageUri")) {
      res.add("string");
    } else if (typeString.startsWith("ModelVideoUri")) {
      res.add("string");
    } else if (typeString.startsWith("ModelLocale")) {
      res.add("string");
    } else if (typeString.startsWith("ModelGeoValue")) {
      res.add("Prisma.JsonValue");
    } else if (typeString.startsWith("ModelLocalizedValue")) {
      res.add("Prisma.JsonValue");
    } else if (typeString.startsWith("ModelSearch")) {
      res.add("Prisma.JsonValue");
    } else if (typeString.startsWith("ModelToken")) {
      res.add("Prisma.JsonValue");
    }
    if (typeString.endsWith("?")) {
      res.add("undefined");
    }
    return res.distinct().join(" | ");
  }

  static final _refParamRegExp = RegExp(r"^@RefParam\((.+)\)$");

  /// Parameter Element.
  ///
  /// パラメーターエレメント。
  final ParameterElement element;

  /// Parameter Type.
  ///
  /// パラメーターのタイプ。
  late final DartType type;

  /// Name of parameter.
  ///
  /// パラメーターの名前。
  late final String name;

  /// True if Required.
  ///
  /// Requiredな場合true.
  late final bool required;

  /// true` for unique fields.
  ///
  /// ユニークなフィールドの場合`true`。
  late final bool isUnique;

  /// `true` if the field is auto-incremental.
  ///
  /// オートインクリメントなフィールドな場合`true`。
  late final bool isAutoIncrement;

  /// If PrimaryField is `true`.
  ///
  /// PrimaryFieldな場合`true`。
  late final bool isPrimary;

  /// Name of the key.
  ///
  /// キーの名前。
  late final String? jsonKey;

  /// If another document is referenced, the class name of that document is entered. If it does not reference any other document, [Null] is entered.
  ///
  /// 他のドキュメントを参照している場合、そのドキュメントのクラス名が入ります。参照していない場合は[Null]が入ります。
  late final String? reference;

  @override
  String toString() {
    return "$name($type)";
  }
}
