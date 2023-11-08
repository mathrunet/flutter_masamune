part of '/katana.dart';

/// Provides an extension method for [double] that is nullable.
///
/// Nullableな[double]用の拡張メソッドを提供します。
extension NullableDoubleExtensions on double? {
  /// Returns `true` if [double] is [null] or `0`.
  ///
  /// [double]が[Null]、もしくは`0`の場合`true`を返します。
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this == 0.0;
  }

  /// Returns `true` if [double] is not [Null] or `0`.
  ///
  /// [double]が[Null]、もしくは`0`でない場合`true`を返します。
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this != 0.0;
  }

  /// Performs addition with a nullable [double] value.
  ///
  /// If both are [Null], [Null] is returned.
  ///
  /// If only one of them is [Null], a non-null value is returned.
  ///
  /// Nullableな[double]値での加算を行います。
  ///
  /// 両方が[Null]の場合は[Null]が返されます。
  ///
  /// どちらかのみが[Null]の場合、[Null]でない値が返されます。
  double? operator +(num? other) {
    if (this == null) {
      return other?.toDouble();
    }
    if (other == null) {
      return this;
    }
    return this! + other;
  }

  /// Performs subtraction with a nullable [double] value.
  ///
  /// If both are [Null], [Null] is returned.
  ///
  /// If only one of them is [Null], a non-null value is returned.
  ///
  /// Nullableな[double]値での減算を行います。
  ///
  /// 両方が[Null]の場合は[Null]が返されます。
  ///
  /// どちらかのみが[Null]の場合、[Null]でない値が返されます。
  double? operator -(num? other) {
    if (this == null) {
      return other?.toDouble();
    }
    if (other == null) {
      return this;
    }
    return this! - other;
  }

  /// Performs multiplication by a nullable [double] value.
  ///
  /// If both are [Null], [Null] is returned.
  ///
  /// If only one of them is [Null], a non-null value is returned.
  ///
  /// Nullableな[double]値での乗算を行います。
  ///
  /// 両方が[Null]の場合は[Null]が返されます。
  ///
  /// どちらかのみが[Null]の場合、[Null]でない値が返されます。
  double? operator *(num? other) {
    if (this == null) {
      return other?.toDouble();
    }
    if (other == null) {
      return this;
    }
    return this! * other;
  }

  /// Performs division by a nullable [double] value.
  ///
  /// If both are [Null], [Null] is returned.
  ///
  /// If only one of them is [Null], a non-null value is returned.
  ///
  /// Nullableな[double]値での除算を行います。
  ///
  /// 両方が[Null]の場合は[Null]が返されます。
  ///
  /// どちらかのみが[Null]の場合、[Null]でない値が返されます。
  double? operator /(num? other) {
    if (this == null) {
      return other?.toDouble();
    }
    if (other == null) {
      return this;
    }
    return this! / other;
  }

  /// Performs remainder operations on nullable [double] values.
  ///
  /// If both are [Null], [Null] is returned.
  ///
  /// If only one of them is [Null], a non-null value is returned.
  ///
  /// Nullableな[double]値での剰余演算を行います。
  ///
  /// 両方が[Null]の場合は[Null]が返されます。
  ///
  /// どちらかのみが[Null]の場合、[Null]でない値が返されます。
  double? operator %(num? other) {
    if (this == null) {
      return other?.toDouble();
    }
    if (other == null) {
      return this;
    }
    return this! % other;
  }

  /// Performs truncated division by a nullable [double] value.
  ///
  /// If both are [Null], [Null] is returned.
  ///
  /// If only one of them is [Null], a non-null value is returned.
  ///
  /// Nullableな[double]値での切り捨て除算を行います。
  ///
  /// 両方が[Null]の場合は[Null]が返されます。
  ///
  /// どちらかのみが[Null]の場合、[Null]でない値が返されます。
  int? operator ~/(num? other) {
    if (this == null) {
      return other?.toInt();
    }
    if (other == null) {
      return this?.toInt();
    }
    return this! ~/ other;
  }
}
