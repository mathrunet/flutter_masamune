part of "/masamune_model_firebase_data_connect.dart";

/// FirebaseDataConnectConverter for [ModelServerCommandBase].
///
/// [ModelServerCommandBase]用のFirebaseDataConnectConverter。
class FirebaseDataConnectModelCommandBaseConverter
    extends FirebaseDataConnectModelFieldValueConverter {
  /// FirebaseDataConnectConverter for [ModelServerCommandBase].
  ///
  /// [ModelServerCommandBase]用のFirebaseDataConnectConverter。
  const FirebaseDataConnectModelCommandBaseConverter();

  @override
  String get type => ModelServerCommandBase.typeString;

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
          key: ModelServerCommandBase.fromJson(json).toJson(),
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
