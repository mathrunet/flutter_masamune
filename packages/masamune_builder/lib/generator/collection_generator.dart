part of masamune_builder;

class CollectionGenerator extends GeneratorForAnnotation<CollectionModel> {
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
        "`@CollectionModel()` can only be used on classes.",
        element: element,
      );
    }

    final _path = PathModel(
      annotation.read("path").stringValue.trimString("/"),
    );
    final _linkedPath = annotation.read("linkedPath").isNull
        ? null
        : PathModel(
            annotation.read("linkedPath").stringValue.trimString("/"),
          );
    final _converter = annotation
        .peek("converter")
        ?.revive()
        .source
        .toString()
        .split("#")
        .lastOrNull;
    final _enableCollectionCount =
        annotation.read("enableCollectionCount").boolValue;
    final _class = ClassModel(element);

    if (_path.path.splitLength() <= 0 || _path.path.splitLength() % 2 != 1) {
      throw Exception(
        "The path hierarchy must be an odd number: $_path",
      );
    }

    if (_linkedPath != null &&
        (_linkedPath.path.splitLength() <= 0 ||
            _linkedPath.path.splitLength() % 2 != 1)) {
      throw Exception(
        "The linked path hierarchy must be an odd number: $_linkedPath",
      );
    }

    if (_enableCollectionCount && _path.path.splitLength() <= 1) {
      throw Exception(
        "If [enableCollectionCount] is `true`, you cannot specify a path that is less than one level. Please increase the hierarchy of paths: $_path",
      );
    }

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            pathField(_class, _path),
            linkedPathField(_class, _linkedPath),
            converterField(_class, _converter ?? "DefaultConverter"),
            convertMethod(_class),
            ...documentClass(_class),
            ...collectionClass(_class, _linkedPath),
            dynamicMapExtensions(_class),
            dynamicMapCollectionExtensions(_class),
            findRelationMethod(_class),
            widgetRefCollectionExtensions(_class, _path),
            widgetRefParameterDocumentExtensions(_class, _path),
            keyEnum(_class),
            keyEnumExtensions(_class),
            if (_enableCollectionCount) ...[
              counterDocumentClass(_class, _path),
              widgetRefCounterDocumentExtensions(_class, _path)
            ]
          ],
        ),
    );
    final emitter = DartEmitter();
    return DartFormatter().format(
      "${generated.accept(emitter)}",
    );
  }
}
