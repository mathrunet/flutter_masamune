part of katana_model_firestore;

/// FirestoreConverter for [Enum].
///
/// [Enum]用のFirestoreConverter。
class FirestoreEnumConverter extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [Enum].
  ///
  /// [Enum]用のFirestoreConverter。
  const FirestoreEnumConverter();

  @override
  String get type => (ModelCounter).toString();

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
  ) =>
      null;

  @override
  Object? convertQueryValue(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query,
    FirestoreModelAdapterBase adapter,
  ) {
    return (filter.value as Enum).name;
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query,
    FirestoreModelAdapterBase adapter,
  ) {
    return value is Enum;
  }
}
