part of '/katana_scoped.dart';

/// Container object for storing [ScopedValue].
///
/// It is usually called via [ScopedValueListener].
///
/// A database of [ScopedValue] is maintained internally, and the corresponding [ScopedValueState] can be read and edited by [getScopedValueState].
///
/// It inherits from [ChangeNotifier] and can monitor changes in its contents.
///
/// The contents cannot be changed directly, but can be viewed at [data].
///
/// [ScopedValue]を保存するためのコンテナオブジェクト。
///
/// 通常は[ScopedValueListener]を介して呼び出されます。
///
/// 内部に[ScopedValue]のデータベースを保持しており、[getScopedValueState]で[ScopedValue]に対応する[ScopedValueState]を読込み編集を加えることが可能です。
///
/// [ChangeNotifier]を継承しており、中身の変更を監視できます。
///
/// 中身は直接変更することができませんが[data]で中身を確認することが可能です。
class ScopedValueContainer extends ChangeNotifier {
  /// Container object for storing [ScopedValue].
  ///
  /// It is usually called via [ScopedValueListener].
  ///
  /// A database of [ScopedValue] is maintained internally, and the corresponding [ScopedValueState] can be read and edited by [getScopedValueState].
  ///
  /// It inherits from [ChangeNotifier] and can monitor changes in its contents.
  ///
  /// The contents cannot be changed directly, but can be viewed at [data].
  ///
  /// [ScopedValue]を保存するためのコンテナオブジェクト。
  ///
  /// 通常は[ScopedValueListener]を介して呼び出されます。
  ///
  /// 内部に[ScopedValue]のデータベースを保持しており、[getScopedValueState]で[ScopedValue]に対応する[ScopedValueState]を読込み編集を加えることが可能です。
  ///
  /// [ChangeNotifier]を継承しており、中身の変更を監視できます。
  ///
  /// 中身は直接変更することができませんが[data]で中身を確認することが可能です。
  ScopedValueContainer();

  /// It is possible to check the contents of [ScopedValueContainer].
  ///
  /// [ScopedValueContainer]の中身を確認することが可能です。
  Map<String, ScopedValueState> get data {
    return Map.from(_data);
  }

  final Map<String, ScopedValueState> _data = {};

  /// By passing a callback that returns [TScopedValue] to [provider], it creates a state for that [ScopedValue] and performs the appropriate processing, returning [ScopedValueState].
  ///
  /// Keys are stored in `TScopedValue/name` and the state is maintained for each key.
  ///
  /// If the key is searched and the already created state does not exist, a new state is created and [ScopedValueState.initValue] is executed to save the state.
  ///
  /// If the state has already been created, [ScopedValueState.didUpdateValue] is executed and the value is returned.
  ///
  /// [onInit] and [onUpdate] are executed just before [ScopedValueState.initValue] and [ScopedValueState.didUpdateValue] are executed.
  ///
  /// [provider]に[TScopedValue]を返すコールバックを渡すことでその[ScopedValue]のステートを作成しつつ適切な処理を行い[ScopedValueState]を返します。
  ///
  /// `TScopedValue/name`でキーが保存されており、そのキーごとに状態が保持されます。
  ///
  /// キーを検索しすでに作成済みの状態が存在しない場合は新しく状態を作成し[ScopedValueState.initValue]を実行して状態を保存します。
  ///
  /// すでに作成済みの状態が存在する場合は[ScopedValueState.didUpdateValue]を実行して値を返します。
  ///
  /// [ScopedValueState.initValue]や[ScopedValueState.didUpdateValue]を実行する直前に[onInit]や[onUpdate]が実行されます。
  ScopedValueState<TResult, ScopedValue<TResult>>
      getScopedValueState<TResult, TScopedValue extends ScopedValue<TResult>>(
    TScopedValue Function() provider, {
    void Function(ScopedValueState<TResult, TScopedValue> state)? onInit,
    void Function(ScopedValueState<TResult, TScopedValue> state)? onUpdate,
    Object? name,
    ScopedLoggerScope? scope,
    String? managedBy,
    List<LoggerAdapter> loggerAdapters = const [],
  }) {
    final key = "$TScopedValue/${name.hashCode}";
    final found = _data[key];
    if (found != null) {
      assert(
        found is ScopedValueState<TResult, TScopedValue>,
        "The stored [value] type is incorrect: ${found.runtimeType}",
      );
      final state = found as ScopedValueState<TResult, TScopedValue>;
      final oldValue = state.value;
      state._setValue(provider.call());
      onUpdate?.call(state);
      found.didUpdateValue(oldValue);
      notifyListeners();
      return state;
    } else {
      final value = provider.call();
      final state =
          value.createState() as ScopedValueState<TResult, TScopedValue>;
      state._setValue(value);
      state._setLoggers(
        loggerAdapters: loggerAdapters,
        baseParameters: {
          if (scope != null) ScopedLoggerEvent.scopeKey: scope.name,
          ScopedLoggerEvent.typeKey: TScopedValue.toString(),
          ScopedLoggerEvent.nameKey: name,
          if (managedBy != null) ScopedLoggerEvent.managedKey: managedBy,
        },
      );
      onInit?.call(state);
      state.initValue();
      _data[key] = state;
      notifyListeners();
      return state;
    }
  }

  /// Get the [ScopedValueState] associated with the [TScopedValue] already stored in the [ScopedValueContainer].
  ///
  /// Returns [Null] if [TScopedValue] does not exist.
  ///
  /// If [TScopedValue] was saved with [name], specify the same [name].
  ///
  /// [ScopedValueState.setState], [ScopedValueState.initValue] and [ScopedValueState.didUpdateValue] are not executed.
  ///
  /// The [onUpdate] is executed before the value is returned.
  ///
  /// [ScopedValueContainer]にすでに保存されている[TScopedValue]に関連する[ScopedValueState]を取得します。
  ///
  /// [TScopedValue]が存在しない場合は[Null]を返します。
  ///
  /// [name]を指定して[TScopedValue]を保存していた場合、同じ[name]を指定してください。
  ///
  /// [ScopedValueState.setState]や[ScopedValueState.initValue]、[ScopedValueState.didUpdateValue]は実行されません。
  ///
  /// 値が返される前に[onUpdate]が実行されます。
  ScopedValueState<TResult, ScopedValue<TResult>>?
      getAlreadyExistsScopedValueState<TResult,
          TScopedValue extends ScopedValue<TResult>>({
    Object? name,
    void Function(ScopedValueState<TResult, TScopedValue> state)? onUpdate,
  }) {
    final key = "$TScopedValue/${name.hashCode}";
    final found = _data[key];
    if (found != null) {
      assert(
        found is ScopedValueState<TResult, TScopedValue>,
        "The stored [value] type is incorrect: ${found.runtimeType}",
      );
      final state = found as ScopedValueState<TResult, TScopedValue>;
      onUpdate?.call(state);
      return state;
    } else {
      return null;
    }
  }

  /// The contents of [ScopedValueContainer] are discarded and reset once.
  ///
  /// ScopedValueState.dispose] of the retained state is executed.
  ///
  /// [ScopedValueContainer]の中身を破棄し一旦リセットします。
  ///
  /// 保持している状態の[ScopedValueState.dispose]が実行されます。
  void reset() {
    for (final val in _data.values) {
      if (val.disposed) {
        continue;
      }
      val.dispose();
    }
    _data.clear();
  }

  /// If [state] exists in [ScopedValueContainer], it is discarded and deleted.
  ///
  /// [ScopedValueContainer]の中に[state]が存在する場合、その[state]を破棄し削除します。
  void remove(ScopedValueState state) {
    _data.removeWhere((key, value) {
      if (value == state) {
        if (!value.disposed) {
          value.dispose();
        }
        return true;
      }
      return false;
    });
  }

  /// Called when [ScopedValueContainer] is destroyed.
  ///
  /// ScopedValueState.dispose] of the retained state is executed.
  ///
  /// [ScopedValueContainer]が破棄される歳に呼ばれます。
  ///
  /// 保持している状態の[ScopedValueState.dispose]が実行されます。
  @override
  void dispose() {
    super.dispose();
    reset();
  }
}
