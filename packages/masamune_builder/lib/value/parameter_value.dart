part of masamune_builder;

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
    type = element.type;
    required = element.isRequired;
    isSearchable = _searchParamChecker.hasAnnotationOfExact(element);
    isReference = _refParamChecker.hasAnnotationOfExact(element);
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

  /// True if search target.
  ///
  /// 検索対象の場合true.
  late final bool isSearchable;

  /// True if referring to another document.
  ///
  /// 他のドキュメントを参照している場合true.
  late final bool isReference;

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
