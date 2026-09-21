part of "/masamune_model_do.dart";

/// Response when reading cached collection data with
/// [CachedDurableObjectModelAdapter].
///
/// [value] contains the data loaded from the cache. Specify [query] only when
/// DurableObject should continue loading with a modified query.
///
/// [CachedDurableObjectModelAdapter]でコレクションデータのキャッシュを読み込む際のレスポンス。
///
/// [value]にキャッシュから読み込んだデータを指定します。キャッシュ読込後に変更した
/// クエリでDurableObjectからの読込を継続する場合のみ[query]を指定してください。
@immutable
class CachedDurableObjectModelCollectionLoaderResponse {
  /// Creates a response for a cached collection load.
  ///
  /// キャッシュされたコレクション読込のレスポンスを作成します。
  const CachedDurableObjectModelCollectionLoaderResponse({
    required this.value,
    this.query,
  });

  /// Data loaded from the cache.
  ///
  /// キャッシュから読み込んだデータ。
  final Map<String, DynamicMap> value;

  /// Query used to continue loading from DurableObject.
  ///
  /// DurableObjectからの読込を継続する際に利用するクエリ。
  final ModelAdapterCollectionQuery? query;
}

/// Collection loader for [CachedDurableObjectModelAdapter].
///
/// [CachedDurableObjectModelAdapter]用のコレクションローダー。
typedef CachedDurableObjectModelAdapterCollectionLoader
    = Future<CachedDurableObjectModelCollectionLoaderResponse?> Function(
  ModelAdapterCollectionQuery query,
  Map<String, DynamicMap>? cache,
);
