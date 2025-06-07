part of "/masamune_model_firebase_data_connect.dart";

/// FirebaseDataConnectConverter for [ModelTimeRange].
///
/// [ModelTimeRange]用のFirebaseDataConnectConverter。
class FirebaseDataConnectModelTimeRangeConverter
    extends FirebaseDataConnectModelFieldValueConverter {
  /// FirebaseDataConnectConverter for [ModelTimestamp].
  ///
  /// [ModelTimeRange]用のFirebaseDataConnectConverter。
  const FirebaseDataConnectModelTimeRangeConverter();

  @override
  String get type => ModelTimeRange.typeString;

  DynamicMap? _convertFrom(Object? value) {
    if (value == null) {
      return null;
    } else if (value is String) {
      final splitted = value.split("|");
      if (splitted.length == 2) {
        final start = DateTime.tryParse(splitted[0]);
        final end = DateTime.tryParse(splitted[1]);
        if (start != null && end != null) {
          return ModelTimeRange.fromDateTime(
            start: start,
            end: end,
          ).toJson();
        }
      }
    }
    return null;
  }

  String _convertTo(DynamicMap map) {
    final start = map.get<num>(ModelTimeRange.kStartTimeKey, 0.0);
    final end = map.get<num>(ModelTimeRange.kEndTimeKey, 0.0);
    return "${DateTime.fromMicrosecondsSinceEpoch(start.toInt())}|${DateTime.fromMicrosecondsSinceEpoch(end.toInt())}";
  }

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    if (value is List) {
      if (value.isNotEmpty && value.every((e) => e is Timestamp)) {
        return {
          key: value.mapAndRemoveEmpty(
            _convertFrom,
          ),
        };
      }
    } else if (value is Map) {
      if (value.isNotEmpty && value.values.every((e) => e is Timestamp)) {
        return {
          key: value.map<String, Object?>(
            (k, v) => MapEntry(
              k,
              _convertFrom(v),
            ),
          ),
        };
      }
    } else if (value is Timestamp) {
      return {
        key: _convertFrom(value),
      };
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
    final modelTimeRange = value as ModelTimeRange;
    final start = modelTimeRange.value.start;
    final end = modelTimeRange.value.end;
    return "${start.toIso8601String()}|${end.toIso8601String()}";
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    return value is ModelTimeRange;
  }
}
