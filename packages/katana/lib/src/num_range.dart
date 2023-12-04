part of '/katana.dart';

/// A class that represents a range of numbers.
///
/// Includes values from [min] to [max].
///
/// 数値のレンジを表すクラス。
///
/// [min]から[max]までの値を含みます。
class NumRange<TNum extends num> {
  const NumRange(
    this.min,
    this.max,
  ) : assert(min <= max, "min must be less than or equal to max.");

  /// Starting value.
  ///
  /// 開始の値。
  final TNum min;

  /// Exit value.
  ///
  /// 終了の値。
  final TNum max;

  /// Returns `true` if the value is in the range.
  ///
  /// 値がレンジ内にある場合は`true`を返します。
  bool contains(num value) => value >= min && value < max;

  @override
  String toString() {
    return "$runtimeType($min, $max)";
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => min.hashCode ^ max.hashCode;
}
