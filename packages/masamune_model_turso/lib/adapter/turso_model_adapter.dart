part of "/masamune_model_turso.dart";

const _fallbackTokenResponse = TursoTokenFunctionsActionResponse(
  token: "",
  expiresAt: 0,
  readMode: "functions",
  writeMode: "functions",
);

const _tursoRetryDelays = [
  Duration(milliseconds: 250),
  Duration(milliseconds: 500),
  Duration(seconds: 1),
  Duration(seconds: 2),
  Duration(seconds: 4),
  Duration(seconds: 8),
];

const _tursoSchemaTable = "__masamune_turso_schema";

final Map<String, Set<String>> _tursoBoolFieldsCache = {};

/// Timing breakdown for a Turso prewarm.
///
/// Turso prewarmの処理時間内訳。
class TursoPrewarmResult {
  /// Creates a prewarm timing result.
  ///
  /// prewarmの処理時間内訳を作成します。
  const TursoPrewarmResult({
    required this.routeDuration,
    required this.replicaDuration,
    required this.totalDuration,
  });

  /// Time spent resolving permissions and a direct token.
  ///
  /// 権限と直接接続トークンの解決に要した時間。
  final Duration routeDuration;

  /// Time spent opening and synchronizing the embedded replica.
  ///
  /// Embedded Replicaの接続と同期に要した時間。
  final Duration replicaDuration;

  /// Total prewarm duration.
  ///
  /// prewarm全体の処理時間。
  final Duration totalDuration;
}

/// A reusable authenticated direct connection session for Turso.
///
/// Tokens and connected clients are isolated by the value returned from
/// [sessionKey]. Return `null` while no authenticated session is available;
/// those requests continue to use one-shot tokens and clients.
///
/// Tursoの認証済み直接接続を再利用するセッション。
///
/// トークンと接続済みクライアントは[sessionKey]の戻り値ごとに分離されます。
/// 認証セッションがない間は`null`を返してください。その場合は従来どおり
/// リクエストごとにトークンとクライアントを作成します。
class TursoDirectClientSession {
  /// Creates a reusable Turso direct connection session.
  ///
  /// Tursoの直接接続を再利用するセッションを作成します。
  TursoDirectClientSession({
    required this.sessionKey,
    this.expirationMargin = const Duration(seconds: 30),
    this.disposeGracePeriod = const Duration(seconds: 5),
    this.useEmbeddedReplica = true,
    this.clientFactory,
  });

  /// Returns a stable key for the current authenticated user/session.
  ///
  /// 現在の認証ユーザー・セッションを識別する安定したキーを返します。
  final String? Function() sessionKey;

  /// Margin before token expiration at which a new token is requested.
  ///
  /// 有効期限より前に新しいトークンへ更新するための猶予時間。
  final Duration expirationMargin;

  /// Maximum time a disposal waits for in-flight callers to finish.
  ///
  /// A cached client is shared by every concurrent caller, so disposing it
  /// while a query is still running drops the underlying Rust object and
  /// raises `DroppableDisposedException`. Disposal therefore waits until the
  /// client becomes idle, and this duration bounds that wait so a hung query
  /// cannot leak the client forever.
  ///
  /// 破棄処理が実行中の呼び出しの完了を待つ最大時間。
  ///
  /// キャッシュされたクライアントは同時実行中の全呼び出し元で共有されるため、
  /// クエリの実行中に破棄するとRust側のオブジェクトが解放され
  /// `DroppableDisposedException`が発生します。そのため破棄はクライアントが
  /// アイドルになるまで待機します。この時間で待機を打ち切ることで、クエリが
  /// ハングした場合にクライアントが解放されなくなることを防ぎます。
  final Duration disposeGracePeriod;

  /// Whether direct clients use an on-device embedded replica.
  ///
  /// 直接接続クライアントで端末内のEmbedded Replicaを利用するかどうか。
  final bool useEmbeddedReplica;

  /// Overrides direct client creation.
  ///
  /// 直接接続クライアントの生成処理を上書きします。
  final Future<LibsqlClient> Function(
    TursoTokenFunctionsActionResponse token,
  )? clientFactory;

  final Map<String, _TursoDirectDatabaseSession> _databases = {};
  String? _activeSessionKey;

  Future<TursoTokenFunctionsActionResponse> _resolve({
    required String connectionKey,
    required String database,
    required String? prefix,
    required List<TursoTokenScope> scopes,
    required Future<TursoTokenFunctionsActionResponse> Function(
      List<TursoTokenScope> scopes,
    ) loader,
  }) async {
    final currentSessionKey = sessionKey();
    if (currentSessionKey == null || currentSessionKey.isEmpty) {
      return await loader(scopes);
    }
    await _activate(currentSessionKey);
    final key = _cacheKey(
      sessionKey: currentSessionKey,
      connectionKey: connectionKey,
      database: database,
      prefix: prefix,
    );
    final state = _databases.putIfAbsent(
      key,
      () => _TursoDirectDatabaseSession(
        key: key,
        database: database,
        prefix: prefix,
      ),
    );
    final mergedScopes = _mergeSessionScopes([...state.scopes, ...scopes]);
    final resolved = state.resolved;
    if (resolved != null &&
        _coversScopes(resolved, scopes) &&
        (_isValid(resolved) || !_hasDirectMode(resolved))) {
      return resolved;
    }
    final pending = state.resolving;
    if (pending != null && _sameScopes(state.scopes, mergedScopes)) {
      return await pending;
    }
    state.scopes = mergedScopes;
    final future = loader(mergedScopes);
    state.resolving = future;
    try {
      final token = await future;
      state.resolved = token;
      if (state.client != null) {
        await _disposeClient(state);
      }
      return token;
    } catch (_) {
      state.resolved = null;
      rethrow;
    } finally {
      if (identical(state.resolving, future)) {
        state.resolving = null;
      }
    }
  }

  String? _cachedMode({
    required String connectionKey,
    required String database,
    required String? prefix,
    required List<TursoTokenScope> scopes,
    required bool write,
  }) {
    final currentSessionKey = sessionKey();
    if (currentSessionKey == null ||
        currentSessionKey.isEmpty ||
        _activeSessionKey != currentSessionKey) {
      return null;
    }
    final key = _cacheKey(
      sessionKey: currentSessionKey,
      connectionKey: connectionKey,
      database: database,
      prefix: prefix,
    );
    final resolved = _databases[key]?.resolved;
    if (resolved == null || !_coversScopes(resolved, scopes)) {
      return null;
    }
    if (_hasDirectMode(resolved) && !_isValid(resolved)) {
      return null;
    }
    return _modeFor(resolved, scopes, write: write);
  }

  Future<T> _run<T>({
    required String connectionKey,
    required String database,
    required String? prefix,
    required TursoTokenFunctionsActionResponse token,
    required bool write,
    required Future<T> Function(LibsqlClient client) callback,
  }) async {
    final currentSessionKey = sessionKey();
    if (currentSessionKey == null || currentSessionKey.isEmpty) {
      final client = await _connect(token, null);
      try {
        final result = await callback(client);
        if (write && useEmbeddedReplica) {
          await client.sync();
        }
        return result;
      } finally {
        await client.dispose();
      }
    }
    await _activate(currentSessionKey);
    final key = _cacheKey(
      sessionKey: currentSessionKey,
      connectionKey: connectionKey,
      database: database,
      prefix: prefix,
    );
    final state = _databases.putIfAbsent(
      key,
      () => _TursoDirectDatabaseSession(
        key: key,
        database: database,
        prefix: prefix,
      ),
    );
    final handle = state.client ??= _TursoDirectClientHandle(
      _connect(token, key),
    );
    // Retain before awaiting so a concurrent `clear()` cannot dispose the
    // shared client while this caller is still connecting or querying.
    handle.retain();
    var released = false;
    try {
      final client = await handle.client;
      final result = await callback(client);
      if (write && useEmbeddedReplica) {
        await client.sync();
      }
      return result;
    } catch (_) {
      if (identical(state.client, handle)) {
        state.client = null;
      }
      // Release before disposing. `_disposeHandle` waits for the handle to
      // become idle, so holding this caller's own retain would deadlock.
      handle.release();
      released = true;
      await _disposeHandle(handle);
      rethrow;
    } finally {
      if (!released) {
        handle.release();
      }
    }
  }

  Future<void> _sync({
    required String connectionKey,
    required String database,
    required String? prefix,
  }) async {
    if (!useEmbeddedReplica) {
      return;
    }
    final currentSessionKey = sessionKey();
    if (currentSessionKey == null ||
        currentSessionKey.isEmpty ||
        _activeSessionKey != currentSessionKey) {
      return;
    }
    final key = _cacheKey(
      sessionKey: currentSessionKey,
      connectionKey: connectionKey,
      database: database,
      prefix: prefix,
    );
    final state = _databases[key];
    final resolved = state?.resolved;
    if (state == null ||
        resolved == null ||
        resolved.token.isEmpty ||
        resolved.url.isEmpty ||
        !_isValid(resolved)) {
      return;
    }
    final handle = state.client ??= _TursoDirectClientHandle(
      _connect(resolved, key),
    );
    handle.retain();
    try {
      final client = await handle.client;
      await client.sync();
    } finally {
      handle.release();
    }
  }

  /// Disposes cached clients and tokens.
  ///
  /// Each client is disposed only after its in-flight callers finish, so this
  /// can take up to [disposeGracePeriod]. Databases are disposed in parallel
  /// to keep that wait from accumulating across sessions.
  ///
  /// キャッシュしたクライアントとトークンを破棄します。
  ///
  /// 各クライアントは実行中の呼び出しが完了してから破棄されるため、最大で
  /// [disposeGracePeriod]の時間がかかります。待ち時間がセッションごとに
  /// 積み上がらないよう、データベース単位の破棄は並列で実行します。
  Future<void> clear() async {
    final databases = _databases.values.toList();
    _databases.clear();
    await Future.wait(databases.map(_disposeClient));
  }

  Future<void> _activate(String currentSessionKey) async {
    if (_activeSessionKey == currentSessionKey) {
      return;
    }
    await clear();
    _activeSessionKey = currentSessionKey;
  }

  bool _isValid(TursoTokenFunctionsActionResponse token) {
    if (token.expiresAt <= 0) {
      return false;
    }
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return token.expiresAt >
        now + expirationMargin.inSeconds.clamp(0, token.expiresAt);
  }

  String _cacheKey({
    required String sessionKey,
    required String connectionKey,
    required String database,
    required String? prefix,
  }) {
    return [
      sessionKey,
      connectionKey,
      prefix ?? "",
      database,
    ].join("\u0000");
  }

  Future<LibsqlClient> _connect(
    TursoTokenFunctionsActionResponse token,
    String? cacheKey,
  ) async {
    final clientFactory = this.clientFactory;
    if (clientFactory != null) {
      return await clientFactory(token);
    }
    final directory = await DatabaseExporter.documentDirectory;
    final replicaPath = directory == null ||
            directory.isEmpty ||
            cacheKey == null ||
            !useEmbeddedReplica
        ? null
        : "$directory/turso_${cacheKey.toSHA1()}.db";
    final client = replicaPath == null
        ? LibsqlClient.remote(token.url, authToken: token.token)
        : LibsqlClient.replica(
            replicaPath,
            syncUrl: token.url,
            authToken: token.token,
            readYourWrites: true,
          );
    await client.connect();
    if (replicaPath != null) {
      await client.sync();
    }
    return client;
  }

  Future<void> _disposeClient(_TursoDirectDatabaseSession state) async {
    final handle = state.client;
    // Detach first so later callers open a fresh client instead of joining the
    // one about to be disposed.
    state.client = null;
    if (handle == null) {
      return;
    }
    await _disposeHandle(handle);
  }

  Future<void> _disposeHandle(_TursoDirectClientHandle handle) async {
    try {
      await handle.waitUntilIdle().timeout(disposeGracePeriod);
    } on TimeoutException {
      // The grace period expired. Prefer releasing the client over waiting on
      // a caller that may never finish.
    }
    final LibsqlClient client;
    try {
      client = await handle.client.timeout(disposeGracePeriod);
    } on Object {
      // The connection failed or never settled. Dispose it in the background
      // if it resolves later so the Rust object is not leaked, but never block
      // the caller of `clear()` on a connection that may never complete.
      unawaited(
        handle.client.then((client) => client.dispose()).onError((_, __) {}),
      );
      return;
    }
    try {
      await client.dispose();
    } catch (_) {}
  }

  bool _hasDirectMode(TursoTokenFunctionsActionResponse response) {
    return response.readMode == "direct" || response.writeMode == "direct";
  }

  String? _modeFor(
    TursoTokenFunctionsActionResponse response,
    List<TursoTokenScope> scopes, {
    required bool write,
  }) {
    final modes = <String>{};
    for (final scope in scopes) {
      final operations = scope.operations;
      final requiresMode = write
          ? operations.any(_isTursoWriteOperation)
          : operations.any(_isTursoReadOperation);
      if (!requiresMode) {
        continue;
      }
      final resolved = response.scopes.firstWhereOrNull(
        (item) => item.table == scope.table,
      );
      modes.add(
        (write ? resolved?.writeMode : resolved?.readMode) ??
            (write ? response.writeMode : response.readMode),
      );
    }
    if (modes.isEmpty) {
      return null;
    }
    if (modes.length == 1) {
      return modes.single;
    }
    if (modes.contains("none")) {
      return "none";
    }
    return "functions";
  }

  bool _coversScopes(
    TursoTokenFunctionsActionResponse response,
    List<TursoTokenScope> scopes,
  ) {
    for (final scope in scopes) {
      final resolved = response.scopes.firstWhereOrNull(
        (item) => item.table == scope.table,
      );
      if (resolved == null) {
        return false;
      }
      for (final operation in scope.operations) {
        if (!_operationsContain(resolved.operations, operation)) {
          return false;
        }
      }
    }
    return true;
  }

  bool _operationsContain(List<String> operations, String operation) {
    if (operations.contains(operation)) {
      return true;
    }
    if (_isTursoReadOperation(operation)) {
      return operations.any(_isTursoReadOperation);
    }
    if (_isTursoWriteOperation(operation)) {
      return operations.any(_isTursoWriteOperation);
    }
    return false;
  }

  bool _sameScopes(
    List<TursoTokenScope> first,
    List<TursoTokenScope> second,
  ) {
    return _scopeSignature(first) == _scopeSignature(second);
  }

  String _scopeSignature(List<TursoTokenScope> scopes) {
    final values = scopes.map((scope) {
      final operations = [...scope.operations]..sort();
      return "${scope.table}:${operations.join(",")}";
    }).toList()
      ..sort();
    return values.join(";");
  }
}

class _TursoDirectDatabaseSession {
  _TursoDirectDatabaseSession({
    required this.key,
    required this.database,
    required this.prefix,
  });

  final String key;
  final String database;
  final String? prefix;
  List<TursoTokenScope> scopes = const [];
  TursoTokenFunctionsActionResponse? resolved;
  Future<TursoTokenFunctionsActionResponse>? resolving;
  _TursoDirectClientHandle? client;
}

/// A single cached [LibsqlClient] together with its in-flight caller count.
///
/// The count is tracked per client rather than per database session. While a
/// disposal waits for the client to become idle, a new caller may open a
/// replacement client on the same session; counting per session would let
/// those new callers keep the disposal waiting indefinitely.
class _TursoDirectClientHandle {
  _TursoDirectClientHandle(this.client);

  final Future<LibsqlClient> client;
  int _active = 0;
  Completer<void>? _idle;

  void retain() {
    _active++;
  }

  void release() {
    _active--;
    if (_active <= 0) {
      _idle?.complete();
      _idle = null;
    }
  }

  Future<void> waitUntilIdle() {
    if (_active <= 0) {
      return Future<void>.value();
    }
    return (_idle ??= Completer<void>()).future;
  }
}

bool _isTursoReadOperation(String operation) {
  return operation == "read" || operation == "get";
}

bool _isTursoWriteOperation(String operation) {
  return const {"write", "create", "update", "delete"}.contains(operation);
}

List<TursoTokenScope> _mergeSessionScopes(List<TursoTokenScope> scopes) {
  final values = <String, Set<String>>{};
  for (final scope in scopes) {
    values.putIfAbsent(scope.table, () => <String>{}).addAll(scope.operations);
  }
  return values.entries
      .map((entry) => TursoTokenScope(
            table: entry.key,
            operations: entry.value.toList()..sort(),
          ))
      .toList()
    ..sort((a, b) => a.table.compareTo(b.table));
}

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
    this.useDirectClient = true,
    this.directClientSession,
    FunctionsAdapter? functionsAdapter,
    String? prefix,
    this.tokenTtlSeconds = 3600,
    this.retryDelays = _tursoRetryDelays,
    NoSqlDatabase? cachedRuntimeDatabase,
  })  : _functionsAdapter = functionsAdapter,
        _prefix = prefix,
        _cachedRuntimeDatabase = cachedRuntimeDatabase;

  /// Functions adapter for obtaining tokens and using Workers CRUD.
  ///
  /// トークン取得やWorkers CRUDに利用するFunctionsアダプター。
  FunctionsAdapter get functionsAdapter {
    return _functionsAdapter ?? FunctionsAdapter.primary;
  }

  final FunctionsAdapter? _functionsAdapter;

  /// Prefix added to the physical database name.
  ///
  /// 物理データベース名に追加するプレフィックス。
  String? get prefix => _normalizeTursoDatabasePrefix(_prefix);

  final String? _prefix;

  /// Prefix used to isolate runtime and persistent cache entries.
  ///
  /// ランタイムキャッシュと永続キャッシュのエントリーを分離するプレフィックス。
  @protected
  String? get cachePrefix =>
      prefix == null ? null : "__database_prefix__/$prefix";

  /// Whether to use direct client access.
  ///
  /// 直接接続を利用するかどうか。
  final bool useDirectClient;

  /// Optional authenticated session used to reuse tokens and direct clients.
  ///
  /// トークンと直接接続クライアントの再利用に使う認証済みセッション。
  final TursoDirectClientSession? directClientSession;

  /// Token TTL in seconds.
  ///
  /// トークンの有効秒数。
  final int tokenTtlSeconds;

  /// Retry delays for transient Turso direct connection errors.
  ///
  /// Turso直接接続の一時的なエラーに対するリトライ間隔。
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

  /// Resolves all Turso routes for [database] and opens its direct replica.
  ///
  /// [database]の全Turso経路を解決し、直接接続用レプリカを事前に開きます。
  Future<TursoPrewarmResult?> prewarm({
    required String database,
    required List<TursoTokenScope> scopes,
  }) async {
    final session = directClientSession;
    if (!_directEnabled || session == null || scopes.isEmpty) {
      return null;
    }
    final totalStopwatch = Stopwatch()..start();
    final routeStopwatch = Stopwatch()..start();
    final connectionKey = functionsAdapter.endpoint;
    final resolved = await session._resolve(
      connectionKey: connectionKey,
      database: database,
      prefix: prefix,
      scopes: _mergeScopes(scopes),
      loader: (targets) => functionsAdapter.execute(TursoTokenFunctionsAction(
        database: database,
        prefix: prefix,
        targets: targets,
        ttlSeconds: tokenTtlSeconds,
      )),
    );
    routeStopwatch.stop();
    final replicaStopwatch = Stopwatch()..start();
    if (resolved.token.isNotEmpty &&
        resolved.url.isNotEmpty &&
        (resolved.readMode == "direct" || resolved.writeMode == "direct")) {
      await session._run<void>(
        connectionKey: connectionKey,
        database: database,
        prefix: prefix,
        token: resolved,
        write: false,
        callback: (_) async {},
      );
    }
    replicaStopwatch.stop();
    totalStopwatch.stop();
    return TursoPrewarmResult(
      routeDuration: routeStopwatch.elapsed,
      replicaDuration: replicaStopwatch.elapsed,
      totalDuration: totalStopwatch.elapsed,
    );
  }

  /// Called before loading a document from Turso.
  ///
  /// Tursoからドキュメントを読み込む前に呼び出されます。
  @protected
  Future<DynamicMap?> onPreloadDocument(
    ModelAdapterDocumentQuery query,
  ) =>
      Future.value();

  /// Called after loading a document from Turso.
  ///
  /// Tursoからドキュメントを読み込んだ後に呼び出されます。
  @protected
  Future<void> onPostloadDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) =>
      Future.value();

  /// Called before loading a collection from Turso.
  ///
  /// Tursoからコレクションを読み込む前に呼び出されます。
  @protected
  Future<CachedTursoModelCollectionLoaderResponse?> onPreloadCollection(
    ModelAdapterCollectionQuery query,
  ) =>
      Future.value();

  /// Called after loading a collection from Turso.
  ///
  /// Tursoからコレクションを読み込んだ後に呼び出されます。
  @protected
  Future<void> onPostloadCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap> value,
  ) =>
      Future.value();

  /// Called after saving a document to Turso.
  ///
  /// Tursoへドキュメントを保存した後に呼び出されます。
  @protected
  Future<void> onSaveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) =>
      Future.value();

  /// Called after deleting a document from Turso.
  ///
  /// Tursoからドキュメントを削除した後に呼び出されます。
  @protected
  Future<void> onDeleteDocument(
    ModelAdapterDocumentQuery query,
  ) =>
      Future.value();

  Future<void> _syncCachedCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap> value,
  ) async {
    await cachedRuntimeDatabase.syncCollection(
      query,
      value,
      prefix: cachePrefix,
    );
    await onPostloadCollection(query, value);
  }

  Future<void> _syncCachedDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await cachedRuntimeDatabase.syncDocument(
      query,
      value,
      prefix: cachePrefix,
    );
    await onPostloadDocument(query, value);
  }

  Future<void> _saveCachedDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await cachedRuntimeDatabase.saveDocument(
      query,
      value,
      prefix: cachePrefix,
    );
    await onSaveDocument(query, value);
  }

  Future<void> _deleteCachedDocument(
    ModelAdapterDocumentQuery query,
  ) async {
    await cachedRuntimeDatabase.deleteDocument(query, prefix: cachePrefix);
    await onDeleteDocument(query);
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    final path = TursoModelPath.fromDocumentQuery(query);
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
            prefix: prefix,
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
        prefix: prefix,
        indexKey: path.indexKey,
      ));
    }
    await _deleteCachedDocument(query);
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
    cachedRuntimeDatabase.removeCollectionListener(query, prefix: cachePrefix);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    cachedRuntimeDatabase.removeDocumentListener(query, prefix: cachePrefix);
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
    final path = TursoModelPath.fromCollectionQuery(query);
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
            prefix: prefix,
            where: payload.where,
            count: true,
          ));
          return res.data;
        },
        callback: (client) async {
          final where = _buildTursoWhereSql(where: payload.where);
          final List<Map<String, dynamic>> rows;
          try {
            rows = await client.query(
              "SELECT COUNT(*) AS count FROM ${_quoteTursoIdentifier(path.table)}${where.sql}",
              positional: where.args,
            );
          } catch (error) {
            if (_isTursoMissingTableError(error)) {
              return 0;
            }
            rethrow;
          }
          return rows.firstOrNull?["count"] ?? 0;
        },
      );
    } else {
      final res = await functionsAdapter.execute(TursoGetModelFunctionsAction(
        database: path.database,
        table: path.table,
        prefix: prefix,
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
    final cache = await onPreloadCollection(query);
    var data = cache?.value;
    if (data == null || cache?.query != null) {
      if (cache?.query != null) {
        query = cache!.query!;
      }
      final path = TursoModelPath.fromCollectionQuery(query);
      final payload = TursoQueryPayload.fromFilters(query.query.filters);
      final remote = _directEnabled
          ? await _loadCollectionDirect(path, payload)
          : await _loadCollectionFunctions(path, payload);
      data = {
        ...?data,
        ...remote,
      };
      await _syncCachedCollection(query, data);
    } else {
      await cachedRuntimeDatabase.syncCollection(
        query,
        data,
        prefix: cachePrefix,
      );
    }
    return data;
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    if (query.reference && !query.reload) {
      final cached =
          await cachedRuntimeDatabase.loadDocument(query, prefix: cachePrefix);
      if (cached != null) {
        return cached;
      }
    }
    final cached = await onPreloadDocument(query);
    if (cached != null) {
      await cachedRuntimeDatabase.syncDocument(
        query,
        cached,
        prefix: cachePrefix,
      );
      return cached;
    }
    final path = TursoModelPath.fromDocumentQuery(query);
    final data = _directEnabled
        ? await _loadDocumentDirect(path)
        : await _loadDocumentFunctions(path);
    await _syncCachedDocument(query, data);
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
    final path = TursoModelPath.fromDocumentQuery(query);
    final row = _buildSaveRow(path, value);
    final boolFields = _extractTursoBoolFields(value);
    _cacheTursoBoolFields(path.database, path.table, boolFields);
    if (_directEnabled) {
      await _saveDocumentDirect(path, row, boolFields);
    } else {
      await _saveDocumentFunctions(path, row);
    }
    await _saveCachedDocument(query, value);
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
        const TursoTokenScope(table: _tursoSchemaTable, operations: ["read"]),
      ],
      functionsFallback: (_) => _loadCollectionFunctions(path, payload),
      callback: (client) async {
        final where = _buildTursoWhereSql(where: payload.where);
        final boolFields =
            await _loadTursoBoolFields(client, path.database, path.table);
        final List<Map<String, dynamic>> rows;
        try {
          rows = await client.query(
            "SELECT * FROM ${_quoteTursoIdentifier(path.table)}"
            "${where.sql}${_buildTursoOrderSql(payload.orderBy)}"
            "${_buildTursoLimitSql(payload.limit)}",
            positional: where.args,
          );
        } catch (error) {
          if (_isTursoMissingTableError(error)) {
            return <String, DynamicMap>{};
          }
          rethrow;
        }
        return Map.fromEntries(rows.map((row) {
          final decoded = _decodeTursoRow(row, boolFields: boolFields);
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
      prefix: prefix,
      where: payload.where,
      orderBy: payload.orderBy,
      limit: payload.limit,
    ));
    return _rowsToMap(
      res.data,
      database: path.database,
      table: path.table,
    );
  }

  Future<DynamicMap> _loadDocumentDirect(TursoModelPath path) async {
    return await _withDirectClient(
      database: path.database,
      scopes: [
        TursoTokenScope(table: path.table, operations: const ["read"]),
        const TursoTokenScope(table: _tursoSchemaTable, operations: ["read"]),
      ],
      functionsFallback: (_) => _loadDocumentFunctions(path),
      callback: (client) async {
        final boolFields =
            await _loadTursoBoolFields(client, path.database, path.table);
        final List<Map<String, dynamic>> rows;
        try {
          rows = await client.query(
            "SELECT * FROM ${_quoteTursoIdentifier(path.table)} "
            "WHERE ${_quoteTursoIdentifier("id")} = ? LIMIT 1",
            positional: [path.indexKey],
          );
        } catch (error) {
          if (_isTursoMissingTableError(error)) {
            return <String, dynamic>{};
          }
          rethrow;
        }
        return rows.isEmpty
            ? <String, dynamic>{}
            : _decodeTursoRow(rows.first, boolFields: boolFields);
      },
    );
  }

  Future<DynamicMap> _loadDocumentFunctions(TursoModelPath path) async {
    final res = await functionsAdapter.execute(TursoGetModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      indexKey: path.indexKey,
    ));
    final rows = _rowsToList(
      res.data,
      database: path.database,
      table: path.table,
    );
    return rows.isEmpty ? <String, dynamic>{} : rows.first;
  }

  @override
  Future<void> preloadReferences(
    Iterable<ModelAdapterDocumentQuery> queries,
  ) async {
    final grouped = <String, Map<String, Set<String>>>{};
    for (final query in queries) {
      final TursoModelPath path;
      try {
        path = TursoModelPath.fromDocumentQuery(query);
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
          ...tables.keys.map((table) => TursoTokenScope(
                table: table,
                operations: const ["read"],
              )),
          const TursoTokenScope(
            table: _tursoSchemaTable,
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
              final boolFields =
                  await _loadTursoBoolFields(client, database, table);
              final rows = await client.query(
                "SELECT * FROM ${_quoteTursoIdentifier(table)} "
                "WHERE ${_quoteTursoIdentifier("id")} IN (${ids.map((_) => "?").join(", ")})",
                positional: ids,
              );
              databaseResult[table] = Map.fromEntries(rows.map((row) {
                final decoded = _decodeTursoRow(row, boolFields: boolFields);
                return MapEntry(decoded.get("id", ""), decoded);
              }).where((entry) => entry.key.isNotEmpty));
            } catch (error) {
              if (_isTursoMissingTableError(error)) {
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
        final res = await functionsAdapter.execute(TursoGetModelFunctionsAction(
          database: database,
          table: table,
          prefix: prefix,
          where: [
            {
              "type": ModelQueryFilterType.whereIn.name,
              "key": "id",
              "value": ids,
            },
          ],
        ));
        databaseResult[table] = _rowsToMap(
          res.data,
          database: database,
          table: table,
        );
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
      await _syncCachedCollection(
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
    TursoModelPath path,
    DynamicMap row,
    Set<String> boolFields,
  ) async {
    await _withDirectClient(
      database: path.database,
      scopes: [
        TursoTokenScope(table: path.table, operations: const ["write"]),
        const TursoTokenScope(table: _tursoSchemaTable, operations: ["write"]),
      ],
      functionsFallback: (_) => _saveDocumentFunctions(path, row),
      callback: (client) async {
        await _ensureSchema(client, path.table, row, boolFields);
        final insert = _buildTursoInsertSql(path.table, row);
        await client.execute(insert.sql, positional: insert.args);
      },
    );
  }

  Future<void> _saveDocumentFunctions(
      TursoModelPath path, DynamicMap row) async {
    await functionsAdapter.execute(TursoPostModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: prefix,
      value: row,
    ));
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
    final operationDatabases =
        operations.map((operation) => operation.path().database).toSet();
    if (operationDatabases.length > 1) {
      throw UnsupportedError(
          "TursoModelAdapter does not support direct batch operations across multiple databases.");
    }
    final operationDatabase = operationDatabases.single;
    final scopes = operations
        .map((operation) => TursoTokenScope(
              table: operation.path().table,
              operations: const ["write"],
            ))
        .toList()
      ..add(const TursoTokenScope(
          table: _tursoSchemaTable, operations: ["write"]));
    await _withDirectClient(
      database: operationDatabase,
      scopes: scopes,
      functionsFallback: (_) => _runOperationsFunctions(operations),
      callback: (client) async {
        for (final operation in operations.whereType<_TursoSaveOperation>()) {
          final path = operation.path();
          final boolFields = _extractTursoBoolFields(operation.value);
          _cacheTursoBoolFields(path.database, path.table, boolFields);
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
          for (final operation in operations) {
            await operation.syncCache(this);
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
    final mergedScopes = _mergeScopes(scopes);
    final session = directClientSession;
    final connectionKey = functionsAdapter.endpoint;
    final requiresWrite = _requiresWrite(scopes);
    final cachedMode = session?._cachedMode(
      connectionKey: connectionKey,
      database: database,
      prefix: prefix,
      scopes: mergedScopes,
      write: requiresWrite,
    );
    if (cachedMode == "functions" && functionsFallback != null) {
      final result = await functionsFallback(_fallbackTokenResponse);
      if (requiresWrite) {
        await session?._sync(
          connectionKey: connectionKey,
          database: database,
          prefix: prefix,
        );
      }
      return result;
    }
    if (cachedMode == "none") {
      throw StateError("Turso access is not allowed.");
    }
    try {
      return await _retryTursoTransient(() async {
        final token = session == null
            ? await functionsAdapter.execute(TursoTokenFunctionsAction(
                database: database,
                prefix: prefix,
                targets: mergedScopes,
                ttlSeconds: tokenTtlSeconds,
              ))
            : await session._resolve(
                connectionKey: connectionKey,
                database: database,
                prefix: prefix,
                scopes: mergedScopes,
                loader: (targets) =>
                    functionsAdapter.execute(TursoTokenFunctionsAction(
                  database: database,
                  prefix: prefix,
                  targets: targets,
                  ttlSeconds: tokenTtlSeconds,
                )),
              );
        final mode = session?._modeFor(
              token,
              mergedScopes,
              write: requiresWrite,
            ) ??
            (requiresWrite ? token.writeMode : token.readMode);
        if (mode != "direct") {
          if (mode == "functions" && functionsFallback != null) {
            final result = await functionsFallback(token);
            if (requiresWrite) {
              await session?._sync(
                connectionKey: connectionKey,
                database: database,
                prefix: prefix,
              );
            }
            return result;
          }
          throw StateError("Turso access is not allowed. mode=$mode");
        }
        if (token.url.isEmpty) {
          throw StateError(
              "Token response url is required for direct Turso access.");
        }
        if (session != null) {
          return await session._run(
            connectionKey: connectionKey,
            database: database,
            prefix: prefix,
            token: token,
            write: requiresWrite,
            callback: callback,
          );
        }
        final client = LibsqlClient.remote(token.url, authToken: token.token);
        await client.connect();
        try {
          return await callback(client);
        } finally {
          await client.dispose();
        }
      });
    } catch (error) {
      if (functionsFallback != null && _isTursoDirectFallbackError(error)) {
        final result = await _retryTursoTransient(
          () => functionsFallback(_fallbackTokenResponse),
        );
        if (requiresWrite) {
          await session?._sync(
            connectionKey: connectionKey,
            database: database,
            prefix: prefix,
          );
        }
        return result;
      }
      rethrow;
    }
  }

  Future<T> _retryTursoTransient<T>(Future<T> Function() callback) async {
    Object? lastError;
    StackTrace? lastStackTrace;
    for (var attempt = 0; attempt <= retryDelays.length; attempt++) {
      try {
        return await callback();
      } catch (error, stackTrace) {
        lastError = error;
        lastStackTrace = stackTrace;
        if (!_isTursoDirectFallbackError(error) ||
            attempt == retryDelays.length) {
          rethrow;
        }
        await Future<void>.delayed(retryDelays[attempt]);
      }
    }
    Error.throwWithStackTrace(lastError!, lastStackTrace!);
  }

  bool _requiresWrite(List<TursoTokenScope> scopes) {
    const writeOperations = {"write", "create", "update", "delete"};
    return scopes.any((scope) => scope.operations
        .any((operation) => writeOperations.contains(operation)));
  }

  bool _isTursoDirectFallbackError(Object error) {
    if (_isTursoMissingTableError(error)) {
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

  bool _isTursoMissingTableError(Object error) {
    final message = error.toString();
    return message.contains("no such table") ||
        message.contains("SQLITE_UNKNOWN");
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
    final sanitizedValue = _sanitizeTursoSaveValue(value);
    return {
      ...sanitizedValue
          .map((key, val) => MapEntry(key, _encodeTursoValue(val))),
      "id": path.indexKey,
      "created_at": value["created_at"] ?? now,
      "updated_at": now,
    };
  }

  Future<void> _ensureSchema(
    LibsqlClient client,
    String table,
    DynamicMap row,
    Set<String> boolFields,
  ) async {
    final create = _buildTursoCreateTableSql(table, row);
    await client.execute(create.sql);
    await _ensureTursoSchemaTable(client);
    await _saveTursoBoolFields(client, table, boolFields);
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

  List<DynamicMap> _rowsToList(
    Object? data, {
    String? database,
    String? table,
  }) {
    final boolFields = database == null || table == null
        ? const <String>{}
        : _tursoBoolFieldsCache[_boolFieldsCacheKey(database, table)] ??
            const <String>{};
    if (data is List) {
      return data
          .whereType<Map>()
          .map((row) => _decodeTursoRow(
                Map<String, dynamic>.from(row),
                boolFields: boolFields,
              ))
          .toList();
    }
    if (data is Map) {
      return [
        _decodeTursoRow(
          Map<String, dynamic>.from(data),
          boolFields: boolFields,
        )
      ];
    }
    return [];
  }

  Future<void> _ensureTursoSchemaTable(LibsqlClient client) async {
    await client.execute(
      "CREATE TABLE IF NOT EXISTS ${_quoteTursoIdentifier(_tursoSchemaTable)} ( "
      "id TEXT PRIMARY KEY, "
      "table_name TEXT, "
      "column_name TEXT, "
      "value_type TEXT, "
      "updated_at INTEGER"
      " )",
    );
  }

  Future<void> _saveTursoBoolFields(
    LibsqlClient client,
    String table,
    Set<String> boolFields,
  ) async {
    if (boolFields.isEmpty) {
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    for (final field in boolFields) {
      await client.execute(
        "INSERT OR REPLACE INTO ${_quoteTursoIdentifier(_tursoSchemaTable)} "
        "(id, table_name, column_name, value_type, updated_at) "
        "VALUES (?, ?, ?, ?, ?)",
        positional: ["$table:$field", table, field, "bool", now],
      );
    }
  }

  Future<Set<String>> _loadTursoBoolFields(
    LibsqlClient client,
    String database,
    String table,
  ) async {
    try {
      final schemaTable = await client.query(
        "SELECT 1 FROM sqlite_master WHERE type = ? AND name = ? LIMIT 1",
        positional: ["table", _tursoSchemaTable],
      );
      if (schemaTable.isEmpty) {
        return _tursoBoolFieldsCache[_boolFieldsCacheKey(database, table)] ??
            const {};
      }
      final rows = await client.query(
        "SELECT column_name FROM ${_quoteTursoIdentifier(_tursoSchemaTable)} "
        "WHERE table_name = ? AND value_type = ?",
        positional: [table, "bool"],
      );
      final fields = rows
          .map((row) => row.get("column_name", ""))
          .where((field) => field.isNotEmpty)
          .toSet();
      _cacheTursoBoolFields(database, table, fields);
      return fields;
    } catch (_) {
      return _tursoBoolFieldsCache[_boolFieldsCacheKey(database, table)] ??
          const {};
    }
  }

  void _cacheTursoBoolFields(
    String database,
    String table,
    Set<String> fields,
  ) {
    if (fields.isEmpty) {
      return;
    }
    final key = _boolFieldsCacheKey(database, table);
    _tursoBoolFieldsCache[key] = {
      ...?_tursoBoolFieldsCache[key],
      ...fields,
    };
  }

  String _boolFieldsCacheKey(String database, String table) {
    return "${prefix ?? ""}\u0000$database\u0000$table";
  }

  Map<String, DynamicMap> _rowsToMap(
    Object? data, {
    String? database,
    String? table,
  }) {
    return Map.fromEntries(_rowsToList(
      data,
      database: database,
      table: table,
    ).map((row) {
      return MapEntry(row.get("id", ""), row);
    }).where((entry) => entry.key.isNotEmpty));
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return runtimeType.hashCode ^
        functionsAdapter.hashCode ^
        prefix.hashCode ^
        useDirectClient.hashCode ^
        directClientSession.hashCode ^
        retryDelays.hashCode ^
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
  TursoModelPath path();

  Future<void> run(TursoModelAdapter adapter);

  Future<void> runFunctions(TursoModelAdapter adapter);

  Future<void> runDirect(TursoModelAdapter adapter, LibsqlClient client);

  Future<void> runDirectTransaction(
    TursoModelAdapter adapter,
    dynamic transaction,
  );

  Future<void> syncCache(TursoModelAdapter adapter);
}

class _TursoSaveOperation extends _TursoOperation {
  _TursoSaveOperation(this.query, this.value);

  final ModelAdapterDocumentQuery query;
  final DynamicMap value;

  @override
  TursoModelPath path() {
    return TursoModelPath.fromDocumentQuery(query);
  }

  @override
  Future<void> run(TursoModelAdapter adapter) {
    return adapter.saveDocument(query, value);
  }

  @override
  Future<void> runFunctions(TursoModelAdapter adapter) async {
    final path = this.path();
    await adapter._saveDocumentFunctions(
      path,
      adapter._buildSaveRow(path, value),
    );
    await syncCache(adapter);
  }

  @override
  Future<void> runDirect(TursoModelAdapter adapter, LibsqlClient client) async {
    final path = this.path();
    final row = adapter._buildSaveRow(path, value);
    final insert = _buildTursoInsertSql(path.table, row);
    await client.execute(insert.sql, positional: insert.args);
    await syncCache(adapter);
  }

  @override
  Future<void> runDirectTransaction(
    TursoModelAdapter adapter,
    dynamic transaction,
  ) async {
    final path = this.path();
    final row = adapter._buildSaveRow(path, value);
    final insert = _buildTursoInsertSql(path.table, row);
    await transaction.execute(insert.sql, positional: insert.args);
  }

  @override
  Future<void> syncCache(TursoModelAdapter adapter) async {
    await adapter._saveCachedDocument(query, value);
  }
}

class _TursoDeleteOperation extends _TursoOperation {
  _TursoDeleteOperation(this.query);

  final ModelAdapterDocumentQuery query;

  @override
  TursoModelPath path() {
    return TursoModelPath.fromDocumentQuery(query);
  }

  @override
  Future<void> run(TursoModelAdapter adapter) {
    return adapter.deleteDocument(query);
  }

  @override
  Future<void> runFunctions(TursoModelAdapter adapter) async {
    final path = this.path();
    await adapter.functionsAdapter.execute(TursoDeleteModelFunctionsAction(
      database: path.database,
      table: path.table,
      prefix: adapter.prefix,
      indexKey: path.indexKey,
    ));
    await syncCache(adapter);
  }

  @override
  Future<void> runDirect(TursoModelAdapter adapter, LibsqlClient client) async {
    final path = this.path();
    await client.execute(
      "DELETE FROM ${_quoteTursoIdentifier(path.table)} "
      "WHERE ${_quoteTursoIdentifier("id")} = ?",
      positional: [path.indexKey],
    );
    await syncCache(adapter);
  }

  @override
  Future<void> runDirectTransaction(
    TursoModelAdapter adapter,
    dynamic transaction,
  ) async {
    final path = this.path();
    await transaction.execute(
      "DELETE FROM ${_quoteTursoIdentifier(path.table)} "
      "WHERE ${_quoteTursoIdentifier("id")} = ?",
      positional: [path.indexKey],
    );
  }

  @override
  Future<void> syncCache(TursoModelAdapter adapter) async {
    await adapter._deleteCachedDocument(query);
  }
}
