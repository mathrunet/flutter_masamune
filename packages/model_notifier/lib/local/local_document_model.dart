part of model_notifier;

/// Base class for holding and manipulating data from a local database as a document of [T].
///
/// The [load()] method retrieves the value from the local database and
/// the [save()] method saves the value to the local database.
///
/// The local database is a Json database.
/// Specify a path to specify the location of the contents.
///
/// In addition, since it can be used as [Map],
/// it is possible to operate the content as it is.
abstract class LocalDocumentModel<T> extends DocumentModel<T>
    implements StoredDocumentModel<T> {
  /// Base class for holding and manipulating data from a local database as a document of [T].
  ///
  /// The [load()] method retrieves the value from the local database and
  /// the [save()] method saves the value to the local database.
  ///
  /// The local database is a Json database.
  /// Specify a path to specify the location of the contents.
  ///
  /// In addition, since it can be used as [Map],
  /// it is possible to operate the content as it is.
  LocalDocumentModel(this.path, T initialValue)
      : assert(
          !(path.splitLength() <= 0 || path.splitLength() % 2 != 0),
          "The path hierarchy must be an even number: $path",
        ),
        super(initialValue);

  /// The current value stored in this notifier.
  ///
  /// When the value is replaced with something that is not equal to the old value as evaluated by the equality operator ==,
  /// this class notifies its listeners.
  @override
  set value(T newValue) {
    if (super.value == newValue) {
      return;
    }
    super.value = newValue;
  }

  /// Key for UID values.
  final String uidValueKey = Const.uid;

  /// Key for time values.
  final String timeValueKey = Const.time;

  /// Key for locale values.
  final String localeValueKey = MetaConst.locale;

  /// Discards any resources used by the object.
  /// After this is called, the object is not in a usable state and should be discarded (calls to [addListener] and [removeListener] will throw after the object is disposed).
  ///
  /// This method should only be called by the object's owner.
  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    LocalDatabase._db.removeDocumentListener(_query);
  }

  LocalStoreDocumentQuery? _query;

  /// Path of the local database.
  final String path;

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
  @protected
  @mustCallSuper
  Future<void> onLoad() async {}

  /// Callback before the save has been done.
  @protected
  @mustCallSuper
  Future<void> onSave() async {}

  /// Callback before the delete has been done.
  @protected
  @mustCallSuper
  Future<void> onDelete() async {}

  /// Callback after the load has been done.
  @protected
  @mustCallSuper
  Future<void> onDidLoad() async {}

  /// Callback after the save has been done.
  @protected
  @mustCallSuper
  Future<void> onDidSave() async {}

  /// Callback after the delete has been done.
  @protected
  @mustCallSuper
  Future<void> onDidDelete() async {}

  /// You can filter the loaded content when it is loaded.
  ///
  /// Edit the value of [loaded] and return.
  @protected
  @mustCallSuper
  DynamicMap filterOnLoad(DynamicMap loaded) => loaded;

  /// You can filter the saving content when it is saving.
  ///
  /// Edit the value of [save] and return.
  @protected
  @mustCallSuper
  DynamicMap filterOnSave(DynamicMap save) => save;

  /// Provides the best data acquisition method to implement during screen build.
  ///
  /// Data loading does not occur in duplicate when a screen is built multiple times.
  ///
  /// Basically, it listens for data.
  /// If [listen] is set to `false`, load only.
  @override
  Future<void> fetch([bool listen = true]) {
    return loadOnce();
  }

  /// Retrieves data and updates the data in the model.
  ///
  /// You will be notified of model updates at the time they are retrieved.
  ///
  /// In addition,
  /// the updated [Resuult] can be obtained at the stage where the loading is finished.
  @override
  Future<void> load() async {
    if (_loadCompleter != null) {
      return loading;
    }
    _loadCompleter = Completer<void>();
    try {
      value = await _loadProcess();
      notifyListeners();
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
  }

  /// Load data while monitoring Firestore for real-time updates.
  ///
  /// Returns [UnimplementedError] if there is no real-time update.
  ///
  /// It will continue to monitor for updates until [dispose()].
  @override
  Future<void> listen() {
    throw UnimplementedError(
      "Real-time update functionality is not provided; please execute load().",
    );
  }

  Future<T> _loadProcess() async {
    _query ??= LocalStoreDocumentQuery(
      path: path,
      callback: _handledOnUpdate,
      origin: this,
    );
    LocalDatabase._db.addDocumentListener(_query!);
    final data = await LocalDatabase._db.loadDocument(_query!);
    return fromMap(filterOnLoad(data != null ? Map.from(data) : {}));
  }

  void _handledOnUpdate(LocalStoreDocumentUpdate update) {
    switch (update.status) {
      case LocalStoreDocumentUpdateStatus.deleted:
        value = fromMap(filterOnLoad({}));
        break;
      default:
        if (update.origin == this) {
          // FIXME: 同一のオブジェクトが渡された場合の処理になるがこれでいいか不明
          notifyListeners();
        } else {
          value = fromMap(filterOnLoad(update.value));
        }
        break;
    }
  }

  /// Data stored in the model is stored in a database external to the app that is tied to the model.
  ///
  /// The updated [Resuult] can be obtained at the stage where the loading is finished.
  @override
  Future<void> save() async {
    if (_saveCompleter != null) {
      return saving;
    }
    _saveCompleter = Completer<void>();
    try {
      await onSave();
      _saveProcess();
      notifyListeners();
      await onDidSave();
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

  void _saveProcess() {
    final data = filterOnSave(toMap(value));
    _query ??= LocalStoreDocumentQuery(
      path: path,
      callback: _handledOnUpdate,
      origin: this,
    );
    LocalDatabase._db.saveDocument(_query!, data);
  }

  /// Reload data and updates the data in the model.
  ///
  /// It is basically the same as the [load] method,
  /// but combining it with [loadOnce] makes it easier to manage the data.
  @override
  Future<void> reload() => load();

  /// If the data is empty, [load] is performed only once.
  ///
  /// In other cases, the value is returned as is.
  ///
  /// Use [isEmpty] to determine whether the file is empty or not.
  @override
  Future<void> loadOnce() async {
    if (!loaded) {
      loaded = true;
      return load();
    }
  }

  /// Deletes the document.
  ///
  /// Deleted documents are immediately reflected and removed from related collections, etc.
  @override
  Future<void> delete() async {
    if (_saveCompleter != null) {
      return saving;
    }
    _saveCompleter = Completer<void>();
    try {
      await onDelete();
      _deleteProcess();
      notifyListeners();
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

  void _deleteProcess() {
    _query ??= LocalStoreDocumentQuery(
      path: path,
      callback: _handledOnUpdate,
      origin: this,
    );
    value = fromMap(filterOnLoad({}));
    LocalDatabase._db.deleteDocument(_query!);
  }

  /// Return `true` if data is not empty.
  @override
  bool get isNotEmpty => !isEmpty;

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
  int get hashCode => path.hashCode;
}
