part of '/katana_model_firestore.dart';

/// FirestoreConverter for [ModelToken].
///
/// [ModelToken]用のFirestoreConverter。
class FirestoreModelTokenConverter extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelToken].
  ///
  /// [ModelToken]用のFirestoreConverter。
  const FirestoreModelTokenConverter();

  @override
  String get type => ModelToken.typeString;

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    if (value is List) {
      final targetKey = "#$key";
      final targetMap = original.getAsMap(targetKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        return {
          key: ModelToken(
            value.map((e) => e.toString()).toList(),
          ).toJson(),
        };
      }
    }
    return null;
  }

  @override
  DynamicMap? convertTo(
    String key,
    Object? value,
    DynamicMap original, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    if (value is DynamicMap && value.containsKey(_kTypeKey)) {
      final type = value.get(_kTypeKey, "");
      if (type == this.type) {
        final fromUser = value.get(ModelToken.kSourceKey, "") ==
            ModelFieldValueSource.user.name;
        final val = value.getAsList<String>(ModelToken.kListKey);
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: ModelToken.typeString,
            ModelToken.kListKey: val.toMap((item) => MapEntry(item, true)),
            _kTargetKey: key,
          },
          if (fromUser) key: val,
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        throw UnsupportedError(
            "ModelToken cannot be included in a listing or map. It must be placed in the top field.");
      }
    } else if (value is Map) {
      final map = value
          .where((key, value) => value is DynamicMap)
          .cast<String, DynamicMap>();
      if (map.isNotEmpty &&
          map.values.every((e) => e.get(_kTypeKey, "") == type)) {
        throw UnsupportedError(
            "ModelToken cannot be included in a listing or map. It must be placed in the top field.");
      }
    }
    return null;
  }

  @override
  Object? convertQueryValue(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]
  ) {
    return (filter.value as ModelToken).value.join(",");
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]
  ) {
    return value is ModelToken;
  }

  @override
  Query<DynamicMap>? filterQuery(
    Query<DynamicMap> firestoreQuery,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]
  ) {
    if (!enabledQuery(filter.value, filter, query, adapter)) {
      return null;
    }
    final key = filter.key!;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        final modelToken = filter.value as ModelToken;
        for (final text in modelToken.value) {
          firestoreQuery = firestoreQuery.where(
            "#${convertQueryKey(key, filter, query, adapter)}.${ModelToken.kListKey}.$text",
            isEqualTo: true,
          );
        }
        break;
      case ModelQueryFilterType.notEqualTo:
        final modelToken = filter.value as ModelToken;
        for (final text in modelToken.value) {
          firestoreQuery = firestoreQuery.where(
            "#${convertQueryKey(key, filter, query, adapter)}.${ModelToken.kListKey}.$text",
            isNotEqualTo: true,
          );
        }
        break;
      case ModelQueryFilterType.arrayContains:
        final modelToken = filter.value as ModelToken;
        firestoreQuery = firestoreQuery.where(
          convertQueryKey(key, filter, query, adapter),
          arrayContainsAny: modelToken.value,
        );
        break;
      default:
        final res = super.filterQuery(firestoreQuery, filter, query, adapter);
        if (res != null) {
          return res;
        }
        break;
    }
    return firestoreQuery;
  }

  @override
  List<Query<DynamicMap>>? collectionQueries(
    List<Object?> items,
    Query<DynamicMap> Function() generator,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]
  ) {
    if (!items.every((e) => enabledQuery(e, filter, query, adapter))) {
      return null;
    }
    switch (filter.type) {
      case ModelQueryFilterType.arrayContainsAny:
        final list =
            items.whereType<ModelToken>().expand((e) => e.value).toList();
        final queries = <Query<DynamicMap>>[];
        for (var i = 0; i < list.length; i += 10) {
          queries.add(
            generator().where(
              filter.key!,
              arrayContainsAny: list
                  .sublist(
                    i,
                    min(i + 10, list.length),
                  )
                  .toList(),
            ),
          );
        }
        return queries;
      default:
        return super.collectionQueries(
          items,
          generator,
          filter,
          query,
          adapter,
        );
    }
  }
}
