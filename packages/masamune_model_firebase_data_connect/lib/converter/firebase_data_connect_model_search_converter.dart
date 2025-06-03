part of "/masamune_model_firebase_data_connect.dart";

/// FirebaseDataConnectConverter for [ModelSearch].
///
/// [ModelSearch]用のFirebaseDataConnectConverter。
class FirebaseDataConnectModelSearchConverter
    extends FirebaseDataConnectModelFieldValueConverter {
  /// FirebaseDataConnectConverter for [ModelSearch].
  ///
  /// [ModelSearch]用のFirebaseDataConnectConverter。
  const FirebaseDataConnectModelSearchConverter();

  @override
  String get type => ModelSearch.typeString;

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
          key: ModelSearch.fromJson(json).toJson(),
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
