part of "/katana_model_firestore.dart";

/// FirestoreConverter for [ModelVectorValue].
///
/// Currently stores vectors as arrays in Firestore.
/// When Firestore Dart SDK adds native Vector support with findNearest(),
/// this converter should be updated to use the native Vector type.
///
/// [ModelVectorValue]用のFirestoreConverter。
///
/// 現在はFirestoreに配列として保存します。
/// Firestore Dart SDKがfindNearest()を含むネイティブVector型をサポートした時、
/// このコンバーターをネイティブVector型を使用するように更新する必要があります。
class FirestoreModelVectorValueConverter
    extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelVectorValue].
  ///
  /// Currently stores vectors as arrays in Firestore.
  /// When Firestore Dart SDK adds native Vector support with findNearest(),
  /// this converter should be updated to use the native Vector type.
  ///
  /// [ModelVectorValue]用のFirestoreConverter。
  ///
  /// 現在はFirestoreに配列として保存します。
  /// Firestore Dart SDKがfindNearest()を含むネイティブVector型をサポートした時、
  /// このコンバーターをネイティブVector型を使用するように更新する必要があります。
  const FirestoreModelVectorValueConverter();

  @override
  String get type => ModelVectorValue.typeString;

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
        // Convert from stored metadata to ModelVectorValue
        return {
          key: targetList.mapAndRemoveEmpty<DynamicMap>(
            (e) {
              final vector = e.getAsList(ModelVectorValue.kVectorKey);
              if (vector.isEmpty) {
                return null;
              }
              return ModelVectorValue(
                VectorValue.fromList(vector.cast<num>()),
              ).toJson();
            },
          ),
          targetKey: null,
        };
      } else if (value.every((e) => e is num || e is List)) {
        // Direct array of numbers or nested arrays
        return {
          key: value.map<DynamicMap>((e) {
            if (e is List) {
              return ModelVectorValue(
                VectorValue.fromList(e.cast<num>()),
              ).toJson();
            }
            return const ModelVectorValue().toJson();
          }).toList(),
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
          key: targetMap.map<String, DynamicMap>(
            (k, v) {
              final vector = v.getAsList(ModelVectorValue.kVectorKey);
              if (vector.isEmpty) {
                return MapEntry(k, const ModelVectorValue().toJson());
              }
              return MapEntry(
                k,
                ModelVectorValue(
                  VectorValue.fromList(vector.cast<num>()),
                ).toJson(),
              );
            },
          ),
          targetKey: null,
        };
      }
    } else if (value is List<num>) {
      // Single vector as array of numbers
      final targetKey = "#$key";
      final targetMap = original.getAsMap(targetKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        final vector = targetMap.getAsList(ModelVectorValue.kVectorKey);
        return {
          key: ModelVectorValue(
            VectorValue.fromList(vector.cast<num>()),
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
        final fromUser = value.get(ModelVectorValue.kSourceKey, "") ==
            ModelFieldValueSource.user.name;
        final vector = value.getAsList(ModelVectorValue.kVectorKey);
        final targetKey = "#$key";

        if (fromUser) {
          // Store vector data in metadata and the actual vector array
          return {
            targetKey: {
              kTypeFieldKey: type,
              ModelVectorValue.kVectorKey: vector,
              _kTargetKey: key,
            },
            key:
                vector, // Store actual vector for future Firestore Vector support
          };
        } else {
          // Server-side vectors
          return {
            targetKey: {
              kTypeFieldKey: type,
              ModelVectorValue.kVectorKey: vector,
              _kTargetKey: key,
            },
          };
        }
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        final target = <DynamicMap>[];
        final res = <List<double>>[];
        final targetKey = "#$key";
        for (final entry in list) {
          final fromUser = entry.get(ModelVectorValue.kSourceKey, "") ==
              ModelFieldValueSource.user.name;
          final vector = entry.getAsList(ModelVectorValue.kVectorKey);
          target.add({
            kTypeFieldKey: type,
            ModelVectorValue.kVectorKey: vector,
            _kTargetKey: key,
          });
          if (fromUser && vector.isNotEmpty) {
            res.add(vector.cast<double>());
          }
        }
        return {
          targetKey: target,
          if (res.isNotEmpty) key: res,
        };
      }
    } else if (value is Map) {
      final map = value
          .where((key, value) => value is DynamicMap)
          .cast<String, DynamicMap>();
      if (map.isNotEmpty &&
          map.values.every((e) => e.get(_kTypeKey, "") == type)) {
        final target = <String, DynamicMap>{};
        final res = <String, List<double>>{};
        final targetKey = "#$key";
        for (final entry in map.entries) {
          final fromUser = entry.value.get(ModelVectorValue.kSourceKey, "") ==
              ModelFieldValueSource.user.name;
          final vector = entry.value.getAsList(ModelVectorValue.kVectorKey);
          target[entry.key] = {
            kTypeFieldKey: type,
            ModelVectorValue.kVectorKey: vector,
            _kTargetKey: key,
          };
          if (fromUser && vector.isNotEmpty) {
            res[entry.key] = vector.cast<double>();
          }
        }
        return {
          targetKey: target,
          if (res.isNotEmpty) key: res,
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
    return (value as ModelVectorValue).value.vector;
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    return value is ModelVectorValue;
  }
}
