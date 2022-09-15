part of masamune_builder;

class DocumentGenerator extends GeneratorForAnnotation<DocumentPath> {
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
        "`@DocumentPath()` can only be used on classes.",
        element: element,
      );
    }

    final _path = annotation.read("path").stringValue.trimString("/");
    final _keySuffix = annotation.read("keySuffix").stringValue;
    final _converter = annotation
        .peek("converter")
        ?.revive()
        .source
        .toString()
        .split("#")
        .lastOrNull;
    final _class = ClassModel(element);

    if (_path.splitLength() <= 0 || _path.splitLength() % 2 != 0) {
      throw Exception(
        "The path hierarchy must be an even number: $_path",
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
            converterField(_class, _converter ?? "DefaultConverter"),
            convertMethod(_class, _keySuffix),
            keyConstClass(_class, _keySuffix),
            ...documentClass(_class, _keySuffix),
            dynamicMapExtensions(_class),
            widgetRefDocumentExtensions(_class),
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
