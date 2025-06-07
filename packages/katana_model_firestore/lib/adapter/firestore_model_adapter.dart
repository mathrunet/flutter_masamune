part of "/katana_model_firestore.dart";

const _kTypeKey = "@type";
const _kTargetKey = "@target";

/// Model adapter with Firebase Firestore available.
///
/// Firestore application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
///
/// Basically, the default [FirebaseFirestore.instance] is used, but it is possible to use a specified database by passing [database] when creating the adapter.
///
/// You can initialize Firebase by passing [options].
///
/// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
///
/// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
///
/// FirebaseFirestoreを利用できるようにしたモデルアダプター。
///
/// 事前にFirestoreのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
///
/// 基本的にデフォルトの[FirebaseFirestore.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定されたデータベースを利用することが可能です。
///
/// [options]を渡すことでFirebaseの初期化を行うことができます。
///
/// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
///
/// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
class FirestoreModelAdapter extends ModelAdapter
    implements FirestoreModelAdapterBase {
  /// Model adapter with Firebase Firestore available.
  ///
  /// Firestore application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
  ///
  /// Basically, the default [FirebaseFirestore.instance] is used, but it is possible to use a specified database by passing [database] when creating the adapter.
  ///
  /// You can initialize Firebase by passing [options].
  ///
  /// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
  ///
  /// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
  ///
  /// FirebaseFirestoreを利用できるようにしたモデルアダプター。
  ///
  /// 事前にFirestoreのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
  ///
  /// 基本的にデフォルトの[FirebaseFirestore.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定されたデータベースを利用することが可能です。
  ///
  /// [options]を渡すことでFirebaseの初期化を行うことができます。
  ///
  /// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
  ///
  /// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
  const FirestoreModelAdapter({
    this.initialValue,
    FirebaseFirestore? database,
    NoSqlDatabase? cachedRuntimeDatabase,
    FirebaseOptions? options,
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.linuxOptions,
    this.windowsOptions,
    this.macosOptions,
    this.prefix,
    this.validator,
    this.onInitialize,
    this.databaseId,
  })  : _database = database,
        _options = options,
        _cachedRuntimeDatabase = cachedRuntimeDatabase;

  /// The Firestore database instance used in the adapter.
  ///
  /// アダプター内で利用しているFirestoreのデータベースインスタンス。
  @override
  FirebaseFirestore get database {
    if (_database != null) {
      return _database!;
    }
    if (databaseId.isNotEmpty) {
      return FirebaseFirestore.instanceFor(
        app: FirebaseCore.app!,
        databaseId: databaseId,
      );
    }
    return FirebaseFirestore.instance;
  }

  final FirebaseFirestore? _database;

  /// Caches data retrieved from the specified internal database, Firestore.
  ///
  /// 指定の内部データベース。Firestoreから取得したデータをキャッシュします。
  NoSqlDatabase get cachedRuntimeDatabase {
    final database = _cachedRuntimeDatabase ?? sharedRuntimeDatabase;
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

  final NoSqlDatabase? _cachedRuntimeDatabase;

  /// A common internal database throughout the app.
  ///
  /// アプリ内全体での共通の内部データベース。
  static final NoSqlDatabase sharedRuntimeDatabase = NoSqlDatabase();

  /// Specify the permission validator for the database.
  ///
  /// If [Null], no validation is performed.
  ///
  /// データベースのパーミッションバリデーターを指定します。
  ///
  /// [Null]のときはバリデーションされません。
  @override
  final DatabaseValidator? validator;

  /// ID of the database to use; if [Null], the default is used.
  ///
  /// [database]が指定されている場合はそちらが利用されます。
  ///
  /// 使用するデータベースのID。[Null]の場合はデフォルトが利用されます。
  ///
  /// [database]が指定されている場合はそちらが利用されます。
  final String? databaseId;

  /// Callback for initialization. If this is specified, normal initialization is not performed.
  ///
  /// 初期化を行う場合のコールバック。これが指定されている場合通常の初期化は行われません。
  final Future<void> Function(FirebaseOptions? options)? onInitialize;

  /// Actual data when used as a mock-up.
  ///
  /// モックアップとして利用する際の実データ。
  final List<ModelInitialValue>? initialValue;

  /// A special class can be registered as a [ModelFieldValue] by passing [FirestoreModelFieldValueConverter] to [converter].
  ///
  /// [FirestoreModelFieldValueConverter]を[converter]に渡すことで特殊なクラスを[ModelFieldValue]として登録することができます。
  static void registerConverter(FirestoreModelFieldValueConverter converter) {
    _converters.add(converter);
  }

  /// By passing [FirestoreModelFieldValueConverter] to [converter], you can release an already registered [FirestoreModelFieldValueConverter].
  ///
  /// [converter]に[FirestoreModelFieldValueConverter]を渡すことですでに登録されている[FirestoreModelFieldValueConverter]を解除することができます。
  static void unregisterConverter(FirestoreModelFieldValueConverter converter) {
    _converters.remove(converter);
  }

  static final Set<FirestoreModelFieldValueConverter> _converters = {
    ...FirestoreModelFieldValueConverter.defaultConverters
  };

  /// Options for initializing Firebase.
  ///
  /// If platform-specific options are specified, they take precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// プラットフォーム固有のオプションが指定されている場合はそちらが優先されます。
  FirebaseOptions? get options {
    if (UniversalPlatform.isIOS) {
      return iosOptions ?? _options;
    } else if (UniversalPlatform.isAndroid) {
      return androidOptions ?? _options;
    } else if (UniversalPlatform.isWeb) {
      return webOptions ?? _options;
    } else if (UniversalPlatform.isLinux) {
      return linuxOptions ?? _options;
    } else if (UniversalPlatform.isWindows) {
      return windowsOptions ?? _options;
    } else if (UniversalPlatform.isMacOS) {
      return macosOptions ?? _options;
    } else {
      return _options;
    }
  }

  /// Options for initializing Firebase.
  ///
  /// If options for other platforms are specified, these are ignored.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// 他のプラットフォーム用のオプションが指定されている場合はこちらは無視されます。
  final FirebaseOptions? _options;

  /// Options for initializing Firebase.
  ///
  /// Applies to IOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// IOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? iosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Android only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Androidのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? androidOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? webOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? windowsOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to MacOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// MacOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? macosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Linux only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Linuxのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? linuxOptions;

  /// Path prefix.
  ///
  /// パスのプレフィックス。
  @override
  final String? prefix;

  /// Callback for deleting a document.
  ///
  /// ドキュメントを削除する際のコールバック。
  Future<void> onDeleteDocument(ModelAdapterDocumentQuery query) =>
      Future.value();

  /// Callback for saving a document.
  ///
  /// ドキュメントを保存する際のコールバック。
  Future<void> onSaveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) =>
      Future.value();

  /// Callbacks for loading documents.
  ///
  /// ドキュメントをロードする際のコールバック。
  Future<DynamicMap?> onPreloadDocument(ModelAdapterDocumentQuery query) =>
      Future.value(null);

  /// Callback after the document is loaded.
  ///
  /// ドキュメントをロードした後のコールバック。
  Future<void> onPostloadDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) =>
      Future.value();

  /// Callback for loading a collection.
  ///
  /// コレクションをロードする際のコールバック。
  Future<CachedFirestoreModelCollectionLoaderResponse?> onPreloadCollection(
    ModelAdapterCollectionQuery query,
  ) =>
      Future.value(null);

  /// Callback for postloading a collection.
  ///
  /// コレクションをロードした後のコールバック。
  Future<void> onPostloadCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap> value,
  ) =>
      Future.value();

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    _assert();
    if (validator != null) {
      final oldValue =
          _FirestoreCache.getCache(options).get(_path(query.query.path));
      await validator!.onDeleteDocument(query, oldValue);
    }
    if (onInitialize != null) {
      await onInitialize?.call(options);
    } else {
      await FirebaseCore.initialize(options: options);
    }
    await _documentReference(query).delete();
    await cachedRuntimeDatabase.deleteDocument(query, prefix: prefix);
    _FirestoreCache.getCache(options).set(_path(query.query.path));
    await onDeleteDocument(query);
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    _assert();
    if (validator != null) {
      await validator!.onPreloadDocument(query);
    }
    if (onInitialize != null) {
      await onInitialize?.call(options);
    } else {
      await FirebaseCore.initialize(options: options);
    }
    DynamicMap? res = await onPreloadDocument(query);
    if (res == null) {
      final snapshot = await _documentReference(query).get();
      res = _convertFrom(snapshot.data()?.cast() ?? {});
      await onPostloadDocument(query, res);
    } else {
      res = _convertFrom(res);
    }
    if (res.isEmpty) {
      final localRes =
          await cachedRuntimeDatabase.getInitialDocument(query, prefix: prefix);
      if (localRes.isNotEmpty) {
        res = localRes!;
      }
    }
    if (validator != null) {
      await validator!.onPostloadDocument(query, res);
    }
    await cachedRuntimeDatabase.syncDocument(query, res, prefix: prefix);
    _FirestoreCache.getCache(options).set(_path(query.query.path), res);
    return res;
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    _assert();
    cachedRuntimeDatabase.removeCollectionListener(query, prefix: prefix);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    _assert();
    cachedRuntimeDatabase.removeDocumentListener(query, prefix: prefix);
  }

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    _assert();
    if (validator != null) {
      await validator!.onPreloadCollection(query);
    }
    if (onInitialize != null) {
      await onInitialize?.call(options);
    } else {
      await FirebaseCore.initialize(options: options);
    }
    CachedFirestoreModelCollectionLoaderResponse? cache =
        await onPreloadCollection(query);
    Map<String, DynamicMap>? res = cache?.value.map(
      (k, v) => MapEntry(k, _convertFrom(v)),
    );
    if (res == null || cache?.query != null) {
      if (cache?.query != null) {
        query = cache!.query!;
      }
      final snapshot = await Future.wait<QuerySnapshot<DynamicMap>>(
        _collectionReference(query).map((reference) => reference.get()),
      );
      res = {
        if (res != null) ...res,
        ...snapshot.expand((e) => e.docChanges).toMap(
              (e) => MapEntry(
                e.doc.id,
                _convertFrom(e.doc.data()?.cast() ?? {}),
              ),
            )
      };
      await onPostloadCollection(query, res);
    }
    final localRes =
        await cachedRuntimeDatabase.getInitialCollection(query, prefix: prefix);
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
    if (validator != null) {
      await validator!.onPostloadCollection(query, res);
    }
    await cachedRuntimeDatabase.syncCollection(query, res, prefix: prefix);
    for (final doc in res.entries) {
      _FirestoreCache.getCache(options).set(
        "${_path(query.query.path)}/${doc.key}",
        doc.value,
      );
    }
    return res;
  }

  @override
  Future<T?> loadAggregation<T>(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery aggregateQuery,
  ) async {
    _assert();
    if (onInitialize != null) {
      await onInitialize?.call(options);
    } else {
      await FirebaseCore.initialize(options: options);
    }
    switch (aggregateQuery.type) {
      case ModelAggregateQueryType.count:
        final snapshot = await Future.wait<AggregateQuerySnapshot>(
          _collectionReference(
            query.copyWith(
              query: query.query.remove(ModelQueryFilterType.limit),
            ),
          ).map(
            (reference) => reference.count().get(),
          ),
        );
        final res = snapshot.fold<int>(0, (p, e) => p + (e.count ?? 0));
        if (res is! T) {
          return null;
        }
        return res as T;
      case ModelAggregateQueryType.sum:
        final key = aggregateQuery.key;
        assert(
          key.isNotEmpty,
          "Enter [key] for [ModelAggregateQueryType.sum].",
        );
        final snapshot = await Future.wait<AggregateQuerySnapshot>(
          _collectionReference(
            query.copyWith(
              query: query.query.remove(ModelQueryFilterType.limit),
            ),
          ).map(
            (reference) => reference.aggregate(sum(key!)).get(),
          ),
        );
        final res =
            snapshot.fold<double>(0.0, (p, e) => p + (e.getSum(key!) ?? 0.0));
        if (res is! T) {
          return null;
        }
        return res as T;
      case ModelAggregateQueryType.average:
        final key = aggregateQuery.key;
        assert(
          aggregateQuery.key.isNotEmpty,
          "Enter [key] for [ModelAggregateQueryType.average].",
        );
        final snapshot = await Future.wait<AggregateQuerySnapshot>(
          _collectionReference(
            query.copyWith(
              query: query.query.remove(ModelQueryFilterType.limit),
            ),
          ).map(
            (reference) => reference.aggregate(average(key!)).get(),
          ),
        );
        final res = snapshot.fold<double>(
                0.0, (p, e) => p + (e.getAverage(key!) ?? 0.0)) /
            snapshot.length;
        if (res is! T) {
          return null;
        }
        return res as T;
    }
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    _assert();
    if (validator != null) {
      final oldValue =
          _FirestoreCache.getCache(options).get(_path(query.query.path));
      await validator!.onSaveDocument(
        query,
        oldValue: oldValue,
        newValue: value,
      );
    }
    if (onInitialize != null) {
      await onInitialize?.call(options);
    } else {
      await FirebaseCore.initialize(options: options);
    }

    final converted = _convertTo(
      value,
      _FirestoreCache.getCache(options).get(_path(query.query.path)) ?? {},
    );
    await _documentReference(query).set(
      converted,
      SetOptions(merge: true),
    );
    await cachedRuntimeDatabase.saveDocument(query, value, prefix: prefix);
    _FirestoreCache.getCache(options).set(
      _path(query.query.path),
      value,
    );
    await onSaveDocument(query, value);
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
    if (ref is! FirestoreModelTransactionRef) {
      throw Exception("[ref] is not [FirestoreModelTransactionRef].");
    }
    ref._transaction.delete(database.doc(_path(query.query.path)));
    ref._preLocalTransaction.add(() async {
      if (validator != null) {
        final oldValue =
            _FirestoreCache.getCache(options).get(_path(query.query.path));
        await validator!.onDeleteDocument(query, oldValue);
      }
    });
    ref._postLocalTransaction.add(() async {
      await cachedRuntimeDatabase.deleteDocument(query, prefix: prefix);
      _FirestoreCache.getCache(options).set(_path(query.query.path));
      await onDeleteDocument(query);
    });
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) async {
    _assert();
    if (ref is! FirestoreModelTransactionRef) {
      throw Exception("[ref] is not [FirestoreModelTransactionRef].");
    }
    if (validator != null) {
      await validator!.onPreloadDocument(query);
    }
    DynamicMap? res = await onPreloadDocument(query);
    if (res == null) {
      final snapshot =
          await ref._transaction.get(database.doc(_path(query.query.path)));
      res = _convertFrom(snapshot.data()?.cast() ?? {});
      await onPostloadDocument(query, res);
    } else {
      res = _convertFrom(res);
    }
    if (res.isEmpty) {
      final localRes =
          await cachedRuntimeDatabase.getInitialDocument(query, prefix: prefix);
      if (localRes.isNotEmpty) {
        res = localRes!;
      }
    }
    if (validator != null) {
      await validator!.onPostloadDocument(query, res);
    }
    await cachedRuntimeDatabase.syncDocument(query, res, prefix: prefix);
    _FirestoreCache.getCache(options).set(_path(query.query.path), res);
    return res;
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    _assert();
    if (ref is! FirestoreModelTransactionRef) {
      throw Exception("[ref] is not [FirestoreModelTransactionRef].");
    }
    final converted = _convertTo(
      value,
      _FirestoreCache.getCache(options).get(_path(query.query.path)) ?? {},
    );
    ref._transaction.set(
      database.doc(_path(query.query.path)),
      converted,
      SetOptions(merge: true),
    );
    ref._preLocalTransaction.add(() async {
      if (validator != null) {
        final oldValue =
            _FirestoreCache.getCache(options).get(_path(query.query.path));
        await validator!.onSaveDocument(
          query,
          oldValue: oldValue,
          newValue: value,
        );
      }
    });
    ref._postLocalTransaction.add(() async {
      if (validator != null) {
        final oldValue =
            _FirestoreCache.getCache(options).get(_path(query.query.path));
        await validator!.onSaveDocument(
          query,
          oldValue: oldValue,
          newValue: value,
        );
      }
      await cachedRuntimeDatabase.saveDocument(query, value, prefix: prefix);
      _FirestoreCache.getCache(options).set(_path(query.query.path), value);
      await onSaveDocument(query, value);
    });
  }

  @override
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  ) async {
    _assert();
    if (onInitialize != null) {
      await onInitialize?.call(options);
    } else {
      await FirebaseCore.initialize(options: options);
    }
    await database.runTransaction((handler) async {
      final ref = FirestoreModelTransactionRef._(handler);
      for (final tr in ref._preLocalTransaction) {
        await tr.call();
      }
      await transaction.call(ref);
      for (final tr in ref._postLocalTransaction) {
        await tr.call();
      }
    });
  }

  @override
  void deleteOnBatch(ModelBatchRef ref, ModelAdapterDocumentQuery query) {
    _assert();
    if (ref is! FirestoreModelBatchRef) {
      throw Exception("[ref] is not [FirestoreModelBatchRef].");
    }
    ref._localBatch.add(
      _FirestoreModelBatchItem(
        path: _path(query.query.path),
        preActions: () async {
          if (validator != null) {
            final oldValue =
                _FirestoreCache.getCache(options).get(_path(query.query.path));
            await validator!.onDeleteDocument(query, oldValue);
          }
        },
        actions: () async {
          await cachedRuntimeDatabase.deleteDocument(query, prefix: prefix);
          _FirestoreCache.getCache(options).set(_path(query.query.path));
          await onDeleteDocument(query);
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
      "[splitLength] must be greater than 0 and less than or equal to 500 in Firestore.",
    );
    _assert();
    if (onInitialize != null) {
      await onInitialize?.call(options);
    } else {
      await FirebaseCore.initialize(options: options);
    }
    final ref = FirestoreModelBatchRef._();
    await batch.call(ref);
    await wait(
      ref._localBatch.map((e) => e.preActions?.call()),
    );
    await wait(
      ref._localBatch.split(splitLength).expand((b) {
        final db = database.batch();
        final actions = <Future<void>>[];
        for (final item in b) {
          if (item.value == null) {
            db.delete(database.doc(item.path));
          } else {
            db.set(
              database.doc(item.path),
              item.value,
              SetOptions(merge: true),
            );
            if (item.actions != null) {
              actions.add(item.actions!());
            }
          }
        }
        return [db.commit(), ...actions];
      }),
    );
  }

  @override
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    _assert();
    if (ref is! FirestoreModelBatchRef) {
      throw Exception("[ref] is not [FirestoreModelBatchRef].");
    }
    final converted = _convertTo(
      value,
      _FirestoreCache.getCache(options).get(_path(query.query.path)) ?? {},
    );
    ref._localBatch.add(
      _FirestoreModelBatchItem(
        path: _path(query.query.path),
        value: converted,
        preActions: () async {
          if (validator != null) {
            final oldValue =
                _FirestoreCache.getCache(options).get(_path(query.query.path));
            await validator!.onSaveDocument(
              query,
              oldValue: oldValue,
              newValue: value,
            );
          }
        },
        actions: () async {
          await cachedRuntimeDatabase.saveDocument(query, value,
              prefix: prefix);
          _FirestoreCache.getCache(options).set(_path(query.query.path), value);
          await onSaveDocument(query, value);
        },
      ),
    );
  }

  @override
  Future<void> clearAll()  {
    throw UnimplementedError("This function is not available.");
  }

  @override
  Future<void> clearCache()  {
    _assert();
    _FirestoreCache._caches.clear();
    return cachedRuntimeDatabase.clearAll();
  }

  DynamicMap _convertFrom(DynamicMap map) {
    final res = <String, dynamic>{};

    for (final tmp in map.entries) {
      final key = tmp.key;
      final val = tmp.value;
      DynamicMap? replaced;
      for (final converter in _converters) {
        replaced = converter.convertFrom(key, val, map, this);
        if (replaced != null) {
          break;
        }
      }
      if (replaced != null) {
        replaced.removeWhere((key, value) => value == null);
        res.addAll(replaced);
      } else {
        res[key] = val;
      }
    }
    return res;
  }

  DynamicMap _convertTo(DynamicMap map, DynamicMap original) {
    final res = <String, dynamic>{};
    for (final tmp in map.entries) {
      final key = tmp.key;
      final val = tmp.value;
      DynamicMap? replaced;
      if (val is Map && original.containsKey(key) && original[key] is Map) {
        final map = <String, dynamic>{};
        final originalMap = original[key] as Map;
        for (final originalKey in originalMap.keys) {
          map[originalKey] = FieldValue.delete();
        }
        for (final entry in val.entries) {
          map[entry.key] = entry.value;
        }
        replaced = {key: map};
      }
      for (final converter in _converters) {
        replaced = converter.convertTo(key, val, map, this);
        if (replaced != null) {
          break;
        }
      }
      if (replaced != null) {
        res.addAll(replaced);
      } else {
        res[key] = val;
      }
    }
    return res;
  }

  Query<DynamicMap> _query(
    Query<DynamicMap> firestoreQuery,
    ModelAdapterCollectionQuery query,
  ) {
    final filters = query.query.filters.sortTo(_compareFilters);
    for (final filter in filters) {
      for (final converter in _converters) {
        final res = converter.filterQuery(firestoreQuery, filter, query, this);
        if (res != null) {
          firestoreQuery = res;
          break;
        }
      }
    }
    for (final filter in filters) {
      for (final converter in _converters) {
        final res = converter.orderQuery(firestoreQuery, filter, query, this);
        if (res != null) {
          firestoreQuery = res;
          break;
        }
      }
    }
    return firestoreQuery;
  }

  @override
  String _path(String original) {
    if (prefix.isEmpty) {
      return original;
    }
    _assert();
    final p = prefix!.trimQuery().trimString("/");
    final o = original.trimQuery().trimString("/");
    return "$p/$o";
  }

  DocumentReference<DynamicMap> _documentReference(
    ModelAdapterDocumentQuery query,
  ) =>
      database.doc(_path(query.query.path));

  List<Query<DynamicMap>> _collectionReference(
    ModelAdapterCollectionQuery query,
  ) {
    final filters = query.query.filters.sortTo(_compareFilters);
    final containsAny = filters
        .where((e) => e.type == ModelQueryFilterType.arrayContainsAny)
        .toList();
    final whereIn =
        filters.where((e) => e.type == ModelQueryFilterType.whereIn).toList();
    final whereNotIn = filters
        .where((e) => e.type == ModelQueryFilterType.whereNotIn)
        .toList();
    final geoHash =
        filters.where((e) => e.type == ModelQueryFilterType.geoHash).toList();
    assert(
      containsAny.length <= 1,
      "Multiple conditions cannot be defined for `containsAny`.",
    );
    assert(
      whereIn.length <= 1,
      "Multiple conditions cannot be defined for `where`.",
    );
    assert(
      whereNotIn.length <= 1,
      "Multiple conditions cannot be defined for `notWhere`.",
    );
    assert(
      geoHash.length <= 1,
      "Multiple conditions cannot be defined for `geo`.",
    );
    assert(
      containsAny.length +
              whereNotIn.length +
              whereIn.length +
              geoHash.length <=
          1,
      "Only one of `containsAny`, `where`, `notWhere`, or `geo` may be specified. Duplicate conditions cannot be given.",
    );
    if (containsAny.isNotEmpty) {
      final filter = containsAny.first;
      final items = filter.value;
      if (items is List && items.isNotEmpty) {
        for (final conveter in _converters) {
          final res = conveter.collectionQueries(
            items,
            () => _query(
              _createCollection(query),
              query,
            ),
            filter,
            query,
            this,
          );
          if (res != null) {
            return res;
          }
        }
      }
    } else if (whereIn.isNotEmpty) {
      final filter = whereIn.first;
      final items = filter.value;
      if (items is List && items.isNotEmpty) {
        for (final conveter in _converters) {
          final res = conveter.collectionQueries(
            items,
            () => _query(
              _createCollection(query),
              query,
            ),
            filter,
            query,
            this,
          );
          if (res != null) {
            return res;
          }
        }
      }
    } else if (whereNotIn.isNotEmpty) {
      final filter = whereNotIn.first;
      final items = filter.value;
      if (items is List && items.isNotEmpty) {
        for (final conveter in _converters) {
          final res = conveter.collectionQueries(
            items,
            () => _query(
              _createCollection(query),
              query,
            ),
            filter,
            query,
            this,
          );
          if (res != null) {
            return res;
          }
        }
      }
    } else if (geoHash.isNotEmpty) {
      final filter = geoHash.first;
      final items = filter.value;
      if (items is List && items.isNotEmpty) {
        for (final conveter in _converters) {
          final res = conveter.collectionQueries(
            items,
            () => _query(
              _createCollection(query),
              query,
            ),
            filter,
            query,
            this,
          );
          if (res != null) {
            return res;
          }
        }
      }
    }
    return [
      _query(
        _createCollection(query),
        query,
      )
    ];
  }

  Query<Map<String, dynamic>> _createCollection(
      ModelAdapterCollectionQuery query) {
    final path = _path(query.query.path);
    if (query.query.filters
        .any((e) => e.type == ModelQueryFilterType.collectionGroup)) {
      return database.collectionGroup(path.last());
    } else {
      return database.collection(path);
    }
  }

  int _compareFilters(ModelQueryFilter a, ModelQueryFilter b) {
    final res = a.type.name.compareTo(b.type.name);
    if (res == 0) {
      if (a.key == null || b.key == null) {
        return 0;
      } else if (a.key == null) {
        return -1;
      } else if (b.key == null) {
        return 1;
      }
      return a.key!.compareTo(b.key!);
    }
    return res;
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return prefix.hashCode ^
        _cachedRuntimeDatabase.hashCode ^
        options.hashCode ^
        _database.hashCode ^
        databaseId.hashCode;
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

/// [ModelTransactionRef] for [FirestoreModelAdapter].
///
/// [FirestoreModelAdapter]用の[ModelTransactionRef]。
@immutable
class FirestoreModelTransactionRef extends ModelTransactionRef {
  FirestoreModelTransactionRef._(
    this._transaction,
  );
  final Transaction _transaction;
  final List<Future<void> Function()> _preLocalTransaction = [];
  final List<Future<void> Function()> _postLocalTransaction = [];
}

/// [ModelBatchRef] for [FirestoreModelAdapter].
///
/// [FirestoreModelAdapter]用の[ModelBatchRef]。
@immutable
class FirestoreModelBatchRef extends ModelBatchRef {
  FirestoreModelBatchRef._();
  final List<_FirestoreModelBatchItem> _localBatch = [];
}

@immutable
class _FirestoreModelBatchItem {
  const _FirestoreModelBatchItem({
    required this.path,
    this.value,
    this.actions,
    this.preActions,
  });
  final String path;
  final DynamicMap? value;
  final Future<void> Function()? preActions;
  final Future<void> Function()? actions;
}
