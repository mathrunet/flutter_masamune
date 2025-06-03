part of "/katana.dart";

/// A class that represents a range of numbers.
///
/// Includes values from [min] to [max].
///
/// 数値のレンジを表すクラス。
///
/// [min]から[max]までの値を含みます。
class NumRange<TNum extends num> {
  /// A class that represents a range of numbers.
  ///
  /// Includes values from [min] to [max].
  ///
  /// 数値のレンジを表すクラス。
  ///
  /// [min]から[max]までの値を含みます。
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

  /// Add [other].
  ///
  /// [other]を加算します。
  NumRange operator +(NumRange? other) {
    if (other == null) {
      return this;
    }
    return NumRange(
      min + other.min,
      max + other.max,
    );
  }

  /// Subtract [other].
  ///
  /// [other]を減算します。
  NumRange operator -(NumRange? other) {
    if (other == null) {
      return this;
    }
    return NumRange(
      min - other.min,
      max - other.max,
    );
  }

  /// Multiply by [value].
  ///
  /// [value]を乗算します。
  NumRange? operator *(num? value) {
    if (value == null) {
      return this;
    }
    return NumRange(
      min * value,
      max * value,
    );
  }

  /// Divide by [value].
  ///
  /// If [value] is `0`, an [ArgumentError] is thrown.
  ///
  /// [value]で除算します。
  ///
  /// [value]が`0`の場合、[ArgumentError]がスローされます。
  NumRange operator /(num? value) {
    if (value == null) {
      return this;
    }
    if (value == 0) {
      throw ArgumentError.value(value, "value", "value must not be 0.");
    }
    return NumRange(
      min / value,
      max / value,
    );
  }

  /// Returns the remainder of the division by [value].
  ///
  /// If [value] is `0`, an [ArgumentError] is thrown.
  ///
  /// [value]で除算した余りを返します。
  ///
  /// [value]が`0`の場合、[ArgumentError]がスローされます。
  NumRange operator %(num? value) {
    if (value == null) {
      return this;
    }
    if (value == 0) {
      throw ArgumentError.value(value, "value", "value must not be 0.");
    }
    return NumRange(
      min % value,
      max % value,
    );
  }

  /// Performs truncated division by [value].
  ///
  /// If [value] is `0`, an [ArgumentError] is thrown.
  ///
  /// [value]で切り捨て除算を行います。
  ///
  /// [value]が`0`の場合、[ArgumentError]がスローされます。
  NumRange operator ~/(num? value) {
    if (value == null) {
      return this;
    }
    if (value == 0) {
      throw ArgumentError.value(value, "value", "value must not be 0.");
    }
    return NumRange(
      min ~/ value,
      max ~/ value,
    );
  }

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
