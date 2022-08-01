part of firebase_model_notifier;

/// This is a mixin for handling Firestore queries.
///
/// Any query that is possible in Firestore can be executed.
mixin FirestoreCollectionQueryMixin<T extends FirestoreDocumentModel>
    on FirestoreCollectionModel<T> {
  /// You can change the [query] object of Firestore.
  @override
  @protected
  @mustCallSuper
  Query<DynamicMap> query(Query<DynamicMap> query) {
    if (parameters.isNotEmpty) {
      if (parameters.containsKey("key") && parameters["key"].isNotEmpty) {
        if (parameters.containsKey("equalTo") &&
            parameters["equalTo"].isNotEmpty) {
          query = query.where(
            parameters["key"]!,
            isEqualTo: FirestoreUtility._parse(parameters["equalTo"]),
          );
        }
        if (parameters.containsKey("notEqualTo") &&
            parameters["noteEqualTo"].isNotEmpty) {
          query = query.where(
            parameters["key"]!,
            isNotEqualTo: FirestoreUtility._parse(parameters["noteEqualTo"]),
          );
        }
        if (parameters.containsKey("startAt") &&
            parameters["startAt"].isNotEmpty) {
          query = query.where(
            parameters["key"]!,
            isGreaterThanOrEqualTo: num.parse(parameters["startAt"]!),
          );
        }
        if (parameters.containsKey("endAt") && parameters["endAt"].isNotEmpty) {
          query = query.where(
            parameters["key"]!,
            isLessThanOrEqualTo: num.parse(parameters["endAt"]!),
          );
        }
        if (parameters.containsKey("contains") &&
            parameters["contains"].isNotEmpty) {
          query = query.where(
            parameters["key"]!,
            arrayContains: FirestoreUtility._parse(parameters["contains"]),
          );
        }
      }
      if (parameters.containsKey("limitToFirst") &&
          parameters["limitToFirst"].isNotEmpty) {
        query =
            query.limit(int.parse(parameters["limitToFirst"]!) * _nextCount);
      }
      if (parameters.containsKey("limitToLast") &&
          parameters["limitToLast"].isNotEmpty) {
        query = query
            .limitToLast(int.parse(parameters["limitToLast"]!) * _nextCount);
      }
      if (parameters.containsKey("orderByDesc") &&
          parameters["orderByDesc"].isNotEmpty) {
        if (!(parameters.containsKey("key") &&
            parameters["key"] == parameters["orderByDesc"] &&
            (parameters.containsKey("equalTo") ||
                parameters.containsKey("notEqualTo") ||
                parameters.containsKey("containsAny") ||
                parameters.containsKey("whereIn") ||
                parameters.containsKey("whereNotIn")))) {
          query = query.orderBy(parameters["orderByDesc"]!, descending: true);
        }
      } else if (parameters.containsKey("orderByAsc") &&
          parameters["orderByAsc"].isNotEmpty) {
        if (!(parameters.containsKey("key") &&
            parameters["key"] == parameters["orderByAsc"] &&
            (parameters.containsKey("equalTo") ||
                parameters.containsKey("notEqualTo") ||
                parameters.containsKey("containsAny") ||
                parameters.containsKey("whereIn") ||
                parameters.containsKey("whereNotIn")))) {
          query = query.orderBy(parameters["orderByAsc"]!);
        }
      } else {
        if (parameters.containsKey("startAt") &&
            parameters["startAt"].isNotEmpty) {
          query = query.orderBy(parameters["key"]!);
        } else if (parameters.containsKey("endAt") &&
            parameters["endAt"].isNotEmpty) {
          query = query.orderBy(parameters["key"]!);
        }
      }
    }
    return super.query(query);
  }

  /// You can change the Firestore reference.
  ///
  /// By specifying multiple items in the array, it is possible to issue and read queries simultaneously.
  @override
  @protected
  @mustCallSuper
  List<Query<DynamicMap>> get references {
    if (parameters.containsKey("key")) {
      if (parameters.containsKey("containsAny")) {
        final items = parameters["containsAny"]?.split(",") ?? <String>[];
        if (items.isNotEmpty) {
          final queries = <Query<DynamicMap>>[];
          for (var i = 0; i < items.length; i += 10) {
            queries.add(
              query(
                firestore.collection(path.split("?").first),
              ).where(
                parameters["key"]!,
                arrayContainsAny: items
                    .sublist(
                      i,
                      min(i + 10, items.length),
                    )
                    .map((e) => FirestoreUtility._parse(e))
                    .toList(),
              ),
            );
          }
          return queries;
        }
      } else if (parameters.containsKey("whereIn")) {
        final items = parameters["whereIn"]?.split(",") ?? <String>[];
        if (items.isNotEmpty) {
          final queries = <Query<DynamicMap>>[];
          for (var i = 0; i < items.length; i += 10) {
            queries.add(
              query(
                firestore.collection(path.split("?").first),
              ).where(
                parameters["key"]!,
                whereIn: items
                    .sublist(
                      i,
                      min(i + 10, items.length),
                    )
                    .map((e) => FirestoreUtility._parse(e))
                    .toList(),
              ),
            );
          }
          return queries;
        }
      } else if (parameters.containsKey("whereNotIn")) {
        final items = parameters["whereNotIn"]?.split(",") ?? <String>[];
        if (items.isNotEmpty) {
          final queries = <Query<DynamicMap>>[];
          for (var i = 0; i < items.length; i += 10) {
            queries.add(
              query(
                firestore.collection(path.split("?").first),
              ).where(
                parameters["key"]!,
                whereIn: items
                    .sublist(
                      i,
                      min(i + 10, items.length),
                    )
                    .map((e) => FirestoreUtility._parse(e))
                    .toList(),
              ),
            );
          }
          return queries;
        }
      } else if (parameters.containsKey("geoHash")) {
        final items = parameters["geoHash"]?.split(",") ?? <String>[];
        if (items.isNotEmpty) {
          final queries = <Query<DynamicMap>>[];
          for (var i = 0; i < items.length; i++) {
            final hash = items[i];
            queries.add(
              query(
                firestore.collection(path.split("?").first),
              )
                  .orderBy(parameters["key"]!)
                  .startAt([hash]).endAt([hash + '\uf8ff']),
            );
          }
          return queries;
        }
      }
    }
    return super.references;
  }
}
