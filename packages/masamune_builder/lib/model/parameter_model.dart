part of masamune_builder;

const _coreChecker = TypeChecker.fromRuntime(Default);

class ParamaterModel {
  ParamaterModel(this.element) {
    name = element.displayName;
    type = element.type;
    if (element.type.isNullable || element.isRequired) {
      defaultValue = null;
    } else {
      if (_coreChecker.hasAnnotationOfExact(element)) {
        defaultValue = _coreChecker
            .firstAnnotationOfExact(element)
            ?.getField("defaultValue")
            ?.toValue();
        if (defaultValue.runtimeType.toString() != type.toString()) {
          throw Exception(
            "Different types of DefaultValue:${defaultValue.runtimeType.toString()}!=${type.toString()}",
          );
        }
      } else if (element.hasDefaultValue) {
        defaultValue = element.defaultValueCode;
      } else {
        throw Exception(
          "DefaultValue is not specified.",
        );
      }
    }
  }
  final ParameterElement element;
  late final Object? defaultValue;
  late final DartType type;
  late final String name;

  @override
  String toString() {
    return "$name($type) => $defaultValue";
  }
}
