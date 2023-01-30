part of katana_model;

/// Mix-ins to create collections for which search functions are available.
///
/// Grant to [CollectionBase].
///
/// Documents to which [SearchableDocumentMixin] is granted are eligible.
///
/// Specify the target key in [searchValueFieldKey] in a manner consistent with [SearchableDocumentMixin.searchValueFieldKey].
///
/// When the [search] method is executed, it performs a search and stores the search results in its own [CollectionBase].
///
/// When passing a [CollectionModelQuery] to [CollectionBase], it cannot contain filtering conditions such as `isEqualTo` or sorting conditions such as `orderBy`.
///
/// If they are included, an error occurs and the search cannot be performed.
///
/// 検索機能を利用できるコレクションを作成するためのミックスイン。
///
/// [CollectionBase]に付与します。
///
/// [SearchableDocumentMixin]を付与したドキュメントが対象となります。
///
/// [searchValueFieldKey]で対象となるキーを[SearchableDocumentMixin.searchValueFieldKey]と合わせる形で指定します。
///
/// [search]メソッドを実行すると検索を行ない、検索結果を自身の[CollectionBase]に格納します。
///
/// [CollectionBase]に[CollectionModelQuery]を渡す場合、`isEqualTo`などのフィルタリング条件や`orderBy`などのソート条件を含めることができません。
///
/// それらが含まれていた場合、エラーとなり検索が行えません。
///
/// ```dart
/// class SearchableRuntimeMapDocumentModel extends DocumentBase<DynamicMap>
///     with SearchableDocumentMixin<DynamicMap> {
///   SearchableRuntimeMapDocumentModel(super.query, super.value);
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
///   String buildSearchText(DynamicMap value) {
///     return value.get("name", "") + value.get("text", "");
///   }
/// }
///
/// class SearchableRuntimeCollectionModel
///     extends CollectionBase<SearchableRuntimeMapDocumentModel>
///     with SearchableCollectionMixin<SearchableRuntimeMapDocumentModel> {
///   SearchableRuntimeCollectionModel(super.query);
///
///   @override
///   SearchableRuntimeMapDocumentModel create([String? id]) {
///     return SearchableRuntimeMapDocumentModel(
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
///   final collection = SearchableRuntimeCollectionModel(query);
///   collection.search("test");
/// }
/// ```
mixin SearchableCollectionMixin<TModel extends SearchableDocumentMixin>
    on CollectionBase<TModel> {
  /// Field key for default search.
  ///
  /// デフォルトのサーチ用のフィールドキー。
  static const defaultSearchValueFieldKey = "@search";

  /// Query to read and save collections.
  ///
  /// コレクションを読込・保存するためのクエリ。
  @override
  @protected
  CollectionModelQuery get modelQuery {
    if (_modelQuery != null) {
      return _modelQuery!;
    }
    final modelQuery = super.modelQuery;
    assert(
      modelQuery.isEqualTo == null &&
          modelQuery.isNotEqualTo == null &&
          modelQuery.isGreaterThanOrEqualTo == null &&
          modelQuery.isLessThanOrEqualTo == null &&
          modelQuery.arrayContains == null &&
          modelQuery.arrayContainsAny == null &&
          modelQuery.whereIn == null &&
          modelQuery.whereNotIn == null &&
          modelQuery.geoHash == null &&
          modelQuery.orderBy == null,
      "Filtering and sorting conditions are passed to [CollectionModelQuery]. These conditions cannot be used in a search. Please remove the conditions.",
    );
    return _modelQuery = CollectionModelQuery._(
      modelQuery.path,
      filters: [
        ...modelQuery.filters.where((e) => e.type != ModelQueryFilterType.like),
        ModelQueryFilter._(
          type: ModelQueryFilterType.like,
          key: searchValueFieldKey,
          value: "",
        ),
      ],
      adapter: modelQuery.adapter,
    );
  }

  CollectionModelQuery? _modelQuery;

  /// The field with this key contains the Bigram data for the search.
  ///
  /// このキーを持つフィールドに検索用のBigramのデータを格納します。
  @protected
  String get searchValueFieldKey => defaultSearchValueFieldKey;

  /// Search within a collection with [searchText].
  ///
  /// It is [reload] internally and the search results are returned in [CollectionBase].
  ///
  /// It is not possible to filter or sort and return values using [CollectionModelQuery] keys in conjunction with a search.
  ///
  /// Sorting, etc., should be done on the client side to sort the search results before returning them.
  ///
  /// [searchText]でコレクション内の検索を行います。
  ///
  /// 内部で[reload]され検索結果が[CollectionBase]で返されます。
  ///
  /// 検索と併せて[CollectionModelQuery]のキーを用いたフィルタリングやソートして値を返すことはできません。
  ///
  /// ソートなどは検索結果をクライアント側でソートしてから返してください。
  Future<CollectionBase<TModel>> search(String searchText) async {
    _databaseQuery = null;
    _modelQuery = CollectionModelQuery._(
      modelQuery.path,
      filters: [
        ...modelQuery.filters.where((e) => e.type != ModelQueryFilterType.like),
        ModelQueryFilter._(
          type: ModelQueryFilterType.like,
          key: searchValueFieldKey,
          value: searchText,
        ),
      ],
      adapter: modelQuery.adapter,
    );
    return await reload();
  }
}
