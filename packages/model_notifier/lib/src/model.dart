part of model_notifier;

/// You can create a [Model] based on a [ChangeNotifier].
abstract class Model<T> extends ChangeNotifier {
  /// You can create a [Model] based on a [ChangeNotifier].
  Model() {
    initState();
  }

  /// True if the model is Disposed.
  bool get disposed => _disposed;
  @protected
  bool _disposed = false;

  /// The method to be executed when initialization is performed.
  @protected
  @mustCallSuper
  void initState() {}

  /// Discards any resources used by the object. After this is called, the
  /// object is not in a usable state and should be discarded (calls to
  /// [addListener] and [removeListener] will throw after the object is
  /// disposed).
  ///
  /// This method should only be called by the object's owner.
  @override
  @protected
  @mustCallSuper
  void dispose() {
    if (disposed) {
      throw Exception("This model is already disposed.");
    }
    super.dispose();
    _disposed = true;
  }

  /// Call all the registered listeners.
  ///
  /// Call this method whenever the object changes, to notify any clients the
  /// object may have changed. Listeners that are added during this iteration
  /// will not be visited. Listeners that are removed during this iteration will
  /// not be visited after they are removed.
  ///
  /// Exceptions thrown by listeners will be caught and reported using
  /// [FlutterError.reportError].
  ///
  /// This method must not be called after [dispose] has been called.
  ///
  /// Surprising behavior can result when reentrantly removing a listener (e.g.
  /// in response to a notification) that has been registered multiple times.
  /// See the discussion at [removeListener].
  @override
  @protected
  @mustCallSuper
  void notifyListeners() {
    if (disposed) {
      throw Exception("This model is already disposed.");
    }
    super.notifyListeners();
  }
}
