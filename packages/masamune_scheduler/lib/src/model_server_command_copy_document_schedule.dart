part of masamune_scheduler;

/// [ModelServerCommandBase] to copy all documents to [time].
///
/// Specify the path of the destination document in [path].
///
/// **If you use this in firestore, please specify the fields `_time` and `_done` in CollectionID:`schedule` to create the index.**
///
/// [time]にドキュメントをすべてコピーするための[ModelServerCommandBase]です。
///
/// [path]にコピー先のドキュメントのパスを指定します。
///
/// **firestoreでこちらを利用する場合CollectionID:`schedule`で`_time`と`_done`のフィールドを指定してインデックスを作成してください。**
class ModelServerCommandCopyDocumentSchedule extends ModelServerCommandBase {
  /// [ModelServerCommandBase] to copy all documents to [time].
  ///
  /// Specify the path of the destination document in [path].
  ///
  /// **If you use this in firestore, please specify the fields `_time` and `_done` in CollectionID:`schedule` to create the index.**
  ///
  /// [time]にドキュメントをすべてコピーするための[ModelServerCommandBase]です。
  ///
  /// [path]にコピー先のドキュメントのパスを指定します。
  ///
  /// **firestoreでこちらを利用する場合CollectionID:`schedule`で`_time`と`_done`のフィールドを指定してインデックスを作成してください。**
  const factory ModelServerCommandCopyDocumentSchedule({
    required String path,
    required ModelTimestamp time,
  }) = _ModelServerCommandCopyDocumentSchedule;

  const ModelServerCommandCopyDocumentSchedule._()
      : super(ModelServerCommandCopyDocumentSchedule.command);

  /// Used to disguise the retrieval of data from the server.
  ///
  /// Use for testing purposes.
  ///
  /// サーバーからのデータの取得に偽装するために利用します。
  ///
  /// テスト用途で用いてください。
  const ModelServerCommandCopyDocumentSchedule.fromServer({
    super.publicParameters = const {},
    super.privateParameters = const {},
  }) : super(ModelServerCommandCopyDocumentSchedule.command);

  /// The path of the destination document.
  ///
  /// Must be in Firestore's canonical document path hierarchy.
  ///
  /// コピー先のドキュメントのパス。
  ///
  /// Firestoreの正規のドキュメントのパス階層である必要があります。
  String get path => throw UnimplementedError();

  /// Specify the date and time to copy.
  ///
  /// コピーする日時を指定します。
  ModelTimestamp get time => throw UnimplementedError();

  /// Command Name.
  ///
  /// コマンド名。
  static const command = "copy_document";

  static const String _kTimeKey = "_time";
  static const String _kDoneKey = "_done";
  static const String _kPathKey = "path";

  /// Convert from [json] map to [ModelServerCommandCopyDocumentSchedule].
  ///
  /// [json]のマップから[ModelServerCommandCopyDocumentSchedule]に変換します。
  factory ModelServerCommandCopyDocumentSchedule.fromJson(DynamicMap json) {
    return ModelServerCommandCopyDocumentSchedule.fromServer(
      publicParameters:
          json.getAsMap(ModelServerCommandBase.kPublicParametersKey, {}),
      privateParameters:
          json.getAsMap(ModelServerCommandBase.kPrivateParametersKey, {}),
    );
  }

  @override
  DynamicMap get privateParameters {
    assert(
      !(path.trimQuery().trimString("/").splitLength() <= 0 ||
          path.trimQuery().trimString("/").splitLength() % 2 != 0),
      "The query path hierarchy must be an even number: $path",
    );
    return {
      _kPathKey: path,
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

class _ModelServerCommandCopyDocumentSchedule
    extends ModelServerCommandCopyDocumentSchedule {
  const _ModelServerCommandCopyDocumentSchedule({
    required this.path,
    required this.time,
  }) : super._();

  @override
  final String path;

  @override
  final ModelTimestamp time;
}
