part of '/katana_model_local.dart';

const _kLocalDatabaseId = "local://";

/// A database adapter that stores data on a local terminal.
///
/// Use for application development that does not require external storage of values.
///
/// For mobile and desktop, data is encrypted and stored in external files, and for the Web, data is encrypted and stored in LocalStorage.
///
/// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
///
/// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
///
/// If [validator] is specified, validation is performed in the database.
///
/// ローカル端末にデータを保存するデータベースアダプター。
///
/// 外部に値を保存する必要のないアプリ開発に利用します。
///
/// モバイルやデスクトップは外部ファイルに暗号化してデータが保存されWebの場合はLocalStorageに暗号化されデータが保存されます。
///
/// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
///
/// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
///
/// [validator]を指定するとデータベース内でのバリデーションが行われます。
@immutable
class LocalModelAdapter extends ModelAdapter {
  /// A database adapter that stores data on a local terminal.
  ///
  /// Use for application development that does not require external storage of values.
  ///
  /// For mobile and desktop, data is encrypted and stored in external files, and for the Web, data is encrypted and stored in LocalStorage.
  ///
  /// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
  ///
  /// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
  ///
  /// If [validator] is specified, validation is performed in the database.
  ///
  /// ローカル端末にデータを保存するデータベースアダプター。
  ///
  /// 外部に値を保存する必要のないアプリ開発に利用します。
  ///
  /// モバイルやデスクトップは外部ファイルに暗号化してデータが保存されWebの場合はLocalStorageに暗号化されデータが保存されます。
  ///
  /// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
  ///
  /// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
  ///
  /// [validator]を指定するとデータベース内でのバリデーションが行われます。
  const LocalModelAdapter({
    NoSqlDatabase? database,
    this.prefix,
    this.initialValue,
    this.validator,
  }) : _database = database;

  final NoSqlDatabase? _database;

  /// Designated database.
  ///
  /// 指定のデータベース。
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

  /// A common database throughout the application.
  ///
  /// アプリ内全体での共通のデータベース。
  static final NoSqlDatabase sharedDatabase = NoSqlDatabase(
    onInitialize: (database) async {
      try {
        database.data = await DatabaseExporter.import(
          "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        );
      } catch (e) {
        database.data = {};
      }
    },
    onSaved: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        database.data,
      );
    },
    onDeleted: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        database.data,
      );
    },
    onClear: (database) async {
      await DatabaseExporter.export(
        "${await DatabaseExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        {},
      );
    },
  );

  /// Specify the permission validator for the database.
  ///
  /// If [Null], no validation is performed.
  ///
  /// データベースのパーミッションバリデーターを指定します。
  ///
  /// [Null]のときはバリデーションされません。
  final DatabaseValidator? validator;

  /// Path prefix.
  ///
  /// パスのプレフィックス。
  final String? prefix;

  /// Actual data when used as a mock-up.
  ///
  /// モックアップとして利用する際の実データ。
  final List<ModelInitialValue>? initialValue;

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    _assert();
    if (validator != null) {
      await validator!.onPreloadDocument(query);
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
    if (ref is! LocalModelTransactionRef) {
      throw Exception("[ref] is not [LocalModelTransactionRef].");
    }
    ref._transactionList.add(() => deleteDocument(query));
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
    if (ref is! LocalModelTransactionRef) {
      throw Exception("[ref] is not [LocalModelTransactionRef].");
    }
    ref._transactionList.add(() => saveDocument(query, value));
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  ) async {
    _assert();
    final ref = LocalModelTransactionRef._();
    await transaction.call(ref);
    for (final tmp in ref._transactionList) {
      await tmp.call();
    }
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

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return prefix.hashCode ^ _database.hashCode;
  }

  @override
  void deleteOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    _assert();
    if (ref is! LocalModelBatchRef) {
      throw Exception("[ref] is not [LocalModelBatchRef].");
    }
    ref._batchList.add(() => deleteDocument(query));
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    _assert();
    if (ref is! LocalModelBatchRef) {
      throw Exception("[ref] is not [LocalModelBatchRef].");
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
    _assert();
    final ref = LocalModelBatchRef._();
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
  Future<void> clearCache() async {
    _assert();
  }

  void _assert() {
    assert(
      prefix.isEmpty ||
          !(prefix!.trimQuery().trimString("/").splitLength() <= 0 ||
              prefix!.trimQuery().trimString("/").splitLength() % 2 != 0),
      "The prefix path hierarchy must be an even number: $prefix",
    );
  }
}

/// [ModelTransactionRef] for [LocalModelAdapter].
///
/// [LocalModelAdapter]用の[ModelTransactionRef]。
@immutable
class LocalModelTransactionRef extends ModelTransactionRef {
  LocalModelTransactionRef._();

  final List<FutureOr<void> Function()> _transactionList = [];
}

/// [ModelBatchRef] for [LocalModelAdapter].
///
/// [LocalModelAdapter]用の[ModelBatchRef]。
@immutable
class LocalModelBatchRef extends ModelBatchRef {
  LocalModelBatchRef._();

  final List<FutureOr<void> Function()> _batchList = [];
}
