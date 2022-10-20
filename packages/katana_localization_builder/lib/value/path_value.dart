part of katana_localization_builder;

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
  PathValue(this.path);

  /// Path value.
  ///
  /// パスの値。
  late final String path;
  @override
  String toString() {
    return path;
  }
}
