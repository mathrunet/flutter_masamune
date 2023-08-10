part of katana_model;

/// Class for building a NoSql database model within an application.
///
/// It is based on the Firestore model and handles data separately as documents and collections.
///
/// https://firebase.google.com/docs/firestore/data-model
///
/// Use [loadDocument] to read individual data and [loadCollection] to read a collection of data.
///
/// You can pass [ModelAdapterDocumentQuery] on each data read and specify callbacks when data is updated internally.
///
/// This makes it possible to monitor changes that occur elsewhere (or outside the application, such as on the server side) and to handle data in sync with the database.
///
/// Data can be added (updated) and deleted only in documents. Use [saveDocument] and [deleteDocument] respectively.
///
/// Callbacks for [onInitialize], [onLoad], [onSaved], and [onDeleted] can be passed when an object is created, making it possible to add processing that links with external databases, etc. when data is read or saved.
///
/// When a document or collection is destroyed, use [removeDocumentListener] and [removeCollectionListener] to remove each document or collection from the monitoring target.
///
/// アプリケーション内でのNoSqlデータベースモデルを構築するためのクラスです。
///
/// Firestoreのモデルをベースとしており、ドキュメントとコレクションに分けてデータを扱います。
///
/// https://firebase.google.com/docs/firestore/data-model
///
/// 個別のデータの読み取りは[loadDocument]を利用し、まとまったデータの読み取りは[loadCollection]を利用します。
///
/// それぞれのデータ読み取り時に[ModelAdapterDocumentQuery]を渡すことができ、データが内部で更新された場合のコールバックを指定できます。
///
/// これにより他の箇所で起きた（もしくはサーバー側などのアプリ外）変更を監視することが可能になりデータベースと同期したデータを扱うことができます。
///
/// データの追加（更新）、削除はドキュメントのみで行うことが可能です。それぞれ[saveDocument]、[deleteDocument]で行います。
///
/// オブジェクトの作成時に[onInitialize]、[onLoad]、[onSaved]、[onDeleted]のコールバックを渡すことができ、データの読み出し時や保存時などに外部のデータベース等との連携処理を追加することが可能です。
///
/// ドキュメントやコレクションが破棄される際は[removeDocumentListener]、[removeCollectionListener]で各ドキュメントやコレクションを監視対象から外してください。
class NoSqlDatabase {
  /// Class for building a NoSql database model within an application.
  ///
  /// It is based on the Firestore model and handles data separately as documents and collections.
  ///
  /// https://firebase.google.com/docs/firestore/data-model
  ///
  /// Use [loadDocument] to read individual data and [loadCollection] to read a collection of data.
  ///
  /// You can pass [ModelAdapterDocumentQuery] on each data read and specify callbacks when data is updated internally.
  ///
  /// This makes it possible to monitor changes that occur elsewhere (or outside the application, such as on the server side) and to handle data in sync with the database.
  ///
  /// Data can be added (updated) and deleted only in documents. Use [saveDocument] and [deleteDocument] respectively.
  ///
  /// Callbacks for [onInitialize], [onLoad], [onSaved], and [onDeleted] can be passed when an object is created, making it possible to add processing that links with external databases, etc. when data is read or saved.
  ///
  /// When a document or collection is destroyed, use [removeDocumentListener] and [removeCollectionListener] to remove each document or collection from the monitoring target.
  ///
  /// アプリケーション内でのNoSqlデータベースモデルを構築するためのクラスです。
  ///
  /// Firestoreのモデルをベースとしており、ドキュメントとコレクションに分けてデータを扱います。
  ///
  /// https://firebase.google.com/docs/firestore/data-model
  ///
  /// 個別のデータの読み取りは[loadDocument]を利用し、まとまったデータの読み取りは[loadCollection]を利用します。
  ///
  /// それぞれのデータ読み取り時に[ModelAdapterDocumentQuery]を渡すことができ、データが内部で更新された場合のコールバックを指定できます。
  ///
  /// これにより他の箇所で起きた（もしくはサーバー側などのアプリ外）変更を監視することが可能になりデータベースと同期したデータを扱うことができます。
  ///
  /// データの追加（更新）、削除はドキュメントのみで行うことが可能です。それぞれ[saveDocument]、[deleteDocument]で行います。
  ///
  /// オブジェクトの作成時に[onInitialize]、[onLoad]、[onSaved]、[onDeleted]のコールバックを渡すことができ、データの読み出し時や保存時などに外部のデータベース等との連携処理を追加することが可能です。
  ///
  /// ドキュメントやコレクションが破棄される際は[removeDocumentListener]、[removeCollectionListener]で各ドキュメントやコレクションを監視対象から外してください。
  NoSqlDatabase({
    this.onInitialize,
    this.onLoad,
    this.onSaved,
    this.onDeleted,
  });

  /// Location where real data is stored.
  ///
  /// If you rewrite this section, the entire database will be rewritten.
  ///
  /// 実データが格納されている場所。
  ///
  /// ここを書き換えるとデータベースがすべて書き変わります。
  DynamicMap data = {};

  /// Executed at Database initialization time.
  ///
  /// Databaseの初期化時に実行されます。
  final Future<void> Function(NoSqlDatabase database)? onInitialize;

  /// Executed when saving the Database.
  ///
  /// Databaseの保存時に実行されます。
  final Future<void> Function(NoSqlDatabase database)? onSaved;

  /// Executed when loading Database.
  ///
  /// Databaseの読み込み時に実行されます。
  final Future<void> Function(NoSqlDatabase database)? onLoad;

  /// Executed when Database is deleted.
  ///
  /// Databaseの削除時に実行されます。
  final Future<void> Function(NoSqlDatabase database)? onDeleted;

  bool _initialized = false;
  Completer<void>? _completer;
  final Map<String, DynamicMap> _registeredInitialValue = {};
  final Map<String, Map<Object?, ModelAdapterDocumentQuery>>
      _documentListeners = {};
  final Map<String, Map<Object?, ModelAdapterCollectionQuery>>
      _collectionListeners = {};
  final Map<Object?, List<MapEntry<String, DynamicMap>>> _collectionEntries =
      {};

  String _path(String original, String? prefix) {
    if (prefix.isEmpty) {
      return original;
    }
    final p = prefix!.trimQuery().trimString("/");
    final o = original.trimQuery().trimString("/");
    return "$p/$o";
  }

  Future<void> _initialize() async {
    if (_completer != null) {
      return _completer?.future;
    }
    if (_initialized) {
      return;
    }
    _completer = Completer();
    try {
      _initialized = true;
      await onInitialize?.call(this);
      _applyRawData();
      _completer?.complete();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  void _addDocumentListener(
    ModelAdapterDocumentQuery query, {
    String? prefix,
  }) {
    final trimPath = _path(query.query.path, prefix);
    if (_documentListeners.containsKey(trimPath)) {
      final listener = _documentListeners[trimPath]!;
      if (listener.containsKey(query.origin)) {
        return;
      }
      listener[query.origin] = query;
    } else {
      _documentListeners[trimPath] = {query.origin: query};
    }
  }

  void _addCollectionListener(
    ModelAdapterCollectionQuery query, {
    String? prefix,
  }) {
    final trimPath = _path(query.query.path, prefix);
    if (_collectionListeners.containsKey(trimPath)) {
      final listener = _collectionListeners[trimPath]!;
      if (listener.containsKey(query.origin)) {
        return;
      }
      listener[query.origin] = query;
    } else {
      _collectionListeners[trimPath] = {query.origin: query};
    }
  }

  /// Pass [query] to remove the document corresponding to [query] from the monitored list.
  ///
  /// [prefix] can be specified to prefix the path.
  ///
  /// [query]を渡して[query]に対応するドキュメントを監視対象から外します。
  ///
  /// [prefix]を指定するとパスにプレフィックスを付与可能です。
  void removeDocumentListener(
    ModelAdapterDocumentQuery? query, {
    String? prefix,
  }) {
    if (query == null) {
      return;
    }
    final trimPath = _path(query.query.path, prefix);
    if (_documentListeners.containsKey(trimPath)) {
      _documentListeners[trimPath]!.remove(query.origin);
    }
  }

  /// Pass [query] to remove the collection corresponding to [query] from the monitored list.
  ///
  /// [prefix] can be specified to prefix the path.
  ///
  /// [query]を渡して[query]に対応するコレクションを監視対象から外します。
  ///
  /// [prefix]を指定するとパスにプレフィックスを付与可能です。
  void removeCollectionListener(
    ModelAdapterCollectionQuery? query, {
    String? prefix,
  }) {
    if (query == null) {
      return;
    }
    final trimPath = _path(query.query.path, prefix);
    if (_collectionListeners.containsKey(trimPath)) {
      _collectionListeners[trimPath]!.remove(query.origin);
    }
  }

  /// Pass [query] and load the document corresponding to [query].
  ///
  /// If data is found, it is returned in [DynamicMap].
  ///
  /// If no data is found or the path is invalid, [Null] is returned.
  ///
  /// [prefix] can be specified to prefix the path.
  ///
  /// If [onLoad] is specified, it is executed when data is loaded after initialization.
  ///
  /// [query]を渡して[query]に対応するドキュメントを読み込みます。
  ///
  /// データが見つかった場合は[DynamicMap]で返されます。
  ///
  /// データが見つからなかったり、パスに不正があった場合は[Null]が返されます。
  ///
  /// [prefix]を指定するとパスにプレフィックスを付与可能です。
  ///
  /// [onLoad]を指定すると初期化後にデータを読み込む際に実行されます。
  Future<DynamicMap?> loadDocument(
    ModelAdapterDocumentQuery query, {
    String? prefix,
    Future<void> Function(NoSqlDatabase)? onLoad,
  }) async {
    _addDocumentListener(query, prefix: prefix);
    await _initialize();
    await this.onLoad?.call(this);
    await onLoad?.call(this);
    final trimPath = _path(query.query.path, prefix);
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return null;
    }
    final value = data._readFromPath(paths, 0);
    if (value is! Map) {
      return null;
    }
    return Map<String, dynamic>.from(value);
  }

  /// Stores [value] in the path corresponding to [query] and then returns [value].
  ///
  /// Used to synchronize [NoSqlDatabase] with other databases.
  ///
  /// [prefix] can be specified to prefix the path.
  ///
  /// [query]に対応するパスに[value]を格納してから[value]を返します。
  ///
  /// 他のデータベースと[NoSqlDatabase]を同期するために利用します。
  ///
  /// [prefix]を指定するとパスにプレフィックスを付与可能です。
  Future<DynamicMap?> syncDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap? value, {
    String? prefix,
  }) async {
    _addDocumentListener(query, prefix: prefix);
    await _initialize();
    final trimPath = _path(query.query.path, prefix);
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return value;
    }
    value = Map.from(value ?? {})..removeWhere((key, value) => value == null);
    if (value.isEmpty) {
      data._deleteFromPath(paths, 0);
      onDeleted?.call(this);
      return null;
    }
    data._writeToPath(paths, 0, value);
    await onSaved?.call(this);
    return value;
  }

  /// Load the document corresponding to [query] from [_registeredInitialValue].
  ///
  /// If data is found, it is returned in [DynamicMap].
  ///
  /// If no data is found or the path is invalid, [Null] is returned.
  ///
  /// [prefix] can be specified to prefix the path.
  ///
  /// [_registeredInitialValue]から[query]に対応するドキュメントを読み込みます。
  ///
  /// データが見つかった場合は[DynamicMap]で返されます。
  ///
  /// データが見つからなかったり、パスに不正があった場合は[Null]が返されます。
  ///
  /// [prefix]を指定するとパスにプレフィックスを付与可能です。
  Future<DynamicMap?> getInitialDocument(
    ModelAdapterDocumentQuery query, {
    String? prefix,
  }) async {
    _addDocumentListener(query, prefix: prefix);
    await _initialize();
    await onLoad?.call(this);
    final trimPath = _path(query.query.path, prefix);
    if (_registeredInitialValue.containsKey(trimPath)) {
      return Map<String, dynamic>.from(_registeredInitialValue[trimPath] ?? {});
    }
    return null;
  }

  /// Pass [query] and load the collection corresponding to [query].
  ///
  /// If data is found, it will be returned in [Map<String, DynamicMap>].
  ///
  /// [String] contains the ID of each document (if the path is `aaaaa/bbbbb/cccc/ddddd`, the ID is `ddddd`).
  ///
  /// If no data is found or the path is invalid, [Null] is returned.
  ///
  /// [prefix] can be specified to prefix the path.
  ///
  /// If [onLoad] is specified, it is executed when data is loaded after initialization.
  ///
  /// [query]を渡して[query]に対応するコレクションを読み込みます。
  ///
  /// データが見つかった場合は[Map<String, DynamicMap>]で返されます。
  ///
  /// [String]にはそれぞれのドキュメントのID（パスが`aaaa/bbbb/cccc/dddd`の場合IDは`dddd`になります）が含まれています。
  ///
  /// データが見つからなかったり、パスに不正があった場合は[Null]が返されます。
  ///
  /// [prefix]を指定するとパスにプレフィックスを付与可能です。
  ///
  /// [onLoad]を指定すると初期化後にデータを読み込む際に実行されます。
  Future<Map<String, DynamicMap>?> loadCollection(
    ModelAdapterCollectionQuery query, {
    String? prefix,
    Future<void> Function(NoSqlDatabase)? onLoad,
  }) async {
    _addCollectionListener(query, prefix: prefix);
    await _initialize();
    await this.onLoad?.call(this);
    await onLoad?.call(this);
    final trimPath = _path(query.query.path, prefix);
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return null;
    }
    final value = data._readFromPath(paths, 0);
    if (value is! DynamicMap) {
      return null;
    }
    final limitValue = query.query.filters
        .firstWhereOrNull((e) => e.type == ModelQueryFilterType.limit)
        ?.value as int?;
    final entries = query.query.sort(
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
    );
    final limited = entries.sublist(
      0,
      limitValue != null ? min(limitValue, entries.length) : null,
    );
    _collectionEntries[query.origin] = List.from(limited);
    return Map<String, DynamicMap>.fromEntries(limited);
  }

  /// Stores [value] in the path corresponding to [query] and then returns [value].
  ///
  /// Used to synchronize [NoSqlDatabase] with other databases.
  /// (Strictly speaking, the given value is stocked, not synchronized.)
  ///
  /// [prefix] can be specified to prefix the path.
  ///
  /// [query]に対応するパスに[value]を格納してから[value]を返します。
  ///
  /// 他のデータベースと[NoSqlDatabase]を同期するために利用します。
  /// （厳密には同期ではなく与えられた値をストックしていきます。）
  ///
  /// [prefix]を指定するとパスにプレフィックスを付与可能です。
  Future<Map<String, DynamicMap>?> syncCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap>? value, {
    String? prefix,
  }) async {
    _addCollectionListener(query, prefix: prefix);
    await _initialize();
    final trimPath = _path(query.query.path, prefix);
    final paths = trimPath.split("/");
    if (paths.isEmpty || value == null) {
      return value;
    }
    for (final tmp in value.entries) {
      final key = tmp.key;
      final val = Map<String, dynamic>.from(tmp.value);
      data._writeToPath([...paths, key], 0, val);
    }
    final limitValue = query.query.filters
        .firstWhereOrNull((e) => e.type == ModelQueryFilterType.limit)
        ?.value as int?;
    final entries = query.query.sort(
      value
          .toList(
            (key, value) {
              // ignore: unnecessary_type_check
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
    );
    final limited = entries.sublist(
      0,
      limitValue != null ? min(limitValue, entries.length) : null,
    );
    _collectionEntries[query.origin] = List.from(limited);
    await onSaved?.call(this);
    return value;
  }

  /// Load the document corresponding to [query] from [_registeredInitialValue].
  ///
  /// If data is found, it is returned in [DynamicMap].
  ///
  /// If no data is found or the path is invalid, [Null] is returned.
  ///
  /// [prefix] can be specified to prefix the path.
  ///
  /// [_registeredInitialValue]から[query]に対応するドキュメントを読み込みます。
  ///
  /// データが見つかった場合は[DynamicMap]で返されます。
  ///
  /// データが見つからなかったり、パスに不正があった場合は[Null]が返されます。
  ///
  /// [prefix]を指定するとパスにプレフィックスを付与可能です。
  Future<Map<String, DynamicMap>?> getInitialCollection(
    ModelAdapterCollectionQuery query, {
    String? prefix,
  }) async {
    _addCollectionListener(query, prefix: prefix);
    await _initialize();
    await onLoad?.call(this);
    final trimPath = _path(query.query.path, prefix);
    final res = <String, DynamicMap>{};
    for (final entry in _registeredInitialValue.entries) {
      final parentPath = entry.key.parentPath().trimString("/");
      if (parentPath != trimPath) {
        continue;
      }
      final id = entry.key.last();
      final value = entry.value;
      res[id] = Map<String, dynamic>.from(value);
    }
    if (res.isEmpty) {
      return null;
    }
    return res;
  }

  /// Add/update the data of [value] at the position of [path].
  ///
  /// Unlike other storage methods, you will not be notified of data updates.
  ///
  /// Also, actual data is written after [_initialize] is executed.
  ///
  /// Please use this function when you want to include mock data or other data in advance.
  ///
  /// [path]の位置に[value]のデータを追加・更新します。
  ///
  /// 他の保存用メソッドと違ってデータの更新が通知されることはありません。
  ///
  /// また、[_initialize]実行後に実際のデータが書き込まれます。
  ///
  /// モックデータなど予めデータを入れておきたい場合などにご利用ください。
  void setInitialValue(String path, DynamicMap value) {
    if (path.isEmpty || value.isEmpty) {
      return;
    }
    path = path.trimQuery().trimString("/");
    final paths = path.split("/");
    if (paths.isEmpty) {
      return;
    }
    if (_registeredInitialValue.containsKey(path)) {
      return;
    }
    _registeredInitialValue[path] = value;
  }

  /// Returns `true` if data is registered with [setInitialValue].
  ///
  /// [setInitialValue]でデータが登録されている場合は`true`を返します。
  bool get isInitialValueRegistered => _registeredInitialValue.isNotEmpty;

  void _applyRawData() {
    if (_registeredInitialValue.isEmpty) {
      return;
    }
    for (final tmp in _registeredInitialValue.entries) {
      final path = tmp.key;
      final value = tmp.value;
      final paths = path.split("/");
      if (paths.isEmpty) {
        continue;
      }
      data._writeToPath(paths, 0, Map.from(value));
    }
  }

  /// Update and add data to [value] by passing [query] and the data in the document corresponding to [query].
  ///
  /// When changes are made, notifications are sent to documents and collections already registered for monitoring according to the data in [query].
  ///
  /// You can also register a callback for [NoSqlDatabase.onSaved] to add processing such as writing as a file after saving.
  ///
  /// Keys with [value] value of [Null] will be deleted. If all keys are deleted, the document itself will be deleted.
  ///
  /// [prefix] can be specified to prefix the path.
  ///
  /// [query]を渡して[query]に対応するドキュメントのデータを[value]に更新・追加します。
  ///
  /// 変更点があった場合、[query]のデータに応じてすでに監視対象に登録されているドキュメントやコレクションに通知を送信します。
  ///
  /// また、[NoSqlDatabase.onSaved]のコールバックを登録しておくことで保存後にファイルとして書き出すなどの処理を追加することができます。
  ///
  /// [value]の値に[Null]が入っているキーは削除されます。すべてのキーが削除された場合、ドキュメント自体が削除されます。
  ///
  /// [prefix]を指定するとパスにプレフィックスを付与可能です。
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value, {
    String? prefix,
  }) async {
    _addDocumentListener(query, prefix: prefix);
    await _initialize();
    final trimPath = _path(query.query.path, prefix);
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return;
    }
    value = Map.from(value)..removeWhere((key, value) => value == null);
    if (value.isEmpty) {
      return deleteDocument(query, prefix: prefix);
    }
    final isAdd = data._writeToPath(paths, 0, value);
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
    await onSaved?.call(this);
  }

  /// Deletes the data in the document corresponding to [query] by passing [query].
  ///
  /// When deleted, a notification is sent to documents and collections already registered for monitoring according to the data in [query].
  ///
  /// You can also register a callback for [NoSqlDatabase.onDeleted] to add processing such as writing out as a file after saving.
  ///
  /// [prefix] can be specified to prefix the path.
  ///
  /// [query]を渡して[query]に対応するドキュメントのデータを削除します。
  ///
  /// 削除された場合、[query]のデータに応じてすでに監視対象に登録されているドキュメントやコレクションに通知を送信します。
  ///
  /// また、[NoSqlDatabase.onDeleted]のコールバックを登録しておくことで保存後にファイルとして書き出すなどの処理を追加することができます。
  ///
  /// [prefix]を指定するとパスにプレフィックスを付与可能です。
  Future<void> deleteDocument(
    ModelAdapterDocumentQuery query, {
    String? prefix,
  }) async {
    _addDocumentListener(query, prefix: prefix);
    await _initialize();
    final trimPath = _path(query.query.path, prefix);
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return;
    }
    data._deleteFromPath(paths, 0);
    notifyDocuments(
      trimPath,
      paths.last,
      {},
      ModelUpdateNotificationStatus.removed,
      query,
    );
    await onDeleted?.call(this);
  }

  /// Replaces all data in the database inside by giving [replaceData].
  ///
  /// It also compares the data to the data before it was replaced and sends notifications to monitored documents and collections when data is deleted, updated, or added.
  ///
  /// After all data has been replaced, a callback to [NoSqlDatabase.onSaved] can be registered to add a process such as writing the data as a file after saving.
  ///
  /// [replaceData]を与えることで中のデータベース内のデータをすべて置き換えます。
  ///
  /// また置き換える前のデータと比較し、データの削除や更新、追加が起こった場合、監視対象のドキュメントやコレクションに通知を送信します。
  ///
  /// すべてのデータの置き換えが終わったあと、[NoSqlDatabase.onSaved]のコールバックを登録しておくことで保存後にファイルとして書き出すなどの処理を追加することができます。
  Future<void> replace(DynamicMap replaceData) async {
    await _initialize();
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
      final value = data._readFromPath(paths, 0);
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
      final value = data._readFromPath(paths, 0);
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
    data = replaceData;
    // キャッシュから
    // 以前存在していたもの→存在しなくなった→removed
    // 以前存在していたもの→まだある→modified
    for (final tmp in cache.entries) {
      final trimPath = tmp.key;
      final paths = trimPath.split("/");
      final value = data._readFromPath(paths, 0);
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
      final value = data._readFromPath(paths, 0);
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
    await onSaved?.call(this);
  }

  /// Sends notifications to monitored documents and collections based on [documentPath] and [documentId].
  ///
  /// The changed value is passed to [value] and the change status is passed to [status].
  ///
  /// Pass [ModelAdapterDocumentQuery] passed at the time of modification directly to [query].
  ///
  /// [documentPath]と[documentId]を元に監視対象にしたドキュメントやコレクションへ通知を送信します。
  ///
  /// 変更後の値を[value]に渡し、変更ステータスを[status]に渡します。
  ///
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
      for (final element in _documentListeners[documentPath]?.values ??
          <ModelAdapterDocumentQuery>[]) {
        element.callback?.call(
          ModelUpdateNotification(
            path: documentPath,
            id: documentId,
            status: status,
            value: Map.from(value),
            origin: query.origin,
            listen: query.listen,
            query: element.query,
          ),
        );
      }
    }
    if (_collectionListeners.containsKey(collectionPath)) {
      for (final element in _collectionListeners[collectionPath]?.values ??
          <ModelAdapterCollectionQuery>[]) {
        final entries = _collectionEntries[element.origin] ?? [];
        switch (status) {
          case ModelUpdateNotificationStatus.added:
            if (!element.query.hasMatchAsMap(value)) {
              continue;
            }
            final newIndex =
                element.query.seekIndex(entries, value) ?? entries.length;
            _collectionEntries[element.origin] = entries
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
                listen: query.listen,
                query: element.query,
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
                _collectionEntries[element.origin] = entries
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
                    listen: query.listen,
                    query: element.query,
                  ),
                );
              } else {
                var newIndex =
                    element.query.seekIndex(entries, value) ?? oldIndex;
                if (oldIndex < newIndex) {
                  newIndex = newIndex - 1;
                }
                _collectionEntries[element.origin] = entries
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
                    listen: query.listen,
                    query: element.query,
                  ),
                );
              }
            } else {
              final oldIndex = entries.indexWhere(
                (e) => e.key.trimQuery().trimString("/") == documentId,
              );
              if (oldIndex >= 0) {
                _collectionEntries[element.origin] = entries
                  ..removeAt(oldIndex);
                element.callback?.call(
                  ModelUpdateNotification(
                    path: documentPath,
                    id: documentId,
                    status: ModelUpdateNotificationStatus.removed,
                    value: const {},
                    origin: query.origin,
                    oldIndex: oldIndex < 0 ? null : oldIndex,
                    newIndex: null,
                    listen: query.listen,
                    query: element.query,
                  ),
                );
              }
            }
            break;
          case ModelUpdateNotificationStatus.removed:
            final oldIndex = entries.indexWhere(
              (e) => e.key.trimQuery().trimString("/") == documentId,
            );
            if (oldIndex >= 0) {
              _collectionEntries[element.origin] = entries..removeAt(oldIndex);
              element.callback?.call(
                ModelUpdateNotification(
                  path: documentPath,
                  id: documentId,
                  status: status,
                  value: const {},
                  origin: query.origin,
                  oldIndex: oldIndex < 0 ? null : oldIndex,
                  newIndex: null,
                  listen: query.listen,
                  query: element.query,
                ),
              );
            }
            break;
        }
      }
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
