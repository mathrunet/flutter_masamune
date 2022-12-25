part of katana_scoped.value;

/// Provides an extension method for [Ref] to perform caching.
///
/// キャッシュを行うための[Ref]用の拡張メソッドを提供します。
extension RefCacheExtensions on Ref {
  /// Caches and stores the value returned by [callback].
  ///
  /// If [keys] is passed a value different from the previous value, [callback] is executed again and the value is updated.
  ///
  /// If [name] is specified, it is saved as a separate type. If [keys] is changed, the previous state is discarded, but if [name] is changed, it is kept as a separate state.
  ///
  /// [callback]で返される値をキャッシュして保存します。
  ///
  /// [keys]が前の値と違う値が渡された場合、再度[callback]が実行され値が更新されます。
  ///
  /// [name]を指定すると別のタイプとして保存されます。[keys]を変えた場合は以前の状態は破棄されますが、[name]を変えた場合は別々の状態として保持されます。
  T cache<T>(
    T Function(Ref ref) callback, {
    List<Object> keys = const [],
    String? name,
  }) {
    return getScopedValue<T, _CacheValue<T>>(
      (ref) => _CacheValue<T>(callback: () => callback(ref), keys: keys),
      listen: false,
      name: name,
    );
  }
}

@immutable
class _CacheValue<T> extends ScopedValue<T> {
  const _CacheValue({
    required this.callback,
    required this.keys,
  });

  final T Function() callback;
  final List<Object> keys;

  @override
  ScopedValueState<T, ScopedValue<T>> createState() => _CacheValueState<T>();
}

class _CacheValueState<T> extends ScopedValueState<T, _CacheValue<T>> {
  _CacheValueState();

  late T _value;

  @override
  void initValue() {
    super.initValue();
    _value = value.callback();
  }

  @override
  void didUpdateValue(_CacheValue<T> oldValue) {
    super.didUpdateValue(oldValue);
    if (!equalsKeys(value.keys, oldValue.keys)) {
      _value = value.callback();
    }
  }

  @override
  T build() => _value;
}
