// Dart imports:
import "dart:convert";

// Package imports:
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
    return action.execute((_) async => {
          "data": responseForAction?.call(action) ?? responseData,
        });
  }
}
