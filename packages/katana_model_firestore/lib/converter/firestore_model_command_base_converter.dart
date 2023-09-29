part of katana_model_firestore;

/// FirestoreConverter for [ModelServerCommandBase].
///
/// [ModelServerCommandBase]用のFirestoreConverter。
class FirestoreModelCommandBaseConverter
    extends FirestoreModelFieldValueConverter {
  /// FirestoreConverter for [ModelServerCommandBase].
  ///
  /// [ModelServerCommandBase]用のFirestoreConverter。
  const FirestoreModelCommandBaseConverter();

  @override
  String get type => ModelServerCommandBase.typeString;

  @override
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original,
    FirestoreModelAdapterBase adapter,
  ) {
    if (value is String) {
      final targetKey = "#$key";
      final targetMap = original.getAsMap(targetKey);
      final publicParameters =
          targetMap.getAsMap(ModelServerCommandBase.kPublicParametersKey);
      final privateParameters =
          targetMap.getAsMap(ModelServerCommandBase.kPrivateParametersKey);
      final type = targetMap.get(_kTypeKey, "");
      if (type == this.type) {
        return {
          key: ModelServerCommandBase(
            value,
            publicParameters: publicParameters,
            privateParameters: privateParameters,
          ).toJson()
        };
      }
    }
    return null;
  }

  @override
  DynamicMap? convertTo(
    String key,
    Object? value,
    DynamicMap original,
    FirestoreModelAdapterBase adapter,
  ) {
    if (value is DynamicMap && value.containsKey(_kTypeKey)) {
      final type = value.get(_kTypeKey, "");
      if (type == this.type) {
        final command = value.get(ModelServerCommandBase.kCommandKey, "");
        final publicParameters =
            value.getAsMap(ModelServerCommandBase.kPublicParametersKey);
        final privateParameters =
            value.getAsMap(ModelServerCommandBase.kPrivateParametersKey);
        final targetKey = "#$key";
        return {
          ...publicParameters,
          targetKey: {
            kTypeFieldKey: this.type,
            ModelServerCommandBase.kCommandKey: command,
            ModelServerCommandBase.kPublicParametersKey: publicParameters,
            ModelServerCommandBase.kPrivateParametersKey: privateParameters,
            _kTargetKey: key,
          },
          key: command,
        };
      }
    }
    return null;
  }

  @override
  Object? convertQueryValue(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query,
    FirestoreModelAdapterBase adapter,
  ) {
    return (filter.value as ModelServerCommandBase).value;
  }

  @override
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query,
    FirestoreModelAdapterBase adapter,
  ) {
    return value is ModelServerCommandBase;
  }
}
