part of '/masamune_model_algolia.dart';

/// Model adapter with Algolia available.
///
/// Please obtain [applicationId] and [apiKey] from the Algolia dashboard and give them to us.
///
/// Only [loadCollection] is available.
///
/// Algoliaを利用できるようにしたモデルアダプター。
///
/// Algoliaのダッシュボードにて[applicationId]と[apiKey]を取得して与えてください。
///
/// [loadCollection]のみ利用可能です。
class AlgoliaModelAdapter extends ModelAdapter {
  /// Model adapter with Algolia available.
  ///
  /// Please obtain [applicationId] and [apiKey] from the Algolia dashboard and give them to us.
  ///
  /// Only [loadCollection] is available.
  ///
  /// Algoliaを利用できるようにしたモデルアダプター。
  ///
  /// Algoliaのダッシュボードにて[applicationId]と[apiKey]を取得して与えてください。
  ///
  /// [loadCollection]のみ利用可能です。
  const AlgoliaModelAdapter({
    required this.applicationId,
    required this.apiKey,
  });

  /// Algolia application ID.
  ///
  /// AlgoliaのアプリケーションID。
  final String applicationId;

  /// API key for Algolia.
  ///
  /// AlgoliaのAPIキー。
  final String apiKey;

  static final Map<String, _AlgoliaSearcherCache> _cache = {};

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    final path = _path(query.query.path);
    final indexName = path.last();
    final cache = _cache[indexName];
    cache?.subscription.cancel();
    _cache.remove(indexName);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final cache = await _loadCollection(query);
    return cache?.results ?? {};
  }

  Future<_AlgoliaSearcherCache?> _loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final path = _path(query.query.path);
    final indexName = path.last();
    final cache = _cache[indexName];
    final searcher = cache?.searcher ??
        HitsSearcher.create(
          applicationID: applicationId,
          apiKey: apiKey,
          state: SearchState(
            indexName: indexName,
            page: _page(query),
            hitsPerPage: _hitsPerPage(query),
            query: _query(query),
          ),
        );
    final stream = cache?.stream ?? searcher.responses;
    final subscription = cache?.subscription ??
        stream.listen(
          (event) {
            _update(indexName, event);
          },
        );
    _cache[indexName] = cache ??
        _AlgoliaSearcherCache(
          indexName: indexName,
          searcher: searcher,
          stream: stream,
          subscription: subscription,
        );
    final event = await stream.last;
    _update(indexName, event);
    return cache;
  }

  @override
  Future<num> loadAggregation(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery aggregateQuery,
  ) async {
    switch (aggregateQuery.type) {
      case ModelAggregateQueryType.count:
        final cache = await _loadCollection(query);
        return cache?.length ?? 0;
      default:
        throw UnsupportedError("This function is not available.");
    }
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    throw UnsupportedError("This function is not available.");
  }

  @override
  bool get availableListen => false;

  @override
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  ) {
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  void deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) async {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  ) async {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  FutureOr<void> runBatch(
    FutureOr<void> Function(
      ModelBatchRef ref,
    ) batch,
    int splitLength,
  ) async {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<void> clearAll() {
    throw UnimplementedError("This function is not available.");
  }

  int? _page(
    ModelAdapterCollectionQuery query,
  ) {
    if (query.query.filters.any((e) => e.type == ModelQueryFilterType.limit)) {
      return query.page;
    }
    return null;
  }

  int? _hitsPerPage(
    ModelAdapterCollectionQuery query,
  ) {
    final found = query.query.filters
        .firstWhereOrNull((e) => e.type == ModelQueryFilterType.limit);
    final value = found?.value;
    if (value is int) {
      return value;
    }
    return null;
  }

  String? _query(
    ModelAdapterCollectionQuery query,
  ) {
    final found = query.query.filters
        .firstWhereOrNull((e) => e.type == ModelQueryFilterType.like);
    final value = found?.value;
    if (value is String) {
      return value;
    }
    return null;
  }

  void _update(String indexName, SearchResponse response) {
    final cache = _cache[indexName];
    if (cache == null) {
      return;
    }
    final res = <String, DynamicMap>{};
    for (final hit in response.hits) {
      final key = hit.get(kUidFieldKey, "");
      if (key.isEmpty) {
        continue;
      }
      res[key] = Map.from(hit);
    }
    _cache[indexName] = cache.copyWith(
      results: res,
      length: response.nbHits,
    );
  }

  String _path(String original) {
    final path = original.trimQuery().trimString("/");
    final paths = path.split("/");
    assert(paths.length <= 2, "The path must be up to two levels.");
    return path;
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return applicationId.hashCode ^ apiKey.hashCode;
  }
}

@immutable
class _AlgoliaSearcherCache {
  const _AlgoliaSearcherCache({
    required this.indexName,
    required this.searcher,
    required this.stream,
    required this.subscription,
    this.results = const {},
    this.length = 0,
  });

  final String indexName;
  final HitsSearcher searcher;
  final Stream<SearchResponse> stream;
  final StreamSubscription<SearchResponse> subscription;

  final Map<String, DynamicMap> results;
  final int length;

  _AlgoliaSearcherCache copyWith({
    Map<String, DynamicMap>? results,
    int? length,
  }) {
    return _AlgoliaSearcherCache(
      indexName: indexName,
      searcher: searcher,
      stream: stream,
      subscription: subscription,
      results: {
        ...this.results,
        if (results != null) ...results,
      },
      length: length ?? this.length,
    );
  }
}
