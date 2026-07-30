part of "/masamune_model_turso.dart";

/// Response when reading cached collection data with
/// [CachedTursoModelAdapter].
///
/// [value] contains the data loaded from the cache. Specify [query] only when
/// Turso should continue loading with a modified query.
///
/// [CachedTursoModelAdapter]でコレクションデータのキャッシュを読み込む際のレスポンス。
///
/// [value]にキャッシュから読み込んだデータを指定します。キャッシュ読込後に変更した
/// クエリでTursoからの読込を継続する場合のみ[query]を指定してください。
@immutable
class CachedTursoModelCollectionLoaderResponse {
  /// Creates a response for a cached collection load.
  ///
  /// キャッシュされたコレクション読込のレスポンスを作成します。
  const CachedTursoModelCollectionLoaderResponse({
    required this.value,
    this.query,
  });

  /// Data loaded from the cache.
  ///
  /// キャッシュから読み込んだデータ。
  final Map<String, DynamicMap> value;

  /// Query used to continue loading from Turso.
  ///
  /// Tursoからの読込を継続する際に利用するクエリ。
  final ModelAdapterCollectionQuery? query;
}

/// Collection loader for [CachedTursoModelAdapter].
///
/// [CachedTursoModelAdapter]用のコレクションローダー。
typedef CachedTursoModelAdapterCollectionLoader
    = Future<CachedTursoModelCollectionLoaderResponse?> Function(
  ModelAdapterCollectionQuery query,
  Map<String, DynamicMap>? cache,
);
