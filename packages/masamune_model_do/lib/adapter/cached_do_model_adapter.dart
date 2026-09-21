part of "/masamune_model_do.dart";

const _kCachedDurableObjectLocalDatabaseId = "localdo://";

/// A DurableObject model adapter that persistently caches loaded data on the device.
///
/// Documents are loaded from [cachedLocalDatabase] before DurableObject. Collection
/// cache loading can be customized with [collectionLoaders]. Use an explicit
/// reload when fresh remote data is required.
///
/// 読み込んだデータを端末へ永続的にキャッシュするDurableObjectモデルアダプター。
///
/// ドキュメントはDurableObjectより先に[cachedLocalDatabase]から読み込みます。コレクション
/// キャッシュの読込は[collectionLoaders]でカスタマイズできます。リモートの最新データが
/// 必要な場合は明示的に再読込してください。
class CachedDurableObjectModelAdapter extends DurableObjectModelAdapter {
  /// Creates a DurableObject model adapter with a persistent local cache.
  ///
  /// 永続ローカルキャッシュを持つDurableObjectモデルアダプターを作成します。
  const CachedDurableObjectModelAdapter({
    required super.prefix,
    required super.session,
    super.vectorConverter,
    super.defaultAutoDisposeWhenUnreferenced,
    super.functionsAdapter,
    super.cachedRuntimeDatabase,
    NoSqlDatabase? cachedLocalDatabase,
    this.collectionLoaders = const [],
    this.cacheFilter,
  }) : _cachedLocalDatabase = cachedLocalDatabase;

  /// Persistent local cache database.
  ///
  /// 永続ローカルキャッシュデータベース。
  NoSqlDatabase get cachedLocalDatabase {
    return _cachedLocalDatabase ?? sharedLocalDatabase;
  }

  final NoSqlDatabase? _cachedLocalDatabase;

  /// Shared persistent local cache database.
  ///
  /// アプリ全体で共有される永続ローカルキャッシュデータベース。
  static final NoSqlDatabase sharedLocalDatabase = NoSqlDatabase(
    onInitialize: (database) async {
      try {
        database.data = await DatabaseExporter.import(
          "${await DatabaseExporter.documentDirectory}/${_kCachedDurableObjectLocalDatabaseId.toSHA1()}",
        );
      } catch (_) {
        database.data = {};
      }
    },
    onSaved: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kCachedDurableObjectLocalDatabaseId.toSHA1()}",
        database.data,
      );
    },
    onDeleted: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kCachedDurableObjectLocalDatabaseId.toSHA1()}",
        database.data,
      );
    },
    onClear: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kCachedDurableObjectLocalDatabaseId.toSHA1()}",
        {},
      );
    },
  );

  /// Filter that determines whether a document is cached.
  ///
  /// ドキュメントをキャッシュするかを決定するフィルター。
  final bool Function(DocumentModelQuery query, DynamicMap value)? cacheFilter;

  /// Collection cache loaders, applied in order.
  ///
  /// 順番に適用されるコレクションキャッシュローダー。
  final List<CachedDurableObjectModelAdapterCollectionLoader> collectionLoaders;

  /// Loads a collection from the persistent cache with prefix isolation.
  ///
  /// プレフィックス分離を適用して永続キャッシュからコレクションを読み込みます。
  Future<Map<String, DynamicMap>?> loadCachedCollection(
    ModelAdapterCollectionQuery query,
  ) {
    return cachedLocalDatabase.loadCollection(query, prefix: cachePrefix);
  }

  @override
  Future<void> onDeleteDocument(ModelAdapterDocumentQuery query) async {
    await cachedLocalDatabase.deleteDocument(query, prefix: cachePrefix);
  }

  @override
  Future<void> onSaveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    if (cacheFilter == null || cacheFilter!.call(query.query, value)) {
      await cachedLocalDatabase.saveDocument(
        query,
        value,
        prefix: cachePrefix,
      );
    } else {
      await cachedLocalDatabase.deleteDocument(query, prefix: cachePrefix);
    }
  }

  @override
  Future<DynamicMap?> onPreloadDocument(
    ModelAdapterDocumentQuery query,
  ) async {
    if (query.reload) {
      return null;
    }
    return await cachedLocalDatabase.loadDocument(
      query,
      prefix: cachePrefix,
    );
  }

  @override
  Future<void> onPostloadDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    if (cacheFilter == null || cacheFilter!.call(query.query, value)) {
      await cachedLocalDatabase.saveDocument(
        query,
        value,
        prefix: cachePrefix,
      );
    } else {
      await cachedLocalDatabase.deleteDocument(query, prefix: cachePrefix);
    }
  }

  @override
  Future<CachedDurableObjectModelCollectionLoaderResponse?> onPreloadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    if (query.reload) {
      return null;
    }
    CachedDurableObjectModelCollectionLoaderResponse? response;
    for (final loader in collectionLoaders) {
      response = await loader.call(
        response?.query ?? query,
        response?.value,
      );
    }
    return response;
  }

  @override
  Future<void> onPostloadCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap> value,
  ) async {
    final filtered = <String, DynamicMap>{};
    for (final entry in value.entries) {
      if (cacheFilter == null ||
          cacheFilter!.call(query.query.create(entry.key), entry.value)) {
        filtered[entry.key] = entry.value;
      }
    }
    await cachedLocalDatabase.syncCollection(query, filtered,
        prefix: cachePrefix);
  }

  @override
  Future<void> clearCache() async {
    await super.clearCache();
    await cachedLocalDatabase.clearAll();
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return super.hashCode ^
        cachedLocalDatabase.hashCode ^
        collectionLoaders.hashCode ^
        cacheFilter.hashCode;
  }
}
