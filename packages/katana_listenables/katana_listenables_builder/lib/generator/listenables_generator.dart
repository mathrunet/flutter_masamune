part of katana_listenables_builder;

/// Generator to automatically create Listenable groups.
///
/// Listenableのグループを自動作成するジェネレーター。
class ListenablesGenerator extends GeneratorForAnnotation<Listenables> {
  /// Generator to automatically create Listenable groups.
  ///
  /// Listenableのグループを自動作成するジェネレーター。
  ListenablesGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (!element.library!.isNonNullableByDefault) {
      throw InvalidGenerationSourceError(
        "Generator cannot target libraries that have not been migrated to "
        "null-safety.",
        element: element,
      );
    }

    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        "`@Listenables()` can only be used on classes.",
        element: element,
      );
    }

    final _class = ClassValue(element);

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...baseClass(_class),
          ],
        ),
    );
    final emitter = DartEmitter();
    return DartFormatter().format(
      "${generated.accept(emitter)}",
    );
  }
}
