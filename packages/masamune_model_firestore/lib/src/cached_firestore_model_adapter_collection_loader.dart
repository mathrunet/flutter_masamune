part of "/masamune_model_firestore.dart";

/// Type definition for the collection loader of [CachedFirestoreModelAdapter].
///
/// [CachedFirestoreModelAdapter]のコレクションローダーの型定義。
typedef CachedFirestoreModelAdapterCollectionLoader
    = Future<CachedFirestoreModelCollectionLoaderResponse?> Function(
  ModelAdapterCollectionQuery query,
  Map<String, DynamicMap>? cache,
);
