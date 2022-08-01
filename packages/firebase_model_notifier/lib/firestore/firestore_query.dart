part of firebase_model_notifier;

/// Class for sending queries to the model.
///
/// Basically, it allows you to send the same query as Firestore.
///
/// Can be converted to a [String] by passing [value].
@immutable
class FirestoreQuery extends ModelQuery {
  /// Class for sending queries to the model.
  ///
  /// Basically, it allows you to send the same query as Firestore.
  ///
  /// Can be converted to a [String] by passing [value].
  const FirestoreQuery(
    String path, {
    String? key,
    String? orderBy,
    dynamic isEqualTo,
    dynamic isNotEqualTo,
    // dynamic isLessThan;
    dynamic isLessThanOrEqualTo,
    // dynamic isGreaterThan;
    dynamic isGreaterThanOrEqualTo,
    dynamic arrayContains,
    DynamicList? arrayContainsAny,
    DynamicList? whereIn,
    DynamicList? whereNotIn,
    List<String>? geoHash,
    // bool? isNull;
    ModelQueryOrder order = ModelQueryOrder.asc,
    int? limit,
  }) : super(
          path,
          key: key,
          orderBy: orderBy,
          isEqualTo: isEqualTo,
          isNotEqualTo: isNotEqualTo,
          isLessThanOrEqualTo: isLessThanOrEqualTo,
          isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
          arrayContains: arrayContains,
          arrayContainsAny: arrayContainsAny,
          whereIn: whereIn,
          geoHash: geoHash,
          whereNotIn: whereNotIn,
          order: order,
          limit: limit,
        );
}
