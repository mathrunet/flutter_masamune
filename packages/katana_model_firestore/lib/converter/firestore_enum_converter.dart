part of '/katana_model_firestore.dart';

/// FirestoreConverter for [Enum].
///
/// [Enum]用のFirestoreConverter。
class FirestoreEnumConverter extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [Enum].
  ///
  /// [Enum]用のFirestoreConverter。
  const FirestoreEnumConverter();

  @override
  String get type => (Enum).toString();

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original, [
    FirestoreModelAdapterBase? adapter,
  ]) =>
      null;

  @override
  DynamicMap? convertTo(
    String key,
    Object? value,
    DynamicMap original, [
    FirestoreModelAdapterBase? adapter,
  ]) =>
      null;

  @override
  Object? convertQueryValue(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    if (value is List) {
      return value.map((e) => (e as Enum).name).toList();
    } else if (value is Map) {
      return value.map((key, val) => MapEntry(key, (val as Enum).name));
    }
    return (value as Enum).name;
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirestoreModelAdapterBase? adapter,
  ]) {
    if (value is List) {
      return value.every((element) => element is Enum);
    } else if (value is Map) {
      return value.values.every((element) => element is Enum);
    }
    return value is Enum;
  }
}
