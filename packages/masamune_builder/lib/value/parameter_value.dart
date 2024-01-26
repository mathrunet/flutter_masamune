part of '/masamune_builder.dart';

const _searchParamChecker = TypeChecker.fromRuntime(SearchParam);
const _refParamChecker = TypeChecker.fromRuntime(RefParam);
const _jsonParamChecker = TypeChecker.fromRuntime(JsonParam);
const _jsonKeyChecker = TypeChecker.fromRuntime(JsonKey);

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
    type = element.type as InterfaceType;
    required = element.isRequired;
    isSearchable = _searchParamChecker.hasAnnotationOfExact(element);
    if (_refParamChecker.hasAnnotationOfExact(element)) {
      String? res;
      for (final item in element.metadata) {
        final match = _refParamRegExp.firstMatch(item.toSource());
        if (match != null) {
          res = match.group(1);
          break;
        }
      }
      final referenceDoc = res?.trim();
      final referenceValue = type.typeArguments.first.toString();
      if (referenceDoc.isNotEmpty && referenceValue.isNotEmpty) {
        reference = ReferenceValue(
          valueType: referenceValue,
          documentType: referenceDoc!,
        );
      } else {
        reference = null;
      }
    } else {
      reference = null;
    }

    isJsonSerializable = _jsonParamChecker.hasAnnotationOfExact(element);
    if (isJsonSerializable) {
      jsonKey = _jsonParamChecker
              .firstAnnotationOfExact(element)
              ?.getField("name")
              ?.toStringValue() ??
          _jsonKeyChecker
              .firstAnnotationOfExact(element)
              ?.getField("name")
              ?.toStringValue() ??
          name;
    } else {
      jsonKey = name;
    }
  }
  static final _refParamRegExp = RegExp(r"^@RefParam\((.+)\)$");

  /// Parameter Element.
  ///
  /// パラメーターエレメント。
  final ParameterElement element;

  /// Parameter Type.
  ///
  /// パラメーターのタイプ。
  late final InterfaceType type;

  /// Name of parameter.
  ///
  /// パラメーターの名前。
  late final String name;

  /// True if Required.
  ///
  /// Requiredな場合true.
  late final bool required;

  /// True if search target.
  ///
  /// 検索対象の場合true.
  late final bool isSearchable;

  /// If another document is referenced, the class name of that document is entered. If it does not reference any other document, [Null] is entered.
  ///
  /// 他のドキュメントを参照している場合、そのドキュメントのクラス名が入ります。参照していない場合は[Null]が入ります。
  late final ReferenceValue? reference;

  /// True if serializable to Json.
  ///
  /// Jsonにシリアライズ可能な場合true.
  late final bool isJsonSerializable;

  /// Name of the key if [isJsonSerializable] is true.
  ///
  /// [isJsonSerializable]がtrueな場合のキーの名前。
  late final String? jsonKey;

  @override
  String toString() {
    return "$name($type)";
  }
}

/// Definition class for `ModelRef`.
///
/// `ModelRef`用の定義クラス。
class ReferenceValue {
  /// Definition class for `ModelRef`.
  ///
  /// `ModelRef`用の定義クラス。
  const ReferenceValue({
    required this.valueType,
    required this.documentType,
  });

  /// Value Type.
  ///
  /// 値のタイプ。
  final String valueType;

  /// Document Type.
  ///
  /// ドキュメントのタイプ。
  final String documentType;
}
