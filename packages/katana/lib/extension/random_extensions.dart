part of katana;

/// Provides extended methods for [Random].
/// [Random]用の拡張メソッドを提供します。
extension RandomExtensions on Random {
  /// Get a random [int] `value` where [min] <= `value` < [max].
  /// [min] <= `value` < [max]のランダムな[int]`value`を取得します。
  int rangeInt(int min, int max) =>
      ((nextDouble() * (max - min)) + min).toInt().limit(min, max);

  /// Get a random [double] `value` where [min] <= `value` < [max].
  /// [min] <= `value` < [max]のランダムな[double]`value`を取得します。
  double rangeDouble(double min, double max) =>
      ((nextDouble() * (max - min)) + min).limit(min, max);
}
