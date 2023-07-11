part of katana_model_firestore;

/// FirestoreConverter for [ModelTimestamp].
///
/// [ModelTimestamp]用のFirestoreConverter。
class FirestoreModelUriConverter extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelTimestamp].
  ///
  /// [ModelTimestamp]用のFirestoreConverter。
  const FirestoreModelUriConverter();

  @override
  String get type => (ModelUri).toString();

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
          key: value.mapAndRemoveEmpty<DynamicMap>(
            (e) => ModelUri(Uri.tryParse(e.toString())).toJson(),
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
          key: value.map<String, DynamicMap>(
            (k, v) => MapEntry(
              k,
              ModelUri(Uri.tryParse(v.toString())).toJson(),
            ),
          ),
        };
      }
    } else if (value is String) {
      final targetKey = "#$key";
      final targetMap = original.getAsMap(targetKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        return {
          key: ModelUri(Uri.tryParse(value)).toJson(),
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
        final val = value.get(ModelUri.kUriKey, "");
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: this.type,
            ModelUri.kUriKey: val,
            _kTargetKey: key,
          },
          key: val,
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        final target = <DynamicMap>[];
        final res = <String>[];
        final targetKey = "#$key";
        for (final entry in list) {
          final uri = entry.get(ModelUri.kUriKey, "");
          target.add({
            kTypeFieldKey: type,
            ModelUri.kUriKey: uri,
            _kTargetKey: key,
          });
          res.add(uri);
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
          final uri = entry.value.get(ModelUri.kUriKey, "");
          target[entry.key] = {
            kTypeFieldKey: type,
            ModelUri.kUriKey: uri,
            _kTargetKey: key,
          };
          res[entry.key] = uri;
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
    FirestoreModelAdapterBase adapter,
  ) {
    if (value is! ModelUri) {
      return null;
    }
    return value.value;
  }
}
