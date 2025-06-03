part of "value.dart";

/// Provides an extended method for [Ref] to monitor [ChangeNotifier].
///
/// [ChangeNotifier]の監視を行うための[Ref]用の拡張メソッドを提供します。
extension RefWatchExtensions on Ref {
  @Deprecated(
    "[watch] will no longer be available in the App scope. Instead, use [ref.page.watch] or [ref.widget.watch] and limit your use to page or widget scope only. Please use [ref.app.query] instead of [watch]. Appスコープでの[watch]の利用はできなくなります。代わりに[ref.page.watch]や[ref.widget.watch]を利用し、ページやウィジェットスコープのみでの利用に限定してください。Appスコープでの利用は[watch]を利用せず、[ChangeNotifierScopedQuery]を作成し[ref.app.query]を利用してください。",
  )
  T watch<T extends Listenable?>(
    T Function(QueryScopedValueRef<Ref> ref) callback, {
    List<Object> keys = const [],
    Object? name,
    bool disposal = true,
    bool autoDisposeWhenUnreferenced = false,
  }) {
    return getScopedValue<T, _WatchValue<T, Ref>>(
      (ref) => _WatchValue<T, Ref>(
        callback: callback,
        keys: keys,
        ref: this,
        disposal: disposal,
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      ),
      listen: true,
      name: name,
    );
  }
}

/// Provides an extended method for [RefHasPage] to monitor [ChangeNotifier].
///
/// [ChangeNotifier]の監視を行うための[RefHasPage]用の拡張メソッドを提供します。
extension RefHasPageWatchExtensions on RefHasPage {
  @Deprecated(
    "It is no longer possible to use [watch] by directly specifying [PageRef] or [WidgetRef]. Instead, use [ref.page.watch] or [ref.widget.watch] to specify the scope. [PageRef]や[WidgetRef]を直接指定しての[watch]の利用はできなくなります。代わりに[ref.page.watch]や[ref.widget.watch]でスコープを指定しての利用を行ってください。",
  )
  T watch<T extends Listenable?>(
    T Function(QueryScopedValueRef<PageScopedValueRef> ref) callback, {
    List<Object> keys = const [],
    Object? name,
    bool disposal = true,
    bool autoDisposeWhenUnreferenced = false,
  }) {
    return page.getScopedValue<T, _WatchValue<T, PageScopedValueRef>>(
      (ref) => _WatchValue<T, PageScopedValueRef>(
        callback: callback,
        keys: keys,
        ref: page,
        disposal: disposal,
        autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
      ),
      listen: true,
      name: name,
    );
  }
}

/// Provides an extended method for [PageOrWidgetScopedValueRef] to monitor [ChangeNotifier].
///
/// [ChangeNotifier]の監視を行うための[PageOrWidgetScopedValueRef]用の拡張メソッドを提供します。
extension PageOrWidgetScopedValueRefWatchExtensions
    on PageOrWidgetScopedValueRef {
  /// You can monitor it by passing a [callback] that returns a [ChangeNotifier].
  ///
  /// When [ChangeNotifier.notifyListeners] is executed, the update is notified and the associated widget is redrawn.
  ///
  /// If [keys] is different from the previous value, [callback] is executed again and the new [ChangeNotifier] is saved.
  ///
  /// If [name] is specified, it is saved as a separate type. If [keys] is changed, the previous state is discarded, but if [name] is changed, it is kept as a separate state.
  ///
  /// If [disposal] is set to `false`, when [ScopedValue] is destroyed, the content [T] is not destroyed.
  ///
  /// [ChangeNotifier]を返す[callback]を渡すとそれを監視することができます。
  ///
  /// [ChangeNotifier.notifyListeners]が実行されると更新が通知され、関連するウィジェットが再描画されます。
  ///
  /// [keys]が前の値と違う場合再度[callback]が実行され、新しい[ChangeNotifier]が保存されます。
  ///
  /// [name]を指定すると別のタイプとして保存されます。[keys]を変えた場合は以前の状態は破棄されますが、[name]を変えた場合は別々の状態として保持されます。
  ///
  /// [disposal]を`false`にすると[ScopedValue]破棄時、中身の[T]は破棄されません。
  T watch<T extends Listenable?>(
    T Function(QueryScopedValueRef<PageOrWidgetScopedValueRef> ref) callback, {
    List<Object> keys = const [],
    Object? name,
    bool disposal = true,
  }) {
    return getScopedValue<T, _WatchValue<T, PageOrWidgetScopedValueRef>>(
      (ref) => _WatchValue<T, PageOrWidgetScopedValueRef>(
        callback: callback,
        keys: keys,
        ref: this,
        disposal: disposal,
        autoDisposeWhenUnreferenced: false,
      ),
      listen: true,
      name: name,
    );
  }
}

/// Provides an extended method for [QueryScopedValueRef] to monitor [ChangeNotifier].
///
/// [ChangeNotifier]の監視を行うための[QueryScopedValueRef]用の拡張メソッドを提供します。
extension QueryScopedValueRefPageOrWidgetScopedValueRefWatchExtensions
    on QueryScopedValueRef<PageOrWidgetScopedValueRef> {
  /// You can monitor it by passing a [callback] that returns a [ChangeNotifier].
  ///
  /// When [ChangeNotifier.notifyListeners] is executed, the update is notified and the associated widget is redrawn.
  ///
  /// If [keys] is different from the previous value, [callback] is executed again and the new [ChangeNotifier] is saved.
  ///
  /// If [name] is specified, it is saved as a separate type. If [keys] is changed, the previous state is discarded, but if [name] is changed, it is kept as a separate state.
  ///
  /// If [disposal] is set to `false`, when [ScopedValue] is destroyed, the content [T] is not destroyed.
  ///
  /// [ChangeNotifier]を返す[callback]を渡すとそれを監視することができます。
  ///
  /// [ChangeNotifier.notifyListeners]が実行されると更新が通知され、関連するウィジェットが再描画されます。
  ///
  /// [keys]が前の値と違う場合再度[callback]が実行され、新しい[ChangeNotifier]が保存されます。
  ///
  /// [name]を指定すると別のタイプとして保存されます。[keys]を変えた場合は以前の状態は破棄されますが、[name]を変えた場合は別々の状態として保持されます。
  ///
  /// [disposal]を`false`にすると[ScopedValue]破棄時、中身の[T]は破棄されません。
  T watch<T extends Listenable?>(
    T Function(QueryScopedValueRef<PageOrWidgetScopedValueRef> ref) callback, {
    List<Object> keys = const [],
    Object? name,
    bool disposal = true,
  }) {
    return getScopedValue<T, _WatchValue<T, PageOrWidgetScopedValueRef>>(
      (ref) => _WatchValue<T, PageOrWidgetScopedValueRef>(
        callback: callback,
        keys: keys,
        ref: this.ref,
        disposal: disposal,
        autoDisposeWhenUnreferenced: false,
      ),
      listen: true,
      name: name,
    );
  }
}

@immutable
class _WatchValue<T, TRef extends Ref> extends QueryScopedValue<T, TRef> {
  const _WatchValue({
    required this.callback,
    required this.keys,
    required TRef ref,
    this.disposal = true,
    this.autoDisposeWhenUnreferenced = false,
  }) : super(ref: ref);

  final T Function(QueryScopedValueRef<TRef> ref) callback;
  final List<Object> keys;
  final bool disposal;
  final bool autoDisposeWhenUnreferenced;

  @override
  QueryScopedValueState<T, TRef, QueryScopedValue<T, TRef>> createState() =>
      _WatchValueState<T, TRef>();
}

class _WatchValueState<T, TRef extends Ref>
    extends QueryScopedValueState<T, TRef, _WatchValue<T, TRef>> {
  _WatchValueState();

  late T _value;

  @override
  bool get autoDisposeWhenUnreferenced => value.autoDisposeWhenUnreferenced;

  @override
  void initValue() {
    super.initValue();
    _value = value.callback(ref);
    final val = _value;
    if (val is Listenable) {
      val.addListener(_handledOnUpdate);
    }
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void didUpdateValue(_WatchValue<T, TRef> oldValue) {
    super.didUpdateValue(oldValue);
    if (!equalsKeys(value.keys, oldValue.keys)) {
      final oldVal = _value;
      if (oldVal is Listenable) {
        oldVal.removeListener(_handledOnUpdate);
      }
      _value = value.callback(ref);
      final newVal = _value;
      if (newVal is Listenable) {
        newVal.addListener(_handledOnUpdate);
      }
    }
  }

  @override
  void didUpdateDescendant() {
    super.didUpdateDescendant();
    final oldVal = _value;
    if (oldVal is Listenable) {
      oldVal.removeListener(_handledOnUpdate);
    }
    _value = value.callback(ref);
    final newVal = _value;
    if (newVal is Listenable) {
      newVal.addListener(_handledOnUpdate);
    }
  }

  @override
  void dispose() {
    super.dispose();
    final val = _value;
    if (val is Listenable) {
      val.removeListener(_handledOnUpdate);
      if (value.disposal && val is ChangeNotifier) {
        val.dispose();
      }
    }
  }

  @override
  T build() => _value;
}
