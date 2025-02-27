part of '/masamune_model_firestore_builder.dart';

/// Builder to generate rules and indexes for Firestore.
///
/// Firestore用のルールやインデックスをジェネレートするためのビルダー。
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

  Future<void> _buildIndexes(
    List<IndexValue> indexes,
    BuildStep buildStep,
  ) async {
    const fileName = "firestore.indexes.json";
    final outputDir = Directory(
      "${_path(buildStep.inputId)}$_firebaseDir",
    );
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }
    final outputFile = File("${outputDir.path}/$fileName");
    await outputFile.writeAsString(jsonEncode({"indexes": indexes.toJson()}));
  }

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
    for (final rule in rules) {
      buffer = rule.apply(buffer);
    }
    buffer.writeln("    match /{document=**} {");
    buffer.writeln("      allow read, write: if false;");
    buffer.writeln("    }");
    buffer = createFunction(
      buffer,
      functionName: "isSpecifiedUser",
      parameters: "userId",
      body: "return isAuthUser() && request.auth.uid == userId;",
    );
    buffer = createFunction(
      buffer,
      functionName: "getReferenceUid",
      parameters: "data, field",
      body:
          "return isReference(data, field) && exists(data[field]) ? get(data[field])[\"@uid\"] : null",
    );
    buffer = createFunction(
      buffer,
      functionName: "getValue(data, field)",
      parameters: "",
      body: "return isNullOrUndefined(data, field) ? null : data[field];",
    );
    buffer = createFunction(
      buffer,
      functionName: "isDocument",
      parameters: "data",
      body: "return isString(data, \"@uid\");",
    );
    buffer = createFunction(
      buffer,
      functionName: "isSearchable",
      parameters: "data",
      body: "return isMap(data, \"@search\");",
    );
    buffer = createFunction(
      buffer,
      functionName: "isEnum",
      parameters: "data, field",
      body: "return isString(data, field);",
    );
    buffer = createFunction(
      buffer,
      functionName: "isNullableEnum",
      parameters: "data, field",
      body: "return isNullableString(data, field);",
    );
    for (final type in RuleModelFieldValueType.values) {
      buffer = type.apply(buffer);
    }
    for (final type in RuleType.values) {
      buffer = type.apply(buffer);
    }
    buffer = createFunction(
      buffer,
      functionName: "isAuthUser",
      parameters: "",
      body: "return request.auth != null;",
    );
    buffer = createFunction(
      buffer,
      functionName: "getResource",
      parameters: "",
      body:
          "return request.resource != null ? request.resource.data : resource.data;",
    );
    buffer.writeln("  }");
    buffer.writeln("}");
    await outputFile.writeAsString(buffer.toString());
  }

  @override
  Future<void> build(BuildStep buildStep) async {
    final rules = <RuleValue>[];
    final assets = buildStep.findAssets(Glob("**.dart"));
    await for (final asset in assets) {
      if (!await buildStep.resolver.isLibrary(asset)) {
        continue;
      }
      final libraryReader = LibraryReader(
        await buildStep.resolver.libraryFor(
          asset,
          allowSyntaxErrors: false,
        ),
      );

      for (final annotatedElement
          in libraryReader.annotatedWith(_documentModelPathChecker)) {
        final element = annotatedElement.element;
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
            mirrorPathValue: annotatedElement.annotation.read("mirror").isNull
                ? null
                : PathValue(
                    annotatedElement.annotation
                        .read("mirror")
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
            mirrorPathValue: annotatedElement.annotation.read("mirror").isNull
                ? null
                : PathValue(
                    annotatedElement.annotation
                        .read("mirror")
                        .stringValue
                        .trimString("/"),
                  ),
            annotationValue: ModelAnnotationValue(element, CollectionModelPath),
          ),
        );
      }
    }
    if (rules.isEmpty) {
      return;
    }
    rules.sort((a, b) => a.pathValue.path.compareTo(b.pathValue.path));
    await _buildRules(rules, buildStep);
    final indexes = rules.toIndexValueList();
    if (indexes.isNotEmpty) {
      await _buildIndexes(indexes, buildStep);
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
    ".dart": [".rules"]
  };
}
