part of '/masamune.dart';

/// Abstract class to inherit when you want to create a controller using [MasamuneAdapter].
///
/// Specify the value to manage in [TValue], and specify [MasamuneAdapter] in [TAdapter].
///
/// If you do not specify [adapter], [primaryAdapter] is used.
///
/// Since it inherits [ChangeNotifier], you can use [addListener] and [removeListener] to monitor changes in the value.
///
/// [MasamuneAdapter]を利用したコントローラーを作成したい場合に継承する抽象クラスです。
///
/// [TValue]に管理する値を指定し、[TAdapter]に[MasamuneAdapter]を指定します。
///
/// [adapter]を指定しない場合は、[primaryAdapter]を使用します。
///
/// [ChangeNotifier]を継承しているので、[addListener]や[removeListener]を使用して値の変更を監視できます。
abstract class MasamuneControllerBase<TValue, TAdapter extends MasamuneAdapter>
    extends ChangeNotifier implements ValueListenable<TValue?> {
  /// Abstract class to inherit when you want to create a controller using [MasamuneAdapter].
  ///
  /// Specify the value to manage in [TValue], and specify [MasamuneAdapter] in [TAdapter].
  ///
  /// If you do not specify [adapter], [primaryAdapter] is used.
  ///
  /// Since it inherits [ChangeNotifier], you can use [addListener] and [removeListener] to monitor changes in the value.
  ///
  /// [MasamuneAdapter]を利用したコントローラーを作成したい場合に継承する抽象クラスです。
  ///
  /// [TValue]に管理する値を指定し、[TAdapter]に[MasamuneAdapter]を指定します。
  ///
  /// [adapter]を指定しない場合は、[primaryAdapter]を使用します。
  ///
  /// [ChangeNotifier]を継承しているので、[addListener]や[removeListener]を使用して値の変更を監視できます。
  MasamuneControllerBase({TAdapter? adapter, TValue? defaultValue})
      : _adapter = adapter,
        _value = defaultValue;

  /// [TAdapter] to be used.
  ///
  /// If not specified, [primaryAdapter] is used.
  ///
  /// 使用する[TAdapter]。
  ///
  /// 指定されない場合は[primaryAdapter]が利用されます。
  TAdapter get adapter {
    return _adapter ?? primaryAdapter;
  }

  final TAdapter? _adapter;

  /// Specifies the default [TAdapter] if [adapter] is [Null].
  ///
  /// [adapter]が[Null]だった場合のデフォルトの[TAdapter]を指定します。
  TAdapter get primaryAdapter;

  @override
  TValue? get value => _value;

  /// Set method is used to update the current state.
  ///
  /// The argument [value] is the value of the new state.
  /// If it matches the existing value, nothing is done and the process ends.
  ///
  /// セットメソッドを使用して、現在のステートを更新します。
  ///
  /// 引数 [value] は、新しいステートの値です。
  /// 既存の値と一致する場合は何も行われず、処理が終了します。
  @protected
  void setValueInternal(TValue? value) {
    if (_value == value) {
      return;
    }
    _value = value;
  }

  TValue? _value;
}
