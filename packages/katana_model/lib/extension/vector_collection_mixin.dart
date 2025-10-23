part of "/katana_model.dart";

/// A mixin for creating collections that enable vector-based similarity search.
///
/// It allows collections to be sorted by similarity.
///
/// To be applied to [CollectionBase].
///
/// It targets documents to which [VectorDocumentMixin] has been applied.
///
/// The target key is specified using [vectorValueFieldKey] to match [VectorDocumentMixin.vectorValueFieldKey].
///
/// When the [nearest] method is executed, it performs a similarity sort and stores the sorted results in its own [CollectionBase].
///
/// When passing [CollectionModelQuery] to [CollectionBase], filtering conditions such as `isEqualTo` or sorting conditions such as `orderBy` cannot be included.
///
/// If they are included, an error will occur and the search cannot be performed.
///
/// ベクトルによる類似度検索を可能にするコレクションを作成するためのミックスイン。
///
/// コレクションを類似度によるソートを可能にします。
///
/// [CollectionBase]に付与します。
///
/// [VectorDocumentMixin]を付与したドキュメントが対象となります。
///
/// [vectorValueFieldKey]で対象となるキーを[VectorDocumentMixin.vectorValueFieldKey]と合わせる形で指定します。
///
/// [nearest]メソッドを実行すると類似度によるソートを行ない、ソート結果を自身の[CollectionBase]に格納します。
///
/// [CollectionBase]に[CollectionModelQuery]を渡す場合、`isEqualTo`などのフィルタリング条件や`orderBy`などのソート条件を含めることができません。
///
/// それらが含まれていた場合、エラーとなり検索が行えません。
///
/// ```dart
/// class VectorRuntimeMapDocumentModel extends DocumentBase<DynamicMap>
///     with VectorDocumentMixin<DynamicMap> {
///   VectorRuntimeMapDocumentModel(super.query, super.value);
///
///   @override
///   DynamicMap fromMap(DynamicMap map) {
///     return ModelFieldValue.fromMap(map);
///   }
///
///   @override
///   DynamicMap toMap(DynamicMap value) {
///     return ModelFieldValue.toMap(value);
///   }
///
///   @override
///   String buildVectorText(DynamicMap value) {
///     return value.get("name", "") + value.get("text", "");
///   }
/// }
///
/// class VectorRuntimeCollectionModel
///     extends CollectionBase<VectorRuntimeMapDocumentModel>
///     with VectorCollectionMixin<VectorRuntimeMapDocumentModel> {
///   VectorRuntimeCollectionModel(super.query);
///
///   @override
///   VectorRuntimeMapDocumentModel create([String? id]) {
///     return VectorRuntimeMapDocumentModel(
///       modelQuery.create(id),
///       {},
///     );
///   }
/// }
///
/// void search() {
///   final query = CollectionModelQuery(
///     "test",
///   );
///
///   final collection = VectorRuntimeCollectionModel(query);
///   collection.nearest("test");
/// }
/// ```
mixin VectorCollectionMixin<TModel extends VectorDocumentMixin>
    on CollectionBase<TModel> {
  /// Field key for default vector.
  ///
  /// デフォルトのベクトル用のフィールドキー。
  static const defaultVectorValueFieldKey = "@vector";

  /// Query to read and save collections.
  ///
  /// コレクションを読込・保存するためのクエリ。
  @override
  @protected
  CollectionModelQuery get modelQuery {
    final modelQuery = super.modelQuery;
    return _modelQuery = CollectionModelQuery._(
      modelQuery.path,
      filters: [
        ...modelQuery.filters
            .where((e) => e.type != ModelQueryFilterType.nearest),
        ModelQueryFilter._(
          type: ModelQueryFilterType.nearest,
          key: vectorValueFieldKey,
          value: vectorText,
        ),
      ],
      adapter: modelQuery.adapter,
    );
  }

  /// The field with this key contains the vector data for the search.
  ///
  /// このキーを持つフィールドに検索用のベクトルデータを格納します。
  @protected
  String get vectorValueFieldKey => defaultVectorValueFieldKey;

  /// Performs a similarity search within the collection using [vectorText].
  ///
  /// Internally, [reload] is performed, and the search results are returned as [CollectionBase].
  ///
  /// It is not possible to filter or sort and return values using keys from [CollectionModelQuery] in conjunction with the search.
  ///
  /// [vectorText]でコレクション内の類似度検索を行います。
  ///
  /// 内部で[reload]され検索結果が[CollectionBase]で返されます。
  ///
  /// 検索と併せて[CollectionModelQuery]のキーを用いたフィルタリングやソートして値を返すことはできません。
  Future<CollectionBase<TModel>> nearest(String vectorText) async {
    final existsFilter = _modelQuery.filters
        .firstWhereOrNull((item) => item.type == ModelQueryFilterType.nearest);
    if (existsFilter?.value?.toString() == vectorText) {
      return this;
    }
    _databaseQuery = null;
    _modelQuery = CollectionModelQuery._(
      modelQuery.path,
      filters: [
        ...modelQuery.filters
            .where((e) => e.type != ModelQueryFilterType.nearest),
        ModelQueryFilter._(
          type: ModelQueryFilterType.nearest,
          key: vectorValueFieldKey,
          value: vectorText,
        ),
      ],
      adapter: modelQuery.adapter,
    );
    return await reload();
  }

  /// Get the currently searched text.
  ///
  /// If it is not set, it is obtained as an empty character.
  ///
  /// 現在検索されているテキストを取得します。
  ///
  /// 設定されていない場合は空文字として取得されます。
  String get vectorText {
    final existsFilter = _modelQuery.filters
        .firstWhereOrNull((item) => item.type == ModelQueryFilterType.nearest);
    return existsFilter?.value?.toString() ?? "";
  }
}
