part of "/masamune_model_firebase_data_connect.dart";

/// FirebaseDataConnectConverter for [Enum].
///
/// [Enum]用のFirebaseDataConnectConverter。
class FirebaseDataConnectEnumConverter
    extends FirebaseDataConnectModelFieldValueConverter {
  /// FirebaseDataConnectConverter for [Enum].
  ///
  /// [Enum]用のFirebaseDataConnectConverter。
  const FirebaseDataConnectEnumConverter();

  @override
  String get type => (Enum).toString();

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) =>
      null;

  @override
  DynamicMap? convertTo(
    String key,
    Object? value,
    DynamicMap original, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) =>
      null;

  @override
  Object? convertQueryValue(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
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
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    if (value is List) {
      return value.every((element) => element is Enum);
    } else if (value is Map) {
      return value.values.every((element) => element is Enum);
    }
    return value is Enum;
  }
}
