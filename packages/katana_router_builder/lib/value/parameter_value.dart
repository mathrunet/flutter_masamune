part of "/katana_router_builder.dart";

const _pageParamChecker = TypeChecker.typeNamed(PageParam);
const _queryParamChecker = TypeChecker.typeNamed(QueryParam);

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
      isPageParameter = true;
    } else {
      pageParamName = name;
      isPageParameter = false;
    }
    if (_queryParamChecker.hasAnnotationOfExact(element)) {
      queryParamName = _queryParamChecker
              .firstAnnotationOfExact(element)
              ?.getField("name")
              ?.toValue()
              ?.toString() ??
          name;
      isQueryParameter = true;
    } else {
      queryParamName = name;
      isQueryParameter = false;
    }

    if (type.isNullable || element.isRequired) {
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
  final FormalParameterElement element;

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

  /// True if explicitly specified as a page parameter.
  ///
  /// 明示的にページパラメーターとして指定されている場合はtrue。
  late final bool isPageParameter;

  /// True if explicitly specified as a query parameter.
  ///
  /// 明示的にクエリーパラメーターとして指定されている場合はtrue。
  late final bool isQueryParameter;

  @override
  String toString() {
    return "$name($type) => $defaultValue (PageParamName:$pageParamName, QueryParamName: $queryParamName)";
  }
}
