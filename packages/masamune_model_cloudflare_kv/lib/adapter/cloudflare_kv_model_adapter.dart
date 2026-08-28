part of "/masamune_model_cloudflare_kv.dart";

/// A model adapter that enables the use of Cloudflare KV.
///
/// It can be used in conjunction with `@mathrunet/masamune_cloudflare_kv` to obtain, read, and write temporary tokens.
///
/// Cloudflare KVを利用できるようにしたモデルアダプター。
///
/// `@mathrunet/masamune_cloudflare_kv`と併用して、一時トークンの取得や読み書きを行うことが可能です。
class CloudflareKVModelAdapter extends ModelAdapter {
  /// A model adapter that enables the use of Cloudflare KV.
  ///
  /// It can be used in conjunction with `@mathrunet/masamune_cloudflare_kv` to obtain, read, and write temporary tokens.
  ///
  /// Cloudflare KVを利用できるようにしたモデルアダプター。
  ///
  /// `@mathrunet/masamune_cloudflare_kv`と併用して、一時トークンの取得や読み書きを行うことが可能です。
  const CloudflareKVModelAdapter({
    super.defaultAutoDisposeWhenUnreferenced,
    FunctionsAdapter? functionsAdapter,
  }) : _functionsAdapter = functionsAdapter;

  /// Functions adapter for obtaining and reading/writing temporary tokens.
  ///
  /// トークンの取得や読み書きを行うためのFunctionsアダプター。
  FunctionsAdapter get functionsAdapter {
    return _functionsAdapter ?? FunctionsAdapter.primary;
  }

  final FunctionsAdapter? _functionsAdapter;

  @override
  VectorConverter get vectorConverter => const PassVectorConverter();

  @override
  bool get availableListen => false;

  @override
  Future<void> clearAll() {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<void> clearCache() {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    await functionsAdapter.execute(CloudflareKvDeleteDocumentFunctionsAction(
      key: query.query.path,
    ));
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void deleteOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {}

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {}

  @override
  Future<List<StreamSubscription<dynamic>>> listenCollection(
      ModelAdapterCollectionQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<List<StreamSubscription<dynamic>>> listenDocument(
      ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<T?> loadAggregation<T>(ModelAdapterCollectionQuery query,
      ModelAggregateQuery<AsyncAggregateValue<dynamic>> aggregateQuery) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
      ModelAdapterCollectionQuery query) async {
    final res =
        await functionsAdapter.execute(CloudflareKvGetCollectionFunctionsAction(
      key: query.query.path,
    ));
    return res.data.map((key, value) {
      if (value is DynamicMap) {
        return MapEntry(key, ModelFieldValue.fromMap(value));
      }
      if (value is Map) {
        return MapEntry(
          key,
          ModelFieldValue.fromMap(Map<String, dynamic>.from(value)),
        );
      }
      return MapEntry(key, <String, dynamic>{});
    });
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final res =
        await functionsAdapter.execute(CloudflareKvGetDocumentFunctionsAction(
      key: query.query.path,
    ));
    return ModelFieldValue.fromMap(res.data);
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  FutureOr<void> runBatch(
      FutureOr<void> Function(ModelBatchRef ref) batch, int splitLength) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  FutureOr<void> runTransaction(
      FutureOr<void> Function(ModelTransactionRef ref) transaction) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<void> saveDocument(
      ModelAdapterDocumentQuery query, DynamicMap value) async {
    await functionsAdapter.execute(CloudflareKvPutDocumentFunctionsAction(
      key: query.query.path,
      value: ModelFieldValue.toMap(value),
    ));
  }

  @override
  void saveOnBatch(
      ModelBatchRef ref, ModelAdapterDocumentQuery query, DynamicMap value) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void saveOnTransaction(ModelTransactionRef ref,
      ModelAdapterDocumentQuery query, DynamicMap value) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return functionsAdapter.hashCode;
  }
}
