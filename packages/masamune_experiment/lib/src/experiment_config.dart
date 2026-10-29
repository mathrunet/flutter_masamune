part of "/masamune_experiment.dart";

/// Values passed to the first callback of [Experiment.run].
///
/// It has the same getters as [FirebaseRemoteConfig] and converts values with the same rules.
/// Undefined keys return `false`, `0`, `0.0` and `""`.
///
/// All values are read synchronously from the memory, so load them in advance with [Experiment.load].
///
/// [Experiment.run]の最初のコールバックに渡される値。
///
/// [FirebaseRemoteConfig]と同じゲッターを持ち、同じ規則で値を変換します。
/// 未定義のキーは`false`、`0`、`0.0`、`""`を返します。
///
/// すべての値はメモリから同期的に読み出されるため、[Experiment.load]で事前に読み込んでおいてください。
@immutable
class ExperimentConfig {
  /// Values passed to the first callback of [Experiment.run].
  ///
  /// Pass the values in [values].
  ///
  /// [Experiment.run]の最初のコールバックに渡される値。
  ///
  /// [values]に値を渡してください。
  const ExperimentConfig(Map<String, Object?> values) : _values = values;

  static const List<String> _trueValues = [
    "1",
    "true",
    "t",
    "yes",
    "y",
    "on",
  ];

  final Map<String, Object?> _values;

  /// Returns `true` if [key] exists.
  ///
  /// [key]が存在する場合`true`を返します。
  bool containsKey(String key) => _values.containsKey(key);

  /// Get all values.
  ///
  /// すべての値を取得します。
  Map<String, Object?> getAll() => Map.unmodifiable(_values);

  /// Get the value of [key] as [String].
  ///
  /// Returns `""` if [key] does not exist.
  ///
  /// [key]の値を[String]として取得します。
  ///
  /// [key]が存在しない場合は`""`を返します。
  String getString(String key) => _values[key]?.toString() ?? "";

  /// Get the value of [key] as [bool].
  ///
  /// Returns `true` only if the value is one of `1`, `true`, `t`, `yes`, `y` and `on`.
  ///
  /// [key]の値を[bool]として取得します。
  ///
  /// 値が`1`、`true`、`t`、`yes`、`y`、`on`のいずれかの場合のみ`true`を返します。
  bool getBool(String key) {
    final value = _values[key];
    if (value is bool) {
      return value;
    }
    return _trueValues.contains(getString(key).toLowerCase());
  }

  /// Get the value of [key] as [int].
  ///
  /// Returns `0` if the value cannot be converted.
  ///
  /// [key]の値を[int]として取得します。
  ///
  /// 変換できない場合は`0`を返します。
  int getInt(String key) {
    final value = _values[key];
    if (value is int) {
      return value;
    }
    return int.tryParse(getString(key)) ?? 0;
  }

  /// Get the value of [key] as [double].
  ///
  /// Returns `0.0` if the value cannot be converted.
  ///
  /// [key]の値を[double]として取得します。
  ///
  /// 変換できない場合は`0.0`を返します。
  double getDouble(String key) {
    final value = _values[key];
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(getString(key)) ?? 0.0;
  }
}
