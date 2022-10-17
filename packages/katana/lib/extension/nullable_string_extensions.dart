part of katana;

/// Provides an extension method for [String] that is nullable.
///
/// Nullableな[String]用の拡張メソッドを提供します。
extension NullableStringExtensions on String? {
  /// Whether this string is empty.
  ///
  /// Returns `true` if itself is [Null].
  ///
  /// この文字列が空かどうかを調べます。
  ///
  /// 自身が[Null]の場合`true`を返します。
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.isEmpty;
  }

  /// Whether this string is not empty.
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// この文字列が空でないかどうかを調べます。
  ///
  /// 自身が[Null]の場合`false`を返します。
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.isNotEmpty;
  }

  /// The length of the string.
  ///
  /// Returns the number of UTF-16 code units in this string. The number of [runes] might be fewer if the string contains characters outside the Basic Multilingual Plane (plane 0):
  ///
  /// 文字列の長さを返します。
  ///
  /// この文字列の UTF-16 コード単位の数を返します。 文字列に Basic Multilingual Plane (プレーン 0) 以外の文字が含まれている場合、[runes] の数は少なくなる可能性があります。
  ///
  /// ```dart
  /// 'Dart'.length;          // 4
  /// 'Dart'.runes.length;    // 4
  ///
  /// var clef = '\u{1D11E}';
  /// clef.length;            // 2
  /// clef.runes.length;      // 1
  /// ```
  ///
  /// Returns `0` if itself is [Null].
  ///
  /// 自身が[Null]の場合`0`を返します。
  int get length {
    if (this == null) {
      return 0;
    }
    return this!.length;
  }

  /// Converts a [String] to a type that can be parsed as [bool], [int], or [double], in that order, and returns the type as is.
  ///
  /// If it cannot be converted, it is returned as [String].
  ///
  /// [String]を[bool]、[int]、[double]の順でパースできる型に変換しその型のまま返します。
  ///
  /// 変換できない場合は[String]のまま返されます。
  ///
  /// ```dart
  /// final text = "100";
  /// final any = text.toAny(); // 100 (int)
  /// final text = "100.9";
  /// final any = text.toAny(); // 100.9 (double)
  /// final text = "false";
  /// final any = text.toAny(); // false (bool)
  /// final text = "abc100";
  /// final any = text.toAny(); // "abc100" (String)
  /// ```
  ///
  /// Returns `null` if itself is [Null].
  ///
  /// 自身が[Null]の場合`null`を返します。
  dynamic toAny() {
    if (this == null) {
      return null;
    }
    if (isEmpty) {
      return "";
    }
    final b = this!.toLowerCase();
    if (b == "true") {
      return true;
    } else if (b == "false") {
      return false;
    }
    final i = int.tryParse(this!);
    if (i != null) {
      return i;
    }
    final d = double.tryParse(this!);
    if (d != null) {
      return d;
    }
    return this;
  }
}
