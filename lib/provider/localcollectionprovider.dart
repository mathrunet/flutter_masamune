part of masamune;

/// Provider of the local data collection.
///
/// You can store and
/// use data fields there by describing the path as it is.
///
/// ```dart
/// final collection = LocalCollectionProvider("user");
/// ```
class LocalCollectionProvider extends PathProvider<LocalCollection> {
  /// Provider of the local data collection.
  ///
  /// You can store and
  /// use data fields there by describing the path as it is.
  ///
  /// ```dart
  /// final collection = LocalCollectionProvider("user");
  /// ```
  ///
  /// [path]: Collection path.
  /// [orderBy]: Sort order.
  /// [orderByKey]: Key for sorting.
  /// [thenBy]: Sort order when the first sort has the same value.
  /// [thenByKey]: Sort key when the first sort has the same value.
  LocalCollectionProvider(
    String path, {
    OrderBy orderBy = OrderBy.none,
    String orderByKey,
    OrderBy thenBy = OrderBy.none,
    String thenByKey,
  }) : super(
          (_) => LocalCollection.load(
            path,
            orderBy: orderBy,
            thenBy: thenBy,
            orderByKey: orderByKey,
            thenByKey: thenByKey,
          ),
        );
}
