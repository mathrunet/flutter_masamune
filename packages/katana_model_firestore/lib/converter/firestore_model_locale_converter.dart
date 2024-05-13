part of '/katana_model_firestore.dart';

/// FirestoreConverter for [ModelLocale].
///
/// [ModelLocale]用のFirestoreConverter。
class FirestoreModelLocaleConverter extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelLocale].
  ///
  /// [ModelLocale]用のFirestoreConverter。
  const FirestoreModelLocaleConverter();

  @override
  String get type => ModelLocale.typeString;

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
            final keys = e.toString().replaceAll("-", "_").split("_");
            return ModelLocale(
              Locale(keys.first, keys.length > 1 ? keys.last : null),
            ).toJson();
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
          key: value.map<String, DynamicMap>((k, v) {
            final keys = v.toString().replaceAll("-", "_").split("_");
            return MapEntry(
              k,
              ModelLocale(
                Locale(keys.first, keys.length > 1 ? keys.last : null),
              ).toJson(),
            );
          }),
          targetKey: null,
        };
      }
    } else if (value is String) {
      final targetKey = "#$key";
      final targetMap = original.getAsMap(targetKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        final keys = value.toString().replaceAll("-", "_").split("_");
        return {
          key: ModelLocale(
            Locale(keys.first, keys.length > 1 ? keys.last : null),
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
        final language = value.get(ModelLocale.kLaunguageKey, "");
        final country = value.get(ModelLocale.kCountryKey, "");
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: this.type,
            ModelLocale.kLaunguageKey: language,
            ModelLocale.kCountryKey: country,
            _kTargetKey: key,
          },
          if (country.isNotEmpty)
            key: "${language}_$country"
          else
            key: language,
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        final target = <DynamicMap>[];
        final res = <String>[];
        final targetKey = "#$key";
        for (final entry in list) {
          final language = entry.get(ModelLocale.kLaunguageKey, "");
          final country = entry.get(ModelLocale.kCountryKey, "");
          target.add({
            kTypeFieldKey: type,
            ModelLocale.kLaunguageKey: language,
            ModelLocale.kCountryKey: country,
            _kTargetKey: key,
          });
          if (country.isNotEmpty) {
            res.add("${language}_$country");
          } else {
            res.add(language);
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
          final language = entry.value.get(ModelLocale.kLaunguageKey, "");
          final country = entry.value.get(ModelLocale.kCountryKey, "");
          target[entry.key] = {
            kTypeFieldKey: type,
            ModelLocale.kLaunguageKey: language,
            ModelLocale.kCountryKey: country,
            _kTargetKey: key,
          };
          if (country.isNotEmpty) {
            res[entry.key] = "${language}_$country";
          } else {
            res[entry.key] = language;
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
    return (filter.value as ModelLocale).value.toString();
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    return value is ModelLocale;
  }
}
