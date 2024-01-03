part of '/masamune_model_planetscale.dart';

/// Model adapter that makes PlanetScale available via API.
///
/// The API side needs to be able to handle `_PlanetscaleFunctionsAction`. You also need to pass a suitable [functionsAdapter] to connect to the API there.
///
/// In addition, internally retrieved data can be cached, and notifications can be sent to the relevant data for internal changes that occur in [DocumentBase.save], [DocumentBase.delete], etc., so that changes can be reflected.
///
/// The internal database can be specified in [localDatabase].
///
/// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
///
/// PlanetScaleをAPI経由で利用できるようにしたモデルアダプター。
///
/// API側には`_PlanetscaleFunctionsAction`を処理できるようにしておく必要があります。また、そこのAPIにつなげるために適した[functionsAdapter]を渡す必要があります。
///
/// また、内部で取得したデータをキャッシュしておき、[DocumentBase.save]や[DocumentBase.delete]などで発生した内部的な変更については関連するデータに通知を送ることができ変更を反映することができます。
///
/// 内部データベースは[localDatabase]で指定することができます。
///
/// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
class PlanetscaleModelAdapter extends ModelAdapter {
  /// Model adapter that makes PlanetScale available via API.
  ///
  /// The API side needs to be able to handle `_PlanetscaleFunctionsAction`. You also need to pass a suitable [functionsAdapter] to connect to the API there.
  ///
  /// In addition, internally retrieved data can be cached, and notifications can be sent to the relevant data for internal changes that occur in [DocumentBase.save], [DocumentBase.delete], etc., so that changes can be reflected.
  ///
  /// The internal database can be specified in [localDatabase].
  ///
  /// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
  ///
  /// PlanetScaleをAPI経由で利用できるようにしたモデルアダプター。
  ///
  /// API側には`_PlanetscaleFunctionsAction`を処理できるようにしておく必要があります。また、そこのAPIにつなげるために適した[functionsAdapter]を渡す必要があります。
  ///
  /// また、内部で取得したデータをキャッシュしておき、[DocumentBase.save]や[DocumentBase.delete]などで発生した内部的な変更については関連するデータに通知を送ることができ変更を反映することができます。
  ///
  /// 内部データベースは[localDatabase]で指定することができます。
  ///
  /// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
  const PlanetscaleModelAdapter({
    this.initialValue,
    required this.functionsAdapter,
    NoSqlDatabase? localDatabase,
  }) : _localDatabase = localDatabase;

  /// Specify the [FunctionsAdapter] that will run the API.
  ///
  /// APIを実行する[FunctionsAdapter]を指定します。
  final FunctionsAdapter functionsAdapter;

  /// Caches data retrieved from the specified internal database, PlanetScale.
  ///
  /// 指定の内部データベース。PlanetScaleから取得したデータをキャッシュします。
  NoSqlDatabase get localDatabase {
    final database = _localDatabase ?? sharedLocalDatabase;
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
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    await functionsAdapter.execute(
      _PlanetscaleFunctionsAction(
        [
          _PlanetscaleDeleteDocumentQuery(query: query),
        ],
      ),
    );
    await localDatabase.deleteDocument(query);
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    final result = await functionsAdapter.execute(
      _PlanetscaleFunctionsAction(
        [
          _PlanetscaleGetDocumentQuery(query: query),
        ],
      ),
    );
    var res = result.data.entries.first.value;
    if (res.isEmpty) {
      final localRes = await localDatabase.getInitialDocument(query);
      if (localRes.isNotEmpty) {
        res = localRes!;
      }
    }
    await localDatabase.syncDocument(query, res);
    return res;
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    localDatabase.removeCollectionListener(query);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    localDatabase.removeDocumentListener(query);
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final result = await functionsAdapter.execute(
      _PlanetscaleFunctionsAction(
        [
          _PlanetscaleGetCollectionQuery(query: query),
        ],
      ),
    );
    var res = result.data;
    final localRes = await localDatabase.getInitialCollection(query);
    if (localRes.isNotEmpty) {
      for (final entry in localRes!.entries) {
        if (res.containsKey(entry.key)) {
          continue;
        }
        if (!query.query.hasMatchAsMap(entry.value)) {
          continue;
        }
        res[entry.key] = entry.value;
      }
    }
    await localDatabase.syncCollection(query, res);
    return res;
  }

  @override
  Future<int> loadCollectionCount(
    ModelAdapterCollectionQuery query, {
    Iterable? retreivedList,
  }) async {
    final result = await functionsAdapter.execute(
      _PlanetscaleFunctionsAction(
        [
          _PlanetscaleCountCollectionQuery(query: query),
        ],
      ),
    );
    return result.count ?? 0;
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await functionsAdapter.execute(
      _PlanetscaleFunctionsAction(
        [
          _PlanetscalePostDocumentQuery(
            query: query,
            value: value,
          ),
        ],
      ),
    );
    await localDatabase.saveDocument(query, value);
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
    if (ref is! PlanetscaleModelTransactionRef) {
      throw Exception("[ref] is not [PlanetscaleModelTransactionRef].");
    }
    ref._transaction.add(_PlanetscaleDeleteDocumentQuery(query: query));
    ref._localTransaction.add(() async {
      await localDatabase.deleteDocument(query);
    });
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) async {
    if (ref is! PlanetscaleModelTransactionRef) {
      throw Exception("[ref] is not [PlanetscaleModelTransactionRef].");
    }
    final result = await functionsAdapter.execute(
      _PlanetscaleFunctionsAction(
        [
          _PlanetscaleGetDocumentQuery(query: query),
        ],
      ),
    );
    var res = result.data.entries.first.value;
    if (res.isEmpty) {
      final localRes = await localDatabase.getInitialDocument(query);
      if (localRes.isNotEmpty) {
        res = localRes!;
      }
    }
    await localDatabase.syncDocument(query, res);
    return res;
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! PlanetscaleModelTransactionRef) {
      throw Exception("[ref] is not [PlanetscaleModelTransactionRef].");
    }
    ref._transaction.add(
      _PlanetscalePostDocumentQuery(
        query: query,
        value: value,
      ),
    );
    ref._localTransaction.add(() async {
      await localDatabase.saveDocument(query, value);
    });
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  ) async {
    final ref = PlanetscaleModelTransactionRef._();
    await transaction.call(ref);
    await functionsAdapter.execute(
      _PlanetscaleFunctionsAction(
        ref._transaction,
      ),
    );
    for (final tr in ref._localTransaction) {
      await tr.call();
    }
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    if (ref is! PlanetscaleModelBatchRef) {
      throw Exception("[ref] is not [PlanetscaleModelBatchRef].");
    }
    ref._localBatch.add(
      _PlanetscaleModelBatchItem(
        query: _PlanetscaleDeleteDocumentQuery(query: query),
        actions: () async {
          await localDatabase.deleteDocument(query);
        },
      ),
    );
  }

  @override
  FutureOr<void> runBatch(
    FutureOr<void> Function(
      ModelBatchRef ref,
    ) batch,
    int splitLength,
  ) async {
    assert(
      splitLength > 0 && splitLength <= 500,
      "[splitLength] must be greater than 0 and less than or equal to 500 in Planetscale.",
    );
    final ref = PlanetscaleModelBatchRef._();
    await batch.call(ref);
    await wait(
      ref._localBatch.split(splitLength).expand((b) {
        final queries = <_PlanetscaleQueryBase>[];
        final actions = <Future<void>>[];
        for (final item in b) {
          queries.add(item.query);
          if (item.actions != null) {
            actions.add(item.actions!());
          }
        }
        return [
          functionsAdapter.execute(
            _PlanetscaleFunctionsAction(queries),
          ),
          ...actions,
        ];
      }),
    );
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! PlanetscaleModelBatchRef) {
      throw Exception("[ref] is not [PlanetscaleModelBatchRef].");
    }
    ref._localBatch.add(
      _PlanetscaleModelBatchItem(
        query: _PlanetscalePostDocumentQuery(query: query, value: value),
        actions: () async {
          await localDatabase.saveDocument(query, value);
        },
      ),
    );
  }

  @override
  Future<void> clearAll() {
    throw UnimplementedError("This function is not available.");
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
    return localDatabase.hashCode ^
        functionsAdapter.hashCode ^
        initialValue.hashCode;
  }
}

/// [ModelTransactionRef] for [PlanetscaleModelAdapter].
///
/// [PlanetscaleModelAdapter]用の[ModelTransactionRef]。
@immutable
class PlanetscaleModelTransactionRef extends ModelTransactionRef {
  PlanetscaleModelTransactionRef._();
  final List<_PlanetscaleQueryBase> _transaction = [];
  final List<Future<void> Function()> _localTransaction = [];
}

/// [ModelBatchRef] for [PlanetscaleModelAdapter].
///
/// [PlanetscaleModelAdapter]用の[ModelBatchRef]。
@immutable
class PlanetscaleModelBatchRef extends ModelBatchRef {
  PlanetscaleModelBatchRef._();
  final List<_PlanetscaleModelBatchItem> _localBatch = [];
}

@immutable
class _PlanetscaleModelBatchItem {
  const _PlanetscaleModelBatchItem({
    required this.query,
    this.actions,
  });
  final _PlanetscaleQueryBase query;
  final Future<void> Function()? actions;
}
