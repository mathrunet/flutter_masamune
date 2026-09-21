part of "/masamune_model_d1.dart";

/// Retry delays for transient D1 Worker errors (429 / 5xx / network).
///
/// D1 Worker の一時的なエラー（429 / 5xx / ネットワーク断）用のリトライ待機時間。
const _d1RetryDelays = [
  Duration(milliseconds: 200),
  Duration(milliseconds: 400),
  Duration(milliseconds: 800),
  Duration(milliseconds: 1600),
  Duration(milliseconds: 3200),
  Duration(milliseconds: 5000),
];

/// A model adapter that enables the use of D1.
///
/// It accesses D1 through Cloudflare Workers.
///
/// D1を利用できるようにしたモデルアダプター。
///
/// Cloudflare Workers経由でD1にアクセスします。
class D1ModelAdapter extends ModelAdapter {
  /// A model adapter that enables the use of D1.
  ///
  /// D1を利用できるようにしたモデルアダプター。
  const D1ModelAdapter({
    required String? prefix,
    required this.session,
    this.vectorConverter = const PassVectorConverter(),
    super.defaultAutoDisposeWhenUnreferenced,
    FunctionsAdapter? functionsAdapter,
    NoSqlDatabase? cachedRuntimeDatabase,
  })  : _functionsAdapter = functionsAdapter,
        _prefix = prefix,
        _cachedRuntimeDatabase = cachedRuntimeDatabase;

  /// Functions adapter for obtaining tokens and using Workers CRUD.
  ///
  /// トークン取得やWorkers CRUDに利用するFunctionsアダプター。
  FunctionsAdapter get functionsAdapter {
    return _functionsAdapter ?? FunctionsAdapter.primary;
  }

  final FunctionsAdapter? _functionsAdapter;

  /// 接続先・認証ユーザー単位のsession。
  final D1ModelSession session;

  Future<T> _execute<T>(D1DatabaseAction<T> action) =>
      session.execute(functionsAdapter, action, prefix: prefix);

  /// Prefix added to the physical database name.
  ///
  /// 物理データベース名に追加するプレフィックス。
  String? get prefix => _normalizeD1DatabasePrefix(_prefix);

  final String? _prefix;

  /// Prefix used to isolate runtime and persistent cache entries.
  ///
  /// ランタイムキャッシュと永続キャッシュのエントリーを分離するプレフィックス。
  @protected
  String? get cachePrefix =>
      "__d1_scope__/${base64Url.encode(utf8.encode(jsonEncode([
            session.cacheScope,
            prefix
          ])))}";

  /// Local cache database.
  ///
  /// ローカルキャッシュデータベース。
  NoSqlDatabase get cachedRuntimeDatabase {
    return _cachedRuntimeDatabase ?? sharedRuntimeDatabase;
  }

  final NoSqlDatabase? _cachedRuntimeDatabase;

  /// Shared local cache database.
  ///
  /// 共有ローカルキャッシュデータベース。
  static final NoSqlDatabase sharedRuntimeDatabase = NoSqlDatabase();

  @override
  final VectorConverter vectorConverter;

  @override
  bool get availableListen => false;

  @override
  Future<void> clearAll() {
    return cachedRuntimeDatabase.clearAll();
  }

  @override
  Future<void> clearCache() {
    return cachedRuntimeDatabase.clearAll();
  }

  /// Called before loading a document from D1.
  ///
  /// D1からドキュメントを読み込む前に呼び出されます。
  @protected
  Future<DynamicMap?> onPreloadDocument(
    ModelAdapterDocumentQuery query,
  ) =>
      Future.value();

  /// Called after loading a document from D1.
  ///
  /// D1からドキュメントを読み込んだ後に呼び出されます。
  @protected
  Future<void> onPostloadDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) =>
      Future.value();

  /// Called before loading a collection from D1.
  ///
  /// D1からコレクションを読み込む前に呼び出されます。
  @protected
  Future<CachedD1ModelCollectionLoaderResponse?> onPreloadCollection(
    ModelAdapterCollectionQuery query,
  ) =>
      Future.value();

  /// Called after loading a collection from D1.
  ///
  /// D1からコレクションを読み込んだ後に呼び出されます。
  @protected
  Future<void> onPostloadCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap> value,
  ) =>
      Future.value();

  /// Called after saving a document to D1.
  ///
  /// D1へドキュメントを保存した後に呼び出されます。
  @protected
  Future<void> onSaveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) =>
      Future.value();

  /// Called after deleting a document from D1.
  ///
  /// D1からドキュメントを削除した後に呼び出されます。
  @protected
  Future<void> onDeleteDocument(
    ModelAdapterDocumentQuery query,
  ) =>
      Future.value();

  Future<void> _syncCachedCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap> value,
  ) async {
    if (query.query.filters
        .any((f) => f.type == ModelQueryFilterType.nearest)) {
      // 近傍検索の順位と集合はサーバーが確定済み。文書だけをキャッシュする。
      for (final entry in value.entries) {
        await _syncCachedDocument(
            ModelAdapterDocumentQuery(query: query.query.create(entry.key)),
            entry.value);
      }
      return;
    }
    await cachedRuntimeDatabase.syncCollection(
      query,
      value,
      prefix: cachePrefix,
    );
    await onPostloadCollection(query, value);
  }

  Future<void> _syncCachedDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await cachedRuntimeDatabase.syncDocument(
      query,
      value,
      prefix: cachePrefix,
    );
    await onPostloadDocument(query, value);
  }

  Future<void> _saveCachedDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await cachedRuntimeDatabase.saveDocument(
      query,
      value,
      prefix: cachePrefix,
    );
    await onSaveDocument(query, value);
  }

  Future<void> _deleteCachedDocument(
    ModelAdapterDocumentQuery query,
  ) async {
    await cachedRuntimeDatabase.deleteDocument(query, prefix: cachePrefix);
    await onDeleteDocument(query);
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    final path = D1ModelPath.fromDocumentQuery(query);
    await _execute(D1DeleteModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      indexKey: path.indexKey,
    ));
    await _deleteCachedDocument(query);
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    if (ref is! D1ModelBatchRef) {
      throw Exception("[ref] is not [D1ModelBatchRef].");
    }
    ref._operations.add(_D1DeleteOperation(query));
  }

  @override
  void deleteOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    if (ref is! D1ModelTransactionRef) {
      throw Exception("[ref] is not [D1ModelTransactionRef].");
    }
    ref._operations.add(_D1DeleteOperation(query));
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    cachedRuntimeDatabase.removeCollectionListener(query, prefix: cachePrefix);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    cachedRuntimeDatabase.removeDocumentListener(query, prefix: cachePrefix);
  }

  @override
  Future<List<StreamSubscription<dynamic>>> listenCollection(
      ModelAdapterCollectionQuery query) {
    throw UnsupportedError("D1ModelAdapter does not support listen.");
  }

  @override
  Future<List<StreamSubscription<dynamic>>> listenDocument(
      ModelAdapterDocumentQuery query) {
    throw UnsupportedError("D1ModelAdapter does not support listen.");
  }

  @override
  Future<T?> loadAggregation<T>(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery<AsyncAggregateValue<dynamic>> aggregateQuery,
  ) async {
    if (aggregateQuery.type != ModelAggregateQueryType.count) {
      throw UnsupportedError("D1ModelAdapter supports only count aggregate.");
    }
    final path = D1ModelPath.fromCollectionQuery(query);
    final payload = D1QueryPayload.fromFilters(query.query.filters);
    final res = await _execute(D1GetModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      where: payload.where,
      count: true,
      nearest: await _nearestPayload(payload.nearest),
    ));
    final count = res.data;
    final converted = count is num ? count.toInt() : int.tryParse("$count");
    if (converted is! T) {
      return null;
    }
    return converted as T;
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
      ModelAdapterCollectionQuery query) async {
    // 検索候補は認可と現行世代の確認を必要とするため毎回Workerへ問い合わせる。
    final nearest =
        query.query.filters.any((f) => f.type == ModelQueryFilterType.nearest);
    final cache = nearest ? null : await onPreloadCollection(query);
    var data = cache?.value;
    if (data == null || cache?.query != null) {
      if (cache?.query != null) {
        query = cache!.query!;
      }
      final path = D1ModelPath.fromCollectionQuery(query);
      final payload = D1QueryPayload.fromFilters(query.query.filters);
      final remote = await _loadCollectionFunctions(path, payload);
      data = {
        ...?data,
        ...remote,
      };
      await _syncCachedCollection(query, data);
    } else {
      await cachedRuntimeDatabase.syncCollection(
        query,
        data,
        prefix: cachePrefix,
      );
    }
    return data;
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    if (query.reference && !query.reload) {
      final cached =
          await cachedRuntimeDatabase.loadDocument(query, prefix: cachePrefix);
      if (cached != null) {
        return cached;
      }
    }
    final cached = await onPreloadDocument(query);
    if (cached != null) {
      await cachedRuntimeDatabase.syncDocument(
        query,
        cached,
        prefix: cachePrefix,
      );
      return cached;
    }
    final path = D1ModelPath.fromDocumentQuery(query);
    final data = await _loadDocumentFunctions(path);
    await _syncCachedDocument(query, data);
    return data;
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    if (ref is! D1ModelTransactionRef) {
      throw Exception("[ref] is not [D1ModelTransactionRef].");
    }
    return loadDocument(query);
  }

  @override
  FutureOr<void> runBatch(
      FutureOr<void> Function(ModelBatchRef ref) batch, int splitLength) async {
    final ref = D1ModelBatchRef._();
    await batch.call(ref);
    await _runOperations(ref._operations, transaction: true);
  }

  @override
  FutureOr<void> runTransaction(
      FutureOr<void> Function(ModelTransactionRef ref) transaction) {
    throw UnsupportedError(
        "D1はcallback型transactionに未対応です。書き込みはrunBatchを使用してください。");
  }

  @override
  Future<void> saveDocument(
      ModelAdapterDocumentQuery query, DynamicMap value) async {
    final path = D1ModelPath.fromDocumentQuery(query);
    final row = _buildSaveRow(path, value);
    await _saveDocumentFunctions(path, row);
    await _saveCachedDocument(query, value);
  }

  @override
  void saveOnBatch(
      ModelBatchRef ref, ModelAdapterDocumentQuery query, DynamicMap value) {
    if (ref is! D1ModelBatchRef) {
      throw Exception("[ref] is not [D1ModelBatchRef].");
    }
    ref._operations.add(_D1SaveOperation(query, value));
  }

  @override
  void saveOnTransaction(ModelTransactionRef ref,
      ModelAdapterDocumentQuery query, DynamicMap value) {
    if (ref is! D1ModelTransactionRef) {
      throw Exception("[ref] is not [D1ModelTransactionRef].");
    }
    ref._operations.add(_D1SaveOperation(query, value));
  }

  Future<DynamicMap?> _nearestPayload(DynamicMap? nearest) async {
    if (nearest == null) {
      return null;
    }
    final value = nearest["value"];
    return {
      ...nearest,
      "value": value is String ? await vectorConverter.toVector(value) : value
    };
  }

  Future<Map<String, DynamicMap>> _loadCollectionFunctions(
    D1ModelPath path,
    D1QueryPayload payload,
  ) async {
    return await _retryD1Transient(() async {
      final res = await _execute(D1GetModelFunctionsAction(
        database: path.database,
        table: path.table,
        prefix: prefix,
        where: payload.where,
        orderBy: payload.orderBy,
        limit: payload.limit,
        nearest: await _nearestPayload(payload.nearest),
      ));
      return _rowsToMap(res.data, table: path.table);
    });
  }

  Future<DynamicMap> _loadDocumentFunctions(D1ModelPath path) async {
    return await _retryD1Transient(() async {
      final res = await _execute(D1GetModelFunctionsAction(
        database: path.database,
        table: path.table,
        prefix: prefix,
        indexKey: path.indexKey,
      ));
      final rows = _rowsToList(res.data, table: path.table);
      return rows.isEmpty ? <String, dynamic>{} : rows.first;
    });
  }

  @override
  Future<void> preloadReferences(
    Iterable<ModelAdapterDocumentQuery> queries,
  ) async {
    final grouped = <String, Map<String, Set<String>>>{};
    for (final query in queries) {
      final D1ModelPath path;
      try {
        path = D1ModelPath.fromDocumentQuery(query);
      } catch (_) {
        continue;
      }
      final indexKey = path.indexKey;
      if (indexKey == null || indexKey.isEmpty) {
        continue;
      }
      grouped
          .putIfAbsent(path.database, () => <String, Set<String>>{})
          .putIfAbsent(path.table, () => <String>{})
          .add(indexKey);
    }
    if (grouped.isEmpty) {
      return;
    }
    await _preloadReferencesFunctions(grouped);
  }

  Future<Map<String, Map<String, Map<String, DynamicMap>>>>
      _preloadReferencesFunctions(
    Map<String, Map<String, Set<String>>> grouped,
  ) async {
    final result = <String, Map<String, Map<String, DynamicMap>>>{};
    for (final databaseEntry in grouped.entries) {
      final database = databaseEntry.key;
      final databaseResult = <String, Map<String, DynamicMap>>{};
      for (final tableEntry in databaseEntry.value.entries) {
        final table = tableEntry.key;
        final ids = tableEntry.value.toList();
        if (ids.isEmpty) {
          continue;
        }
        final res = await _execute(D1GetModelFunctionsAction(
          database: database,
          table: table,
          prefix: prefix,
          where: [
            {
              "type": ModelQueryFilterType.whereIn.name,
              "key": "id",
              "value": ids,
            },
          ],
        ));
        databaseResult[table] = _rowsToMap(res.data, table: table);
      }
      result[database] = databaseResult;
      await _syncPreloadedReferences(database, databaseResult);
    }
    return result;
  }

  Future<void> _syncPreloadedReferences(
    String database,
    Map<String, Map<String, DynamicMap>> tables,
  ) async {
    for (final tableEntry in tables.entries) {
      final rows = tableEntry.value;
      if (rows.isEmpty) {
        continue;
      }
      await _syncCachedCollection(
        ModelAdapterCollectionQuery(
          query: CollectionModelQuery(
            "database/$database/${tableEntry.key}",
            adapter: this,
          ),
        ),
        rows,
      );
    }
  }

  Future<void> _saveDocumentFunctions(D1ModelPath path, DynamicMap row) async {
    await _execute(D1PostModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      value: row,
    ));
  }

  Future<void> _runOperations(
    List<_D1Operation> operations, {
    bool transaction = false,
  }) async {
    if (operations.isEmpty) {
      return;
    }
    await _runOperationsFunctions(operations);
  }

  Future<void> _runOperationsFunctions(List<_D1Operation> operations) async {
    if (operations.length > 100) {
      throw ArgumentError("D1 batchは100操作までです。");
    }
    final databases = operations.map((o) => o.path().database).toSet();
    if (databases.length != 1) {
      throw ArgumentError("D1 batchは同一DB内だけで実行できます。");
    }
    await _execute(D1BatchModelFunctionsAction(
        database: databases.single,
        prefix: prefix,
        operations: [
          for (final operation in operations)
            if (operation is _D1SaveOperation)
              {
                "method": "POST",
                "table": operation.path().table,
                "indexKey": operation.path().indexKey,
                "value": _buildSaveRow(operation.path(), operation.value)
              }
            else
              {
                "method": "DELETE",
                "table": operation.path().table,
                "indexKey": operation.path().indexKey
              }
        ]));
    for (final operation in operations) {
      if (operation is _D1SaveOperation) {
        await _saveCachedDocument(operation.query, operation.value);
      }
      if (operation is _D1DeleteOperation) {
        await _deleteCachedDocument(operation.query);
      }
    }
  }

  DynamicMap _buildSaveRow(D1ModelPath path, DynamicMap value) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final sanitizedValue = _sanitizeD1SaveValue(value);
    return {
      ...sanitizedValue.map((key, val) => MapEntry(key, _encodeD1Value(val))),
      "id": path.indexKey,
      "created_at": value["created_at"] ?? now,
      "updated_at": now,
    };
  }

  List<DynamicMap> _rowsToList(Object? data, {String? table}) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((row) => _decodeD1Row(
                Map<String, dynamic>.from(row),
              ))
          .toList();
    }
    if (data is Map) {
      return [
        _decodeD1Row(
          Map<String, dynamic>.from(data),
        )
      ];
    }
    return [];
  }

  Map<String, DynamicMap> _rowsToMap(Object? data, {String? table}) {
    return Map.fromEntries(_rowsToList(data, table: table).map((row) {
      return MapEntry(row.get("id", ""), row);
    }).where((entry) => entry.key.isNotEmpty));
  }

  /// 読み取りだけを一時エラー時に再試行する。結果不明の変更処理には使用しない。
  Future<T> _retryD1Transient<T>(Future<T> Function() callback) async {
    Object? lastError;
    StackTrace? lastStackTrace;
    const delays = _d1RetryDelays;
    for (var attempt = 0; attempt <= delays.length; attempt++) {
      try {
        return await callback();
      } catch (error, stackTrace) {
        lastError = error;
        lastStackTrace = stackTrace;
        if (!_isD1RetryableError(error) || attempt == delays.length) {
          rethrow;
        }
        final baseMs = delays[attempt].inMilliseconds;
        final jitteredMs = (baseMs ~/ 4) +
            (baseMs == 0
                ? 0
                : (baseMs * (DateTime.now().microsecondsSinceEpoch % 1000)) ~/
                    1000);
        await Future<void>.delayed(Duration(milliseconds: jitteredMs));
      }
    }
    Error.throwWithStackTrace(lastError!, lastStackTrace!);
  }

  bool _isD1RetryableError(Object error) {
    final message = error.toString();
    return RegExp(
      r"(?:Failed to post:?|status=?|status:\s*)\s*(429|500|502|503|504)",
    ).hasMatch(message);
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return runtimeType.hashCode ^
        functionsAdapter.hashCode ^
        session.hashCode ^
        vectorConverter.hashCode ^
        prefix.hashCode ^
        cachedRuntimeDatabase.hashCode;
  }
}

/// [ModelTransactionRef] for [D1ModelAdapter].
///
/// [D1ModelAdapter]用の[ModelTransactionRef]。
@immutable
class D1ModelTransactionRef extends ModelTransactionRef {
  D1ModelTransactionRef._();

  final List<_D1Operation> _operations = [];
}

/// [ModelBatchRef] for [D1ModelAdapter].
///
/// [D1ModelAdapter]用の[ModelBatchRef]。
@immutable
class D1ModelBatchRef extends ModelBatchRef {
  D1ModelBatchRef._();

  final List<_D1Operation> _operations = [];
}

abstract class _D1Operation {
  D1ModelPath path();

  Future<void> run(D1ModelAdapter adapter);

  Future<void> runFunctions(D1ModelAdapter adapter);
}

class _D1SaveOperation extends _D1Operation {
  _D1SaveOperation(this.query, this.value);

  final ModelAdapterDocumentQuery query;
  final DynamicMap value;

  @override
  D1ModelPath path() {
    return D1ModelPath.fromDocumentQuery(query);
  }

  @override
  Future<void> run(D1ModelAdapter adapter) {
    return adapter.saveDocument(query, value);
  }

  @override
  Future<void> runFunctions(D1ModelAdapter adapter) async {
    final path = this.path();
    await adapter._saveDocumentFunctions(
      path,
      adapter._buildSaveRow(path, value),
    );
    await adapter._saveCachedDocument(query, value);
  }
}

class _D1DeleteOperation extends _D1Operation {
  _D1DeleteOperation(this.query);

  final ModelAdapterDocumentQuery query;

  @override
  D1ModelPath path() {
    return D1ModelPath.fromDocumentQuery(query);
  }

  @override
  Future<void> run(D1ModelAdapter adapter) {
    return adapter.deleteDocument(query);
  }

  @override
  Future<void> runFunctions(D1ModelAdapter adapter) async {
    final path = this.path();
    await adapter._execute(D1DeleteModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: adapter.prefix,
      indexKey: path.indexKey,
    ));
    await adapter._deleteCachedDocument(query);
  }
}
