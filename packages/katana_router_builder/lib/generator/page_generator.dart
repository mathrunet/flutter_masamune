part of "/katana_router_builder.dart";

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
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement2) {
      throw InvalidGenerationSourceError(
        "`@PagePath()` can only be used on classes.",
        element: element,
      );
    }

    final annotationValue = AnnotationValue(element, PagePath);
    final pathValue =
        PathValue("/${annotation.read("path").stringValue.trimString("/")}");
    final classValue = ClassValue(element);

    for (final param in pathValue.parameters) {
      if (!classValue.parameters.any((e) => e.name == param.camelCase)) {
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
      if (!classValue.parameters.any(
        (e) => e.name == param.camelCase && e.type.aliasName == "String",
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
      if (!classValue.parameters.any(
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
            ...queryClass(classValue, pathValue, annotationValue),
          ],
        ),
    );
    final emitter = DartEmitter();
    final code = generated.accept(emitter).toString();
    return DartFormatter(
      languageVersion: DartFormatter.latestLanguageVersion,
    ).format(
      code.isEmpty ? "// no code." : code,
    );
  }
}
