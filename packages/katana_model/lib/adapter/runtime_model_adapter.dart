part of '/katana_model.dart';

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
/// If [validator] is specified, validation is performed in the database.
///
/// Specify [networkDelay] to simulate communication delay.
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
///
/// [validator]を指定するとデータベース内でのバリデーションが行われます。
///
/// [networkDelay]を指定すると通信の遅延をシミュレートすることができます。
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
  /// If [validator] is specified, validation is performed in the database.
  ///
  /// Specify [networkDelay] to simulate communication delay.
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
  ///
  /// [validator]を指定するとデータベース内でのバリデーションが行われます。
  ///
  /// [networkDelay]を指定すると通信の遅延をシミュレートすることができます。
  const RuntimeModelAdapter({
    NoSqlDatabase? database,
    this.initialValue,
    this.prefix,
    this.validator,
    this.networkDelay,
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

  /// Specify the permission validator for the database.
  ///
  /// If [Null], no validation is performed.
  ///
  /// データベースのパーミッションバリデーターを指定します。
  ///
  /// [Null]のときはバリデーションされません。
  final DatabaseValidator? validator;

  /// Actual data when used as a mock-up.
  ///
  /// モックアップとして利用する際の実データ。
  final List<ModelInitialValue>? initialValue;

  /// Path prefix.
  ///
  /// パスのプレフィックス。
  final String? prefix;

  /// Delay time to simulate communication delays.
  ///
  /// 通信の遅延をシミュレートするための遅延時間。
  final Duration? networkDelay;

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    _assert();
    if (validator != null) {
      await validator!.onPreloadDocument(query);
    }
    if (networkDelay != null) {
      await Future.delayed(networkDelay!);
    }
    final data = await database.loadDocument(query, prefix: prefix);
    if (validator != null) {
      await validator!.onPostloadDocument(query, data);
    }
    return data != null ? Map.from(data) : {};
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    _assert();
    if (validator != null) {
      await validator!.onPreloadCollection(query);
    }
    if (networkDelay != null) {
      await Future.delayed(networkDelay!);
    }
    final data = await database.loadCollection(query, prefix: prefix);
    if (validator != null) {
      await validator!.onPostloadCollection(query, data);
    }
    return data != null
        ? data.map((key, value) => MapEntry(key, Map.from(value)))
        : {};
  }

  @override
  Future<T?> loadAggregation<T>(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery aggregateQuery,
  ) async {
    _assert();
    switch (aggregateQuery.type) {
      case ModelAggregateQueryType.count:
        if (networkDelay != null) {
          await Future.delayed(networkDelay!);
        }
        final data = await database.loadCollection(
          query.copyWith(query: query.query.remove(ModelQueryFilterType.limit)),
          prefix: prefix,
        );
        final val = data.length;
        if (val is! T) {
          return null;
        }
        return val as T;
      case ModelAggregateQueryType.sum:
        final key = aggregateQuery.key;
        assert(
          key.isNotEmpty,
          "Enter [key] for [ModelAggregateQueryType.sum].",
        );
        if (networkDelay != null) {
          await Future.delayed(networkDelay!);
        }
        final data = await database.loadCollection(
          query.copyWith(query: query.query.remove(ModelQueryFilterType.limit)),
          prefix: prefix,
        );
        final val =
            data?.values.fold<double>(0.0, (p, e) => p + e.get(key!, 0.0)) ??
                0.0;
        if (val is! T) {
          return null;
        }
        return val as T;
      case ModelAggregateQueryType.average:
        final key = aggregateQuery.key;
        assert(
          aggregateQuery.key.isNotEmpty,
          "Enter [key] for [ModelAggregateQueryType.average].",
        );
        if (networkDelay != null) {
          await Future.delayed(networkDelay!);
        }
        final data = await database.loadCollection(
          query.copyWith(query: query.query.remove(ModelQueryFilterType.limit)),
          prefix: prefix,
        );
        final val =
            (data?.values.fold<double>(0.0, (p, e) => p + e.get(key!, 0.0)) ??
                    0.0) /
                data.length;
        if (val is! T) {
          return null;
        }
        return val as T;
    }
  }

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    await _deleteDocument(query);
    if (networkDelay != null) {
      await Future.delayed(networkDelay!);
    }
  }

  Future<void> _deleteDocument(ModelAdapterDocumentQuery query) async {
    _assert();
    if (validator != null) {
      final oldValue = await database.loadDocument(query, prefix: prefix);
      await validator!.onDeleteDocument(query, oldValue);
    }
    await database.deleteDocument(query, prefix: prefix);
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await _saveDocument(query, value);
    if (networkDelay != null) {
      await Future.delayed(networkDelay!);
    }
  }

  Future<void> _saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    _assert();
    if (validator != null) {
      final oldValue = await database.loadDocument(query, prefix: prefix);
      await validator!
          .onSaveDocument(query, oldValue: oldValue, newValue: value);
    }
    await database.saveDocument(query, value, prefix: prefix);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    _assert();
    database.removeDocumentListener(query, prefix: prefix);
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    _assert();
    database.removeCollectionListener(query, prefix: prefix);
  }

  @override
  bool get availableListen => false;

  @override
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  ) {
    _assert();
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  ) {
    _assert();
    throw UnsupportedError("This adapter cannot listen.");
  }

  @override
  void deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    _assert();
    if (ref is! RuntimeModelTransactionRef) {
      throw Exception("[ref] is not [RuntimeModelTransactionRef].");
    }
    ref._transactionList.add(() => _deleteDocument(query));
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    _assert();
    return loadDocument(query);
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    _assert();
    if (ref is! RuntimeModelTransactionRef) {
      throw Exception("[ref] is not [RuntimeModelTransactionRef].");
    }
    ref._transactionList.add(() => _saveDocument(query, value));
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  ) async {
    _assert();
    final ref = RuntimeModelTransactionRef._();
    await transaction.call(ref);
    if (networkDelay != null) {
      await Future.delayed(networkDelay!);
    }
    for (final tmp in ref._transactionList) {
      await tmp.call();
    }
  }

  @override
  void deleteOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    _assert();
    if (ref is! RuntimeModelBatchRef) {
      throw Exception("[ref] is not [RuntimeModelBatchRef].");
    }
    ref._batchList.add(() => _deleteDocument(query));
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    _assert();
    if (ref is! RuntimeModelBatchRef) {
      throw Exception("[ref] is not [RuntimeModelBatchRef].");
    }
    ref._batchList.add(() => _saveDocument(query, value));
  }

  @override
  FutureOr<void> runBatch(
    FutureOr<void> Function(
      ModelBatchRef ref,
    ) batch,
    int splitLength,
  ) async {
    _assert();
    final ref = RuntimeModelBatchRef._();
    if (networkDelay != null) {
      await Future.delayed(networkDelay!);
    }
    await batch.call(ref);
    await wait(
      ref._batchList.map((tmp) => tmp.call()),
    );
  }

  @override
  Future<void> clearAll() {
    _assert();
    return database.clearAll();
  }

  @override
  Future<void> clearCache() {
    _assert();
    return database.clearAll();
  }

  String _path(String original) {
    if (prefix.isEmpty) {
      return original;
    }
    _assert();
    final p = prefix!.trimQuery().trimString("/");
    final o = original.trimQuery().trimString("/");
    return "$p/$o";
  }

  void _assert() {
    assert(
      prefix.isEmpty ||
          !(prefix!.trimQuery().trimString("/").splitLength() <= 0 ||
              prefix!.trimQuery().trimString("/").splitLength() % 2 != 0),
      "The prefix path hierarchy must be an even number: $prefix",
    );
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return prefix.hashCode ^ _database.hashCode;
  }
}

/// [ModelTransactionRef] for [RuntimeModelAdapter].
///
/// [RuntimeModelAdapter]用の[ModelTransactionRef]。
@immutable
class RuntimeModelTransactionRef extends ModelTransactionRef {
  RuntimeModelTransactionRef._();

  final List<FutureOr<void> Function()> _transactionList = [];
}

/// [ModelBatchRef] for [RuntimeModelAdapter].
///
/// [RuntimeModelAdapter]用の[ModelBatchRef]。
@immutable
class RuntimeModelBatchRef extends ModelBatchRef {
  RuntimeModelBatchRef._();

  final List<FutureOr<void> Function()> _batchList = [];
}
