part of '/masamune_model_firestore_builder.dart';

/// Builder to generate rules for Firestore.
///
/// Firestore用のルールをジェネレートするためのビルダー。
Builder masamuneModelFirestoreBuilderFactory(BuilderOptions options) {
  return _MasamuneModelFirestoreBuilder();
}

class _MasamuneModelFirestoreBuilder extends Builder {
  _MasamuneModelFirestoreBuilder();

  static const _firebaseDir = "firebase";

  static const _collectionModelPathChecker =
      TypeChecker.fromRuntime(CollectionModelPath);
  static const _documentModelPathChecker =
      TypeChecker.fromRuntime(DocumentModelPath);

  Future<void> _buildRules(
    List<RuleValue> rules,
    BuildStep buildStep,
  ) async {
    const fileName = "firestore.rules";
    final outputDir = Directory(
      "${_path(buildStep.inputId)}$_firebaseDir",
    );
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
    final outputFile = File("${outputDir.path}/$fileName");
    var buffer = StringBuffer();
    buffer.writeln("rules_version = '2';");
    buffer.writeln("service cloud.firestore {");
    buffer.writeln("  match /databases/{database}/documents {");
    buffer.writeln("    function getResource() {");
    buffer.writeln(
      "      return request.resource != null ? request.resource.data : resource.data;",
    );
    buffer.writeln("    }");
    buffer.writeln("    function isAuthUser() {");
    buffer.writeln("      return request.auth != null;");
    buffer.writeln("    }");
    buffer.writeln("    function isSpecifiedUser(userId) {");
    buffer.writeln("      return isAuthUser() && request.auth.uid == userId;");
    buffer.writeln("    }");
    for (final type in RuleType.values) {
      buffer = type.apply(buffer);
    }
    for (final type in RuleModelFieldValueType.values) {
      buffer = type.apply(buffer);
    }
    buffer.writeln("    function isDocument(data) {");
    buffer.writeln("      return isString(data, \"@uid\");");
    buffer.writeln("    }");
    buffer.writeln("    function isSearchable(data) {");
    buffer.writeln("      return isMap(data, \"@search\");");
    buffer.writeln("    }");
    buffer.writeln("    function isEnum(data, field) {");
    buffer.writeln("      return isString(data, field);");
    buffer.writeln("    }");
    buffer.writeln("    function isNullableEnum(data, field) {");
    buffer.writeln("      return isNullableString(data, field);");
    buffer.writeln("    }");
    for (final rule in rules) {
      buffer = rule.apply(buffer);
    }
    buffer.writeln("    match /{document=**} {");
    buffer.writeln("      allow read, write: if false;");
    buffer.writeln("    }");
    buffer.writeln("  }");
    buffer.writeln("}");
    await outputFile.writeAsString(buffer.toString());
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final resolver = buildStep.resolver;

    if (!await resolver.isLibrary(buildStep.inputId)) {
      return;
    }

    final rules = <RuleValue>[];
    final library = await buildStep.resolver.libraryFor(buildStep.inputId);
    final libraryReader = LibraryReader(library);
    for (final annotatedElement
        in libraryReader.annotatedWith(_documentModelPathChecker)) {
      final element = annotatedElement.element;
      if (!element.library!.isNonNullableByDefault) {
        throw InvalidGenerationSourceError(
          "Generator cannot target libraries that have not been migrated to "
          "null-safety.",
          element: element,
        );
      }
      if (element is! ClassElement) {
        throw InvalidGenerationSourceError(
          "`@DocumentModelPath()` can only be used on classes.",
          element: element,
        );
      }
      rules.add(
        RuleValue(
          classValue: ClassValue(element),
          pathValue: PathValue(
            annotatedElement.annotation
                .read("path")
                .stringValue
                .trimString("/"),
          ),
          annotationValue: ModelAnnotationValue(element, DocumentModelPath),
        ),
      );
    }
    for (final annotatedElement
        in libraryReader.annotatedWith(_collectionModelPathChecker)) {
      final element = annotatedElement.element;
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
      rules.add(
        RuleValue(
          classValue: ClassValue(element),
          pathValue: PathValue(
            annotatedElement.annotation
                .read("path")
                .stringValue
                .trimString("/"),
          ),
          annotationValue: ModelAnnotationValue(element, CollectionModelPath),
        ),
      );
    }
    if (rules.isEmpty) {
      return;
    }
    await _buildRules(rules, buildStep);
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
    ".dart": [".rules"]
  };
}
