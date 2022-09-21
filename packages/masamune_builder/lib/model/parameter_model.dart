part of masamune_builder;

const _defaultChecker = TypeChecker.fromRuntime(Default);
const _relationChecker = TypeChecker.fromRuntime(Relation);

class ParamaterModel {
  ParamaterModel(this.element) {
    name = element.displayName;
    if (ignoreWords.contains(name)) {
      throw Exception(
        "`$name` is a prohibited word. This word cannot be set as a parameter. Please specify another name.",
      );
    }
    type = element.type;
    isRelation = _relationChecker.hasAnnotationOfExact(element);

    if (element.type.isNullable || element.isRequired) {
      defaultValue = null;
    } else {
      if (_defaultChecker.hasAnnotationOfExact(element)) {
        defaultValue = _defaultChecker
            .firstAnnotationOfExact(element)
            ?.getField("defaultValue")
            ?.toValue();
        if (defaultValue.runtimeType.toString() != type.toString()) {
          throw Exception(
            "Different types of DefaultValue:${defaultValue.runtimeType.toString()}!=${type.toString()} at $name($type)",
          );
        }
      } else if (element.hasDefaultValue) {
        defaultValue = element.defaultValueCode;
      } else if (!isRelation) {
        throw Exception(
          "DefaultValue is not specified at $name($type)",
        );
      } else {
        defaultValue = null;
      }
    }
  }
  final ParameterElement element;
  late final Object? defaultValue;
  late final DartType type;
  late final String name;
  late final bool isRelation;

  @override
  String toString() {
    return "$name($type) => $defaultValue (Relation:$isRelation)";
  }
}
