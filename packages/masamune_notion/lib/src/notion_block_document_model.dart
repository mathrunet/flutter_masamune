part of masamune_notion;

final notionBlockDocumentProvider =
    ChangeNotifierProvider.family<NotionBlockDocumentModel, String>(
  (_, blockId) => NotionBlockDocumentModel(blockId, {}),
);

class NotionBlockDocumentModel extends DocumentModel<DynamicMap>
    with MapModelMixin<String, dynamic>
    implements DynamicDocumentModel {
  NotionBlockDocumentModel(this.blockId, DynamicMap value) : super(value);

  final String blockId;

  DateTime get createdTime {
    return value.getAsDateTime(Const.createdTime);
  }

  DateTime get updatedTime {
    return value.getAsDateTime("updatedTime");
  }

  bool get hasChildren => value.get("hasChildren", false);

  NotionBlockCollectionModel? get children => _children;
  NotionBlockCollectionModel? _children;

  String get type {
    return value.get("type", "");
  }

  int get index {
    return value.get("index", 0);
  }

  DynamicMap get rawData => value.getAsMap("raw");

  /// Returns itself after the load finishes.
  @override
  Future<void>? get loading => _loadCompleter?.future;
  Completer<void>? _loadCompleter;

  /// Returns itself after the save/delete finishes.
  @override
  Future<void>? get saving {
    throw UnimplementedError();
  }

  /// It becomes `true` after [loadOnce] is executed.
  @override
  bool get loaded => _loaded;
  bool _loaded = false;

  /// Callback before the load has been done.
  @protected
  @mustCallSuper
  Future<void> onLoad() async {}

  /// Callback after the load has been done.
  @protected
  @mustCallSuper
  Future<void> onDidLoad() async {}

  /// Creates a specific object from a given [map].
  ///
  /// This is used to convert the loaded data into an object for internal management.
  @override
  DynamicMap fromMap(DynamicMap page) {
    final uid = page.get("id", "").replaceAll("-", "");
    final createdTime = DateTime.tryParse(page.get("created_time", ""));
    final updatedTime = DateTime.tryParse(page.get("last_edited_time", ""));
    final type = page.get("type", "");
    if (uid.isEmpty ||
        createdTime == null ||
        updatedTime == null ||
        type.isEmpty) {
      throw Exception("Response data is invalid.");
    }
    return <String, dynamic>{
      Const.uid: uid,
      Const.createdTime: createdTime.millisecondsSinceEpoch,
      "updatedTime": updatedTime.millisecondsSinceEpoch,
      "type": type,
      "hasChildren": page.get("has_children", false),
      "raw": page.getAsMap(type),
      "index": page.get("index", 0),
    };
  }

  /// Creates a [DynamicMap] from its own [value].
  ///
  /// It is used for storing data.
  @override
  DynamicMap toMap(DynamicMap value) {
    throw UnimplementedError();
  }

  /// If this value is true,
  /// the change will be notified when [value] itself is changed.
  @override
  bool get notifyOnChangeValue => false;

  /// Get an instance of Firebase Functions.
  @protected
  FirebaseFunctions get functions {
    return FirebaseFunctions.instanceFor(region: FirebaseCore.region);
  }

  /// Provides the best data acquisition method to implement during screen build.
  ///
  /// Data loading does not occur in duplicate when a screen is built multiple times.
  ///
  /// Basically, it listens for data.
  /// If [listen] is set to `false`
  @override
  Future<void> fetch([bool listen = true]) {
    return loadChildrenOnce();
  }

  /// Retrieves data and updates the data in the model.
  ///
  /// You will be notified of model updates at the time they are retrieved.
  ///
  /// In addition,
  /// the updated [Resuult] can be obtained at the stage where the loading is finished.
  Future<NotionBlockDocumentModel> loadChildren([bool useCache = true]) async {
    if (!hasChildren) {
      return this;
    }
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
      await onLoad();
      _children = readProvider(notionBlockCollectionProvider(blockId));
      await _children?.loadOnce(useCache);
      await onDidLoad();
      notifyListeners();
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
  Future<NotionBlockDocumentModel> reloadChildren([bool useCache = true]) =>
      loadChildren(useCache);

  /// If the data is empty, [load] is performed only once.
  ///
  /// In other cases, the value is returned as is.
  ///
  /// Use [isEmpty] to determine whether the file is empty or not.
  Future<NotionBlockDocumentModel> loadChildrenOnce([
    bool useCache = true,
  ]) async {
    if (!hasChildren) {
      return this;
    }
    if (!loaded) {
      _loaded = true;
      return loadChildren(useCache);
    }
    return this;
  }

  /// Return `true` if data is not empty.
  @override
  bool get isNotEmpty => !isEmpty;

  @override
  Future<void> delete() {
    throw UnimplementedError();
  }

  @override
  Future<void> reload() {
    throw UnimplementedError();
  }

  @override
  Future<void> save() {
    throw UnimplementedError();
  }

  @override
  DocumentTransactionBuilder transaction() {
    throw UnimplementedError();
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
  int get hashCode => blockId.hashCode;
}
