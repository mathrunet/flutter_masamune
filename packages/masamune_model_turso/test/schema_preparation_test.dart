import "dart:async";

import "package:flutter_test/flutter_test.dart";
import "package:libsql_dart/libsql_dart.dart";
import "package:masamune/masamune.dart";
import "package:masamune_model_turso/masamune_model_turso.dart";

class _Client extends LibsqlClient {
  _Client() : super.memory();
  int preparations = 0;
  int writes = 0;
  int disposals = 0;
  int activeWrites = 0;
  int peakWrites = 0;
  Completer<void>? writeGate;
  bool failPreparation = false;
  bool missingTable = false;

  @override
  Future<void> connect() async {}
  @override
  Future<void> sync() async {}
  @override
  Future<void> dispose() async {
    disposals++;
  }

  @override
  Future<int> execute(String sql,
      {Map<String, dynamic>? named, List<dynamic>? positional}) async {
    if (sql.startsWith('CREATE TABLE IF NOT EXISTS "items"')) {
      preparations++;
      if (failPreparation) {
        failPreparation = false;
        throw StateError("schema preparation failed");
      }
      missingTable = false;
    }
    if (sql.startsWith('INSERT OR REPLACE INTO "items"')) {
      if (missingTable) {
        throw StateError("no such table: items");
      }
      activeWrites++;
      if (activeWrites > peakWrites) {
        peakWrites = activeWrites;
      }
      await writeGate?.future;
      writes++;
      activeWrites--;
    }
    return 1;
  }

  @override
  Future<List<Map<String, dynamic>>> query(String sql,
      {Map<String, dynamic>? named, List<dynamic>? positional}) async {
    if (sql.startsWith("PRAGMA table_info")) {
      return [
        for (final name in [
          "id",
          "created_at",
          "updated_at",
          "name",
          "flag",
          "extra"
        ])
          {"name": name, "type": "TEXT"},
      ];
    }
    return [];
  }
}

class _Functions extends FunctionsAdapter {
  const _Functions();
  @override
  String get endpoint => "https://example.test";
  @override
  Future<T> execute<T>(FunctionsAction<T> action,
      {Duration timeout = const Duration(seconds: 30)}) async {
    final token = action as TursoTokenFunctionsAction;
    return TursoTokenFunctionsActionResponse(
      token: "fixture",
      expiresAt: DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
      url: "libsql://example.test",
      scopes: token.targets
          .map((scope) => TursoTokenScopeResponse(
                table: scope.table,
                operations: scope.operations,
                readMode: "direct",
                writeMode: "direct",
              ))
          .toList(),
    ) as T;
  }
}

TursoModelAdapter _adapter(TursoDirectClientSession session) =>
    TursoModelAdapter(
        prefix: null,
        functionsAdapter: const _Functions(),
        directClientSession: session);

Future<void> _save(TursoModelAdapter adapter, int id, {bool extra = false}) =>
    adapter.saveDocument(
      ModelAdapterDocumentQuery(
          query:
              DocumentModelQuery("database/main/items/$id", adapter: adapter)),
      {"name": "value", "flag": true, if (extra) "extra": 1},
    );

void main() {
  test("parallel saves use a bounded pool and clear waits for queued writes",
      () async {
    final clients = <_Client>[];
    final gate = Completer<void>();
    final session = TursoDirectClientSession(
      sessionKey: () => "pool-user",
      clientFactory: (_) async {
        final client = _Client()..writeGate = gate;
        clients.add(client);
        return client;
      },
    );
    final adapter = _adapter(session);
    final saves = Future.wait(List.generate(50, (id) => _save(adapter, id)));
    await Future<void>.delayed(const Duration(milliseconds: 30));
    final count = clients.length;
    final clearing = session.clear();
    expect(clients.every((c) => c.disposals == 0), isTrue);
    gate.complete();
    await saves;
    await clearing;
    expect(count, 4);
    expect(clients.fold<int>(0, (sum, c) => sum + c.writes), 50);
    expect(clients.every((c) => c.peakWrites == 1), isTrue);
    expect(clients.every((c) => c.disposals == 1), isTrue);
  });

  test("50 concurrent saves prepare an identical schema once", () async {
    final client = _Client();
    final session = TursoDirectClientSession(
        sessionKey: () => "user",
        maxConnectionsPerDatabase: 1,
        clientFactory: (_) async => client);
    final adapter = _adapter(session);
    await Future.wait(List.generate(50, (id) => _save(adapter, id)));
    expect(client.writes, 50);
    expect(client.preparations, 1);
    await _save(adapter, 51, extra: true);
    expect(client.preparations, 2);
    await session.clear();
  });

  test("a replacement client prepares its own schema", () async {
    final clients = <_Client>[];
    final session = TursoDirectClientSession(
        sessionKey: () => "user",
        clientFactory: (_) async {
          final client = _Client();
          clients.add(client);
          return client;
        });
    final adapter = _adapter(session);
    await _save(adapter, 1);
    await session.clear();
    await _save(adapter, 2);
    expect(clients, hasLength(2));
    expect(clients.map((c) => c.preparations), [1, 1]);
    await session.clear();
  });

  test("failed schema preparation is not cached", () async {
    final client = _Client()..failPreparation = true;
    final session = TursoDirectClientSession(
        sessionKey: () => "user",
        maxConnectionsPerDatabase: 1,
        clientFactory: (_) async => client);
    final adapter = _adapter(session);
    await expectLater(_save(adapter, 1), throwsStateError);
    await _save(adapter, 2);
    expect(client.preparations, 2);
    expect(client.writes, 1);
    await session.clear();
  });

  test(
      "a table dropped after preparation is recreated before retrying the insert",
      () async {
    final client = _Client();
    final session = TursoDirectClientSession(
        sessionKey: () => "user",
        maxConnectionsPerDatabase: 1,
        clientFactory: (_) async => client);
    final adapter = _adapter(session);
    await _save(adapter, 1);
    client.missingTable = true;
    await _save(adapter, 2);
    expect(client.writes, 2);
    expect(client.preparations, 2);
    await session.clear();
  });
}
