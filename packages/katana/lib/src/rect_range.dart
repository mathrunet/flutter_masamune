part of '/katana.dart';

/// A class that represents a range of numbers.
///
/// Includes values from [min] to [max].
///
///
class RectRange<TNum extends num> {
  const RectRange({
    required this.minX,
    required this.maxX,
    required this.minY,
    required this.maxY,
  })  : assert(minX <= maxX, "minX must be less than or equal to maxX."),
        assert(minY <= maxY, "minY must be less than or equal to maxY.");

  /// Minimum value on the X axis.
  ///
  /// X軸の最小値。
  final TNum minX;

  /// Maximum value on the X axis.
  ///
  /// X軸の最大値。
  final TNum maxX;

  /// Minimum value on the Y axis.
  ///
  /// Y軸の最小値。
  final TNum minY;

  /// Maximum value on the Y axis.
  ///
  /// Y軸の最大値。
  final TNum maxY;

  /// Returns `true` if the value is in the range.
  ///
  /// 値がレンジ内にある場合は`true`を返します。
  bool contains(num x, num y) => x >= minX && x < maxX && y >= minY && y < maxY;

  @override
  String toString() {
    return "$runtimeType($minX, $maxX, $minY, $maxY)";
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode =>
      minX.hashCode ^ maxX.hashCode ^ minY.hashCode ^ maxY.hashCode;
}
