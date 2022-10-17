part of katana_model;

/// Mix-in to make documents searchable.
///
/// This can be mixed in with `with` to make documents searchable and "display only specific strings" when querying collections.
///
/// Stores Bigram data for search in [searchValueFieldKey].
///
/// [buildSearchText] creates a string to be searched. If you want to search multiple items, combine all strings and return them as a single string.
///
/// ドキュメントを検索対象にするためのミックスイン。
///
/// これを`with`でミックスインすることでドキュメントを検索対象にしてコレクションでのクエリ時に「特定の文字列のみ表示する」といったことを実現することができます。
///
/// [searchValueFieldKey]に検索用のBigramのデータを格納します。
///
/// [buildSearchText]で検索対象の文字列を作成します。複数の項目を検索対象にしたい場合、すべての文字列を合成し１つの文字列として返してください。
///
/// ```dart
/// String buildSearchText(User user){
///   return user.name + user.description;
/// }
/// ```
///
/// Documents targeted for search will be searchable in the collection. The search is made possible by passing a query using [ModelQuery.search].
///
/// 検索対象にされたドキュメントはコレクションで検索可能になります。検索の際は[ModelQuery.search]を用いてクエリを渡すことで検索可能になります。
///
/// ```dart
/// const query = ModelQuery("collection_path", key: "name", search: "mike");
/// final collection = TestCollection(query);
/// await collection.load(false); // search results
/// ```
mixin SearchableDocumentMixin<T> on DocumentBase<T> {
  /// The field with this key contains the Bigram data for the search.
  /// 
  /// このキーを持つフィールドに検索用のBigramのデータを格納します。
  @protected
  String get searchValueFieldKey;

  /// Creates a string to be searched. If you want to search multiple items, combine all strings and return them as a single string.
  /// 
  /// 検索対象の文字列を作成します。複数の項目を検索対象にしたい場合、すべての文字列を合成し１つの文字列として返してください。
  ///
  /// ```dart
  /// String buildSearchText(User user){
  ///   return user.name + user.description;
  /// }
  /// ```
  @protected
  String buildSearchText(T value);

  @override
  @protected
  @mustCallSuper
  DynamicMap filterOnSave(DynamicMap rawData) {
    assert(
      searchValueFieldKey.isNotEmpty,
      "[searchValueFieldKey] is empty. Please specify a non-empty string.",
    );
    final searchText = buildSearchText(value as T);
    if (searchText.isEmpty) {
      return super.filterOnSave(rawData);
    }
    return super.filterOnSave(
      Map.unmodifiable({
        ...rawData,
        searchValueFieldKey: searchText
            .toLowerCase()
            .splitByBigram()
            .toMap((e) => MapEntry(e, true)),
      }),
    );
  }
}
