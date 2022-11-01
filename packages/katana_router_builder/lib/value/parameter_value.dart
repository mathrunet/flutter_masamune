part of katana_router_builder;

const _pageParamChecker = TypeChecker.fromRuntime(PageParam);
const _queryParamChecker = TypeChecker.fromRuntime(QueryParam);

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
    if (_ignoreWords.contains(name)) {
      throw Exception(
        "`$name` is a prohibited word. This word cannot be set as a parameter. Please specify another name.",
      );
    }
    type = element.type;

    if (_pageParamChecker.hasAnnotationOfExact(element)) {
      pageParamName = _pageParamChecker
              .firstAnnotationOfExact(element)
              ?.getField("name")
              ?.toValue()
              ?.toString() ??
          name;
    } else {
      pageParamName = name;
    }
    if (_queryParamChecker.hasAnnotationOfExact(element)) {
      queryParamName = _queryParamChecker
              .firstAnnotationOfExact(element)
              ?.getField("name")
              ?.toValue()
              ?.toString() ??
          name;
    } else {
      queryParamName = name;
    }

    if (element.type.isNullable || element.isRequired) {
      defaultValue = null;
    } else {
      if (element.hasDefaultValue) {
        defaultValue = element.defaultValueCode;
      } else {
        defaultValue = null;
      }
    }
  }

  /// Parameter Element.
  ///
  /// パラメーターエレメント。
  final ParameterElement element;

  /// Default value of the parameter.
  ///
  /// パラメーターのデフォルト値。
  late final Object? defaultValue;

  /// Parameter Type.
  ///
  /// パラメーターのタイプ。
  late final DartType type;

  /// Name of parameter.
  ///
  /// パラメーターの名前。
  late final String name;

  /// Name for the parameter path.
  ///
  /// パラメーターのパス用の名前。
  late final String pageParamName;

  /// Name for query parameters.
  ///
  /// クエリーパラメーター用の名前。
  late final String queryParamName;

  @override
  String toString() {
    return "$name($type) => $defaultValue (PageParamName:$pageParamName, QueryParamName: $queryParamName)";
  }
}
