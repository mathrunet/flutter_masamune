part of "/katana_scoped.dart";

/// Class for extensions to manage state.
///
/// After managing the state, return an object of [TResult].
///
/// Implement the relevant state with [ScopedValueState] and create it with [createState].
///
/// 状態を管理するための拡張用のクラス。
///
/// 状態を管理した後[TResult]のオブジェクトを返すようにします。
///
/// 関連するステートを[ScopedValueState]で実装し[createState]で作成します。
@immutable
abstract class ScopedValue<TResult> {
  /// Class for extensions to manage state.
  ///
  /// After managing the state, return an object of [TResult].
  ///
  /// Implement the relevant state with [ScopedValueState] and create it with [createState].
  ///
  /// 状態を管理するための拡張用のクラス。
  ///
  /// 状態を管理した後[TResult]のオブジェクトを返すようにします。
  ///
  /// 関連するステートを[ScopedValueState]で実装し[createState]で作成します。
  const ScopedValue();

  /// Creates and returns the associated state.
  ///
  /// 関連するステートを作成し返します。
  ScopedValueState<TResult, ScopedValue<TResult>> createState();
}

/// State created by [ScopedValue].
///
/// initValue], [didUpdateValue], [deactivate], and [dispose] are executed for each lifecycle of create, update, deactivate, and destroy.
///
/// After it is destroyed, [disposed] will be `true`.
///
/// You can get the [ScopedValue] of the creation source at [value].
///
/// After [ScopedValue] is updated, [value] is updated.
///
/// You can get [TResult] at [build].
///
/// Execute [setState] to update the associated widget.
///
/// [ScopedValue]で作成されるステート。
///
/// 作成、更新、非有効化、破棄のライフサイクルごとに[initValue]、[didUpdateValue]、[deactivate]、[dispose]が実行されます。
///
/// 破棄された後は[disposed]が`true`になります。
///
/// [value]で作成元の[ScopedValue]を取得できます。
///
/// [ScopedValue]が更新された後は[value]が更新されます。
///
/// [build]で[TResult]を取得することができます。
///
/// [setState]を実行すると関連付けられているウィジェットを更新することができます。
abstract class ScopedValueState<TResult,
    TScopedValue extends ScopedValue<TResult>> {
  bool _disposed = false;
  late TScopedValue? _value;
  final Set<ScopedValueState> _ancestorStates = {};
  final Set<ScopedValueListener> _listeners = {};
  final Set<VoidCallback> _callbacks = {};
  late final DynamicMap _baseParameters;
  late final List<LoggerAdapter> _loggerAdapters;

  /// Returns `true` if [ScopedValue] should be automatically discarded when it is no longer referenced by any widget.
  ///
  /// [ScopedValue]がどのウィジェットにも参照されなくなったときに自動的に破棄する場合`true`を返します。
  bool get autoDisposeWhenUnreferenced => false;

  void _addParent(ScopedValueState state) {
    _ancestorStates.add(state);
  }

  void _addListener(ScopedValueListener listener, [VoidCallback? callback]) {
    if (_listeners.contains(listener)) {
      return;
    }
    _listeners.add(listener);
    if (callback != null) {
      _callbacks.add(callback);
    }
  }

  void _removeListener(ScopedValueListener listener, [VoidCallback? callback]) {
    _listeners.remove(listener);
    if (callback != null) {
      _callbacks.remove(callback);
    }
  }

  void _notifyListeners() {
    assert(!disposed, "Value is already disposed.");
    for (final callback in _callbacks) {
      callback.call();
    }
    for (final ancestor in _ancestorStates) {
      ancestor._notifyAncestor();
    }
  }

  void _notifyAncestor() {
    didUpdateDescendant();
    for (final ancestor in _ancestorStates) {
      ancestor._notifyAncestor();
    }
  }

  void _setValue(TScopedValue value) {
    _value = value;
  }

  void _setLoggers({
    required List<LoggerAdapter> loggerAdapters,
    required DynamicMap baseParameters,
  }) {
    _loggerAdapters = loggerAdapters;
    _baseParameters = baseParameters;
    _sendLog(ScopedLoggerEvent.init);
  }

  /// Used to check for updates with `keys` when trying to update with [setState] in [didUpdateValue].
  ///
  /// Checks all contents of [keys1] and [keys2] and returns `true` if all values are the same.
  ///
  /// [didUpdateValue]で[setState]で更新しようとする際、`keys`で更新チェックを行うために利用します。
  ///
  /// [keys1]と[keys2]の中身をすべてチェックしすべての値が同じな場合は`true`を返します。
  @protected
  bool equalsKeys(List<Object> keys1, List<Object> keys2) {
    if (keys1 == keys2) {
      return true;
    }
    if (keys1.length != keys2.length) {
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

  /// Returns the [TScopedValue] of the creation source.
  ///
  /// 作成元の[TScopedValue]を返します。
  TScopedValue get value => _value!;

  /// `true` after the value is discarded.
  ///
  /// 値が破棄された後`true`になります。
  bool get disposed => _disposed;

  /// Notify associated widgets of updates.
  ///
  /// [callback] is executed when notifying updates.
  ///
  /// 関連付けれらたウィジェットに更新を通知します。
  ///
  /// 更新を通知する際に[callback]が実行されます。
  @protected
  @mustCallSuper
  void setState(VoidCallback callback) {
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      if (_disposed) {
        return;
      }
      callback.call();
    });
    _notifyListeners();
  }

  /// Executed each time [ScopedValue] is called.
  ///
  /// The value before it is called is passed in [oldValue].
  ///
  /// Compare [oldValue] and [value] and update only if you want to update the value.
  ///
  /// For example, you can set `keys` in [ScopedValue] and update the value if it is different from the value set in [equalsKeys].
  ///
  /// [ScopedValue]が毎回呼ばれる際に実行されます。
  ///
  /// 呼ばれる前の値が[oldValue]で渡されます。
  ///
  /// [oldValue]と[value]を比較して値を更新したい場合のみ更新するようにしてください。
  ///
  /// 例えば、[ScopedValue]に`keys`などを設定できるようにし[equalsKeys]で比較して異なっていれば更新するなどが利用されます。
  @mustCallSuper
  void didUpdateValue(covariant TScopedValue oldValue) {}

  /// The original [ScopedValue] is notified when a [ScopedValue] executed through the internal [Ref] is updated.
  ///
  /// 内部の[Ref]を通して実行された[ScopedValue]が更新された際にその元となった[ScopedValue]に通知されます。
  @mustCallSuper
  void didUpdateDescendant() {}

  /// Executed when a value is created.
  ///
  /// 値が作成された際に実行されます。
  @mustCallSuper
  void initValue() {}

  /// If the widget is monitored by a widget, it is executed when the monitored widget is destroyed or otherwise removed.
  ///
  /// ウィジェットで監視されている場合、監視されているウィジェットが破棄される等して外される場合に実行されます。
  @mustCallSuper
  void deactivate() {}

  /// Executed when the value is discarded.
  ///
  /// 値が破棄される際に実行されます。
  @mustCallSuper
  void dispose() {
    assert(!disposed, "Value is already disposed.");
    _disposed = true;
    _callbacks.clear();
    _listeners.clear();
    _ancestorStates.clear();
    _sendLog(ScopedLoggerEvent.dispose);
  }

  /// Builder to return [TResult].
  ///
  /// [TResult]を返すためのビルダー。
  TResult build();

  void _sendLog(
    ScopedLoggerEvent event, {
    DynamicMap? additionalParameter,
  }) {
    for (final loggerAdapter in _loggerAdapters) {
      loggerAdapter.send(
        event.toString(),
        parameters: {
          ..._baseParameters,
          if (additionalParameter != null) ...additionalParameter,
        },
      );
    }
  }
}

/// Class for extensions to manage state.
///
/// After managing the state, return an object of [TResult].
///
/// Implement the relevant state with [ScopedValueState] and create it with [createState].
///
/// You can also specify a [Ref] that can be referenced by a child element by passing [ref].
///
/// 状態を管理するための拡張用のクラス。
///
/// 状態を管理した後[TResult]のオブジェクトを返すようにします。
///
/// 関連するステートを[ScopedValueState]で実装し[createState]で作成します。
///
/// また[ref]を渡すことで子要素に参照可能な[Ref]を指定できます。
@immutable
abstract class QueryScopedValue<TResult, TRef extends Ref>
    extends ScopedValue<TResult> {
  /// Class for extensions to manage state.
  ///
  /// After managing the state, return an object of [TResult].
  ///
  /// Implement the relevant state with [ScopedValueState] and create it with [createState].
  ///
  /// You can also specify a [Ref] that can be referenced by a child element by passing [ref].
  ///
  /// 状態を管理するための拡張用のクラス。
  ///
  /// 状態を管理した後[TResult]のオブジェクトを返すようにします。
  ///
  /// 関連するステートを[ScopedValueState]で実装し[createState]で作成します。
  ///
  /// また[ref]を渡すことで子要素に参照可能な[Ref]を指定できます。
  const QueryScopedValue({required this.ref});

  /// Specify the associated [TRef], if any.
  ///
  /// 関連する[TRef]があれば指定します。
  final TRef? ref;

  /// Creates and returns the associated state.
  ///
  /// 関連するステートを作成し返します。
  @override
  QueryScopedValueState<TResult, TRef, QueryScopedValue<TResult, TRef>>
      createState();
}

/// State created by [ScopedValue].
///
/// initValue], [didUpdateValue], [deactivate], and [dispose] are executed for each lifecycle of create, update, deactivate, and destroy.
///
/// After it is destroyed, [disposed] will be `true`.
///
/// You can get the [ScopedValue] of the creation source at [value].
///
/// After [ScopedValue] is updated, [value] is updated.
///
/// You can get [TResult] at [build].
///
/// Execute [setState] to update the associated widget.
///
/// By specifying [ref], you can obtain a [Ref] that can be referenced by a child element.
///
/// [ScopedValue]で作成されるステート。
///
/// 作成、更新、非有効化、破棄のライフサイクルごとに[initValue]、[didUpdateValue]、[deactivate]、[dispose]が実行されます。
///
/// 破棄された後は[disposed]が`true`になります。
///
/// [value]で作成元の[ScopedValue]を取得できます。
///
/// [ScopedValue]が更新された後は[value]が更新されます。
///
/// [build]で[TResult]を取得することができます。
///
/// [setState]を実行すると関連付けられているウィジェットを更新することができます。
///
/// [ref]を指定することで子要素で参照可能な[Ref]を取得できます。
abstract class QueryScopedValueState<TResult, TRef extends Ref,
        TScopedValue extends QueryScopedValue<TResult, TRef>>
    extends ScopedValueState<TResult, TScopedValue> {
  /// If [Ref] is passed to [ScopedValue], it returns a [Ref] that can be referenced by descendants.
  ///
  /// If [Ref] is not passed to [ScopedValue], an error will result.
  ///
  /// [ScopedValue]に[Ref]が渡された場合、子孫によって参照可能な[Ref]を返します。
  ///
  /// [ScopedValue]に[Ref]が渡されていない場合、エラーになります。
  QueryScopedValueRef<TRef> get ref {
    final ref = value.ref;
    assert(ref != null, "[ref] is not set.");
    return QueryScopedValueRef<TRef>._(ref: ref!, state: this);
  }
}
