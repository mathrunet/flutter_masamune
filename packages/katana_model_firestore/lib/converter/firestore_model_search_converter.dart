part of katana_model_firestore;

/// FirestoreConverter for [ModelSearch].
///
/// [ModelSearch]用のFirestoreConverter。
class FirestoreModelSearchConverter extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelSearch].
  ///
  /// [ModelSearch]用のFirestoreConverter。
  const FirestoreModelSearchConverter();

  @override
  String get type => (ModelSearch).toString();

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original,
    FirestoreModelAdapterBase adapter,
  ) {
    if (value is Map) {
      final targetKey = "#$key";
      final targetMap = original.getAsMap(targetKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        return {
          key: ModelSearch(
            value.keys.map((e) => e.toString()).toList(),
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
    DynamicMap original,
    FirestoreModelAdapterBase adapter,
  ) {
    if (value is DynamicMap && value.containsKey(_kTypeKey)) {
      final type = value.get(_kTypeKey, "");
      if (type == this.type) {
        final fromUser = value.get(ModelSearch.kSourceKey, "") ==
            ModelFieldValueSource.user.name;
        final val = value.getAsList<String>(ModelSearch.kListKey);
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: (ModelSearch).toString(),
            ModelSearch.kListKey: val,
            _kTargetKey: key,
          },
          if (fromUser) key: val.toMap((item) => MapEntry(item, true)),
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        throw UnsupportedError(
            "ModelSearch cannot be included in a listing or map. It must be placed in the top field.");
      }
    } else if (value is Map) {
      final map = value
          .where((key, value) => value is DynamicMap)
          .cast<String, DynamicMap>();
      if (map.isNotEmpty &&
          map.values.every((e) => e.get(_kTypeKey, "") == type)) {
        throw UnsupportedError(
            "ModelSearch cannot be included in a listing or map. It must be placed in the top field.");
      }
    }
    return null;
  }

  @override
  Object? convertQueryValue(
    Object? value,
    FirestoreModelAdapterBase adapter,
  ) {
    if (value is! ModelSearch) {
      return null;
    }
    return value.value;
  }
}
