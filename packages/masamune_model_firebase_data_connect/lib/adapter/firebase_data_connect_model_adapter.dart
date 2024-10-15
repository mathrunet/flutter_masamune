part of '/masamune_model_firebase_data_connect.dart';

abstract class FirebaseDataConnectModelAdapterBase extends ModelAdapter {
  const FirebaseDataConnectModelAdapterBase({
    this.initialValue,
    NoSqlDatabase? localDatabase,
  }) : _localDatabase = localDatabase;

  /// The specified internal database, caching data retrieved from FirebaseDataConnect.
  ///
  /// 指定の内部データベース。FirebaseDataConnectから取得したデータをキャッシュします。
  NoSqlDatabase get localDatabase {
    final database = _localDatabase ?? sharedLocalDatabase;
    if (initialValue.isNotEmpty && !database.isInitialValueRegistered) {
      for (final raw in initialValue!) {
        if (raw is ModelInitialDocument) {
          final map = raw.toMap(raw.value);
          database.setInitialValue(
            raw.path,
            raw.filterOnSave(map, raw.value),
          );
        } else if (raw is ModelInitialCollection) {
          for (final tmp in raw.value.entries) {
            final map = raw.toMap(tmp.value);
            database.setInitialValue(
              "${raw.path}/${tmp.key}",
              raw.filterOnSave(map, tmp.value),
            );
          }
        }
      }
    }
    return database;
  }

  final NoSqlDatabase? _localDatabase;

  /// A common internal database throughout the app.
  ///
  /// アプリ内全体での共通の内部データベース。
  static final NoSqlDatabase sharedLocalDatabase = NoSqlDatabase();

  /// Actual data when used as a mock-up.
  ///
  /// モックアップとして利用する際の実データ。
  final List<ModelInitialValue>? initialValue;

  @override
  bool get availableListen => false;

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    localDatabase.removeCollectionListener(query);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    localDatabase.removeDocumentListener(query);
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
  Future<T?> loadAggregation<T>(ModelAdapterCollectionQuery query,
      ModelAggregateQuery<AsyncAggregateValue> aggregateQuery) {
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
    throw UnsupportedError("This function is not available.");
  }

  @override
  Future<void> clearCache() {
    return localDatabase.clearAll();
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }
}
