part of katana_routing;

/// Defining values that can maintain state in Scoped.
@immutable
abstract class ScopedValue<TResult> {
  /// Defining values that can maintain state in Scoped.
  const ScopedValue();

  /// Create a new state.
  ScopedValueState<TResult, ScopedValue<TResult>> createState();
}

/// State created from Container.
abstract class ScopedValueState<TResult,
    TScopedValue extends ScopedValue<TResult>> {
  bool _disposed = false;
  WidgetRef? _ref;
  TScopedValue? _value;

  /// Compare [keys1] and [keys2] and return True if they have the same value.
  @protected
  bool equalsKeys(List<Object?>? keys1, List<Object?>? keys2) {
    if (keys1 == keys2) {
      return true;
    }
    if (keys1 == null || keys2 == null || keys1.length != keys2.length) {
      return false;
    }

    final i1 = keys1.iterator;
    final i2 = keys2.iterator;
    while (true) {
      if (!i1.moveNext() || !i2.moveNext()) {
        return true;
      }
      if (i1.current != i2.current) {
        return false;
      }
    }
  }

  /// The associated WidgetRef.
  WidgetRef get ref => _ref!;

  /// Current container.
  TScopedValue get value => _value!;

  /// True if the state is discarded.
  bool get disposed => _disposed;

  /// When executed, [Scoped], [ScopedWidget] and [PageScopedWidget] will be rebuilt.
  ///
  /// [callback] is called before the rebuild is done.
  @protected
  @mustCallSuper
  void setState(VoidCallback callback) {
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      if (_disposed) {
        return;
      }
      callback.call();
      _ref?.rebuild();
    });
  }

  /// Process when the scoped value is updated.
  @mustCallSuper
  void didUpdateValue(covariant TScopedValue oldValue) {}

  /// Called when the scoped value is created.
  @mustCallSuper
  void initValue() {}

  /// Called before the page is disposed.
  @mustCallSuper
  void deactivate() {}

  /// Called when the page is disposed.
  @mustCallSuper
  void dispose() {
    _disposed = true;
  }

  /// Build and output the value.
  TResult build();
}
