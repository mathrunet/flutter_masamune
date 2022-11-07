import 'package:flutter/material.dart';
import 'package:katana_scoped/katana_scoped.dart';

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
  /// [ChangeNotifier]を返す[callback]を渡すとそれを監視することができます。
  ///
  /// [ChangeNotifier.notifyListeners]が実行されると更新が通知され、関連するウィジェットが再描画されます。
  ///
  /// [keys]が前の値と違う場合再度[callback]が実行され、新しい[ChangeNotifier]が保存されます。
  T watch<T extends Listenable>(
    T Function() callback, {
    List<Object> keys = const [],
  }) {
    return getScopedValue<T, _WatchValue<T>>(
      () => _WatchValue<T>(callback: callback, keys: keys),
      listen: true,
    );
  }
}

@immutable
class _WatchValue<T extends Listenable> extends ScopedValue<T> {
  const _WatchValue({
    required this.callback,
    required this.keys,
  });

  final T Function() callback;
  final List<Object> keys;

  @override
  ScopedValueState<T, ScopedValue<T>> createState() => _WatchValueState<T>();
}

class _WatchValueState<T extends Listenable>
    extends ScopedValueState<T, _WatchValue<T>> {
  _WatchValueState();

  late T _value;

  @override
  void initValue() {
    super.initValue();
    _value = value.callback();
    _value.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void didUpdateValue(_WatchValue<T> oldValue) {
    super.didUpdateValue(oldValue);
    if (!equalsKeys(value.keys, oldValue.keys)) {
      _value.removeListener(_handledOnUpdate);
      _value = value.callback();
      _value.addListener(_handledOnUpdate);
    }
  }

  @override
  void dispose() {
    super.dispose();
    final val = _value;
    _value.removeListener(_handledOnUpdate);
    if (val is ChangeNotifier) {
      val.dispose();
    }
  }

  @override
  T build() => _value;
}
