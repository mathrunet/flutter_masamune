part of flutter_runtime_database;

/// Provider of the data field.
///
/// You can store and
/// use data fields there by describing the path as it is.
///
/// ```dart
/// final counter = DataFieldProvider("count");
/// ```
class DataFieldProvider extends PathProvider<DataField> {
  /// Provider of the data field.
  ///
  /// You can store and
  /// use data fields there by describing the path as it is.
  ///
  /// ```dart
  /// final counter = DataFieldProvider("count");
  /// ```
  ///
  /// [path]: The path of the data field.
  /// [value]: Initial value.
  DataFieldProvider(
    String path, [
    dynamic value,
  ]) : super(
          (_) => DataField(
            path,
            value,
          ),
        );
}
