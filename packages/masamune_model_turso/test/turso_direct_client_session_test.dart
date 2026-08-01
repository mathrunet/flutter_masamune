// ignore_for_file: depend_on_referenced_packages

// Dart imports:
import "dart:async";

// Package imports:
import "package:flutter_test/flutter_test.dart";
import "package:katana_functions/katana_functions.dart";
import "package:katana_model/katana_model.dart";
import "package:libsql_dart/libsql_dart.dart";
import "package:masamune_model_turso/masamune_model_turso.dart";

/// A [LibsqlClient] that never touches the Rust bridge.
///
/// [LibsqlClient.connect] initializes `RustLib`, so every entry point that
/// would reach native code is overridden here.
class _FakeLibsqlClient extends LibsqlClient {
  _FakeLibsqlClient() : super.memory();

  int disposeCount = 0;

  /// Blocks every [query] until completed. Used to keep a caller in flight.
  Completer<void>? queryGate;

  @override
  Future<void> connect() async {}

  @override
  Future<void> sync() async {}

  @override
  Future<List<Map<String, dynamic>>> query(
    String sql, {
    Map<String, dynamic>? named,
    List<dynamic>? positional,
  }) async {
    await queryGate?.future;
    return const [];
  }

  @override
  Future<void> dispose() async {
    disposeCount++;
  }
}

/// Issues direct-mode tokens covering exactly the requested targets.
class _FakeFunctionsAdapter extends FunctionsAdapter {
  const _FakeFunctionsAdapter();

  @override
  String get endpoint => "https://example.test";

  @override
  Future<TResponse> execute<TResponse>(
    FunctionsAction<TResponse> action, {
    Duration timeout = const Duration(seconds: 30),
  }) async {
    // `action` cannot be promoted directly because `TResponse` is a type
    // variable, so widen to `Object` first.
    final Object raw = action;
    final targets = raw is TursoTokenFunctionsAction
        ? raw.targets
        : const <TursoTokenScope>[];
    return TursoTokenFunctionsActionResponse(
      token: "token",
      // Far enough in the future to stay valid for the whole test.
      expiresAt: DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
      url: "libsql://example.test",
      scopes: targets
          .map(
            (target) => TursoTokenScopeResponse(
              table: target.table,
              operations: target.operations,
              readMode: "direct",
              writeMode: "direct",
            ),
          )
          .toList(),
    ) as TResponse;
  }
}

const _scopes = [
  TursoTokenScope(table: "items", operations: ["read", "write"]),
];

/// Exactly the scopes `loadDocument` requests.
///
/// Prewarming with these keeps the cached token valid for the subsequent load,
/// so the load reuses the cached client instead of triggering a token refresh
/// (which legitimately replaces the client).
const _documentLoadScopes = [
  TursoTokenScope(table: "items", operations: ["read"]),
  TursoTokenScope(table: "__masamune_turso_schema", operations: ["read"]),
];

TursoModelAdapter _adapter(TursoDirectClientSession session) {
  return TursoModelAdapter(
    functionsAdapter: const _FakeFunctionsAdapter(),
    directClientSession: session,
  );
}

void main() {
  test("clear() waits for an in-flight query before disposing the client",
      () async {
    final client = _FakeLibsqlClient();
    final session = TursoDirectClientSession(
      sessionKey: () => "user",
      clientFactory: (_) async => client,
    );
    final adapter = _adapter(session);

    // Open and cache the client first, so the disposal below races against a
    // query rather than against the connection itself.
    await adapter.prewarm(database: "inflight", scopes: _documentLoadScopes);
    expect(client.disposeCount, 0);

    // Hold the next caller inside `client.query`.
    client.queryGate = Completer<void>();
    final load = adapter.loadDocument(
      ModelAdapterDocumentQuery(
        query: DocumentModelQuery(
          "database/inflight/items/item",
          adapter: adapter,
        ),
      ),
    );
    await pumpEventQueue();

    final cleared = session.clear();
    await pumpEventQueue();
    expect(
      client.disposeCount,
      0,
      reason: "The client must not be disposed while a query is running.",
    );

    client.queryGate!.complete();
    await load;
    await cleared;

    expect(client.disposeCount, 1);
  });

  test("clear() waits for a caller that is still connecting", () async {
    final client = _FakeLibsqlClient();
    final connected = Completer<LibsqlClient>();
    final session = TursoDirectClientSession(
      sessionKey: () => "user",
      clientFactory: (_) => connected.future,
    );
    final adapter = _adapter(session);

    final prewarm = adapter.prewarm(database: "connecting", scopes: _scopes);
    await pumpEventQueue();

    final cleared = session.clear();
    await pumpEventQueue();
    expect(client.disposeCount, 0);

    connected.complete(client);
    await prewarm;
    await cleared;

    expect(client.disposeCount, 1);
  });

  test("clear() disposes an idle client immediately", () async {
    final client = _FakeLibsqlClient();
    final session = TursoDirectClientSession(
      sessionKey: () => "user",
      clientFactory: (_) async => client,
    );
    final adapter = _adapter(session);

    await adapter.prewarm(database: "idle", scopes: _scopes);
    expect(client.disposeCount, 0);

    await session.clear();
    expect(client.disposeCount, 1);
  });

  test("clear() gives up waiting once the grace period expires", () async {
    final client = _FakeLibsqlClient();
    final connected = Completer<LibsqlClient>();
    final session = TursoDirectClientSession(
      sessionKey: () => "user",
      disposeGracePeriod: const Duration(milliseconds: 50),
      clientFactory: (_) => connected.future,
    );
    final adapter = _adapter(session);

    // Never completes, emulating a hung connection.
    adapter.prewarm(database: "hung", scopes: _scopes).ignore();
    await pumpEventQueue();

    // Must return instead of blocking forever on the pending caller.
    await session.clear().timeout(const Duration(seconds: 5));

    // The client is still disposed once the connection eventually settles.
    connected.complete(client);
    await pumpEventQueue();
    expect(client.disposeCount, 1);
  });

  test("a caller that starts after clear() opens a fresh client", () async {
    final clients = <_FakeLibsqlClient>[];
    final session = TursoDirectClientSession(
      sessionKey: () => "user",
      clientFactory: (_) async {
        final client = _FakeLibsqlClient();
        clients.add(client);
        return client;
      },
    );
    final adapter = _adapter(session);

    await adapter.prewarm(database: "reopen", scopes: _scopes);
    await session.clear();
    await adapter.prewarm(database: "reopen", scopes: _scopes);

    expect(clients, hasLength(2));
    expect(clients.first.disposeCount, 1);
    expect(clients.last.disposeCount, 0);
  });
}
