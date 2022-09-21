part of masamune_builder;

class DocumentGenerator extends GeneratorForAnnotation<DocumentModel> {
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
        "`@DocumentModel()` can only be used on classes.",
        element: element,
      );
    }

    final _path = PathModel(
      annotation.read("path").stringValue.trimString("/"),
    );
    final _converter = annotation
        .peek("converter")
        ?.revive()
        .source
        .toString()
        .split("#")
        .lastOrNull;
    final _class = ClassModel(element);

    if (_path.path.splitLength() <= 0 || _path.path.splitLength() % 2 != 0) {
      throw Exception(
        "The path hierarchy must be an even number: $_path",
      );
    }

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            pathField(_class, _path),
            converterField(_class, _converter ?? "DefaultConverter"),
            convertMethod(_class),
            ...documentClass(_class),
            dynamicMapExtensions(_class),
            widgetRefDocumentExtensions(_class, _path),
            keyEnum(_class),
            keyEnumExtensions(_class),
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
