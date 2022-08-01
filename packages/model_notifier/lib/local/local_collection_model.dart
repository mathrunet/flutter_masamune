part of model_notifier;

/// Base class for holding and manipulating data from a local database as a collection of [LocalDocumentModel].
///
/// The [load()] method retrieves the value from the local database and
/// the [save()] method saves the value to the local database.
///
/// The local database is a Json database.
/// Specify a path to specify the location of the contents.
///
/// In addition, since it can be used as [List],
/// it is possible to operate the content as it is.
abstract class LocalCollectionModel<T extends LocalDocumentModel>
    extends ListModel<T>
    implements StoredModel<List<T>, LocalCollectionModel<T>> {
  /// Base class for holding and manipulating data from a local database as a collection of [LocalDocumentModel].
  ///
  /// The [load()] method retrieves the value from the local database and
  /// the [save()] method saves the value to the local database.
  ///
  /// The local database is a Json database.
  /// Specify a path to specify the location of the contents.
  ///
  /// In addition, since it can be used as [List],
  /// it is possible to operate the content as it is.
  LocalCollectionModel(String path, [List<T>? value])
      : assert(
          !(path.splitLength() <= 0 || path.splitLength() % 2 != 1),
          "The path hierarchy must be an odd number: $path",
        ),
        _rawPath = path,
        path = path.trimQuery(),
        parameters = _getParameters(path),
        super(value ?? []);

  static Map<String, String> _getParameters(String path) {
    if (path.contains("?")) {
      return Uri.parse(path).queryParameters;
    }
    return const {};
  }

  /// Discards any resources used by the object.
  /// After this is called, the object is not in a usable state and should be discarded (calls to [addListener] and [removeListener] will throw after the object is disposed).
  ///
  /// This method should only be called by the object's owner.
  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    _nextCount = 1;
    LocalDatabase._db.removeCollectionListener(_query);
  }

  LocalStoreCollectionQuery? _query;
  int _nextCount = 1;
  final List<T> _rawValues = [];
  List<MapEntry<String, Map<String, dynamic>>> _rawEntries = [];

  /// If this value is true,
  /// Notify changes when there are changes in the list itself using list-specific methods.
  @override
  bool get notifyOnChangeList => false;

  /// If this value is true,
  /// the change will be notified when [value] itself is changed.
  @override
  bool get notifyOnChangeValue => true;

  /// If it is `true`,
  /// the collection itself will be notified if the content of the document has changed.
  ///
  /// The initial value is `false`,
  /// but it can be set to `true` by executing [setNotifyOnModified].
  bool get notifyOnModified => _notifyOnModified;
  // ignore: prefer_final_fields
  bool _notifyOnModified = false;

  /// If [notify] is set to `true`,
  /// the collection will be notified of changes to the document.
  void setNotifyOnModified(bool notify) {
    _notifyOnModified = notify;
  }

  /// Path of the local database.
  final String path;
  final String _rawPath;

  /// Parameters of the local database.
  final Map<String, String> parameters;

  /// True if filtering by [ModelQuery] is enabled.
  @protected
  bool get enableQueryFilter => true;

  /// Returns itself after the load finishes.
  @override
  Future<void>? get loading => _loadCompleter?.future;
  Completer<void>? _loadCompleter;

  /// Returns itself after the save/delete finishes.
  @override
  Future<void>? get saving => _saveCompleter?.future;
  Completer<void>? _saveCompleter;

  /// It becomes `true` after [loadOnce] is executed.
  @override
  bool loaded = false;

  /// Callback before the load has been done.
  @override
  @protected
  @mustCallSuper
  Future<void> onLoad() async {}

  /// Callback after the load has been done.
  @override
  @protected
  @mustCallSuper
  Future<void> onDidLoad() async {}

  /// Callback after the load has been done.
  @override
  @protected
  @mustCallSuper
  Future<void> onSave() async => throw UnimplementedError(
        "Save process should be done for each document.",
      );

  /// Callback after the save has been done.
  @override
  @protected
  @mustCallSuper
  Future<void> onDidSave() async => throw UnimplementedError(
        "Save process should be done for each document.",
      );

  /// Callback before the delete has been done.
  @protected
  @mustCallSuper
  Future<void> onDelete() async {}

  /// Callback after the delete has been done.
  @protected
  @mustCallSuper
  Future<void> onDidDelete() async {}

  /// Callback before the append has been done.
  @protected
  @mustCallSuper
  Future<void> onAppend() async {}

  /// Callback after the append has been done.
  @protected
  @mustCallSuper
  Future<void> onDidAppend() async {}

  /// Filters the given [data].
  ///
  /// If it returns `true`, the data will be included.
  @protected
  bool filter(DynamicMap data) => true;

  /// Add a process to create a document object.
  @protected
  T createDocument(String path);

  /// Create a new document.
  ///
  /// [id] is the ID of the document. If it is blank, [uuid] is used.
  T create([String? id]) =>
      createDocument("${path.trimQuery()}/${id.isEmpty ? uuid : id}");

  /// Retrieves data and updates the data in the model.
  ///
  /// You will be notified of model updates at the time they are retrieved.
  ///
  /// In addition,
  /// the updated [Resuult] can be obtained at the stage where the loading is finished.
  @override
  Future<LocalCollectionModel<T>> load() async {
    if (_loadCompleter != null) {
      await loading;
      return this;
    }
    _loadCompleter = Completer<void>();
    try {
      await onLoad();
      bool notify = false;
      _query ??= LocalStoreCollectionQuery(
        path: path,
        callback: _handledOnUpdate,
        filter: parameters.isEmpty || !enableQueryFilter
            ? null
            : (data) => ModelQuery._filter(parameters, data),
        origin: this,
      );
      LocalDatabase._db.addCollectionListener(_query!);
      final data = await LocalDatabase._db.loadCollection(_query!);
      if (isNotEmpty) {
        clear();
        notify = true;
      }
      if (data.isNotEmpty) {
        notify = true;
        _rawEntries = ModelQuery._sort(
          parameters,
          List.from(data!.entries),
        );
        _rawValues.clear();
        for (final tmp in _rawEntries) {
          if (tmp.key.isEmpty) {
            continue;
          }
          if (!filter(tmp.value)) {
            continue;
          }
          final value = createDocument("${path.trimQuery()}/${tmp.key}");
          value.value = value.fromMap(
            value.filterOnLoad(Map<String, dynamic>.from(tmp.value)),
          );
          _rawValues.add(value);
        }
        final limit = ModelQuery.limitCountFrom(parameters);
        addAll(
          limit != null
              ? _rawValues.sublist(0, limit * _nextCount)
              : _rawValues,
        );
      }
      if (notify) {
        notifyListeners();
      }
      await onDidLoad();
      _loadCompleter?.complete();
      _loadCompleter = null;
    } catch (e) {
      _loadCompleter?.completeError(e);
      _loadCompleter = null;
    } finally {
      _loadCompleter?.complete();
      _loadCompleter = null;
    }
    return this;
  }

  void _handledOnUpdate(LocalStoreDocumentUpdate update) {
    final limit = ModelQuery.limitCountFrom(parameters);
    final oldPos = _rawEntries.indexWhere(
      (element) => element.key == update.id,
    );
    switch (update.status) {
      case LocalStoreDocumentUpdateStatus.deleted:
        if (oldPos >= 0) {
          _deleteOnUpdate(oldPos, update, limit);
        }
        break;
      default:
        if (oldPos >= 0) {
          if (_query?.filter != null) {
            if (_query!.filter!.call(update.value)) {
              _modifyOnUpdate(oldPos, update, limit);
            } else {
              _deleteOnUpdate(oldPos, update, limit);
            }
          } else {
            _modifyOnUpdate(oldPos, update, limit);
          }
        } else {
          if (_query?.filter != null) {
            if (_query!.filter!.call(update.value)) {
              _addOnUpdate(update, limit);
            }
          } else {
            _addOnUpdate(update, limit);
          }
        }
        break;
    }
  }

  void _deleteOnUpdate(
    int oldPos,
    LocalStoreDocumentUpdate update,
    int? limit,
  ) {
    _rawValues.removeAt(oldPos);
    _rawEntries.removeAt(oldPos);
    clear();
    addAll(
      limit != null ? _rawValues.sublist(0, limit * _nextCount) : _rawValues,
    );
    notifyListeners();
  }

  void _modifyOnUpdate(
    int oldPos,
    LocalStoreDocumentUpdate update,
    int? limit,
  ) {
    bool notify = false;
    final pos =
        ModelQuery._seek(parameters, _rawEntries, update.value) ?? oldPos;
    if (pos == oldPos) {
      final entry = _rawEntries[oldPos];
      _rawEntries[pos] = MapEntry(
        entry.key,
        Map<String, dynamic>.from(update.value),
      );
      final val = _rawValues[oldPos];
      val.value = val.fromMap(val.filterOnLoad(update.value));
      _rawValues[pos] = val;
    } else if (pos < oldPos) {
      final entry = _rawEntries.removeAt(oldPos);
      _rawEntries.insert(
        pos,
        MapEntry(entry.key, Map<String, dynamic>.from(update.value)),
      );
      final val = _rawValues.removeAt(oldPos);
      val.value = val.fromMap(val.filterOnLoad(update.value));
      _rawValues.insert(pos, val);
      notify = true;
    } else {
      final entry = _rawEntries.removeAt(oldPos);
      _rawEntries.insert(
        pos - 1,
        MapEntry(entry.key, Map<String, dynamic>.from(update.value)),
      );
      final val = _rawValues.removeAt(oldPos);
      val.value = val.fromMap(val.filterOnLoad(update.value));
      _rawValues.insert(pos - 1, val);
      notify = true;
    }
    if (notify) {
      clear();
      addAll(
        limit != null ? _rawValues.sublist(0, limit * _nextCount) : _rawValues,
      );
      notifyListeners();
    }
  }

  void _addOnUpdate(LocalStoreDocumentUpdate update, int? limit) {
    final val = createDocument("${path.trimQuery()}/${update.id}");
    final pos = ModelQuery._seek(parameters, _rawEntries, update.value);
    if (pos == null || (_rawEntries.length <= pos)) {
      _rawEntries.add(
        MapEntry(update.id, Map<String, dynamic>.from(update.value)),
      );
      val.value = val.fromMap(val.filterOnLoad(update.value));
      _rawValues.add(val);
    } else {
      _rawEntries.insert(
        pos,
        MapEntry(update.id, Map<String, dynamic>.from(update.value)),
      );
      val.value = val.fromMap(val.filterOnLoad(update.value));
      _rawValues.insert(pos, val);
    }
    clear();
    addAll(
      limit != null ? _rawValues.sublist(0, limit * _nextCount) : _rawValues,
    );
    notifyListeners();
  }

  /// Data stored in the model is stored in a database external to the app that is tied to the model.
  ///
  /// The updated [Resuult] can be obtained at the stage where the loading is finished.
  @override
  Future<LocalCollectionModel<T>> save() async {
    throw UnimplementedError("Save process should be done for each document.");
  }

  /// Reload data and updates the data in the model.
  ///
  /// It is basically the same as the [load] method,
  /// but combining it with [loadOnce] makes it easier to manage the data.
  @override
  Future<LocalCollectionModel<T>> reload() async {
    clear();
    await load();
    return this;
  }

  /// Load the data on the next page.
  ///
  /// If there is no data, [load()] is executed.
  Future<LocalCollectionModel<T>> next() async {
    if (!canNext) {
      return this;
    }
    final prevLength = length;
    clear();
    _nextCount = _nextCount + 1;
    await load();
    if (prevLength == length) {
      _nextCount = _nextCount - 1;
    }
    return this;
  }

  /// Returns True if the following reads are possible
  ///
  /// Returns False if no data has been read yet and no limit has been set.
  bool get canNext {
    if (isEmpty) {
      return false;
    }
    final limit = ModelQuery.limitCountFrom(parameters);
    if (limit == null) {
      return false;
    }
    return length >= limit * _nextCount;
  }

  /// If the data is empty, [load] is performed only once.
  ///
  /// In other cases, the value is returned as is.
  ///
  /// Use [isEmpty] to determine whether the file is empty or not.
  @override
  Future<LocalCollectionModel<T>> loadOnce() async {
    if (!loaded) {
      loaded = true;
      return load();
    }
    return this;
  }

  /// Remove elements in the collection that are `true` in [test].
  Future<void> delete(bool Function(T value) test) async {
    if (_saveCompleter != null) {
      await saving;
      return;
    }
    _saveCompleter = Completer<void>();
    try {
      await onDelete();
      await Future.wait(
        mapAndRemoveEmpty((item) {
          if (!test.call(item)) {
            return null;
          }
          return item.delete();
        }),
      );
      await onDidDelete();
      _saveCompleter?.complete();
      _saveCompleter = null;
    } catch (e) {
      _saveCompleter?.completeError(e);
      _saveCompleter = null;
    } finally {
      _saveCompleter?.complete();
      _saveCompleter = null;
    }
  }

  /// Add a new document to the current collection based on [uid].
  ///
  /// It is possible to specify data to be added to the document by giving [data].
  Future<void> append(
    String uid, {
    DynamicMap data = const {},
  }) async {
    if (_saveCompleter != null) {
      await saving;
      return;
    }
    _saveCompleter = Completer<void>();
    try {
      await onAppend();
      final val = createDocument("${path.trimQuery()}/$uid");
      val.value = val.fromMap(val.filterOnLoad(Map.from(data)));
      await val.save();
      await onDidAppend();
      _saveCompleter?.complete();
      _saveCompleter = null;
    } catch (e) {
      _saveCompleter?.completeError(e);
      _saveCompleter = null;
    } finally {
      _saveCompleter?.complete();
      _saveCompleter = null;
    }
  }

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => _rawPath.hashCode;
}
