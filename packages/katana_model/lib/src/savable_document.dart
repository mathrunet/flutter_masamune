part of katana_model;

/// Define a document model that can be saved and deleted.
/// 保存・削除可能なドキュメントモデルを定義します。
///
/// オブジェクト自体の変更を行ったあと、[SavableDocument.save]を行うことで変更を保存することができます。
///
/// Delete data by executing [SavableDocument.delete].
/// [SavableDocument.delete]を実行することでデータの削除を行います。
///
/// You can monitor [SavableDocument.saving] when saving or deleting data and wait for the saving or deleting process.
/// データの保存・削除時に[SavableDocument.saving]を監視することができ保存や削除の処理を待つことができます。
///
/// [SavableDocument.saveRequest] and [SavableDocument.deleteRequest] implement internal processing when saving and deleting data.
/// [SavableDocument.saveRequest]、[SavableDocument.deleteRequest]でデータ保存・削除時の内部処理を実装します。
abstract class SavableDocument<T> implements DocumentBase<T> {
  /// Data can be saved.
  /// データの保存を行うことができます。
  ///
  /// Since it is only the content of [value] that is saved, it is necessary to change the content of [value] before saving.
  /// 保存を行うのはあくまで[value]の中身なので保存を行う前に[value]の中身を変更しておく必要があります。
  ///
  /// It is possible to wait for saving with `await`.
  /// `await`で保存を待つことが可能です。
  Future<void> save();

  /// Data can be deleted.
  /// データの削除を行うことができます。
  ///
  /// It is the data in his document that is deleted.
  /// 削除されるのは自身のドキュメントのデータです。
  ///
  /// After deletion, the data is empty, but the object itself is still valid.
  /// 削除後はデータが空になりますが、このオブジェクト自体は有効になっています。
  ///
  /// If the database allows it, the data can be restored by re-entering the data and executing [save].
  /// データベース上可能な場合、再度データを入れ[save]を実行することでデータを復元できます。
  Future<void> delete();

  /// If [save] or [delete] is executed, it waits until the read process is completed.
  /// [save]や[delete]を実行した場合、その読込処理が終わるまで待ちます。
  Future<void>? get saving;

  /// Implement internal processing when [save] is executed.
  /// [save]を実行した際の内部処理を実装します。
  ///
  ///　The data to be stored in [map] is decoded and passed to [DynamicMap].
  /// [map]に保存するためのデータが[DynamicMap]にデコードされ渡されます。
  @protected
  @mustCallSuper
  Future<void> saveRequest(DynamicMap map);

  /// [delete]を実行した際の内部処理を実装します。
  ///
  /// The deletion process is performed using its own [query] and other data.
  /// 自身の[query]などのデータを用いて削除処理を行います。
  @protected
  @mustCallSuper
  Future<void> deleteRequest();

  /// You can filter the data to be saved.
  /// 保存するデータをフィルターすることができます。
  ///
  /// [value] is the locally held object and [rawData] is the data to be decoded and stored in [DynamicMap].
  /// [value]がローカルに保持されているオブジェクト、[rawData]が[DynamicMap]にデコードされた保存されるデータになります。
  ///
  /// The value returned is stored as data.
  /// 戻り値に返した値がデータとして保存されます。
  @protected
  @mustCallSuper
  FutureOr<DynamicMap> filterOnSave(T value, DynamicMap rawData);
}

/// Define a Mixin that implements [SavableDocument].
/// [SavableDocument]を実装したMixinを定義します。
abstract class SavableDocumentMixin<T> implements SavableDocument<T> {
  Completer<T>? _saveCompleter;

  @override
  Future<void> save() async {
    if (_saveCompleter != null) {
      return saving!;
    }
    try {
      _saveCompleter = Completer<T>();
      await saveRequest(await filterOnSave(value, toMap(value)));
      _saveCompleter?.complete(value);
      _saveCompleter = null;
    } catch (e) {
      _saveCompleter?.completeError(e);
      _saveCompleter = null;
      rethrow;
    } finally {
      _saveCompleter?.complete();
      _saveCompleter = null;
    }
  }

  @override
  Future<void> delete() async {
    if (_saveCompleter != null) {
      return saving!;
    }
    try {
      _saveCompleter = Completer<T>();
      await deleteRequest();
      _saveCompleter?.complete(value);
      _saveCompleter = null;
    } catch (e) {
      _saveCompleter?.completeError(e);
      _saveCompleter = null;
      rethrow;
    } finally {
      _saveCompleter?.complete();
      _saveCompleter = null;
    }
  }

  @override
  Future<void>? get saving => _saveCompleter?.future;

  @override
  @protected
  Future<void> saveRequest(DynamicMap map) async {
    return await query.adapter.saveDocument(databaseQuery, map);
  }

  @override
  @protected
  Future<void> deleteRequest() async {
    return await query.adapter.deleteDocument(databaseQuery);
  }

  @override
  @protected
  @mustCallSuper
  FutureOr<DynamicMap> filterOnSave(T value, DynamicMap rawData) => rawData;
}
