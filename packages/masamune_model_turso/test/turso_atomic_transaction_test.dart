import "package:flutter_test/flutter_test.dart";
import "package:libsql_dart/libsql_dart.dart";
import "package:masamune/masamune.dart";
import "package:masamune_model_turso/masamune_model_turso.dart";

/// In-memory libsql double with SQLite-like transaction semantics.
///
/// Writes inside `BEGIN IMMEDIATE` are staged and only become visible on
/// `COMMIT`. `ROLLBACK` discards them. Failures can be injected on the n-th
/// user-table write or on `COMMIT`.
class _TransactionalClient extends LibsqlClient {
  _TransactionalClient() : super.memory();

  Map<String, Map<String, Map<String, dynamic>>> committed = {};
  Map<String, Map<String, Map<String, dynamic>>>? _staged;
  final statements = <String>[];
  int userWrites = 0;
  int? failOnUserWrite;
  bool failOnCommit = false;
  int disposals = 0;

  Map<String, Map<String, Map<String, dynamic>>> get _view =>
      _staged ?? committed;

  static Map<String, Map<String, Map<String, dynamic>>> _copy(
    Map<String, Map<String, Map<String, dynamic>>> source,
  ) {
    return source.map(
      (table, rows) => MapEntry(
        table,
        rows.map((id, row) => MapEntry(id, Map<String, dynamic>.of(row))),
      ),
    );
  }

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
    statements.add(sql);
    if (sql == "BEGIN IMMEDIATE" || sql == "BEGIN CONCURRENT") {
      if (_staged != null) {
        throw StateError("cannot start a transaction within a transaction");
      }
      _staged = _copy(committed);
      return 0;
    }
    if (sql == "COMMIT") {
      if (_staged == null) {
        throw StateError("cannot commit - no transaction is active");
      }
      if (failOnCommit) {
        throw StateError("injected commit failure");
      }
      committed = _staged!;
      _staged = null;
      return 0;
    }
    if (sql == "ROLLBACK") {
      if (_staged == null) {
        throw StateError("cannot rollback - no transaction is active");
      }
      _staged = null;
      return 0;
    }
    final create =
        RegExp(r'^CREATE TABLE IF NOT EXISTS "([^"]+)"').firstMatch(sql);
    if (create != null) {
      _view.putIfAbsent(create.group(1)!, () => {});
      return 0;
    }
    final insert = RegExp(r'^INSERT OR REPLACE INTO "([^"]+)" \(([^)]*)\)')
        .firstMatch(sql);
    if (insert != null) {
      final table = insert.group(1)!;
      final columns = insert
          .group(2)!
          .split(",")
          .map((column) => column.trim().replaceAll('"', ""))
          .toList();
      final row = <String, dynamic>{
        for (var i = 0; i < columns.length; i++) columns[i]: positional![i],
      };
      if (!table.startsWith("__")) {
        _injectWriteFailure();
      }
      _view.putIfAbsent(table, () => {})[row["id"] as String] = row;
      return 1;
    }
    final delete = RegExp(r'^DELETE FROM "([^"]+)"').firstMatch(sql);
    if (delete != null) {
      _injectWriteFailure();
      return _view[delete.group(1)!]?.remove(positional!.first) == null ? 0 : 1;
    }
    return 0;
  }

  void _injectWriteFailure() {
    userWrites++;
    if (userWrites == failOnUserWrite) {
      throw StateError("injected failure on write #$userWrites");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> query(String sql,
      {Map<String, dynamic>? named, List<dynamic>? positional}) async {
    statements.add(sql);
    if (sql.startsWith("SELECT 1 FROM sqlite_master")) {
      return _view.containsKey(positional![1])
          ? [
              {"1": 1}
            ]
          : [];
    }
    final select =
        RegExp(r'^SELECT \* FROM "([^"]+)" WHERE "id" = \?').firstMatch(sql);
    if (select != null) {
      final row = _view[select.group(1)!]?[positional!.first];
      return row == null ? [] : [Map<String, dynamic>.of(row)];
    }
    return [];
  }
}

class _Functions extends FunctionsAdapter {
  _Functions({this.readMode = "direct", this.writeMode = "direct"});

  final String readMode;
  final String writeMode;
  final actions = <Object>[];

  @override
  String get endpoint => "https://example.test";

  @override
  Future<T> execute<T>(FunctionsAction<T> action,
      {Duration timeout = const Duration(seconds: 30)}) async {
    final Object raw = action;
    actions.add(raw);
    if (raw is TursoTokenFunctionsAction) {
      return TursoTokenFunctionsActionResponse(
        token: "fixture",
        expiresAt: DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
        url: "libsql://example.test",
        readMode: readMode,
        writeMode: writeMode,
        scopes: raw.targets
            .map((scope) => TursoTokenScopeResponse(
                  table: scope.table,
                  operations: scope.operations,
                  readMode: readMode,
                  writeMode: writeMode,
                ))
            .toList(),
      ) as T;
    }
    throw StateError("Workers CRUD must not be used: ${raw.runtimeType}");
  }

  int get crudRequests =>
      actions.where((action) => action is! TursoTokenFunctionsAction).length;
}

class _Fixture {
  _Fixture({
    String readMode = "direct",
    String writeMode = "direct",
    bool useDirectClient = true,
  }) : functions = _Functions(readMode: readMode, writeMode: writeMode) {
    session = TursoDirectClientSession(
      sessionKey: () => "uid-1",
      maxConnectionsPerDatabase: 1,
      clientFactory: (_) async {
        connections++;
        return client;
      },
    );
    adapter = TursoModelAdapter(
      prefix: null,
      functionsAdapter: functions,
      useDirectClient: useDirectClient,
      directClientSession: session,
      retryDelays: const [],
      cachedRuntimeDatabase: NoSqlDatabase(),
    );
  }

  final _Functions functions;
  final client = _TransactionalClient();
  late final TursoDirectClientSession session;
  late final TursoModelAdapter adapter;
  int connections = 0;

  ModelAdapterDocumentQuery query(String table, String id) =>
      ModelAdapterDocumentQuery(
        query:
            DocumentModelQuery("database/uid-1/$table/$id", adapter: adapter),
      );

  void seed(String table, String id, Map<String, dynamic> row) {
    client.committed.putIfAbsent(table, () => {})[id] = {...row, "id": id};
  }

  Map<String, dynamic>? row(String table, String id) =>
      client.committed[table]?[id];
}

const _tables = ["official_transitions", "outcomes"];

void main() {
  test("reads and writes run on one pinned connection and commit together",
      () async {
    final f = _Fixture();
    final result = await f.adapter.runAtomicTransaction(
      database: "uid-1",
      tables: _tables,
      transaction: (ref) async {
        expect((ref as TursoModelTransactionRef).isAtomic, isTrue);
        final current = await f.adapter
            .loadOnTransaction(ref, f.query("official_transitions", "r1"));
        expect(current, isEmpty);
        f.adapter.saveOnTransaction(ref, f.query("official_transitions", "r1"),
            {"launch_state": "prepared"});
        f.adapter.saveOnTransaction(
            ref, f.query("outcomes", "v1"), {"state": "unrecorded"});
        return "done";
      },
    );
    expect(result, "done");
    expect(f.row("official_transitions", "r1")?["launch_state"], "prepared");
    expect(f.row("outcomes", "v1")?["state"], "unrecorded");
    expect(f.connections, 1);
    expect(f.functions.crudRequests, 0);
    final begin = f.client.statements.indexOf("BEGIN IMMEDIATE");
    final read = f.client.statements
        .indexWhere((sql) => sql.startsWith("SELECT 1 FROM sqlite_master"));
    final commit = f.client.statements.indexOf("COMMIT");
    expect(begin, greaterThanOrEqualTo(0));
    expect(read, greaterThan(begin));
    expect(commit, greaterThan(read));
    await f.session.clear();
  });

  test("a failure on the second write rolls back the first write", () async {
    final f = _Fixture();
    f.client.failOnUserWrite = 2;
    await expectLater(
      f.adapter.runAtomicTransaction(
        database: "uid-1",
        tables: _tables,
        transaction: (ref) {
          f.adapter.saveOnTransaction(
              ref,
              f.query("official_transitions", "r1"),
              {"launch_state": "prepared"});
          f.adapter.saveOnTransaction(
              ref, f.query("outcomes", "v1"), {"state": "unrecorded"});
        },
      ),
      throwsA(isA<StateError>()),
    );
    expect(f.client.userWrites, 2);
    expect(f.row("official_transitions", "r1"), isNull);
    expect(f.row("outcomes", "v1"), isNull);
    expect(f.client.statements, contains("ROLLBACK"));
    expect(f.client.statements, isNot(contains("COMMIT")));
    expect(f.functions.crudRequests, 0);
    await f.session.clear();
  });

  test("a failure while cancelling keeps both the prepared state and outcome",
      () async {
    final f = _Fixture();
    f.seed("official_transitions", "r1", {"launch_state": "prepared"});
    f.seed("outcomes", "v1", {"state": "unrecorded", "last": "r1"});
    f.client.failOnUserWrite = 2;
    await expectLater(
      f.adapter.runAtomicTransaction(
        database: "uid-1",
        tables: _tables,
        transaction: (ref) async {
          final transition = await f.adapter
              .loadOnTransaction(ref, f.query("official_transitions", "r1"));
          final outcome =
              await f.adapter.loadOnTransaction(ref, f.query("outcomes", "v1"));
          expect(transition["launch_state"], "prepared");
          expect(outcome["last"], "r1");
          f.adapter.saveOnTransaction(
              ref,
              f.query("official_transitions", "r1"),
              {"launch_state": "failed"});
          f.adapter.deleteOnTransaction(ref, f.query("outcomes", "v1"));
        },
      ),
      throwsA(isA<StateError>()),
    );
    expect(f.row("official_transitions", "r1")?["launch_state"], "prepared");
    expect(f.row("outcomes", "v1")?["state"], "unrecorded");
    expect(f.functions.crudRequests, 0);
    await f.session.clear();
  });

  test("an exception thrown by the callback sends no write", () async {
    final f = _Fixture();
    await expectLater(
      f.adapter.runAtomicTransaction(
        database: "uid-1",
        tables: _tables,
        transaction: (ref) {
          f.adapter.saveOnTransaction(
              ref,
              f.query("official_transitions", "r1"),
              {"launch_state": "prepared"});
          throw StateError("callback failure");
        },
      ),
      throwsA(isA<StateError>()),
    );
    expect(f.client.userWrites, 0);
    expect(f.client.statements, contains("ROLLBACK"));
    expect(f.row("official_transitions", "r1"), isNull);
    await f.session.clear();
  });

  test("a commit failure is rethrown and leaves nothing behind", () async {
    final f = _Fixture();
    f.client.failOnCommit = true;
    await expectLater(
      f.adapter.runAtomicTransaction(
        database: "uid-1",
        tables: _tables,
        transaction: (ref) {
          f.adapter.saveOnTransaction(
              ref,
              f.query("official_transitions", "r1"),
              {"launch_state": "prepared"});
          f.adapter.saveOnTransaction(
              ref, f.query("outcomes", "v1"), {"state": "unrecorded"});
        },
      ),
      throwsA(isA<StateError>()),
    );
    expect(f.client.statements, contains("ROLLBACK"));
    expect(f.client.committed["official_transitions"], isNull);
    expect(f.client.committed["outcomes"], isNull);
    await f.session.clear();
  });

  for (final mode in [
    (read: "direct", write: "functions"),
    (read: "functions", write: "direct"),
    (read: "direct", write: "none"),
  ]) {
    test(
        "a token with read=${mode.read} write=${mode.write} is rejected before any read or write",
        () async {
      final f = _Fixture(readMode: mode.read, writeMode: mode.write);
      var called = false;
      await expectLater(
        f.adapter.runAtomicTransaction(
          database: "uid-1",
          tables: _tables,
          transaction: (ref) {
            called = true;
            f.adapter.saveOnTransaction(ref,
                f.query("official_transitions", "r1"), {"launch_state": "x"});
          },
        ),
        throwsA(isA<TursoAtomicTransactionUnavailableException>().having(
          (e) => e.reason,
          "reason",
          mode.read == "functions" || mode.write == "functions"
              ? TursoAtomicTransactionUnavailableReason.functionsMode
              : TursoAtomicTransactionUnavailableReason.accessDenied,
        )),
      );
      expect(called, isFalse);
      expect(f.connections, 0);
      expect(f.client.statements, isEmpty);
      expect(f.functions.crudRequests, 0);
      expect(f.functions.actions.whereType<TursoTokenFunctionsAction>(),
          hasLength(1));
      await f.session.clear();
    });
  }

  test("useDirectClient: false is rejected without any request", () async {
    final f = _Fixture(useDirectClient: false);
    await expectLater(
      f.adapter.runAtomicTransaction(
        database: "uid-1",
        tables: _tables,
        transaction: (ref) {},
      ),
      throwsA(isA<TursoAtomicTransactionUnavailableException>().having(
        (e) => e.reason,
        "reason",
        TursoAtomicTransactionUnavailableReason.directClientDisabled,
      )),
    );
    expect(f.functions.actions, isEmpty);
    expect(f.connections, 0);
  });

  test("the shared adapter is rejected without any request", () async {
    final functions = _Functions();
    final adapter = TursoModelAdapter.shared(
      functionsAdapter: functions,
      cachedRuntimeDatabase: NoSqlDatabase(),
    );
    await expectLater(
      adapter.runAtomicTransaction(
        database: "shared",
        tables: _tables,
        transaction: (ref) {},
      ),
      throwsA(isA<TursoAtomicTransactionUnavailableException>().having(
        (e) => e.reason,
        "reason",
        TursoAtomicTransactionUnavailableReason.sharedDatabase,
      )),
    );
    expect(functions.actions, isEmpty);
  });

  test("an undeclared table is rejected and the transaction is rolled back",
      () async {
    final f = _Fixture();
    await expectLater(
      f.adapter.runAtomicTransaction(
        database: "uid-1",
        tables: const ["outcomes"],
        transaction: (ref) {
          f.adapter.saveOnTransaction(
              ref, f.query("outcomes", "v1"), {"state": "unrecorded"});
          f.adapter.saveOnTransaction(ref,
              f.query("official_transitions", "r1"), {"launch_state": "x"});
        },
      ),
      throwsArgumentError,
    );
    expect(f.client.userWrites, 0);
    expect(f.row("outcomes", "v1"), isNull);
    await f.session.clear();
  });

  test("a read after a write is rejected and rolled back", () async {
    final f = _Fixture();
    await expectLater(
      f.adapter.runAtomicTransaction(
        database: "uid-1",
        tables: _tables,
        transaction: (ref) async {
          f.adapter.saveOnTransaction(
              ref, f.query("outcomes", "v1"), {"state": "unrecorded"});
          await f.adapter
              .loadOnTransaction(ref, f.query("official_transitions", "r1"));
        },
      ),
      throwsStateError,
    );
    expect(f.row("outcomes", "v1"), isNull);
    await f.session.clear();
  });

  test("the general runTransaction keeps its existing behavior", () async {
    final f = _Fixture();
    await f.adapter.runTransaction((ref) {
      expect((ref as TursoModelTransactionRef).isAtomic, isFalse);
      f.adapter.saveOnTransaction(
          ref, f.query("outcomes", "v1"), {"state": "unrecorded"});
    });
    expect(f.row("outcomes", "v1")?["state"], "unrecorded");
    await f.session.clear();
  });
}
