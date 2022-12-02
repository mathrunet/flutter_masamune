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
  /// [ChangeNotifier]を返す[callback]を渡すとそれを監視することができます。
  ///
  /// [ChangeNotifier.notifyListeners]が実行されると更新が通知され、関連するウィジェットが再描画されます。
  ///
  /// [keys]が前の値と違う場合再度[callback]が実行され、新しい[ChangeNotifier]が保存されます。
  ///
  /// [name]を指定すると別のタイプとして保存されます。[keys]を変えた場合は以前の状態は破棄されますが、[name]を変えた場合は別々の状態として保持されます。
  T watch<T extends Listenable?>(
    T Function() callback, {
    List<Object> keys = const [],
    String? name,
  }) {
    return getScopedValue<T, _WatchValue<T>>(
      () => _WatchValue<T>(callback: callback, keys: keys),
      listen: true,
      name: name,
    );
  }
}

@immutable
class _WatchValue<T> extends ScopedValue<T> {
  const _WatchValue({
    required this.callback,
    required this.keys,
  });

  final T Function() callback;
  final List<Object> keys;

  @override
  ScopedValueState<T, ScopedValue<T>> createState() => _WatchValueState<T>();
}

class _WatchValueState<T> extends ScopedValueState<T, _WatchValue<T>> {
  _WatchValueState();

  late T _value;

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
      if (val is ChangeNotifier) {
        val.dispose();
      }
    }
  }

  @override
  T build() => _value;
}
