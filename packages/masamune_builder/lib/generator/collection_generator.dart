part of masamune_builder;

class CollectionGenerator extends GeneratorForAnnotation<CollectionPath> {
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

    final _path = annotation.read("path").stringValue.trimString("/");
    final _linkedPath = annotation.read("linkedPath").isNull
        ? null
        : annotation.read("linkedPath").stringValue.trimString("/");
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

    if (_linkedPath != null &&
        (_linkedPath.splitLength() <= 0 ||
            _linkedPath.splitLength() % 2 != 1)) {
      throw Exception(
        "The linked path hierarchy must be an odd number: $_linkedPath",
      );
    }

    if (_keySuffix.isEmpty || !RegExp(r"^[a-zA-Z]+$").hasMatch(_keySuffix)) {
      throw Exception(
        "The key suffix is available only for alphabetical characters.: $_keySuffix",
      );
    }

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            pathField(_class, _path),
            linkedPathField(_class, _linkedPath),
            converterField(_class, _converter ?? "DefaultConverter"),
            convertMethod(_class, _keySuffix),
            ...documentClass(_class, _keySuffix),
            ...collectionClass(_class),
            dynamicMapExtensions(_class),
            dynamicMapCollectionExtensions(_class),
            widgetRefCollectionExtensions(_class, _keySuffix),
            widgetRefParameterDocumentExtensions(_class),
            keyEnum(_class, _keySuffix),
            keyEnumExtensions(_class, _keySuffix),
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
