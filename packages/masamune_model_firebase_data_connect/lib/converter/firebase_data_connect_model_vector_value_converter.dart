part of "/masamune_model_firebase_data_connect.dart";

/// FirebaseDataConnectConverter for [ModelVectorValue].
///
/// [ModelVectorValue]用のFirebaseDataConnectConverter。
class FirebaseDataConnectModelVectorValueConverter
    extends FirebaseDataConnectModelFieldValueConverter {
  /// FirebaseDataConnectConverter for [ModelVectorValue].
  ///
  /// [ModelVectorValue]用のFirebaseDataConnectConverter。
  const FirebaseDataConnectModelVectorValueConverter();

  @override
  String get type => ModelVectorValue.typeString;

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    if (value is String) {
      final json = jsonDecodeAsMap(value);
      final type = json.get(kTypeFieldKey, "");
      if (type == this.type) {
        return {
          key: ModelVectorValue.fromJson(json).toJson(),
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
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    if (value is DynamicMap && value.containsKey(_kTypeKey)) {
      final type = value.get(_kTypeKey, "");
      if (type == this.type) {
        return {
          key: jsonEncode(value),
        };
      }
    }
    return null;
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    return false;
  }
}
