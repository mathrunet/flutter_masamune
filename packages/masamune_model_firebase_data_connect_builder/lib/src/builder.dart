part of '/masamune_model_firebase_data_connect_builder.dart';

/// Builder to generate schema for FirebaseDataConnect.
///
/// FirebaseDataConnect用のスキーマをジェネレートするためのビルダー。
Builder masamuneModelFirebaseDataConnectBuilderFactory(BuilderOptions options) {
  return _MasamuneModelFirebaseDataConnectBuilder();
}

class _MasamuneModelFirebaseDataConnectBuilder extends Builder {
  _MasamuneModelFirebaseDataConnectBuilder();

  static final List<SchemaValue> schemas = [];

  static const _firebaseDataConnectChecker =
      TypeChecker.fromRuntime(FirebaseDataConnect);

  Future<void> _buildSchemas(
    List<SchemaValue> schemas,
    BuildStep buildStep,
  ) async {
    for (final schema in schemas) {
      final outputDir = Directory(
        "${_path(buildStep.inputId)}${schema.firebaseDataConnectAnnotationValue.schemaDirPath}",
      );
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }
      final outputFile =
          File("${outputDir.path}/${schema.classValue.name.toSnakeCase()}.gql");
      outputFile.writeAsStringSync(schema.buildType());
    }
  }

  Future<void> _buildQueries(
    List<SchemaValue> schemas,
    BuildStep buildStep,
  ) async {
    for (final schema in schemas) {
      final outputDir = Directory(
        "${_path(buildStep.inputId)}${schema.firebaseDataConnectAnnotationValue.connectorDirPath}",
      );
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }
      final outputFile = File(
        "${outputDir.path}/${schema.classValue.name.toSnakeCase()}_queries.gql",
      );
      outputFile.writeAsStringSync(schema.buildQuery());
    }
  }

  Future<void> _buildMutations(
    List<SchemaValue> schemas,
    BuildStep buildStep,
  ) async {
    for (final schema in schemas) {
      final outputDir = Directory(
        "${_path(buildStep.inputId)}${schema.firebaseDataConnectAnnotationValue.connectorDirPath}",
      );
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }
      final outputFile = File(
        "${outputDir.path}/${schema.classValue.name.toSnakeCase()}_mutations.gql",
      );
      outputFile.writeAsStringSync(schema.buildMutation());
    }
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
        in libraryReader.annotatedWith(_firebaseDataConnectChecker)) {
      final element = annotatedElement.element;
      if (element is! ClassElement) {
        throw InvalidGenerationSourceError(
          "`@FirebaseDataConnect()` can only be used on classes.",
          element: element,
        );
      }
      final modelAnnotationValue =
          ModelAnnotationValue.hasMatch(element, DocumentModelPath)
              ? ModelAnnotationValue(element, DocumentModelPath)
              : (ModelAnnotationValue.hasMatch(element, CollectionModelPath)
                  ? ModelAnnotationValue(element, CollectionModelPath)
                  : null);
      if (modelAnnotationValue == null) {
        throw InvalidGenerationSourceError(
          "The `@FirebaseDataConnect()` must be given `@DocumentModelPath()` or `@CollectionModelPath()` at the same time.",
          element: element,
        );
      }
      schemas.add(
        SchemaValue(
          classValue: ClassValue(element),
          firebaseDataConnectAnnotationValue:
              FirebaseDataConnectAnnotationValue(element, FirebaseDataConnect),
          modelAnnotationValue: modelAnnotationValue,
        ),
      );
    }
    if (schemas.isEmpty) {
      return;
    }
    schemas.sort((a, b) => a.classValue.name.compareTo(b.classValue.name));
    await _buildSchemas(schemas, buildStep);
    await _buildQueries(schemas, buildStep);
    await _buildMutations(schemas, buildStep);
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
    ".dart": [".gql"]
  };
}
