part of "/katana_model.dart";

/// A mixin for making documents searchable by similarity.
///
/// By mixing this in with `with`, you can make documents searchable, enabling queries such as "finding elements similar to a specific string" when querying collections.
///
/// Bigram data for search is stored in [vectorValueFieldKey].
///
/// Text for the vector data to be searched is created using [buildVectorText]. If you want to search multiple items, combine all strings and return them as a single string.
///
/// ドキュメントを類似度検索の対象にするためのミックスイン。
///
/// これを`with`でミックスインすることでドキュメントを検索対象にしてコレクションでのクエリ時に「特定の文字列に近い要素の検索」といったことを実現することができます。
///
/// [vectorValueFieldKey]に検索用のBigramのデータを格納します。
///
/// [buildVectorText]で検索対象のベクトルデータにするためのテキストを作成します。複数の項目を検索対象にしたい場合、すべての文字列を合成し１つの文字列として返してください。
///
/// ```dart
/// String buildVectorText(User user){
///   return user.name + user.description;
/// }
/// ```
///
/// Collections that perform searches can be made searchable by mixing in [VectorCollectionMixin].
/// Then, perform a similarity search using [VectorCollectionMixin.nearest].
///
/// 検索を行うコレクションには[VectorCollectionMixin]をミックスインして検索できるようにします。
/// その後、[VectorCollectionMixin.nearest]を利用して類似度検索を行います。
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
mixin VectorDocumentMixin<T> on DocumentBase<T> {
  /// Field key for default vector.
  ///
  /// デフォルトのベクトル用のフィールドキー。
  static const defaultVectorValueFieldKey = "@vector";

  /// The field with this key contains the Bigram data for the vector.
  ///
  /// このキーを持つフィールドにベクトル用のBigramのデータを格納します。
  @protected
  String get vectorValueFieldKey => defaultVectorValueFieldKey;

  /// Creates a string to be searched. If you want to search multiple items, combine all strings and return them as a single string.
  ///
  /// 検索対象の文字列を作成します。複数の項目を検索対象にしたい場合、すべての文字列を合成し１つの文字列として返してください。
  ///
  /// ```dart
  /// String buildVectorText(User user){
  ///   return user.name + user.description;
  /// }
  /// ```
  @protected
  String buildVectorText(T value);

  @override
  @protected
  @mustCallSuper
  DynamicMap filterOnSave(DynamicMap rawData) {
    final vectorConverter = modelQuery.adapter.vectorConverter;
    if (vectorConverter is! SyncedVectorConverter) {
      return super.filterOnSave(rawData);
    }
    assert(
      vectorValueFieldKey.isNotEmpty,
      "[vectorValueFieldKey] is empty. Please specify a non-empty string.",
    );
    final vectorText = buildVectorText(fromMap(rawData));
    if (vectorText.isEmpty) {
      return super.filterOnSave(rawData);
    }
    return super.filterOnSave(
      Map.unmodifiable(<String, dynamic>{
        ...rawData,
        vectorValueFieldKey: vectorConverter.toVector(vectorText),
      }),
    );
  }

  @override
  @protected
  Future<void> saveRequest(DynamicMap map) async {
    final vectorConverter = modelQuery.adapter.vectorConverter;
    if (vectorConverter is! AsyncVectorConverter) {
      return await modelQuery.adapter.saveDocument(databaseQuery, map);
    }
    assert(
      vectorValueFieldKey.isNotEmpty,
      "[vectorValueFieldKey] is empty. Please specify a non-empty string.",
    );
    final vectorText = buildVectorText(fromMap(map));
    return await modelQuery.adapter.saveDocument(
      databaseQuery,
      Map.unmodifiable(<String, dynamic>{
        ...map,
        vectorValueFieldKey: vectorConverter.toVector(vectorText),
      }),
    );
  }
}
