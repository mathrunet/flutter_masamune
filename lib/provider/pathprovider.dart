part of masamune;

/// [IPath] Provider.
/// It can be used in the way riverpod is used.
///
/// You can also combine it with other providers.
///
/// You can use the notification feature of [IPath] as it is, and
/// When you receive a notification, the update will be notified to the widget etc.
///
/// ```dart
/// final counter = PathProvider((ref) => DataField("count"));
/// ```
class PathProvider<T extends IPath>
    extends AlwaysAliveProviderBase<FutureOr<T>, T> {
  /// [IPath] Provider.
  /// It can be used in the way riverpod is used.
  ///
  /// You can also combine it with other providers.
  ///
  /// You can use the notification feature of [IPath] as it is, and
  /// When you receive a notification, the update will be notified to the widget etc.
  ///
  /// ```dart
  /// final counter = PathProvider((ref) => DataField("count"));
  /// ```
  ///
  /// [create]: Provider Definition.
  PathProvider(Create<FutureOr<T>, ProviderReference> create)
      : super(create, null);

  /// An internal method that creates the state of a provider.
  @override
  _PathProviderState<T> createState() => _PathProviderState<T>();
}

@sealed
class _PathProviderState<T extends IPath> = ProviderStateBase<FutureOr<T>, T>
    with _PathProviderStateMixin<T>;

mixin _PathProviderStateMixin<T extends IPath>
    on ProviderStateBase<FutureOr<T>, T> {
  T _cachedValue;

  @override
  void valueChanged({FutureOr<T> previous}) {
    if (createdValue == previous) {
      return;
    }
    if (previous is Future<T>) {
      previous?.then((p) => p?.unwatch(_listener));
    } else if (previous is T) {
      previous?.unwatch(_listener);
    }
    final value = createdValue;
    if (value is Future<T>) {
      value?.then((p) {
        exposedValue = this._cachedValue = p;
        p?.watch(_listener);
      });
    } else if (value is T) {
      exposedValue = this._cachedValue = value;
      value?.watch(_listener);
    }
  }

  void _listener(IPath path) {
    exposedValue = this._cachedValue;
  }

  @override
  void dispose() {
    final value = createdValue;
    if (value is Future<T>) {
      value?.then((p) {
        p?.unwatch(_listener);
      });
    } else if (value is T) {
      value?.unwatch(_listener);
    }
    super.dispose();
  }
}
