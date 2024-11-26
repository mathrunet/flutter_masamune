part of '/masamune_model_firebase_data_connect.dart';

const _kTypeKey = "@type";

/// Base class for converting [ModelFieldValue] for use in FirebaseDataConnect.
///
/// FirebaseDataConnectで利用するための[ModelFieldValue]の変換を行うベースクラス。
@immutable
abstract class FirebaseDataConnectModelFieldValueConverter {
  /// Base class for converting [ModelFieldValue] for use in FirebaseDataConnect.
  ///
  /// FirebaseDataConnectで利用するための[ModelFieldValue]の変換を行うベースクラス。
  const FirebaseDataConnectModelFieldValueConverter();

  /// Prefix for discrimination.
  ///
  /// 判別用のプレフィックス。
  String get prefix => "${type.toBase64()}#";

  /// Regular expression for prefix.
  ///
  /// プレフィックス用の正規表現。
  RegExp get prefixRegExp => RegExp("^$prefix");

  /// List of converters for converting FirebaseDataConnect values.
  ///
  /// FirebaseDataConnectの値を変換するためのコンバーター一覧。
  static const Set<FirebaseDataConnectModelFieldValueConverter>
      defaultConverters = {
    FirebaseDataConnectModelCommandBaseConverter(),
    FirebaseDataConnectModelCounterConverter(),
    FirebaseDataConnectModelDateConverter(),
    // Timestampを必ず変換するためTimestamp変換系はこれを一番最後にすること
    FirebaseDataConnectModelTimestampConverter(),
    FirebaseDataConnectModelLocaleConverter(),
    FirebaseDataConnectModelLocalizedValueConverter(),
    FirebaseDataConnectModelUriConverter(),
    FirebaseDataConnectModelImageUriConverter(),
    FirebaseDataConnectModelVideoUriConverter(),
    FirebaseDataConnectModelSearchConverter(),
    FirebaseDataConnectModelTokenConverter(),
    FirebaseDataConnectModelGeoValueConverter(),
    FirebaseDataConnectModelRefConverter(),
    FirebaseDataConnectEnumConverter(),
    FirebaseDataConnectNullConverter(),
    FirebaseDataConnectBasicConverter(),
  };

  /// The type of [ModelFieldValue] that can be converted.
  ///
  /// 変換可能な[ModelFieldValue]の型。
  String get type;

  /// Convert from FirebaseDataConnect manageable type to [ModelFieldValue].
  ///
  /// Generate and return a [DynamicMap] value from [key] and [value]. [original] is passed the [DynamicMap] before conversion.
  ///
  /// Return [Null] if there are no changes.
  ///
  /// [FirebaseDataConnectModelAdapterBase] is passed to [adapter].
  ///
  /// FirebaseDataConnectで管理可能な型から[ModelFieldValue]に変換します。
  ///
  /// [key]と[value]から[DynamicMap]の値を生成して返してください。[original]は変換前の[DynamicMap]を渡します。
  ///
  /// 変更がない場合は[Null]を返してください。
  ///
  /// [adapter]に[FirebaseDataConnectModelAdapterBase]が渡されます。
  DynamicMap? convertFrom(
    String key,
    Object? value,
    DynamicMap original, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]);

  /// Convert from [ModelFieldValue] to a type that can be managed by FirebaseDataConnect.
  ///
  /// Generate and return a [DynamicMap] value from [key] and [value]. [original] is passed the [DynamicMap] before conversion.
  ///
  /// Return [Null] if there are no changes.
  ///
  /// [FirebaseDataConnectModelAdapterBase] is passed to [adapter].
  ///
  /// [ModelFieldValue]からFirebaseDataConnectで管理可能な型に変換します。
  ///
  /// [key]と[value]から[DynamicMap]の値を生成して返してください。[original]は変換前の[DynamicMap]を渡します。
  ///
  /// 変更がない場合は[Null]を返してください。
  ///
  /// [adapter]に[FirebaseDataConnectModelAdapterBase]が渡されます。
  DynamicMap? convertTo(
    String key,
    Object? value,
    DynamicMap original, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]);

  /// Returns `true` if the query is possible.
  ///
  /// The value to be queried is passed in [value], the filter class to be queried is passed in [filter], and [query] is passed in [ModelAdapterCollectionQuery].
  ///
  /// [FirebaseDataConnectModelAdapterBase] is passed to [adapter].
  ///
  /// クエリが可能な場合は`true`を返します。
  ///
  /// [value]にはクエリを行う値、[filter]にはクエリを行うためのフィルタークラス、[query]には[ModelAdapterCollectionQuery]が渡されます。
  ///
  /// [adapter]に[FirebaseDataConnectModelAdapterBase]が渡されます。
  bool enabledQuery(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]);

  /// Converts keys for queries.
  ///
  /// Return the key after conversion.
  ///
  /// [key] is the key to query, [filter] is the filter class to query, and [query] is passed [ModelAdapterCollectionQuery].
  ///
  /// [FirebaseDataConnectModelAdapterBase] is passed to [adapter].
  ///
  /// クエリー用のキーを変換します。
  ///
  /// 変換後のキーを返してください。
  ///
  /// [key]にはクエリを行うキー、[filter]にはクエリを行うためのフィルタークラス、[query]には[ModelAdapterCollectionQuery]が渡されます。
  ///
  /// [adapter]に[FirebaseDataConnectModelAdapterBase]が渡されます。
  String convertQueryKey(
    String key,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) =>
      key;

  /// Convert values for queries.
  ///
  /// Return the converted value.
  ///
  /// The value to be queried is passed in [value], the filter class to be queried is passed in [filter], and [query] is passed in [ModelAdapterCollectionQuery].
  ///
  /// [FirebaseDataConnectModelAdapterBase] is passed to [adapter].
  ///
  /// クエリー用の値を変換します。
  ///
  /// 変換後の値を返してください。
  ///
  /// [value]にはクエリを行う値、[filter]にはクエリを行うためのフィルタークラス、[query]には[ModelAdapterCollectionQuery]が渡されます。
  ///
  /// [adapter]に[FirebaseDataConnectModelAdapterBase]が渡されます。
  Object? convertQueryValue(
    Object? value,
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) =>
      value;

  /// Generate a query object for FirebaseDataConnect.
  ///
  /// FirebaseDataConnect用のクエリーオブジェクトを生成します。
  Object? filterQuery(
    ModelQueryFilter filter,
    ModelAdapterCollectionQuery query, [
    FirebaseDataConnectModelAdapterBase? adapter,
  ]) {
    if (!enabledQuery(filter.value, filter, query, adapter)) {
      return null;
    }
    if (filter.key.isEmpty) {
      return null;
    }
    switch (filter.type) {
      case ModelQueryFilterType.equalTo:
        return convertQueryValue(
          filter.value,
          filter,
          query,
          adapter,
        );
      case ModelQueryFilterType.notEqualTo:
        return convertQueryValue(
          filter.value,
          filter,
          query,
          adapter,
        );
      case ModelQueryFilterType.lessThan:
        return convertQueryValue(
          filter.value,
          filter,
          query,
          adapter,
        );
      case ModelQueryFilterType.greaterThan:
        return convertQueryValue(
          filter.value,
          filter,
          query,
          adapter,
        );
      case ModelQueryFilterType.lessThanOrEqualTo:
        return convertQueryValue(
          filter.value,
          filter,
          query,
          adapter,
        );
      case ModelQueryFilterType.greaterThanOrEqualTo:
        return convertQueryValue(
          filter.value,
          filter,
          query,
          adapter,
        );
      case ModelQueryFilterType.arrayContains:
        return convertQueryValue(
          filter.value,
          filter,
          query,
          adapter,
        );
      case ModelQueryFilterType.like:
        return convertQueryValue(
          filter.value,
          filter,
          query,
          adapter,
        );
      case ModelQueryFilterType.isNull:
        return convertQueryValue(
          filter.value,
          filter,
          query,
          adapter,
        );
      case ModelQueryFilterType.isNotNull:
        return convertQueryValue(
          filter.value,
          filter,
          query,
          adapter,
        );
      default:
        break;
    }
    return null;
  }
}
