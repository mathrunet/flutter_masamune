part of masamune_builder;

class PageGenerator extends GeneratorForAnnotation<PagePath> {
  static Set<String> allAnnotations = {};

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
        "`@PagePath()` can only be used on classes.",
        element: element,
      );
    }

    final _path =
        PathModel(annotation.read("path").stringValue.trimString("/"));
    final _class = ClassModel(element);
    allAnnotations.add(_path.path);
    print("-----");
    print(allAnnotations.join("\n"));
    print("-----");

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            pathField(_class, _path.path),
            pageParameterClass(_class, _path),
            pageBuildContextExtensions(_class, _path),
            pageQueryClass(_class, _path),
            pageRouteConfig(_class, _path),
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
