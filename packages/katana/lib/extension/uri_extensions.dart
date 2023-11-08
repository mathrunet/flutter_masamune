part of '/katana.dart';

/// Provides extended methods for [Uri].
///
/// [Uri]用の拡張メソッドを提供します。
extension UriExtensions on Uri {
  static final RegExp _tail = RegExp(r"[^/]+$");

  /// Divides [Uri] by [separator] and returns the number of elements.
  ///
  /// [Uri]を[separator]で分割し、その要素数を返します。
  ///
  /// ```dart
  /// final path = Uri.parse("aaaa/bbbb/cccc/dddd");
  /// final length = path.splitLength(); // 4
  /// ```
  int splitLength({String separator = "/"}) {
    if (isEmpty) {
      return 0;
    }
    final path = toString();
    final paths = path.split(separator);
    final length = paths.length;
    return length;
  }

  /// [Uri] is divided by [separator] and moved one level up.
  ///
  /// [Uri]を[separator]で分割し一つ上の階層に移動します。
  ///
  /// ```dart
  /// final path = Uri.parse("aaaa/bbbb/cccc/dddd");
  /// final parentPath = path.parentPath(); // "aaaa/bbbb/cccc"
  /// ```
  Uri parentPath({String separator = "/"}) {
    if (isEmpty) {
      return this;
    }
    final path = toString().trimString(separator);
    return Uri.parse(path.replaceAll(_tail, "").trimStringRight(separator));
  }

  /// Trims [Uri] query characters (after ?).
  ///
  /// [Uri]のクエリ文字（?以降）をトリムします。
  ///
  /// ```dart
  /// final url = Uri.parse("https://google.com?q=searchtext");
  /// final trimed = url.trimQuery(); // "https://google.com"
  /// ```
  Uri trimQuery() {
    final path = toString();
    if (!path.contains("?")) {
      return this;
    }
    return Uri.parse(path.split("?").first);
  }

  /// Divides a [Uri] by [separator] and returns the first part.
  ///
  /// [Uri]を[separator]で分割しその最初の部分を返します。
  ///
  /// ```dart
  /// final path = Uri.parse("aaaa/bbbb/cccc/dddd");
  /// final first = path.first(); // aaaa
  /// ```
  String first({String separator = "/"}) {
    return toString().split(separator).firstOrNull ?? "";
  }

  /// Divides a [Uri] by [separator] and returns the last part.
  ///
  /// [Uri]を[separator]で分割しその最後の部分を返します。
  ///
  /// ```dart
  /// final path = Uri.parse("aaaa/bbbb/cccc/dddd");
  /// final first = path.first(); // dddd
  /// ```
  String last({String separator = "/"}) {
    return toString().split(separator).lastOrNull ?? "";
  }
}
