part of "/masamune_model_do.dart";

/// 個人または共有トピックの変更通知を認可付きsnapshotへ変換するAdapter。
class ListenableDurableObjectModelAdapter extends DurableObjectModelAdapter
    with _DurableObjectListening {
  /// 認証切替時はsession.reset()を呼び、新しいsessionを使用する。
  const ListenableDurableObjectModelAdapter({
    required super.prefix,
    required super.session,
    super.functionsAdapter,
    super.cachedRuntimeDatabase,
    super.vectorConverter,
    super.defaultAutoDisposeWhenUnreferenced,
    this.socketConnector = DurableObjectSocket.connect,
    this.onListenError,
  });

  @override
  final Future<DurableObjectSocket> Function(Uri) socketConnector;
  @override
  final void Function(Object, StackTrace)? onListenError;
}

mixin _DurableObjectListening on DurableObjectModelAdapter {
  Future<DurableObjectSocket> Function(Uri) get socketConnector;
  void Function(Object, StackTrace)? get onListenError;
  static final _subscriptions = Expando<Map<Object, _DoSubscription>>();
  Map<Object, _DoSubscription> get _active =>
      _subscriptions[this] ??= <Object, _DoSubscription>{};

  @override
  bool get availableListen => true;

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final active = _active[query];
    if (active == null) {
      return super.loadDocument(query);
    }
    await active.work;
    session.cacheScope;
    return Map<String, dynamic>.from(active.previous.values.firstOrNull ?? {});
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
      ModelAdapterCollectionQuery query) async {
    final active = _active[query];
    if (active == null) {
      return super.loadCollection(query);
    }
    await active.work;
    session.cacheScope;
    return Map<String, DynamicMap>.from(active.previous);
  }

  @override
  Future<List<StreamSubscription<dynamic>>> listenDocument(
          ModelAdapterDocumentQuery query) =>
      _listen(query);
  @override
  Future<List<StreamSubscription<dynamic>>> listenCollection(
          ModelAdapterCollectionQuery query) =>
      _listen(query);

  Future<List<StreamSubscription<dynamic>>> _listen(Object query) async {
    session.cacheScope;
    await _active.remove(query)?.stop();
    final subscription = _DoSubscription(this, query);
    _active[query] = subscription;
    try {
      await subscription.start();
      return [subscription.lifetime];
    } catch (error) {
      if (RegExp(r"\b(401|403)\b").hasMatch(error.toString())) {
        await _applySnapshot(
            query, subscription.previous, {}, subscription.scope);
      }
      await subscription.stop();
      _active.remove(query);
      rethrow;
    }
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    unawaited(_active.remove(query)?.stop());
    super.disposeDocument(query);
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    unawaited(_active.remove(query)?.stop());
    super.disposeCollection(query);
  }

  Future<void> _applySnapshot(Object query, Map<String, DynamicMap> previous,
      Map<String, DynamicMap> next, String scope,
      {bool Function()? valid}) async {
    // snapshotはquery単位で保持する。別queryの結果を誤って削除しない。
    final queryScope = _doListenCacheScope(scope, query);
    if (query is ModelAdapterCollectionQuery) {
      await cachedRuntimeDatabase.syncCollection(query, next,
          prefix: queryScope, overwrite: true);
      if (session._generation != 0 || (valid != null && !valid())) {
        return;
      }
      if (this is CachedListenableDurableObjectModelAdapter) {
        await onPostloadCollection(query, next);
      }
      if (session._generation != 0 || (valid != null && !valid())) {
        return;
      }
      final currentKeys = previous.keys.toList();
      final keys = next.keys.toList();
      for (final id in previous.keys.where((id) => !next.containsKey(id))) {
        final oldIndex = currentKeys.indexOf(id);
        currentKeys.removeAt(oldIndex);
        query.callback?.call(ModelUpdateNotification(
            path: "${query.query.path}/$id",
            id: id,
            status: ModelUpdateNotificationStatus.removed,
            value: previous[id]!,
            oldIndex: oldIndex,
            newIndex: -1,
            origin: query.origin,
            listen: true,
            query: query.query));
      }
      for (var newIndex = 0; newIndex < keys.length; newIndex++) {
        final id = keys[newIndex];
        final oldIndex = currentKeys.indexOf(id);
        if (oldIndex == newIndex &&
            jsonEncode(previous[id]) == jsonEncode(next[id])) {
          continue;
        }
        if (oldIndex >= 0) {
          currentKeys.removeAt(oldIndex);
        }
        currentKeys.insert(newIndex, id);
        query.callback?.call(ModelUpdateNotification(
            path: "${query.query.path}/$id",
            id: id,
            status: oldIndex < 0
                ? ModelUpdateNotificationStatus.added
                : ModelUpdateNotificationStatus.modified,
            value: next[id]!,
            oldIndex: oldIndex,
            newIndex: newIndex,
            origin: query.origin,
            listen: true,
            query: query.query));
      }
    } else if (query is ModelAdapterDocumentQuery) {
      final value = next.values.firstOrNull ?? <String, dynamic>{};
      await cachedRuntimeDatabase.syncDocument(query, value,
          prefix: queryScope);
      if (this is CachedListenableDurableObjectModelAdapter) {
        await onPostloadDocument(query, value);
      }
      if (session._generation != 0 || (valid != null && !valid())) {
        return;
      }
      if (jsonEncode(previous) != jsonEncode(next) || previous.isEmpty) {
        query.callback?.call(ModelUpdateNotification(
            path: query.query.path,
            id: query.query.path.last(),
            status: next.isEmpty
                ? ModelUpdateNotificationStatus.removed
                : ModelUpdateNotificationStatus.modified,
            value: value,
            origin: query.origin,
            listen: true,
            query: query.query));
      }
    }
  }
}

class _DoSyncAction extends DurableObjectDatabaseAction<DynamicMap> {
  _DoSyncAction(this.database, this.body);
  @override
  final String database;
  final DynamicMap body;
  @override
  String get action => "do";
  @override
  String get path => _buildDurableObjectActionPath(action, ["sync", database]);
  @override
  ApiMethod get method => ApiMethod.post;
  @override
  Duration get timeout => const Duration(seconds: 15);
  @override
  DynamicMap toMap() => body;
  @override
  DynamicMap toResponse(DynamicMap map) => map;
}

class _DoSubscription {
  _DoSubscription(this.adapter, this.query) : scope = adapter.cachePrefix! {
    lifetime = controller.stream.listen((_) {});
    controller.onCancel = stop;
    adapter.session._resetListeners.add(reset);
  }
  final _DurableObjectListening adapter;
  final Object query;
  final String scope;
  final controller = StreamController<void>();
  // 呼び出し元のModelまたはstopが購読を終了する。
  // ignore: cancel_subscriptions
  late final StreamSubscription<void> lifetime;
  DurableObjectSocket? socket;
  StreamSubscription<String>? messages;
  Timer? retry;
  Timer? refresh;
  Timer? renewal;
  bool stopped = false;
  int sequence = -1;
  int failures = 0;
  bool pending = false;
  Future<void> work = Future.value();
  Map<String, DynamicMap> previous = {};
  DurableObjectModelPath get path => query is ModelAdapterDocumentQuery
      ? DurableObjectModelPath.fromDocumentQuery(
          query as ModelAdapterDocumentQuery)
      : DurableObjectModelPath.fromCollectionQuery(
          query as ModelAdapterCollectionQuery);
  DynamicMap body(bool ticket) {
    final payload = query is ModelAdapterCollectionQuery
        ? DurableObjectQueryPayload.fromFilters(
            (query as ModelAdapterCollectionQuery).query.filters)
        : null;
    if (payload?.nearest != null) {
      throw UnsupportedError("DOの近傍検索購読は未対応です。");
    }
    return {
      "table": path.table,
      if (path.indexKey != null) "indexKey": path.indexKey,
      if (payload != null) "where": _normalizeDurableObjectWhere(payload.where),
      if (payload != null)
        "orderBy": _normalizeDurableObjectOrderBy(payload.orderBy),
      if (payload?.limit != null) "limit": payload!.limit,
      "ticket": ticket
    };
  }

  Future<DynamicMap> snapshot(bool ticket) =>
      adapter._execute(_DoSyncAction(path.database, body(ticket)));
  Future<void> apply(DynamicMap response) async {
    if (stopped || adapter.session._generation != 0) {
      return;
    }
    final current = response["sequence"];
    if (current is! int || current < 0) {
      throw StateError("同期連番が不正です。");
    }
    // 要求と適用を直列化しているため、連番が巻き戻った場合も全snapshotで復旧する。
    final next = adapter._rowsToMap(response["data"]);
    await adapter._applySnapshot(query, previous, next, scope,
        valid: () => !stopped);
    if (stopped || adapter.session._generation != 0) {
      return;
    }
    previous = next;
    sequence = current;
  }

  Future<void> start() async {
    await work;
    if (stopped) {
      return;
    }
    final response = await snapshot(true);
    if (stopped) {
      return;
    }
    await apply(response);
    if (stopped) {
      return;
    }
    final endpoint = Uri.parse(adapter.session.endpoint);
    final topic = adapter.session.sharedTopic;
    final hub = response["hub"];
    if (topic != null &&
        (hub is! Map ||
            hub["generation"] is! String ||
            !RegExp(r"^[A-Za-z0-9_-]{1,64}$")
                .hasMatch(hub["generation"] as String) ||
            hub["shard"] is! int ||
            (hub["shard"] as int) < 0 ||
            (hub["shard"] as int) >= 32)) {
      throw StateError("共有hubの接続情報が不正です。");
    }
    final segments = topic == null
        ? [path.database, adapter.session.userId]
        : [
            "shared",
            path.database,
            topic,
            adapter.session.userId,
            (hub as Map)["generation"] as String,
            hub["shard"].toString()
          ];
    final uri = endpoint.replace(
        scheme: endpoint.scheme == "https" ? "wss" : "ws",
        path:
            "${endpoint.path.replaceAll(RegExp(r'/+$'), '')}/do-connect/${segments.map(Uri.encodeComponent).join('/')}",
        queryParameters: {"ticket": response["ticket"] as String});
    final connected = await adapter.socketConnector(uri);
    if (stopped) {
      await connected.close();
      return;
    }
    socket = connected;
    messages = connected.messages.listen((message) {
      try {
        final data = jsonDecode(message) as Map<String, dynamic>;
        if (data["type"] == "invalidate" &&
            (topic != null || data["sequence"] != sequence)) {
          schedule();
        }
      } catch (error, stack) {
        failed(error, stack);
      }
    }, onError: failed, onDone: reconnect);
    failures = 0;
    // closeハンドシェイクの完了を待たず、ticketの期限前に再認証する。
    renewal?.cancel();
    final expires = response["expires"];
    if (expires is int) {
      renewal = Timer(
          Duration(
              milliseconds:
                  (expires - DateTime.now().millisecondsSinceEpoch - 2000)
                      .clamp(0, 30000)),
          reconnect);
    }
    // 無更新時の認可失効も検出する。サーバーの休眠は妨げない。
    refresh?.cancel();
    refresh = Timer.periodic(const Duration(seconds: 15), (_) => schedule());
  }

  void schedule() {
    if (stopped) {
      return;
    }
    if (pending) {
      return;
    }
    pending = true;
    work = work.then((_) async {
      pending = false;
      if (stopped) {
        return;
      }
      try {
        await apply(await snapshot(false));
      } catch (error, stack) {
        failed(error, stack);
      }
    });
  }

  void failed(Object error, StackTrace stack) {
    if (stopped) {
      return;
    }
    if (RegExp(r"\b(401|403)\b").hasMatch(error.toString())) {
      unawaited(adapter._applySnapshot(query, previous, {}, scope));
      unawaited(stop());
    } else if (RegExp(r"\b(400|404|409|413|422)\b")
        .hasMatch(error.toString())) {
      unawaited(stop());
    } else {
      reconnect();
    }
    if (adapter.onListenError != null) {
      adapter.onListenError!(error, stack);
    } else {
      unawaited(Logger().error(error, stack));
    }
  }

  void reconnect() {
    if (stopped || (retry?.isActive ?? false)) {
      return;
    }
    refresh?.cancel();
    renewal?.cancel();
    final old = socket;
    socket = null;
    unawaited(messages?.cancel());
    messages = null;
    unawaited(old?.close());
    final delay = Duration(milliseconds: 200 * (1 << (failures++).clamp(0, 5)));
    retry = Timer(delay, () async {
      if (stopped) {
        return;
      }
      try {
        await start();
      } catch (error, stack) {
        failed(error, stack);
      }
    });
  }

  void reset() {
    unawaited(stop());
  }

  Future<void> stop() async {
    if (stopped) {
      return;
    }
    stopped = true;
    if (identical(adapter._active[query], this)) {
      adapter._active.remove(query);
    }
    retry?.cancel();
    refresh?.cancel();
    renewal?.cancel();
    adapter.session._resetListeners.remove(reset);
    await messages?.cancel();
    await socket?.close();
    final queryScope = _doListenCacheScope(scope, query);
    if (query is ModelAdapterCollectionQuery) {
      adapter.cachedRuntimeDatabase.removeCollectionListener(
          query as ModelAdapterCollectionQuery,
          prefix: queryScope);
      if (adapter is CachedListenableDurableObjectModelAdapter) {
        (adapter as CachedListenableDurableObjectModelAdapter)
            .cachedLocalDatabase
            .removeCollectionListener(query as ModelAdapterCollectionQuery,
                prefix: queryScope);
      }
    } else {
      adapter.cachedRuntimeDatabase.removeDocumentListener(
          query as ModelAdapterDocumentQuery,
          prefix: queryScope);
      if (adapter is CachedListenableDurableObjectModelAdapter) {
        (adapter as CachedListenableDurableObjectModelAdapter)
            .cachedLocalDatabase
            .removeDocumentListener(query as ModelAdapterDocumentQuery,
                prefix: queryScope);
      }
    }
    unawaited(controller.close());
  }
}

String _doListenCacheScope(String scope, Object query) {
  final modelQuery = query is ModelAdapterCollectionQuery
      ? query.query
      : (query as ModelAdapterDocumentQuery).query;
  return "$scope/__listen__/${base64Url.encode(utf8.encode(jsonEncode(modelQuery.toJson())))}";
}
