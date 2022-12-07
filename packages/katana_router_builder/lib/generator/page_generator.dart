part of katana_router_builder;

/// Automatic page generation.
///
/// ページの自動生成を行います。
class PageGenerator extends GeneratorForAnnotation<PagePath> {
  /// Automatic page generation.
  ///
  /// ページの自動生成を行います。
  PageGenerator();

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
        "`@PagePath()` can only be used on classes.",
        element: element,
      );
    }

    final _annotation = AnnotationValue(element, PagePath);
    final _path =
        PathValue("/${annotation.read("path").stringValue.trimString("/")}");
    final _class = ClassValue(element);

    for (final param in _path.parameters) {
      if (!_class.parameters.any((e) => e.name == param.camelCase)) {
        throw InvalidGenerationSourceError(
          "A path variable is defined in {${param.snakeCase}}, but `${param.camelCase}` is not defined as a page argument.\n"
          "Add the following arguments\n"
          "\n"
          "```\n"
          "required String ${param.camelCase},\n"
          "```\n",
          element: element,
        );
      }
      if (!_class.parameters.any(
        (e) => e.name == param.camelCase && e.type.toString() == "String",
      )) {
        throw InvalidGenerationSourceError(
          "The corresponding `${param.camelCase}` for {${param.snakeCase}} is defined, but the type is not `String`.\n"
          "\n"
          "```\n"
          "required String ${param.camelCase},\n"
          "```\n",
          element: element,
        );
      }
      if (!_class.parameters.any(
        (e) =>
            e.name == param.camelCase &&
            (e.element.isRequired || e.defaultValue != null),
      )) {
        throw InvalidGenerationSourceError(
          "The corresponding `${param.camelCase}` for {${param.snakeCase}} is defined, but it is not `required` or the default value is not set.\n"
          "Add the following arguments\n"
          "\n"
          "```\n"
          "required String ${param.camelCase},\n"
          "```\n",
          element: element,
        );
      }
    }

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...queryClass(_class, _path, _annotation),
          ],
        ),
    );
    final emitter = DartEmitter();
    final code = generated.accept(emitter).toString();
    return DartFormatter().format(
      code.isEmpty ? "// no code." : code,
    );
  }
}
