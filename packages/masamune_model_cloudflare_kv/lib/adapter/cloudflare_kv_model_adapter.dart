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
    this.vectorConverter = const PassVectorConverter(),
  }) : _functionsAdapter = functionsAdapter;

  /// Functions adapter for obtaining and reading/writing temporary tokens.
  ///
  /// トークンの取得や読み書きを行うためのFunctionsアダプター。
  FunctionsAdapter get functionsAdapter {
    return _functionsAdapter ?? FunctionsAdapter.primary;
  }

  final FunctionsAdapter? _functionsAdapter;

  @override
  final VectorConverter vectorConverter;

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
    DynamicMap? nearest;
    int? limit;
    for (final filter in query.query.filters) {
      switch (filter.type) {
        case ModelQueryFilterType.nearest:
          if (nearest != null || filter.key.isEmpty) {
            throw ArgumentError("nearestは1フィールドだけ指定できます。");
          }
          final value = filter.value;
          nearest = {
            "key": filter.key,
            "value": value is String
                ? await vectorConverter.toVector(value)
                : value is VectorValue
                    ? {"vector": value.vector, "measure": value.measure.name}
                    : value is ModelFieldValue
                        ? value.toJson()
                        : value,
          };
        case ModelQueryFilterType.limit:
          if (filter.value is! int || (filter.value as int) <= 0) {
            throw ArgumentError("limitは正の整数で指定してください。");
          }
          limit = filter.value as int;
        case ModelQueryFilterType.collectionGroup:
        case ModelQueryFilterType.notifyDocumentChanges:
          continue;
        default:
          throw UnsupportedError(
              "CloudflareKVModelAdapter does not support ${filter.type.name}.");
      }
    }
    final res =
        await functionsAdapter.execute(CloudflareKvGetCollectionFunctionsAction(
      key: query.query.path,
      nearest: nearest,
      limit: limit,
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
