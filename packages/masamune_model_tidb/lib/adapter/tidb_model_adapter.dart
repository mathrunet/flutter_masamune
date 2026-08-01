part of "/masamune_model_tidb.dart";

/// A model adapter that enables the use of TiDB.
///
/// It accesses TiDB through Cloudflare Workers.
///
/// TiDBを利用できるようにしたモデルアダプター。
///
/// Cloudflare Workers経由でTiDBにアクセスします。
class TidbModelAdapter extends ModelAdapter {
  /// A model adapter that enables the use of TiDB.
  ///
  /// TiDBを利用できるようにしたモデルアダプター。
  const TidbModelAdapter({
    FunctionsAdapter? functionsAdapter,
    String? prefix,
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

  /// Prefix added to the physical database name.
  ///
  /// 物理データベース名に追加するプレフィックス。
  String? get prefix => _normalizeTidbDatabasePrefix(_prefix);

  final String? _prefix;

  /// Prefix used to isolate runtime and persistent cache entries.
  ///
  /// ランタイムキャッシュと永続キャッシュのエントリーを分離するプレフィックス。
  @protected
  String? get cachePrefix =>
      prefix == null ? null : "__database_prefix__/$prefix";

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
  VectorConverter get vectorConverter => const PassVectorConverter();

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

  /// Called before loading a document from TiDB.
  ///
  /// TiDBからドキュメントを読み込む前に呼び出されます。
  @protected
  Future<DynamicMap?> onPreloadDocument(
    ModelAdapterDocumentQuery query,
  ) =>
      Future.value();

  /// Called after loading a document from TiDB.
  ///
  /// TiDBからドキュメントを読み込んだ後に呼び出されます。
  @protected
  Future<void> onPostloadDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) =>
      Future.value();

  /// Called before loading a collection from TiDB.
  ///
  /// TiDBからコレクションを読み込む前に呼び出されます。
  @protected
  Future<CachedTidbModelCollectionLoaderResponse?> onPreloadCollection(
    ModelAdapterCollectionQuery query,
  ) =>
      Future.value();

  /// Called after loading a collection from TiDB.
  ///
  /// TiDBからコレクションを読み込んだ後に呼び出されます。
  @protected
  Future<void> onPostloadCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap> value,
  ) =>
      Future.value();

  /// Called after saving a document to TiDB.
  ///
  /// TiDBへドキュメントを保存した後に呼び出されます。
  @protected
  Future<void> onSaveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) =>
      Future.value();

  /// Called after deleting a document from TiDB.
  ///
  /// TiDBからドキュメントを削除した後に呼び出されます。
  @protected
  Future<void> onDeleteDocument(
    ModelAdapterDocumentQuery query,
  ) =>
      Future.value();

  Future<void> _syncCachedCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap> value,
  ) async {
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
    final path = TidbModelPath.fromDocumentQuery(query);
    await functionsAdapter.execute(TidbDeleteModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      indexKey: path.indexKey,
    ));
    await _deleteCachedDocument(query);
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    if (ref is! TidbModelBatchRef) {
      throw Exception("[ref] is not [TidbModelBatchRef].");
    }
    ref._operations.add(_TidbDeleteOperation(query));
  }

  @override
  void deleteOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    if (ref is! TidbModelTransactionRef) {
      throw Exception("[ref] is not [TidbModelTransactionRef].");
    }
    ref._operations.add(_TidbDeleteOperation(query));
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
    throw UnsupportedError("TidbModelAdapter does not support listen.");
  }

  @override
  Future<List<StreamSubscription<dynamic>>> listenDocument(
      ModelAdapterDocumentQuery query) {
    throw UnsupportedError("TidbModelAdapter does not support listen.");
  }

  @override
  Future<T?> loadAggregation<T>(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery<AsyncAggregateValue<dynamic>> aggregateQuery,
  ) async {
    if (aggregateQuery.type != ModelAggregateQueryType.count) {
      throw UnsupportedError("TidbModelAdapter supports only count aggregate.");
    }
    final path = TidbModelPath.fromCollectionQuery(query);
    final payload = TidbQueryPayload.fromFilters(query.query.filters);
    final res = await functionsAdapter.execute(TidbGetModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      where: payload.where,
      count: true,
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
    final cache = await onPreloadCollection(query);
    var data = cache?.value;
    if (data == null || cache?.query != null) {
      if (cache?.query != null) {
        query = cache!.query!;
      }
      final path = TidbModelPath.fromCollectionQuery(query);
      final payload = TidbQueryPayload.fromFilters(query.query.filters);
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
    final path = TidbModelPath.fromDocumentQuery(query);
    final data = await _loadDocumentFunctions(path);
    await _syncCachedDocument(query, data);
    return data;
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    if (ref is! TidbModelTransactionRef) {
      throw Exception("[ref] is not [TidbModelTransactionRef].");
    }
    return loadDocument(query);
  }

  @override
  FutureOr<void> runBatch(
      FutureOr<void> Function(ModelBatchRef ref) batch, int splitLength) async {
    final ref = TidbModelBatchRef._();
    await batch.call(ref);
    await _runOperations(ref._operations, transaction: true);
  }

  @override
  FutureOr<void> runTransaction(
      FutureOr<void> Function(ModelTransactionRef ref) transaction) async {
    final ref = TidbModelTransactionRef._();
    await transaction.call(ref);
    await _runOperations(ref._operations, transaction: true);
  }

  @override
  Future<void> saveDocument(
      ModelAdapterDocumentQuery query, DynamicMap value) async {
    final path = TidbModelPath.fromDocumentQuery(query);
    final row = _buildSaveRow(path, value);
    await _saveDocumentFunctions(path, row);
    await _saveCachedDocument(query, value);
  }

  @override
  void saveOnBatch(
      ModelBatchRef ref, ModelAdapterDocumentQuery query, DynamicMap value) {
    if (ref is! TidbModelBatchRef) {
      throw Exception("[ref] is not [TidbModelBatchRef].");
    }
    ref._operations.add(_TidbSaveOperation(query, value));
  }

  @override
  void saveOnTransaction(ModelTransactionRef ref,
      ModelAdapterDocumentQuery query, DynamicMap value) {
    if (ref is! TidbModelTransactionRef) {
      throw Exception("[ref] is not [TidbModelTransactionRef].");
    }
    ref._operations.add(_TidbSaveOperation(query, value));
  }

  Future<Map<String, DynamicMap>> _loadCollectionFunctions(
    TidbModelPath path,
    TidbQueryPayload payload,
  ) async {
    final res = await functionsAdapter.execute(TidbGetModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      where: payload.where,
      orderBy: payload.orderBy,
      limit: payload.limit,
    ));
    return _rowsToMap(res.data, table: path.table);
  }

  Future<DynamicMap> _loadDocumentFunctions(TidbModelPath path) async {
    final res = await functionsAdapter.execute(TidbGetModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      indexKey: path.indexKey,
    ));
    final rows = _rowsToList(res.data, table: path.table);
    return rows.isEmpty ? <String, dynamic>{} : rows.first;
  }

  @override
  Future<void> preloadReferences(
    Iterable<ModelAdapterDocumentQuery> queries,
  ) async {
    final grouped = <String, Map<String, Set<String>>>{};
    for (final query in queries) {
      final TidbModelPath path;
      try {
        path = TidbModelPath.fromDocumentQuery(query);
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
        final res = await functionsAdapter.execute(TidbGetModelFunctionsAction(
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

  Future<void> _saveDocumentFunctions(
      TidbModelPath path, DynamicMap row) async {
    await functionsAdapter.execute(TidbPostModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      value: row,
    ));
  }

  Future<void> _runOperations(
    List<_TidbOperation> operations, {
    bool transaction = false,
  }) async {
    if (operations.isEmpty) {
      return;
    }
    await _runOperationsFunctions(operations);
  }

  Future<void> _runOperationsFunctions(List<_TidbOperation> operations) async {
    for (final operation in operations) {
      await operation.runFunctions(this);
    }
  }

  DynamicMap _buildSaveRow(TidbModelPath path, DynamicMap value) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final sanitizedValue = _sanitizeTidbSaveValue(value);
    return {
      ...sanitizedValue.map((key, val) => MapEntry(key, _encodeTidbValue(val))),
      "id": path.indexKey,
      "created_at": value["created_at"] ?? now,
      "updated_at": now,
    };
  }

  List<DynamicMap> _rowsToList(Object? data, {String? table}) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((row) => _decodeTidbRow(
                Map<String, dynamic>.from(row),
              ))
          .toList();
    }
    if (data is Map) {
      return [
        _decodeTidbRow(
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

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return runtimeType.hashCode ^
        functionsAdapter.hashCode ^
        prefix.hashCode ^
        cachedRuntimeDatabase.hashCode;
  }
}

/// [ModelTransactionRef] for [TidbModelAdapter].
///
/// [TidbModelAdapter]用の[ModelTransactionRef]。
@immutable
class TidbModelTransactionRef extends ModelTransactionRef {
  TidbModelTransactionRef._();

  final List<_TidbOperation> _operations = [];
}

/// [ModelBatchRef] for [TidbModelAdapter].
///
/// [TidbModelAdapter]用の[ModelBatchRef]。
@immutable
class TidbModelBatchRef extends ModelBatchRef {
  TidbModelBatchRef._();

  final List<_TidbOperation> _operations = [];
}

abstract class _TidbOperation {
  TidbModelPath path();

  Future<void> run(TidbModelAdapter adapter);

  Future<void> runFunctions(TidbModelAdapter adapter);
}

class _TidbSaveOperation extends _TidbOperation {
  _TidbSaveOperation(this.query, this.value);

  final ModelAdapterDocumentQuery query;
  final DynamicMap value;

  @override
  TidbModelPath path() {
    return TidbModelPath.fromDocumentQuery(query);
  }

  @override
  Future<void> run(TidbModelAdapter adapter) {
    return adapter.saveDocument(query, value);
  }

  @override
  Future<void> runFunctions(TidbModelAdapter adapter) async {
    final path = this.path();
    await adapter._saveDocumentFunctions(
      path,
      adapter._buildSaveRow(path, value),
    );
    await adapter._saveCachedDocument(query, value);
  }
}

class _TidbDeleteOperation extends _TidbOperation {
  _TidbDeleteOperation(this.query);

  final ModelAdapterDocumentQuery query;

  @override
  TidbModelPath path() {
    return TidbModelPath.fromDocumentQuery(query);
  }

  @override
  Future<void> run(TidbModelAdapter adapter) {
    return adapter.deleteDocument(query);
  }

  @override
  Future<void> runFunctions(TidbModelAdapter adapter) async {
    final path = this.path();
    await adapter.functionsAdapter.execute(TidbDeleteModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: adapter.prefix,
      indexKey: path.indexKey,
    ));
    await adapter._deleteCachedDocument(query);
  }
}
