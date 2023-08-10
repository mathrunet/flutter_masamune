part of katana_model_firestore;

/// FirestoreConverter for [ModelGeoValue].
///
/// [ModelGeoValue]用のFirestoreConverter。
class FirestoreModelGeoValueConverter
    extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelGeoValue].
  ///
  /// [ModelGeoValue]用のFirestoreConverter。
  const FirestoreModelGeoValueConverter();

  @override
  String get type => ModelGeoValue.typeString;

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
        if (value.every((e) => e is String)) {
          return {
            key: targetList.mapAndRemoveEmpty<DynamicMap>(
              (e) => ModelGeoValue(
                GeoValue(
                    latitude: e.get(ModelGeoValue.kLatitudeKey, 0.0),
                    longitude: e.get(ModelGeoValue.kLongitudeKey, 0.0)),
              ).toJson(),
            ),
          };
        } else if (value.every((e) => e is GeoPoint)) {
          return {
            key: value
                .whereType<GeoPoint>()
                .cast<GeoPoint>()
                .mapAndRemoveEmpty<DynamicMap>(
                  (e) => ModelGeoValue(
                    GeoValue(latitude: e.latitude, longitude: e.longitude),
                  ).toJson(),
                ),
          };
        }
      }
    } else if (value is Map) {
      final targetKey = "#$key";
      final targetMap = original
          .getAsMap(targetKey)
          .where((key, value) => value is DynamicMap)
          .cast<String, DynamicMap>();
      if (targetMap.isNotEmpty &&
          targetMap.values.every((e) => e.get(_kTypeKey, "") == type)) {
        if (value.values.every((e) => e is String)) {
          return {
            key: targetMap.map<String, DynamicMap>(
              (k, v) => MapEntry(
                k,
                ModelGeoValue(
                  GeoValue(
                      latitude: v.get(ModelGeoValue.kLatitudeKey, 0.0),
                      longitude: v.get(ModelGeoValue.kLongitudeKey, 0.0)),
                ).toJson(),
              ),
            ),
          };
        } else if (value.values.every((e) => e is GeoPoint)) {
          return {
            key: value
                .where((k, v) => v is GeoPoint)
                .cast<String, GeoPoint>()
                .map<String, DynamicMap>(
                  (k, v) => MapEntry(
                    k,
                    ModelGeoValue(
                      GeoValue(latitude: v.latitude, longitude: v.longitude),
                    ).toJson(),
                  ),
                ),
          };
        }
      }
    } else if (value is String) {
      final targetKey = "#$key";
      final targetMap = original.getAsMap(targetKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        final latitude = targetMap.get(ModelGeoValue.kLatitudeKey, 0.0);
        final longitude = targetMap.get(ModelGeoValue.kLongitudeKey, 0.0);
        return {
          key: ModelGeoValue(
            GeoValue(latitude: latitude, longitude: longitude),
          ).toJson(),
        };
      }
    } else if (value is GeoPoint) {
      return {
        key: ModelGeoValue(
          GeoValue(latitude: value.latitude, longitude: value.longitude),
        ).toJson(),
      };
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
        final fromUser = value.get(ModelGeoValue.kSourceKey, "") ==
            ModelFieldValueSource.user.name;
        final geoHash = value.get(ModelGeoValue.kGeoHashKey, "");
        final latitude = value.get(ModelGeoValue.kLatitudeKey, 0);
        final longitude = value.get(ModelGeoValue.kLongitudeKey, 0);
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: type,
            ModelGeoValue.kLatitudeKey: latitude,
            ModelGeoValue.kLongitudeKey: longitude,
            _kTargetKey: key,
          },
          if (fromUser) key: geoHash,
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        final target = <DynamicMap>[];
        final res = <String>[];
        final targetKey = "#$key";
        for (final entry in list) {
          final fromUser = entry.get(ModelCounter.kSourceKey, "") ==
              ModelFieldValueSource.user.name;
          final geoHash = entry.get(ModelGeoValue.kGeoHashKey, "");
          final latitude = entry.get(ModelGeoValue.kLatitudeKey, 0);
          final longitude = entry.get(ModelGeoValue.kLongitudeKey, 0);
          target.add({
            kTypeFieldKey: type,
            ModelGeoValue.kLatitudeKey: latitude,
            ModelGeoValue.kLongitudeKey: longitude,
            _kTargetKey: key,
          });
          if (fromUser) {
            res.add(geoHash);
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
        final res = <String, String>{};
        final targetKey = "#$key";
        for (final entry in map.entries) {
          final fromUser = entry.value.get(ModelCounter.kSourceKey, "") ==
              ModelFieldValueSource.user.name;
          final geoHash = entry.value.get(ModelGeoValue.kGeoHashKey, "");
          final latitude = entry.value.get(ModelGeoValue.kLatitudeKey, 0);
          final longitude = entry.value.get(ModelGeoValue.kLongitudeKey, 0);
          target[entry.key] = {
            kTypeFieldKey: type,
            ModelGeoValue.kLatitudeKey: latitude,
            ModelGeoValue.kLongitudeKey: longitude,
            _kTargetKey: key,
          };
          if (fromUser) {
            res[entry.key] = geoHash;
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
    ModelAdapterCollectionQuery query,
    FirestoreModelAdapterBase adapter,
  ) {
    return (value as ModelGeoValue).value.geoHash;
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query,
    FirestoreModelAdapterBase adapter,
  ) {
    return value is ModelGeoValue;
  }
}
