part of katana_model;

/// Mix-in to search for [ModelInitialCollection].
///
/// This can be mixed in with `with` to make mock data searchable and "display only specific strings" when querying collections.
///
/// Stores Bigram data for search in [searchValueFieldKey].
///
/// [buildSearchText] creates a string to be searched. If you want to search multiple items, combine all strings and return them as a single string.
///
/// [ModelInitialCollection]を検索対象にするためのミックスイン。
///
/// これを`with`でミックスインすることでモックデータを検索対象にしてコレクションでのクエリ時に「特定の文字列のみ表示する」といったことを実現することができます。
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
/// A collection that performs searches should have [SearchableCollectionMixin] mixed in so that it can be searched.
/// Then use [SearchableCollectionMixin.search] to perform the search.
///
/// 検索を行うコレクションには[SearchableCollectionMixin]をミックスインして検索できるようにします。
/// その後、[SearchableCollectionMixin.search]を利用して検索を行います。
mixin SearchableInitialCollectionMixin<T> on ModelInitialCollection<T> {
  /// Field key for default search.
  ///
  /// デフォルトのサーチ用のフィールドキー。
  static const defaultSearchValueFieldKey = "@search";

  /// The field with this key contains the Bigram data for the search.
  ///
  /// このキーを持つフィールドに検索用のBigramのデータを格納します。
  @protected
  String get searchValueFieldKey => defaultSearchValueFieldKey;

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
  DynamicMap filterOnSave(DynamicMap rawData, T value) {
    assert(
      searchValueFieldKey.isNotEmpty,
      "[searchValueFieldKey] is empty. Please specify a non-empty string.",
    );
    final searchText = buildSearchText(value);
    if (searchText.isEmpty) {
      return super.filterOnSave(rawData, value);
    }
    return super.filterOnSave(
      Map.unmodifiable({
        ...rawData,
        searchValueFieldKey: searchText
            .toLowerCase()
            // .toHankakuNumericAndAlphabet()
            // .toZenkakuKatakana()
            // .toKatakana()
            .splitByCharacterAndBigram()
            .distinct()
            .toMap((e) => MapEntry(e, true)),
      }),
      value,
    );
  }
}
