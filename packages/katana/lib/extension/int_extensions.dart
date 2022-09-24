part of katana;

/// Provides extended methods for [int].
/// [int]用の拡張メソッドを提供します。
extension IntExtensions on int {
  /// Returns `true` if [int] is `0`.
  /// [int]が`0`の場合`true`を返します。
  bool get isEmpty => this == 0;

  /// Returns `true` if [int] is not `0`.
  /// [int]が`0`でない場合`true`を返します。
  bool get isNotEmpty => this != 0;

  /// If [int] is [double.nan], [double.infinity], or [double.negativeInfinity], replace it with [replace].
  /// [int]が[double.nan]か[double.infinity]、[double.negativeInfinity]の場合[replace]に置き換えます。
  int replaceNanOrInfinite([int replace = 0]) {
    if (isNaN || isInfinite) {
      return replace;
    }
    return this;
  }

  /// If [int] is less than or equal to [min], [min] is returned.
  /// [int]が[min]以下の場合は[min]が返されます。
  ///
  /// If [int] is greater than or equal to [max], [max] is returned.
  /// [int]が[max]以上の場合は[max]が返されます。
  ///
  /// If [double.nan], [min] is returned.
  /// [double.nan]の場合は[min]が返されます。
  int limit(int min, int max) {
    if (this < min) {
      return min;
    }
    if (this > max) {
      return max;
    }
    return this;
  }

  /// If [int] is less than or equal to [min], [min] is returned.
  /// [int]が[min]以下の場合は[min]が返されます。
  ///
  /// If [double.nan], [min] is returned.
  /// [double.nan]の場合は[min]が返されます。
  int limitLow(int min) {
    if (this < min) {
      return min;
    }
    return this;
  }

  /// If [int] is greater than or equal to [max], [max] is returned.
  /// [int]が[max]以上の場合は[max]が返されます。
  ///
  /// If [double.nan], [max] is returned.
  /// [double.nan]の場合は[max]が返されます。
  int limitHigh(int max) {
    if (this > max) {
      return max;
    }
    return this;
  }

  /// Enter [format] to replace the value of [int] with a string.
  /// [format]を入力して[int]の値を文字列に置き換えます。
  ///
  /// The following patterns can be used for [format].
  /// [format]には下記のパターンを使用することが可能です。
  ///
  /// - `0` A single digit
  /// - `#` A single digit, omitted if the value is zero
  /// - `.` Decimal separator
  /// - `-` Minus sign
  /// - `,` Grouping separator
  /// - `E` Separates mantissa and expontent
  /// - `+` - Before an exponent, to say it should be prefixed with a plus sign.
  /// - `%` - In prefix or suffix, multiply by 100 and show as percentage
  /// - `‰ (\u2030)` In prefix or suffix, multiply by 1000 and show as per mille
  /// - `¤ (\u00A4)` Currency sign, replaced by currency name
  /// - `'` Used to quote special characters
  /// - `;` Used to separate the positive and negative patterns (if both present)
  ///
  /// For example,
  ///
  /// ```dart
  /// final i = 12;
  /// print(i.format("000")); // 012
  /// ```
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    return NumberFormat(format).format(this);
  }
}
