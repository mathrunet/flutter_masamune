part of "/katana_model_firestore.dart";

/// Response when reading the cache of data in the collection at [CachedFirestoreModelAdapter].
///
/// The data read from the cache is entered in [value]. If there is no data, [null] is entered.
///
/// [query] should be specified only if you want to change the query after reading data from the cache.
///
/// [CachedFirestoreModelAdapter]にてコレクションのデータのキャッシュを読み込む際のレスポンス。
///
/// [value]にキャッシュから読み込まれたデータが入ります。データがない場合は[null]が入ります。
///
/// [query]にはキャッシュからデータを読み込んだ後、クエリを変更したい場合にのみ指定してください。
@immutable
class CachedFirestoreModelCollectionLoaderResponse {
  /// Response when reading the cache of data in the collection at [CachedFirestoreModelAdapter].
  ///
  /// The data read from the cache is entered in [value]. If there is no data, [null] is entered.
  ///
  /// [query] should be specified only if you want to change the query after reading data from the cache.
  ///
  /// [CachedFirestoreModelAdapter]にてコレクションのデータのキャッシュを読み込む際のレスポンス。
  ///
  /// [value]にキャッシュから読み込まれたデータが入ります。データがない場合は[null]が入ります。
  ///
  /// [query]にはキャッシュからデータを読み込んだ後、クエリを変更したい場合にのみ指定してください。
  const CachedFirestoreModelCollectionLoaderResponse({
    required this.value,
    this.query,
  });

  /// The data read from the cache. If there is no data, [null] is entered.
  ///
  /// キャッシュから読み込まれたデータ。データがない場合は[null]が入ります。
  final Map<String, DynamicMap> value;

  /// [query] should be specified only if you want to change the query after reading data from the cache.
  ///
  /// [query]にはキャッシュからデータを読み込んだ後、クエリを変更したい場合にのみ指定してください。
  final ModelAdapterCollectionQuery? query;
}
