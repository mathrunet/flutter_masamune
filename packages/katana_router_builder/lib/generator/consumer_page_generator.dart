part of katana_router_builder;

class ConsumerPageGenerator extends GeneratorForAnnotation<ConsumerPagePath> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (!element.library!.isNonNullableByDefault) {
      throw InvalidGenerationSourceError(
        "Generator cannot target libraries that have not been migrated to "
        "null-safety.",
        element: element,
      );
    }

    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        "`@ConsumerPagePath()` can only be used on classes.",
        element: element,
      );
    }

    final _path =
        PathModel("/${annotation.read("path").stringValue.trimString("/")}");
    final _class = ClassModel(element);

    for (final param in _path.parameters) {
      if (!_class.parameters.any((e) => e.name == param.camelCase)) {
        throw InvalidGenerationSourceError(
          "A path variable is defined in {${param.snakeCase}}, but `${param.camelCase}` is not defined as a page argument."
          "Add the following arguments"
          ""
          "```"
          "required String ${param.camelCase},"
          "```",
          element: element,
        );
      }
      if (!_class.parameters.any(
        (e) => e.name == param.camelCase && e.type.toString() == "String",
      )) {
        throw InvalidGenerationSourceError(
          "The corresponding `${param.camelCase}` for {${param.snakeCase}} is defined, but the type is not `String`."
          ""
          "```"
          "required String ${param.camelCase},"
          "```",
          element: element,
        );
      }
      if (!_class.parameters.any(
        (e) =>
            e.name == param.camelCase &&
            (e.element.isRequired || e.defaultValue != null),
      )) {
        throw InvalidGenerationSourceError(
          "The corresponding `${param.camelCase}` for {${param.snakeCase}} is defined, but it is not `required` or the default value is not set."
          "Add the following arguments"
          ""
          "```"
          "required String ${param.camelCase},"
          "```",
          element: element,
        );
      }
    }

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...queryClass(_class, _path),
            ...valueClass(_class, _path),
            ...consumerExtendsClass(_class, _path),
          ],
        ),
    );
    final emitter = DartEmitter();
    return DartFormatter().format(
      "${generated.accept(emitter)}",
    );
  }
}
