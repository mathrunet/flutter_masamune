part of '/masamune.dart';

/// Mix-in to do [CollectionBase.replaceQuery] by [ModelQueryBase].
///
/// Grant to [CollectionBase].
///
/// Add the [filter] method.
///
/// [ModelQueryBase]による[CollectionBase.replaceQuery]を行うためのミックスイン。
///
/// [CollectionBase]に付与します。
///
/// [filter]メソッドを追加してください。
mixin FilterableCollectionMixin<TModel extends DocumentBase,
    TModelQuery extends ModelQueryBase> on CollectionBase<TModel> {
  /// Redefine a new [TModelQuery] with [callback] and execute [replaceQuery].
  ///
  /// Use this function when you want to read the file again with new conditions.
  ///
  /// [callback]で新しい[TModelQuery]を再定義し[replaceQuery]を実行します。
  ///
  /// 新しい条件で再度読み込みをおこないたい場合に利用します。
  Future<CollectionBase<TModel>> filter(
    TModelQuery Function(TModelQuery source) callback,
  );
}
