part of '/masamune_builder.dart';

final _pathRegExp = RegExp(r":([^/]+)");

/// Value for path.
///
/// Specify the path given in the annotation in [path].
///
/// パス用の値。
///
/// [path]にアノテーションに与えられたパスを指定します。
class PathValue {
  /// Value for path.
  ///
  /// Specify the path given in the annotation in [path].
  ///
  /// パス用の値。
  ///
  /// [path]にアノテーションに与えられたパスを指定します。
  PathValue(this.path) {
    parameters = _pathRegExp.allMatches(path).mapAndRemoveEmpty(
          (e) => _PathValue(e.group(1)!),
        );
  }

  /// Path value.
  ///
  /// パスの値。
  late final String path;

  /// Parameters specified in the path.
  ///
  /// パスに指定されたパラメーター。
  // ignore: library_private_types_in_public_api
  late final List<_PathValue> parameters;

  /// Outputs paths for rules.
  ///
  /// ルール用のパスを出力します。
  String get rulePath {
    final paths =
        path.trimQuery().trimString("/").replaceAllMapped(_pathRegExp, (match) {
      final key = match.group(1);
      if (key.isEmpty) {
        throw Exception("Key is empty.");
      }
      return "{${key!.toCamelCase()}}";
    }).split("/");
    if (paths.length % 2 == 0) {
      paths.removeLast();
      paths.add("{uid}");
      return paths.join("/");
    } else {
      return "$path/{uid}";
    }
  }

  @override
  String toString() {
    return "$path(${parameters.map((e) => e.toString()).join(", ")})";
  }
}

class _PathValue {
  _PathValue(String text) {
    snakeCase = text.toSnakeCase();
    camelCase = text.toCamelCase();
  }

  late final String snakeCase;
  late final String camelCase;

  @override
  String toString() {
    return "$camelCase($snakeCase)";
  }
}
