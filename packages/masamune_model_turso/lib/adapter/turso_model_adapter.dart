part of "/masamune_model_turso.dart";

const _fallbackTokenResponse = TursoTokenFunctionsActionResponse(
  token: "",
  expiresAt: 0,
  readMode: "functions",
  writeMode: "functions",
);

const _tursoRetryDelays = [
  Duration(milliseconds: 250),
  Duration(milliseconds: 500),
  Duration(seconds: 1),
  Duration(seconds: 2),
  Duration(seconds: 4),
  Duration(seconds: 8),
];

const _tursoSchemaTable = "__masamune_turso_schema";

final Map<String, Set<String>> _tursoBoolFieldsCache = {};

/// A model adapter that enables the use of Turso.
///
/// It can access Turso through Cloudflare Workers, or directly through a
/// scoped short-lived token issued by the Workers endpoint.
///
/// Tursoを利用できるようにしたモデルアダプター。
///
/// Cloudflare Workers経由、またはWorkersで発行したスコープ付き短命トークンを
/// 使った直接接続でTursoにアクセスします。
class TursoModelAdapter extends ModelAdapter {
  /// A model adapter that enables the use of Turso.
  ///
  /// Tursoを利用できるようにしたモデルアダプター。
  const TursoModelAdapter({
    this.useDirectClient = true,
    FunctionsAdapter? functionsAdapter,
    String? prefix,
    this.tokenTtlSeconds = 3600,
    this.retryDelays = _tursoRetryDelays,
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
  String? get prefix => _normalizeTursoDatabasePrefix(_prefix);

  final String? _prefix;

  /// Prefix used to isolate runtime and persistent cache entries.
  ///
  /// ランタイムキャッシュと永続キャッシュのエントリーを分離するプレフィックス。
  @protected
  String? get cachePrefix =>
      prefix == null ? null : "__database_prefix__/$prefix";

  /// Whether to use direct client access.
  ///
  /// 直接接続を利用するかどうか。
  final bool useDirectClient;

  /// Token TTL in seconds.
  ///
  /// トークンの有効秒数。
  final int tokenTtlSeconds;

  /// Retry delays for transient Turso direct connection errors.
  ///
  /// Turso直接接続の一時的なエラーに対するリトライ間隔。
  final List<Duration> retryDelays;

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

  bool get _directEnabled => useDirectClient;

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

  /// Called before loading a document from Turso.
  ///
  /// Tursoからドキュメントを読み込む前に呼び出されます。
  @protected
  Future<DynamicMap?> onPreloadDocument(
    ModelAdapterDocumentQuery query,
  ) =>
      Future.value();

  /// Called after loading a document from Turso.
  ///
  /// Tursoからドキュメントを読み込んだ後に呼び出されます。
  @protected
  Future<void> onPostloadDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) =>
      Future.value();

  /// Called before loading a collection from Turso.
  ///
  /// Tursoからコレクションを読み込む前に呼び出されます。
  @protected
  Future<CachedTursoModelCollectionLoaderResponse?> onPreloadCollection(
    ModelAdapterCollectionQuery query,
  ) =>
      Future.value();

  /// Called after loading a collection from Turso.
  ///
  /// Tursoからコレクションを読み込んだ後に呼び出されます。
  @protected
  Future<void> onPostloadCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap> value,
  ) =>
      Future.value();

  /// Called after saving a document to Turso.
  ///
  /// Tursoへドキュメントを保存した後に呼び出されます。
  @protected
  Future<void> onSaveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) =>
      Future.value();

  /// Called after deleting a document from Turso.
  ///
  /// Tursoからドキュメントを削除した後に呼び出されます。
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
    final path = TursoModelPath.fromDocumentQuery(query);
    if (_directEnabled) {
      await _withDirectClient(
        database: path.database,
        scopes: [
          TursoTokenScope(table: path.table, operations: const ["write"]),
        ],
        functionsFallback: (_) async {
          await functionsAdapter.execute(TursoDeleteModelFunctionsAction(
            database: path.database,
            table: path.table,
            prefix: prefix,
            indexKey: path.indexKey,
          ));
        },
        callback: (client) async {
          await client.execute(
            "DELETE FROM ${_quoteTursoIdentifier(path.table)} "
            "WHERE ${_quoteTursoIdentifier("id")} = ?",
            positional: [path.indexKey],
          );
        },
      );
    } else {
      await functionsAdapter.execute(TursoDeleteModelFunctionsAction(
        database: path.database,
        table: path.table,
        prefix: prefix,
        indexKey: path.indexKey,
      ));
    }
    await _deleteCachedDocument(query);
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    if (ref is! TursoModelBatchRef) {
      throw Exception("[ref] is not [TursoModelBatchRef].");
    }
    ref._operations.add(_TursoDeleteOperation(query));
  }

  @override
  void deleteOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    if (ref is! TursoModelTransactionRef) {
      throw Exception("[ref] is not [TursoModelTransactionRef].");
    }
    ref._operations.add(_TursoDeleteOperation(query));
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
    throw UnsupportedError("TursoModelAdapter does not support listen.");
  }

  @override
  Future<List<StreamSubscription<dynamic>>> listenDocument(
      ModelAdapterDocumentQuery query) {
    throw UnsupportedError("TursoModelAdapter does not support listen.");
  }

  @override
  Future<T?> loadAggregation<T>(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery<AsyncAggregateValue<dynamic>> aggregateQuery,
  ) async {
    if (aggregateQuery.type != ModelAggregateQueryType.count) {
      throw UnsupportedError(
          "TursoModelAdapter supports only count aggregate.");
    }
    final path = TursoModelPath.fromCollectionQuery(query);
    final payload = TursoQueryPayload.fromFilters(query.query.filters);
    Object? count;
    if (_directEnabled) {
      count = await _withDirectClient(
        database: path.database,
        scopes: [
          TursoTokenScope(table: path.table, operations: const ["read"]),
        ],
        functionsFallback: (_) async {
          final res =
              await functionsAdapter.execute(TursoGetModelFunctionsAction(
            database: path.database,
            table: path.table,
            prefix: prefix,
            where: payload.where,
            count: true,
          ));
          return res.data;
        },
        callback: (client) async {
          final where = _buildTursoWhereSql(where: payload.where);
          final List<Map<String, dynamic>> rows;
          try {
            rows = await client.query(
              "SELECT COUNT(*) AS count FROM ${_quoteTursoIdentifier(path.table)}${where.sql}",
              positional: where.args,
            );
          } catch (error) {
            if (_isTursoMissingTableError(error)) {
              return 0;
            }
            rethrow;
          }
          return rows.firstOrNull?["count"] ?? 0;
        },
      );
    } else {
      final res = await functionsAdapter.execute(TursoGetModelFunctionsAction(
        database: path.database,
        table: path.table,
        prefix: prefix,
        where: payload.where,
        count: true,
      ));
      count = res.data;
    }
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
      final path = TursoModelPath.fromCollectionQuery(query);
      final payload = TursoQueryPayload.fromFilters(query.query.filters);
      final remote = _directEnabled
          ? await _loadCollectionDirect(path, payload)
          : await _loadCollectionFunctions(path, payload);
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
    final path = TursoModelPath.fromDocumentQuery(query);
    final data = _directEnabled
        ? await _loadDocumentDirect(path)
        : await _loadDocumentFunctions(path);
    await _syncCachedDocument(query, data);
    return data;
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    if (ref is! TursoModelTransactionRef) {
      throw Exception("[ref] is not [TursoModelTransactionRef].");
    }
    return loadDocument(query);
  }

  @override
  FutureOr<void> runBatch(
      FutureOr<void> Function(ModelBatchRef ref) batch, int splitLength) async {
    final ref = TursoModelBatchRef._();
    await batch.call(ref);
    await _runOperations(ref._operations, transaction: true);
  }

  @override
  FutureOr<void> runTransaction(
      FutureOr<void> Function(ModelTransactionRef ref) transaction) async {
    final ref = TursoModelTransactionRef._();
    await transaction.call(ref);
    await _runOperations(ref._operations, transaction: true);
  }

  @override
  Future<void> saveDocument(
      ModelAdapterDocumentQuery query, DynamicMap value) async {
    final path = TursoModelPath.fromDocumentQuery(query);
    final row = _buildSaveRow(path, value);
    final boolFields = _extractTursoBoolFields(value);
    _cacheTursoBoolFields(path.database, path.table, boolFields);
    if (_directEnabled) {
      await _saveDocumentDirect(path, row, boolFields);
    } else {
      await _saveDocumentFunctions(path, row);
    }
    await _saveCachedDocument(query, value);
  }

  @override
  void saveOnBatch(
      ModelBatchRef ref, ModelAdapterDocumentQuery query, DynamicMap value) {
    if (ref is! TursoModelBatchRef) {
      throw Exception("[ref] is not [TursoModelBatchRef].");
    }
    ref._operations.add(_TursoSaveOperation(query, value));
  }

  @override
  void saveOnTransaction(ModelTransactionRef ref,
      ModelAdapterDocumentQuery query, DynamicMap value) {
    if (ref is! TursoModelTransactionRef) {
      throw Exception("[ref] is not [TursoModelTransactionRef].");
    }
    ref._operations.add(_TursoSaveOperation(query, value));
  }

  Future<Map<String, DynamicMap>> _loadCollectionDirect(
    TursoModelPath path,
    TursoQueryPayload payload,
  ) async {
    return await _withDirectClient(
      database: path.database,
      scopes: [
        TursoTokenScope(table: path.table, operations: const ["read"]),
        const TursoTokenScope(table: _tursoSchemaTable, operations: ["read"]),
      ],
      functionsFallback: (_) => _loadCollectionFunctions(path, payload),
      callback: (client) async {
        final where = _buildTursoWhereSql(where: payload.where);
        final boolFields =
            await _loadTursoBoolFields(client, path.database, path.table);
        final List<Map<String, dynamic>> rows;
        try {
          rows = await client.query(
            "SELECT * FROM ${_quoteTursoIdentifier(path.table)}"
            "${where.sql}${_buildTursoOrderSql(payload.orderBy)}"
            "${_buildTursoLimitSql(payload.limit)}",
            positional: where.args,
          );
        } catch (error) {
          if (_isTursoMissingTableError(error)) {
            return <String, DynamicMap>{};
          }
          rethrow;
        }
        return Map.fromEntries(rows.map((row) {
          final decoded = _decodeTursoRow(row, boolFields: boolFields);
          return MapEntry(decoded.get("id", ""), decoded);
        }).where((entry) => entry.key.isNotEmpty));
      },
    );
  }

  Future<Map<String, DynamicMap>> _loadCollectionFunctions(
    TursoModelPath path,
    TursoQueryPayload payload,
  ) async {
    final res = await functionsAdapter.execute(TursoGetModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      where: payload.where,
      orderBy: payload.orderBy,
      limit: payload.limit,
    ));
    return _rowsToMap(
      res.data,
      database: path.database,
      table: path.table,
    );
  }

  Future<DynamicMap> _loadDocumentDirect(TursoModelPath path) async {
    return await _withDirectClient(
      database: path.database,
      scopes: [
        TursoTokenScope(table: path.table, operations: const ["read"]),
        const TursoTokenScope(table: _tursoSchemaTable, operations: ["read"]),
      ],
      functionsFallback: (_) => _loadDocumentFunctions(path),
      callback: (client) async {
        final boolFields =
            await _loadTursoBoolFields(client, path.database, path.table);
        final List<Map<String, dynamic>> rows;
        try {
          rows = await client.query(
            "SELECT * FROM ${_quoteTursoIdentifier(path.table)} "
            "WHERE ${_quoteTursoIdentifier("id")} = ? LIMIT 1",
            positional: [path.indexKey],
          );
        } catch (error) {
          if (_isTursoMissingTableError(error)) {
            return <String, dynamic>{};
          }
          rethrow;
        }
        return rows.isEmpty
            ? <String, dynamic>{}
            : _decodeTursoRow(rows.first, boolFields: boolFields);
      },
    );
  }

  Future<DynamicMap> _loadDocumentFunctions(TursoModelPath path) async {
    final res = await functionsAdapter.execute(TursoGetModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      indexKey: path.indexKey,
    ));
    final rows = _rowsToList(
      res.data,
      database: path.database,
      table: path.table,
    );
    return rows.isEmpty ? <String, dynamic>{} : rows.first;
  }

  @override
  Future<void> preloadReferences(
    Iterable<ModelAdapterDocumentQuery> queries,
  ) async {
    final grouped = <String, Map<String, Set<String>>>{};
    for (final query in queries) {
      final TursoModelPath path;
      try {
        path = TursoModelPath.fromDocumentQuery(query);
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
    if (_directEnabled) {
      await _preloadReferencesDirect(grouped);
    } else {
      await _preloadReferencesFunctions(grouped);
    }
  }

  Future<Map<String, Map<String, Map<String, DynamicMap>>>>
      _preloadReferencesDirect(
    Map<String, Map<String, Set<String>>> grouped,
  ) async {
    final result = <String, Map<String, Map<String, DynamicMap>>>{};
    for (final databaseEntry in grouped.entries) {
      final database = databaseEntry.key;
      final tables = databaseEntry.value;
      final loaded = await _withDirectClient(
        database: database,
        scopes: [
          ...tables.keys.map((table) => TursoTokenScope(
                table: table,
                operations: const ["read"],
              )),
          const TursoTokenScope(
            table: _tursoSchemaTable,
            operations: ["read"],
          ),
        ],
        functionsFallback: (_) => _preloadReferencesFunctions({
          database: tables,
        }),
        callback: (client) async {
          final databaseResult = <String, Map<String, DynamicMap>>{};
          for (final tableEntry in tables.entries) {
            final table = tableEntry.key;
            final ids = tableEntry.value.toList();
            if (ids.isEmpty) {
              continue;
            }
            try {
              final boolFields =
                  await _loadTursoBoolFields(client, database, table);
              final rows = await client.query(
                "SELECT * FROM ${_quoteTursoIdentifier(table)} "
                "WHERE ${_quoteTursoIdentifier("id")} IN (${ids.map((_) => "?").join(", ")})",
                positional: ids,
              );
              databaseResult[table] = Map.fromEntries(rows.map((row) {
                final decoded = _decodeTursoRow(row, boolFields: boolFields);
                return MapEntry(decoded.get("id", ""), decoded);
              }).where((entry) => entry.key.isNotEmpty));
            } catch (error) {
              if (_isTursoMissingTableError(error)) {
                databaseResult[table] = <String, DynamicMap>{};
                continue;
              }
              rethrow;
            }
          }
          return {database: databaseResult};
        },
      );
      result.addAll(loaded);
      await _syncPreloadedReferences(database, loaded[database] ?? {});
    }
    return result;
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
        final res = await functionsAdapter.execute(TursoGetModelFunctionsAction(
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
        databaseResult[table] = _rowsToMap(
          res.data,
          database: database,
          table: table,
        );
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

  Future<void> _saveDocumentDirect(
    TursoModelPath path,
    DynamicMap row,
    Set<String> boolFields,
  ) async {
    await _withDirectClient(
      database: path.database,
      scopes: [
        TursoTokenScope(table: path.table, operations: const ["write"]),
        const TursoTokenScope(table: _tursoSchemaTable, operations: ["write"]),
      ],
      functionsFallback: (_) => _saveDocumentFunctions(path, row),
      callback: (client) async {
        await _ensureSchema(client, path.table, row, boolFields);
        final insert = _buildTursoInsertSql(path.table, row);
        await client.execute(insert.sql, positional: insert.args);
      },
    );
  }

  Future<void> _saveDocumentFunctions(
      TursoModelPath path, DynamicMap row) async {
    await functionsAdapter.execute(TursoPostModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      value: row,
    ));
  }

  Future<void> _runOperations(
    List<_TursoOperation> operations, {
    bool transaction = false,
  }) async {
    if (operations.isEmpty) {
      return;
    }
    if (!_directEnabled) {
      for (final operation in operations) {
        await operation.run(this);
      }
      return;
    }
    final operationDatabases =
        operations.map((operation) => operation.path().database).toSet();
    if (operationDatabases.length > 1) {
      throw UnsupportedError(
          "TursoModelAdapter does not support direct batch operations across multiple databases.");
    }
    final operationDatabase = operationDatabases.single;
    final scopes = operations
        .map((operation) => TursoTokenScope(
              table: operation.path().table,
              operations: const ["write"],
            ))
        .toList()
      ..add(const TursoTokenScope(
          table: _tursoSchemaTable, operations: ["write"]));
    await _withDirectClient(
      database: operationDatabase,
      scopes: scopes,
      functionsFallback: (_) => _runOperationsFunctions(operations),
      callback: (client) async {
        for (final operation in operations.whereType<_TursoSaveOperation>()) {
          final path = operation.path();
          final boolFields = _extractTursoBoolFields(operation.value);
          _cacheTursoBoolFields(path.database, path.table, boolFields);
          await _ensureSchema(
            client,
            path.table,
            _buildSaveRow(path, operation.value),
            boolFields,
          );
        }
        if (transaction) {
          final dynamic tx = await client.transaction();
          try {
            for (final operation in operations) {
              await operation.runDirectTransaction(this, tx);
            }
            await tx.commit();
          } catch (_) {
            await tx.rollback();
            rethrow;
          }
          for (final operation in operations) {
            await operation.syncCache(this);
          }
        } else {
          for (final operation in operations) {
            await operation.runDirect(this, client);
          }
        }
      },
    );
  }

  Future<void> _runOperationsFunctions(List<_TursoOperation> operations) async {
    for (final operation in operations) {
      await operation.runFunctions(this);
    }
  }

  Future<T> _withDirectClient<T>({
    required String database,
    required List<TursoTokenScope> scopes,
    required Future<T> Function(LibsqlClient client) callback,
    Future<T> Function(TursoTokenFunctionsActionResponse token)?
        functionsFallback,
  }) async {
    final TursoTokenFunctionsActionResponse token;
    try {
      token = await _retryTursoTransient(() {
        return functionsAdapter.execute(TursoTokenFunctionsAction(
          database: database,
          prefix: prefix,
          targets: _mergeScopes(scopes),
          ttlSeconds: tokenTtlSeconds,
        ));
      });
    } catch (error) {
      if (functionsFallback != null && _isTursoDirectFallbackError(error)) {
        return await _retryTursoTransient(
          () => functionsFallback(_fallbackTokenResponse),
        );
      }
      rethrow;
    }
    if (_requiresRead(scopes) && token.readMode != "direct") {
      if (token.readMode == "functions" && functionsFallback != null) {
        return await functionsFallback(token);
      }
      throw StateError(
          "Direct Turso read is not allowed. readMode=${token.readMode}");
    }
    if (_requiresWrite(scopes) && token.writeMode != "direct") {
      if (token.writeMode == "functions" && functionsFallback != null) {
        return await functionsFallback(token);
      }
      throw StateError(
          "Direct Turso write is not allowed. writeMode=${token.writeMode}");
    }
    final url = token.url;
    if (url.isEmpty) {
      throw StateError(
          "Token response url is required for direct Turso access.");
    }
    try {
      return await _retryTursoTransient(() async {
        final client = LibsqlClient.remote(url, authToken: token.token);
        await client.connect();
        try {
          return await callback(client);
        } finally {
          await client.dispose();
        }
      });
    } catch (error) {
      if (functionsFallback != null && _isTursoDirectFallbackError(error)) {
        return await _retryTursoTransient(
          () => functionsFallback(token),
        );
      }
      rethrow;
    }
  }

  Future<T> _retryTursoTransient<T>(Future<T> Function() callback) async {
    Object? lastError;
    StackTrace? lastStackTrace;
    for (var attempt = 0; attempt <= retryDelays.length; attempt++) {
      try {
        return await callback();
      } catch (error, stackTrace) {
        lastError = error;
        lastStackTrace = stackTrace;
        if (!_isTursoDirectFallbackError(error) ||
            attempt == retryDelays.length) {
          rethrow;
        }
        await Future<void>.delayed(retryDelays[attempt]);
      }
    }
    Error.throwWithStackTrace(lastError!, lastStackTrace!);
  }

  bool _requiresWrite(List<TursoTokenScope> scopes) {
    const writeOperations = {"write", "create", "update", "delete"};
    return scopes.any((scope) => scope.operations
        .any((operation) => writeOperations.contains(operation)));
  }

  bool _requiresRead(List<TursoTokenScope> scopes) {
    return scopes.any((scope) => scope.operations
        .any((operation) => operation == "read" || operation == "get"));
  }

  bool _isTursoDirectFallbackError(Object error) {
    if (_isTursoMissingTableError(error)) {
      return false;
    }
    final message = error.toString();
    return RegExp(r"(?:Failed to post:?|status=?|status: )\s*(500|502|503|504)")
            .hasMatch(message) ||
        message.contains("no route configured for host") ||
        message.contains("Bad Gateway") ||
        message.contains("Service Unavailable") ||
        message.contains("Gateway Timeout");
  }

  bool _isTursoMissingTableError(Object error) {
    final message = error.toString();
    return message.contains("no such table") ||
        message.contains("SQLITE_UNKNOWN");
  }

  List<TursoTokenScope> _mergeScopes(List<TursoTokenScope> scopes) {
    final map = <String, Set<String>>{};
    for (final scope in scopes) {
      final operations = map[scope.table] ?? <String>{};
      operations.addAll(scope.operations);
      map[scope.table] = operations;
    }
    return map.entries
        .map((entry) => TursoTokenScope(
              table: entry.key,
              operations: entry.value.toList(),
            ))
        .toList();
  }

  DynamicMap _buildSaveRow(TursoModelPath path, DynamicMap value) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final sanitizedValue = _sanitizeTursoSaveValue(value);
    return {
      ...sanitizedValue
          .map((key, val) => MapEntry(key, _encodeTursoValue(val))),
      "id": path.indexKey,
      "created_at": value["created_at"] ?? now,
      "updated_at": now,
    };
  }

  Future<void> _ensureSchema(
    LibsqlClient client,
    String table,
    DynamicMap row,
    Set<String> boolFields,
  ) async {
    final create = _buildTursoCreateTableSql(table, row);
    await client.execute(create.sql);
    await _ensureTursoSchemaTable(client);
    await _saveTursoBoolFields(client, table, boolFields);
    final current = await client
        .query("PRAGMA table_info(${_quoteTursoIdentifier(table)})");
    final columns = current.map((row) => row.get("name", "")).toSet();
    for (final entry in row.entries) {
      if (columns.contains(entry.key)) {
        continue;
      }
      await client.execute(
        "ALTER TABLE ${_quoteTursoIdentifier(table)} "
        "ADD COLUMN ${_quoteTursoIdentifier(entry.key)} ${_inferTursoSqlType(entry.value)}",
      );
    }
  }

  List<DynamicMap> _rowsToList(
    Object? data, {
    String? database,
    String? table,
  }) {
    final boolFields = database == null || table == null
        ? const <String>{}
        : _tursoBoolFieldsCache[_boolFieldsCacheKey(database, table)] ??
            const <String>{};
    if (data is List) {
      return data
          .whereType<Map>()
          .map((row) => _decodeTursoRow(
                Map<String, dynamic>.from(row),
                boolFields: boolFields,
              ))
          .toList();
    }
    if (data is Map) {
      return [
        _decodeTursoRow(
          Map<String, dynamic>.from(data),
          boolFields: boolFields,
        )
      ];
    }
    return [];
  }

  Future<void> _ensureTursoSchemaTable(LibsqlClient client) async {
    await client.execute(
      "CREATE TABLE IF NOT EXISTS ${_quoteTursoIdentifier(_tursoSchemaTable)} ( "
      "id TEXT PRIMARY KEY, "
      "table_name TEXT, "
      "column_name TEXT, "
      "value_type TEXT, "
      "updated_at INTEGER"
      " )",
    );
  }

  Future<void> _saveTursoBoolFields(
    LibsqlClient client,
    String table,
    Set<String> boolFields,
  ) async {
    if (boolFields.isEmpty) {
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final field in boolFields) {
      await client.execute(
        "INSERT OR REPLACE INTO ${_quoteTursoIdentifier(_tursoSchemaTable)} "
        "(id, table_name, column_name, value_type, updated_at) "
        "VALUES (?, ?, ?, ?, ?)",
        positional: ["$table:$field", table, field, "bool", now],
      );
    }
  }

  Future<Set<String>> _loadTursoBoolFields(
    LibsqlClient client,
    String database,
    String table,
  ) async {
    try {
      final rows = await client.query(
        "SELECT column_name FROM ${_quoteTursoIdentifier(_tursoSchemaTable)} "
        "WHERE table_name = ? AND value_type = ?",
        positional: [table, "bool"],
      );
      final fields = rows
          .map((row) => row.get("column_name", ""))
          .where((field) => field.isNotEmpty)
          .toSet();
      _cacheTursoBoolFields(database, table, fields);
      return fields;
    } catch (_) {
      return _tursoBoolFieldsCache[_boolFieldsCacheKey(database, table)] ??
          const {};
    }
  }

  void _cacheTursoBoolFields(
    String database,
    String table,
    Set<String> fields,
  ) {
    if (fields.isEmpty) {
      return;
    }
    final key = _boolFieldsCacheKey(database, table);
    _tursoBoolFieldsCache[key] = {
      ...?_tursoBoolFieldsCache[key],
      ...fields,
    };
  }

  String _boolFieldsCacheKey(String database, String table) {
    return "${prefix ?? ""}\u0000$database\u0000$table";
  }

  Map<String, DynamicMap> _rowsToMap(
    Object? data, {
    String? database,
    String? table,
  }) {
    return Map.fromEntries(_rowsToList(
      data,
      database: database,
      table: table,
    ).map((row) {
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
        useDirectClient.hashCode ^
        retryDelays.hashCode ^
        cachedRuntimeDatabase.hashCode;
  }
}

/// [ModelTransactionRef] for [TursoModelAdapter].
///
/// [TursoModelAdapter]用の[ModelTransactionRef]。
@immutable
class TursoModelTransactionRef extends ModelTransactionRef {
  TursoModelTransactionRef._();

  final List<_TursoOperation> _operations = [];
}

/// [ModelBatchRef] for [TursoModelAdapter].
///
/// [TursoModelAdapter]用の[ModelBatchRef]。
@immutable
class TursoModelBatchRef extends ModelBatchRef {
  TursoModelBatchRef._();

  final List<_TursoOperation> _operations = [];
}

abstract class _TursoOperation {
  TursoModelPath path();

  Future<void> run(TursoModelAdapter adapter);

  Future<void> runFunctions(TursoModelAdapter adapter);

  Future<void> runDirect(TursoModelAdapter adapter, LibsqlClient client);

  Future<void> runDirectTransaction(
    TursoModelAdapter adapter,
    dynamic transaction,
  );

  Future<void> syncCache(TursoModelAdapter adapter);
}

class _TursoSaveOperation extends _TursoOperation {
  _TursoSaveOperation(this.query, this.value);

  final ModelAdapterDocumentQuery query;
  final DynamicMap value;

  @override
  TursoModelPath path() {
    return TursoModelPath.fromDocumentQuery(query);
  }

  @override
  Future<void> run(TursoModelAdapter adapter) {
    return adapter.saveDocument(query, value);
  }

  @override
  Future<void> runFunctions(TursoModelAdapter adapter) async {
    final path = this.path();
    await adapter._saveDocumentFunctions(
      path,
      adapter._buildSaveRow(path, value),
    );
    await syncCache(adapter);
  }

  @override
  Future<void> runDirect(TursoModelAdapter adapter, LibsqlClient client) async {
    final path = this.path();
    final row = adapter._buildSaveRow(path, value);
    final insert = _buildTursoInsertSql(path.table, row);
    await client.execute(insert.sql, positional: insert.args);
    await syncCache(adapter);
  }

  @override
  Future<void> runDirectTransaction(
    TursoModelAdapter adapter,
    dynamic transaction,
  ) async {
    final path = this.path();
    final row = adapter._buildSaveRow(path, value);
    final insert = _buildTursoInsertSql(path.table, row);
    await transaction.execute(insert.sql, positional: insert.args);
  }

  @override
  Future<void> syncCache(TursoModelAdapter adapter) async {
    await adapter._saveCachedDocument(query, value);
  }
}

class _TursoDeleteOperation extends _TursoOperation {
  _TursoDeleteOperation(this.query);

  final ModelAdapterDocumentQuery query;

  @override
  TursoModelPath path() {
    return TursoModelPath.fromDocumentQuery(query);
  }

  @override
  Future<void> run(TursoModelAdapter adapter) {
    return adapter.deleteDocument(query);
  }

  @override
  Future<void> runFunctions(TursoModelAdapter adapter) async {
    final path = this.path();
    await adapter.functionsAdapter.execute(TursoDeleteModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: adapter.prefix,
      indexKey: path.indexKey,
    ));
    await syncCache(adapter);
  }

  @override
  Future<void> runDirect(TursoModelAdapter adapter, LibsqlClient client) async {
    final path = this.path();
    await client.execute(
      "DELETE FROM ${_quoteTursoIdentifier(path.table)} "
      "WHERE ${_quoteTursoIdentifier("id")} = ?",
      positional: [path.indexKey],
    );
    await syncCache(adapter);
  }

  @override
  Future<void> runDirectTransaction(
    TursoModelAdapter adapter,
    dynamic transaction,
  ) async {
    final path = this.path();
    await transaction.execute(
      "DELETE FROM ${_quoteTursoIdentifier(path.table)} "
      "WHERE ${_quoteTursoIdentifier("id")} = ?",
      positional: [path.indexKey],
    );
  }

  @override
  Future<void> syncCache(TursoModelAdapter adapter) async {
    await adapter._deleteCachedDocument(query);
  }
}
