part of "/masamune_model_firebase_data_connect.dart";

/// Normal FirebaseDataConnectConverter.
///
/// 通常のFirebaseDataConnectConverter。
class FirebaseDataConnectBasicConverter
    extends FirebaseDataConnectModelFieldValueConverter {
  /// Normal FirebaseDataConnectConverter.
  ///
  /// 通常のFirebaseDataConnectConverter。
  const FirebaseDataConnectBasicConverter();

  @override
  String get type => (Object).toString();

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
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    return true;
  }
}
