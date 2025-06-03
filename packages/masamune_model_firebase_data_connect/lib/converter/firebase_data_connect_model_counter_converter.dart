part of "/masamune_model_firebase_data_connect.dart";

/// FirebaseDataConnectConverter for [ModelCounter].
///
/// [ModelCounter]用のFirebaseDataConnectConverter。
class FirebaseDataConnectModelCounterConverter
    extends FirebaseDataConnectModelFieldValueConverter {
  /// FirebaseDataConnectConverter for [ModelCounter].
  ///
  /// [ModelCounter]用のFirebaseDataConnectConverter。
  const FirebaseDataConnectModelCounterConverter();

  @override
  String get type => ModelCounter.typeString;

  DynamicMap? _convertFrom(Object? value) {
    if (value == null) {
      return null;
    } else if (value is num) {
      return ModelCounter(value.toInt()).toJson();
    } else if (value is String) {
      final replaced = value.replaceAll(prefixRegExp, "");
      final number = num.tryParse(replaced);
      if (number == null) {
        return null;
      }
      return ModelCounter(number.toInt()).toJson();
    }
    return null;
  }

  String _convertTo(DynamicMap map) {
    return _convertToString(map.get<num>(ModelCounter.kValueKey, 0.0));
  }

  String _convertToString(num val) {
    final text = val.toString();
    final splitted = text.split(".");
    if (splitted.length <= 1) {
      return "$prefix${text.padLeft(64, "0")}";
    }
    final integer = splitted.first;
    final decimalPortion = splitted.last;
    return "$prefix${integer.padLeft(64, "0")}.$decimalPortion";
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
            (e) => _convertFrom(e),
          )
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
        final res = <Object>[];
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
        final res = <String, Object>{};
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
    return "$prefix${_convertToString((filter.value as ModelCounter).value)}";
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    return value is ModelCounter;
  }
}
