part of "/masamune_model_firebase_data_connect.dart";

/// FirebaseDataConnectConverter for [Null].
///
/// [Null]用のFirebaseDataConnectConverter。
class FirebaseDataConnectNullConverter
    extends FirebaseDataConnectModelFieldValueConverter {
  /// FirebaseDataConnectConverter for [Null].
  ///
  /// [Null]用のFirebaseDataConnectConverter。
  const FirebaseDataConnectNullConverter();

  @override
  String get type => (Null).toString();

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
  ]) {
    return null;
  }

  @override
  Object? convertQueryValue(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    return null;
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    return value == null;
  }
}
