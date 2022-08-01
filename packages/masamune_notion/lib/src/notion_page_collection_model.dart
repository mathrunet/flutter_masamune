part of masamune_notion;

final notionPageCollectionProvider =
    ChangeNotifierProvider.family<NotionPageCollectionModel, String>(
  (_, databaseId) => NotionPageCollectionModel(databaseId),
);

class NotionPageCollectionModel
    extends ValueModel<List<NotionPageDocumentModel>>
    with ListModelMixin<NotionPageDocumentModel>
    implements DynamicCollectionModel<NotionPageDocumentModel> {
  NotionPageCollectionModel(this.databaseQuery) : super([]);

  final String databaseQuery;
  // ignore: unused_field
  String? _nextCursor;
  List<_NotionPageCollectionModelCache> _cacheList = [];

  /// It becomes `true` after [loadOnce] is executed.
  bool loaded = false;

  bool get canNext {
    return _nextCursor.isNotEmpty;
  }

  @override
  Future<void>? get loading => _loadCompleter?.future;
  Completer<void>? _loadCompleter;

  @override
  Future<void>? get saving => throw UnimplementedError();

  /// Get an instance of Firebase Functions.
  @protected
  FirebaseFunctions get functions {
    return FirebaseFunctions.instanceFor(region: FirebaseCore.region);
  }

  /// If this value is true,
  /// Notify changes when there are changes in the list itself using list-specific methods.
  @override
  bool get notifyOnChangeList => false;

  /// If this value is true,
  /// the change will be notified when [value] itself is changed.
  @override
  bool get notifyOnChangeValue => true;

  /// Callback before the load has been done.
  @protected
  @mustCallSuper
  Future<void> onLoad() async {}

  /// Callback after the load has been done.
  @protected
  @mustCallSuper
  Future<void> onDidLoad() async {}

  /// You can describe the process when you get the [response].
  ///
  /// Describe error handling (throw Exception in case of error), etc.
  @protected
  @mustCallSuper
  @protected
  @mustCallSuper
  void onCatchResponse(HttpsCallableResult<Map> response) {}

  /// Add a process to create a document object.
  @protected
  NotionPageDocumentModel createDocument() {
    throw UnimplementedError();
  }

  /// Create a new document.
  NotionPageDocumentModel create() {
    throw UnimplementedError();
  }

  /// Functions can be called to retrieve the data.
  ///
  /// You can specify the Post data to be called in [parameters].
  Future<NotionPageCollectionModel> load([bool useCache = true]) async {
    if (_loadCompleter != null) {
      await loading;
      return this;
    }
    if (!NotionCore.initialized) {
      throw Exception(
        "Notion settings have not been initialized. Please initialize it by executing [NotionCore.initialize()].",
      );
    }
    _loadCompleter = Completer();
    try {
      if (value.isNotEmpty) {
        _loadCompleter?.complete();
        _loadCompleter = null;
        return this;
      }
      await _loadProcess(useCache: useCache, nextCursor: null);
      _loadCompleter?.complete();
      _loadCompleter = null;
    } catch (e) {
      _loadCompleter?.completeError(e);
      _loadCompleter = null;
      rethrow;
    } finally {
      _loadCompleter?.complete();
      _loadCompleter = null;
    }
    return this;
  }

  Future<NotionPageCollectionModel> next([bool useCache = true]) async {
    if (_loadCompleter != null) {
      await loading;
      return this;
    }
    if (_nextCursor == null) {
      assert(
        _nextCursor != null,
        "If the next cursor is not present, it cannot be read.",
      );
      return this;
    }
    if (!NotionCore.initialized) {
      throw Exception(
        "Notion settings have not been initialized. Please initialize it by executing [NotionCore.initialize()].",
      );
    }
    _loadCompleter = Completer();
    try {
      await _loadProcess(useCache: useCache, nextCursor: _nextCursor);
      _loadCompleter?.complete();
      _loadCompleter = null;
    } catch (e) {
      _loadCompleter?.completeError(e);
      _loadCompleter = null;
      rethrow;
    } finally {
      _loadCompleter?.complete();
      _loadCompleter = null;
    }
    return this;
  }

  Future<void> _loadProcess({
    bool useCache = true,
    String? nextCursor,
  }) async {
    final _query = NotionQuery.fromPath(databaseQuery);
    final limit = _query.limit;
    final databaseId =
        _query.path.substring(_query.path.length - 32, _query.path.length);
    final query = NotionCore._defaultQuery != null
        ? NotionQueryGroup([
            _query,
            NotionCore._defaultQuery!,
          ])
        : _query;
    final queryKey = query.value.toSHA1().replaceAll("/", "") +
        (nextCursor?.replaceAll("-", "") ?? "");
    await FirebaseCore.initialize();
    await onLoad();
    final cache = _fetchCache(nextCursor);
    cache.document ??= readProvider(
      firestoreDocumentProvider("${NotionCore._indexPath}/$queryKey"),
    );
    await cache.document?.loadOnce();
    final indexList = cache.document.getAsList<String>("index").distinct();
    cache.collection ??= readProvider(
      firestoreCollectionProvider(
        ModelQuery(
          NotionCore._contentPath,
          key: "uid",
          whereIn: indexList,
        ).value,
      ),
    );
    await cache.collection?.loadOnce();
    final data = indexList.mapAndRemoveEmpty((uid) {
      final e = cache.collection.firstWhereOrNull((item) => item.uid == uid);
      if (e == null) {
        return null;
      }
      final doc = NotionPageDocumentModel(uid, {});
      doc.value = doc.fromMap(e);
      return doc;
    });
    _addAll(data, cache);
    await onDidLoad();
    if (cache.pageList.isNotEmpty) {
      _nextCursor = cache.document.get("next", nullOfString);
      notifyListeners();
      _loadCompleter?.complete();
      _loadCompleter = null;
    }
    final filter = query.toFilter();
    final res = await functions.httpsCallable(NotionCore._endpoint).call<Map>({
      "type": "database",
      "id": databaseId,
      "key": queryKey,
      "bucket": NotionCore._cacheBucketName,
      "cachePath": NotionCore._cachePath,
      if (nextCursor != null) "next": nextCursor,
      if (limit != null) "limit": limit,
      if (filter != null) "filter": filter,
    });
    final map = res.data.cast<String, dynamic>();
    final list = map.getAsList("results").cast<DynamicMap>();
    if (list.isNotEmpty && cache.pageList.length != list.length) {
      final data = list.mapAndRemoveEmpty((page) {
        final uid = page.get("id", "").replaceAll("-", "");
        if (uid.isEmpty) {
          return null;
        }
        final doc = NotionPageDocumentModel(uid, {});
        doc.value = doc.fromMap(page);
        return doc;
      });
      _addAll(data, cache);
      _nextCursor = map.get("next_cursor", nullOfString);
      notifyListeners();
    }
  }

  _NotionPageCollectionModelCache _fetchCache(String? nextCursor) {
    var cache = _cacheList.firstWhereOrNull((e) => e.nextCursor == nextCursor);
    if (cache != null) {
      return cache;
    }
    cache = _NotionPageCollectionModelCache(nextCursor: nextCursor);
    _cacheList.add(cache);
    return cache;
  }

  void _addAll(
    List<NotionPageDocumentModel> data,
    _NotionPageCollectionModelCache cache,
  ) {
    cache.pageList.clear();
    cache.pageList.addAll(data);
    clear();
    addAll(_cacheList.expand((e) => e.pageList));
  }

  /// Reload data and updates the data in the model.
  ///
  /// It is basically the same as the [load] method,
  /// but combining it with [loadOnce] makes it easier to manage the data.
  Future<NotionPageCollectionModel> reload([bool useCache = true]) =>
      load(useCache);

  /// If the data is empty, [load] is performed only once.
  ///
  /// In other cases, the value is returned as is.
  ///
  /// Use [isEmpty] to determine whether the file is empty or not.
  Future<NotionPageCollectionModel> loadOnce([bool useCache = true]) async {
    if (!loaded) {
      loaded = true;
      return load(useCache);
    }
    return this;
  }
}

class _NotionPageCollectionModelCache {
  _NotionPageCollectionModelCache({
    this.nextCursor,
  });
  final String? nextCursor;
  FirestoreDynamicDocumentModel? document;
  FirestoreDynamicCollectionModel? collection;
  List<NotionPageDocumentModel> pageList = [];
}
