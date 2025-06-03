part of "/masamune_model_firestore.dart";

/// Model adapter with Firebase Firestore available.
///
/// You can also save the document and collection data loaded from Firestore in [cachedLocalDatabase] and load them preferentially the next time they are loaded to reduce Firestore fees.
///
/// Data in collections can be loaded from the cache with [collectionLoaders], and the query can be modified according to the results of the loading.
///
/// It also monitors all Firestore documents for changes and notifies you of any changes on the remote side.
///
/// Firestore application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
///
/// Basically, the default [FirebaseFirestore.instance] is used, but it is possible to use a specified database by passing [database] when creating the adapter.
///
/// You can initialize Firebase by passing [options].
///
/// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
///
/// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
///
/// FirebaseFirestoreを利用できるようにしたモデルアダプター。
///
/// また、Firestoreから読み込まれたドキュメントデータやコレクションデータを[cachedLocalDatabase]に保存しておき、次回以降読み込む際はそちらを優先的に読み込みFirestoreの料金を削減することができます。
///
/// コレクションのデータは[collectionLoaders]でキャッシュのデータを読み込むことができ、読み込んだ結果に応じてクエリを変更することができます。
///
/// さらにFirestoreのすべてのドキュメントの変更を監視し、リモート側で変更があればそれを通知します。
///
/// 事前にFirestoreのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
///
/// 基本的にデフォルトの[FirebaseFirestore.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定されたデータベースを利用することが可能です。
///
/// [options]を渡すことでFirebaseの初期化を行うことができます。
///
/// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
///
/// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
class CachedListenableFirestoreModelAdapter
    extends ListenableFirestoreModelAdapter
    implements FirestoreModelAdapterBase {
  /// Model adapter with Firebase Firestore available.
  ///
  /// You can also save the document and collection data loaded from Firestore in [cachedLocalDatabase] and load them preferentially the next time they are loaded to reduce Firestore fees.
  ///
  /// Data in collections can be loaded from the cache with [collectionLoaders], and the query can be modified according to the results of the loading.
  ///
  /// It also monitors all Firestore documents for changes and notifies you of any changes on the remote side.
  ///
  /// Firestore application settings must be completed in advance and [FirebaseCore.initialize] must be executed.
  ///
  /// Basically, the default [FirebaseFirestore.instance] is used, but it is possible to use a specified database by passing [database] when creating the adapter.
  ///
  /// You can initialize Firebase by passing [options].
  ///
  /// By passing data to [initialValue], the database can be used as a data mockup because it contains data in advance.
  ///
  /// By adding [prefix], all paths can be prefixed, enabling operations such as separating data storage locations for each Flavor.
  ///
  /// FirebaseFirestoreを利用できるようにしたモデルアダプター。
  ///
  /// また、Firestoreから読み込まれたドキュメントデータやコレクションデータを[cachedLocalDatabase]に保存しておき、次回以降読み込む際はそちらを優先的に読み込みFirestoreの料金を削減することができます。
  ///
  /// コレクションのデータは[collectionLoaders]でキャッシュのデータを読み込むことができ、読み込んだ結果に応じてクエリを変更することができます。
  ///
  /// さらにFirestoreのすべてのドキュメントの変更を監視し、リモート側で変更があればそれを通知します。
  ///
  /// 事前にFirestoreのアプリ設定を済ませておくことと[FirebaseCore.initialize]を実行しておきます。
  ///
  /// 基本的にデフォルトの[FirebaseFirestore.instance]が利用されますが、アダプターの作成時に[database]を渡すことで指定されたデータベースを利用することが可能です。
  ///
  /// [options]を渡すことでFirebaseの初期化を行うことができます。
  ///
  /// [initialValue]にデータを渡すことで予めデータが入った状態でデータベースを利用することができるためデータモックとして利用することができます。
  ///
  /// [prefix]を追加することですべてのパスにプレフィックスを付与することができ、Flavorごとにデータの保存場所を分けるなどの運用が可能です。
  const CachedListenableFirestoreModelAdapter({
    super.initialValue,
    super.database,
    super.cachedRuntimeDatabase,
    NoSqlDatabase? cachedLocalDatabase,
    super.options,
    super.iosOptions,
    super.androidOptions,
    super.webOptions,
    super.linuxOptions,
    super.windowsOptions,
    super.macosOptions,
    super.prefix,
    super.validator,
    super.onInitialize,
    super.databaseId,
    this.collectionLoaders = const [],
    this.cacheFilter,
  }) : _cachedLocalDatabase = cachedLocalDatabase;

  /// Caches data retrieved from the specified internal database, Firestore.
  ///
  /// 指定の内部データベース。Firestoreから取得したデータをキャッシュします。
  NoSqlDatabase get cachedLocalDatabase {
    final database =
        _cachedLocalDatabase ?? CachedFirestoreModelAdapter.sharedLocalDatabase;
    return database;
  }

  final NoSqlDatabase? _cachedLocalDatabase;

  /// Filter for caching. Only if `true` is returned will it be cached.
  ///
  /// キャッシュフィルター。`true`を返した場合のみキャッシュされます。
  final bool Function(DocumentModelQuery query, DynamicMap value)? cacheFilter;

  /// List of collection loaders for [CachedFirestoreModelAdapter].
  ///
  /// [CachedFirestoreModelAdapter]のコレクションローダーのリスト。
  final List<CachedFirestoreModelAdapterCollectionLoader> collectionLoaders;

  @override
  Future<void> onDeleteDocument(ModelAdapterDocumentQuery query) async {
    await super.onDeleteDocument(query);
    await cachedLocalDatabase.deleteDocument(query);
  }

  @override
  Future<void> onSaveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await super.onSaveDocument(query, value);
    if (cacheFilter == null || cacheFilter!.call(query.query, value)) {
      await cachedLocalDatabase.saveDocument(query, value);
    }
  }

  @override
  Future<DynamicMap?> onPreloadDocument(
    ModelAdapterDocumentQuery query,
  ) async {
    final res = await super.onPreloadDocument(query);
    if (res != null) {
      return res;
    }
    return await cachedLocalDatabase.loadDocument(query);
  }

  @override
  Future<void> onPostloadDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  ) async {
    await super.onPostloadDocument(query, value);
    if (cacheFilter == null || cacheFilter!.call(query.query, value)) {
      await cachedLocalDatabase.saveDocument(query, value);
    }
  }

  @override
  Future<CachedFirestoreModelCollectionLoaderResponse?> onPreloadCollection(
    ModelAdapterCollectionQuery query,
  ) async {
    final superRes = await super.onPreloadCollection(query);
    if (superRes != null) {
      return superRes;
    }
    CachedFirestoreModelCollectionLoaderResponse? res;
    for (final loader in collectionLoaders) {
      res = await loader.call(res?.query ?? query, res?.value);
    }
    return res;
  }

  @override
  Future<void> onPostloadCollection(
    ModelAdapterCollectionQuery query,
    Map<String, DynamicMap> value,
  ) async {
    await super.onPostloadCollection(query, value);
    final filtered = <String, DynamicMap>{};
    for (final entry in value.entries) {
      if (cacheFilter == null ||
          cacheFilter!.call(query.query.create(entry.key), entry.value)) {
        filtered[entry.key] = entry.value;
      }
    }
    if (filtered.isNotEmpty) {
      await cachedLocalDatabase.saveCollection(query, filtered);
    }
  }

  @override
  Future<void> clearCache() async {
    await super.clearCache();
    await cachedLocalDatabase.clearAll();
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return super.hashCode ^
        _cachedLocalDatabase.hashCode ^
        collectionLoaders.hashCode;
  }
}
