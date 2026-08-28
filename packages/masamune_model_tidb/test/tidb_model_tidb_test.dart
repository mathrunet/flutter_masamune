// Dart imports:
import "dart:convert";

// Flutter imports:
import "package:flutter/foundation.dart";

// Package imports:
import "package:masamune/masamune.dart";
import "package:test/test.dart";

// Project imports:
import "package:masamune_model_tidb/masamune_model_tidb.dart";

void main() {
  test("ModelQueryBase uses the resolved adapter auto-dispose default.", () {
    const adapter = TidbModelAdapter(
      defaultAutoDisposeWhenUnreferenced: true,
    );
    const query = _TestModelQuery(
      DocumentModelQuery(
        "database/test/users/user_1",
        adapter: adapter,
      ),
    );

    expect(query.primaryAdapter, same(adapter));
    expect(query.autoDisposeWhenUnreferenced, true);

    final appRef = AppRef();
    final model = appRef.model(
      query,
      autoDisposeWhenUnreferenced: null,
    );
    expect(
      appRef.model(query, autoDisposeWhenUnreferenced: true),
      same(model),
    );
    expect(
      appRef.model(query, autoDisposeWhenUnreferenced: false),
      same(model),
    );
  });

  test("TidbGetModelFunctionsAction builds path based URL.", () {
    final action = TidbGetModelFunctionsAction(
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
    expect(uri.path, "tidb/database/main/users/user_1");
    expect(uri.queryParameters["limit"], "10");
    final where = jsonDecode(uri.queryParameters["where"]!) as List;
    final orderBy = jsonDecode(uri.queryParameters["orderBy"]!) as List;
    expect(where, hasLength(2));
    expect(where[1]["key"], "id");
    expect(orderBy, hasLength(1));
    expect(orderBy.single["key"], "updated_at");
  });

  test("Tidb prefix is normalized and serialized.", () {
    final get = TidbGetModelFunctionsAction(
      database: "main",
      table: "users",
      prefix: " dev___ ",
    );
    const post = TidbPostModelFunctionsAction(
      database: "main",
      table: "users",
      prefix: "dev",
      value: {"name": "Alice"},
    );
    const empty = TidbDeleteModelFunctionsAction(
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
      () => const TidbModelAdapter(prefix: "invalid prefix").prefix,
      throwsArgumentError,
    );
  });

  test("Tidb write FunctionsActions build path based URLs.", () {
    const post = TidbPostModelFunctionsAction(
      database: "main",
      table: "users",
      indexKey: "user_1",
      value: {
        "name": "Alice",
        "isActive": true,
        kUidFieldKey: "ignored",
        kTimeFieldKey: 1000,
      },
    );
    const put = TidbPutModelFunctionsAction(
      database: "main",
      table: "users",
      indexKey: "user_1",
      where: [
        {"type": "equalTo", "key": kUidFieldKey, "value": "user_1"},
      ],
      value: {
        "name": "Alice",
        "isActive": false,
        kUidFieldKey: "ignored",
        kTimeFieldKey: 1000,
      },
    );
    const delete = TidbDeleteModelFunctionsAction(
      database: "main",
      table: "users",
      indexKey: "user_1",
    );

    expect(post.path, "tidb/database/main/users/user_1");
    expect(post.toMap(), {
      "value": {"name": "Alice", "isActive": true},
    });
    expect(put.path, "tidb/database/main/users/user_1");
    expect(put.toMap(), {
      "where": [
        {"type": "equalTo", "key": "id", "value": "user_1"},
      ],
      "value": {"name": "Alice", "isActive": false},
    });
    expect(delete.path, "tidb/database/main/users/user_1");
    expect(delete.toMap(), isEmpty);
  });

  test("TidbModelAdapter saves through POST without a preflight GET.",
      () async {
    final functionsAdapter = _RecordingFunctionsAdapter();
    final adapter = TidbModelAdapter(
      functionsAdapter: functionsAdapter,
    );
    const query = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/user/user_1"),
    );

    await adapter.saveDocument(query, {
      "name": "Alice",
      "age": 20,
      "isActive": true,
      kUidFieldKey: "ignored",
      kTimeFieldKey: 1000,
    });

    expect(functionsAdapter.actions, hasLength(1));
    final action = functionsAdapter.actions.single;
    expect(action, isA<TidbPostModelFunctionsAction>());
    expect(action, isNot(isA<TidbGetModelFunctionsAction>()));
    final post = action as TidbPostModelFunctionsAction;
    expect(post.path, "tidb/database/test/user");
    expect(post.indexKey, isNull);
    expect(post.value["id"], "user_1");
    expect(post.value["name"], "Alice");
    expect(post.value["age"], 20);
    expect(post.value["isActive"], true);
    expect(post.value.containsKey(kUidFieldKey), false);
    expect(post.value.containsKey(kTimeFieldKey), false);
  });

  test("TidbModelAdapter restores uid and time fields on load.", () async {
    final functionsAdapter = _RecordingFunctionsAdapter(
      responseData: const [
        {
          "id": "user_1",
          "name": "Alice",
          "isActive": 0,
          "updated_at": 1234,
        },
      ],
    );
    final adapter = TidbModelAdapter(
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
    expect(document["isActive"], false);
    expect(collection["user_1"]?[kUidFieldKey], "user_1");
    expect(collection["user_1"]?[kTimeFieldKey], 1234);
    expect(collection["user_1"]?["isActive"], false);
  });

  test("TidbModelAdapter isolates shared cache by prefix.", () async {
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
    final dev = TidbModelAdapter(
      functionsAdapter: devFunctions,
      cachedRuntimeDatabase: cache,
      prefix: "dev",
    );
    final prod = TidbModelAdapter(
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

  test("TidbModelAdapter preloads references with one whereIn query.",
      () async {
    final functionsAdapter = _RecordingFunctionsAdapter(
      responseForAction: (action) {
        if (action is! TidbGetModelFunctionsAction) {
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
    final adapter = TidbModelAdapter(
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
        functionsAdapter.actions.whereType<TidbGetModelFunctionsAction>();
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

  test("TidbModelAdapter preloads references by table.", () async {
    final functionsAdapter = _RecordingFunctionsAdapter(
      responseForAction: (action) {
        if (action is! TidbGetModelFunctionsAction) {
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
    final adapter = TidbModelAdapter(
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
        functionsAdapter.actions.whereType<TidbGetModelFunctionsAction>();
    expect(getActions.map((action) => action.table), [
      "users",
      "organizations",
    ]);
  });

  test("TidbQueryPayload converts supported model filters.", () {
    final payload = TidbQueryPayload.fromFilters(const [
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

  test("CachedTidbModelAdapter loads documents from persistent cache.",
      () async {
    final localDatabase = NoSqlDatabase();
    final firstFunctions = _RecordingFunctionsAdapter(
      responseData: const [
        {"id": "user_1", "name": "Alice"},
      ],
    );
    final firstAdapter = CachedTidbModelAdapter(
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
    final secondAdapter = CachedTidbModelAdapter(
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

  test("CachedTidbModelAdapter merges collection cache and remote data.",
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
    final adapter = CachedTidbModelAdapter(
      functionsAdapter: functionsAdapter,
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
      collectionLoaders: [
        (query, _) async {
          return CachedTidbModelCollectionLoaderResponse(
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

  test("CachedTidbModelAdapter can satisfy collection loads from cache.",
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
    final adapter = CachedTidbModelAdapter(
      functionsAdapter: functionsAdapter,
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
      collectionLoaders: [
        (query, _) async {
          return CachedTidbModelCollectionLoaderResponse(
            value: await localDatabase.loadCollection(query) ?? {},
          );
        },
      ],
    );

    expect((await adapter.loadCollection(query))["user_1"]?["name"], "Alice");
    expect(functionsAdapter.actions, isEmpty);
  });

  test("CachedTidbModelAdapter applies cacheFilter.", () async {
    final localDatabase = NoSqlDatabase();
    final adapter = CachedTidbModelAdapter(
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

  test("CachedTidbModelAdapter isolates persistent cache by prefix.", () async {
    final localDatabase = NoSqlDatabase();
    const query = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/users/user_1"),
    );
    final dev = CachedTidbModelAdapter(
      prefix: "dev",
      functionsAdapter: _RecordingFunctionsAdapter(
        responseData: const [
          {"id": "user_1", "name": "Development"},
        ],
      ),
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
    );
    final prod = CachedTidbModelAdapter(
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
    final cachedDev = CachedTidbModelAdapter(
      prefix: "dev",
      functionsAdapter: cachedDevFunctions,
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
    );
    final cachedProd = CachedTidbModelAdapter(
      functionsAdapter: cachedProdFunctions,
      cachedRuntimeDatabase: NoSqlDatabase(),
      cachedLocalDatabase: localDatabase,
    );

    expect((await cachedDev.loadDocument(query))["name"], "Development");
    expect((await cachedProd.loadDocument(query))["name"], "Production");
    expect(cachedDevFunctions.actions, isEmpty);
    expect(cachedProdFunctions.actions, isEmpty);
  });

  test("CachedTidbModelAdapter syncs saves, batches, deletes, and clear.",
      () async {
    final localDatabase = NoSqlDatabase();
    final adapter = CachedTidbModelAdapter(
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

class _TestModelQuery extends ModelQueryBase<ChangeNotifier> {
  const _TestModelQuery(this.modelQuery);

  @override
  final DocumentModelQuery modelQuery;

  @override
  ChangeNotifier Function() call(Ref ref) => ChangeNotifier.new;
}

class _RecordingFunctionsAdapter extends FunctionsAdapter {
  _RecordingFunctionsAdapter({
    this.responseData = const [],
    this.responseForAction,
  });

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
    return action.execute((_) async => {
          "data": responseForAction?.call(action) ?? responseData,
        });
  }
}
