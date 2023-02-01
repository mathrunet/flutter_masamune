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
class ListenableFirestoreModelAdapter extends ModelAdapter {
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
  FirebaseFirestore get database => _database ?? FirebaseFirestore.instance;
  final FirebaseFirestore? _database;

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
    return _documentReference(query).delete();
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    await FirebaseCore.initialize(options: options);
    final snapshot = await _documentReference(query).get();
    return _convertFrom(snapshot.data()?.cast() ?? {});
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
    return snapshot.expand((e) => e.docChanges).toMap(
          (e) => MapEntry(e.doc.id, _convertFrom(e.doc.data()?.cast() ?? {})),
        );
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await FirebaseCore.initialize(options: options);

    return _documentReference(query).set(
      _convertTo(value),
      SetOptions(merge: true),
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
          query.callback?.call(
            ModelUpdateNotification(
              path: doc.doc.reference.path,
              id: doc.doc.id,
              status: _status(doc.type),
              value: _convertFrom(doc.doc.data()?.cast() ?? {}),
              oldIndex: doc.oldIndex,
              newIndex: doc.newIndex,
              origin: query.origin,
              listen: availableListen,
            ),
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
      query.callback?.call(
        ModelUpdateNotification(
          path: doc.reference.path,
          id: doc.id,
          status: ModelUpdateNotificationStatus.modified,
          value: _convertFrom(doc.data()?.cast() ?? {}),
          origin: query.origin,
          listen: availableListen,
        ),
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
    return _convertFrom(snapshot.data() ?? {});
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
    ref.transaction.set(
      database.doc(_path(query.query.path)),
      _convertTo(value),
      SetOptions(merge: true),
    );
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
    await FirebaseCore.initialize(options: options);
    await database.runTransaction((handler) async {
      final ref = ListenableFirestoreModelTransactionRef._(handler);
      await transaction.call(ref, ref.read(doc));
    });
  }

  DynamicMap _convertFrom(DynamicMap map) {
    final res = <String, dynamic>{};

    for (final tmp in map.entries) {
      final key = tmp.key;
      final val = tmp.value;
      if (val is DynamicMap && val.containsKey(_kTypeKey)) {
        final type = val.get(_kTypeKey, "");
        if (type == (ModelCounter).toString()) {
          final targetKey = val.get(_kTargetKey, "");
          res[key] = ModelCounter(map.get(targetKey, 0)).toJson();
        } else if (type == (ModelTimestamp).toString()) {
          final targetKey = val.get(_kTargetKey, "");
          if (map.containsKey(targetKey)) {
            if (map[targetKey] is Timestamp) {
              final timestamp = map[targetKey] as Timestamp;
              res[key] = ModelTimestamp(timestamp.toDate()).toJson();
            } else if (map[targetKey] is int) {
              final timestamp = map[targetKey] as int;
              res[key] = ModelTimestamp(
                DateTime.fromMillisecondsSinceEpoch(timestamp),
              ).toJson();
            } else {
              res[key] = const ModelTimestamp().toJson();
            }
          } else {
            res[key] = const ModelTimestamp().toJson();
          }
        } else {
          res[key] = val;
        }
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

  DynamicMap _convertTo(DynamicMap map) {
    final res = <String, dynamic>{};
    for (final tmp in map.entries) {
      final key = tmp.key;
      final val = tmp.value;
      if (val is DynamicMap && val.containsKey(_kTypeKey)) {
        final type = val.get(_kTypeKey, "");
        if (type == (ModelCounter).toString()) {
          final counter = ModelCounter.fromJson(val);
          final targetKey = "#$key";
          res[key] = {
            ...counter.toJson(),
            _kTargetKey: targetKey,
          };
          res[targetKey] = FieldValue.increment(counter.incrementValue);
        } else if (type == (ModelTimestamp).toString()) {
          final timestamp = ModelTimestamp.fromJson(val);
          final targetKey = "#$key";
          res[key] = {
            ...timestamp.toJson(),
            _kTargetKey: targetKey,
          };
          res[targetKey] = FieldValue.serverTimestamp();
        } else if (type.startsWith((ModelRefBase).toString())) {
          final ref = ModelRefBase.fromJson(val);
          res[key] = database.doc(_path(ref.modelQuery.path));
        } else {
          res[key] = val;
        }
      } else if (val == null) {
        res[key] = FieldValue.delete();
      } else {
        res[key] = val;
      }
    }
    return res;
  }

  @Deprecated("This is an implementation that is not necessary.")
  List<ModelQueryFilter> _addOldFilter(
    ModelAdapterCollectionQuery query,
  ) {
    final res = <ModelQueryFilter>[];
    if (query.query.key.isNotEmpty) {
      if (query.query.isEqualTo != null) {
        res.add(ModelQueryFilter.equal(
            key: query.query.key!, value: query.query.isEqualTo));
      } else if (query.query.isNotEqualTo != null) {
        res.add(ModelQueryFilter.notEqual(
            key: query.query.key!, value: query.query.isNotEqualTo));
      } else if (query.query.isLessThanOrEqualTo != null) {
        res.add(ModelQueryFilter.lessThanOrEqual(
            key: query.query.key!, value: query.query.isLessThanOrEqualTo));
      } else if (query.query.isGreaterThanOrEqualTo != null) {
        res.add(ModelQueryFilter.greaterThanOrEqual(
            key: query.query.key!, value: query.query.isGreaterThanOrEqualTo));
      } else if (query.query.arrayContains != null) {
        res.add(ModelQueryFilter.contains(
            key: query.query.key!, value: query.query.arrayContains));
      } else if (query.query.arrayContainsAny != null) {
        res.add(ModelQueryFilter.containsAny(
            key: query.query.key!,
            values: query.query.arrayContainsAny!.cast<Object>()));
      } else if (query.query.whereIn != null) {
        res.add(ModelQueryFilter.where(
            key: query.query.key!,
            values: query.query.whereIn!.cast<Object>()));
      } else if (query.query.whereNotIn != null) {
        res.add(ModelQueryFilter.notWhere(
            key: query.query.key!,
            values: query.query.whereNotIn!.cast<Object>()));
      } else if (query.query.geoHash != null) {
        res.add(ModelQueryFilter.geo(
            key: query.query.key!, geoHash: query.query.geoHash!));
      } else if (query.query.searchText.isNotEmpty) {
        res.add(ModelQueryFilter.like(
            key: query.query.key!, text: query.query.searchText!));
      }
    }
    if (query.query.orderBy.isNotEmpty) {
      if (query.query.order == ModelQueryOrder.asc) {
        res.add(ModelQueryFilter.orderByAsc(key: query.query.orderBy!));
      } else {
        res.add(ModelQueryFilter.orderByDesc(key: query.query.orderBy!));
      }
    }
    if (query.query.limit != null) {
      res.add(ModelQueryFilter.limitTo(value: query.query.limit!));
    }
    return res;
  }

  Query<DynamicMap> _query(
    Query<DynamicMap> firestoreQuery,
    ModelAdapterCollectionQuery query,
  ) {
    // TODO: Deprecatedが取れればここを修正
    final filters = [
      ...query.query.filters,
      ..._addOldFilter(query),
    ];
    for (final filter in filters) {
      switch (filter.type) {
        case ModelQueryFilterType.equalTo:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isEqualTo: filter.value,
          );
          break;
        case ModelQueryFilterType.notEqualTo:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isNotEqualTo: filter.value,
          );
          break;
        case ModelQueryFilterType.lessThan:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isLessThan: filter.value,
          );
          break;
        case ModelQueryFilterType.greaterThan:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isGreaterThan: filter.value,
          );
          break;
        case ModelQueryFilterType.lessThanOrEqualTo:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isLessThanOrEqualTo: filter.value,
          );
          break;
        case ModelQueryFilterType.greaterThanOrEqualTo:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            isGreaterThanOrEqualTo: filter.value,
          );
          break;
        case ModelQueryFilterType.arrayContains:
          firestoreQuery = firestoreQuery.where(
            filter.key!,
            arrayContains: filter.value,
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
    // TODO: Deprecatedが取れればここを修正
    final filters = [
      ...query.query.filters,
      ..._addOldFilter(query),
    ];
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
        final queries = <Query<DynamicMap>>[];
        for (var i = 0; i < items.length; i += 10) {
          queries.add(
            _query(
              database.collection(_path(query.query.path)),
              query,
            ).where(
              filter.key!,
              arrayContainsAny: items
                  .sublist(
                    i,
                    min(i + 10, items.length),
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
        final queries = <Query<DynamicMap>>[];
        for (var i = 0; i < items.length; i += 10) {
          queries.add(
            _query(
              database.collection(_path(query.query.path)),
              query,
            ).where(
              filter.key!,
              whereIn: items
                  .sublist(
                    i,
                    min(i + 10, items.length),
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
        final queries = <Query<DynamicMap>>[];
        for (var i = 0; i < items.length; i += 10) {
          queries.add(
            _query(
              database.collection(_path(query.query.path)),
              query,
            ).where(
              filter.key!,
              whereNotIn: items
                  .sublist(
                    i,
                    min(i + 10, items.length),
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
  const ListenableFirestoreModelTransactionRef._(this.transaction);
  final Transaction transaction;
}
