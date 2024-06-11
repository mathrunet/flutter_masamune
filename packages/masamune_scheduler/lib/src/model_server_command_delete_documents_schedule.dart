part of '/masamune_scheduler.dart';

/// [ModelServerCommandBase] to delete all documents for the collection specified in [time].
///
/// Specify the path of the collection to be deleted in [collectionPath].
///
/// [where] allows you to specify conditions for retrieving data from a collection. In addition, it is possible to specify conditions for the retrieved data in [conditions].
///
/// No problem even if the number of documents in the collection is large, as they are deleted in a batch process.
///
/// **If you use this in firestore, please specify the fields `_time` and `_done` in CollectionID:`schedule` to create the index.**
///
/// [time]に指定されたコレクションに対するすべてのドキュメントを削除するための[ModelServerCommandBase]です。
///
/// [collectionPath]に削除対象のコレクションのパスを指定します。
///
/// [where]でコレクションからの取得条件を指定することが可能です。また、[conditions]で取得したデータに対する条件を指定することが可能です。
///
/// バッチ処理で削除されるためコレクション内のドキュメントの数が多い場合でも問題ございません。
///
/// **firestoreでこちらを利用する場合CollectionID:`schedule`で`_time`と`_done`のフィールドを指定してインデックスを作成してください。**
class ModelServerCommandDeleteDocumentsSchedule extends ModelServerCommandBase {
  /// [ModelServerCommandBase] to delete all documents for the collection specified in [time].
  ///
  /// Specify the path of the collection to be deleted in [collectionPath].
  ///
  /// [where] allows you to specify conditions for retrieving data from a collection. In addition, it is possible to specify conditions for the retrieved data in [conditions].
  ///
  /// No problem even if the number of documents in the collection is large, as they are deleted in a batch process.
  ///
  /// **If you use this in firestore, please specify the fields `_time` and `_done` in CollectionID:`schedule` to create the index.**
  ///
  /// [time]に指定されたコレクションに対するすべてのドキュメントを削除するための[ModelServerCommandBase]です。
  ///
  /// [collectionPath]に削除対象のコレクションのパスを指定します。
  ///
  /// [where]でコレクションからの取得条件を指定することが可能です。また、[conditions]で取得したデータに対する条件を指定することが可能です。
  ///
  /// バッチ処理で削除されるためコレクション内のドキュメントの数が多い場合でも問題ございません。
  ///
  /// **firestoreでこちらを利用する場合CollectionID:`schedule`で`_time`と`_done`のフィールドを指定してインデックスを作成してください。**
  const factory ModelServerCommandDeleteDocumentsSchedule({
    required String collectionPath,
    List<ModelServerCommandCondition>? where,
    List<ModelServerCommandCondition>? conditions,
    required ModelTimestamp time,
  }) = _ModelServerCommandDeleteDocumentsSchedule;

  const ModelServerCommandDeleteDocumentsSchedule._()
      : super(ModelServerCommandDeleteDocumentsSchedule.command);

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const ModelServerCommandDeleteDocumentsSchedule.fromServer({
    super.publicParameters = const {},
    super.privateParameters = const {},
  }) : super(ModelServerCommandDeleteDocumentsSchedule.command);

  /// Path of the collection from which to retrieve the list of documents to be deleted.
  ///
  /// Must be a regular Firestore collection path hierarchy.
  ///
  /// 削除するドキュメント一覧を取得するコレクションのパス。
  ///
  /// Firestoreの正規のコレクションのパス階層である必要があります。
  String get collectionPath => throw UnimplementedError();

  /// Specifies the conditions for retrieving from the collection.
  ///
  /// All are And conditions.
  ///
  /// コレクションから取得するための条件を指定します。
  ///
  /// すべてAnd条件となります。
  List<ModelServerCommandCondition>? get where => throw UnimplementedError();

  /// Specify the condition for the acquired data.
  ///
  /// All are And conditions.
  ///
  /// 取得したデータに対する条件を指定します。
  ///
  /// すべてAnd条件となります。
  List<ModelServerCommandCondition>? get conditions =>
      throw UnimplementedError();

  /// Specify the date and time to copy.
  ///
  /// コピーする日時を指定します。
  ModelTimestamp get time => throw UnimplementedError();

  /// Command Name.
  ///
  /// コマンド名。
  static const command = "delete_documents";

  static const String _kTimeKey = "_time";
  static const String _kDoneKey = "_done";
  static const String _kCollectionPathKey = "conditionPath";
  static const String _kWheresKey = "wheres";
  static const String _kConditionsKey = "conditions";

  /// Convert from [json] map to [ModelServerCommandCopyDocumentSchedule].
  ///
  /// [json]のマップから[ModelServerCommandCopyDocumentSchedule]に変換します。
  factory ModelServerCommandDeleteDocumentsSchedule.fromJson(DynamicMap json) {
    return ModelServerCommandDeleteDocumentsSchedule.fromServer(
      publicParameters:
          json.getAsMap(ModelServerCommandBase.kPublicParametersKey, {}),
      privateParameters:
          json.getAsMap(ModelServerCommandBase.kPrivateParametersKey, {}),
    );
  }

  @override
  DynamicMap get privateParameters {
    assert(
      !(collectionPath.trimQuery().trimString("/").splitLength() <= 0 ||
          collectionPath.trimQuery().trimString("/").splitLength() % 2 != 1),
      "The query path hierarchy must be an odd number: $collectionPath",
    );
    return {
      _kCollectionPathKey: collectionPath,
      if (where != null) _kWheresKey: where!.map((e) => e.toJson()).toList(),
      if (conditions != null)
        _kConditionsKey: conditions!.map((e) => e.toJson()).toList(),
    };
  }

  @override
  DynamicMap get publicParameters {
    return {
      _kDoneKey: false,
      _kTimeKey: time.value.millisecondsSinceEpoch,
    };
  }
}

class _ModelServerCommandDeleteDocumentsSchedule
    extends ModelServerCommandDeleteDocumentsSchedule {
  const _ModelServerCommandDeleteDocumentsSchedule({
    required this.collectionPath,
    this.where,
    this.conditions,
    required this.time,
  }) : super._();

  @override
  final String collectionPath;

  @override
  final List<ModelServerCommandCondition>? where;

  @override
  final List<ModelServerCommandCondition>? conditions;

  @override
  final ModelTimestamp time;
}
