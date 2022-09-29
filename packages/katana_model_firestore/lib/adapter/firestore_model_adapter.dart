part of katana_model_firestore;

/// Model adapter with Firebase Firestore available.
/// FirebaseFirestoreを利用できるようにしたモデルアダプター。
///
/// Firestore application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
/// 事前にFirestoreのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
///
/// Basically, the default [FirebaseFirestore.instance] is used, but it is possible to use a specified database by passing [database] when creating the adapter.
/// 基本的にデフォルトの[FirebaseFirestore.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定されたデータベースを利用することが可能です。
class FirestoreModelAdapter extends ModelAdapter {
  /// Model adapter with Firebase Firestore available.
  /// FirebaseFirestoreを利用できるようにしたモデルアダプター。
  ///
  /// Firestore application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
  /// 事前にFirestoreのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
  ///
  /// Basically, the default [FirebaseFirestore.instance] is used, but it is possible to use a specified database by passing [database] when creating the adapter.
  /// 基本的にデフォルトの[FirebaseFirestore.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定されたデータベースを利用することが可能です。
  const FirestoreModelAdapter({FirebaseFirestore? database})
      : _database = database;

  /// The Firestore database instance used in the adapter.
  /// アダプター内で利用しているFirestoreのデータベースインスタンス。
  FirebaseFirestore get database => _database ?? FirebaseFirestore.instance;
  final FirebaseFirestore? _database;

  @override
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    assert(
      FirebaseCore.isInitialized,
      "Firebase is not initialized. Please run [FirebaseCore.initialize].",
    );
    return _documentReference(query).delete();
  }

  @override
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query) async {
    assert(
      FirebaseCore.isInitialized,
      "Firebase is not initialized. Please run [FirebaseCore.initialize].",
    );
    final snapshot = await _documentReference(query).get();
    return snapshot.data()?.cast() ?? {};
  }

  @override
  void disposeCollection(ModelAdapterCollectionQuery query) {}

  @override
  void disposeDocument(ModelAdapterDocumentQuery query) {}

  @override
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    assert(
      FirebaseCore.isInitialized,
      "Firebase is not initialized. Please run [FirebaseCore.initialize].",
    );
    final snapshot = await Future.wait<QuerySnapshot<DynamicMap>>(
      _collectionReference(query).map((reference) => reference.get()),
    );
    return snapshot
        .expand((e) => e.docChanges)
        .toMap((e) => MapEntry(e.doc.id, e.doc.data()?.cast() ?? {}));
  }

  @override
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    assert(
      FirebaseCore.isInitialized,
      "Firebase is not initialized. Please run [FirebaseCore.initialize].",
    );
    return _documentReference(query).set(value);
  }

  @override
  void setRawData(Map<String, DynamicMap> rawData) {
    assert(
      FirebaseCore.isInitialized,
      "Firebase is not initialized. Please run [FirebaseCore.initialize].",
    );
    Future.forEach<MapEntry<String, Map<String, dynamic>>>(
      rawData.entries,
      (tmp) => database.doc(tmp.key).set(tmp.value),
    );
  }

  @override
  bool get availableListen => true;

  @override
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    assert(
      FirebaseCore.isInitialized,
      "Firebase is not initialized. Please run [FirebaseCore.initialize].",
    );
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
              value: doc.doc.data()?.cast() ?? {},
              oldIndex: doc.oldIndex,
              newIndex: doc.newIndex,
              origin: query.origin,
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
    assert(
      FirebaseCore.isInitialized,
      "Firebase is not initialized. Please run [FirebaseCore.initialize].",
    );
    final stream = _documentReference(query).snapshots();
    // ignore: cancel_subscriptions
    final subscription = stream.listen((doc) {
      query.callback?.call(
        ModelUpdateNotification(
          path: doc.reference.path,
          id: doc.id,
          status: ModelUpdateNotificationStatus.modified,
          value: doc.data()?.cast() ?? {},
          origin: query.origin,
        ),
      );
    });
    await stream.first;
    return [subscription];
  }

  Query<DynamicMap> _query(
    Query<DynamicMap> firestoreQuery,
    ModelAdapterCollectionQuery query,
  ) {
    if (query.query.key.isNotEmpty) {
      if (query.query.isEqualTo != null) {
        firestoreQuery = firestoreQuery.where(
          query.query.key!,
          isEqualTo: query.query.isEqualTo,
        );
      }
      if (query.query.isNotEqualTo != null) {
        firestoreQuery = firestoreQuery.where(
          query.query.key!,
          isNotEqualTo: query.query.isNotEqualTo,
        );
      }
      if (query.query.isGreaterThanOrEqualTo != null) {
        firestoreQuery = firestoreQuery.where(
          query.query.key!,
          isGreaterThanOrEqualTo: query.query.isGreaterThanOrEqualTo,
        );
      }
      if (query.query.isLessThanOrEqualTo != null) {
        firestoreQuery = firestoreQuery.where(
          query.query.key!,
          isLessThanOrEqualTo: query.query.isLessThanOrEqualTo,
        );
      }
      if (query.query.arrayContains != null) {
        firestoreQuery = firestoreQuery.where(
          query.query.key!,
          arrayContains: query.query.arrayContains,
        );
      }
      if (query.query.search != null) {
        query.query.search
            ?.toLowerCase()
            .splitByBigram()
            .distinct()
            .forEach((text) {
          firestoreQuery =
              firestoreQuery.where("${query.query.key}.$text", isEqualTo: true);
        });
      }
    }
    if (query.query.limit != null) {
      firestoreQuery = firestoreQuery.limit(
        query.query.limit! * query.page,
      );
    }
    if (query.query.orderBy.isNotEmpty) {
      switch (query.query.order) {
        case ModelQueryOrder.asc:
          if (!(query.query.key.isNotEmpty &&
              query.query.key == query.query.orderBy &&
              (query.query.isEqualTo != null ||
                  query.query.isNotEqualTo != null ||
                  query.query.arrayContainsAny != null ||
                  query.query.whereIn != null ||
                  query.query.whereNotIn != null ||
                  query.query.search != null))) {
            firestoreQuery = firestoreQuery.orderBy(query.query.orderBy!);
          }
          break;
        case ModelQueryOrder.desc:
          if (!(query.query.key.isNotEmpty &&
              query.query.key == query.query.orderBy &&
              (query.query.isEqualTo ||
                  query.query.isNotEqualTo != null ||
                  query.query.arrayContainsAny != null ||
                  query.query.whereIn != null ||
                  query.query.whereNotIn != null ||
                  query.query.search != null))) {
            firestoreQuery =
                firestoreQuery.orderBy(query.query.orderBy!, descending: true);
          }
          break;
      }
    } else {
      if (query.query.isGreaterThanOrEqualTo != null) {
        firestoreQuery = firestoreQuery.orderBy(query.query.key!);
      } else if (query.query.isLessThanOrEqualTo != null) {
        firestoreQuery = firestoreQuery.orderBy(query.query.key!);
      }
    }

    return firestoreQuery;
  }

  DocumentReference<DynamicMap> _documentReference(
    ModelAdapterDocumentQuery query,
  ) =>
      database.doc(query.query.path);

  List<Query<DynamicMap>> _collectionReference(
    ModelAdapterCollectionQuery query,
  ) {
    if (query.query.key.isNotEmpty) {
      if (query.query.arrayContainsAny != null) {
        final items = query.query.arrayContainsAny!;
        if (items.isNotEmpty) {
          final queries = <Query<DynamicMap>>[];
          for (var i = 0; i < items.length; i += 10) {
            queries.add(
              _query(
                database
                    .collection(query.query.path.trimQuery().trimString("/")),
                query,
              ).where(
                query.query.key!,
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
      } else if (query.query.whereIn != null) {
        final items = query.query.whereIn!;
        if (items.isNotEmpty) {
          final queries = <Query<DynamicMap>>[];
          for (var i = 0; i < items.length; i += 10) {
            queries.add(
              _query(
                database
                    .collection(query.query.path.trimQuery().trimString("/")),
                query,
              ).where(
                query.query.key!,
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
      } else if (query.query.whereNotIn != null) {
        final items = query.query.whereNotIn!;
        if (items.isNotEmpty) {
          final queries = <Query<DynamicMap>>[];
          for (var i = 0; i < items.length; i += 10) {
            queries.add(
              _query(
                database
                    .collection(query.query.path.trimQuery().trimString("/")),
                query,
              ).where(
                query.query.key!,
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
      } else if (query.query.geoHash != null) {
        final items = query.query.geoHash!;
        if (items.isNotEmpty) {
          final queries = <Query<DynamicMap>>[];
          for (var i = 0; i < items.length; i++) {
            final hash = items[i];
            queries.add(
              _query(
                database
                    .collection(query.query.path.trimQuery().trimString("/")),
                query,
              )
                  .orderBy(
                query.query.key!,
              )
                  .startAt([hash]).endAt([hash + "\uf8ff"]),
            );
          }
          return queries;
        }
      }
    }
    return [
      _query(
        database.collection(query.query.path.trimQuery().trimString("/")),
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
