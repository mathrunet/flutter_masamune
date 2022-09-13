part of masamune_builder;

Builder masamuneBuilderFactory(BuilderOptions options) {
  return PartBuilder([MasamuneCollectionGenerator()], ".m.dart");
}

class MasamuneCollectionGenerator
    extends GeneratorForAnnotation<CollectionPath> {
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
        "`@CollectionPath()` can only be used on classes.",
        element: element,
      );
    }

    final _path = annotation.read("path").stringValue;
    final _keySuffix = annotation.read("keySuffix").stringValue;
    final _converter = annotation
        .peek("converter")
        ?.revive()
        .source
        .toString()
        .split("#")
        .lastOrNull;
    final _class = ClassModel(element);

    if (_path.splitLength() <= 0 || _path.splitLength() % 2 != 1) {
      throw Exception(
        "The path hierarchy must be an odd number: $_path",
      );
    }

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            pathField(_path),
            converterField(_converter ?? "DefaultConverter"),
            convertMethod(_class, _keySuffix),
            keyConstClass(_class, _keySuffix),
            ...documentClass(_class, _keySuffix),
            ...collectionClass(_class),
            dynamicMapExtensions(_class),
            dynamicMapCollectionExtensions(_class),
            widgetRefDocumentExtensions(_class),
            widgetRefCollectionExtensions(_class)
          ],
        ),
    );
    final emitter = DartEmitter();
    return DartFormatter().format(
      // "// ignore_for_file: require_trailing_commas"
      "${generated.accept(emitter)}",
    );
  }
}
