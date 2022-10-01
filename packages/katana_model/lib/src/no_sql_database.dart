part of katana_model;

/// Class for building a NoSql database model within an application.
/// アプリケーション内でのNoSqlデータベースモデルを構築するためのクラスです。
///
/// It is based on the Firestore model and handles data separately as documents and collections.
/// Firestoreのモデルをベースとしており、ドキュメントとコレクションに分けてデータを扱います。
/// https://firebase.google.com/docs/firestore/data-model
///
/// Use [loadDocument] to read individual data and [loadCollection] to read a collection of data.
/// 個別のデータの読み取りは[loadDocument]を利用し、まとまったデータの読み取りは[loadCollection]を利用します。
///
/// You can pass [ModelAdapterDocumentQuery] on each data read and specify callbacks when data is updated internally.
/// それぞれのデータ読み取り時に[ModelAdapterDocumentQuery]を渡すことができ、データが内部で更新された場合のコールバックを指定できます。
///
/// This makes it possible to monitor changes that occur elsewhere (or outside the application, such as on the server side) and to handle data in sync with the database.
/// これにより他の箇所で起きた（もしくはサーバー側などのアプリ外）変更を監視することが可能になりデータベースと同期したデータを扱うことができます。
///
/// Data can be added (updated) and deleted only in documents. Use [saveDocument] and [deleteDocument] respectively.
/// データの追加（更新）、削除はドキュメントのみで行うことが可能です。それぞれ[saveDocument]、[deleteDocument]で行います。
///
/// Callbacks for [onInitialize], [onLoad], [onSaved], and [onDeleted] can be passed when an object is created, making it possible to add processing that links with external databases, etc. when data is read or saved.
/// オブジェクトの作成時に[onInitialize]、[onLoad]、[onSaved]、[onDeleted]のコールバックを渡すことができ、データの読み出し時や保存時などに外部のデータベース等との連携処理を追加することが可能です。
///
/// When a document or collection is destroyed, use [removeDocumentListener] and [removeCollectionListener] to remove each document or collection from the monitoring target.
/// ドキュメントやコレクションが破棄される際は[removeDocumentListener]、[removeCollectionListener]で各ドキュメントやコレクションを監視対象から外してください。
class NoSqlDatabase {
  /// Class for building a NoSql database model within an application.
  /// アプリケーション内でのNoSqlデータベースモデルを構築するためのクラスです。
  ///
  /// It is based on the Firestore model and handles data separately as documents and collections.
  /// Firestoreのモデルをベースとしており、ドキュメントとコレクションに分けてデータを扱います。
  /// https://firebase.google.com/docs/firestore/data-model
  ///
  /// Use [loadDocument] to read individual data and [loadCollection] to read a collection of data.
  /// 個別のデータの読み取りは[loadDocument]を利用し、まとまったデータの読み取りは[loadCollection]を利用します。
  ///
  /// You can pass [ModelAdapterDocumentQuery] on each data read and specify callbacks when data is updated internally.
  /// それぞれのデータ読み取り時に[ModelAdapterDocumentQuery]を渡すことができ、データが内部で更新された場合のコールバックを指定できます。
  ///
  /// This makes it possible to monitor changes that occur elsewhere (or outside the application, such as on the server side) and to handle data in sync with the database.
  /// これにより他の箇所で起きた（もしくはサーバー側などのアプリ外）変更を監視することが可能になりデータベースと同期したデータを扱うことができます。
  ///
  /// Data can be added (updated) and deleted only in documents. Use [saveDocument] and [deleteDocument] respectively.
  /// データの追加（更新）、削除はドキュメントのみで行うことが可能です。それぞれ[saveDocument]、[deleteDocument]で行います。
  ///
  /// Callbacks for [onInitialize], [onLoad], [onSaved], and [onDeleted] can be passed when an object is created, making it possible to add processing that links with external databases, etc. when data is read or saved.
  /// オブジェクトの作成時に[onInitialize]、[onLoad]、[onSaved]、[onDeleted]のコールバックを渡すことができ、データの読み出し時や保存時などに外部のデータベース等との連携処理を追加することが可能です。
  ///
  /// When a document or collection is destroyed, use [removeDocumentListener] and [removeCollectionListener] to remove each document or collection from the monitoring target.
  /// ドキュメントやコレクションが破棄される際は[removeDocumentListener]、[removeCollectionListener]で各ドキュメントやコレクションを監視対象から外してください。
  NoSqlDatabase({
    this.onInitialize,
    this.onLoad,
    this.onSaved,
    this.onDeleted,
  }) {
    onInitialize?.call();
  }
  // ignore: prefer_final_fields
  DynamicMap _data = {};

  /// Executed at Database initialization time.
  /// Databaseの初期化時に実行されます。
  final Future<void> Function()? onInitialize;

  /// Executed when saving the Database.
  /// Databaseの保存時に実行されます。
  final Future<void> Function()? onSaved;

  /// Executed when loading Database.
  /// Databaseの読み込み時に実行されます。
  final Future<void> Function()? onLoad;

  /// Executed when Database is deleted.
  /// Databaseの削除時に実行されます。
  final Future<void> Function()? onDeleted;

  final List<String> _registeredRawDataPath = [];
  final Map<String, Set<ModelAdapterDocumentQuery>> _documentListeners = {};
  final Map<String, Set<ModelAdapterCollectionQuery>> _collectionListeners = {};
  final Map<ModelAdapterCollectionQuery, List<MapEntry<String, DynamicMap>>>
      _collectionEntries = {};

  void _addDocumentListener(ModelAdapterDocumentQuery query) {
    final trimPath = query.query.path.trimQuery().trimString("/");
    if (_documentListeners.containsKey(trimPath)) {
      final listener = _documentListeners[trimPath]!;
      if (listener.contains(query)) {
        return;
      }
      listener.add(query);
    } else {
      _documentListeners[trimPath] = {query};
    }
  }

  void _addCollectionListener(ModelAdapterCollectionQuery query) {
    final trimPath = query.query.path.trimQuery().trimString("/");
    if (_collectionListeners.containsKey(trimPath)) {
      final listener = _collectionListeners[trimPath]!;
      if (listener.contains(query)) {
        return;
      }
      listener.add(query);
    } else {
      _collectionListeners[trimPath] = {query};
    }
  }

  /// Pass [query] to remove the document corresponding to [query] from the monitored list.
  /// [query]を渡して[query]に対応するドキュメントを監視対象から外します。
  void removeDocumentListener(ModelAdapterDocumentQuery? query) {
    if (query == null) {
      return;
    }
    final trimPath = query.query.path.trimQuery().trimString("/");
    if (_documentListeners.containsKey(trimPath)) {
      _documentListeners[trimPath]!.remove(query);
    }
  }

  /// Pass [query] to remove the collection corresponding to [query] from the monitored list.
  /// [query]を渡して[query]に対応するコレクションを監視対象から外します。
  void removeCollectionListener(ModelAdapterCollectionQuery? query) {
    if (query == null) {
      return;
    }
    final trimPath = query.query.path.trimQuery().trimString("/");
    if (_collectionListeners.containsKey(trimPath)) {
      _collectionListeners[trimPath]!.remove(query);
    }
  }

  /// Pass [query] and load the document corresponding to [query].
  /// [query]を渡して[query]に対応するドキュメントを読み込みます。
  ///
  /// If data is found, it is returned in [DynamicMap].
  /// データが見つかった場合は[DynamicMap]で返されます。
  ///
  /// If no data is found or the path is invalid, [Null] is returned.
  /// データが見つからなかったり、パスに不正があった場合は[Null]が返されます。
  Future<DynamicMap?> loadDocument(ModelAdapterDocumentQuery query) async {
    _addDocumentListener(query);
    await onLoad?.call();
    final trimPath = query.query.path.trimQuery().trimString("/");
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return null;
    }
    final value = _data._readFromPath(paths, 0);
    if (value is! Map) {
      return null;
    }
    return Map<String, dynamic>.from(value);
  }

  /// Pass [query] and load the collection corresponding to [query].
  /// [query]を渡して[query]に対応するコレクションを読み込みます。
  ///
  /// If data is found, it will be returned in [Map<String, DynamicMap>].
  /// データが見つかった場合は[Map<String, DynamicMap>]で返されます。
  ///
  /// [String] contains the ID of each document (if the path is `aaaaa/bbbbb/cccc/ddddd`, the ID is `ddddd`).
  /// [String]にはそれぞれのドキュメントのID（パスが`aaaa/bbbb/cccc/dddd`の場合IDは`dddd`になります）が含まれています。
  ///
  /// If no data is found or the path is invalid, [Null] is returned.
  /// データが見つからなかったり、パスに不正があった場合は[Null]が返されます。
  Future<Map<String, DynamicMap>?> loadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    _addCollectionListener(query);
    await onLoad?.call();
    final trimPath = query.query.path.trimQuery().trimString("/");
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return null;
    }
    final value = _data._readFromPath(paths, 0);
    if (value is! DynamicMap) {
      return null;
    }
    final entries = query.query
        .sort(
          value
              .toList(
                (key, value) {
                  if (value is! Map) {
                    return null;
                  }
                  return MapEntry(
                    key,
                    Map<String, dynamic>.from(value),
                  );
                },
              )
              .where(
                (element) =>
                    element != null && query.query.hasMatchAsMap(element.value),
              )
              .removeEmpty(),
        )
        .sublist(0, query.query.limit);
    _collectionEntries[query] = entries;
    return Map<String, DynamicMap>.fromEntries(entries);
  }

  /// Add/update the data of [value] at the position of [path].
  /// [path]の位置に[value]のデータを追加・更新します。
  ///
  /// Unlike other storage methods, you will not be notified of data updates.
  /// 他の保存用メソッドと違ってデータの更新が通知されることはありません。
  ///
  /// Please use this function when you want to include mock data or other data in advance.
  /// モックデータなど予めデータを入れておきたい場合などにご利用ください。
  void setRawData(String path, DynamicMap value) {
    if (path.isEmpty || value.isEmpty) {
      return;
    }
    path = path.trimQuery().trimString("/");
    final paths = path.split("/");
    if (paths.isEmpty) {
      return;
    }
    if (_registeredRawDataPath.contains(path)) {
      return;
    }
    _registeredRawDataPath.add(path);
    _data._writeToPath(paths, 0, Map.from(value));
  }

  /// Update and add data to [value] by passing [query] and the data in the document corresponding to [query].
  /// [query]を渡して[query]に対応するドキュメントのデータを[value]に更新・追加します。
  ///
  /// When changes are made, notifications are sent to documents and collections already registered for monitoring according to the data in [query].
  /// 変更点があった場合、[query]のデータに応じてすでに監視対象に登録されているドキュメントやコレクションに通知を送信します。
  ///
  /// You can also register a callback for [NoSqlDatabase.onSaved] to add processing such as writing as a file after saving.
  /// また、[NoSqlDatabase.onSaved]のコールバックを登録しておくことで保存後にファイルとして書き出すなどの処理を追加することができます。
  ///
  /// Keys with [value] value of [Null] will be deleted. If all keys are deleted, the document itself will be deleted.
  /// [value]の値に[Null]が入っているキーは削除されます。すべてのキーが削除された場合、ドキュメント自体が削除されます。
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    _addDocumentListener(query);
    final trimPath = query.query.path.trimQuery().trimString("/");
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return;
    }
    value = Map.from(value)..removeWhere((key, value) => value == null);
    if (value.isEmpty) {
      return deleteDocument(query);
    }
    final isAdd = _data._writeToPath(paths, 0, value);
    if (isAdd == null) {
      return;
    }
    notifyDocuments(
      trimPath,
      paths.last,
      value,
      isAdd
          ? ModelUpdateNotificationStatus.added
          : ModelUpdateNotificationStatus.modified,
      query,
    );
    await onSaved?.call();
  }

  /// Deletes the data in the document corresponding to [query] by passing [query].
  /// [query]を渡して[query]に対応するドキュメントのデータを削除します。
  ///
  /// When deleted, a notification is sent to documents and collections already registered for monitoring according to the data in [query].
  /// 削除された場合、[query]のデータに応じてすでに監視対象に登録されているドキュメントやコレクションに通知を送信します。
  ///
  /// You can also register a callback for [NoSqlDatabase.onDeleted] to add processing such as writing out as a file after saving.
  /// また、[NoSqlDatabase.onDeleted]のコールバックを登録しておくことで保存後にファイルとして書き出すなどの処理を追加することができます。
  Future<void> deleteDocument(ModelAdapterDocumentQuery query) async {
    _addDocumentListener(query);
    final trimPath = query.query.path.trimQuery().trimString("/");
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return;
    }
    _data._deleteFromPath(paths, 0);
    notifyDocuments(
      trimPath,
      paths.last,
      {},
      ModelUpdateNotificationStatus.removed,
      query,
    );
    await onDeleted?.call();
  }

  /// Replaces all data in the database inside by giving [replaceData].
  /// [replaceData]を与えることで中のデータベース内のデータをすべて置き換えます。
  ///
  /// It also compares the data to the data before it was replaced and sends notifications to monitored documents and collections when data is deleted, updated, or added.
  /// また置き換える前のデータと比較し、データの削除や更新、追加が起こった場合、監視対象のドキュメントやコレクションに通知を送信します。
  ///
  /// After all data has been replaced, a callback to [NoSqlDatabase.onSaved] can be registered to add a process such as writing the data as a file after saving.
  /// すべてのデータの置き換えが終わったあと、[NoSqlDatabase.onSaved]のコールバックを登録しておくことで保存後にファイルとして書き出すなどの処理を追加することができます。
  Future<void> replace(DynamicMap replaceData) async {
    // ドキュメントリスナーから現在のパスを取得。
    final cache = <String, DynamicMap>{};
    for (final tmp in _documentListeners.entries) {
      final trimPath = tmp.key.trimQuery().trimString("/");
      if (cache.containsKey(trimPath)) {
        continue;
      }
      final paths = trimPath.split("/");
      if (paths.isEmpty) {
        continue;
      }
      final value = _data._readFromPath(paths, 0);
      if (value is! Map) {
        continue;
      }
      cache[trimPath] = value.cast<String, dynamic>();
    }
    // コレクションリスナーから現在のパスを取得。
    for (final tmp in _collectionListeners.entries) {
      final trimPath = tmp.key.trimQuery().trimString("/");
      final paths = trimPath.split("/");
      if (paths.isEmpty) {
        continue;
      }
      final value = _data._readFromPath(paths, 0);
      if (value is! DynamicMap) {
        continue;
      }
      final entries = value.toList(
        (key, value) {
          if (value is! Map) {
            return null;
          }
          return MapEntry(
            key,
            Map<String, dynamic>.from(value),
          );
        },
      ).removeEmpty();
      for (final e in entries) {
        final path = "$trimPath/${e.key}";
        if (cache.containsKey(path)) {
          continue;
        }
        cache[path] = value.cast<String, dynamic>();
      }
    }
    // 置き換え
    _data = replaceData;
    // キャッシュから
    // 以前存在していたもの→存在しなくなった→removed
    // 以前存在していたもの→まだある→modified
    for (final tmp in cache.entries) {
      final trimPath = tmp.key;
      final paths = trimPath.split("/");
      final value = _data._readFromPath(paths, 0);
      if (value is! Map) {
        // Removed.
        notifyDocuments(
          trimPath,
          paths.last,
          {},
          ModelUpdateNotificationStatus.removed,
          ModelAdapterDocumentQuery(query: DocumentModelQuery(trimPath)),
        );
      } else {
        // Modified.
        notifyDocuments(
          trimPath,
          paths.last,
          value.cast<String, dynamic>(),
          ModelUpdateNotificationStatus.modified,
          ModelAdapterDocumentQuery(query: DocumentModelQuery(trimPath)),
        );
      }
    }
    // もう一度コレクションリスナーから現在のパスを取得。
    // 以前存在していなかったもの→存在している→added
    for (final tmp in _collectionListeners.entries) {
      final trimPath = tmp.key.trimQuery().trimString("/");
      final paths = trimPath.split("/");
      if (paths.isEmpty) {
        continue;
      }
      final value = _data._readFromPath(paths, 0);
      if (value is! DynamicMap) {
        continue;
      }
      final entries = value.toList(
        (key, value) {
          if (value is! Map) {
            return null;
          }
          return MapEntry(
            key,
            Map<String, dynamic>.from(value),
          );
        },
      ).removeEmpty();
      for (final e in entries) {
        final path = "$trimPath/${e.key}";
        if (cache.containsKey(path)) {
          continue;
        }
        // Added.
        final paths = path.split("/");
        notifyDocuments(
          path,
          paths.last,
          e.value.cast<String, dynamic>(),
          ModelUpdateNotificationStatus.added,
          ModelAdapterDocumentQuery(query: DocumentModelQuery(path)),
        );
      }
    }
    await onSaved?.call();
  }

  /// Sends notifications to monitored documents and collections based on [documentPath] and [documentId].
  /// [documentPath]と[documentId]を元に監視対象にしたドキュメントやコレクションへ通知を送信します。
  ///
  /// The changed value is passed to [value] and the change status is passed to [status].
  /// 変更後の値を[value]に渡し、変更ステータスを[status]に渡します。
  ///
  /// Pass [ModelAdapterDocumentQuery] passed at the time of modification directly to [query].
  /// 変更時に渡された[ModelAdapterDocumentQuery]を[query]にそのまま渡してください。
  void notifyDocuments(
    String documentPath,
    String documentId,
    DynamicMap value,
    ModelUpdateNotificationStatus status,
    ModelAdapterDocumentQuery query,
  ) {
    final collectionPath = documentPath.parentPath();
    if (_documentListeners.containsKey(documentPath)) {
      _documentListeners[documentPath]?.forEach(
        (element) => element.callback?.call(
          ModelUpdateNotification(
            path: documentPath,
            id: documentId,
            status: status,
            value: Map.from(value),
            origin: query.origin,
          ),
        ),
      );
    }
    if (_collectionListeners.containsKey(collectionPath)) {
      _collectionListeners[collectionPath]?.forEach(
        (element) {
          final entries = _collectionEntries[element] ?? [];
          switch (status) {
            case ModelUpdateNotificationStatus.added:
              if (!element.query.hasMatchAsMap(value)) {
                return;
              }
              final newIndex =
                  element.query.seekIndex(entries, value) ?? entries.length;
              _collectionEntries[element] = entries
                ..insert(newIndex, MapEntry(documentId, value));
              element.callback?.call(
                ModelUpdateNotification(
                  path: documentPath,
                  id: documentId,
                  status: status,
                  value: Map.from(value),
                  origin: query.origin,
                  oldIndex: null,
                  newIndex: newIndex,
                ),
              );
              break;
            case ModelUpdateNotificationStatus.modified:
              if (element.query.hasMatchAsMap(value)) {
                final oldIndex = entries.indexWhere(
                  (e) => e.key.trimQuery().trimString("/") == documentId,
                );

                if (oldIndex < 0) {
                  final newIndex =
                      element.query.seekIndex(entries, value) ?? entries.length;
                  _collectionEntries[element] = entries
                    ..insert(newIndex, MapEntry(documentId, value));
                  element.callback?.call(
                    ModelUpdateNotification(
                      path: documentPath,
                      id: documentId,
                      status: ModelUpdateNotificationStatus.added,
                      value: Map.from(value),
                      origin: query.origin,
                      oldIndex: null,
                      newIndex: newIndex,
                    ),
                  );
                } else {
                  var newIndex =
                      element.query.seekIndex(entries, value) ?? oldIndex;
                  if (oldIndex < newIndex) {
                    newIndex = newIndex - 1;
                  }
                  _collectionEntries[element] = entries
                    ..removeAt(oldIndex)
                    ..insert(newIndex, MapEntry(documentId, value));
                  element.callback?.call(
                    ModelUpdateNotification(
                      path: documentPath,
                      id: documentId,
                      status: status,
                      value: Map.from(value),
                      origin: query.origin,
                      oldIndex: oldIndex < 0 ? null : oldIndex,
                      newIndex: newIndex,
                    ),
                  );
                }
              } else {
                final oldIndex = entries.indexWhere(
                  (e) => e.key.trimQuery().trimString("/") == documentId,
                );
                _collectionEntries[element] = entries..removeAt(oldIndex);
                element.callback?.call(
                  ModelUpdateNotification(
                    path: documentPath,
                    id: documentId,
                    status: ModelUpdateNotificationStatus.removed,
                    value: const {},
                    origin: query.origin,
                    oldIndex: oldIndex < 0 ? null : oldIndex,
                    newIndex: null,
                  ),
                );
              }
              break;
            case ModelUpdateNotificationStatus.removed:
              final oldIndex = entries.indexWhere(
                (e) => e.key.trimQuery().trimString("/") == documentId,
              );
              _collectionEntries[element] = entries..removeAt(oldIndex);
              element.callback?.call(
                ModelUpdateNotification(
                  path: documentPath,
                  id: documentId,
                  status: status,
                  value: const {},
                  origin: query.origin,
                  oldIndex: oldIndex < 0 ? null : oldIndex,
                  newIndex: null,
                ),
              );
              break;
          }
        },
      );
    }
  }
}

extension _NoSqlDatabaseDynamicMapExtensions on Map {
  dynamic _readFromPath(List<String> paths, int index) {
    if (paths.length <= index) {
      return this;
    }
    final p = paths[index];
    if (p.isEmpty) {
      return null;
    }
    final val = this[p];
    if (val is Map) {
      return val._readFromPath(paths, index + 1);
    }
    return val;
  }

  // 返り値が`true`の場合「追加」。`false`の場合「更新」になる
  // データが見つからなかった場合は`null`が返される
  bool? _writeToPath(List<String> paths, int index, dynamic value) {
    final p = paths[index];
    if (p.isEmpty) {
      return null;
    }
    if (paths.length - 1 <= index) {
      final prev = this[p];
      remove(p);
      this[p] = value;
      if (prev is Map) {
        return prev.isEmpty;
      } else {
        return prev == null;
      }
    }
    final val = this[p];
    if (val is! Map) {
      final val = this[p] = <String, dynamic>{};
      return val._writeToPath(paths, index + 1, value);
    } else {
      return val._writeToPath(paths, index + 1, value);
    }
  }

  void _deleteFromPath(List<String> paths, int index) {
    final p = paths[index];
    if (p.isEmpty) {
      return;
    }
    if (paths.length - 1 <= index) {
      remove(p);
      return;
    }
    final val = this[p];
    if (val is! Map) {
      return;
    }
    val._deleteFromPath(paths, index + 1);
  }
}
