part of katana_model_firestore;

/// Model adapter with Firebase Firestore available.
///
/// It monitors all documents in Firestore for changes and notifies you of any changes on the remote side.
///
/// Firestore application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
///
/// Basically, the default [FirebaseFirestore.instance] is used, but it is possible to use a specified database by passing [database] when creating the adapter.
///
/// You can initialize Firebase by passing [options].
///
/// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
///
/// FirebaseFirestoreを利用できるようにしたモデルアダプター。
///
/// Firestoreのすべてのドキュメントの変更を監視し、リモート側で変更があればそれを通知します。
///
/// 事前にFirestoreのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
///
/// 基本的にデフォルトの[FirebaseFirestore.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定されたデータベースを利用することが可能です。
///
/// [options]を渡すことでFirebaseの初期化を行うことができます。
///
/// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
class ListenableFirestoreModelAdapter extends ModelAdapter
    implements FirestoreModelAdapterBase {
  /// Model adapter with Firebase Firestore available.
  ///
  /// It monitors all documents in Firestore for changes and notifies you of any changes on the remote side.
  ///
  /// Firestore application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
  ///
  /// Basically, the default [FirebaseFirestore.instance] is used, but it is possible to use a specified database by passing [database] when creating the adapter.
  ///
  /// You can initialize Firebase by passing [options].
  ///
  /// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
  ///
  /// FirebaseFirestoreを利用できるようにしたモデルアダプター。
  ///
  /// Firestoreのすべてのドキュメントの変更を監視し、リモート側で変更があればそれを通知します。
  ///
  /// 事前にFirestoreのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
  ///
  /// 基本的にデフォルトの[FirebaseFirestore.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定されたデータベースを利用することが可能です。
  ///
  /// [options]を渡すことでFirebaseの初期化を行うことができます。
  ///
  /// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
  const ListenableFirestoreModelAdapter({
    FirebaseFirestore? database,
    this.options,
    this.prefix,
  }) : _database = database;

  /// The Firestore database instance used in the adapter.
  ///
  /// アダプター内で利用しているFirestoreのデータベースインスタンス。
  @override
  FirebaseFirestore get database => _database ?? FirebaseFirestore.instance;
  final FirebaseFirestore? _database;

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
    const FirestoreModelCounterConverter(),
    const FirestoreModelTimestampConverter(),
    const FirestoreModelUriConverter(),
    const FirestoreModelImageUriConverter(),
    const FirestoreModelVideoUriConverter(),
    const FirestoreModelSearchConverter(),
    const FirestoreModelGeoValueConverter(),
    const FirestoreModelRefConverter(),
    const FirestoreNullConverter(),
  };

  /// Options for initializing Firebase.
  ///
  /// Firebaseを初期化する際のオプション。
  final FirebaseOptions? options;

  /// Path prefix.
  ///
  /// パスのプレフィックス。
  @override
  final String? prefix;

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    await FirebaseCore.initialize(options: options);
    await _documentReference(query).delete();
    _FirestoreCache.getCache(options).set(_path(query.query.path));
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    await FirebaseCore.initialize(options: options);
    final snapshot = await _documentReference(query).get();
    final res = _convertFrom(snapshot.data()?.cast() ?? {});
    _FirestoreCache.getCache(options).set(_path(query.query.path), res);
    return res;
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {}

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {}

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    await FirebaseCore.initialize(options: options);
    final snapshot = await Future.wait<QuerySnapshot<DynamicMap>>(
      _collectionReference(query).map((reference) => reference.get()),
    );
    final res = snapshot.expand((e) => e.docChanges).toMap(
          (e) => MapEntry(e.doc.id, _convertFrom(e.doc.data()?.cast() ?? {})),
        );
    for (final doc in res.entries) {
      _FirestoreCache.getCache(options).set(
        "${_path(query.query.path)}/${doc.key}",
        doc.value,
      );
    }
    return res;
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await FirebaseCore.initialize(options: options);

    final converted = _convertTo(
      value,
      _FirestoreCache.getCache(options).get(_path(query.query.path)) ?? {},
    );
    await _documentReference(query).set(
      converted,
      SetOptions(merge: true),
    );
    _FirestoreCache.getCache(options).set(
      _path(query.query.path),
      value,
    );
  }

  @override
  bool get availableListen => true;

  @override
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    await FirebaseCore.initialize(options: options);
    final streams =
        _collectionReference(query).map((reference) => reference.snapshots());
    final subscriptions = streams.map((e) {
      return e.listen((event) {
        for (final doc in event.docChanges) {
          final converted = _convertFrom(doc.doc.data()?.cast() ?? {});
          query.callback?.call(
            ModelUpdateNotification(
              path: doc.doc.reference.path,
              id: doc.doc.id,
              status: _status(doc.type),
              value: converted,
              oldIndex: doc.oldIndex,
              newIndex: doc.newIndex,
              origin: query.origin,
              listen: availableListen,
              query: query.query,
            ),
          );
          _FirestoreCache.getCache(options).set(
            _path(query.query.path),
            converted,
          );
        }
      });
    }).toList();
    await Future.wait(streams.map((stream) => stream.first));
    return subscriptions;
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  ) async {
    await FirebaseCore.initialize(options: options);
    final stream = _documentReference(query).snapshots();
    // ignore: cancel_subscriptions
    final subscription = stream.listen((doc) {
      final converted = _convertFrom(doc.data()?.cast() ?? {});
      query.callback?.call(
        ModelUpdateNotification(
          path: doc.reference.path,
          id: doc.id,
          status: ModelUpdateNotificationStatus.modified,
          value: converted,
          origin: query.origin,
          listen: availableListen,
          query: query.query,
        ),
      );
      _FirestoreCache.getCache(options).set(
        _path(query.query.path),
        converted,
      );
    });
    await stream.first;
    return [subscription];
  }

  @override
  void deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) {
    if (ref is! ListenableFirestoreModelTransactionRef) {
      throw Exception("[ref] is not [ListenableFirestoreModelTransactionRef].");
    }
    ref.transaction.delete(database.doc(_path(query.query.path)));
    ref.localTransaction.add(() async {
      _FirestoreCache.getCache(options).set(_path(query.query.path));
    });
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) async {
    if (ref is! ListenableFirestoreModelTransactionRef) {
      throw Exception("[ref] is not [ListenableFirestoreModelTransactionRef].");
    }
    final snapshot =
        await ref.transaction.get(database.doc(_path(query.query.path)));
    final res = _convertFrom(snapshot.data() ?? {});
    _FirestoreCache.getCache(options).set(_path(query.query.path), res);
    return res;
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! ListenableFirestoreModelTransactionRef) {
      throw Exception("[ref] is not [ListenableFirestoreModelTransactionRef].");
    }
    final converted = _convertTo(
      value,
      _FirestoreCache.getCache(options).get(_path(query.query.path)) ?? {},
    );
    ref.transaction.set(
      database.doc(_path(query.query.path)),
      converted,
      SetOptions(merge: true),
    );
    ref.localTransaction.add(() async {
      _FirestoreCache.getCache(options).set(_path(query.query.path), value);
    });
  }

  @override
  FutureOr<void> runTransaction<T>(
    DocumentBase<T> doc,
    FutureOr<void> Function(
      ModelTransactionRef ref,
      ModelTransactionDocument<T> doc,
    ) transaction,
  ) async {
    await FirebaseCore.initialize(options: options);
    await database.runTransaction((handler) async {
      final ref = ListenableFirestoreModelTransactionRef._(handler);
      await transaction.call(ref, ref.read(doc));
      for (final tr in ref.localTransaction) {
        await tr.call();
      }
    });
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
    final filters = query.query.filters;
    for (final filter in filters) {
      switch (filter.type) {
        case ModelQueryFilterType.equalTo:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isEqualTo: _convertQueryValue(filter.value),
          );
          break;
        case ModelQueryFilterType.notEqualTo:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isNotEqualTo: _convertQueryValue(filter.value),
          );
          break;
        case ModelQueryFilterType.lessThan:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isLessThan: _convertQueryValue(filter.value),
          );
          break;
        case ModelQueryFilterType.greaterThan:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isGreaterThan: _convertQueryValue(filter.value),
          );
          break;
        case ModelQueryFilterType.lessThanOrEqualTo:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isLessThanOrEqualTo: _convertQueryValue(filter.value),
          );
          break;
        case ModelQueryFilterType.greaterThanOrEqualTo:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isGreaterThanOrEqualTo: _convertQueryValue(filter.value),
          );
          break;
        case ModelQueryFilterType.arrayContains:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            arrayContains: _convertQueryValue(filter.value),
          );
          break;
        case ModelQueryFilterType.like:
          final texts =
              filter.value.toString().toLowerCase().splitByBigram().distinct();
          for (final text in texts) {
            firestoreQuery = firestoreQuery.where(
              "${filter.key!}.$text",
              isEqualTo: true,
            );
          }
          break;
        case ModelQueryFilterType.isNull:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isNull: true,
          );
          break;
        case ModelQueryFilterType.isNotNull:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isNull: false,
          );
          break;
        default:
          break;
      }
    }
    for (final filter in filters) {
      switch (filter.type) {
        case ModelQueryFilterType.orderByAsc:
          firestoreQuery = firestoreQuery.orderBy(filter.key!);
          break;
        case ModelQueryFilterType.orderByDesc:
          firestoreQuery =
              firestoreQuery.orderBy(filter.key!, descending: true);
          break;
        case ModelQueryFilterType.limit:
          final val = filter.value;
          if (val is! num) {
            continue;
          }
          firestoreQuery = firestoreQuery.limit(
            val.toInt() * query.page,
          );
          break;
        default:
          break;
      }
    }
    return firestoreQuery;
  }

  Object? _convertQueryValue(Object? value) {
    Object? res;
    for (final converter in _converters) {
      res = converter.convertQueryValue(value, this);
      if (res != null) {
        return res;
      }
    }
    return value;
  }

  @override
  String _path(String original) {
    if (prefix.isEmpty) {
      return original;
    }
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
    final filters = query.query.filters;
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
        final list = items.map((e) => _convertQueryValue(e)).toList();
        final queries = <Query<DynamicMap>>[];
        for (var i = 0; i < list.length; i += 10) {
          queries.add(
            _query(
              database.collection(_path(query.query.path)),
              query,
            ).where(
              filter.key!,
              arrayContainsAny: list
                  .sublist(
                    i,
                    min(i + 10, list.length),
                  )
                  .toList(),
            ),
          );
        }
        return queries;
      }
    } else if (whereIn.isNotEmpty) {
      final filter = whereIn.first;
      final items = filter.value;
      if (items is List && items.isNotEmpty) {
        final list = items.map((e) => _convertQueryValue(e)).toList();
        final queries = <Query<DynamicMap>>[];
        for (var i = 0; i < list.length; i += 10) {
          queries.add(
            _query(
              database.collection(_path(query.query.path)),
              query,
            ).where(
              filter.key!,
              whereIn: list
                  .sublist(
                    i,
                    min(i + 10, list.length),
                  )
                  .toList(),
            ),
          );
        }
        return queries;
      }
    } else if (whereNotIn.isNotEmpty) {
      final filter = whereNotIn.first;
      final items = filter.value;
      if (items is List && items.isNotEmpty) {
        final list = items.map((e) => _convertQueryValue(e)).toList();
        final queries = <Query<DynamicMap>>[];
        for (var i = 0; i < list.length; i += 10) {
          queries.add(
            _query(
              database.collection(_path(query.query.path)),
              query,
            ).where(
              filter.key!,
              whereNotIn: list
                  .sublist(
                    i,
                    min(i + 10, list.length),
                  )
                  .toList(),
            ),
          );
        }
        return queries;
      }
    } else if (geoHash.isNotEmpty) {
      final filter = geoHash.first;
      final items = filter.value;
      if (items is List<String> && items.isNotEmpty) {
        final queries = <Query<DynamicMap>>[];
        for (var i = 0; i < items.length; i++) {
          final hash = items[i];
          queries.add(
            _query(
              database.collection(_path(query.query.path)),
              query,
            )
                .orderBy(
              filter.key!,
            )
                // ignore: prefer_interpolation_to_compose_strings
                .startAt([hash]).endAt([hash + "\uf8ff"]),
          );
        }
        return queries;
      }
    }
    return [
      _query(
        database.collection(_path(query.query.path)),
        query,
      )
    ];
  }

  ModelUpdateNotificationStatus _status(DocumentChangeType type) {
    switch (type) {
      case DocumentChangeType.added:
        return ModelUpdateNotificationStatus.added;
      case DocumentChangeType.modified:
        return ModelUpdateNotificationStatus.modified;
      case DocumentChangeType.removed:
        return ModelUpdateNotificationStatus.removed;
    }
  }
}

@immutable
class ListenableFirestoreModelTransactionRef extends ModelTransactionRef {
  ListenableFirestoreModelTransactionRef._(this.transaction);
  final Transaction transaction;
  final List<Future<void> Function()> localTransaction = [];
}
