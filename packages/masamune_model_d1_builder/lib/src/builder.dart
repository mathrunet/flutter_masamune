part of "/masamune_model_d1_builder.dart";

const _d1SchemaChecker = TypeChecker.typeNamed(D1Schema);
const _collectionModelPathChecker = TypeChecker.typeNamed(CollectionModelPath);
const _documentModelPathChecker = TypeChecker.typeNamed(DocumentModelPath);

class _MasamuneModelD1Builder extends Builder {
  _MasamuneModelD1Builder(this._configuredPrefixes);

  final List<String> _configuredPrefixes;

  @override
  Future<void> build(BuildStep buildStep) async {
    if (!await buildStep.resolver.isLibrary(buildStep.inputId)) {
      return;
    }
    final library = await buildStep.resolver.libraryFor(buildStep.inputId);
    final tables = <D1TableSpec>[];
    String? schemaDirPath;
    for (final annotated
        in LibraryReader(library).annotatedWith(_d1SchemaChecker)) {
      final element = annotated.element;
      if (element is! ClassElement) {
        throw InvalidGenerationSourceError(
          "`@D1Schema()` can only be used on classes.",
          element: element,
        );
      }
      final annotation = annotated.annotation;
      final database = annotation.read("database").stringValue.trim();
      final outputPath = annotation.read("schemaDirPath").stringValue.trim();
      final modelPath = _readModelPath(element);
      final table = _tableNameFromModelPath(
        modelPath,
        database,
        element,
      );
      schemaDirPath ??= outputPath;
      if (schemaDirPath != outputPath) {
        throw InvalidGenerationSourceError("同じ入力のschemaDirPathは統一してください。",
            element: element);
      }
      final prefixes = _readPrefixes(
        [
          ..._configuredPrefixes,
          ...annotation
              .read("prefixes")
              .listValue
              .map((value) => value.toStringValue()),
        ],
        element,
      );
      final modelTable = D1TableSpec(
        database: database,
        table: table,
        vectors: _readVectors(annotation.read("vectors")),
        columns: [
          ..._columns(element),
          ..._readColumns(annotation.read("extraColumns")),
        ],
        indexes: {
          for (final entry in annotation.read("indexes").mapValue.entries)
            entry.key!.toStringValue()!: [
              for (final value in entry.value!.toListValue()!)
                value.toStringValue()!,
            ],
        },
      );
      tables.addAll(_withDatabasePrefixes(modelTable, prefixes));
      for (final value in annotation.read("additionalTables").listValue) {
        final table = ConstantReader(value);
        final additionalTable = D1TableSpec(
          database: table.read("database").stringValue.trim(),
          table: table.read("table").stringValue.trim(),
          columns: _readColumns(table.read("columns")),
          vectors: _readVectors(table.read("vectors")),
          indexes: {
            for (final entry in table.read("indexes").mapValue.entries)
              entry.key!.toStringValue()!: [
                for (final value in entry.value!.toListValue()!)
                  value.toStringValue()!
              ],
          },
        );
        tables.addAll(_withDatabasePrefixes(additionalTable, prefixes));
      }
    }
    if (tables.isEmpty) {
      return;
    }
    final relative = schemaDirPath!.replaceAll("\\", "/");
    if (relative.startsWith("/") ||
        relative.split("/").contains("..") ||
        relative.trim().isEmpty) {
      throw ArgumentError("schemaDirPathはproject内の相対パスで指定してください。");
    }
    await buildStep.writeAsString(
        buildStep.inputId.changeExtension(".d1_schema"),
        jsonEncode({
          "schemaDirPath": relative,
          "schema": D1SchemaSpec.schemaManifest(tables)
        }));
  }

  List<String> _readPrefixes(
    Iterable<String?> values,
    ClassElement element,
  ) {
    try {
      return normalizeD1DatabasePrefixes(values);
    } on ArgumentError catch (error) {
      throw InvalidGenerationSourceError(
        error.message?.toString() ??
            "D1スキーマ prefixes must be valid identifiers.",
        element: element,
      );
    }
  }

  List<D1TableSpec> _withDatabasePrefixes(
    D1TableSpec table,
    List<String> prefixes,
  ) {
    return [
      table,
      for (final prefix in prefixes)
        D1TableSpec(
          database: "$prefix${table.database}",
          table: table.table,
          columns: table.columns,
          indexes: table.indexes,
          vectors: table.vectors,
        ),
    ];
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
      "`@D1Schema()` requires @CollectionModelPath or @DocumentModelPath.",
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
    if (!databasePath && database != "main") {
      throw InvalidGenerationSourceError(
          "main以外のDBはモデルpathにもdatabase/<database>/を明示してください。",
          element: element);
    }
    if (databasePath &&
        segments.length > 1 &&
        !segments[1].startsWith(":") &&
        !(segments[1].startsWith("{") && segments[1].endsWith("}")) &&
        segments[1] != database) {
      throw InvalidGenerationSourceError(
        "The model path database `${segments[1]}` does not match "
        "@D1Schema(database: \"$database\").",
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
        "D1スキーマ v1 supports only flat model paths. "
        "Nested path was: $path",
        element: element,
      );
    }
    final table = staticSegments.single;
    if (!RegExp(r"^[A-Za-z_][A-Za-z0-9_]*$").hasMatch(table)) {
      throw InvalidGenerationSourceError(
        "The model path must map to a valid D1 table name: $table",
        element: element,
      );
    }
    return table;
  }

  List<D1ColumnSpec> _columns(ClassElement element) {
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
        .map((parameter) => D1ColumnSpec(
              name: _columnName(parameter),
              sqlType: _sqlType(parameter.type.getDisplayString()),
              required: parameter.isRequired,
            ))
        .toList();
  }

  String _columnName(FormalParameterElement parameter) {
    for (final annotation in parameter.metadata.annotations) {
      final value = annotation.computeConstantValue();
      final typeName = value?.type?.element?.name;
      if (typeName != "JsonKey") {
        continue;
      }
      final name = value?.getField("name")?.toStringValue()?.trim();
      if (name != null && name.isNotEmpty) {
        return name;
      }
    }
    return parameter.name!;
  }

  List<Map<String, Object>> _readVectors(ConstantReader reader) => [
        for (final value in reader.listValue)
          {
            "field": ConstantReader(value).read("field").stringValue,
            "binding": ConstantReader(value).read("binding").stringValue,
            "dimensions": ConstantReader(value).read("dimensions").intValue,
            "metric": ConstantReader(value).read("metric").stringValue,
          }
      ];

  List<D1ColumnSpec> _readColumns(ConstantReader reader) {
    return reader.listValue.map((value) {
      final column = ConstantReader(value);
      return D1ColumnSpec(
        name: column.read("name").stringValue.trim(),
        sqlType: column.read("sqlType").stringValue.trim(),
        required: column.read("required").boolValue,
      );
    }).toList();
  }

  String _sqlType(String dartType) {
    final type = dartType.replaceAll("?", "");
    if (type == "String") {
      return "TEXT";
    }
    if (type == "int") {
      return "INTEGER";
    }
    if (type == "double" || type == "num") {
      return "REAL";
    }
    if (type == "bool") {
      return "BOOLEAN";
    }
    if (type == "DateTime") {
      return "TEXT";
    }
    if (type == "ModelTimestamp" ||
        type == "ModelDate" ||
        type == "ModelTime") {
      return "JSON";
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
        ".dart": [".d1_schema"],
      };
}
