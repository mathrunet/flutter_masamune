part of katana_model;

/// Define a document model for storing [T] types that inherit from [ValueNotifier].
/// [ValueNotifier]を継承した[T]型を保存するためのドキュメントモデルを定義します。
///
/// Any changes made locally in the app will be notified and related objects will reflect the changes.
/// アプリのローカル内での変更はすべて通知され関連のあるオブジェクトは変更内容が反映されます。
///
/// When changes are reflected, [notifyListeners] will notify all listeners of the changes.
/// 変更内容が反映された場合[notifyListeners]によって変更内容がすべてのリスナーに通知されます。
///
/// Define object conversion from [DynamicMap] to [T], which is output by decoding Json by implementing [DocumentBase.fromMap].
/// [DocumentBase.fromMap]を実装することでJsonをデコードして出力される[DynamicMap]から[T]へのオブジェクト変換を定義します。
///
/// Implementing [DocumentBase.toMap] defines the conversion from a [T] object to a [DynamicMap] that can later be Json encoded.
/// [DocumentBase.toMap]を実装することで[T]のオブジェクトから後にJsonエンコード可能な[DynamicMap]への変換を定義します。
///
/// By defining [query], you can specify settings for loading, such as document paths.
/// [query]を定義することで、ドキュメントのパスなど読み込みを行うための設定を指定できます。
///
/// The initial value is given in [value].
/// [value]で初期値を与えます。
abstract class DocumentBase<T> extends ValueNotifier<T> {
  /// Define a document model for storing [T] types that inherit from [ValueNotifier].
  /// [ValueNotifier]を継承した[T]型を保存するためのドキュメントモデルを定義します。
  ///
  /// Any changes made locally in the app will be notified and related objects will reflect the changes.
  /// アプリのローカル内での変更はすべて通知され関連のあるオブジェクトは変更内容が反映されます。
  ///
  /// When changes are reflected, [notifyListeners] will notify all listeners of the changes.
  /// 変更内容が反映された場合[notifyListeners]によって変更内容がすべてのリスナーに通知されます。
  ///
  /// Define object conversion from [DynamicMap] to [T], which is output by decoding Json by implementing [DocumentBase.fromMap].
  /// [DocumentBase.fromMap]を実装することでJsonをデコードして出力される[DynamicMap]から[T]へのオブジェクト変換を定義します。
  ///
  /// Implementing [DocumentBase.toMap] defines the conversion from a [T] object to a [DynamicMap] that can later be Json encoded.
  /// [DocumentBase.toMap]を実装することで[T]のオブジェクトから後にJsonエンコード可能な[DynamicMap]への変換を定義します。
  ///
  /// By defining [query], you can specify settings for loading, such as document paths.
  /// [query]を定義することで、ドキュメントのパスなど読み込みを行うための設定を指定できます。
  ///
  /// The initial value is given in [value].
  /// [value]で初期値を与えます。
  DocumentBase(
    this.query,
    super.value,
  ) : assert(
          !(query.path.splitLength() <= 0 || query.path.splitLength() % 2 != 0),
          "The query path hierarchy must be an even number: ${query.path}",
        );

  /// Defines the object transformation from [DynamicMap] to [T], which is output by decoding Json.
  /// Jsonをデコードして出力される[DynamicMap]から[T]へのオブジェクト変換を定義します。
  ///
  /// A [DynamicMap] decoded from Json, etc. is passed to [map].
  /// [map]にJsonなどからデコード済みの[DynamicMap]が渡されます。
  @protected
  T fromMap(DynamicMap map);

  /// Defines the conversion from a [T] object to a [DynamicMap] that can later be Json encoded.
  /// [T]のオブジェクトから後にJsonエンコード可能な[DynamicMap]への変換を定義します。
  ///
  /// The object [T] held by the document is passed to [value].
  /// [value]にドキュメントが保持している[T]のオブジェクトが渡されます。
  @protected
  DynamicMap toMap(T value);

  /// Query for loading and saving documents.
  /// ドキュメントを読込・保存するためのクエリ。
  @protected
  final DocumentModelQuery query;

  /// Database queries for documents.
  /// ドキュメント用のデータベースクエリ。
  @protected
  ModelAdapterDocumentQuery get databaseQuery {
    return _databaseQuery ??= ModelAdapterDocumentQuery(
      query: query,
      callback: handledOnUpdate,
      origin: this,
    );
  }

  ModelAdapterDocumentQuery? _databaseQuery;

  /// List of currently subscribed notifications. All should be canceled when the object is destroyed.
  /// 現在購読中の通知一覧。オブジェクトの破棄時にすべてキャンセルするようにしてください。
  @protected
  List<StreamSubscription> get subscriptions => _subscriptions;
  final List<StreamSubscription> _subscriptions = [];

  /// Describe the callback process to be passed to [ModelAdapterDocumentQuery.callback].
  /// [ModelAdapterDocumentQuery.callback]に渡すためのコールバック処理を記述します。
  ///
  /// This is executed when there is a change in the associated collection or document.
  /// 関連するコレクションやドキュメントに変更があった場合、こちらが実行されます。
  ///
  /// Please take appropriate action according to the contents of [update].
  /// [update]の内容に応じて適切な処理を行ってください。
  @protected
  void handledOnUpdate(ModelUpdateNotification update) {
    value = fromMap(update.value);
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    query.adapter.disposeDocument(databaseQuery);
    subscriptions.forEach((subscription) => subscription.cancel());
    subscriptions.clear();
  }

  @override
  String toString() => "$runtimeType($value)";
}
