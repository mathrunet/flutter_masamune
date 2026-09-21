part of "/masamune_model_d1.dart";

/// Response when reading cached collection data with
/// [CachedD1ModelAdapter].
///
/// [value] contains the data loaded from the cache. Specify [query] only when
/// D1 should continue loading with a modified query.
///
/// [CachedD1ModelAdapter]でコレクションデータのキャッシュを読み込む際のレスポンス。
///
/// [value]にキャッシュから読み込んだデータを指定します。キャッシュ読込後に変更した
/// クエリでD1からの読込を継続する場合のみ[query]を指定してください。
@immutable
class CachedD1ModelCollectionLoaderResponse {
  /// Creates a response for a cached collection load.
  ///
  /// キャッシュされたコレクション読込のレスポンスを作成します。
  const CachedD1ModelCollectionLoaderResponse({
    required this.value,
    this.query,
  });

  /// Data loaded from the cache.
  ///
  /// キャッシュから読み込んだデータ。
  final Map<String, DynamicMap> value;

  /// Query used to continue loading from D1.
  ///
  /// D1からの読込を継続する際に利用するクエリ。
  final ModelAdapterCollectionQuery? query;
}

/// Collection loader for [CachedD1ModelAdapter].
///
/// [CachedD1ModelAdapter]用のコレクションローダー。
typedef CachedD1ModelAdapterCollectionLoader
    = Future<CachedD1ModelCollectionLoaderResponse?> Function(
  ModelAdapterCollectionQuery query,
  Map<String, DynamicMap>? cache,
);
