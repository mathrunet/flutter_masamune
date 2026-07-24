part of "/masamune_model_tidb_builder.dart";

const _tidbDataServiceChecker = TypeChecker.typeNamed(TidbDataService);
const _collectionModelPathChecker = TypeChecker.typeNamed(CollectionModelPath);
const _documentModelPathChecker = TypeChecker.typeNamed(DocumentModelPath);

class _BuilderEntry {
  const _BuilderEntry({
    required this.tables,
    required this.dataServiceDirPath,
    required this.rulesJsonPath,
  });

  final List<TidbTableSpec> tables;
  final String dataServiceDirPath;
  final String rulesJsonPath;
}

class _MasamuneModelTidbBuilder extends Builder {
  static final Map<String, _BuilderEntry> _entries = {};

  @override
  Future<void> build(BuildStep buildStep) async {
    if (!await buildStep.resolver.isLibrary(buildStep.inputId)) {
      return;
    }
    final library = await buildStep.resolver.libraryFor(buildStep.inputId);
    final tables = <TidbTableSpec>[];
    String? dataServiceDirPath;
    String? rulesJsonPath;
    for (final annotated
        in LibraryReader(library).annotatedWith(_tidbDataServiceChecker)) {
      final element = annotated.element;
      if (element is! ClassElement) {
        throw InvalidGenerationSourceError(
          "`@TidbDataService()` can only be used on classes.",
          element: element,
        );
      }
      final annotation = annotated.annotation;
      final database = annotation.read("database").stringValue.trim();
      final outputPath =
          annotation.read("dataServiceDirPath").stringValue.trim();
      final rulesPath = annotation.read("rulesJsonPath").stringValue.trim();
      final modelPath = _readModelPath(element);
      final table = _tableNameFromModelPath(
        modelPath,
        database,
        element,
      );
      dataServiceDirPath ??= outputPath;
      rulesJsonPath ??= rulesPath;
      if (dataServiceDirPath != outputPath || rulesJsonPath != rulesPath) {
        throw InvalidGenerationSourceError(
          "All @TidbDataService annotations must use the same output and rules paths.",
          element: element,
        );
      }
      tables.add(TidbTableSpec(
        database: database,
        table: table,
        columns: _columns(element),
      ));
    }
    final key = buildStep.inputId.toString();
    if (tables.isEmpty) {
      _entries.remove(key);
    } else {
      _entries[key] = _BuilderEntry(
        tables: tables,
        dataServiceDirPath: dataServiceDirPath!,
        rulesJsonPath: rulesJsonPath!,
      );
    }
    if (_entries.isEmpty) {
      return;
    }
    _generateAggregate();
  }

  void _generateAggregate() {
    final entries = _entries.values.toList();
    final outputPath = entries.first.dataServiceDirPath;
    final rulesPath = entries.first.rulesJsonPath;
    if (entries.any((entry) =>
        entry.dataServiceDirPath != outputPath ||
        entry.rulesJsonPath != rulesPath)) {
      throw StateError(
        "All @TidbDataService annotations in a package must share paths.",
      );
    }
    final tableMap = <String, TidbTableSpec>{};
    for (final entry in entries) {
      for (final table in entry.tables) {
        tableMap["${table.database}\u0000${table.table}"] = table;
      }
    }
    final root = Directory.current;
    final output = Directory(_safeProjectPath(root, outputPath));
    final rulesFile = File(_safeProjectPath(root, rulesPath));
    final artifacts = TidbEndpointSpec.generate(
      tables: tableMap.values.toList(),
      rules: TidbRulesReader.fromFile(rulesFile),
    );
    _cleanPreviouslyGenerated(output, artifacts.files.keys.toSet());
    for (final file in artifacts.files.entries) {
      final target = File("${output.path}/${file.key}");
      target.parent.createSync(recursive: true);
      target.writeAsStringSync(file.value);
    }
  }

  void _cleanPreviouslyGenerated(
    Directory output,
    Set<String> nextFiles,
  ) {
    final manifest = File("${output.path}/__generated_manifest.json");
    if (!manifest.existsSync()) {
      return;
    }
    try {
      final decoded = jsonDecode(manifest.readAsStringSync());
      if (decoded is! Map || decoded["generated_files"] is! List) {
        return;
      }
      for (final value in decoded["generated_files"] as List) {
        if (value is! String || nextFiles.contains(value)) {
          continue;
        }
        final target = File("${output.path}/$value");
        if (target.existsSync()) {
          target.deleteSync();
        }
      }
    } on FormatException {
      // A malformed manifest is never trusted for cleanup.
    }
  }

  String _safeProjectPath(Directory root, String relative) {
    final normalized = relative.replaceAll("\\", "/");
    if (normalized.startsWith("/") ||
        normalized.split("/").contains("..") ||
        normalized.trim().isEmpty) {
      throw ArgumentError("Output paths must remain inside the project.");
    }
    return "${root.path}/$normalized";
  }

  String _readModelPath(ClassElement element) {
    for (final metadata in element.metadata.annotations) {
      final value = metadata.computeConstantValue();
      if (value?.type != null &&
          (_collectionModelPathChecker.isExactlyType(value!.type!) ||
              _documentModelPathChecker.isExactlyType(value.type!))) {
        final path = value.getField("path")?.toStringValue();
        if (path != null && path.isNotEmpty) {
          return path;
        }
      }
    }
    throw InvalidGenerationSourceError(
      "`@TidbDataService()` requires @CollectionModelPath or @DocumentModelPath.",
      element: element,
    );
  }

  String _tableNameFromModelPath(
    String path,
    String database,
    ClassElement element,
  ) {
    final segments =
        path.split("/").where((segment) => segment.isNotEmpty).toList();
    final databasePath = segments.isNotEmpty && segments.first == "database";
    if (databasePath &&
        segments.length > 1 &&
        !segments[1].startsWith(":") &&
        !(segments[1].startsWith("{") && segments[1].endsWith("}")) &&
        segments[1] != database) {
      throw InvalidGenerationSourceError(
        "The model path database `${segments[1]}` does not match "
        "@TidbDataService(database: \"$database\").",
        element: element,
      );
    }
    final modelSegments = databasePath ? segments.skip(2) : segments;
    final staticSegments = modelSegments
        .where((segment) =>
            !segment.startsWith(":") &&
            !(segment.startsWith("{") && segment.endsWith("}")))
        .toList();
    if (staticSegments.length != 1) {
      throw InvalidGenerationSourceError(
        "TiDB Data Service v1 supports only flat model paths. "
        "Nested path was: $path",
        element: element,
      );
    }
    final table = staticSegments.single;
    if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(table)) {
      throw InvalidGenerationSourceError(
        "The model path must map to a valid TiDB table name: $table",
        element: element,
      );
    }
    return table;
  }

  List<TidbColumnSpec> _columns(ClassElement element) {
    final constructors =
        element.constructors.where((constructor) => constructor.name == "new");
    if (constructors.isEmpty) {
      throw InvalidGenerationSourceError(
        "An unnamed model constructor is required.",
        element: element,
      );
    }
    return constructors.first.formalParameters
        .where((parameter) => parameter.name != "key")
        .map((parameter) => TidbColumnSpec(
              name: parameter.name!,
              sqlType: _sqlType(parameter.type.getDisplayString()),
              required: parameter.isRequired,
            ))
        .toList();
  }

  String _sqlType(String dartType) {
    final type = dartType.replaceAll("?", "");
    if (type == "String") {
      return "TEXT";
    }
    if (type == "int") {
      return "BIGINT";
    }
    if (type == "double" || type == "num") {
      return "DOUBLE";
    }
    if (type == "bool") {
      return "TINYINT(1)";
    }
    if (type == "DateTime" ||
        type == "ModelTimestamp" ||
        type == "ModelDate" ||
        type == "ModelTime") {
      return "BIGINT";
    }
    if (type.startsWith("List<") ||
        type.startsWith("Map<") ||
        type.startsWith("ModelRef<")) {
      return "JSON";
    }
    return "JSON";
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        ".dart": [".tidb_data_service"],
      };
}
