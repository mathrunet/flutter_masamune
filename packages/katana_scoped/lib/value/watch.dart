part of katana_scoped.value;

/// Provides an extended method for [Ref] to monitor [ChangeNotifier].
///
/// [ChangeNotifier]の監視を行うための[Ref]用の拡張メソッドを提供します。
extension RefWatchExtensions on Ref {
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
  /// If you want [ScopedValue] to be automatically disposed of when it is no longer referenced by any widget, set [autoDisposeWhenUnreferenced] to `true`.
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
  ///
  /// [ScopedValue]がどのウィジェットにも参照されなくなったときに自動的に破棄させたい場合は[autoDisposeWhenUnreferenced]を`true`にしてください。
  T watch<T extends Listenable?>(
    T Function(Ref ref) callback, {
    List<Object> keys = const [],
    String? name,
    bool disposal = true,
    bool autoDisposeWhenUnreferenced = false,
  }) {
    return getScopedValue<T, _WatchValue<T>>(
      (ref) => _WatchValue<T>(
        callback: () => callback(ref),
        keys: keys,
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
  /// If you want [ScopedValue] to be automatically disposed of when it is no longer referenced by any widget, set [autoDisposeWhenUnreferenced] to `true`.
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
  ///
  /// [ScopedValue]がどのウィジェットにも参照されなくなったときに自動的に破棄させたい場合は[autoDisposeWhenUnreferenced]を`true`にしてください。
  T watch<T extends Listenable?>(
    T Function(Ref ref) callback, {
    List<Object> keys = const [],
    String? name,
    bool disposal = true,
    bool autoDisposeWhenUnreferenced = false,
  }) {
    return page.watch<T>(
      callback,
      keys: keys,
      name: name,
      disposal: disposal,
      autoDisposeWhenUnreferenced: autoDisposeWhenUnreferenced,
    );
  }
}

@immutable
class _WatchValue<T> extends ScopedValue<T> {
  const _WatchValue({
    required this.callback,
    required this.keys,
    this.disposal = true,
    this.autoDisposeWhenUnreferenced = false,
  });

  final T Function() callback;
  final List<Object> keys;
  final bool disposal;
  final bool autoDisposeWhenUnreferenced;

  @override
  ScopedValueState<T, ScopedValue<T>> createState() => _WatchValueState<T>();
}

class _WatchValueState<T> extends ScopedValueState<T, _WatchValue<T>> {
  _WatchValueState();

  late T _value;

  @override
  bool get autoDisposeWhenUnreferenced => value.autoDisposeWhenUnreferenced;

  @override
  void initValue() {
    super.initValue();
    _value = value.callback();
    final val = _value;
    if (val is Listenable) {
      val.addListener(_handledOnUpdate);
    }
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void didUpdateValue(_WatchValue<T> oldValue) {
    super.didUpdateValue(oldValue);
    if (!equalsKeys(value.keys, oldValue.keys)) {
      final oldVal = _value;
      if (oldVal is Listenable) {
        oldVal.removeListener(_handledOnUpdate);
      }
      _value = value.callback();
      final newVal = _value;
      if (newVal is Listenable) {
        newVal.addListener(_handledOnUpdate);
      }
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
