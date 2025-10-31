part of "/katana_router_builder.dart";

/// Automatic generation of pages with hidden URLs.
///
/// URLが隠されたページの自動生成を行います。
class HiddenPageGenerator extends GeneratorForAnnotation<HiddenPage> {
  /// Automatic generation of pages with hidden URLs.
  ///
  /// URLが隠されたページの自動生成を行います。
  HiddenPageGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement2) {
      throw InvalidGenerationSourceError(
        "`@HiddenPage()` can only be used on classes.",
        element: element,
      );
    }

    final annotationValue = AnnotationValue(element, HiddenPage);
    final classValue = ClassValue(element);

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...queryClass(classValue, null, annotationValue),
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
