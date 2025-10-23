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
  ///stores vectors as arrays in Firestore.
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
      final targetMap = original.getAsMap(targetKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        return {
          key: ModelVectorValue(
            VectorValue.fromList(value.whereType<num>().toList()),
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
        final val = value
            .getAsList<num>(ModelVectorValue.kVectorKey)
            .map((e) => e.toDouble())
            .toList();
        final targetKey = "#$key";
        return {
          targetKey: {
            kTypeFieldKey: ModelVectorValue.typeString,
            _kTargetKey: key,
          },
          // TODO: Update to native Vector type when Firestore Dart SDK supports it.
          if (fromUser) key: val,
        };
      }
    } else if (value is List) {
      final list = value.whereType<DynamicMap>();
      if (list.isNotEmpty && list.every((e) => e.get(_kTypeKey, "") == type)) {
        throw UnsupportedError(
            "ModelVectorValue cannot be included in a listing or map. It must be placed in the top field.");
      }
    } else if (value is Map) {
      final map = value
          .where((key, value) => value is DynamicMap)
          .cast<String, DynamicMap>();
      if (map.isNotEmpty &&
          map.values.every((e) => e.get(_kTypeKey, "") == type)) {
        throw UnsupportedError(
            "ModelVectorValue cannot be included in a listing or map. It must be placed in the top field.");
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
