part of flutter_runtime_database;

/// Base class for overriding and using providers.
///
/// You can create that provider by describing
/// how to create it in the constructor.
abstract class ProviderBase<T> extends AlwaysAliveProviderBase<FutureOr<T>, T> {
  /// Base class for overriding and using providers.
  ///
  /// You can create that provider by describing
  /// how to create it in the constructor.
  ///
  /// [create]: Provider creation callback.
  ProviderBase(Create<FutureOr<T>, ProviderReference> create)
      : super(create, null);

  @override
  ProviderOverride overrideWithProvider(RootProvider<Object, T> provider) {
    return ProviderOverride(provider, this);
  }

  @override
  _ProviderBaseState<T> createState() => _ProviderBaseState();
}

@sealed
class _ProviderBaseState<T> = ProviderStateBase<FutureOr<T>, T>
    with _ProviderBaseStateMixin<T>;

mixin _ProviderBaseStateMixin<T> on ProviderStateBase<FutureOr<T>, T> {
  @override
  void valueChanged({FutureOr<T> previous}) {
    if (createdValue == exposedValue) {
      return;
    }
    final value = createdValue;
    if (value is Future<T>) {
      value?.then((p) {
        exposedValue = p;
      });
    } else if (value is T) {
      exposedValue = value;
    }
  }
}
