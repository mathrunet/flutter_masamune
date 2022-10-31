part of katana_scoped;

/// Container object for storing [ScopedValue].
///
/// It is usually called via [ScopedValueListener].
///
/// A database of [ScopedValue] is maintained internally, and the corresponding [ScopedValueState] can be read and edited by [getScopedValueState].
///
/// [ScopedValue]を保存するためのコンテナオブジェクト。
///
/// 通常は[ScopedValueListener]を介して呼び出されます。
///
/// 内部に[ScopedValue]のデータベースを保持しており、[getScopedValueState]で[ScopedValue]に対応する[ScopedValueState]を読込み編集を加えることが可能です。
class ScopedValueContainer {
  /// Container object for storing [ScopedValue].
  ///
  /// It is usually called via [ScopedValueListener].
  ///
  /// A database of [ScopedValue] is maintained internally, and the corresponding [ScopedValueState] can be read and edited by [getScopedValueState].
  ///
  /// [ScopedValue]を保存するためのコンテナオブジェクト。
  ///
  /// 通常は[ScopedValueListener]を介して呼び出されます。
  ///
  /// 内部に[ScopedValue]のデータベースを保持しており、[getScop
  ScopedValueContainer();

  final Map<String, ScopedValueState> _data = {};

  /// By passing a callback that returns [TScopedValue] to [provider], it creates a state for that [ScopedValue] and performs the appropriate processing, returning [ScopedValueState].
  ///
  /// Keys are stored in `TScopedValue/name` and the state is maintained for each key.
  ///
  /// If the key is searched and the already created state does not exist, a new state is created and [ScopedValueState.initValue] is executed to save the state.
  ///
  /// If the state has already been created, [ScopedValueState.didUpdateValue] is executed and the value is returned.
  ///
  /// [onInitOrUpdate] is executed just before [ScopedValueState.initValue] or [ScopedValueState.didUpdateValue] is executed.
  ///
  /// [provider]に[TScopedValue]を返すコールバックを渡すことでその[ScopedValue]のステートを作成しつつ適切な処理を行い[ScopedValueState]を返します。
  ///
  /// `TScopedValue/name`でキーが保存されており、そのキーごとに状態が保持されます。
  ///
  /// キーを検索しすでに作成済みの状態が存在しない場合は新しく状態を作成し[ScopedValueState.initValue]を実行して状態を保存します。
  ///
  /// すでに作成済みの状態が存在する場合は[ScopedValueState.didUpdateValue]を実行して値を返します。
  ///
  /// [ScopedValueState.initValue]や[ScopedValueState.didUpdateValue]を実行する直前に[onInitOrUpdate]が実行されます。
  ScopedValueState<TResult, ScopedValue<TResult>>
      getScopedValueState<TResult, TScopedValue extends ScopedValue<TResult>>(
    TScopedValue Function() provider, {
    void Function(ScopedValueState<TResult, TScopedValue> state)?
        onInitOrUpdate,
    String? name,
  }) {
    final key = "$TScopedValue/$name";
    final found = _data[key];
    if (found != null) {
      assert(
        found is ScopedValueState<TResult, TScopedValue>,
        "The stored [value] type is incorrect: ${found.runtimeType}",
      );
      final state = found as ScopedValueState<TResult, TScopedValue>;
      final oldValue = state.value;
      state._setValue(provider.call());
      onInitOrUpdate?.call(state);
      found.didUpdateValue(oldValue);
      return state;
    } else {
      final value = provider.call();
      final state =
          value.createState() as ScopedValueState<TResult, TScopedValue>;
      state._setValue(value);
      onInitOrUpdate?.call(state);
      state.initValue();
      _data[key] = state;
      return state;
    }
  }

  /// Called just before [ScopedValueContainer] is destroyed.
  ///
  /// ScopedValueState.deactivate] of the retained state is executed.
  ///
  /// [ScopedValueContainer]が破棄される直前に呼ばれます。
  ///
  /// 保持している状態の[ScopedValueState.deactivate]が実行されます。
  void diactivate() {
    for (final val in _data.values) {
      val.deactivate();
    }
  }

  /// Called when [ScopedValueContainer] is destroyed.
  ///
  /// ScopedValueState.dispose] of the retained state is executed.
  ///
  /// [ScopedValueContainer]が破棄される歳に呼ばれます。
  ///
  /// 保持している状態の[ScopedValueState.dispose]が実行されます。
  void dispose() {
    for (final val in _data.values) {
      val.dispose();
    }
    _data.clear();
  }
}
