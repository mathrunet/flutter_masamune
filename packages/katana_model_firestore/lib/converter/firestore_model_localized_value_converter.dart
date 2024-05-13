part of '/katana_model_firestore.dart';

/// FirestoreConverter for [ModelLocalizedValue].
///
/// [ModelLocalizedValue]用のFirestoreConverter。
class FirestoreModelLocalizedValueConverter
    extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelLocalizedValue].
  ///
  /// [ModelLocalizedValue]用のFirestoreConverter。
  const FirestoreModelLocalizedValueConverter();

  @override
  String get type => ModelLocalizedValue.typeString;

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
          key: ModelLocalizedValue(
            LocalizedValue.fromJson(
              targetMap.getAsMap(ModelLocalizedValue.kLocalizedKey),
            ),
          ).toJson(),
          targetKey: null,
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
        final fromUser = value.get(ModelLocalizedValue.kSourceKey, "") ==
            ModelFieldValueSource.user.name;
        final val = value.getAsMap(ModelLocalizedValue.kLocalizedKey);
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: ModelLocalizedValue.typeString,
            ModelLocalizedValue.kLocalizedKey: val,
            _kTargetKey: key,
          },
          if (fromUser) key: val.toList((key, value) => "$key:$value").toList(),
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        throw UnsupportedError(
            "ModelLocalizedValue cannot be included in a listing or map. It must be placed in the top field.");
      }
    } else if (value is Map) {
      final map = value
          .where((key, value) => value is DynamicMap)
          .cast<String, DynamicMap>();
      if (map.isNotEmpty &&
          map.values.every((e) => e.get(_kTypeKey, "") == type)) {
        throw UnsupportedError(
            "ModelLocalizedValue cannot be included in a listing or map. It must be placed in the top field.");
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
  ]) {
    return (filter.value as ModelLocalizedValue)
        .value
        .map((e) => "${e.locale}:${e.value}")
        .join(",");
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    return value is ModelLocalizedValue;
  }

  @override
  Query<DynamicMap>? filterQuery(
    Query<DynamicMap> firestoreQuery,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    if (!enabledQuery(filter.value, filter, query, adapter)) {
      return null;
    }
    final key = filter.key!;
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        final localizedValue = filter.value as ModelLocalizedValue;
        for (final entry in localizedValue.value) {
          firestoreQuery = firestoreQuery.where(
            "#${convertQueryKey(key, filter, query, adapter)}.${ModelLocalizedValue.kLocalizedKey}.${entry.locale.toString()}",
            isEqualTo: entry.value,
          );
        }
        break;
      case ModelQueryFilterType.notEqualTo:
        final localizedValue = filter.value as ModelLocalizedValue;
        for (final entry in localizedValue.value) {
          firestoreQuery = firestoreQuery.where(
            "#${convertQueryKey(key, filter, query, adapter)}.${ModelLocalizedValue.kLocalizedKey}.${entry.locale.toString()}",
            isNotEqualTo: entry.value,
          );
        }
        break;
      case ModelQueryFilterType.arrayContains:
        final localizedValue = filter.value as ModelLocalizedValue;
        firestoreQuery = firestoreQuery.where(
          convertQueryKey(key, filter, query, adapter),
          arrayContainsAny: localizedValue.value.map(
            (e) => "${e.locale}:${e.value}",
          ),
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
  ]) {
    if (!items.every((e) => enabledQuery(e, filter, query, adapter))) {
      return null;
    }
    switch (filter.type) {
      case ModelQueryFilterType.arrayContainsAny:
        final list = items
            .whereType<ModelLocalizedValue>()
            .expand((e) => e.value.map((e) => "${e.locale}:${e.value}"))
            .toList();
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
