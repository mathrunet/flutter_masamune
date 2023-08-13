part of katana_model_local;

/// {@macro csv_source_model_adapter}
///
/// The first line is treated as a header and the strings listed there as keys.
///
/// The elements of a row are the documents, and each row forms a collection.
///
/// １行目をヘッダーとして扱い、そこに記載されている文字列をキーとして扱います。
///
/// 行の要素がドキュメントとなり、行ごとにコレクションが形成されます。
///
/// ```csv
/// id,name,age
/// 1,John,20
/// 2,Tom,30
/// 3,Alice,40
/// ```
///
/// ->
///
/// ```json
/// {
///   "1": {
///     "id": 1,
///     "name": "John",
///     "age": 20
///   },
///   "2": {
///     "id": 2,
///     "name": "Tom",
///     "age": 30
///   },
///   "3": {
///     "id": 3,
///     "name": "Alice",
///     "age": 40
///   }
/// }
/// ```
@immutable
class CsvCollectionSourceModelAdapter extends CsvSourceModelAdapter {
  /// {@macro csv_source_model_adapter}
  ///
  /// The first line is treated as a header and the strings listed there as keys.
  ///
  /// The elements of a row are the documents, and each row forms a collection.
  ///
  /// １行目をヘッダーとして扱い、そこに記載されている文字列をキーとして扱います。
  ///
  /// 行の要素がドキュメントとなり、行ごとにコレクションが形成されます。
  ///
  /// ```csv
  /// id,name,age
  /// 1,John,20
  /// 2,Tom,30
  /// 3,Alice,40
  /// ```
  ///
  /// ->
  ///
  /// ```json
  /// {
  ///   "1": {
  ///     "id": 1,
  ///     "name": "John",
  ///     "age": 20
  ///   },
  ///   "2": {
  ///     "id": 2,
  ///     "name": "Tom",
  ///     "age": 30
  ///   },
  ///   "3": {
  ///     "id": 3,
  ///     "name": "Alice",
  ///     "age": 40
  ///   }
  /// }
  /// ```
  const CsvCollectionSourceModelAdapter({
    super.initialValue,
    super.database,
    super.collectionPath,
    required super.source,
    required this.idKey,
    super.requestHeaders,
    super.requestMethod,
  });

  /// Key of the column to be used as the ID.
  ///
  /// IDとして使うカラムのキー。
  final String idKey;

  @override
  Map<String, DynamicMap> fromCsv(List<List<dynamic>> csv) {
    if (csv.length < 2) {
      return {};
    }
    final header = csv.first;
    final data = csv.skip(1).toList();
    final result = <String, DynamicMap>{};
    for (final row in data) {
      final map = <String, dynamic>{};
      for (var i = 0; i < header.length; i++) {
        map[header[i].toString()] = _toAny(row[i]);
      }
      result[map[idKey].toString()] = _merged(map);
    }
    return result;
  }
}

/// {@macro csv_source_model_adapter}
///
/// Treats a CSV with a sequence of keys and values as a document. It cannot be used as a collection.
///
/// If [direction] is set to [Axis.horizontal], data can be defined in the horizontal direction.
///
/// If [direction] is set to [Axis.vertical], data can be defined in the vertical direction.
///
/// The offset of the data can be specified with [offset].
///
/// キーと値が並んだCSVをドキュメントとして扱います。コレクションとしては利用できません。
///
/// [direction]を[Axis.horizontal]にすると横方向にデータを定義できます。
///
/// [direction]を[Axis.vertical]にすると縦方向にデータを定義できます。
///
/// [offset]でデータのオフセットを指定できます。
///
/// ```csv
/// // Horizontal
/// id,name,age
/// 1,John,20
///
/// // Vertical
/// id,1
/// name,John
/// age,20
/// ```
///
/// ->
///
/// ```json
/// {
///   "id": 1,
///   "name": "John",
///   "age": 20
/// }
/// ```
@immutable
class CsvDocumentSourceModelAdapter extends CsvSourceModelAdapter {
  /// {@macro csv_source_model_adapter}
  ///
  /// Treats a CSV with a sequence of keys and values as a document. It cannot be used as a collection.
  ///
  /// If [direction] is set to [Axis.horizontal], data can be defined in the horizontal direction.
  ///
  /// If [direction] is set to [Axis.vertical], data can be defined in the vertical direction.
  ///
  /// The offset of the data can be specified with [offset].
  ///
  /// キーと値が並んだCSVをドキュメントとして扱います。コレクションとしては利用できません。
  ///
  /// [direction]を[Axis.horizontal]にすると横方向にデータを定義できます。
  ///
  /// [direction]を[Axis.vertical]にすると縦方向にデータを定義できます。
  ///
  /// [offset]でデータのオフセットを指定できます。
  ///
  /// ```csv
  /// // Horizontal
  /// id,name,age
  /// 1,John,20
  ///
  /// // Vertical
  /// id,1
  /// name,John
  /// age,20
  /// ```
  ///
  /// ->
  ///
  /// ```json
  /// {
  ///   "id": 1,
  ///   "name": "John",
  ///   "age": 20
  /// }
  /// ```
  const CsvDocumentSourceModelAdapter({
    super.initialValue,
    super.database,
    super.collectionPath,
    this.documentId,
    required super.source,
    this.offset,
    this.direction = Axis.horizontal,
    super.requestHeaders,
    super.requestMethod,
  });

  /// ID as a document.
  ///
  /// The document path is formed by [collectionPath]/[documentId].
  ///
  /// If [Null], the hash value of [source] is used.
  ///
  /// ドキュメントとしてのID。
  ///
  /// [collectionPath]/[documentId]でドキュメントパスが形成されます。
  ///
  /// [Null]の場合は[source]のハッシュ値を利用します。
  final String? documentId;

  /// Offset of XY axis.
  ///
  /// XY軸のオフセット。
  final Offset? offset;

  /// Direction in which data is read.
  ///
  /// データを読み取る方向。
  ///
  /// ```csv
  /// // Horizontal
  /// id,name,age
  /// 1,John,20
  ///
  /// // Vertical
  /// id,1
  /// name,John
  /// age,20
  /// ```
  ///
  /// ->
  ///
  /// ```json
  /// {
  ///   "id": 1,
  ///   "name": "John",
  ///   "age": 20
  /// }
  /// ```
  final Axis direction;

  @override
  Map<String, DynamicMap> fromCsv(List<List<dynamic>> csv) {
    final res = <String, dynamic>{};
    final documentId = this.documentId ?? source.hashCode.toString();
    switch (direction) {
      case Axis.horizontal:
        final effectiveOffset = offset ?? const Offset(0, 0);
        if (csv.length <= effectiveOffset.dy + 1) {
          throw Exception("The number of rows is less than the offset.");
        }
        final header = csv[effectiveOffset.dy.toInt()];
        final values = csv[effectiveOffset.dy.toInt() + 1];
        if (header.length <= effectiveOffset.dx ||
            values.length <= effectiveOffset.dx) {
          throw Exception("The number of columns is less than the offset.");
        }
        for (var i = effectiveOffset.dx.toInt(); i < header.length; i++) {
          final key = header[i].toString();
          final value = values[i];
          if (value == null || key.isEmpty) {
            continue;
          }
          res[key] = _toAny(value);
        }
        return {
          documentId: _merged(res),
        };

      case Axis.vertical:
        final effectiveOffset = offset ?? const Offset(0, 0);
        if (csv.length <= effectiveOffset.dy) {
          throw Exception("The number of rows is less than the offset.");
        }
        for (var i = effectiveOffset.dy.toInt(); i < csv.length; i++) {
          final line = csv[i];
          if (line.length <= effectiveOffset.dx + 1) {
            throw Exception("The number of columns is less than the offset.");
          }
          final key = line[effectiveOffset.dx.toInt()].toString();
          final value = line[effectiveOffset.dx.toInt() + 1];
          if (value == null || key.isEmpty) {
            continue;
          }
          res[key] = _toAny(value);
        }
        return {
          documentId: _merged(res),
        };
    }
  }

  @override
  ModelAdapterDocumentQuery _replaceDocumentQuery(
    ModelAdapterDocumentQuery query,
  ) {
    final collectionPath = this.collectionPath ?? source.hashCode.toString();
    final documentId = this.documentId ?? source.hashCode.toString();
    return ModelAdapterDocumentQuery(
      query: query.query.copyWith(
        path: "$collectionPath/$documentId",
        adapter: query.query.adapter,
      ),
      callback: query.callback,
      origin: query.origin,
      listen: false,
      headers: requestHeaders ?? {},
      method: requestMethod,
    );
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    throw UnsupportedError("This adapter cannot be used as a collection.");
  }

  @override
  Future<int> loadCollectionCount(
    ModelAdapterCollectionQuery query, {
    Iterable? retreivedList,
  }) async {
    throw UnsupportedError("This adapter cannot be used as a collection.");
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    throw UnsupportedError("This adapter cannot be used as a collection.");
  }
}

/// {@template csv_source_model_adapter}
/// A database adapter that uses CSV files as a data source.
///
/// CSV files can be used as configuration files for settings and other purposes.
///
/// URL, asset path, or CSV data can be directly specified in [source].
///
/// [requestHeaders] specifies request headers to be sent when requesting as HTTP.
///
/// [requestMethod] specifies the request method to be sent when requesting as HTTP.
///
/// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
///
/// CSVファイルをデータソースとして利用するデータベースアダプター。
///
/// CSVファイルで設定などを行う場合、設定ファイルとして利用することができます。
///
/// [source]にはURLやアセットパス、CSVデータを直接指定することができます。
///
/// [requestHeaders]にはHTTPとしてリクエストする際に送るリクエストヘッダーを指定します。
///
/// [requestMethod]にはHTTPとしてリクエストする際に送るリクエストメソッドを指定します。
///
/// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
/// {@endtemplate}
///
/// CSV data is converted to [Map] by writing the process for conversion in [fromCsv].
///
/// [fromCsv]に変換用の処理を記述することでCSVのデータを[Map]に変換します。
@immutable
abstract class CsvSourceModelAdapter extends ModelAdapter {
  /// {@template csv_source_model_adapter}
  /// A database adapter that uses CSV files as a data source.
  ///
  /// CSV files can be used as configuration files for settings and other purposes.
  ///
  /// URL, asset path, or CSV data can be directly specified in [source].
  ///
  /// [requestHeaders] specifies request headers to be sent when requesting as HTTP.
  ///
  /// [requestMethod] specifies the request method to be sent when requesting as HTTP.
  ///
  /// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
  ///
  /// CSVファイルをデータソースとして利用するデータベースアダプター。
  ///
  /// CSVファイルで設定などを行う場合、設定ファイルとして利用することができます。
  ///
  /// [source]にはURLやアセットパス、CSVデータを直接指定することができます。
  ///
  /// [requestHeaders]にはHTTPとしてリクエストする際に送るリクエストヘッダーを指定します。
  ///
  /// [requestMethod]にはHTTPとしてリクエストする際に送るリクエストメソッドを指定します。
  ///
  /// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
  /// {@endtemplate}
  ///
  /// CSV data is converted to [Map] by writing the process for conversion in [fromCsv].
  ///
  /// [fromCsv]に変換用の処理を記述することでCSVのデータを[Map]に変換します。
  const CsvSourceModelAdapter({
    NoSqlDatabase? database,
    this.initialValue,
    required this.source,
    this.requestHeaders,
    this.requestMethod,
    this.collectionPath,
  }) : _database = database;

  final NoSqlDatabase? _database;

  /// Designated database.
  ///
  /// 指定のデータベース。
  NoSqlDatabase get database {
    final database = _database ?? sharedDatabase;
    if (initialValue.isNotEmpty && !database.isInitialValueRegistered) {
      for (final raw in initialValue!) {
        if (raw is ModelInitialDocument) {
          final map = raw.toMap(raw.value);
          database.setInitialValue(
            raw.path,
            raw.filterOnSave(map, raw.value),
          );
        } else if (raw is ModelInitialCollection) {
          for (final tmp in raw.value.entries) {
            final map = raw.toMap(tmp.value);
            database.setInitialValue(
              "${raw.path}/${tmp.key}",
              raw.filterOnSave(map, tmp.value),
            );
          }
        }
      }
    }
    return database;
  }

  /// A common database throughout the application.
  ///
  /// アプリ内全体での共通のデータベース。
  static final NoSqlDatabase sharedDatabase = NoSqlDatabase();

  /// The path of the destination as a collection.
  ///
  /// If [Null], the hash value of [source] is used.
  ///
  /// コレクションとしての保存先のパス。
  ///
  /// [Null]の場合は[source]のハッシュ値を利用します。
  final String? collectionPath;

  /// Actual data when used as a mock-up.
  ///
  /// モックアップとして利用する際の実データ。
  final List<ModelInitialValue>? initialValue;

  /// Data source.
  ///
  /// Specifying a URL will load a CSV file.
  ///
  /// If a relative path is specified, the file is read from the asset data.
  ///
  /// If data with newlines is specified, it is directly read as CSV data.
  ///
  /// データソース。
  ///
  /// URLを指定するとCSVファイルを読み込みます。
  ///
  /// 相対パスを指定するとアセットデータからファイルを読み込みます。
  ///
  /// 改行入りのデータを指定すると直接CSVデータとして読み込みます。
  final String source;

  /// A request header sent when making a request as HTTP.
  ///
  /// HTTPとしてリクエストする際に送るリクエストヘッダー。
  final Map<String, String>? requestHeaders;

  /// A request method sent when making a request as HTTP.
  ///
  /// HTTPとしてリクエストする際に送るリクエストメソッド。
  final String? requestMethod;

  /// CSV data [List] can be retrieved in [NoSqlDatabase] [Map].
  ///
  /// Specify the ID of the document as the key of [Map] and the data of the document as the value in [DynamicMap].
  ///
  /// CSVのデータ[List]を[NoSqlDatabase]で取得可能な[Map]。
  ///
  /// [Map]のキーにドキュメントのIDを指定し、値にドキュメントのデータを[DynamicMap]で指定します。
  Map<String, DynamicMap> fromCsv(List<List<dynamic>> csv);

  Future<void> _loadCSV(NoSqlDatabase database) async {
    if (database.data.isNotEmpty) {
      return;
    }
    try {
      final source =
          this.source.replaceAll("\r\n", "\n").replaceAll("\r", "\n");
      final collectionPath = this.collectionPath ?? source.hashCode.toString();
      if (source.startsWith("http")) {
        switch (requestMethod) {
          case "POST":
            final res = await Api.post(
              source,
              headers: requestHeaders,
            );
            if (res.statusCode != 200) {
              throw Exception(
                "Failed to load CSV file. [${res.statusCode}]",
              );
            }
            database.data = {
              collectionPath: fromCsv(
                const CsvToListConverter(eol: "\n").convert(res.body),
              ),
            };
            break;
          default:
            final res = await Api.get(
              source,
              headers: requestHeaders,
            );
            if (res.statusCode != 200) {
              throw Exception(
                "Failed to load CSV file. [${res.statusCode}]",
              );
            }
            database.data = {
              collectionPath: fromCsv(
                const CsvToListConverter(eol: "\n").convert(res.body),
              ),
            };
            break;
        }
      } else if (source.contains("\n")) {
        database.data = {
          collectionPath: fromCsv(
            const CsvToListConverter(eol: "\n").convert(source),
          ),
        };
      } else {
        final csv = await rootBundle.loadString(source);
        database.data = {
          collectionPath: fromCsv(
            const CsvToListConverter(eol: "\n").convert(csv),
          ),
        };
      }
    } catch (e) {
      throw Exception(
        "Failed to load CSV file. [$e]",
      );
    }
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final data = await database.loadDocument(
      _replaceDocumentQuery(query),
      onLoad: (db) => _loadCSV(db),
    );
    return data != null ? Map.from(data) : {};
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final data = await database.loadCollection(
      _replaceCollectionQuery(query),
      onLoad: (db) => _loadCSV(db),
    );
    return data != null
        ? data.map((key, value) => MapEntry(key, Map.from(value)))
        : {};
  }

  @override
  Future<int> loadCollectionCount(
    ModelAdapterCollectionQuery query, {
    Iterable? retreivedList,
  }) async {
    if (retreivedList != null) {
      return retreivedList.length;
    }
    final data = await database.loadCollection(
      _replaceCollectionQuery(query),
      onLoad: (db) => _loadCSV(db),
    );
    return data.length;
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    throw UnsupportedError("This adapter cannot delete.");
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    throw UnsupportedError("This adapter cannot save.");
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    database.removeDocumentListener(_replaceDocumentQuery(query));
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    database.removeCollectionListener(_replaceCollectionQuery(query));
  }

  @override
  bool get availableListen => false;

  @override
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  ) {
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  void deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    if (ref is! CsvSourceModelTransactionRef) {
      throw Exception("[ref] is not [LocalModelTransactionRef].");
    }
    throw UnsupportedError("This adapter cannot delete.");
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    return loadDocument(query);
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! CsvSourceModelTransactionRef) {
      throw Exception("[ref] is not [LocalModelTransactionRef].");
    }
    throw UnsupportedError("This adapter cannot save.");
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  ) async {
    final ref = CsvSourceModelTransactionRef._();
    await transaction.call(ref);
    for (final tmp in ref._transactionList) {
      await tmp.call();
    }
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return source.hashCode;
  }

  @override
  void deleteOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    if (ref is! CsvSourceModelBatchRef) {
      throw Exception("[ref] is not [LocalModelBatchRef].");
    }
    throw UnsupportedError("This adapter cannot delete.");
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! CsvSourceModelBatchRef) {
      throw Exception("[ref] is not [LocalModelBatchRef].");
    }
    throw UnsupportedError("This adapter cannot save.");
  }

  @override
  FutureOr<void> runBatch(
    FutureOr<void> Function(
      ModelBatchRef ref,
    ) batch,
    int splitLength,
  ) async {
    final ref = CsvSourceModelBatchRef._();
    await batch.call(ref);
    await wait(
      ref._batchList.map((tmp) => tmp.call()),
    );
  }

  ModelAdapterDocumentQuery _replaceDocumentQuery(
    ModelAdapterDocumentQuery query,
  ) {
    final collectionPath = this.collectionPath ?? source.hashCode.toString();
    return ModelAdapterDocumentQuery(
      query: query.query.copyWith(
        path: "$collectionPath/${query.query.path.last()}",
        adapter: query.query.adapter,
      ),
      callback: query.callback,
      origin: query.origin,
      listen: false,
      headers: requestHeaders ?? {},
      method: requestMethod,
    );
  }

  ModelAdapterCollectionQuery _replaceCollectionQuery(
    ModelAdapterCollectionQuery query,
  ) {
    final collectionPath = this.collectionPath ?? source.hashCode.toString();
    return ModelAdapterCollectionQuery(
      query: query.query.copyWith(
        path: collectionPath,
        adapter: query.query.adapter,
      ),
      callback: query.callback,
      origin: query.origin,
      listen: false,
      headers: requestHeaders ?? {},
      method: requestMethod,
    );
  }
}

/// [ModelTransactionRef] for [CsvSourceModelAdapter].
/// [CsvSourceModelAdapter]用の[ModelTransactionRef]。
@immutable
class CsvSourceModelTransactionRef extends ModelTransactionRef {
  CsvSourceModelTransactionRef._();

  final List<FutureOr<void> Function()> _transactionList = [];
}

/// [ModelBatchRef] for [CsvSourceModelAdapter].
/// [CsvSourceModelAdapter]用の[ModelBatchRef]。
@immutable
class CsvSourceModelBatchRef extends ModelBatchRef {
  CsvSourceModelBatchRef._();

  final List<FutureOr<void> Function()> _batchList = [];
}

dynamic _toAny(Object? object) {
  if (object == null) {
    return null;
  } else if (object is num) {
    return object;
  } else if (object is bool) {
    return object;
  } else {
    final st = object.toString();
    final d = double.tryParse(st);
    if (d != null) {
      return d;
    }
    final i = int.tryParse(st);
    if (i != null) {
      return i;
    }
    if (st.toLowerCase() == "true") {
      return true;
    }
    if (st.toLowerCase() == "false") {
      return false;
    }
    final dt = DateTime.tryParse(st);
    if (dt != null) {
      return ModelTimestamp(dt).toJson();
    }
    final uri = Uri.tryParse(st);
    if (uri != null && uri.scheme == "ref") {
      return ModelRefBase.fromPath(
        uri.toString().replaceAll(RegExp("^ref:/"), ""),
      ).toJson();
    }
    return object;
  }
}

DynamicMap _merged(DynamicMap map) {
  final result = <String, dynamic>{};
  final localized = <String, Map<Locale, String>>{};
  for (final entry in map.entries) {
    if (entry.key.contains(":")) {
      final keys = entry.key.split(":");
      final key = keys.first;
      switch (keys.length) {
        case 2:
          if (!localized.containsKey(key)) {
            localized[key] = {};
          }
          final locales = keys.last.split("_");
          final locale = Locale(
            locales.first,
            locales.length < 2 ? null : locales.last,
          );
          localized[key]![locale] = entry.value;
          break;
        default:
          result[entry.key] = entry.value;
          break;
      }
    } else {
      result[entry.key] = entry.value;
    }
  }
  if (localized.isNotEmpty) {
    for (final l in localized.entries) {
      result[l.key] = ModelLocalizedValue.fromList(
        l.value
            .toList((key, value) => LocalizedLocaleValue(key, value))
            .toList(),
      ).toJson();
    }
  }
  return result;
}
