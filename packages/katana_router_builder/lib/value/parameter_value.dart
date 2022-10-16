part of katana_router_builder;

const _pageParamChecker = TypeChecker.fromRuntime(PageParam);

class ParamaterValue {
  ParamaterValue(this.element) {
    name = element.displayName;
    if (ignoreWords.contains(name)) {
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
              .toString() ??
          name;
    } else {
      pageParamName = name;
    }

    if (element.type.isNullable || element.isRequired) {
      defaultValue = null;
    } else {
      // if (_defaultChecker.hasAnnotationOfExact(element)) {
      //   defaultValue = _defaultChecker
      //       .firstAnnotationOfExact(element)
      //       ?.getField("defaultValue")
      //       ?.toValue();
      //   if (defaultValue.runtimeType.toString() != type.toString()) {
      //     throw Exception(
      //       "Different types of DefaultValue:${defaultValue.runtimeType.toString()}!=${type.toString()} at $name($type)",
      //     );
      //   }
      // } else
      if (element.hasDefaultValue) {
        defaultValue = element.defaultValueCode;
      } else {
        defaultValue = null;
      }
    }
  }
  final ParameterElement element;
  late final Object? defaultValue;
  late final DartType type;
  late final String name;
  late final String pageParamName;

  @override
  String toString() {
    return "$name($type) => $defaultValue (PageParamName:$pageParamName)";
  }
}
