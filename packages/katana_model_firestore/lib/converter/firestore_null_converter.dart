part of katana_model_firestore;

/// FirestoreConverter for [Null].
///
/// [Null]用のFirestoreConverter。
class FirestoreNullConverter extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [Null].
  ///
  /// [Null]用のFirestoreConverter。
  const FirestoreNullConverter();

  @override
  String get type => (Null).toString();

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original,
    FirestoreModelAdapterBase adapter,
  ) =>
      null;

  @override
  DynamicMap? convertTo(
    String key,
    Object? value,
    DynamicMap original,
    FirestoreModelAdapterBase adapter,
  ) {
    if (value is DynamicMap && original.containsKey(key)) {
      final originalMap = original[key];
      if (originalMap is Map) {
        final newRes = Map<String, dynamic>.from(value);
        for (final o in originalMap.entries) {
          if (!value.containsKey(o.key) || value[o.key] == null) {
            newRes[o.key] = FieldValue.delete();
          }
        }
        return {key: newRes};
      }
    } else if (value == null) {
      return {key: FieldValue.delete()};
    }
    return null;
  }

  @override
  Object? convertQueryValue(
    Object? value,
    FirestoreModelAdapterBase adapter,
  ) =>
      null;
}
