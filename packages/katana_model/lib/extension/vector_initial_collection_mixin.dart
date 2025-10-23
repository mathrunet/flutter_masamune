part of "/katana_model.dart";

/// A mixin for enabling similarity search on [ModelInitialCollection].
///
/// By mixing this in with `with`, you can make mock data searchable and achieve functionalities like "sorting by proximity to specific characters" when querying a collection.
///
/// When [AsyncVectorConverter] is specified for [ModelAdapter.vectorConverter], the conversion process will not be applied.
///
/// Store the vector data for searching in [vectorValueFieldKey].
///
/// Create the search target string using [buildSearchText]. If you want to make multiple items searchable, concatenate all strings and return them as a single string.
///
/// [ModelInitialCollection]を類似検索対象にするためのミックスイン。
///
/// これを`with`でミックスインすることでモックデータを検索対象にしてコレクションでのクエリ時に「特定の文字に近い順にソート」といったことを実現することができます。
///
/// [ModelAdapter.vectorConverter]で[AsyncVectorConverter]を指定している場合、変換処理は適用されません。
///
/// [vectorValueFieldKey]に検索用のVectorデータを格納します。
///
/// [buildSearchText]で検索対象の文字列を作成します。複数の項目を検索対象にしたい場合、すべての文字列を合成し１つの文字列として返してください。
///
/// ```dart
/// String buildSearchText(User user){
///   return user.name + user.description;
/// }
/// ```
///
/// To enable searching for a collection, mix in [VectorCollectionMixin].
/// Then, perform searches using [VectorCollectionMixin.nearest].
///
/// 検索を行うコレクションには[VectorCollectionMixin]をミックスインして検索できるようにします。
/// その後、[VectorCollectionMixin.nearest]を利用して検索を行います。
mixin VectorInitialCollectionMixin<T> on ModelInitialCollection<T> {
  /// Field key for default search.
  ///
  /// デフォルトのサーチ用のフィールドキー。
  static const defaultVectorValueFieldKey = "@vector";

  /// The field with this key contains the Bigram data for the search.
  ///
  /// このキーを持つフィールドに検索用のBigramのデータを格納します。
  @protected
  String get vectorValueFieldKey => defaultVectorValueFieldKey;

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
  DynamicMap filterOnSave(DynamicMap rawData, T value, ModelAdapter adapter) {
    final vectorConverter = adapter.vectorConverter;
    if (vectorConverter is! SyncedVectorConverter) {
      debugPrint(
        "[VectorInitialCollectionMixin] The adapter's vectorConverter is not SyncedVectorConverter, so the vector conversion process will be skipped.",
      );
      return super.filterOnSave(rawData, value, adapter);
    }
    assert(
      vectorValueFieldKey.isNotEmpty,
      "[vectorValueFieldKey] is empty. Please specify a non-empty string.",
    );
    final searchText = buildSearchText(value);
    if (searchText.isEmpty) {
      return super.filterOnSave(rawData, value, adapter);
    }
    return super.filterOnSave(
      Map.unmodifiable({
        ...rawData,
        vectorValueFieldKey: vectorConverter.toVector(searchText),
      }),
      value,
      adapter,
    );
  }
}
