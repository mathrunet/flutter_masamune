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
  // TODO: implement availableListen
  bool get availableListen => throw UnimplementedError();

  @override
  Future<void> clearAll() {
    // TODO: implement clearAll
    throw UnimplementedError();
  }

  @override
  Future<void> clearCache() {
    // TODO: implement clearCache
    throw UnimplementedError();
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) {
    // TODO: implement deleteDocument
    throw UnimplementedError();
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    // TODO: implement deleteOnBatch
  }

  @override
  void deleteOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    // TODO: implement deleteOnTransaction
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    // TODO: implement disposeCollection
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    // TODO: implement disposeDocument
  }

  @override
  Future<List<StreamSubscription<dynamic>>> listenCollection(
      ModelAdapterCollectionQuery query) {
    // TODO: implement listenCollection
    throw UnimplementedError();
  }

  @override
  Future<List<StreamSubscription<dynamic>>> listenDocument(
      ModelAdapterDocumentQuery query) {
    // TODO: implement listenDocument
    throw UnimplementedError();
  }

  @override
  Future<T?> loadAggregation<T>(ModelAdapterCollectionQuery query,
      ModelAggregateQuery<AsyncAggregateValue<dynamic>> aggregateQuery) {
    // TODO: implement loadAggregation
    throw UnimplementedError();
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
      ModelAdapterCollectionQuery query) {
    // TODO: implement loadCollection
    throw UnimplementedError();
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) {
    // TODO: implement loadDocument
    throw UnimplementedError();
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    // TODO: implement loadOnTransaction
    throw UnimplementedError();
  }

  @override
  FutureOr<void> runBatch(
      FutureOr<void> Function(ModelBatchRef ref) batch, int splitLength) {
    // TODO: implement runBatch
    throw UnimplementedError();
  }

  @override
  FutureOr<void> runTransaction(
      FutureOr<void> Function(ModelTransactionRef ref) transaction) {
    // TODO: implement runTransaction
    throw UnimplementedError();
  }

  @override
  Future<void> saveDocument(ModelAdapterDocumentQuery query, DynamicMap value) {
    // TODO: implement saveDocument
    throw UnimplementedError();
  }

  @override
  void saveOnBatch(
      ModelBatchRef ref, ModelAdapterDocumentQuery query, DynamicMap value) {
    // TODO: implement saveOnBatch
  }

  @override
  void saveOnTransaction(ModelTransactionRef ref,
      ModelAdapterDocumentQuery query, DynamicMap value) {
    // TODO: implement saveOnTransaction
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return functionsAdapter.hashCode;
  }
}
