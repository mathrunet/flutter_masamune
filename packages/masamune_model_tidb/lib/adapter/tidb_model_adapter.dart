part of "/masamune_model_tidb.dart";

const _fallbackTokenResponse = TidbTokenFunctionsActionResponse(
  token: "",
  expiresAt: 0,
  readMode: "functions",
  writeMode: "functions",
);

const _tidbRetryDelays = [
  Duration(milliseconds: 250),
  Duration(milliseconds: 500),
  Duration(seconds: 1),
  Duration(seconds: 2),
  Duration(seconds: 4),
  Duration(seconds: 8),
];

const _tidbSchemaTable = "__masamune_tidb_schema";

final Map<String, Set<String>> _tidbBoolFieldsCache = {};

/// A model adapter that enables the use of Tidb.
///
/// It can access Tidb through Cloudflare Workers, or directly through a
/// scoped short-lived token issued by the Workers endpoint.
///
/// Tidbを利用できるようにしたモデルアダプター。
///
/// Cloudflare Workers経由、またはWorkersで発行したスコープ付き短命トークンを
/// 使った直接接続でTidbにアクセスします。
class TidbModelAdapter extends ModelAdapter {
  /// A model adapter that enables the use of Tidb.
  ///
  /// Tidbを利用できるようにしたモデルアダプター。
  const TidbModelAdapter({
    this.useDirectClient = true,
    FunctionsAdapter? functionsAdapter,
    this.tokenTtlSeconds = 3600,
    this.retryDelays = _tidbRetryDelays,
    NoSqlDatabase? cachedRuntimeDatabase,
  })  : _functionsAdapter = functionsAdapter,
        _cachedRuntimeDatabase = cachedRuntimeDatabase;

  /// Functions adapter for obtaining tokens and using Workers CRUD.
  ///
  /// トークン取得やWorkers CRUDに利用するFunctionsアダプター。
  FunctionsAdapter get functionsAdapter {
    return _functionsAdapter ?? FunctionsAdapter.primary;
  }

  final FunctionsAdapter? _functionsAdapter;

  /// Whether to use direct client access.
  ///
  /// 直接接続を利用するかどうか。
  final bool useDirectClient;

  /// Token TTL in seconds.
  ///
  /// トークンの有効秒数。
  final int tokenTtlSeconds;

  /// Retry delays for transient Tidb direct connection errors.
  ///
  /// Tidb直接接続の一時的なエラーに対するリトライ間隔。
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

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    final path = TidbModelPath.fromDocumentQuery(query);
    if (_directEnabled) {
      await _withDirectClient(
        database: path.database,
        scopes: [
          TidbTokenScope(table: path.table, operations: const ["write"]),
        ],
        functionsFallback: (_) async {
          await functionsAdapter.execute(TidbDeleteModelFunctionsAction(
            database: path.database,
            table: path.table,
            indexKey: path.indexKey,
          ));
        },
        callback: (client) async {
          await client.execute(
            "DELETE FROM ${_quoteTidbIdentifier(path.table)} "
            "WHERE ${_quoteTidbIdentifier("id")} = ?",
            positional: [path.indexKey],
          );
        },
      );
    } else {
      await functionsAdapter.execute(TidbDeleteModelFunctionsAction(
        database: path.database,
        table: path.table,
        indexKey: path.indexKey,
      ));
    }
    await cachedRuntimeDatabase.deleteDocument(query);
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
    cachedRuntimeDatabase.removeCollectionListener(query);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    cachedRuntimeDatabase.removeDocumentListener(query);
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
      throw UnsupportedError(
          "TidbModelAdapter supports only count aggregate.");
    }
    final path = TidbModelPath.fromCollectionQuery(query);
    final payload = TidbQueryPayload.fromFilters(query.query.filters);
    Object? count;
    if (_directEnabled) {
      count = await _withDirectClient(
        database: path.database,
        scopes: [
          TidbTokenScope(table: path.table, operations: const ["read"]),
        ],
        functionsFallback: (_) async {
          final res =
              await functionsAdapter.execute(TidbGetModelFunctionsAction(
            database: path.database,
            table: path.table,
            where: payload.where,
            count: true,
          ));
          return res.data;
        },
        callback: (client) async {
          final where = _buildTidbWhereSql(where: payload.where);
          final List<Map<String, dynamic>> rows;
          try {
            rows = await client.query(
              "SELECT COUNT(*) AS count FROM ${_quoteTidbIdentifier(path.table)}${where.sql}",
              positional: where.args,
            );
          } catch (error) {
            if (_isTidbMissingTableError(error)) {
              return 0;
            }
            rethrow;
          }
          return rows.firstOrNull?["count"] ?? 0;
        },
      );
    } else {
      final res = await functionsAdapter.execute(TidbGetModelFunctionsAction(
        database: path.database,
        table: path.table,
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
    final path = TidbModelPath.fromCollectionQuery(query);
    final payload = TidbQueryPayload.fromFilters(query.query.filters);
    final data = _directEnabled
        ? await _loadCollectionDirect(path, payload)
        : await _loadCollectionFunctions(path, payload);
    await cachedRuntimeDatabase.syncCollection(query, data);
    return data;
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    if (query.reference && !query.reload) {
      final cached = await cachedRuntimeDatabase.loadDocument(query);
      if (cached != null) {
        return cached;
      }
    }
    final path = TidbModelPath.fromDocumentQuery(query);
    final data = _directEnabled
        ? await _loadDocumentDirect(path)
        : await _loadDocumentFunctions(path);
    await cachedRuntimeDatabase.syncDocument(query, data);
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
    final boolFields = _extractTidbBoolFields(value);
    _cacheTidbBoolFields(path.table, boolFields);
    if (_directEnabled) {
      await _saveDocumentDirect(path, row, boolFields);
    } else {
      await _saveDocumentFunctions(path, row);
    }
    await cachedRuntimeDatabase.saveDocument(query, value);
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

  Future<Map<String, DynamicMap>> _loadCollectionDirect(
    TidbModelPath path,
    TidbQueryPayload payload,
  ) async {
    return await _withDirectClient(
      database: path.database,
      scopes: [
        TidbTokenScope(table: path.table, operations: const ["read"]),
        const TidbTokenScope(table: _tidbSchemaTable, operations: ["read"]),
      ],
      functionsFallback: (_) => _loadCollectionFunctions(path, payload),
      callback: (client) async {
        final where = _buildTidbWhereSql(where: payload.where);
        final boolFields = await _loadTidbBoolFields(client, path.table);
        final List<Map<String, dynamic>> rows;
        try {
          rows = await client.query(
            "SELECT * FROM ${_quoteTidbIdentifier(path.table)}"
            "${where.sql}${_buildTidbOrderSql(payload.orderBy)}"
            "${_buildTidbLimitSql(payload.limit)}",
            positional: where.args,
          );
        } catch (error) {
          if (_isTidbMissingTableError(error)) {
            return <String, DynamicMap>{};
          }
          rethrow;
        }
        return Map.fromEntries(rows.map((row) {
          final decoded = _decodeTidbRow(row, boolFields: boolFields);
          return MapEntry(decoded.get("id", ""), decoded);
        }).where((entry) => entry.key.isNotEmpty));
      },
    );
  }

  Future<Map<String, DynamicMap>> _loadCollectionFunctions(
    TidbModelPath path,
    TidbQueryPayload payload,
  ) async {
    final res = await functionsAdapter.execute(TidbGetModelFunctionsAction(
      database: path.database,
      table: path.table,
      where: payload.where,
      orderBy: payload.orderBy,
      limit: payload.limit,
    ));
    return _rowsToMap(res.data, table: path.table);
  }

  Future<DynamicMap> _loadDocumentDirect(TidbModelPath path) async {
    return await _withDirectClient(
      database: path.database,
      scopes: [
        TidbTokenScope(table: path.table, operations: const ["read"]),
        const TidbTokenScope(table: _tidbSchemaTable, operations: ["read"]),
      ],
      functionsFallback: (_) => _loadDocumentFunctions(path),
      callback: (client) async {
        final boolFields = await _loadTidbBoolFields(client, path.table);
        final List<Map<String, dynamic>> rows;
        try {
          rows = await client.query(
            "SELECT * FROM ${_quoteTidbIdentifier(path.table)} "
            "WHERE ${_quoteTidbIdentifier("id")} = ? LIMIT 1",
            positional: [path.indexKey],
          );
        } catch (error) {
          if (_isTidbMissingTableError(error)) {
            return <String, dynamic>{};
          }
          rethrow;
        }
        return rows.isEmpty
            ? <String, dynamic>{}
            : _decodeTidbRow(rows.first, boolFields: boolFields);
      },
    );
  }

  Future<DynamicMap> _loadDocumentFunctions(TidbModelPath path) async {
    final res = await functionsAdapter.execute(TidbGetModelFunctionsAction(
      database: path.database,
      table: path.table,
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
          ...tables.keys.map((table) => TidbTokenScope(
                table: table,
                operations: const ["read"],
              )),
          const TidbTokenScope(
            table: _tidbSchemaTable,
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
              final boolFields = await _loadTidbBoolFields(client, table);
              final rows = await client.query(
                "SELECT * FROM ${_quoteTidbIdentifier(table)} "
                "WHERE ${_quoteTidbIdentifier("id")} IN (${ids.map((_) => "?").join(", ")})",
                positional: ids,
              );
              databaseResult[table] = Map.fromEntries(rows.map((row) {
                final decoded = _decodeTidbRow(row, boolFields: boolFields);
                return MapEntry(decoded.get("id", ""), decoded);
              }).where((entry) => entry.key.isNotEmpty));
            } catch (error) {
              if (_isTidbMissingTableError(error)) {
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
        final res = await functionsAdapter.execute(TidbGetModelFunctionsAction(
          database: database,
          table: table,
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
      await cachedRuntimeDatabase.syncCollection(
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
    TidbModelPath path,
    DynamicMap row,
    Set<String> boolFields,
  ) async {
    await _withDirectClient(
      database: path.database,
      scopes: [
        TidbTokenScope(table: path.table, operations: const ["write"]),
        const TidbTokenScope(table: _tidbSchemaTable, operations: ["write"]),
      ],
      functionsFallback: (_) => _saveDocumentFunctions(path, row),
      callback: (client) async {
        await _ensureSchema(client, path.table, row, boolFields);
        final insert = _buildTidbInsertSql(path.table, row);
        await client.execute(insert.sql, positional: insert.args);
      },
    );
  }

  Future<void> _saveDocumentFunctions(
      TidbModelPath path, DynamicMap row) async {
    await functionsAdapter.execute(TidbPostModelFunctionsAction(
      database: path.database,
      table: path.table,
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
          "TidbModelAdapter does not support direct batch operations across multiple databases.");
    }
    final operationDatabase = operationDatabases.single;
    final scopes = operations
        .map((operation) => TidbTokenScope(
              table: operation.path().table,
              operations: const ["write"],
            ))
        .toList()
      ..add(const TidbTokenScope(
          table: _tidbSchemaTable, operations: ["write"]));
    await _withDirectClient(
      database: operationDatabase,
      scopes: scopes,
      functionsFallback: (_) => _runOperationsFunctions(operations),
      callback: (client) async {
        for (final operation in operations.whereType<_TidbSaveOperation>()) {
          final path = operation.path();
          final boolFields = _extractTidbBoolFields(operation.value);
          _cacheTidbBoolFields(path.table, boolFields);
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
        } else {
          for (final operation in operations) {
            await operation.runDirect(this, client);
          }
        }
      },
    );
  }

  Future<void> _runOperationsFunctions(List<_TidbOperation> operations) async {
    for (final operation in operations) {
      await operation.runFunctions(this);
    }
  }

  Future<T> _withDirectClient<T>({
    required String database,
    required List<TidbTokenScope> scopes,
    required Future<T> Function(TidbDirectClient client) callback,
    Future<T> Function(TidbTokenFunctionsActionResponse token)?
        functionsFallback,
  }) async {
    final TidbTokenFunctionsActionResponse token;
    try {
      token = await _retryTidbTransient(() {
        return functionsAdapter.execute(TidbTokenFunctionsAction(
          database: database,
          targets: _mergeScopes(scopes),
          ttlSeconds: tokenTtlSeconds,
        ));
      });
    } catch (error) {
      if (functionsFallback != null && _isTidbDirectFallbackError(error)) {
        return await _retryTidbTransient(
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
          "Direct Tidb read is not allowed. readMode=${token.readMode}");
    }
    if (_requiresWrite(scopes) && token.writeMode != "direct") {
      if (token.writeMode == "functions" && functionsFallback != null) {
        return await functionsFallback(token);
      }
      throw StateError(
          "Direct Tidb write is not allowed. writeMode=${token.writeMode}");
    }
    if (token.host.isEmpty || token.username.isEmpty || token.database.isEmpty) {
      throw StateError(
          "Token response host, username and database are required for direct Tidb access.");
    }
    try {
      return await _retryTidbTransient(() async {
        final client = await TidbDirectClient.connect(
          host: token.host,
          port: token.port,
          username: token.username,
          password: token.token,
          database: token.database,
        );
        try {
          return await callback(client);
        } finally {
          await client.close();
        }
      });
    } catch (error) {
      if (functionsFallback != null && _isTidbDirectFallbackError(error)) {
        return await _retryTidbTransient(
          () => functionsFallback(token),
        );
      }
      rethrow;
    }
  }

  Future<T> _retryTidbTransient<T>(Future<T> Function() callback) async {
    Object? lastError;
    StackTrace? lastStackTrace;
    for (var attempt = 0; attempt <= retryDelays.length; attempt++) {
      try {
        return await callback();
      } catch (error, stackTrace) {
        lastError = error;
        lastStackTrace = stackTrace;
        if (!_isTidbDirectFallbackError(error) ||
            attempt == retryDelays.length) {
          rethrow;
        }
        await Future<void>.delayed(retryDelays[attempt]);
      }
    }
    Error.throwWithStackTrace(lastError!, lastStackTrace!);
  }

  bool _requiresWrite(List<TidbTokenScope> scopes) {
    const writeOperations = {"write", "create", "update", "delete"};
    return scopes.any((scope) => scope.operations
        .any((operation) => writeOperations.contains(operation)));
  }

  bool _requiresRead(List<TidbTokenScope> scopes) {
    return scopes.any((scope) => scope.operations
        .any((operation) => operation == "read" || operation == "get"));
  }

  bool _isTidbDirectFallbackError(Object error) {
    if (_isTidbMissingTableError(error)) {
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

  bool _isTidbMissingTableError(Object error) {
    final message = error.toString();
    return message.contains("no such table") ||
        message.contains("doesn't exist") ||
        message.contains("Unknown table") ||
        message.contains("SQLITE_UNKNOWN");
  }

  List<TidbTokenScope> _mergeScopes(List<TidbTokenScope> scopes) {
    final map = <String, Set<String>>{};
    for (final scope in scopes) {
      final operations = map[scope.table] ?? <String>{};
      operations.addAll(scope.operations);
      map[scope.table] = operations;
    }
    return map.entries
        .map((entry) => TidbTokenScope(
              table: entry.key,
              operations: entry.value.toList(),
            ))
        .toList();
  }

  DynamicMap _buildSaveRow(TidbModelPath path, DynamicMap value) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final sanitizedValue = _sanitizeTidbSaveValue(value);
    return {
      ...sanitizedValue
          .map((key, val) => MapEntry(key, _encodeTidbValue(val))),
      "id": path.indexKey,
      "created_at": value["created_at"] ?? now,
      "updated_at": now,
    };
  }

  Future<void> _ensureSchema(
    TidbDirectClient client,
    String table,
    DynamicMap row,
    Set<String> boolFields,
  ) async {
    final create = _buildTidbCreateTableSql(table, row);
    await client.execute(create.sql);
    await _ensureTidbSchemaTable(client);
    await _saveTidbBoolFields(client, table, boolFields);
    final current =
        await client.query("SHOW COLUMNS FROM ${_quoteTidbIdentifier(table)}");
    final columns =
        current.map((row) => row.get("Field", row.get("field", ""))).toSet();
    for (final entry in row.entries) {
      if (columns.contains(entry.key)) {
        continue;
      }
      await client.execute(
        "ALTER TABLE ${_quoteTidbIdentifier(table)} "
        "ADD COLUMN ${_quoteTidbIdentifier(entry.key)} ${_inferTidbSqlType(entry.value)}",
      );
    }
  }

  List<DynamicMap> _rowsToList(Object? data, {String? table}) {
    final boolFields = table == null
        ? const <String>{}
        : _tidbBoolFieldsCache[table] ?? const <String>{};
    if (data is List) {
      return data
          .whereType<Map>()
          .map((row) => _decodeTidbRow(
                Map<String, dynamic>.from(row),
                boolFields: boolFields,
              ))
          .toList();
    }
    if (data is Map) {
      return [
        _decodeTidbRow(
          Map<String, dynamic>.from(data),
          boolFields: boolFields,
        )
      ];
    }
    return [];
  }

  Future<void> _ensureTidbSchemaTable(TidbDirectClient client) async {
    await client.execute(
      "CREATE TABLE IF NOT EXISTS ${_quoteTidbIdentifier(_tidbSchemaTable)} ( "
      "id VARCHAR(255) PRIMARY KEY, "
      "table_name TEXT, "
      "column_name TEXT, "
      "value_type TEXT, "
      "updated_at BIGINT"
      " )",
    );
  }

  Future<void> _saveTidbBoolFields(
    TidbDirectClient client,
    String table,
    Set<String> boolFields,
  ) async {
    if (boolFields.isEmpty) {
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final field in boolFields) {
      await client.execute(
        "INSERT INTO ${_quoteTidbIdentifier(_tidbSchemaTable)} "
        "(id, table_name, column_name, value_type, updated_at) "
        "VALUES (?, ?, ?, ?, ?) "
        "ON DUPLICATE KEY UPDATE "
        "table_name = VALUES(table_name), "
        "column_name = VALUES(column_name), "
        "value_type = VALUES(value_type), "
        "updated_at = VALUES(updated_at)",
        positional: ["$table:$field", table, field, "bool", now],
      );
    }
  }

  Future<Set<String>> _loadTidbBoolFields(
    TidbDirectClient client,
    String table,
  ) async {
    try {
      final rows = await client.query(
        "SELECT column_name FROM ${_quoteTidbIdentifier(_tidbSchemaTable)} "
        "WHERE table_name = ? AND value_type = ?",
        positional: [table, "bool"],
      );
      final fields = rows
          .map((row) => row.get("column_name", ""))
          .where((field) => field.isNotEmpty)
          .toSet();
      _cacheTidbBoolFields(table, fields);
      return fields;
    } catch (_) {
      return _tidbBoolFieldsCache[table] ?? const {};
    }
  }

  void _cacheTidbBoolFields(String table, Set<String> fields) {
    if (fields.isEmpty) {
      return;
    }
    _tidbBoolFieldsCache[table] = {
      ...?_tidbBoolFieldsCache[table],
      ...fields,
    };
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
        useDirectClient.hashCode ^
        retryDelays.hashCode ^
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

  Future<void> runDirect(TidbModelAdapter adapter, TidbDirectClient client);

  Future<void> runDirectTransaction(
    TidbModelAdapter adapter,
    dynamic transaction,
  );
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
    await adapter.cachedRuntimeDatabase.saveDocument(query, value);
  }

  @override
  Future<void> runDirect(TidbModelAdapter adapter, TidbDirectClient client) async {
    final path = this.path();
    final row = adapter._buildSaveRow(path, value);
    final insert = _buildTidbInsertSql(path.table, row);
    await client.execute(insert.sql, positional: insert.args);
    await adapter.cachedRuntimeDatabase.saveDocument(query, value);
  }

  @override
  Future<void> runDirectTransaction(
    TidbModelAdapter adapter,
    dynamic transaction,
  ) async {
    final path = this.path();
    final row = adapter._buildSaveRow(path, value);
    final insert = _buildTidbInsertSql(path.table, row);
    await transaction.execute(insert.sql, positional: insert.args);
    await adapter.cachedRuntimeDatabase.saveDocument(query, value);
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
      indexKey: path.indexKey,
    ));
    await adapter.cachedRuntimeDatabase.deleteDocument(query);
  }

  @override
  Future<void> runDirect(TidbModelAdapter adapter, TidbDirectClient client) async {
    final path = this.path();
    await client.execute(
      "DELETE FROM ${_quoteTidbIdentifier(path.table)} "
      "WHERE ${_quoteTidbIdentifier("id")} = ?",
      positional: [path.indexKey],
    );
    await adapter.cachedRuntimeDatabase.deleteDocument(query);
  }

  @override
  Future<void> runDirectTransaction(
    TidbModelAdapter adapter,
    dynamic transaction,
  ) async {
    final path = this.path();
    await transaction.execute(
      "DELETE FROM ${_quoteTidbIdentifier(path.table)} "
      "WHERE ${_quoteTidbIdentifier("id")} = ?",
      positional: [path.indexKey],
    );
    await adapter.cachedRuntimeDatabase.deleteDocument(query);
  }
}
