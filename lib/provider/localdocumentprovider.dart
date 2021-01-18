part of flutter_runtime_database;

/// Provider of the local data document.
///
/// You can store and
/// use data fields there by describing the path as it is.
///
/// ```dart
/// final document = LocalDocumentProvider("user");
/// ```
class LocalDocumentProvider extends PathProvider<LocalDocument> {
  /// Provider of the local data document.
  ///
  /// You can store and
  /// use data fields there by describing the path as it is.
  ///
  /// ```dart
  /// final document = LocalDocumentProvider("user");
  /// ```
  ///
  /// [path]: Document path.
  LocalDocumentProvider(
    String path,
  ) : super(
          (_) => LocalDocument.load(path),
        );
}
