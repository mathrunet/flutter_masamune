part of '/katana.dart';

/// Provides extended methods for [bool].
///
/// [bool]用の拡張メソッドを提供します。
extension BooleanExtensions on bool {
  /// Executes and returns either [onTrue] or [onFalse] for [bool].
  ///
  /// [bool]に対して[onTrue]と[onFalse]のどちらかを実行して返します。
  T select<T>({
    required T Function() onTrue,
    required T Function() onFalse,
  }) {
    if (this) {
      return onTrue.call();
    } else {
      return onFalse.call();
    }
  }
}
