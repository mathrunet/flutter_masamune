part of masamune_builder;

/// Collection model generator for classes annotated with [CollectionModelPath].
///
/// [CollectionModelPath]アノテーションを付与されたクラスに対するコレクションモデルのジェネレーター。
class CollectionModelGenerator
    extends GeneratorForAnnotation<CollectionModelPath> {
  /// Collection model generator for classes annotated with [CollectionModelPath].
  ///
  /// [CollectionModelPath]アノテーションを付与されたクラスに対するコレクションモデルのジェネレーター。
  CollectionModelGenerator();

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
        "`@CollectionModelPath()` can only be used on classes.",
        element: element,
      );
    }

    if (!_freezedChecker.hasAnnotationOfExact(element)) {
      throw InvalidGenerationSourceError(
        "The `@freezed` annotation is required to use `@CollectionModelPath()` or `@DocumentModelPath()`.",
        element: element,
      );
    }

    if (_documentModelPathChecker.hasAnnotationOfExact(element)) {
      throw InvalidGenerationSourceError(
        "You cannot use `@CollectionModelPath()` and `@DocumentModelPath()` at the same time.",
        element: element,
      );
    }

    final _class = ClassValue(element);
    final _path =
        PathValue(annotation.read("path").stringValue.trimString("/"));
    final path = _path.path;

    if (path.splitLength() <= 0 || path.splitLength() % 2 != 1) {
      throw InvalidGenerationSourceError(
        "The query path hierarchy must be an odd number: $path",
        element: element,
      );
    }

    final generated = Library(
      (l) => l
        ..body.addAll(
          [
            ...collectionModelClass(_class, _path),
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
