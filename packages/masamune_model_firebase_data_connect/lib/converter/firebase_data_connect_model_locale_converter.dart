part of "/masamune_model_firebase_data_connect.dart";

/// FirebaseDataConnectConverter for [ModelLocale].
///
/// [ModelLocale]用のFirebaseDataConnectConverter。
class FirebaseDataConnectModelLocaleConverter
    extends FirebaseDataConnectModelFieldValueConverter {
  /// FirebaseDataConnectConverter for [ModelLocale].
  ///
  /// [ModelLocale]用のFirebaseDataConnectConverter。
  const FirebaseDataConnectModelLocaleConverter();

  @override
  String get type => ModelLocale.typeString;

  DynamicMap? _convertFrom(Object? value) {
    if (value == null) {
      return null;
    } else if (value is String) {
      final replaced = value.replaceAll(prefixRegExp, "");
      final keys = replaced.toString().replaceAll("-", "_").split("_");
      return ModelLocale(
        Locale(keys.first, keys.length > 1 ? keys.last : null),
      ).toJson();
    }
    return null;
  }

  String _convertTo(DynamicMap map) {
    final language = map.get(ModelLocale.kLaunguageKey, "");
    final country = map.get(ModelLocale.kCountryKey, "");
    if (country.isNotEmpty) {
      return "$prefix${language}_$country";
    }
    return "$prefix$language";
  }

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    if (value is List) {
      if (value.isNotEmpty &&
          value.every((e) => prefixRegExp.hasMatch(e.toString()))) {
        return {
          key: value.mapAndRemoveEmpty(
            _convertFrom,
          ),
        };
      }
    } else if (value is Map) {
      if (value.isNotEmpty &&
          value.values.every((e) => prefixRegExp.hasMatch(e.toString()))) {
        return {
          key: value.map<String, Object?>(
            (k, v) => MapEntry(
              k,
              _convertFrom(v),
            ),
          ),
        };
      }
    } else if (value is String) {
      if (prefixRegExp.hasMatch(value.toString())) {
        return {
          key: _convertFrom(value),
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
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    if (value is DynamicMap && value.containsKey(_kTypeKey)) {
      final type = value.get(_kTypeKey, "");
      if (type == this.type) {
        return {
          key: _convertTo(value),
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        final res = <String>[];
        for (final entry in list) {
          res.add(_convertTo(entry));
        }
        return {
          key: res,
        };
      }
    } else if (value is Map) {
      final map = value
          .where((key, value) => value is DynamicMap)
          .cast<String, DynamicMap>();
      if (map.isNotEmpty &&
          map.values.every((e) => e.get(_kTypeKey, "") == type)) {
        final res = <String, String>{};
        for (final entry in map.entries) {
          res[entry.key] = _convertTo(entry.value);
        }
        return {
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
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    return "$prefix${(filter.value as ModelLocale).value.toString()}";
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    return value is ModelLocale;
  }
}
