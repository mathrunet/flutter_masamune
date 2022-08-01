part of model_notifier;

/// Abstract class for creating a model that can wait on Future.
abstract class FutureModel<T> extends Model<T> {
  /// Returns itself after the load finishes.
  Future<void>? get loading;

  /// Returns itself after the save/delete finishes.
  Future<void>? get saving;
}
