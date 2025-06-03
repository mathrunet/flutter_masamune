part of "/katana_model_firestore.dart";

/// FirestoreConverter for [ModelTimestamp].
///
/// [ModelTimestamp]用のFirestoreConverter。
class FirestoreModelTimestampConverter
    extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelTimestamp].
  ///
  /// [ModelTimestamp]用のFirestoreConverter。
  const FirestoreModelTimestampConverter();

  @override
  String get type => ModelTimestamp.typeString;

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
              return ModelTimestamp(
                DateTime.fromMicrosecondsSinceEpoch(e.toInt()),
              ).toJson();
            } else if (e is Timestamp) {
              return ModelTimestamp(e.toDate()).toJson();
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
                    ModelTimestamp(
                      DateTime.fromMicrosecondsSinceEpoch(v.toInt()),
                    ).toJson(),
                  );
                } else if (v is Timestamp) {
                  return MapEntry(
                    k,
                    ModelTimestamp(v.toDate()).toJson(),
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
          key: ModelTimestamp(
            DateTime.fromMicrosecondsSinceEpoch(value.toInt()),
          ).toJson(),
          targetKey: null,
        };
      }
    } else if (value is Timestamp) {
      final targetKey = "#$key";
      return {
        key: ModelTimestamp(value.toDate()).toJson(),
        targetKey: null,
      };
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
        final fromUser = value.get(ModelTimestamp.kSourceKey, "") ==
            ModelFieldValueSource.user.name;
        final val = value.getAsDouble(ModelTimestamp.kTimeKey);
        final useNow = value.get(ModelTimestamp.kNowKey, false);
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: this.type,
            ModelTimestamp.kTimeKey: val,
            _kTargetKey: key,
          },
          if (fromUser) ...{
            if (useNow)
              key: FieldValue.serverTimestamp()
            else
              key: Timestamp.fromMicrosecondsSinceEpoch(val.toInt()),
          } else ...{
            key: Timestamp.fromMicrosecondsSinceEpoch(val.toInt()),
          },
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        final target = <DynamicMap>[];
        final res = <Object>[];
        final targetKey = "#$key";
        for (final entry in list) {
          final fromUser = entry.get(ModelTimestamp.kSourceKey, "") ==
              ModelFieldValueSource.user.name;
          final time = entry.get<num>(ModelTimestamp.kTimeKey, 0.0);
          final useNow = entry.get(ModelTimestamp.kNowKey, false);
          target.add({
            kTypeFieldKey: type,
            ModelTimestamp.kTimeKey: time,
            _kTargetKey: key,
          });
          if (fromUser) {
            if (useNow) {
              res.add(FieldValue.serverTimestamp());
            } else {
              res.add(Timestamp.fromMicrosecondsSinceEpoch(time.toInt()));
            }
          } else {
            res.add(Timestamp.fromMicrosecondsSinceEpoch(time.toInt()));
          }
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
          final fromUser = entry.value.get(ModelTimestamp.kSourceKey, "") ==
              ModelFieldValueSource.user.name;
          final time = entry.value.getAsDouble(ModelTimestamp.kTimeKey);
          final useNow = entry.value.get(ModelTimestamp.kNowKey, false);
          target[entry.key] = {
            kTypeFieldKey: type,
            ModelTimestamp.kTimeKey: time,
            _kTargetKey: key,
          };
          if (fromUser) {
            if (useNow) {
              res[entry.key] = FieldValue.serverTimestamp();
            } else {
              res[entry.key] =
                  Timestamp.fromMicrosecondsSinceEpoch(time.toInt());
            }
          } else {
            res[entry.key] = Timestamp.fromMicrosecondsSinceEpoch(time.toInt());
          }
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
    return Timestamp.fromDate((value as ModelTimestamp).value);
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    return value is ModelTimestamp;
  }
}
