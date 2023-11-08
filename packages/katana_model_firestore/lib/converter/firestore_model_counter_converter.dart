part of '/katana_model_firestore.dart';

/// FirestoreConverter for [ModelCounter].
///
/// [ModelCounter]用のFirestoreConverter。
class FirestoreModelCounterConverter extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelCounter].
  ///
  /// [ModelCounter]用のFirestoreConverter。
  const FirestoreModelCounterConverter();

  @override
  String get type => ModelCounter.typeString;

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original,
    FirestoreModelAdapterBase adapter,
  ) {
    if (value is List) {
      final targetKey = "#$key";
      final targetList = original
          .getAsList(targetKey)
          .whereType<DynamicMap>()
          .cast<DynamicMap>();
      if (targetList.isNotEmpty &&
          targetList.every((e) => e.get(_kTypeKey, "") == type)) {
        return {
          key: value.whereType<num>().cast<num>().mapAndRemoveEmpty<DynamicMap>(
                (e) => ModelCounter(e.toInt()).toJson(),
              ),
        };
      }
    } else if (value is Map) {
      final targetKey = "#$key";
      final targetMap = original
          .getAsMap(targetKey)
          .where((key, value) => value is DynamicMap)
          .cast<String, DynamicMap>();
      if (targetMap.isNotEmpty &&
          targetMap.values.every((e) => e.get(_kTypeKey, "") == type)) {
        return {
          key: value
              .where((k, v) => v is num)
              .cast<String, num>()
              .map<String, DynamicMap>(
                (k, v) => MapEntry(
                  k,
                  ModelCounter(v.toInt()).toJson(),
                ),
              ),
        };
      }
    } else if (value is num) {
      final targetKey = "#$key";
      final targetMap = original.getAsMap(targetKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        return {key: ModelCounter(value.toInt()).toJson()};
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
        final fromUser = value.get(ModelCounter.kSourceKey, "") ==
            ModelFieldValueSource.user.name;
        final count = value.get<num>(ModelCounter.kValueKey, 0.0);
        final increment = value.get<num>(ModelCounter.kIncrementKey, 0.0);
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: this.type,
            ModelCounter.kValueKey: count,
            ModelCounter.kIncrementKey: increment,
            _kTargetKey: key,
          },
          key: fromUser ? count : FieldValue.increment(increment),
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        final target = <DynamicMap>[];
        final res = <Object>[];
        final targetKey = "#$key";
        for (final entry in list) {
          final fromUser = entry.get(ModelCounter.kSourceKey, "") ==
              ModelFieldValueSource.user.name;
          final count = entry.get<num>(ModelCounter.kValueKey, 0.0);
          final increment = entry.get<num>(ModelCounter.kIncrementKey, 0.0);
          target.add({
            kTypeFieldKey: type,
            ModelCounter.kValueKey: count,
            ModelCounter.kIncrementKey: increment,
            _kTargetKey: key,
          });
          res.add(fromUser ? count : FieldValue.increment(increment));
        }
        return {
          targetKey: target,
          key: res,
        };
      }
    } else if (value is Map) {
      final map = value
          .where((key, value) => value is DynamicMap)
          .cast<String, DynamicMap>();
      if (map.isNotEmpty &&
          map.values.every((e) => e.get(_kTypeKey, "") == type)) {
        final target = <String, DynamicMap>{};
        final res = <String, Object>{};
        final targetKey = "#$key";
        for (final entry in map.entries) {
          final fromUser = entry.value.get(ModelCounter.kSourceKey, "") ==
              ModelFieldValueSource.user.name;
          final count = entry.value.get<num>(ModelCounter.kValueKey, 0.0);
          final increment =
              entry.value.get<num>(ModelCounter.kIncrementKey, 0.0);
          target[entry.key] = {
            kTypeFieldKey: type,
            ModelCounter.kValueKey: count,
            ModelCounter.kIncrementKey: increment,
            _kTargetKey: key,
          };
          res[entry.key] = fromUser ? count : FieldValue.increment(increment);
        }
        return {
          targetKey: target,
          key: res,
        };
      }
    }
    return null;
  }

  @override
  Object? convertQueryValue(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query,
    FirestoreModelAdapterBase adapter,
  ) {
    return (filter.value as ModelCounter).value;
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query,
    FirestoreModelAdapterBase adapter,
  ) {
    return value is ModelCounter;
  }
}
