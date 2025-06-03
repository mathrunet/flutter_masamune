part of "/katana_model_firestore.dart";

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
/// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
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
/// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
///
/// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
class ListenableFirestoreModelAdapter extends FirestoreModelAdapter
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
  /// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
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
  /// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
  ///
  /// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
  const ListenableFirestoreModelAdapter({
    super.initialValue,
    super.database,
    super.cachedRuntimeDatabase,
    super.options,
    super.iosOptions,
    super.androidOptions,
    super.webOptions,
    super.linuxOptions,
    super.windowsOptions,
    super.macosOptions,
    super.prefix,
    super.validator,
    super.onInitialize,
    super.databaseId,
  });

  @override
  bool get availableListen => true;

  @override
  Future<List<StreamSubscription>> listenCollection(
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
    Map<String, DynamicMap>? map = cache?.value;
    if (map != null) {
      if (validator != null) {
        await validator!.onPreloadCollection(query);
        final res = map.map((k, v) => MapEntry(k, _convertFrom(v)));
        await validator!.onPostloadCollection(query, res);
      }
      final res = <String, DynamicMap>{};
      for (final entry in map.entries) {
        final path = "${_path(query.query.path)}/${entry.key}";
        final converted = _convertFrom(entry.value);
        query.callback?.call(
          ModelUpdateNotification(
            path: path,
            id: entry.key,
            status: ModelUpdateNotificationStatus.added,
            value: converted,
            newIndex: 0,
            origin: query.origin,
            listen: availableListen,
            query: query.query,
          ),
        );
        res[entry.key] = converted;
      }
      await cachedRuntimeDatabase.syncCollection(query, res, prefix: prefix);
      for (final doc in res.entries) {
        _FirestoreCache.getCache(options).set(
          "${_path(query.query.path)}/${doc.key}",
          doc.value,
        );
      }
      if (cache?.query == null) {
        return [];
      }
    }
    if (cache?.query != null) {
      query = cache!.query!;
    }
    final localRes =
        await cachedRuntimeDatabase.getInitialCollection(query, prefix: prefix);
    if (localRes.isNotEmpty) {
      if (validator != null) {
        await validator!.onPostloadCollection(query, localRes);
      }
      for (final entry in localRes!.entries) {
        if (!query.query.hasMatchAsMap(entry.value)) {
          continue;
        }
        query.callback?.call(
          ModelUpdateNotification(
            path: entry.key,
            id: entry.key.last(),
            status: ModelUpdateNotificationStatus.added,
            value: entry.value,
            newIndex: 0,
            origin: query.origin,
            listen: availableListen,
            query: query.query,
          ),
        );
      }
    }
    final streams =
        _collectionReference(query).map((reference) => reference.snapshots());
    final subscriptions = streams.map((e) {
      return e.listen((event) async {
        final converted = event.docChanges.toMap((e) {
          return MapEntry(e.doc.id, _convertFrom(e.doc.data()?.cast() ?? {}));
        });
        if (validator != null) {
          await validator!.onPreloadCollection(query);
          await validator!.onPostloadCollection(query, converted);
        }
        await onPostloadCollection(query, converted);
        final res = <String, DynamicMap>{};
        for (final doc in event.docChanges) {
          final path = doc.doc.reference.path;
          final converted = _convertFrom(doc.doc.data()?.cast() ?? {});
          query.callback?.call(
            ModelUpdateNotification(
              path: path,
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
          res[doc.doc.id] = converted;
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
      });
    }).toList();
    await Future.wait(streams.map((stream) => stream.first));
    return subscriptions;
  }

  @override
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  ) async {
    _assert();
    if (validator != null) {
      await validator!.onPreloadDocument(query);
    }
    if (onInitialize != null) {
      await onInitialize?.call(options);
    } else {
      await FirebaseCore.initialize(options: options);
    }
    DynamicMap? map = await onPreloadDocument(query);
    if (map != null) {
      if (validator != null) {
        await validator!.onPostloadDocument(query, map);
      }
      final converted = _convertFrom(map);
      query.callback?.call(
        ModelUpdateNotification(
          path: query.query.path.parentPath(),
          id: query.query.path.last(),
          status: ModelUpdateNotificationStatus.modified,
          value: converted,
          origin: query.origin,
          listen: availableListen,
          query: query.query,
        ),
      );
      if (validator != null) {
        await validator!.onPostloadDocument(query, converted);
      }
      await cachedRuntimeDatabase.syncDocument(query, converted,
          prefix: prefix);
      _FirestoreCache.getCache(options).set(
        _path(query.query.path),
        converted,
      );
    }
    final localRes =
        await cachedRuntimeDatabase.getInitialDocument(query, prefix: prefix);
    if (localRes.isNotEmpty) {
      if (validator != null) {
        await validator!.onPostloadDocument(query, localRes);
      }
      query.callback?.call(
        ModelUpdateNotification(
          path: query.query.path.parentPath(),
          id: query.query.path.last(),
          status: ModelUpdateNotificationStatus.modified,
          value: localRes!,
          origin: query.origin,
          listen: availableListen,
          query: query.query,
        ),
      );
    }
    final stream = _documentReference(query).snapshots();
    // ignore: cancel_subscriptions
    final subscription = stream.listen((doc) async {
      if (validator != null) {
        await validator!.onPreloadDocument(query);
      }
      final map = doc.data()?.cast<String, dynamic>() ?? <String, dynamic>{};
      final converted = _convertFrom(map);
      if (converted.isEmpty && localRes.isNotEmpty) {
        return;
      }
      await onPostloadDocument(query, converted);
      if (validator != null) {
        await validator!.onPostloadDocument(query, converted);
      }
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
      if (validator != null) {
        await validator!.onPostloadDocument(query, converted);
      }
      await cachedRuntimeDatabase.syncDocument(query, converted,
          prefix: prefix);
      _FirestoreCache.getCache(options).set(
        _path(query.query.path),
        converted,
      );
    });
    await stream.first;
    return [subscription];
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
}
