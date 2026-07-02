// Dart imports:
import "dart:convert";

// Package imports:
import "package:masamune/masamune.dart";
import "package:test/test.dart";

// Project imports:
import "package:masamune_model_tidb/masamune_model_tidb.dart";

void main() {
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

  test("Tidb write FunctionsActions build path based URLs.", () {
    const post = TidbPostModelFunctionsAction(
      database: "main",
      table: "users",
      indexKey: "user_1",
      value: {
        "name": "Alice",
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
      "value": {"name": "Alice"},
    });
    expect(put.path, "tidb/database/main/users/user_1");
    expect(put.toMap(), {
      "where": [
        {"type": "equalTo", "key": "id", "value": "user_1"},
      ],
      "value": {"name": "Alice"},
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
    expect(post.value.containsKey(kUidFieldKey), false);
    expect(post.value.containsKey(kTimeFieldKey), false);
  });

  test("TidbModelAdapter restores uid and time fields on load.", () async {
    final functionsAdapter = _RecordingFunctionsAdapter(
      responseData: const [
        {
          "id": "user_1",
          "name": "Alice",
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
    expect(collection["user_1"]?[kUidFieldKey], "user_1");
    expect(collection["user_1"]?[kTimeFieldKey], 1234);
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
