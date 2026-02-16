part of "/masamune_builder.dart";

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
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is ClassElement) {
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

      final classValue = ClassValue(element);
      final annotationValue =
          ModelAnnotationValue(element, CollectionModelPath);
      final pathValue =
          PathValue(annotation.read("path").stringValue.trimString("/"));
      final mirrorPathValue = annotation.read("mirror").isNull
          ? null
          : PathValue(annotation.read("mirror").stringValue.trimString("/"));
      final path = pathValue.path;
      final mirrorPath = mirrorPathValue?.path;
      final googleSpreadSheetValue =
          GoogleSpreadSheetValue(element, CollectionModelPath);

      if (path.splitLength() <= 0 || path.splitLength() % 2 != 1) {
        throw InvalidGenerationSourceError(
          "The query path hierarchy must be an odd number: $path",
          element: element,
        );
      }

      if (mirrorPath.isNotEmpty &&
          (mirrorPath!.splitLength() <= 0 ||
              mirrorPath.splitLength() % 2 != 1)) {
        throw InvalidGenerationSourceError(
          "The query mirror path hierarchy must be an odd number: $mirrorPath",
          element: element,
        );
      }

      if (path.contains("//")) {
        throw InvalidGenerationSourceError(
          "The query path hierarchy must not contain double slashes: $path",
          element: element,
        );
      }

      if (mirrorPath.isNotEmpty && mirrorPath!.contains("//")) {
        throw InvalidGenerationSourceError(
          "The query mirror path hierarchy must not contain double slashes: $mirrorPath",
          element: element,
        );
      }

      await googleSpreadSheetValue.load();

      final generated = Library(
        (l) => l
          ..body.addAll(
            [
              ...modelClass(classValue, annotationValue, pathValue,
                  mirrorPathValue, googleSpreadSheetValue),
              ...documentModelClass(classValue, annotationValue, pathValue,
                  mirrorPathValue, googleSpreadSheetValue),
              ...collectionModelClass(classValue, annotationValue, pathValue,
                  mirrorPathValue, googleSpreadSheetValue),
              ...collectionModelQueryClass(classValue, annotationValue,
                  pathValue, mirrorPathValue, googleSpreadSheetValue),
            ],
          ),
      );
      final emitter = DartEmitter();
      final code = generated.accept(emitter).toString();
      return DartFormatter(
        languageVersion: DartFormatter.latestLanguageVersion,
      ).format(
        code.isEmpty ? "// no code." : code,
      );
    } else if (element is TypeDefiningElement2) {
      if (_documentModelPathChecker.hasAnnotationOfExact(element)) {
        throw InvalidGenerationSourceError(
          "You cannot use `@CollectionModelPath()` and `@DocumentModelPath()` at the same time.",
          element: element,
        );
      }
      throw InvalidGenerationSourceError(
        "`@CollectionModelPath()` can only be used on classes or typedefs.",
        element: element,
      );
    } else {
      throw InvalidGenerationSourceError(
        "`@CollectionModelPath()` can only be used on classes or typedefs.",
        element: element,
      );
    }
  }
}
