part of katana;

/// Provides extended methods for [double].
///
/// [double]用の拡張メソッドを提供します。
extension DoubleExtensions on double {
  /// Returns `true` if [double] is `0`.
  ///
  /// [double]が`0`の場合`true`を返します。
  bool get isEmpty => this == 0.0;

  /// Returns `true` if [double] is not `0`.
  ///
  /// [double]が`0`でない場合`true`を返します。
  bool get isNotEmpty => this != 0.0;

  /// If [double] is [double.nan], [double.infinity], or [double.negativeInfinity], replace it with [replace].
  ///
  /// [double]が[double.nan]か[double.infinity]、[double.negativeInfinity]の場合[replace]に置き換えます。
  double replaceNanOrInfinite([double replace = 0.0]) {
    if (isNaN || isInfinite) {
      return replace;
    }
    return this;
  }

  /// If [double] is less than or equal to [min], [min] is returned.
  ///
  /// If [double] is greater than or equal to [max], [max] is returned.
  ///
  /// If [double.nan], [min] is returned.
  ///
  /// [double]が[min]以下の場合は[min]が返されます。
  ///
  /// [double]が[max]以上の場合は[max]が返されます。
  ///
  /// [double.nan]の場合は[min]が返されます。
  double limit(double min, double max) {
    if (isNaN || this < min) {
      return min;
    }
    if (this > max) {
      return max;
    }
    return this;
  }

  /// If [double] is less than or equal to [min], [min] is returned.
  ///
  /// If [double.nan], [min] is returned.
  ///
  /// [double]が[min]以下の場合は[min]が返されます。
  ///
  /// [double.nan]の場合は[min]が返されます。
  double limitLow(double min) {
    if (isNaN || this < min) {
      return min;
    }
    return this;
  }

  /// If [double] is greater than or equal to [max], [max] is returned.
  ///
  /// If [double.nan], [max] is returned.
  ///
  /// [double]が[max]以上の場合は[max]が返されます。
  ///
  /// [double.nan]の場合は[max]が返されます。
  double limitHigh(double max) {
    if (isNaN || this > max) {
      return max;
    }
    return this;
  }

  /// Enter [format] to replace the value of [double] with a string.
  ///
  /// The following patterns can be used for [format].
  ///
  /// [format]を入力して[double]の値を文字列に置き換えます。
  ///
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
  /// final d = 12.343;
  /// print(d.format("###.0#")); // 12.34
  /// ```
  ///
  /// Please note that decimal points will be **rounded**.
  ///
  /// 小数点を丸めるときは**四捨五入**されますのでご注意ください。
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    return NumberFormat(format).format(this);
  }
}
