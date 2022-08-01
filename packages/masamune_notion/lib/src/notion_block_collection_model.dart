part of masamune_notion;

final notionBlockCollectionProvider =
    ChangeNotifierProvider.family<NotionBlockCollectionModel, String>(
  (_, blockId) => NotionBlockCollectionModel(blockId),
);

class NotionBlockCollectionModel
    extends ValueModel<List<NotionBlockDocumentModel>>
    with ListModelMixin<NotionBlockDocumentModel>
    implements DynamicCollectionModel<NotionBlockDocumentModel> {
  NotionBlockCollectionModel(this.blockId) : super([]);

  final String blockId;
  // ignore: unused_field
  String? _nextCursor;
  int _index = 0;
  FirestoreDynamicDocumentModel? _document;
  FirestoreDynamicCollectionModel? _collection;

  /// It becomes `true` after [loadOnce] is executed.
  bool loaded = false;

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
  Future<NotionBlockCollectionModel> load([bool useCache = true]) async {
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
      final _trimedId = this.blockId.trimQuery();
      final blockId =
          _trimedId.substring(_trimedId.length - 32, _trimedId.length);
      await FirebaseCore.initialize();
      await onLoad();
      _document ??= readProvider(
        firestoreDocumentProvider("${NotionCore._indexPath}/$blockId"),
      );
      await _document?.loadOnce();
      final indexList = _document.getAsList<String>("index").distinct();
      _collection ??= readProvider(
        firestoreCollectionProvider(
          ModelQuery(
            NotionCore._contentPath,
            key: "uid",
            whereIn: indexList,
          ).value,
        ),
      );
      await _collection?.loadOnce();
      clear();
      _index = 0;
      final data = indexList.mapAndRemoveEmpty((uid) {
        final e = _collection.firstWhereOrNull((item) => item.uid == uid);
        if (e == null) {
          return null;
        }
        final doc = NotionBlockDocumentModel(uid, {});
        final type = e.get("type", "");
        if (type == "numbered_list_item") {
          _index = _index + 1;
        } else {
          _index = 0;
        }
        doc.value = doc.fromMap({
          "index": _index,
          ...e,
        });
        return doc;
      });
      addAll(data);
      await onDidLoad();
      if (isNotEmpty) {
        notifyListeners();
        _loadCompleter?.complete();
        _loadCompleter = null;
      }
      final res =
          await functions.httpsCallable(NotionCore._endpoint).call<Map>({
        "type": "block",
        "id": blockId,
        "bucket": NotionCore._cacheBucketName,
        "cachePath": NotionCore._cachePath,
      });
      final map = res.data.cast<String, dynamic>();
      final list = map.getAsList("results").cast<DynamicMap>();
      if (list.isNotEmpty && list.length != length) {
        clear();
        final data = list.mapAndRemoveEmpty((page) {
          final uid = page.get("id", "").replaceAll("-", "");
          if (uid.isEmpty) {
            return null;
          }
          final doc = NotionBlockDocumentModel(uid, {});
          final type = page.get("type", "");
          if (type == "numbered_list_item") {
            _index = _index + 1;
          } else {
            _index = 0;
          }
          doc.value = doc.fromMap({
            "index": _index,
            ...page,
          });
          return doc;
        });
        addAll(data);
        notifyListeners();
      }
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

  /// Reload data and updates the data in the model.
  ///
  /// It is basically the same as the [load] method,
  /// but combining it with [loadOnce] makes it easier to manage the data.
  Future<NotionBlockCollectionModel> reload([bool useCache = true]) =>
      load(useCache);

  /// If the data is empty, [load] is performed only once.
  ///
  /// In other cases, the value is returned as is.
  ///
  /// Use [isEmpty] to determine whether the file is empty or not.
  Future<NotionBlockCollectionModel> loadOnce([bool useCache = true]) async {
    if (!loaded) {
      loaded = true;
      return load(useCache);
    }
    return this;
  }
}
