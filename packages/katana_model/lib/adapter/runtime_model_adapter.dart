part of katana_model;

/// Model adapter that uses a database that runs only in the memory of the application.
/// All data will be reset when the application is re-launched.
///
/// It is usually used for temporary databases under development or for testing.
///
/// Normally, a common database [sharedDatabase] is used for the entire app, but if you want to reset the database each time, for example for testing, pass an individual database to [database].
///
/// By passing data to [initialValue], the database can be used as a data mockup since it contains data in advance.
///
/// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
///
/// アプリのメモリ上でのみ動作するデータベースを利用したモデルアダプター。
///
/// アプリを立ち上げ直すとデータはすべてリセットされます。
///
/// 通常は開発途中の仮のデータベースやテスト用のデータベースに利用します。
///
/// 通常はアプリ内全体での共通のデータベース[sharedDatabase]が利用されますが、テスト用などで毎回データベースをリセットする場合は[database]に個別のデータベースを渡してください。
///
/// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
///
/// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
@immutable
class RuntimeModelAdapter extends ModelAdapter {
  /// Model adapter that uses a database that runs only in the memory of the application.
  /// All data will be reset when the application is re-launched.
  ///
  /// It is usually used for temporary databases under development or for testing.
  ///
  /// Normally, a common database [sharedDatabase] is used for the entire app, but if you want to reset the database each time, for example for testing, pass an individual database to [database].
  ///
  /// By passing data to [initialValue], the database can be used as a data mockup since it contains data in advance.
  ///
  /// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
  ///
  /// アプリのメモリ上でのみ動作するデータベースを利用したモデルアダプター。
  ///
  /// アプリを立ち上げ直すとデータはすべてリセットされます。
  ///
  /// 通常は開発途中の仮のデータベースやテスト用のデータベースに利用します。
  ///
  /// 通常はアプリ内全体での共通のデータベース[sharedDatabase]が利用されますが、テスト用などで毎回データベースをリセットする場合は[database]に個別のデータベースを渡してください。
  ///
  /// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
  ///
  /// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
  const RuntimeModelAdapter({
    NoSqlDatabase? database,
    this.initialValue,
    this.prefix,
  }) : _database = database;

  /// Designated database. Please use for testing purposes, etc.
  ///
  /// 指定のデータベース。テスト用途などにご利用ください。
  NoSqlDatabase get database {
    final database = _database ?? sharedDatabase;
    if (initialValue.isNotEmpty && !database.isInitialValueRegistered) {
      for (final raw in initialValue!) {
        if (raw is ModelInitialDocument) {
          final map = raw.toMap(raw.value);
          database.setInitialValue(
            _path(raw.path),
            raw.filterOnSave(map, raw.value),
          );
        } else if (raw is ModelInitialCollection) {
          for (final tmp in raw.value.entries) {
            final map = raw.toMap(tmp.value);
            database.setInitialValue(
              _path("${raw.path}/${tmp.key}"),
              raw.filterOnSave(map, tmp.value),
            );
          }
        }
      }
    }
    return database;
  }

  final NoSqlDatabase? _database;

  /// A common database throughout the application.
  ///
  /// アプリ内全体での共通のデータベース。
  static final NoSqlDatabase sharedDatabase = NoSqlDatabase();

  /// Actual data when used as a mock-up.
  ///
  /// モックアップとして利用する際の実データ。
  final List<ModelInitialValue>? initialValue;

  /// Path prefix.
  ///
  /// パスのプレフィックス。
  final String? prefix;

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final data = await database.loadDocument(query, prefix: prefix);
    return data != null ? Map.from(data) : {};
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final data = await database.loadCollection(query, prefix: prefix);
    return data != null
        ? data.map((key, value) => MapEntry(key, Map.from(value)))
        : {};
  }

  @override
  Future<int> loadCollectionCount(ModelAdapterCollectionQuery query) async {
    final data = await database.loadCollection(
      query.copyWith(query: query.query.remove(ModelQueryFilterType.limit)),
      prefix: prefix,
    );
    return data.length;
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    await database.deleteDocument(query, prefix: prefix);
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await database.saveDocument(query, value, prefix: prefix);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    database.removeDocumentListener(query, prefix: prefix);
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    database.removeCollectionListener(query, prefix: prefix);
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
    if (ref is! RuntimeModelTransactionRef) {
      throw Exception("[ref] is not [RuntimeModelTransactionRef].");
    }
    ref._transactionList.add(() => deleteDocument(query));
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    return loadDocument(query);
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! RuntimeModelTransactionRef) {
      throw Exception("[ref] is not [RuntimeModelTransactionRef].");
    }
    ref._transactionList.add(() => saveDocument(query, value));
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  ) async {
    final ref = RuntimeModelTransactionRef._();
    await transaction.call(ref);
    for (final tmp in ref._transactionList) {
      await tmp.call();
    }
  }

  @override
  void deleteOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    if (ref is! RuntimeModelBatchRef) {
      throw Exception("[ref] is not [RuntimeModelBatchRef].");
    }
    ref._batchList.add(() => deleteDocument(query));
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! RuntimeModelBatchRef) {
      throw Exception("[ref] is not [RuntimeModelBatchRef].");
    }
    ref._batchList.add(() => saveDocument(query, value));
  }

  @override
  FutureOr<void> runBatch(
    FutureOr<void> Function(
      ModelBatchRef ref,
    ) batch,
    int splitLength,
  ) async {
    final ref = RuntimeModelBatchRef._();
    await wait(
      ref._batchList.map((tmp) => tmp.call()),
    );
  }

  String _path(String original) {
    if (prefix.isEmpty) {
      return original;
    }
    final p = prefix!.trimQuery().trimString("/");
    final o = original.trimQuery().trimString("/");
    return "$p/$o";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return prefix.hashCode ^ database.hashCode ^ initialValue.hashCode;
  }
}

/// [ModelTransactionRef] for [RuntimeModelAdapter].
/// [RuntimeModelAdapter]用の[ModelTransactionRef]。
@immutable
class RuntimeModelTransactionRef extends ModelTransactionRef {
  RuntimeModelTransactionRef._();

  final List<FutureOr<void> Function()> _transactionList = [];
}

/// [ModelBatchRef] for [RuntimeModelAdapter].
/// [RuntimeModelAdapter]用の[ModelBatchRef]。
@immutable
class RuntimeModelBatchRef extends ModelBatchRef {
  RuntimeModelBatchRef._();

  final List<FutureOr<void> Function()> _batchList = [];
}
