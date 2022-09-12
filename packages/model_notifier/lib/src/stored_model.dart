part of model_notifier;

/// Abstract class that defines methods on document model for reading and writing data.
abstract class StoredDocumentModel<T> extends Model<T>
    implements FutureModel<T> {
  /// Provides the best data acquisition method to implement during screen build.
  ///
  /// Data loading does not occur in duplicate when a screen is built multiple times.
  ///
  /// Basically, it listens for data.
  /// If [listen] is set to `false`, load only.
  Future<void> fetch([bool listen = true]);

  /// Retrieves data and updates the data in the model.
  ///
  /// You will be notified of model updates at the time they are retrieved.
  ///
  /// In addition,
  /// the updated [Result] can be obtained at the stage where the loading is finished.
  Future<void> load();

  /// Load data while monitoring Firestore for real-time updates.
  ///
  /// Returns [UnimplementedError] if there is no real-time update.
  ///
  /// It will continue to monitor for updates until [dispose()].
  Future<void> listen();

  /// Data stored in the model is stored in a database external to the app that is tied to the model.
  ///
  /// The updated [Result] can be obtained at the stage where the loading is finished.
  Future<void> save();

  /// Reload data and updates the data in the model.
  ///
  /// It is basically the same as the [load] method,
  /// but combining it with [loadOnce] makes it easier to manage the data.
  Future<void> reload();

  /// If the data is empty, [load] is performed only once.
  ///
  /// In other cases, the value is returned as is.
  ///
  /// Use [isEmpty] to determine whether the file is empty or not.
  Future<void> loadOnce();

  /// Deletes the document.
  ///
  /// Deleted documents are immediately reflected and removed from related collections, etc.
  Future<void> delete();

  /// It becomes `true` after [loadOnce] is executed.
  bool get loaded;

  /// Return `true` if data is empty.
  bool get isEmpty;

  /// Return `true` if data is not empty.
  bool get isNotEmpty;
}

/// Abstract class that defines methods on collection model for reading and writing data.
abstract class StoredCollectionModel<T> extends Model<List<T>>
    implements FutureModel<List<T>> {
  /// Create a new document.
  ///
  /// [id] is the ID of the document. If it is blank, [uuid] is used.
  T create([String? id]);

  /// Provides the best data acquisition method to implement during screen build.
  ///
  /// Data loading does not occur in duplicate when a screen is built multiple times.
  ///
  /// Basically, it listens for data.
  /// If [listen] is set to `false`, load only.
  Future<void> fetch([bool listen = true]);

  /// Retrieves data and updates the data in the model.
  ///
  /// You will be notified of model updates at the time they are retrieved.
  ///
  /// In addition,
  /// the updated [Result] can be obtained at the stage where the loading is finished.
  Future<void> load();

  /// Load data while monitoring Firestore for real-time updates.
  ///
  /// Returns [UnimplementedError] if there is no real-time update.
  ///
  /// It will continue to monitor for updates until [dispose()].
  Future<void> listen();

  /// Data stored in the model is stored in a database external to the app that is tied to the model.
  ///
  /// The updated [Result] can be obtained at the stage where the loading is finished.
  Future<void> save();

  /// Reload data and updates the data in the model.
  ///
  /// It is basically the same as the [load] method,
  /// but combining it with [loadOnce] makes it easier to manage the data.
  Future<void> reload();

  /// If the data is empty, [load] is performed only once.
  ///
  /// In other cases, the value is returned as is.
  ///
  /// Use [isEmpty] to determine whether the file is empty or not.
  Future<void> loadOnce();

  /// Load the data on the next page.
  ///
  /// If there is no data, [load()] is executed.
  Future<void> next();

  /// Returns True if the following reads are possible
  ///
  /// Returns False if no data has been read yet and no limit has been set.
  bool get canNext;

  /// Remove elements in the collection that are `true` in [test].
  Future<void> delete(bool Function(T value) test);

  /// Add a new document to the current collection based on [uid].
  ///
  /// It is possible to specify data to be added to the document by giving [data].
  Future<void> append(String uid, {T? data});

  /// It becomes `true` after [loadOnce] is executed.
  bool get loaded;

  /// Return `true` if data is empty.
  bool get isEmpty;

  /// Return `true` if data is not empty.
  bool get isNotEmpty;
}
