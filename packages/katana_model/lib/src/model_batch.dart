part of katana_model;

/// {@template model_batch}
/// Builder for batch processing.
///
/// [ModelBatchDocument] can be created from other [DocumentBase] using [ModelBatchRef.read], and the process to be executed together can be written.
///
/// Batch processing can be performed by executing [ModelBatchDocument.save] and [ModelBatchDocument.delete] using [ModelBatchDocument].
///
/// Data integrity is not protected and processing occurs in parallel.
///
/// If [splitLength] is specified, batch processing can be split and executed for each [splitLength]. /// If there is a fixed limit to the number of batch processes that can be executed at one time, such as in a Firestore, you can specify this number to limit the number of batch processes to be executed at one time.
///
/// バッチ処理を行うためのビルダー。
///
/// [ModelBatchRef.read]を用いて他の[DocumentBase]から[ModelBatchDocument]を作成することができ、まとめて実行する処理を記述することができます。
///
/// [ModelBatchDocument]を用いて[ModelBatchDocument.save]、[ModelBatchDocument.delete]を実行することでバッチ処理を行うことが可能です。
///
/// データの整合性は守られず、並列で処理が行われます。
///
/// [splitLength]を指定すると、バッチ処理を[splitLength]ごとに分割して実行することができます。
/// Firestoreなどの一度のバッチ処理の上限が決められている場合、この数を指定して１度に実行するバッチ処理の数を抑えることができます。
/// {@endtemplate}
///
/// ```dart
/// final batch = sourceDocument.batch();
/// batch((ref, document){
///   final doc = ref.read(document); // `doc` is [ModelBatchDocument] of `sourceDocument`.
///   final newValue = {"name": "test"}; // The same mechanism can be used to perform the same preservation method as usual.
///   doc.save(newValue);
/// });
/// ```
class ModelBatchDocumentBuilder<T> {
  ModelBatchDocumentBuilder._(this.document, this.splitLength);

  /// Number of batch processes to be divided.
  ///
  /// The batch process is divided and executed for each of these numbers.
  ///
  /// バッチ処理を分割する数。
  ///
  /// この数値ごとにバッチ処理が分割されて実行されます。
  final int splitLength;

  /// Original document.
  ///
  /// 元となるドキュメント。
  final DocumentBase<T> document;

  /// Pass [batch] as a callback to execute the batch.
  ///
  /// [batch]をコールバックとして渡しバッチを実行します。
  FutureOr<void> call(
    FutureOr<void> Function(
      ModelBatchRef ref,
      DocumentBase<T> doc,
    ) batch,
  ) {
    return document.modelQuery.adapter.runBatch(
      (ref) {
        return batch(ref, document);
      },
      splitLength,
    );
  }
}

/// {@macro model_batch}
///
/// ```dart
/// final batch = sourceCollection.batch();
/// batch((ref, collection){
///   final doc = ref.read(collection.create()); // `doc` is [ModelBatchDocument] of `sourceDocument`.
///   final newValue = {"name": "test"}; // The same mechanism can be used to perform the same preservation method as usual.
///   doc.save(newValue);
/// });
/// ```
class ModelBatchCollectionBuilder<TModel extends DocumentBase> {
  ModelBatchCollectionBuilder._(this.collection, this.splitLength);

  /// Number of batch processes to be divided.
  ///
  /// The batch process is divided and executed for each of these numbers.
  ///
  /// バッチ処理を分割する数。
  ///
  /// この数値ごとにバッチ処理が分割されて実行されます。
  final int splitLength;

  /// Original collection.
  ///
  /// 元となるコレクション。
  final CollectionBase<TModel> collection;

  /// Pass [batch] as a callback to execute the batch.
  ///
  /// [batch]をコールバックとして渡しバッチを実行します。
  FutureOr<void> call(
    FutureOr<void> Function(
      ModelBatchRef ref,
      CollectionBase<TModel> collection,
    ) batch,
  ) {
    return collection.modelQuery.adapter.runBatch(
      (ref) {
        return batch(ref, collection);
      },
      splitLength,
    );
  }
}

/// Reference class for batching.
///
/// With [read], documents can be converted into objects for batch use.
///
/// バッチを行う際のリファレンスクラス。
///
/// [read]でドキュメントをバッチ用のオブジェクトに変換できます。
@immutable
abstract class ModelBatchRef {
  /// Reference class for performing transactions.
  ///
  /// With [read], documents can be converted into transactional objects.
  ///
  /// トランザクションを行う際のリファレンスクラス。
  ///
  /// [read]でドキュメントをトランザクション用のオブジェクトに変換できます。
  const ModelBatchRef();

  /// You can convert it to a [ModelBatchDocument] by passing [document].
  ///
  /// Converted objects can be saved and deleted with [ModelBatchDocument.save] and [ModelBatchDocument.delete], respectively.
  ///
  /// [document]を渡すことで[ModelBatchDocument]に変換することができます。
  ///
  /// 変換されたオブジェクトは[ModelBatchDocument.save]、[ModelBatchDocument.delete]でそれぞれデータ保存、削除を行うことができます。
  ModelBatchDocument<E> read<E>(DocumentBase<E> document) =>
      ModelBatchDocument<E>._(this, document);

  void _delete(DocumentBase document) {
    document.modelQuery.adapter.deleteOnBatch(
      this,
      document.databaseQuery,
    );
  }

  void _save(DocumentBase document, DynamicMap value) {
    return document.modelQuery.adapter.saveOnBatch(
      this,
      document.databaseQuery,
      value,
    );
  }
}

/// Documentation class for batch.
///
/// Loaded data can be retrieved with [value].
///
/// After replacing [value], the contents of [value] are saved again by executing [save].
///
/// [delete] will delete the document.
///
/// バッチ用のドキュメントクラス。
///
/// ロードされたデータは[value]で取得することが可能です。
///
/// [value]を置き換えた後[save]を実行することで[value]の内容が再度保存されます。
///
/// [delete]を実行することでドキュメントが削除されます。
@immutable
class ModelBatchDocument<T> {
  const ModelBatchDocument._(
    ModelBatchRef ref,
    DocumentBase<T> document,
  )   : _ref = ref,
        _document = document;

  final DocumentBase<T> _document;
  final ModelBatchRef _ref;

  /// Document Value.
  ///
  /// ドキュメントの値。
  T? get value => _document.value;

  /// Data can be saved.
  ///
  /// The [newValue] is saved as it is as data. If [Null] is given, it is not executed.
  ///
  /// If the save is successful, [value] is replaced with [newValue].
  ///
  /// If the save fails, an attempt is made to restore to the previous data.
  ///
  /// データの保存を行うことができます。
  ///
  /// [newValue]がそのままデータとして保存されます。[Null]が与えられた場合実行されません。
  ///
  /// 保存に成功した場合、[value]が[newValue]に置き換えられます。
  ///
  /// 保存に失敗した場合、前のデータへの復元を試みます。
  void save(T? newValue) {
    if (newValue == null) {
      return;
    }
    final document = _document;
    _ref._save(
      document,
      document._filterOnSave(document.toMap(newValue)),
    );
    document._value = newValue;
  }

  /// Data can be deleted.
  ///
  /// It is the data in his document that is deleted.
  ///
  /// After deletion, the data is empty, but the object itself is still valid.
  ///
  /// If the database allows it, the data can be restored by re-entering the data and executing [save].
  ///
  /// データの削除を行うことができます。
  ///
  /// 削除されるのは自身のドキュメントのデータです。
  ///
  /// 削除後はデータが空になりますが、このオブジェクト自体は有効になっています。
  ///
  /// データベース上可能な場合、再度データを入れ[save]を実行することでデータを復元できます。
  void delete() {
    _ref._delete(_document);
  }
}
