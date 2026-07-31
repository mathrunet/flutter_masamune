// Dart imports:
import "dart:convert";

// Package imports:
import "package:libsql_dart/libsql_dart.dart";
import "package:masamune/masamune.dart";
import "package:test/test.dart";

// Project imports:
import "package:masamune_model_turso/masamune_model_turso.dart";

void main() {
  test("TursoGetModelFunctionsAction builds path based URL.", () {
    final action = TursoGetModelFunctionsAction(
      database: "main",
      table: "users",
      indexKey: "user_1",
      where: const [
        {"type": "equalTo", "key": "name", "value": "Alice"},
        {"type": "equalTo", "key": kUidFieldKey, "value": "user_1"},
      ],
      orderBy: const [
        {"key": kTimeFieldKey, "descending": true},
      ],
      limit: 10,
    );

    final uri = Uri.parse(action.path);
    expect(uri.path, "turso/database/main/users/user_1");
    expect(uri.queryParameters["limit"], "10");
    final where = jsonDecode(uri.queryParameters["where"]!) as List;
    final orderBy = jsonDecode(uri.queryParameters["orderBy"]!) as List;
    expect(where, hasLength(2));
    expect(where[1]["key"], "id");
    expect(orderBy, hasLength(1));
    expect(orderBy.single["key"], "updated_at");
  });

  test("Turso prefix is normalized and serialized.", () {
    final get = TursoGetModelFunctionsAction(
      database: "main",
      table: "users",
      prefix: " dev___ ",
    );
    const post = TursoPostModelFunctionsAction(
      database: "main",
      table: "users",
      prefix: "dev",
      value: {"name": "Alice"},
    );
    const empty = TursoDeleteModelFunctionsAction(
      database: "main",
      table: "users",
      prefix: "___",
    );

    expect(get.prefix, "dev_");
    expect(Uri.parse(get.path).queryParameters["prefix"], "dev_");
    expect(post.prefix, "dev_");
    expect(post.toMap()?["prefix"], "dev_");
    expect(empty.prefix, isNull);
    expect(empty.toMap(), isEmpty);
    expect(
      () => const TursoModelAdapter(prefix: "invalid prefix").prefix,
      throwsArgumentError,
    );
  });

  test("Turso write FunctionsActions build path based URLs.", () {
    const post = TursoPostModelFunctionsAction(
      database: "main",
      table: "users",
      indexKey: "user_1",
      value: {
        "name": "Alice",
        kUidFieldKey: "ignored",
        kTimeFieldKey: 1000,
      },
    );
    const put = TursoPutModelFunctionsAction(
      database: "main",
      table: "users",
      indexKey: "user_1",
      where: [
        {"type": "equalTo", "key": kUidFieldKey, "value": "user_1"},
      ],
      value: {
        "name": "Alice",
        kUidFieldKey: "ignored",
        kTimeFieldKey: 1000,
      },
    );
    const delete = TursoDeleteModelFunctionsAction(
      database: "main",
      table: "users",
      indexKey: "user_1",
    );

    expect(post.path, "turso/database/main/users/user_1");
    expect(post.toMap(), {
      "value": {"name": "Alice"},
    });
    expect(put.path, "turso/database/main/users/user_1");
    expect(put.toMap(), {
      "where": [
        {"type": "equalTo", "key": "id", "value": "user_1"},
      ],
      "value": {"name": "Alice"},
    });
    expect(delete.path, "turso/database/main/users/user_1");
    expect(delete.toMap(), isEmpty);
  });

  test("TursoModelAdapter saves through POST without a preflight GET.",
      () async {
    final functionsAdapter = _RecordingFunctionsAdapter();
    final adapter = TursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: functionsAdapter,
    );
    const query = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/user/user_1"),
    );

    await adapter.saveDocument(query, {
      "name": "Alice",
      "age": 20,
      kUidFieldKey: "ignored",
      kTimeFieldKey: 1000,
    });

    expect(functionsAdapter.actions, hasLength(1));
    final action = functionsAdapter.actions.single;
    expect(action, isA<TursoPostModelFunctionsAction>());
    expect(action, isNot(isA<TursoGetModelFunctionsAction>()));
    final post = action as TursoPostModelFunctionsAction;
    expect(post.path, "turso/database/test/user");
    expect(post.indexKey, isNull);
    expect(post.value["id"], "user_1");
    expect(post.value["name"], "Alice");
    expect(post.value["age"], 20);
    expect(post.value.containsKey(kUidFieldKey), false);
    expect(post.value.containsKey(kTimeFieldKey), false);
  });

  test("TursoModelAdapter falls back to POST when direct token fails.",
      () async {
    final functionsAdapter = _RecordingFunctionsAdapter(
      tokenError: Exception("Failed to post: 500"),
    );
    final adapter = TursoModelAdapter(
      functionsAdapter: functionsAdapter,
      retryDelays: const [],
    );
    const query = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/user/user_1"),
    );

    await adapter.saveDocument(query, {
      "name": "Alice",
      "age": 20,
    });

    expect(
      functionsAdapter.actions.whereType<TursoTokenFunctionsAction>(),
      hasLength(1),
    );
    expect(functionsAdapter.actions.last, isA<TursoPostModelFunctionsAction>());
    final post = functionsAdapter.actions.last as TursoPostModelFunctionsAction;
    expect(post.path, "turso/database/test/user");
    expect(post.value["id"], "user_1");
  });

  test("TursoModelAdapter reuses a direct client within an auth session.",
      () async {
    var sessionKey = "user_1";
    var clientCount = 0;
    var syncCount = 0;
    final functionsAdapter = _RecordingFunctionsAdapter(
      responseForAction: (action) {
        if (action is TursoTokenFunctionsAction) {
          return {
            "token": "token",
            "expiresAt": DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
            "url": ":memory:",
            "readMode": "direct",
            "writeMode": "direct",
            "targets": action.targets
                .map((target) => {
                      ...target.toMap(),
                      "readMode": "direct",
                      "writeMode": "direct",
                    })
                .toList(),
          };
        }
        return const [];
      },
    );
    final session = TursoDirectClientSession(
      sessionKey: () => sessionKey,
      clientFactory: (_) async {
        clientCount++;
        return _TestLibsqlClient(onSync: () => syncCount++);
      },
    );
    final adapter = TursoModelAdapter(
      functionsAdapter: functionsAdapter,
      directClientSession: session,
    );
    const firstQuery = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/user/user_1"),
    );
    const secondQuery = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/records/record_1"),
    );

    await adapter.prewarm(
      database: "test",
      scopes: const [
        TursoTokenScope(table: "user", operations: ["write"]),
        TursoTokenScope(table: "records", operations: ["write"]),
        TursoTokenScope(
          table: "__masamune_turso_schema",
          operations: ["write"],
        ),
      ],
    );
    await adapter.saveDocument(firstQuery, const {"name": "Alice"});
    await adapter.saveDocument(secondQuery, const {"name": "Bob"});

    expect(
      functionsAdapter.actions.whereType<TursoTokenFunctionsAction>(),
      hasLength(1),
    );
    expect(clientCount, 1);
    expect(syncCount, 2);

    sessionKey = "user_2";
    await adapter.saveDocument(firstQuery, const {"name": "Carol"});

    expect(
      functionsAdapter.actions.whereType<TursoTokenFunctionsAction>(),
      hasLength(2),
    );
    expect(clientCount, 2);
    await session.clear();
  });

  test(
      "TursoModelAdapter sends prewarmed functions writes without a token preflight.",
      () async {
    var syncCount = 0;
    final functionsAdapter = _RecordingFunctionsAdapter(
      responseForAction: (action) {
        if (action is TursoTokenFunctionsAction) {
          return {
            "token": "read-token",
            "expiresAt": DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
            "url": ":memory:",
            "readMode": "direct",
            "writeMode": "functions",
            "targets": action.targets
                .map((target) => {
                      ...target.toMap(),
                      "readMode":
                          target.operations.contains("read") ? "direct" : null,
                      "writeMode": target.operations.contains("write")
                          ? "functions"
                          : null,
                    })
                .toList(),
          };
        }
        return const [];
      },
    );
    final session = TursoDirectClientSession(
      sessionKey: () => "user_1",
      clientFactory: (_) async => _TestLibsqlClient(onSync: () => syncCount++),
    );
    final adapter = TursoModelAdapter(
      functionsAdapter: functionsAdapter,
      directClientSession: session,
    );
    const query = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/user/user_1"),
    );

    await adapter.prewarm(
      database: "test",
      scopes: const [
        TursoTokenScope(table: "user", operations: ["read", "write"]),
        TursoTokenScope(
          table: "__masamune_turso_schema",
          operations: ["read", "write"],
        ),
      ],
    );
    await adapter.saveDocument(query, const {"name": "Alice"});

    expect(
      functionsAdapter.actions.whereType<TursoTokenFunctionsAction>(),
      hasLength(1),
    );
    expect(functionsAdapter.actions.last, isA<TursoPostModelFunctionsAction>());
    expect(syncCount, 1);
    await session.clear();
  });

  test("TursoModelAdapter checks sqlite_master before reading bool metadata.",
      () async {
    final queries = <String>[];
    final functionsAdapter = _RecordingFunctionsAdapter(
      responseForAction: (action) => action is TursoTokenFunctionsAction
          ? {
              "token": "token",
              "expiresAt": DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
              "url": ":memory:",
              "readMode": "direct",
              "writeMode": "functions",
              "targets": action.targets
                  .map((target) => {
                        ...target.toMap(),
                        "readMode": "direct",
                        "writeMode": "functions",
                      })
                  .toList(),
            }
          : const [],
    );
    final session = TursoDirectClientSession(
      sessionKey: () => "user_1",
      clientFactory: (_) async => _TestLibsqlClient(
        onQuery: queries.add,
      ),
    );
    final adapter = TursoModelAdapter(
      functionsAdapter: functionsAdapter,
      directClientSession: session,
    );

    await adapter.loadDocument(const ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/users/user_1"),
    ));

    expect(queries.first, contains("sqlite_master"));
    expect(
      queries.where((sql) => sql.contains("SELECT column_name")),
      isEmpty,
    );
    await session.clear();
  });

  test("TursoModelAdapter restores uid and time fields on load.", () async {
    final functionsAdapter = _RecordingFunctionsAdapter(
      responseData: const [
        {
          "id": "user_1",
          "name": "Alice",
          "updated_at": 1234,
        },
      ],
    );
    final adapter = TursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: functionsAdapter,
    );
    const documentQuery = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/user/user_1"),
    );
    const collectionQuery = ModelAdapterCollectionQuery(
      query: CollectionModelQuery("database/test/user"),
    );

    final document = await adapter.loadDocument(documentQuery);
    final collection = await adapter.loadCollection(collectionQuery);

    expect(document[kUidFieldKey], "user_1");
    expect(document[kTimeFieldKey], 1234);
    expect(collection["user_1"]?[kUidFieldKey], "user_1");
    expect(collection["user_1"]?[kTimeFieldKey], 1234);
  });

  test("TursoModelAdapter isolates shared cache by prefix.", () async {
    final cache = NoSqlDatabase();
    final devFunctions = _RecordingFunctionsAdapter(
      responseData: const [
        {"id": "user_1", "name": "Development"},
      ],
    );
    final prodFunctions = _RecordingFunctionsAdapter(
      responseData: const [
        {"id": "user_1", "name": "Production"},
      ],
    );
    final dev = TursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: devFunctions,
      cachedRuntimeDatabase: cache,
      prefix: "dev",
    );
    final prod = TursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: prodFunctions,
      cachedRuntimeDatabase: cache,
    );
    const query = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/users/user_1"),
      reference: true,
    );

    expect((await dev.loadDocument(query))["name"], "Development");
    expect((await prod.loadDocument(query))["name"], "Production");
    expect((await dev.loadDocument(query))["name"], "Development");
    expect(devFunctions.actions, hasLength(1));
    expect(prodFunctions.actions, hasLength(1));
  });

  test("TursoModelAdapter preloads references with one whereIn query.",
      () async {
    final functionsAdapter = _RecordingFunctionsAdapter(
      responseForAction: (action) {
        if (action is! TursoGetModelFunctionsAction) {
          return const [];
        }
        switch (action.table) {
          case "users":
            return const [
              {"id": "user_1", "name": "Alice"},
              {"id": "user_2", "name": "Bob"},
            ];
        }
        return const [];
      },
    );
    final adapter = TursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: functionsAdapter,
      cachedRuntimeDatabase: NoSqlDatabase(),
    );

    await adapter.preloadReferences(const [
      ModelAdapterDocumentQuery(
        query: DocumentModelQuery("database/test/users/user_1"),
        reference: true,
      ),
      ModelAdapterDocumentQuery(
        query: DocumentModelQuery("database/test/users/user_1"),
        reference: true,
      ),
      ModelAdapterDocumentQuery(
        query: DocumentModelQuery("database/test/users/user_2"),
        reference: true,
      ),
    ]);

    final getActions =
        functionsAdapter.actions.whereType<TursoGetModelFunctionsAction>();
    expect(getActions, hasLength(1));
    final usersGet = getActions.single;
    expect(usersGet.table, "users");
    expect(usersGet.where, [
      {
        "type": "whereIn",
        "key": "id",
        "value": ["user_1", "user_2"],
      },
    ]);

    final beforeReferenceLoad = functionsAdapter.actions.length;
    final cached = await adapter.loadDocument(const ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/users/user_1"),
      reference: true,
    ));

    expect(cached["name"], "Alice");
    expect(functionsAdapter.actions, hasLength(beforeReferenceLoad));
  });

  test("TursoModelAdapter preloads references by table.", () async {
    final functionsAdapter = _RecordingFunctionsAdapter(
      responseForAction: (action) {
        if (action is! TursoGetModelFunctionsAction) {
          return const [];
        }
        switch (action.table) {
          case "users":
            return const [
              {"id": "user_1", "name": "Alice"},
            ];
          case "organizations":
            return const [
              {"id": "org_1", "name": "Example Inc."},
            ];
        }
        return const [];
      },
    );
    final adapter = TursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: functionsAdapter,
      cachedRuntimeDatabase: NoSqlDatabase(),
    );

    await adapter.preloadReferences(const [
      ModelAdapterDocumentQuery(
        query: DocumentModelQuery("database/test/users/user_1"),
        reference: true,
      ),
      ModelAdapterDocumentQuery(
        query: DocumentModelQuery("database/test/organizations/org_1"),
        reference: true,
      ),
    ]);

    final getActions =
        functionsAdapter.actions.whereType<TursoGetModelFunctionsAction>();
    expect(getActions.map((action) => action.table), [
      "users",
      "organizations",
    ]);
  });

  test("TursoQueryPayload converts supported model filters.", () {
    final payload = TursoQueryPayload.fromFilters(const [
      ModelQueryFilter.equal(key: "name", value: "Alice"),
      ModelQueryFilter.equal(key: kUidFieldKey, value: "user_1"),
      ModelQueryFilter.greaterThanOrEqual(key: "score", value: 10),
      ModelQueryFilter.orderByDesc(key: kTimeFieldKey),
      ModelQueryFilter.limitTo(value: 20),
    ]);

    expect(payload.where, hasLength(3));
    expect(payload.where[0]["type"], "equalTo");
    expect(payload.where[1]["key"], "id");
    expect(payload.where[2]["type"], "greaterThanOrEqualTo");
    expect(payload.orderBy.single["key"], "updated_at");
    expect(payload.orderBy.single["descending"], true);
    expect(payload.limit, 20);
  });

  test("TursoTokenFunctionsAction serializes scope.", () {
    const action = TursoTokenFunctionsAction(
      database: "main",
      targets: [
        TursoTokenScope(table: "users", operations: ["read", "write"]),
      ],
    );

    final map = action.toMap()!;
    expect(action.path, "turso/token/database/main");
    expect(map["ttlSeconds"], 600);
    expect(map["targets"], [
      {
        "table": "users",
        "operations": ["read", "write"],
      }
    ]);
    expect(map.containsKey("scope"), false);
  });

  test("TursoTokenFunctionsAction serializes normalized prefix.", () {
    const action = TursoTokenFunctionsAction(
      database: "main",
      prefix: "dev___",
      targets: [],
    );

    expect(action.prefix, "dev_");
    expect(action.toMap()?["prefix"], "dev_");
  });

  test("TursoTokenFunctionsAction serializes database operations.", () {
    const action = TursoTokenFunctionsAction(
      database: "main",
      operations: ["read"],
      targets: [],
    );

    expect(action.toMap(), {
      "operations": ["read"],
      "ttlSeconds": 600,
    });
  });

  test("TursoTokenFunctionsAction deserializes resolved URL.", () {
    const action = TursoTokenFunctionsAction(
      database: "main",
      targets: [
        TursoTokenScope(table: "users", operations: ["read"]),
      ],
    );

    final response = action.toResponse({
      "token": "scoped-token",
      "expiresAt": 1760000000,
      "url": "libsql://main.turso.io",
      "readMode": "direct",
      "writeMode": "functions",
      "targets": [
        {
          "table": "users",
          "operations": ["read", "write"],
          "readMode": "direct",
          "writeMode": "functions",
        }
      ],
    });

    expect(response.token, "scoped-token");
    expect(response.expiresAt, 1760000000);
    expect(response.url, "libsql://main.turso.io");
    expect(response.readMode, "direct");
    expect(response.writeMode, "functions");
    expect(response.scopes.single.table, "users");
    expect(response.scopes.single.operations, ["read", "write"]);
    expect(response.scopes.single.readMode, "direct");
    expect(response.scopes.single.writeMode, "functions");
  });

  test("CachedTursoModelAdapter loads documents from persistent cache.",
      () async {
    final localDatabase = NoSqlDatabase();
    final firstFunctions = _RecordingFunctionsAdapter(
      responseData: const [
        {"id": "user_1", "name": "Alice"},
      ],
    );
    final firstAdapter = CachedTursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: firstFunctions,
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
    );
    const query = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/users/user_1"),
    );

    expect((await firstAdapter.loadDocument(query))["name"], "Alice");
    expect(firstFunctions.actions, hasLength(1));

    final secondFunctions = _RecordingFunctionsAdapter(
      responseData: const [
        {"id": "user_1", "name": "Bob"},
      ],
    );
    final secondAdapter = CachedTursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: secondFunctions,
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
    );

    expect((await secondAdapter.loadDocument(query))["name"], "Alice");
    expect(secondFunctions.actions, isEmpty);

    final reloaded = await secondAdapter.loadDocument(
      query.copyWith(reload: true),
    );
    expect(reloaded["name"], "Bob");
    expect(secondFunctions.actions, hasLength(1));
    expect((await localDatabase.loadDocument(query))?["name"], "Bob");
  });

  test("CachedTursoModelAdapter merges collection cache and remote data.",
      () async {
    final localDatabase = NoSqlDatabase();
    const query = ModelAdapterCollectionQuery(
      query: CollectionModelQuery(
        "database/test/users",
        adapter: RuntimeModelAdapter(),
      ),
    );
    await localDatabase.saveCollection(query, const {
      "user_1": {"name": "Alice"},
    });
    final functionsAdapter = _RecordingFunctionsAdapter(
      responseData: const [
        {"id": "user_2", "name": "Bob"},
      ],
    );
    final adapter = CachedTursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: functionsAdapter,
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
      collectionLoaders: [
        (query, _) async {
          return CachedTursoModelCollectionLoaderResponse(
            value: await localDatabase.loadCollection(query) ?? {},
            query: query,
          );
        },
      ],
    );

    final result = await adapter.loadCollection(query);

    expect(result.keys, containsAll(["user_1", "user_2"]));
    expect(functionsAdapter.actions, hasLength(1));
    expect((await localDatabase.loadCollection(query))?.keys,
        containsAll(["user_1", "user_2"]));
  });

  test("CachedTursoModelAdapter can satisfy collection loads from cache.",
      () async {
    final localDatabase = NoSqlDatabase();
    const query = ModelAdapterCollectionQuery(
      query: CollectionModelQuery(
        "database/test/users",
        adapter: RuntimeModelAdapter(),
      ),
    );
    await localDatabase.saveCollection(query, const {
      "user_1": {"name": "Alice"},
    });
    final functionsAdapter = _RecordingFunctionsAdapter();
    final adapter = CachedTursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: functionsAdapter,
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
      collectionLoaders: [
        (query, _) async {
          return CachedTursoModelCollectionLoaderResponse(
            value: await localDatabase.loadCollection(query) ?? {},
          );
        },
      ],
    );

    expect((await adapter.loadCollection(query))["user_1"]?["name"], "Alice");
    expect(functionsAdapter.actions, isEmpty);
  });

  test("CachedTursoModelAdapter applies cacheFilter.", () async {
    final localDatabase = NoSqlDatabase();
    final adapter = CachedTursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: _RecordingFunctionsAdapter(
        responseData: const [
          {"id": "user_1", "name": "Alice", "private": true},
        ],
      ),
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
      cacheFilter: (_, value) => value["private"] != true,
    );
    const query = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/users/user_1"),
    );

    await adapter.loadDocument(query);

    expect(await localDatabase.loadDocument(query), isNull);
  });

  test("CachedTursoModelAdapter isolates persistent cache by prefix.",
      () async {
    final localDatabase = NoSqlDatabase();
    const query = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/users/user_1"),
    );
    final dev = CachedTursoModelAdapter(
      useDirectClient: false,
      prefix: "dev",
      functionsAdapter: _RecordingFunctionsAdapter(
        responseData: const [
          {"id": "user_1", "name": "Development"},
        ],
      ),
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
    );
    final prod = CachedTursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: _RecordingFunctionsAdapter(
        responseData: const [
          {"id": "user_1", "name": "Production"},
        ],
      ),
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
    );

    expect((await dev.loadDocument(query))["name"], "Development");
    expect((await prod.loadDocument(query))["name"], "Production");

    final cachedDevFunctions = _RecordingFunctionsAdapter();
    final cachedProdFunctions = _RecordingFunctionsAdapter();
    final cachedDev = CachedTursoModelAdapter(
      useDirectClient: false,
      prefix: "dev",
      functionsAdapter: cachedDevFunctions,
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
    );
    final cachedProd = CachedTursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: cachedProdFunctions,
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
    );

    expect((await cachedDev.loadDocument(query))["name"], "Development");
    expect((await cachedProd.loadDocument(query))["name"], "Production");
    expect(cachedDevFunctions.actions, isEmpty);
    expect(cachedProdFunctions.actions, isEmpty);
  });

  test("CachedTursoModelAdapter syncs saves, batches, deletes, and clear.",
      () async {
    final localDatabase = NoSqlDatabase();
    final adapter = CachedTursoModelAdapter(
      useDirectClient: false,
      functionsAdapter: _RecordingFunctionsAdapter(),
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
    );
    const firstQuery = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/users/user_1"),
    );
    const secondQuery = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/users/user_2"),
    );

    await adapter.saveDocument(firstQuery, const {"name": "Alice"});
    expect((await localDatabase.loadDocument(firstQuery))?["name"], "Alice");

    await adapter.runBatch((ref) {
      adapter.saveOnBatch(ref, secondQuery, const {"name": "Bob"});
    }, 100);
    expect((await localDatabase.loadDocument(secondQuery))?["name"], "Bob");

    await adapter.runTransaction((ref) {
      adapter.deleteOnTransaction(ref, secondQuery);
    });
    expect(await localDatabase.loadDocument(secondQuery), isNull);

    await adapter.deleteDocument(firstQuery);
    expect(await localDatabase.loadDocument(firstQuery), isNull);

    await adapter.saveDocument(firstQuery, const {"name": "Alice"});
    await adapter.clearCache();
    expect(await localDatabase.loadDocument(firstQuery), isNull);
  });
}

class _RecordingFunctionsAdapter extends FunctionsAdapter {
  _RecordingFunctionsAdapter({
    this.tokenError,
    this.responseData = const [],
    this.responseForAction,
  });

  final Object? tokenError;

  final Object? responseData;

  final Object? Function(FunctionsAction<dynamic> action)? responseForAction;

  final List<FunctionsAction<dynamic>> actions = [];

  @override
  String get endpoint => "";

  @override
  Future<TResponse> execute<TResponse>(
    FunctionsAction<TResponse> action,
  ) {
    actions.add(action);
    final tokenError = this.tokenError;
    if (action is TursoTokenFunctionsAction && tokenError != null) {
      throw tokenError;
    }
    return action.execute((_) async {
      final response = responseForAction?.call(action) ?? responseData;
      if (action is TursoTokenFunctionsAction && response is Map) {
        return Map<String, dynamic>.from(response);
      }
      return {"data": response};
    });
  }
}

class _TestLibsqlClient extends LibsqlClient {
  _TestLibsqlClient({this.onSync, this.onQuery}) : super.memory();

  final void Function()? onSync;
  final void Function(String sql)? onQuery;

  @override
  Future<List<Map<String, dynamic>>> query(
    String sql, {
    Map<String, dynamic>? named,
    List<dynamic>? positional,
  }) async {
    onQuery?.call(sql);
    return const [];
  }

  @override
  Future<int> execute(
    String sql, {
    Map<String, dynamic>? named,
    List<dynamic>? positional,
  }) async =>
      1;

  @override
  Future<void> sync() async {
    onSync?.call();
  }

  @override
  Future<void> dispose() async {}
}
