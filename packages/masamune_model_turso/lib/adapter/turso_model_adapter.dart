part of "/masamune_model_turso.dart";

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
    FunctionsAdapter? functionsAdapter,
    this.database = "main",
    this.useDirectClient = false,
    this.tokenTtlSeconds = 600,
    NoSqlDatabase? cachedRuntimeDatabase,
    this.vectorConverter = const PassVectorConverter(),
  })  : _functionsAdapter = functionsAdapter,
        _cachedRuntimeDatabase = cachedRuntimeDatabase;

  /// Functions adapter for obtaining tokens and using Workers CRUD.
  ///
  /// トークン取得やWorkers CRUDに利用するFunctionsアダプター。
  FunctionsAdapter get functionsAdapter {
    return _functionsAdapter ?? FunctionsAdapter.primary;
  }

  final FunctionsAdapter? _functionsAdapter;

  /// Database ID.
  ///
  /// データベースID。
  final String database;

  /// Whether to use direct client access.
  ///
  /// 直接接続を利用するかどうか。
  final bool useDirectClient;

  /// Token TTL in seconds.
  ///
  /// トークンの有効秒数。
  final int tokenTtlSeconds;

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
    final path = TursoModelPath.fromDocumentQuery(
      query,
      defaultDatabase: database,
    );
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
        indexKey: path.indexKey,
      ));
    }
    await cachedRuntimeDatabase.deleteDocument(query);
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
    cachedRuntimeDatabase.removeCollectionListener(query);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    cachedRuntimeDatabase.removeDocumentListener(query);
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
    final path = TursoModelPath.fromCollectionQuery(
      query,
      defaultDatabase: database,
    );
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
            where: payload.where,
            count: true,
          ));
          return res.data;
        },
        callback: (client) async {
          final where = _buildTursoWhereSql(where: payload.where);
          final rows = await client.query(
            "SELECT COUNT(*) AS count FROM ${_quoteTursoIdentifier(path.table)}${where.sql}",
            positional: where.args,
          );
          return rows.firstOrNull?["count"] ?? 0;
        },
      );
    } else {
      final res = await functionsAdapter.execute(TursoGetModelFunctionsAction(
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
    final path = TursoModelPath.fromCollectionQuery(
      query,
      defaultDatabase: database,
    );
    final payload = TursoQueryPayload.fromFilters(query.query.filters);
    final data = _directEnabled
        ? await _loadCollectionDirect(path, payload)
        : await _loadCollectionFunctions(path, payload);
    await cachedRuntimeDatabase.syncCollection(query, data);
    return data;
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final path = TursoModelPath.fromDocumentQuery(
      query,
      defaultDatabase: database,
    );
    final data = _directEnabled
        ? await _loadDocumentDirect(path)
        : await _loadDocumentFunctions(path);
    await cachedRuntimeDatabase.syncDocument(query, data);
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
    final path = TursoModelPath.fromDocumentQuery(
      query,
      defaultDatabase: database,
    );
    final row = _buildSaveRow(path, value);
    if (_directEnabled) {
      await _saveDocumentDirect(path, row);
    } else {
      await _saveDocumentFunctions(path, row);
    }
    await cachedRuntimeDatabase.saveDocument(query, value);
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
      ],
      functionsFallback: (_) => _loadCollectionFunctions(path, payload),
      callback: (client) async {
        final where = _buildTursoWhereSql(where: payload.where);
        final rows = await client.query(
          "SELECT * FROM ${_quoteTursoIdentifier(path.table)}"
          "${where.sql}${_buildTursoOrderSql(payload.orderBy)}"
          "${_buildTursoLimitSql(payload.limit)}",
          positional: where.args,
        );
        return Map.fromEntries(rows.map((row) {
          final decoded = _decodeTursoRow(row);
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
      where: payload.where,
      orderBy: payload.orderBy,
      limit: payload.limit,
    ));
    return _rowsToMap(res.data);
  }

  Future<DynamicMap> _loadDocumentDirect(TursoModelPath path) async {
    return await _withDirectClient(
      database: path.database,
      scopes: [
        TursoTokenScope(table: path.table, operations: const ["read"]),
      ],
      functionsFallback: (_) => _loadDocumentFunctions(path),
      callback: (client) async {
        final rows = await client.query(
          "SELECT * FROM ${_quoteTursoIdentifier(path.table)} "
          "WHERE ${_quoteTursoIdentifier("id")} = ? LIMIT 1",
          positional: [path.indexKey],
        );
        return rows.isEmpty ? <String, dynamic>{} : _decodeTursoRow(rows.first);
      },
    );
  }

  Future<DynamicMap> _loadDocumentFunctions(TursoModelPath path) async {
    final res = await functionsAdapter.execute(TursoGetModelFunctionsAction(
      database: path.database,
      table: path.table,
      indexKey: path.indexKey,
    ));
    final rows = _rowsToList(res.data);
    return rows.isEmpty ? <String, dynamic>{} : rows.first;
  }

  Future<void> _saveDocumentDirect(TursoModelPath path, DynamicMap row) async {
    await _withDirectClient(
      database: path.database,
      scopes: [
        TursoTokenScope(table: path.table, operations: const ["write"]),
      ],
      functionsFallback: (_) => _saveDocumentFunctions(path, row),
      callback: (client) async {
        await _ensureSchema(client, path.table, row);
        final insert = _buildTursoInsertSql(path.table, row);
        await client.execute(insert.sql, positional: insert.args);
      },
    );
  }

  Future<void> _saveDocumentFunctions(
      TursoModelPath path, DynamicMap row) async {
    final exists = (await _loadDocumentFunctions(path)).isNotEmpty;
    if (exists) {
      await functionsAdapter.execute(TursoPutModelFunctionsAction(
        database: path.database,
        table: path.table,
        indexKey: path.indexKey,
        value: row,
      ));
    } else {
      await functionsAdapter.execute(TursoPostModelFunctionsAction(
        database: path.database,
        table: path.table,
        indexKey: path.indexKey,
        value: row,
      ));
    }
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
    final operationDatabases = operations
        .map((operation) => operation.path(defaultDatabase: database).database)
        .toSet();
    if (operationDatabases.length > 1) {
      throw UnsupportedError(
          "TursoModelAdapter does not support direct batch operations across multiple databases.");
    }
    final operationDatabase = operationDatabases.single;
    final scopes = operations
        .map((operation) => TursoTokenScope(
              table: operation.path(defaultDatabase: database).table,
              operations: const ["write"],
            ))
        .toList();
    await _withDirectClient(
      database: operationDatabase,
      scopes: scopes,
      functionsFallback: (_) => _runOperationsFunctions(operations),
      callback: (client) async {
        for (final operation in operations.whereType<_TursoSaveOperation>()) {
          final path = operation.path(defaultDatabase: database);
          await _ensureSchema(
              client, path.table, _buildSaveRow(path, operation.value));
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
    final token = await functionsAdapter.execute(TursoTokenFunctionsAction(
      database: database,
      targets: _mergeScopes(scopes),
      ttlSeconds: tokenTtlSeconds,
    ));
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
    final client = LibsqlClient.remote(url, authToken: token.token);
    await client.connect();
    try {
      return await callback(client);
    } finally {
      await client.dispose();
    }
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
    return {
      ...value.map((key, val) => MapEntry(key, _encodeTursoValue(val))),
      "id": path.indexKey,
      "created_at": value["created_at"] ?? now,
      "updated_at": now,
    };
  }

  Future<void> _ensureSchema(
    LibsqlClient client,
    String table,
    DynamicMap row,
  ) async {
    final create = _buildTursoCreateTableSql(table, row);
    await client.execute(create.sql);
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

  List<DynamicMap> _rowsToList(Object? data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map((row) => _decodeTursoRow(Map<String, dynamic>.from(row)))
          .toList();
    }
    if (data is Map) {
      return [_decodeTursoRow(Map<String, dynamic>.from(data))];
    }
    return [];
  }

  Map<String, DynamicMap> _rowsToMap(Object? data) {
    return Map.fromEntries(_rowsToList(data).map((row) {
      return MapEntry(row.get("id", ""), row);
    }).where((entry) => entry.key.isNotEmpty));
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return runtimeType.hashCode ^
        functionsAdapter.hashCode ^
        database.hashCode ^
        useDirectClient.hashCode ^
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
  TursoModelPath path({required String defaultDatabase});

  Future<void> run(TursoModelAdapter adapter);

  Future<void> runFunctions(TursoModelAdapter adapter);

  Future<void> runDirect(TursoModelAdapter adapter, LibsqlClient client);

  Future<void> runDirectTransaction(
    TursoModelAdapter adapter,
    dynamic transaction,
  );
}

class _TursoSaveOperation extends _TursoOperation {
  _TursoSaveOperation(this.query, this.value);

  final ModelAdapterDocumentQuery query;
  final DynamicMap value;

  @override
  TursoModelPath path({required String defaultDatabase}) {
    return TursoModelPath.fromDocumentQuery(query,
        defaultDatabase: defaultDatabase);
  }

  @override
  Future<void> run(TursoModelAdapter adapter) {
    return adapter.saveDocument(query, value);
  }

  @override
  Future<void> runFunctions(TursoModelAdapter adapter) async {
    final path = this.path(defaultDatabase: adapter.database);
    await adapter._saveDocumentFunctions(
      path,
      adapter._buildSaveRow(path, value),
    );
    await adapter.cachedRuntimeDatabase.saveDocument(query, value);
  }

  @override
  Future<void> runDirect(TursoModelAdapter adapter, LibsqlClient client) async {
    final path = this.path(defaultDatabase: adapter.database);
    final row = adapter._buildSaveRow(path, value);
    final insert = _buildTursoInsertSql(path.table, row);
    await client.execute(insert.sql, positional: insert.args);
    await adapter.cachedRuntimeDatabase.saveDocument(query, value);
  }

  @override
  Future<void> runDirectTransaction(
    TursoModelAdapter adapter,
    dynamic transaction,
  ) async {
    final path = this.path(defaultDatabase: adapter.database);
    final row = adapter._buildSaveRow(path, value);
    final insert = _buildTursoInsertSql(path.table, row);
    await transaction.execute(insert.sql, positional: insert.args);
    await adapter.cachedRuntimeDatabase.saveDocument(query, value);
  }
}

class _TursoDeleteOperation extends _TursoOperation {
  _TursoDeleteOperation(this.query);

  final ModelAdapterDocumentQuery query;

  @override
  TursoModelPath path({required String defaultDatabase}) {
    return TursoModelPath.fromDocumentQuery(query,
        defaultDatabase: defaultDatabase);
  }

  @override
  Future<void> run(TursoModelAdapter adapter) {
    return adapter.deleteDocument(query);
  }

  @override
  Future<void> runFunctions(TursoModelAdapter adapter) async {
    final path = this.path(defaultDatabase: adapter.database);
    await adapter.functionsAdapter.execute(TursoDeleteModelFunctionsAction(
      database: path.database,
      table: path.table,
      indexKey: path.indexKey,
    ));
    await adapter.cachedRuntimeDatabase.deleteDocument(query);
  }

  @override
  Future<void> runDirect(TursoModelAdapter adapter, LibsqlClient client) async {
    final path = this.path(defaultDatabase: adapter.database);
    await client.execute(
      "DELETE FROM ${_quoteTursoIdentifier(path.table)} "
      "WHERE ${_quoteTursoIdentifier("id")} = ?",
      positional: [path.indexKey],
    );
    await adapter.cachedRuntimeDatabase.deleteDocument(query);
  }

  @override
  Future<void> runDirectTransaction(
    TursoModelAdapter adapter,
    dynamic transaction,
  ) async {
    final path = this.path(defaultDatabase: adapter.database);
    await transaction.execute(
      "DELETE FROM ${_quoteTursoIdentifier(path.table)} "
      "WHERE ${_quoteTursoIdentifier("id")} = ?",
      positional: [path.indexKey],
    );
    await adapter.cachedRuntimeDatabase.deleteDocument(query);
  }
}
