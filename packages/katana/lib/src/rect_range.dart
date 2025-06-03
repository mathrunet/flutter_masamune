part of "/katana.dart";

/// A class that represents a range of numbers.
///
/// Includes values from [min] to [max].
///
/// 数値のレンジを表すクラス。
///
/// [minX]から[maxX]までの値を含みます。
class RectRange<TNum extends num> {
  /// A class that represents a range of numbers.
  ///
  /// Includes values from [min] to [max].
  ///
  /// 数値のレンジを表すクラス。
  ///
  /// [minX]から[maxX]までの値を含みます。
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

  /// Add [other].
  ///
  /// [other]を加算します。
  RectRange operator +(RectRange? other) {
    if (other == null) {
      return this;
    }
    return RectRange(
      minX: minX + other.minX,
      maxX: maxX + other.maxX,
      minY: minY + other.minY,
      maxY: maxY + other.maxY,
    );
  }

  /// Subtract [other].
  ///
  /// [other]を減算します。
  RectRange operator -(RectRange? other) {
    if (other == null) {
      return this;
    }
    return RectRange(
      minX: minX - other.minX,
      maxX: maxX - other.maxX,
      minY: minY - other.minY,
      maxY: maxY - other.maxY,
    );
  }

  /// Multiply by [value].
  ///
  /// [value]を乗算します。
  RectRange? operator *(num? value) {
    if (value == null) {
      return this;
    }
    return RectRange(
      minX: minX * value,
      maxX: maxX * value,
      minY: minY * value,
      maxY: maxY * value,
    );
  }

  /// Divide by [value].
  ///
  /// If [value] is `0`, an [ArgumentError] is thrown.
  ///
  /// [value]で除算します。
  ///
  /// [value]が`0`の場合、[ArgumentError]がスローされます。
  RectRange operator /(num? value) {
    if (value == null) {
      return this;
    }
    if (value == 0) {
      throw ArgumentError.value(value, "value", "value must not be 0.");
    }
    return RectRange(
      minX: minX / value,
      maxX: maxX / value,
      minY: minY / value,
      maxY: maxY / value,
    );
  }

  /// Returns the remainder of the division by [value].
  ///
  /// If [value] is `0`, an [ArgumentError] is thrown.
  ///
  /// [value]で除算した余りを返します。
  ///
  /// [value]が`0`の場合、[ArgumentError]がスローされます。
  RectRange operator %(num? value) {
    if (value == null) {
      return this;
    }
    if (value == 0) {
      throw ArgumentError.value(value, "value", "value must not be 0.");
    }
    return RectRange(
      minX: minX % value,
      maxX: maxX % value,
      minY: minY % value,
      maxY: maxY % value,
    );
  }

  /// Performs truncated division by [value].
  ///
  /// If [value] is `0`, an [ArgumentError] is thrown.
  ///
  /// [value]で切り捨て除算を行います。
  ///
  /// [value]が`0`の場合、[ArgumentError]がスローされます。
  RectRange operator ~/(num? value) {
    if (value == null) {
      return this;
    }
    if (value == 0) {
      throw ArgumentError.value(value, "value", "value must not be 0.");
    }
    return RectRange(
      minX: minX ~/ value,
      maxX: maxX ~/ value,
      minY: minY ~/ value,
      maxY: maxY ~/ value,
    );
  }

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
