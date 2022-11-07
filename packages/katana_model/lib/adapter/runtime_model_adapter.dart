part of katana_model;

/// Model adapter that uses a database that runs only in the memory of the application.
/// All data will be reset when the application is re-launched.
///
/// It is usually used for temporary databases under development or for testing.
///
/// Normally, a common database [sharedDatabase] is used for the entire app, but if you want to reset the database each time, for example for testing, pass an individual database to [database].
///
/// By passing data to [RuntimeModelAdapter.setRawData], the database can be used as a data mockup since it contains data in advance.
///
/// アプリのメモリ上でのみ動作するデータベースを利用したモデルアダプター。
///
/// アプリを立ち上げ直すとデータはすべてリセットされます。
///
/// 通常は開発途中の仮のデータベースやテスト用のデータベースに利用します。
///
/// 通常はアプリ内全体での共通のデータベース[sharedDatabase]が利用されますが、テスト用などで毎回データベースをリセットする場合は[database]に個別のデータベースを渡してください。
///
/// [RuntimeModelAdapter.setRawData]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
@immutable
class RuntimeModelAdapter extends ModelAdapter {
  /// Model adapter that uses a database that runs only in the memory of the application.
  /// All data will be reset when the application is re-launched.
  ///
  /// It is usually used for temporary databases under development or for testing.
  ///
  /// Normally, a common database [sharedDatabase] is used for the entire app, but if you want to reset the database each time, for example for testing, pass an individual database to [database].
  ///
  /// By passing data to [RuntimeModelAdapter.setRawData], the database can be used as a data mockup since it contains data in advance.
  ///
  /// アプリのメモリ上でのみ動作するデータベースを利用したモデルアダプター。
  ///
  /// アプリを立ち上げ直すとデータはすべてリセットされます。
  ///
  /// 通常は開発途中の仮のデータベースやテスト用のデータベースに利用します。
  ///
  /// 通常はアプリ内全体での共通のデータベース[sharedDatabase]が利用されますが、テスト用などで毎回データベースをリセットする場合は[database]に個別のデータベースを渡してください。
  ///
  /// [RuntimeModelAdapter.setRawData]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
  const RuntimeModelAdapter({NoSqlDatabase? database}) : _database = database;

  /// Designated database. Please use for testing purposes, etc.
  ///
  /// 指定のデータベース。テスト用途などにご利用ください。
  NoSqlDatabase get database => _database ?? sharedDatabase;
  final NoSqlDatabase? _database;

  /// A common database throughout the application.
  ///
  /// アプリ内全体での共通のデータベース。
  static final NoSqlDatabase sharedDatabase = NoSqlDatabase();

  @override
  void setRawData(Map<String, DynamicMap> rawData) {
    if (rawData.isEmpty) {
      return;
    }
    for (final tmp in rawData.entries) {
      database.setRawData(tmp.key, tmp.value);
    }
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final data = await database.loadDocument(query);
    return data != null ? Map.from(data) : {};
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final data = await database.loadCollection(query);
    return data != null
        ? data.map((key, value) => MapEntry(key, Map.from(value)))
        : {};
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    await database.deleteDocument(query);
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await database.saveDocument(query, value);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    database.removeDocumentListener(query);
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    database.removeCollectionListener(query);
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
  FutureOr<void> deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    return deleteDocument(query);
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    return loadDocument(query);
  }

  @override
  FutureOr<void> saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    return saveDocument(query, value);
  }

  @override
  FutureOr<void> runTransaction<T>(
    DocumentBase<T> doc,
    FutureOr<void> Function(
      ModelTransactionRef ref,
      ModelTransactionDocument<T> doc,
    )
        transaction,
  ) async {
    const ref = RuntimeModelTransactionRef._();
    await transaction.call(ref, ref.read(doc));
  }
}

/// [ModelTransactionRef] for [RuntimeModelAdapter].
/// [RuntimeModelAdapter]用の[ModelTransactionRef]。
@immutable
class RuntimeModelTransactionRef extends ModelTransactionRef {
  const RuntimeModelTransactionRef._();
}
