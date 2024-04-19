part of 'value.dart';

/// Provides an extension method for [Ref] to perform caching.
///
/// キャッシュを行うための[Ref]用の拡張メソッドを提供します。
extension RefCacheExtensions on Ref {
  @Deprecated(
    "[cache] will no longer be available in the App scope. Instead, use [ref.page.cache] or [ref.widget.cache] and limit your use to the page or widget scope. Please use [ref.app.query] instead of [cache]. Appスコープでの[cache]の利用はできなくなります。代わりに[ref.page.cache]や[ref.widget.cache]を利用し、ページやウィジェットスコープのみでの利用に限定してください。Appスコープでの利用は[cache]を利用せず、[ScopedQuery]を作成し[ref.app.query]を利用してください。",
  )
  T cache<T>(
    T Function(Ref ref) callback, {
    List<Object> keys = const [],
    Object? name,
    bool disposal = false,
    bool autoDisposeWhenUnreferenced = false,
  }) {
    return getScopedValue<T, _CacheValue<T>>(
      (ref) => _CacheValue<T>(
        callback: callback,
        keys: keys,
        ref: ref,
        disposal: disposal,
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      ),
      listen: false,
      name: name,
    );
  }
}

/// Provides an extension method for [RefHasPage] to perform caching.
///
/// キャッシュを行うための[RefHasPage]用の拡張メソッドを提供します。
extension RefHasPageCacheExtensions on RefHasPage {
  @Deprecated(
    "It is no longer possible to use [cache] by directly specifying [PageRef] or [WidgetRef]. Instead, use [ref.page.cache] or [ref.widget.cache] to specify the scope. [PageRef]や[WidgetRef]を直接指定しての[cache]の利用はできなくなります。代わりに[ref.page.cache]や[ref.widget.cache]でスコープを指定しての利用を行ってください。",
  )
  T cache<T>(
    T Function(Ref ref) callback, {
    List<Object> keys = const [],
    Object? name,
    bool disposal = false,
    bool autoDisposeWhenUnreferenced = false,
  }) {
    return page.getScopedValue<T, _CacheValue<T>>(
      (ref) => _CacheValue<T>(
        callback: callback,
        keys: keys,
        ref: ref,
        disposal: disposal,
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      ),
      listen: false,
      name: name,
    );
  }
}

/// Provides an extension method for [PageOrWidgetScopedValueRef] to perform caching.
///
/// キャッシュを行うための[PageOrWidgetScopedValueRef]用の拡張メソッドを提供します。
extension PageOrWidgetScopedValueRefCacheExtensions
    on PageOrWidgetScopedValueRef {
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
    Object? name,
    bool disposal = false,
  }) {
    return getScopedValue<T, _CacheValue<T>>(
      (ref) => _CacheValue<T>(
        callback: callback,
        keys: keys,
        ref: ref,
        disposal: disposal,
        autoDisposeWhenUnreferenced: false,
      ),
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
    required Ref ref,
    this.disposal = false,
    this.autoDisposeWhenUnreferenced = false,
  }) : super(ref: ref);

  final T Function(Ref ref) callback;
  final List<Object> keys;
  final bool disposal;
  final bool autoDisposeWhenUnreferenced;

  @override
  ScopedValueState<T, ScopedValue<T>> createState() => _CacheValueState<T>();
}

class _CacheValueState<T> extends ScopedValueState<T, _CacheValue<T>> {
  _CacheValueState();

  late T _value;

  @override
  bool get autoDisposeWhenUnreferenced => value.autoDisposeWhenUnreferenced;

  @override
  void initValue() {
    super.initValue();
    _value = value.callback(ref);
  }

  @override
  void didUpdateValue(_CacheValue<T> oldValue) {
    super.didUpdateValue(oldValue);
    if (!equalsKeys(value.keys, oldValue.keys)) {
      _value = value.callback(ref);
    }
  }

  @override
  void didUpdateDescendant() {
    super.didUpdateDescendant();
    _value = value.callback(ref);
  }

  @override
  void dispose() {
    super.dispose();
    final val = _value;
    if (value.disposal && val is ChangeNotifier) {
      val.dispose();
    }
  }

  @override
  T build() => _value;
}
