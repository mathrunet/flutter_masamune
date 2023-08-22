part of katana_model;

/// {@template model_transaction}
/// Builder for transactions.
///
/// [ModelTransactionDocument] can be created from other [DocumentBase] using [ModelTransactionRef.read], and the process to be executed together can be written.
///
/// [ModelTransactionDocument.load], [ModelTransactionDocument.save], and [ModelTransactionDocument.delete] using [ModelTransactionDocument]. transaction processing can be performed by executing
///
/// トランザクションを行うためのビルダー。
///
/// [ModelTransactionRef.read]を用いて他の[DocumentBase]から[ModelTransactionDocument]を作成することができ、まとめて実行する処理を記述することができます。
///
/// [ModelTransactionDocument]を用いて[ModelTransactionDocument.load]、[ModelTransactionDocument.save]、[ModelTransactionDocument.delete]を実行することでトランザクション処理を行うことが可能です。
/// {@endtemplate}
///
/// ```dart
/// final transaction = sourceDocument.transaction();
/// transaction((ref, document){
///   final doc = ref.read(document); // `doc` is [ModelTransactionDocument] of `sourceDocument`.
///   final newValue = {"name": "test"}; // The same mechanism can be used to perform the same preservation method as usual.
///   doc.save(newValue);
/// });
/// ```
class ModelTransactionDocumentBuilder<T> {
  ModelTransactionDocumentBuilder._(this.document);

  /// Original document.
  ///
  /// 元となるドキュメント。
  final DocumentBase<T> document;

  /// [transaction] is passed as a callback to execute the transaction.
  ///
  /// [transaction]をコールバックとして渡しトランザクションを実行します。
  FutureOr<void> call(
    FutureOr<void> Function(
      ModelTransactionRef ref,
      DocumentBase<T> doc,
    ) transaction,
  ) {
    return document.modelQuery.adapter.runTransaction(
      (ref) {
        return transaction(ref, document);
      },
    );
  }
}

/// {@macro model_transaction}
///
/// ```dart
/// final transaction = sourceCollection.transaction();
/// transaction((ref, collection){
///   final doc = ref.read(collection.create()); // `doc` is [ModelTransactionDocument] of `sourceDocument`.
///   final newValue = {"name": "test"}; // The same mechanism can be used to perform the same preservation method as usual.
///   doc.save(newValue);
/// });
/// ```
class ModelTransactionCollectionBuilder<TModel extends DocumentBase> {
  ModelTransactionCollectionBuilder._(this.collection);

  /// Original collection.
  ///
  /// 元となるコレクション。
  final CollectionBase<TModel> collection;

  /// [transaction] is passed as a callback to execute the transaction.
  ///
  /// [transaction]をコールバックとして渡しトランザクションを実行します。
  FutureOr<void> call(
    FutureOr<void> Function(
      ModelTransactionRef ref,
      CollectionBase<TModel> collection,
    ) transaction,
  ) {
    return collection.modelQuery.adapter.runTransaction(
      (ref) {
        return transaction(ref, collection);
      },
    );
  }
}

/// Reference class for performing transactions.
///
/// With [read], documents can be converted into transactional objects.
///
/// トランザクションを行う際のリファレンスクラス。
///
/// [read]でドキュメントをトランザクション用のオブジェクトに変換できます。
@immutable
abstract class ModelTransactionRef {
  /// Reference class for performing transactions.
  ///
  /// With [read], documents can be converted into transactional objects.
  ///
  /// トランザクションを行う際のリファレンスクラス。
  ///
  /// [read]でドキュメントをトランザクション用のオブジェクトに変換できます。
  const ModelTransactionRef();

  /// You can convert it to a [ModelTransactionDocument] by passing [document].
  ///
  /// The converted object can be retrieved, saved, and deleted with [ModelTransactionDocument.load], [ModelTransactionDocument.save], and [ModelTransactionDocument.delete] respectively. delete] to retrieve, save, and delete data, respectively.
  ///
  /// [document]を渡すことで[ModelTransactionDocument]に変換することができます。
  ///
  /// 変換されたオブジェクトは[ModelTransactionDocument.load]、[ModelTransactionDocument.save]、[ModelTransactionDocument.delete]でそれぞれデータ取得、保存、削除を行うことができます。
  ModelTransactionDocument<E> read<E>(DocumentBase<E> document) =>
      ModelTransactionDocument<E>._(this, document);

  FutureOr<DynamicMap> _load(DocumentBase document) async {
    return await document.modelQuery.adapter.loadOnTransaction(
      this,
      document.databaseQuery,
    );
  }

  void _delete(DocumentBase document) {
    document.modelQuery.adapter.deleteOnTransaction(
      this,
      document.databaseQuery,
    );
  }

  void _save(DocumentBase document, DynamicMap value) {
    return document.modelQuery.adapter.saveOnTransaction(
      this,
      document.databaseQuery,
      value,
    );
  }
}

/// Document class for transactions.
///
/// Load data with [load].
///
/// Loaded data can be retrieved with [value].
///
/// After replacing [value], the contents of [value] are saved again by executing [save].
///
/// [delete] will delete the document.
///
/// トランザクション用のドキュメントクラス。
///
/// [load]でデータをロードします。
///
/// ロードされたデータは[value]で取得することが可能です。
///
/// [value]を置き換えた後[save]を実行することで[value]の内容が再度保存されます。
///
/// [delete]を実行することでドキュメントが削除されます。
@immutable
class ModelTransactionDocument<T> {
  const ModelTransactionDocument._(
    ModelTransactionRef ref,
    DocumentBase<T> document,
  )   : _ref = ref,
        _document = document;

  final DocumentBase<T> _document;
  final ModelTransactionRef _ref;

  /// Document Value.
  ///
  /// ドキュメントの値。
  T? get value => _document.value;

  /// Reads the corresponding document.
  ///
  /// The return value is a [T] object, and the loaded data is available as is.
  ///
  /// The value is stored in [value] and can be retrieved from there.
  ///
  /// 対応したドキュメントの読込を行います。
  ///
  /// 戻り値は[T]オブジェクトが返され、そのまま読込済みのデータの利用が可能になります。
  ///
  /// また[value]に値が保存されているためそこから値を取得することができます。
  FutureOr<T?> load() async {
    final document = _document;
    final res = await _ref._load(document);
    document._value = document.fromMap(document._filterOnLoad(res));
    return value;
  }

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
    // TODO: 削除してみたが問題ないか確認
    // document._value = newValue;
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
