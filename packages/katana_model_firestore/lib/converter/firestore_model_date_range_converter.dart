part of '/katana_model_firestore.dart';

/// FirestoreConverter for [ModelDateRange].
///
/// [ModelDateRange]用のFirestoreConverter。
class FirestoreModelDateRangeConverter
    extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelDateRange].
  ///
  /// [ModelDateRange]用のFirestoreConverter。
  const FirestoreModelDateRangeConverter();

  @override
  String get type => ModelDateRange.typeString;

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
            if (e is String) {
              final splitted = e.split("|");
              if (splitted.length == 2) {
                final start = DateTime.tryParse(splitted[0]);
                final end = DateTime.tryParse(splitted[1]);
                if (start != null && end != null) {
                  return ModelDateRange.fromDateTime(
                    start: start,
                    end: end,
                  ).toJson();
                }
              }
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
                if (v is String) {
                  final splitted = v.split("|");
                  if (splitted.length == 2) {
                    final start = DateTime.tryParse(splitted[0]);
                    final end = DateTime.tryParse(splitted[1]);
                    if (start != null && end != null) {
                      return MapEntry(
                        k,
                        ModelDateRange.fromDateTime(
                          start: start,
                          end: end,
                        ).toJson(),
                      );
                    }
                  }
                }
                return MapEntry(k, null);
              })
              .where((k, v) => v != null)
              .cast<String, DynamicMap>,
          targetKey: null,
        };
      }
    } else if (value is String) {
      final targetKey = "#$key";
      final targetMap = original.getAsMap(targetKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        final splitted = value.split("|");
        if (splitted.length == 2) {
          final start = DateTime.tryParse(splitted[0]);
          final end = DateTime.tryParse(splitted[1]);
          if (start != null && end != null) {
            return ModelDateRange.fromDateTime(
              start: start,
              end: end,
            ).toJson();
          }
        }
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
        final start = value.get<num>(ModelDateRange.kStartTimeKey, 0.0);
        final end = value.get<num>(ModelDateRange.kEndTimeKey, 0.0);
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: this.type,
            ModelDateRange.kStartTimeKey: start,
            ModelDateRange.kEndTimeKey: end,
            _kTargetKey: key,
          },
          key:
              "${DateTime.fromMicrosecondsSinceEpoch(start.toInt()).toIso8601String()}|${DateTime.fromMicrosecondsSinceEpoch(end.toInt()).toIso8601String()}",
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        final target = <DynamicMap>[];
        final res = <Object>[];
        final targetKey = "#$key";
        for (final entry in list) {
          final start = entry.get<num>(ModelDateRange.kStartTimeKey, 0.0);
          final end = entry.get<num>(ModelDateRange.kEndTimeKey, 0.0);
          target.add({
            kTypeFieldKey: type,
            ModelDateRange.kStartTimeKey: start,
            ModelDateRange.kEndTimeKey: end,
            _kTargetKey: key,
          });
          res.add(
            "${DateTime.fromMicrosecondsSinceEpoch(start.toInt()).toIso8601String()}|${DateTime.fromMicrosecondsSinceEpoch(end.toInt()).toIso8601String()}",
          );
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
          final start = entry.value.get<num>(ModelDateRange.kStartTimeKey, 0.0);
          final end = entry.value.get<num>(ModelDateRange.kEndTimeKey, 0.0);
          target[entry.key] = {
            kTypeFieldKey: type,
            ModelDateRange.kStartTimeKey: start,
            ModelDateRange.kEndTimeKey: end,
            _kTargetKey: key,
          };
          res[entry.key] =
              "${DateTime.fromMicrosecondsSinceEpoch(start.toInt()).toIso8601String()}|${DateTime.fromMicrosecondsSinceEpoch(end.toInt()).toIso8601String()}";
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
    final modelDateRange = value as ModelDateRange;
    final start = modelDateRange.value.start;
    final end = modelDateRange.value.end;
    return "${start.toIso8601String()}|${end.toIso8601String()}";
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    return value is ModelDateRange;
  }
}
