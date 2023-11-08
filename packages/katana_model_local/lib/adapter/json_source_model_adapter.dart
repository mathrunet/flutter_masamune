part of '/katana_model_local.dart';

/// {@macro json_source_model_adapter}
///
/// Treat Json in the form of a Map of Map or a List of Map as a collection.
///
/// MapのMap、もしくはMapのListの形式のJsonをコレクションとして扱います。
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
class JsonCollectionSourceModelAdapter extends JsonSourceModelAdapter {
  /// {@macro json_source_model_adapter}
  ///
  /// Treat Json in the form of a Map of Map or a List of Map as a collection.
  ///
  /// MapのMap、もしくはMapのListの形式のJsonをコレクションとして扱います。
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
  const JsonCollectionSourceModelAdapter({
    super.initialValue,
    super.database,
    super.collectionPath,
    required super.source,
    this.idKey,
    super.requestHeaders,
    super.requestMethod,
  });

  /// Key of the map to be used as ID.
  ///
  /// Used when Json is [List].
  ///
  /// IDとして使うマップのキー。
  ///
  /// Jsonが[List]の場合に利用します。
  final String? idKey;

  @override
  Map<String, DynamicMap> fromJson(dynamic json) {
    final result = <String, DynamicMap>{};
    if (json is List) {
      assert(idKey.isNotEmpty, "If Json is a List, [idKey] must be specified.");
      for (final tmp in json) {
        if (tmp is! Map) {
          continue;
        }
        final converted = tmp.map((key, value) {
          final r = _toAny(value);
          return MapEntry(key.toString().trim(), r);
        }).where((key, value) => value != null);
        final key = converted.get(idKey!, "").toString().trim();
        result[key] = _merged(converted);
      }
    } else if (json is Map) {
      for (final tmp in json.entries) {
        final value = tmp.value;
        if (value is! Map) {
          continue;
        }
        final converted = value.map((key, value) {
          final r = _toAny(value);
          return MapEntry(key.toString().trim(), r);
        }).where((key, value) => value != null);
        final key = tmp.key.trim();
        result[key] = _merged(converted);
      }
    } else {
      throw Exception("Incorrect data.");
    }
    return result;
  }
}

/// {@macro json_source_model_adapter}
///
/// Use the Json containing the map as documentation.
///
/// マップを含むJsonをドキュメントとして利用します。
///
/// ```csv
/// {
///   "id": 1,
///   "name": "John",
///   "age": 20
/// }
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
class JsonDocumentSourceModelAdapter extends JsonSourceModelAdapter {
  /// {@macro json_source_model_adapter}
  ///
  /// Use the Json containing the map as documentation.
  ///
  /// マップを含むJsonをドキュメントとして利用します。
  ///
  /// ```csv
  /// {
  ///   "id": 1,
  ///   "name": "John",
  ///   "age": 20
  /// }
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
  const JsonDocumentSourceModelAdapter({
    super.initialValue,
    super.database,
    super.collectionPath,
    this.documentId,
    required super.source,
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

  @override
  Map<String, DynamicMap> fromJson(dynamic json) {
    if (json is! Map) {
      throw Exception("The data is not a Map.");
    }
    final documentId = this.documentId ?? source.hashCode.toString();
    final converted = json.map((key, value) {
      final r = _toAny(value);
      return MapEntry(key.toString().trim(), r);
    }).where((key, value) => value != null);
    return {
      documentId: _merged(converted),
    };
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
  Future<int> loadCollectionCount(ModelAdapterCollectionQuery query) async {
    throw UnsupportedError("This adapter cannot be used as a collection.");
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    throw UnsupportedError("This adapter cannot be used as a collection.");
  }
}

/// {@template json_source_model_adapter}
/// A database adapter that uses Json files as a data source.
///
/// Json files can be used as configuration files for settings and other purposes.
///
/// URL, asset path, or Json data can be directly specified in [source].
///
/// [requestHeaders] specifies request headers to be sent when requesting as HTTP.
///
/// [requestMethod] specifies the request method to be sent when requesting as HTTP.
///
/// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
///
/// Jsonファイルをデータソースとして利用するデータベースアダプター。
///
/// Jsonファイルで設定などを行う場合、設定ファイルとして利用することができます。
///
/// [source]にはURLやアセットパス、Jsonデータを直接指定することができます。
///
/// [requestHeaders]にはHTTPとしてリクエストする際に送るリクエストヘッダーを指定します。
///
/// [requestMethod]にはHTTPとしてリクエストする際に送るリクエストメソッドを指定します。
///
/// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
/// {@endtemplate}
///
/// Json data is converted to [Map] by writing the process for conversion in [fromJson].
///
/// [fromJson]に変換用の処理を記述することでJsonのデータを[Map]に変換します。
@immutable
abstract class JsonSourceModelAdapter extends ModelAdapter {
  /// {@template json_source_model_adapter}
  /// A database adapter that uses Json files as a data source.
  ///
  /// Json files can be used as configuration files for settings and other purposes.
  ///
  /// URL, asset path, or Json data can be directly specified in [source].
  ///
  /// [requestHeaders] specifies request headers to be sent when requesting as HTTP.
  ///
  /// [requestMethod] specifies the request method to be sent when requesting as HTTP.
  ///
  /// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
  ///
  /// Jsonファイルをデータソースとして利用するデータベースアダプター。
  ///
  /// Jsonファイルで設定などを行う場合、設定ファイルとして利用することができます。
  ///
  /// [source]にはURLやアセットパス、Jsonデータを直接指定することができます。
  ///
  /// [requestHeaders]にはHTTPとしてリクエストする際に送るリクエストヘッダーを指定します。
  ///
  /// [requestMethod]にはHTTPとしてリクエストする際に送るリクエストメソッドを指定します。
  ///
  /// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
  /// {@endtemplate}
  ///
  /// Json data is converted to [Map] by writing the process for conversion in [fromJson].
  ///
  /// [fromJson]に変換用の処理を記述することでJsonのデータを[Map]に変換します。
  const JsonSourceModelAdapter({
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
  /// If a URL is specified, a Json file is read.
  ///
  /// If a relative path is specified, the file is read from the asset data.
  ///
  /// If data with newlines is specified, it is read directly as Json data.
  ///
  /// データソース。
  ///
  /// URLを指定するとJsonファイルを読み込みます。
  ///
  /// 相対パスを指定するとアセットデータからファイルを読み込みます。
  ///
  /// 改行入りのデータを指定すると直接Jsonデータとして読み込みます。
  final String source;

  /// A request header sent when making a request as HTTP.
  ///
  /// HTTPとしてリクエストする際に送るリクエストヘッダー。
  final Map<String, String>? requestHeaders;

  /// A request method sent when making a request as HTTP.
  ///
  /// HTTPとしてリクエストする際に送るリクエストメソッド。
  final String? requestMethod;

  /// Json data [List] can be retrieved in [NoSqlDatabase] [Map].
  ///
  /// Specify the ID of the document as the key of [Map] and the data of the document as the value in [DynamicMap].
  ///
  /// Jsonのデータ[List]を[NoSqlDatabase]で取得可能な[Map]。
  ///
  /// [Map]のキーにドキュメントのIDを指定し、値にドキュメントのデータを[DynamicMap]で指定します。
  Map<String, DynamicMap> fromJson(dynamic json);

  Future<void> _loadJson(NoSqlDatabase database) async {
    final collectionPath = this.collectionPath ?? source.hashCode.toString();
    if (database.registeredInitialValuePaths
        .any((e) => e.startsWith(collectionPath))) {
      return;
    }
    try {
      final source =
          this.source.replaceAll("\r\n", "\n").replaceAll("\r", "\n");
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
            final text = utf8.decode(res.bodyBytes);
            final docs = fromJson(jsonDecode(text));
            for (final tmp in docs.entries) {
              database.setInitialValue("$collectionPath/${tmp.key}", tmp.value);
            }
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
            final text = utf8.decode(res.bodyBytes);
            final docs = fromJson(jsonDecode(text));
            for (final tmp in docs.entries) {
              database.setInitialValue("$collectionPath/${tmp.key}", tmp.value);
            }
            break;
        }
      } else if (source.startsWith("{") || source.startsWith("[")) {
        final docs = fromJson(jsonDecode(source));
        for (final tmp in docs.entries) {
          database.setInitialValue("$collectionPath/${tmp.key}", tmp.value);
        }
      } else {
        final json = await rootBundle.loadString(source);
        final docs = fromJson(jsonDecode(json));
        for (final tmp in docs.entries) {
          database.setInitialValue("$collectionPath/${tmp.key}", tmp.value);
        }
      }
    } catch (e) {
      throw Exception(
        "Failed to load CSV file. [$e]",
      );
    }
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    await _loadJson(database);
    final data = await database.loadDocument(
      _replaceDocumentQuery(query),
    );
    return data != null ? Map.from(data) : {};
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    await _loadJson(database);
    final data = await database.loadCollection(
      _replaceCollectionQuery(query),
    );
    return data != null
        ? data.map((key, value) => MapEntry(key, Map.from(value)))
        : {};
  }

  @override
  Future<int> loadCollectionCount(ModelAdapterCollectionQuery query) async {
    await _loadJson(database);
    final data = await database.loadCollection(
      _replaceCollectionQuery(
        query.copyWith(query: query.query.remove(ModelQueryFilterType.limit)),
      ),
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
    if (ref is! JsonSourceModelTransactionRef) {
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
    if (ref is! JsonSourceModelTransactionRef) {
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
    final ref = JsonSourceModelTransactionRef._();
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
    if (ref is! JsonSourceModelBatchRef) {
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
    if (ref is! JsonSourceModelBatchRef) {
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
    final ref = JsonSourceModelBatchRef._();
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

/// [ModelTransactionRef] for [JsonSourceModelTransactionRef].
///
/// [JsonSourceModelTransactionRef]用の[ModelTransactionRef]。
@immutable
class JsonSourceModelTransactionRef extends ModelTransactionRef {
  JsonSourceModelTransactionRef._();

  final List<FutureOr<void> Function()> _transactionList = [];
}

/// [ModelBatchRef] for [JsonSourceModelBatchRef].
///
/// [JsonSourceModelBatchRef]用の[ModelBatchRef]。
@immutable
class JsonSourceModelBatchRef extends ModelBatchRef {
  JsonSourceModelBatchRef._();

  final List<FutureOr<void> Function()> _batchList = [];
}
