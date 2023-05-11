part of katana_model_firestore;

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
/// In addition, internally retrieved data can be cached, and notifications can be sent to the relevant data for internal changes that occur in [DocumentBase.save], [DocumentBase.delete], etc., so that changes can be reflected.
///
/// The internal database can be specified in [localDatabase].
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
/// また、内部で取得したデータをキャッシュしておき、[DocumentBase.save]や[DocumentBase.delete]などで発生した内部的な変更については関連するデータに通知を送ることができ変更を反映することができます。
///
/// 内部データベースは[localDatabase]で指定することができます。
///
/// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
class FirestoreModelAdapter extends ModelAdapter {
  /// Model adapter with Firebase Firestore available.
  ///
  /// Firestore application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
  ///
  /// Basically, the default [FirebaseFirestore.instance] is used, but it is possible to use a specified database by passing [database] when creating the adapter.
  ///
  /// You can initialize Firebase by passing [options].
  ///
  /// In addition, internally retrieved data can be cached, and notifications can be sent to the relevant data for internal changes that occur in [DocumentBase.save], [DocumentBase.delete], etc., so that changes can be reflected.
  ///
  /// The internal database can be specified in [localDatabase].
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
  /// また、内部で取得したデータをキャッシュしておき、[DocumentBase.save]や[DocumentBase.delete]などで発生した内部的な変更については関連するデータに通知を送ることができ変更を反映することができます。
  ///
  /// 内部データベースは[localDatabase]で指定することができます。
  ///
  /// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
  const FirestoreModelAdapter({
    FirebaseFirestore? database,
    NoSqlDatabase? localDatabase,
    this.options,
    this.prefix,
  })  : _database = database,
        _localDatabase = localDatabase;

  /// The Firestore database instance used in the adapter.
  ///
  /// アダプター内で利用しているFirestoreのデータベースインスタンス。
  FirebaseFirestore get database => _database ?? FirebaseFirestore.instance;
  final FirebaseFirestore? _database;

  /// Caches data retrieved from the specified internal database, Firestore.
  ///
  /// 指定の内部データベース。Firestoreから取得したデータをキャッシュします。
  NoSqlDatabase get localDatabase {
    final database = _localDatabase ?? sharedLocalDatabase;
    return database;
  }

  final NoSqlDatabase? _localDatabase;

  /// A common internal database throughout the app.
  ///
  /// アプリ内全体での共通の内部データベース。
  static final NoSqlDatabase sharedLocalDatabase = NoSqlDatabase();

  /// Options for initializing Firebase.
  ///
  /// Firebaseを初期化する際のオプション。
  final FirebaseOptions? options;

  /// Path prefix.
  ///
  /// パスのプレフィックス。
  final String? prefix;

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    await FirebaseCore.initialize(options: options);
    await _documentReference(query).delete();
    await localDatabase.deleteDocument(query, prefix: prefix);
    _FirestoreCache.getCache(options).set(_path(query.query.path));
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    await FirebaseCore.initialize(options: options);
    final snapshot = await _documentReference(query).get();
    final res = _convertFrom(snapshot.data()?.cast() ?? {});
    await localDatabase.syncDocument(query, res, prefix: prefix);
    _FirestoreCache.getCache(options).set(_path(query.query.path), res);
    return res;
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {
    localDatabase.removeCollectionListener(query, prefix: prefix);
  }

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {
    localDatabase.removeDocumentListener(query, prefix: prefix);
  }

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
    await localDatabase.syncCollection(query, res, prefix: prefix);
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
    await localDatabase.saveDocument(query, value, prefix: prefix);
    _FirestoreCache.getCache(options).set(
      _path(query.query.path),
      value,
    );
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
    if (ref is! FirestoreModelTransactionRef) {
      throw Exception("[ref] is not [FirestoreModelTransactionRef].");
    }
    ref.transaction.delete(database.doc(_path(query.query.path)));
    ref.localTransaction.add(() async {
      await localDatabase.deleteDocument(query, prefix: prefix);
      _FirestoreCache.getCache(options).set(_path(query.query.path));
    });
  }

  @override
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  ) async {
    if (ref is! FirestoreModelTransactionRef) {
      throw Exception("[ref] is not [FirestoreModelTransactionRef].");
    }
    final snapshot =
        await ref.transaction.get(database.doc(_path(query.query.path)));
    final res = _convertFrom(snapshot.data() ?? {});
    await localDatabase.syncDocument(query, res, prefix: prefix);
    _FirestoreCache.getCache(options).set(_path(query.query.path), res);
    return res;
  }

  @override
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) {
    if (ref is! FirestoreModelTransactionRef) {
      throw Exception("[ref] is not [FirestoreModelTransactionRef].");
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
      await localDatabase.saveDocument(query, value, prefix: prefix);
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
      final ref = FirestoreModelTransactionRef._(handler);
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
      // ModelCounter検索
      if (val is int) {
        final targetKey = "#$key";
        final type = map.getAsMap(targetKey).get(_kTypeKey, "");
        if (type == (ModelCounter).toString()) {
          res[key] = ModelCounter(val.toInt()).toJson();
        } else if (type == (ModelTimestamp).toString()) {
          res[key] = ModelTimestamp(
            DateTime.fromMillisecondsSinceEpoch(val),
          ).toJson();
        } else {
          res[key] = val;
        }
        // ModelTimestamp検索
      } else if (val is Timestamp) {
        res[key] = ModelTimestamp(val.toDate()).toJson();
        // ModelRef検索
      } else if (val is DocumentReference<DynamicMap>) {
        final path = prefix.isEmpty
            ? val.path
            : val.path.replaceAll(
                RegExp("^${prefix!.trimQuery().trimString("/")}/"),
                "",
              );
        res[key] = ModelRefBase.fromPath(
          path,
        ).toJson();
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
      if (val is DynamicMap && val.containsKey(_kTypeKey)) {
        final type = val.get(_kTypeKey, "");
        if (type == (ModelCounter).toString()) {
          final fromUser = val.get(ModelCounter.kSourceKey, "") ==
              ModelFieldValueSource.user.name;
          final value = val.get(ModelCounter.kValueKey, 0);
          final increment = val.get(ModelCounter.kIncrementKey, 0);
          final targetKey = "#$key";
          res[targetKey] = {
            kTypeFieldKey: (ModelCounter).toString(),
            ModelCounter.kValueKey: value,
            ModelCounter.kIncrementKey: increment,
            _kTargetKey: key,
          };
          if (fromUser) {
            res[key] = value;
          } else {
            res[key] = FieldValue.increment(increment);
          }
        } else if (type == (ModelTimestamp).toString()) {
          final fromUser = val.get(ModelTimestamp.kSourceKey, "") ==
              ModelFieldValueSource.user.name;
          final value = val.get(ModelTimestamp.kTimeKey, 0);
          final useNow = val.get(ModelTimestamp.kNowKey, false);
          final targetKey = "#$key";
          res[targetKey] = {
            kTypeFieldKey: (ModelTimestamp).toString(),
            ModelTimestamp.kTimeKey: value,
            _kTargetKey: key,
          };
          if (fromUser) {
            if (useNow) {
              res[key] = FieldValue.serverTimestamp();
            } else {
              res[key] = Timestamp.fromMillisecondsSinceEpoch(value);
            }
          }
        } else if (type.startsWith((ModelRefBase).toString())) {
          final ref = ModelRefBase.fromJson(val);
          res[key] = database.doc(_path(ref.modelQuery.path));
        } else {
          res[key] = val;
        }
      } else if (val is DynamicMap && original.containsKey(key)) {
        final originalMap = original[key];
        if (originalMap is Map) {
          final newRes = Map<String, dynamic>.from(val);
          for (final o in originalMap.entries) {
            if (!val.containsKey(o.key)) {
              newRes[o.key] = FieldValue.delete();
            }
          }
          res[key] = newRes;
        }
      } else if (val == null) {
        res[key] = FieldValue.delete();
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
    if (value is ModelCounter) {
      return value.value;
    } else if (value is ModelTimestamp) {
      return Timestamp.fromDate(value.value);
    } else if (value is ModelRefBase) {
      return database.doc(_path(value.modelQuery.path));
    } else {
      return value;
    }
  }

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
}

@immutable
class FirestoreModelTransactionRef extends ModelTransactionRef {
  FirestoreModelTransactionRef._(
    this.transaction,
  );
  final Transaction transaction;
  final List<Future<void> Function()> localTransaction = [];
}
