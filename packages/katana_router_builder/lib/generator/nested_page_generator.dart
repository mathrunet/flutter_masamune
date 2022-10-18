part of katana_router_builder;

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

    final _annotation = AnnotationValue(element, NestedPage);
    final _class = ClassValue(element);

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...queryClass(_class, null, _annotation),
          ],
        ),
    );
    final emitter = DartEmitter();
    return DartFormatter().format(
      "${generated.accept(emitter)}",
    );
  }
}
