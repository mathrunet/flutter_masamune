part of '/masamune_model_docs_builder.dart';

/// Builder for generating Markdown courtesy documents from model definitions.
///
/// モデル定義からMarkdownの表敬式のドキュメントをジェネレートするためのビルダー。
Builder masamuneModelDocsBuilderFactory(BuilderOptions options) {
  return _MasamuneModelDocsBuilder();
}

class _MasamuneModelDocsBuilder extends Builder {
  _MasamuneModelDocsBuilder();

  static final docs = <String, List<DocsValue>>{};

  static const _collectionModelPathChecker =
      TypeChecker.fromRuntime(CollectionModelPath);
  static const _documentModelPathChecker =
      TypeChecker.fromRuntime(DocumentModelPath);

  Future<void> _buildDocs(
    String targetPath,
    List<DocsValue> docs,
    BuildStep buildStep,
  ) async {
    const fileName = "schema.md";
    final outputDir = Directory(
      "${_path(buildStep.inputId)}$targetPath",
    );
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
    final outputFile = File("${outputDir.path}/$fileName");
    docs.sort((a, b) => a.pathValue.path.compareTo(b.pathValue.path));
    var buffer = StringBuffer();
    buffer.writeln("<!-- GENERATED CODE - DO NOT MODIFY BY HAND -->");
    buffer.writeln("# Data Schema");
    buffer.writeln("");
    for (final rule in docs) {
      buffer = rule.apply(buffer);
    }
    await outputFile.writeAsString(buffer.toString());
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final resolver = buildStep.resolver;

    if (!await resolver.isLibrary(buildStep.inputId)) {
      return;
    }

    final library = await buildStep.resolver.libraryFor(buildStep.inputId);
    final libraryReader = LibraryReader(library);
    for (final annotatedElement
        in libraryReader.annotatedWith(_documentModelPathChecker)) {
      final element = annotatedElement.element;
      if (element is! ClassElement) {
        throw InvalidGenerationSourceError(
          "`@DocumentModelPath()` can only be used on classes.",
          element: element,
        );
      }
      final annotationValue = ModelAnnotationValue(element, DocumentModelPath);
      final docsPath = annotationValue.docsPath?.trimQuery().trimString("/");
      if (docsPath == null) {
        continue;
      }
      final mirror = annotatedElement.annotation.read("mirror").isNull
          ? null
          : PathValue(
              annotatedElement.annotation
                  .read("mirror")
                  .stringValue
                  .trimString("/"),
            );
      if (!docs.containsKey(docsPath)) {
        docs[docsPath] = [];
      }
      docs[docsPath]?.add(
        DocsValue(
          classValue: ClassValue(element),
          pathValue: PathValue(
            annotatedElement.annotation
                .read("path")
                .stringValue
                .trimString("/"),
          ),
          annotationValue: annotationValue,
        ),
      );
      if (mirror != null) {
        docs[docsPath]?.add(
          DocsValue(
            classValue: ClassValue(element),
            pathValue: mirror,
            annotationValue: annotationValue,
          ),
        );
      }
    }
    for (final annotatedElement
        in libraryReader.annotatedWith(_collectionModelPathChecker)) {
      final element = annotatedElement.element;
      if (element is! ClassElement) {
        throw InvalidGenerationSourceError(
          "`@CollectionModelPath()` can only be used on classes.",
          element: element,
        );
      }
      final annotationValue =
          ModelAnnotationValue(element, CollectionModelPath);
      final docsPath = annotationValue.docsPath;
      if (docsPath == null) {
        continue;
      }
      final mirror = annotatedElement.annotation.read("mirror").isNull
          ? null
          : PathValue(
              annotatedElement.annotation
                  .read("mirror")
                  .stringValue
                  .trimString("/"),
            );
      if (!docs.containsKey(docsPath)) {
        docs[docsPath] = [];
      }
      docs[docsPath]?.add(
        DocsValue(
          classValue: ClassValue(element),
          pathValue: PathValue(
            annotatedElement.annotation
                .read("path")
                .stringValue
                .trimString("/"),
          ),
          annotationValue: annotationValue,
        ),
      );
      if (mirror != null) {
        docs[docsPath]?.add(
          DocsValue(
            classValue: ClassValue(element),
            pathValue: mirror,
            annotationValue: annotationValue,
          ),
        );
      }
    }
    if (docs.isEmpty) {
      return;
    }
    for (final entry in docs.entries) {
      await _buildDocs(entry.key, entry.value, buildStep);
    }
  }

  String _path(AssetId from) {
    final regExp = RegExp("^(.*)lib");
    final match = regExp.firstMatch(from.path);
    if (match == null) {
      return "";
    }
    return match.group(1) ?? "";
  }

  @override
  final Map<String, List<String>> buildExtensions = {
    ".dart": [".md"]
  };
}
