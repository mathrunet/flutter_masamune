part of flutter_runtime_database;

/// Provider of the local data document.
///
/// You can store and
/// use data fields there by describing the path as it is.
///
/// ```dart
/// final document = RuntimeDocumentProvider("user");
/// ```
class RuntimeDocumentProvider extends PathProvider<RuntimeDocument> {
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
  /// [data]: Data to be input.
  RuntimeDocumentProvider(
    String path, {
    Map<String, dynamic> data,
  }) : super(
          (_) => data == null
              ? RuntimeDocument(path)
              : RuntimeDocument.fromMap(
                  path,
                  data,
                ),
        );
}
