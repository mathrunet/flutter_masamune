part of "/masamune_model_do.dart";

/// 購読snapshotをquery別に永続保存するDO Adapter。
/// 再接続では必ず認可付きsnapshotを取得し、古いキャッシュを確定値としない。
class CachedListenableDurableObjectModelAdapter
    extends CachedDurableObjectModelAdapter with _DurableObjectListening {
  /// 認証スコープ別のキャッシュと購読接続を構成する。
  const CachedListenableDurableObjectModelAdapter({
    required super.prefix,
    required super.session,
    required super.cachedLocalDatabase,
    super.functionsAdapter,
    super.cachedRuntimeDatabase,
    super.vectorConverter,
    super.defaultAutoDisposeWhenUnreferenced,
    super.collectionLoaders,
    super.cacheFilter,
    this.socketConnector = DurableObjectSocket.connect,
    this.onListenError,
  });
  @override
  final Future<DurableObjectSocket> Function(Uri) socketConnector;
  @override
  final void Function(Object, StackTrace)? onListenError;

  @override
  Future<DynamicMap?> onPreloadDocument(ModelAdapterDocumentQuery query) async {
    if (query.reload) {
      return null;
    }
    return cachedLocalDatabase.loadDocument(query,
        prefix: _doListenCacheScope(cachePrefix!, query));
  }

  @override
  Future<void> onPostloadDocument(
      ModelAdapterDocumentQuery query, DynamicMap value) async {
    final allowed = cacheFilter == null || cacheFilter!(query.query, value);
    await cachedLocalDatabase.syncDocument(query, allowed ? value : {},
        prefix: _doListenCacheScope(cachePrefix!, query));
  }

  @override
  Future<CachedDurableObjectModelCollectionLoaderResponse?> onPreloadCollection(
      ModelAdapterCollectionQuery query) async {
    if (query.reload) {
      return null;
    }
    final value = await cachedLocalDatabase.loadCollection(query,
        prefix: _doListenCacheScope(cachePrefix!, query));
    if (value == null) {
      return super.onPreloadCollection(query);
    }
    return CachedDurableObjectModelCollectionLoaderResponse(value: value);
  }

  @override
  Future<void> onPostloadCollection(
      ModelAdapterCollectionQuery query, Map<String, DynamicMap> value) async {
    final filtered = {
      for (final e in value.entries)
        if (cacheFilter == null ||
            cacheFilter!(query.query.create(e.key), e.value))
          e.key: e.value
    };
    await cachedLocalDatabase.syncCollection(query, filtered,
        prefix: _doListenCacheScope(cachePrefix!, query), overwrite: true);
  }

  @override
  Future<void> onSaveDocument(
          ModelAdapterDocumentQuery query, DynamicMap value) =>
      onPostloadDocument(query, value);
  @override
  Future<void> onDeleteDocument(ModelAdapterDocumentQuery query) =>
      onPostloadDocument(query, {});
}
