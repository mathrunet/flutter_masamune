part of masamune;

/// Provider of the runtime data collection.
///
/// You can store and
/// use data fields there by describing the path as it is.
///
/// ```dart
/// final collection = RuntimeCollectionProvider("user");
/// ```
class RuntimeCollectionProvider extends PathProvider<RuntimeCollection> {
  /// Provider of the runtime data collection.
  ///
  /// You can store and
  /// use data fields there by describing the path as it is.
  ///
  /// ```dart
  /// final collection = RuntimeCollectionProvider("user");
  /// ```
  ///
  /// [path]: Collection path.
  /// [data]: Data to be input.
  /// [orderBy]: Sort order.
  /// [orderByKey]: Key for sorting.
  /// [thenBy]: Sort order when the first sort has the same value.
  /// [thenByKey]: Sort key when the first sort has the same value.
  RuntimeCollectionProvider(
    String path, {
    List<Map<String, dynamic>> data,
    OrderBy orderBy = OrderBy.none,
    String orderByKey,
    OrderBy thenBy = OrderBy.none,
    String thenByKey,
  }) : super(
          (_) => data == null
              ? RuntimeCollection(path)
              : RuntimeCollection.fromList(
                  path,
                  data,
                  orderBy: orderBy,
                  thenBy: thenBy,
                  orderByKey: orderByKey,
                  thenByKey: thenByKey,
                ),
        );
}
