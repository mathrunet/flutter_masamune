part of "/masamune_model_tidb.dart";

/// Response when reading cached collection data with
/// [CachedTidbModelAdapter].
///
/// [value] contains the data loaded from the cache. Specify [query] only when
/// TiDB should continue loading with a modified query.
///
/// [CachedTidbModelAdapter]でコレクションデータのキャッシュを読み込む際のレスポンス。
///
/// [value]にキャッシュから読み込んだデータを指定します。キャッシュ読込後に変更した
/// クエリでTiDBからの読込を継続する場合のみ[query]を指定してください。
@immutable
class CachedTidbModelCollectionLoaderResponse {
  /// Creates a response for a cached collection load.
  ///
  /// キャッシュされたコレクション読込のレスポンスを作成します。
  const CachedTidbModelCollectionLoaderResponse({
    required this.value,
    this.query,
  });

  /// Data loaded from the cache.
  ///
  /// キャッシュから読み込んだデータ。
  final Map<String, DynamicMap> value;

  /// Query used to continue loading from TiDB.
  ///
  /// TiDBからの読込を継続する際に利用するクエリ。
  final ModelAdapterCollectionQuery? query;
}

/// Collection loader for [CachedTidbModelAdapter].
///
/// [CachedTidbModelAdapter]用のコレクションローダー。
typedef CachedTidbModelAdapterCollectionLoader
    = Future<CachedTidbModelCollectionLoaderResponse?> Function(
  ModelAdapterCollectionQuery query,
  Map<String, DynamicMap>? cache,
);
