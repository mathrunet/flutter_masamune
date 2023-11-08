part of '/katana_router_builder.dart';

/// Automatic generation of nested pages.
///
/// ネストされたページの自動生成を行います。
class NestedPageGenerator extends GeneratorForAnnotation<NestedPage> {
  /// Automatic generation of nested pages.
  ///
  /// ネストされたページの自動生成を行います。
  NestedPageGenerator();

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
        "`@NestedPage()` can only be used on classes.",
        element: element,
      );
    }

    final annotationValue = AnnotationValue(element, NestedPage);
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
    return DartFormatter().format(
      code.isEmpty ? "// no code." : code,
    );
  }
}
