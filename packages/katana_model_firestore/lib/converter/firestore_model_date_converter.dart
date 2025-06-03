part of "/katana_model_firestore.dart";

/// FirestoreConverter for [ModelDate].
///
/// [ModelDate]用のFirestoreConverter。
class FirestoreModelDateConverter extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelDate].
  ///
  /// [ModelDate]用のFirestoreConverter。
  const FirestoreModelDateConverter();

  @override
  String get type => ModelDate.typeString;

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    if (value is List) {
      final targetKey = "#$key";
      final targetList = original
          .getAsList(targetKey)
          .whereType<DynamicMap>()
          .cast<DynamicMap>();
      if (targetList.isNotEmpty &&
          targetList.every((e) => e.get(_kTypeKey, "") == type)) {
        return {
          key: value.mapAndRemoveEmpty<DynamicMap>((e) {
            if (e is num) {
              return ModelDate(
                DateTime.fromMicrosecondsSinceEpoch(e.toInt()),
              ).toJson();
            } else if (e is Timestamp) {
              return ModelDate(e.toDate()).toJson();
            }
            return null;
          }),
          targetKey: null,
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
              .map<String, DynamicMap?>((k, v) {
                if (v is num) {
                  return MapEntry(
                    k,
                    ModelDate(
                      DateTime.fromMicrosecondsSinceEpoch(v.toInt()),
                    ).toJson(),
                  );
                } else if (v is Timestamp) {
                  return MapEntry(
                    k,
                    ModelDate(v.toDate()).toJson(),
                  );
                }
                return MapEntry(k, null);
              })
              .where((k, v) => v != null)
              .cast<String, DynamicMap>,
          targetKey: null,
        };
      }
    } else if (value is num) {
      final targetKey = "#$key";
      final targetMap = original.getAsMap(targetKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        return {
          key: ModelDate(
            DateTime.fromMicrosecondsSinceEpoch(value.toInt()),
          ).toJson(),
          targetKey: null,
        };
      }
    } else if (value is Timestamp) {
      final targetKey = "#$key";
      final targetMap = original.getAsMap(targetKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        return {
          key: ModelDate(value.toDate()).toJson(),
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
        final val = value.get<num>(ModelDate.kTimeKey, 0.0);
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: this.type,
            ModelDate.kTimeKey: val,
            _kTargetKey: key,
          },
          key: Timestamp.fromMicrosecondsSinceEpoch(val.toInt()),
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        final target = <DynamicMap>[];
        final res = <Object>[];
        final targetKey = "#$key";
        for (final entry in list) {
          final time = entry.get<num>(ModelDate.kTimeKey, 0.0);
          target.add({
            kTypeFieldKey: type,
            ModelDate.kTimeKey: time,
            _kTargetKey: key,
          });
          res.add(Timestamp.fromMicrosecondsSinceEpoch(time.toInt()));
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
          final time = entry.value.get<num>(ModelDate.kTimeKey, 0.0);
          target[entry.key] = {
            kTypeFieldKey: type,
            ModelDate.kTimeKey: time,
            _kTargetKey: key,
          };
          res[entry.key] = Timestamp.fromMicrosecondsSinceEpoch(time.toInt());
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
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    return Timestamp.fromDate((value as ModelDate).value);
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    return value is ModelDate;
  }
}
