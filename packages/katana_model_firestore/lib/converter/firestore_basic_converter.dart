part of '/katana_model_firestore.dart';

/// Normal FirestoreConverter.
///
/// 通常のFirestoreConverter。
class FirestoreBasicConverter extends FirestoreModelFieldValueConverter {
  /// Normal FirestoreConverter.
  ///
  /// 通常のFirestoreConverter。
  const FirestoreBasicConverter();

  @override
  String get type => (Object).toString();

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
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query,
    FirestoreModelAdapterBase adapter,
  ) {
    return true;
  }
}
