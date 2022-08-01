part of model_notifier;

/// A model class for listening for and retrieving data.
abstract class ListenedModel<T, Result extends Model<T>> extends Model<T> {
  /// Listen for and retrieve data.
  ///
  /// Each time the data is updated, you will be notified of the change.
  Future<Result> listen();
}
