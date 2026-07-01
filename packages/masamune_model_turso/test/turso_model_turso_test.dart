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
      ],
      orderBy: const [
        {"key": "created_at", "descending": true},
      ],
      limit: 10,
    );

    final uri = Uri.parse(action.path);
    expect(uri.path, "turso/database/main/users/user_1");
    expect(uri.queryParameters["limit"], "10");
    expect(jsonDecode(uri.queryParameters["where"]!) as List, hasLength(1));
    expect(jsonDecode(uri.queryParameters["orderBy"]!) as List, hasLength(1));
  });

  test("Turso write FunctionsActions build path based URLs.", () {
    const post = TursoPostModelFunctionsAction(
      database: "main",
      table: "users",
      indexKey: "user_1",
      value: {"name": "Alice"},
    );
    const put = TursoPutModelFunctionsAction(
      database: "main",
      table: "users",
      indexKey: "user_1",
      value: {"name": "Alice"},
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
      "value": {"name": "Alice"},
    });
    expect(delete.path, "turso/database/main/users/user_1");
    expect(delete.toMap(), isEmpty);
  });

  test("TursoModelAdapter saves through POST without a preflight GET.",
      () async {
    final functionsAdapter = _RecordingFunctionsAdapter();
    final adapter = TursoModelAdapter(functionsAdapter: functionsAdapter);
    const query = ModelAdapterDocumentQuery(
      query: DocumentModelQuery("database/test/user/user_1"),
    );

    await adapter.saveDocument(query, {
      "name": "Alice",
      "age": 20,
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
  });

  test("TursoQueryPayload converts supported model filters.", () {
    final payload = TursoQueryPayload.fromFilters(const [
      ModelQueryFilter.equal(key: "name", value: "Alice"),
      ModelQueryFilter.greaterThanOrEqual(key: "score", value: 10),
      ModelQueryFilter.orderByDesc(key: "created_at"),
      ModelQueryFilter.limitTo(value: 20),
    ]);

    expect(payload.where, hasLength(2));
    expect(payload.where[0]["type"], "equalTo");
    expect(payload.where[1]["type"], "greaterThanOrEqualTo");
    expect(payload.orderBy.single["key"], "created_at");
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
  _RecordingFunctionsAdapter();

  final List<FunctionsAction<dynamic>> actions = [];

  @override
  String get endpoint => "";

  @override
  Future<TResponse> execute<TResponse>(
    FunctionsAction<TResponse> action,
  ) {
    actions.add(action);
    return action.execute((_) async => {"data": []});
  }
}
