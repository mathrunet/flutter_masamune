part of "/masamune_model_functions.dart";

/// An adapter for reading from and writing to the database via Firebase Functions.
///
/// You interact with Functions by executing [DocumentModelFunctionsAction] and [CollectionModelFunctionsAction].
///
/// Firebase Functionsを経由してデータベースの読み書きを行うアダプター。
///
/// [DocumentModelFunctionsAction]と[CollectionModelFunctionsAction]を実行することによりFunctionsとのやりとりを行います。
class FunctionsModelAdapter extends ModelAdapter {
  /// An adapter for reading from and writing to the database via Firebase Functions.
  ///
  /// You interact with Functions by executing [DocumentModelFunctionsAction] and [CollectionModelFunctionsAction].
  ///
  /// Firebase Functionsを経由してデータベースの読み書きを行うアダプター。
  ///
  /// [DocumentModelFunctionsAction]と[CollectionModelFunctionsAction]を実行することによりFunctionsとのやりとりを行います。
  const FunctionsModelAdapter({
    required this.functionsAdapter,
    this.documentAction = "document_model_firestore",
    this.collectionAction = "collection_model_firestore",
    this.aggregateAction = "aggregate_model_firestore",
    this.databaseId,
    NoSqlDatabase? cachedRuntimeDatabase,
    this.vectorConverter = const RuntimeVectorConverter(),
  }) : _cachedRuntimeDatabase = cachedRuntimeDatabase;

  /// Caches data retrieved from the specified internal database, Firestore.
  ///
  /// 指定の内部データベース。Firestoreから取得したデータをキャッシュします。
  NoSqlDatabase get cachedRuntimeDatabase {
    final database = _cachedRuntimeDatabase ?? sharedRuntimeDatabase;
    return database;
  }

  final NoSqlDatabase? _cachedRuntimeDatabase;

  /// A common internal database throughout the app.
  ///
  /// アプリ内全体での共通の内部データベース。
  static final NoSqlDatabase sharedRuntimeDatabase = NoSqlDatabase();

  /// Document action.
  ///
  /// ドキュメントアクション。
  final String documentAction;

  /// Collection action.
  ///
  /// コレクションアクション。
  final String collectionAction;

  /// Aggregate action.
  ///
  /// 集計アクション。
  final String aggregateAction;

  /// Functions adapter.
  ///
  /// Functionsアダプター。
  final FunctionsAdapter functionsAdapter;

  /// Database ID.
  ///
  /// データベースID。
  final String? databaseId;

  @override
  final VectorConverter vectorConverter;

  @override
  bool get availableListen => false;

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final res = await functionsAdapter.execute(CollectionModelFunctionsAction(
      path: query.query.path,
      action: collectionAction,
      method: ApiMethod.get,
      databaseId: databaseId,
    ));
    if (!res.status.toString().startsWith("2")) {
      throw Exception("Failed to load collection");
    }
    final data = res.data ?? {};
    await cachedRuntimeDatabase.syncCollection(query, data);
    return data;
  }

  @override
  Future<DynamicMap> loadDocument(
    ModelAdapterDocumentQuery query,
  ) async {
    final res = await functionsAdapter.execute(DocumentModelFunctionsAction(
      path: query.query.path,
      action: documentAction,
      method: ApiMethod.get,
      databaseId: databaseId,
    ));
    if (!res.status.toString().startsWith("2")) {
      throw Exception("Failed to load document");
    }
    final data = res.data ?? {};
    await cachedRuntimeDatabase.syncDocument(query, data);
    return data;
  }

  @override
  Future<void> saveDocument(
      ModelAdapterDocumentQuery query, DynamicMap value) async {
    final res = await functionsAdapter.execute(DocumentModelFunctionsAction(
      path: query.query.path,
      action: documentAction,
      method: ApiMethod.post,
      data: value,
      databaseId: databaseId,
    ));
    if (!res.status.toString().startsWith("2")) {
      throw Exception("Failed to save document");
    }
    await cachedRuntimeDatabase.saveDocument(query, value);
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    final res = await functionsAdapter.execute(DocumentModelFunctionsAction(
      path: query.query.path,
      action: documentAction,
      method: ApiMethod.delete,
      databaseId: databaseId,
    ));
    if (!res.status.toString().startsWith("2")) {
      throw Exception("Failed to delete document");
    }
    await cachedRuntimeDatabase.deleteDocument(query);
  }

  @override
  Future<T?> loadAggregation<T>(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery<AsyncAggregateValue> aggregateQuery,
  ) async {
    final path =
        "${query.query.path.trimQuery().trimString("/")}/${aggregateQuery.key?.trimQuery().trimString("/") ?? ""}";
    final res = await functionsAdapter.execute(AggregateModelFunctionsAction(
      path: path,
      aggregateType: aggregateQuery.type,
      action: aggregateAction,
      databaseId: databaseId,
    ));
    if (!res.status.toString().startsWith("2")) {
      throw Exception("Failed to load aggregation");
    }
    final value = res.value;
    switch (aggregateQuery.type) {
      case ModelAggregateQueryType.count:
        final converted = value.toInt();
        if (converted is! T) {
          return null;
        }
        return converted as T;
      case ModelAggregateQueryType.sum:
      case ModelAggregateQueryType.average:
        final converted = value.toDouble();
        if (converted is! T) {
          return null;
        }
        return converted as T;
    }
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    cachedRuntimeDatabase.removeCollectionListener(query);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    cachedRuntimeDatabase.removeDocumentListener(query);
  }

  @override
  Future<List<StreamSubscription>> listenCollection(
      ModelAdapterCollectionQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
      ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void saveOnTransaction(ModelTransactionRef ref,
      ModelAdapterDocumentQuery query, DynamicMap value) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void deleteOnTransaction(
      ModelTransactionRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  FutureOr<void> runTransaction(
      FutureOr<void> Function(ModelTransactionRef ref) transaction) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void saveOnBatch(
      ModelBatchRef ref, ModelAdapterDocumentQuery query, DynamicMap value) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  FutureOr<void> runBatch(
      FutureOr<void> Function(ModelBatchRef ref) batch, int splitLength) {
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<void> clearAll() {
    return cachedRuntimeDatabase.clearAll();
  }

  @override
  Future<void> clearCache() {
    return cachedRuntimeDatabase.clearAll();
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return runtimeType.hashCode ^
        cachedRuntimeDatabase.hashCode ^
        documentAction.hashCode ^
        collectionAction.hashCode ^
        functionsAdapter.hashCode;
  }
}
