part of model_notifier;

/// Define a datastore structure for local use.
///
/// Preserves NoSQL structure in Json at runtime.
///
/// Json can be encoded and saved to a local file or to a remote DB.
/// In such cases, use [onInitialize], [onLoad], [onSaved], and [onDeleted] to describe the external linkage.
class LocalStore {
  LocalStore({
    this.onInitialize,
    this.onLoad,
    this.onSaved,
    this.onDeleted,
  });
  // ignore: prefer_final_fields
  DynamicMap _data = {};

  /// Callbacks during initialization.
  final Future<void> Function()? onInitialize;

  /// Callback when data is saved.
  final Future<void> Function()? onSaved;

  /// Callback when data is loaded.
  final Future<void> Function()? onLoad;

  /// Callback when data is deleted.
  final Future<void> Function()? onDeleted;
  final Map<String, Set<LocalStoreDocumentQuery>> _documentListeners = {};
  final Map<String, Set<LocalStoreCollectionQuery>> _collectionListeners = {};

  /// Returns True if the database is initialized.
  bool get isInitialized => _isInitialized;
  bool _isInitialized = false;

  /// Initialize the database.
  Future<void> initialize() async {
    if (isInitialized) {
      return;
    }
    await onInitialize?.call();
    _isInitialized = true;
  }

  void addDocumentListener(LocalStoreDocumentQuery query) {
    final trimPath = query.path.trimQuery().trimString("/");
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

  void removeDocumentListener(LocalStoreDocumentQuery? query) {
    if (query == null) {
      return;
    }
    final trimPath = query.path.trimQuery().trimString("/");
    if (_documentListeners.containsKey(trimPath)) {
      _documentListeners[trimPath]!.remove(query);
    }
  }

  void addCollectionListener(LocalStoreCollectionQuery query) {
    final trimPath = query.path.trimQuery().trimString("/");
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

  void removeCollectionListener(LocalStoreCollectionQuery? query) {
    if (query == null) {
      return;
    }
    final trimPath = query.path.trimQuery().trimString("/");
    if (_collectionListeners.containsKey(trimPath)) {
      _collectionListeners[trimPath]!.remove(query);
    }
  }

  Future<DynamicMap?> loadDocument(LocalStoreDocumentQuery query) async {
    await initialize();
    await onLoad?.call();
    final trimPath = query.path.trimQuery().trimString("/");
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

  Future<Map<String, DynamicMap>?> loadCollection(
    LocalStoreCollectionQuery query,
  ) async {
    await initialize();
    await onLoad?.call();
    final trimPath = query.path.trimQuery().trimString("/");
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return null;
    }
    final value = _data._readFromPath(paths, 0);
    if (value is! DynamicMap) {
      return null;
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
    if (query.filter != null) {
      entries.removeWhere((element) => !query.filter!(element.value));
    }
    return Map<String, DynamicMap>.fromEntries(entries);
  }

  void addMockDocument(String path, DynamicMap value) {
    if (path.isEmpty || value.isEmpty) {
      return;
    }
    final paths = path.trimQuery().trimString("/").split("/");
    if (paths.isEmpty) {
      return;
    }
    _data._writeToPath(paths, 0, Map.from(value));
  }

  Future<void> saveDocument(
    LocalStoreDocumentQuery query,
    DynamicMap value,
  ) async {
    await initialize();
    final trimPath = query.path.trimQuery().trimString("/");
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return;
    }
    _data._writeToPath(paths, 0, value);
    notifyDocuments(
      trimPath,
      paths.last,
      value,
      LocalStoreDocumentUpdateStatus.addOrModified,
      query,
    );
    await onSaved?.call();
  }

  Future<void> deleteDocument(LocalStoreDocumentQuery query) async {
    await initialize();
    final trimPath = query.path.trimQuery().trimString("/");
    final paths = trimPath.split("/");
    if (paths.isEmpty) {
      return;
    }
    _data._deleteFromPath(paths, 0);
    notifyDocuments(
      trimPath,
      paths.last,
      {},
      LocalStoreDocumentUpdateStatus.deleted,
      query,
    );
    await onDeleted?.call();
  }

  Future<void> replace(DynamicMap replaceData) async {
    await initialize();
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
    _data = replaceData;
    for (final tmp in cache.entries) {
      final trimPath = tmp.key;
      final paths = trimPath.split("/");
      final value = _data._readFromPath(paths, 0);
      if (value is! Map) {
        // Deleted.
        notifyDocuments(
          trimPath,
          paths.last,
          {},
          LocalStoreDocumentUpdateStatus.deleted,
          LocalStoreDocumentQuery(path: trimPath),
        );
      } else {
        // Add or Modified.
        notifyDocuments(
          trimPath,
          paths.last,
          value.cast<String, dynamic>(),
          LocalStoreDocumentUpdateStatus.addOrModified,
          LocalStoreDocumentQuery(path: trimPath),
        );
      }
    }
    await onSaved?.call();
  }

  void notifyDocuments(
    String path,
    String key,
    DynamicMap value,
    LocalStoreDocumentUpdateStatus status,
    LocalStoreDocumentQuery query,
  ) {
    final collectionPath = path.parentPath();
    if (_documentListeners.containsKey(path)) {
      _documentListeners[path]?.forEach(
        (element) => element.callback?.call(
          LocalStoreDocumentUpdate(
            path: path,
            id: key,
            status: status,
            value: Map.from(value),
            origin: query.origin,
          ),
        ),
      );
    }
    if (_collectionListeners.containsKey(collectionPath)) {
      _collectionListeners[collectionPath]?.forEach(
        (element) => element.callback?.call(
          LocalStoreDocumentUpdate(
            path: path,
            id: key,
            status: status,
            value: Map.from(value),
            origin: query.origin,
          ),
        ),
      );
    }
  }
}

/// Update Status.
enum LocalStoreDocumentUpdateStatus {
  /// If added or changed.
  addOrModified,

  /// If deleted.
  deleted,
}

/// Class for notification of document updates.
@immutable
class LocalStoreDocumentUpdate {
  const LocalStoreDocumentUpdate({
    required this.path,
    required this.id,
    required this.status,
    required this.value,
    this.origin,
  });

  /// Document path.
  final String path;

  /// Document id.
  final String id;

  /// Document object.
  final Object? origin;

  /// Update Status.
  final LocalStoreDocumentUpdateStatus status;

  /// Updated contents.
  final DynamicMap value;
}

/// Query for storing documents in [LocalStore].
@immutable
class LocalStoreDocumentQuery {
  const LocalStoreDocumentQuery({
    required this.path,
    this.callback,
    this.origin,
  });

  /// Document path.
  final String path;

  /// Document object.
  final Object? origin;

  /// Callback notified when a document is updated.
  final void Function(LocalStoreDocumentUpdate update)? callback;
}

/// Query for storing collection in [LocalStore].
@immutable
class LocalStoreCollectionQuery {
  const LocalStoreCollectionQuery({
    required this.path,
    this.callback,
    this.origin,
    this.filter,
  });

  /// Collection path.
  final String path;

  /// Collection object.
  final Object? origin;

  /// Callback notified when a collection is updated.
  final void Function(LocalStoreDocumentUpdate update)? callback;

  /// Callback to filter the contents of the collection.
  final bool Function(DynamicMap update)? filter;
}

extension _LocalStoreDynamicMapExtensions on Map {
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

  void _writeToPath(List<String> paths, int index, dynamic value) {
    final p = paths[index];
    if (p.isEmpty) {
      return;
    }
    if (paths.length - 1 <= index) {
      remove(p);
      this[p] = value;
      return;
    }
    final val = this[p];
    if (val is! Map) {
      final val = this[p] = <String, dynamic>{};
      val._writeToPath(paths, index + 1, value);
    } else {
      val._writeToPath(paths, index + 1, value);
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
