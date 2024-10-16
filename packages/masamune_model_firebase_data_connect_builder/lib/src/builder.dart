part of '/masamune_model_firebase_data_connect_builder.dart';

const _firebaseDataConnectChecker =
    TypeChecker.fromRuntime(FirebaseDataConnect);

/// Builder to generate schema for FirebaseDataConnect.
///
/// FirebaseDataConnect用のスキーマをジェネレートするためのビルダー。
Builder masamuneModelFirebaseDataConnectBuilderFactory(BuilderOptions options) {
  return _MasamuneModelFirebaseDataConnectBuilder();
}

/// Builder to generate ModelAdapter for FirebaseDataConnect.
///
/// FirebaseDataConnect用のModelAdapterをジェネレートするためのビルダー。
Builder masamuneModelFirebaseDataConnectAdapterBuilderFactory(
    BuilderOptions options) {
  return source_gen.PartBuilder(
    [
      AdapterGenerator(),
    ],
    ".dataconnect.dart",
    header:
        "// GENERATED CODE - DO NOT MODIFY BY HAND\r\n\r\n// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, depend_on_referenced_packages",
  );
}

class _MasamuneModelFirebaseDataConnectBuilder extends Builder {
  _MasamuneModelFirebaseDataConnectBuilder();

  static final List<SchemaValue> schemas = [];

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

  Future<void> _builConnectorYaml(
    List<SchemaValue> schemas,
    BuildStep buildStep,
  ) async {
    for (final schema in schemas) {
      final pathLength = schema
          .firebaseDataConnectAnnotationValue.connectorDirPath
          .trimQuery()
          .trimString("/")
          .split("/")
          .length;
      final relativePath = List.generate(pathLength, (index) => "..").join("/");
      final outputDir = Directory(
        "${_path(buildStep.inputId)}${schema.firebaseDataConnectAnnotationValue.connectorDirPath}",
      );
      if (!outputDir.existsSync()) {
        outputDir.createSync(recursive: true);
      }
      final outputFile = File(
        "${outputDir.path}/connector.yaml",
      );
      outputFile.writeAsStringSync("""
connectorId: "${schema.firebaseDataConnectAnnotationValue.dartPackage}"
generate:
  dartSdk:
    outputDir: "$relativePath/${schema.firebaseDataConnectAnnotationValue.dartDirPath}"
    package: "${schema.firebaseDataConnectAnnotationValue.dartPackage}"
""");
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
    await _builConnectorYaml(schemas, buildStep);
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
