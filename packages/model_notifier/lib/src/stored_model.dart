part of model_notifier;

/// Abstract class that defines methods for reading and writing data.
abstract class StoredModel<T, Result extends Model<T>> extends Model<T>
    implements FutureModel<T> {
  /// Retrieves data and updates the data in the model.
  ///
  /// You will be notified of model updates at the time they are retrieved.
  ///
  /// In addition,
  /// the updated [Result] can be obtained at the stage where the loading is finished.
  Future<Result> load();

  /// Data stored in the model is stored in a database external to the app that is tied to the model.
  ///
  /// The updated [Result] can be obtained at the stage where the loading is finished.
  Future<Result> save();

  /// Reload data and updates the data in the model.
  ///
  /// It is basically the same as the [load] method,
  /// but combining it with [loadOnce] makes it easier to manage the data.
  Future<Result> reload();

  /// If the data is empty, [load] is performed only once.
  ///
  /// In other cases, the value is returned as is.
  ///
  /// Use [isEmpty] to determine whether the file is empty or not.
  Future<Result> loadOnce();

  /// It becomes `true` after [loadOnce] is executed.
  bool get loaded;

  /// Return `true` if data is empty.
  bool get isEmpty;

  /// Return `true` if data is not empty.
  bool get isNotEmpty;

  /// Callback before the load has been done.
  @protected
  @mustCallSuper
  Future<void> onLoad();

  /// Callback before the save has been done.
  @protected
  @mustCallSuper
  Future<void> onSave();

  /// Callback after the load has been done.
  @protected
  @mustCallSuper
  Future<void> onDidLoad();

  /// Callback after the save has been done.
  @protected
  @mustCallSuper
  Future<void> onDidSave();
}
