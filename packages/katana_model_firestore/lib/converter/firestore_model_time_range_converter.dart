part of '/katana_model_firestore.dart';

/// FirestoreConverter for [ModelTimeRange].
///
/// [ModelTimeRange]用のFirestoreConverter。
class FirestoreModelTimeRangeConverter
    extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelTimeRange].
  ///
  /// [ModelTimeRange]用のFirestoreConverter。
  const FirestoreModelTimeRangeConverter();

  @override
  String get type => ModelTimeRange.typeString;

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
                  return ModelTimeRange.fromDateTime(
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
                        ModelTimeRange.fromDateTime(
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
            return ModelTimeRange.fromDateTime(
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
        final start = value.getAsDouble(ModelTimeRange.kStartTimeKey);
        final end = value.getAsDouble(ModelTimeRange.kEndTimeKey);
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: this.type,
            ModelTimeRange.kStartTimeKey: start,
            ModelTimeRange.kEndTimeKey: end,
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
          final start = entry.getAsDouble(ModelTimeRange.kStartTimeKey);
          final end = entry.getAsDouble(ModelTimeRange.kEndTimeKey);
          target.add({
            kTypeFieldKey: type,
            ModelTimeRange.kStartTimeKey: start,
            ModelTimeRange.kEndTimeKey: end,
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
          final start = entry.value.getAsDouble(ModelTimeRange.kStartTimeKey);
          final end = entry.value.getAsDouble(ModelTimeRange.kEndTimeKey);
          target[entry.key] = {
            kTypeFieldKey: type,
            ModelTimeRange.kStartTimeKey: start,
            ModelTimeRange.kEndTimeKey: end,
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
    FirestoreModelAdapterBase? adapter,
  ]) {
    return value is ModelTimeRange;
  }
}
