part of katana_router_builder;

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
  late final List<_PathValue> parameters;

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
