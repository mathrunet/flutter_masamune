part of "/masamune_model_algolia.dart";

/// Model adapter with Algolia available.
///
/// Please obtain [applicationId] and [apiKey] from the Algolia dashboard and give them to us.
///
/// Only [loadCollection] is available.
///
/// Give [firestoreModelAdapter] and use Firestore except for [loadCollection].
///
/// Algoliaを利用できるようにしたモデルアダプター。
///
/// Algoliaのダッシュボードにて[applicationId]と[apiKey]を取得して与えてください。
///
/// [firestoreModelAdapter]を与え[loadCollection]以外はFirestoreを利用するようにします。
class AlgoliaModelAdapter extends ModelAdapter {
  /// Model adapter with Algolia available.
  ///
  /// Please obtain [applicationId] and [apiKey] from the Algolia dashboard and give them to us.
  ///
  /// Only [loadCollection] is available.
  ///
  /// Give [firestoreModelAdapter] and use Firestore except for [loadCollection].
  ///
  /// Algoliaを利用できるようにしたモデルアダプター。
  ///
  /// Algoliaのダッシュボードにて[applicationId]と[apiKey]を取得して与えてください。
  ///
  /// [firestoreModelAdapter]を与え[loadCollection]以外は
  const AlgoliaModelAdapter({
    required this.firestoreModelAdapter,
    required this.applicationId,
    required this.apiKey,
  });

  /// Firestore model adapter.
  ///
  /// Firestoreモデルアダプター。
  final FirestoreModelAdapterBase firestoreModelAdapter;

  /// Algolia application ID.
  ///
  /// AlgoliaのアプリケーションID。
  final String applicationId;

  /// API key for Algolia.
  ///
  /// AlgoliaのAPIキー。
  final String apiKey;

  @override
  VectorConverter get vectorConverter => const PassVectorConverter();

  /// A special class can be registered as a [ModelFieldValue] by passing [FirestoreModelFieldValueConverter] to [converter].
  ///
  /// [FirestoreModelFieldValueConverter]を[converter]に渡すことで特殊なクラスを[ModelFieldValue]として登録することができます。
  static void registerConverter(FirestoreModelFieldValueConverter converter) {
    _converters.add(converter);
  }

  /// By passing [FirestoreModelFieldValueConverter] to [converter], you can release an already registered [FirestoreModelFieldValueConverter].
  ///
  /// [converter]に[FirestoreModelFieldValueConverter]を渡すことですでに登録されている[FirestoreModelFieldValueConverter]を解除することができます。
  static void unregisterConverter(FirestoreModelFieldValueConverter converter) {
    _converters.remove(converter);
  }

  static final Set<FirestoreModelFieldValueConverter> _converters = {
    ...FirestoreModelFieldValueConverter.defaultConverters
  }..removeWhere((element) => element is FirestoreModelRefConverter);

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    await firestoreModelAdapter.deleteDocument(query);
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) {
    return firestoreModelAdapter.loadDocument(query);
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {}

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    firestoreModelAdapter.disposeDocument(query);
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    if (firestoreModelAdapter.validator != null) {
      await firestoreModelAdapter.validator!.onPreloadCollection(query);
    }
    final response = await _loadCollection(query);
    if (firestoreModelAdapter.validator != null) {
      await firestoreModelAdapter.validator!.onPostloadCollection(
        query,
        response?.results,
      );
    }
    return response?.results ?? {};
  }

  Future<_AlgoliaResponce?> _loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final path = _path(query.query.path);
    final indexName = path.last();
    Completer<void>? completer;
    _AlgoliaResponce? response;
    HitsSearcher? searcher;
    StreamSubscription? subscription;
    try {
      completer = Completer<void>();
      searcher = HitsSearcher.create(
        applicationID: applicationId,
        apiKey: apiKey,
        state: SearchState(
          indexName: indexName,
          page: _page(query),
          hitsPerPage: _hitsPerPage(query),
          query: _query(query),
        ),
      );
      subscription = searcher.responses.listen(
        (event) {
          response = _update(query, event);
          completer?.complete();
          completer = null;
        },
        onError: (e) {
          completer?.completeError(e);
          completer = null;
        },
      );
      await completer?.future;
      completer = null;
      return response;
    } catch (e) {
      completer?.completeError(e);
      completer = null;
      rethrow;
    } finally {
      unawaited(subscription?.cancel());
      searcher?.dispose();
      completer?.complete();
      completer = null;
    }
  }

  @override
  Future<T?> loadAggregation<T>(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery aggregateQuery,
  ) async {
    switch (aggregateQuery.type) {
      case ModelAggregateQueryType.count:
        final response = await _loadCollection(query);
        final val = response?.length ?? 0;
        if (val is! T) {
          return null;
        }
        return val as T;
      default:
        throw UnsupportedError("This function is not available.");
    }
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    return firestoreModelAdapter.saveDocument(query, value);
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
    return firestoreModelAdapter.deleteOnTransaction(ref, query);
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    return firestoreModelAdapter.loadOnTransaction(ref, query);
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    return firestoreModelAdapter.saveOnTransaction(ref, query, value);
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  ) {
    return firestoreModelAdapter.runTransaction(transaction);
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    deleteOnBatch(ref, query);
  }

  @override
  FutureOr<void> runBatch(
    FutureOr<void> Function(
      ModelBatchRef ref,
    ) batch,
    int splitLength,
  ) {
    return firestoreModelAdapter.runBatch(batch, splitLength);
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    return firestoreModelAdapter.saveOnBatch(ref, query, value);
  }

  @override
  Future<void> clearAll() {
    return firestoreModelAdapter.clearAll();
  }

  @override
  Future<void> clearCache() {
    return firestoreModelAdapter.clearCache();
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

  _AlgoliaResponce _update(
    ModelAdapterCollectionQuery query,
    SearchResponse response,
  ) {
    final res = <String, DynamicMap>{};
    for (final hit in response.hits) {
      final key = hit.get(kUidFieldKey, "");
      if (key.isEmpty) {
        continue;
      }
      res[key] = _convertFrom(Map.from(hit));
    }
    return _AlgoliaResponce(
      results: res,
      length: response.nbHits,
    );
  }

  DynamicMap _convertFrom(DynamicMap map) {
    final res = <String, dynamic>{};

    for (final tmp in map.entries) {
      final key = tmp.key;
      final val = tmp.value;
      DynamicMap? replaced;
      for (final converter in _converters) {
        replaced = converter.convertFrom(key, val, map);
        if (replaced != null) {
          break;
        }
      }
      if (replaced != null) {
        res.addAll(replaced);
      } else {
        res[key] = val;
      }
    }
    return res;
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
    return applicationId.hashCode ^
        apiKey.hashCode ^
        firestoreModelAdapter.hashCode;
  }
}

@immutable
class _AlgoliaResponce {
  const _AlgoliaResponce({
    required this.results,
    required this.length,
  });

  final Map<String, Map<String, dynamic>> results;
  final int length;
}
