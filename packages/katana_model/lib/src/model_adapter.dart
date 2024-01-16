part of '/katana_model.dart';

/// You can implement adapters that define the internal specifications of the model.
///
/// The loading process is implemented in [ModelAdapter.loadDocument] or [ModelAdapter.loadCollection].
///
/// When saving data for a document (saving and deleting data for a collection is systematically prohibited) is implemented in [ModelAdapter.saveDocument], and deleting is implemented in [ModelAdapter.deleteDocument].
///
/// If each model is to be destroyed, implement and execute [ModelAdapter.disposeDocument] or [ModelAdapter.disposeCollection].
///
/// You can also get the default adapter from [ModelAdapter.primary].
///
/// [ModelAdapter.primary] is automatically set through [ModelAdapterScope] executed at the top level.
///
/// If [ModelAdapterScope] is not running, [RuntimeModelAdapter] will be called.
///
/// モデルの内部仕様を定義するアダプターを実装できます。
///
/// 読み込み時の処理は[ModelAdapter.loadDocument]や[ModelAdapter.loadCollection]に実装します。
///
/// ドキュメントのデータ保存時（コレクションのデータ保存・削除はシステム的に禁止）は[ModelAdapter.saveDocument]に実装し、削除は[ModelAdapter.deleteDocument]に実装します。
///
/// 各モデルが破棄される場合は[ModelAdapter.disposeDocument]や[ModelAdapter.disposeCollection]を実装し実行してください。
///
/// またデフォルトのアダプターを[ModelAdapter.primary]から取得できます。
/// [ModelAdapter.primary]はトップレベルで実行された[ModelAdapterScope]を通して自動的に設定されます。
///
/// [ModelAdapterScope]が実行されていない場合には[RuntimeModelAdapter]が呼び出されます。
@immutable
abstract class ModelAdapter {
  /// You can implement adapters that define the internal specifications of the model.
  ///
  /// The loading process is implemented in [ModelAdapter.loadDocument] or [ModelAdapter.loadCollection].
  ///
  /// When saving data for a document (saving and deleting data for a collection is systematically prohibited) is implemented in [ModelAdapter.saveDocument], and deleting is implemented in [ModelAdapter.deleteDocument].
  ///
  /// If each model is to be destroyed, implement and execute [ModelAdapter.disposeDocument] or [ModelAdapter.disposeCollection].
  ///
  /// You can also get the default adapter from [ModelAdapter.primary].
  ///
  /// [ModelAdapter.primary] is automatically set through [ModelAdapterScope] executed at the top level.
  ///
  /// If [ModelAdapterScope] is not running, [RuntimeModelAdapter] will be called.
  ///
  /// モデルの内部仕様を定義するアダプターを実装できます。
  ///
  /// 読み込み時の処理は[ModelAdapter.loadDocument]や[ModelAdapter.loadCollection]に実装します。
  ///
  /// ドキュメントのデータ保存時（コレクションのデータ保存・削除はシステム的に禁止）は[ModelAdapter.saveDocument]に実装し、削除は[ModelAdapter.deleteDocument]に実装します。
  ///
  /// 各モデルが破棄される場合は[ModelAdapter.disposeDocument]や[ModelAdapter.disposeCollection]を実装し実行してください。
  ///
  /// またデフォルトのアダプターを[ModelAdapter.primary]から取得できます。
  /// [ModelAdapter.primary]はトップレベルで実行された[ModelAdapterScope]を通して自動的に設定されます。
  ///
  /// [ModelAdapterScope]が実行されていない場合には[RuntimeModelAdapter]が呼び出されます。
  const ModelAdapter();

  /// You can get the default adapter.
  ///
  /// [ModelAdapter.primary] is automatically set through [ModelAdapterScope] executed at the top level.
  ///
  /// If [ModelAdapterScope] is not running, [RuntimeModelAdapter] will be called.
  ///
  /// デフォルトのアダプターを取得できます。
  ///
  /// [ModelAdapter.primary]はトップレベルで実行された[ModelAdapterScope]を通して自動的に設定されます。
  ///
  /// [ModelAdapterScope]が実行されていない場合には[RuntimeModelAdapter]が呼び出されます。
  static ModelAdapter get primary {
    assert(
      _primary != null,
      "ModelAdapter is not set. Place [ModelAdapterScope] widget closer to the root.",
    );
    return _primary ?? const RuntimeModelAdapter();
  }

  static ModelAdapter? _primary;

  /// Pass [query] to the platform set by the adapter to retrieve the document.
  ///
  /// All return values are [DynamicMap].
  ///
  /// アダプターで設定されたプラットフォームに[query]を渡してドキュメントを取得します。
  ///
  /// 戻り値はすべて[DynamicMap]になります。
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query);

  /// Pass [query] to the platform set by the adapter to retrieve the collection.
  ///
  /// All return values ​​will be [Map<String, DynamicMap>]. [String] contains the `ID` (not the path) of each document.
  ///
  /// アダプターで設定されたプラットフォームに[query]を渡してコレクションを取得します。
  ///
  /// 戻り値はすべて[Map<String, DynamicMap>]になります。[String]には各ドキュメントの`ID`（パスではない）が入ります。
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  );

  /// Aggregate queries against data collections to retrieve data.
  ///
  /// Pass [query] to the platform configured in the adapter to specify a collection and [aggregateQuery] to specify an aggregate query.
  ///
  /// データコレクションに対しての集計クエリでデータを取得します。
  ///
  /// アダプターで設定されたプラットフォームに[query]を渡してコレクションを指定し、[aggregateQuery]で集計クエリを指定します。
  Future<num> loadAggregation(
    ModelAdapterCollectionQuery query,
    ModelAggregateQuery aggregateQuery,
  );

  /// By passing the [query] and the [value] to be stored, the data is stored on the platform set by the adapter.
  ///
  /// Keys with [value] value of [null] should be deleted from the database.
  ///
  /// [query]と保存する[value]を渡すことでアダプターで設定されたプラットフォームにデータを保存します。
  ///
  /// [value]の値に[Null]が入っているキーはデータベース上から削除するようにしてください。
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  );

  /// Delete data from the platform set by the adapter by passing [query].
  ///
  /// [query]を渡すことでアダプターで設定されたプラットフォームからデータを削除します。
  Future<void> deleteDocument(ModelAdapterDocumentQuery query);

  /// The destruction of related documents is handled by passing [query].
  ///
  /// It should always be performed when a document is destroyed.
  ///
  /// [query]を渡すことで関連したドキュメントの破棄処理を行います。
  ///
  /// ドキュメントの破棄時にはかならず実行してください。
  void disposeDocument(ModelAdapterDocumentQuery query);

  /// The associated collection is discarded by passing [query].
  ///
  /// It should always be performed when destroying a collection.
  ///
  /// [query]を渡すことで関連したコレクションの破棄処理を行います。
  ///
  /// コレクションの破棄時にはかならず実行してください。
  void disposeCollection(ModelAdapterCollectionQuery query);

  // Set to `true` if changes can be monitored.

  // 変更を監視可能な場合`true`にします。
  bool get availableListen;

  /// Pass [query] to monitor the document.
  ///
  /// When monitoring is started, [StreamSubscription] is passed, so keep it.
  ///
  /// All retained [StreamSubscription] should be canceled when the object is destroyed or before executing this method again.
  ///
  /// [query]を渡してドキュメントの監視を行います。
  ///
  /// 監視が開始された場合、[StreamSubscription]が渡されるので、それを保持しておいてください。
  ///
  /// 保持した[StreamSubscription]はオブジェクトの破棄時、または再度このメソッドを実行する前にすべてキャンセルしてください。
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  );

  /// Pass [query] to monitor the collection.
  ///
  /// When monitoring is started, [StreamSubscription] is passed, so keep it.
  ///
  /// All retained [StreamSubscription] should be canceled when the object is destroyed or before executing this method again.
  ///
  /// [query]を渡してコレクションの監視を行います。
  ///
  /// 監視が開始された場合、[StreamSubscription]が渡されるので、それを保持しておいてください。
  ///
  /// 保持した[StreamSubscription]はオブジェクトの破棄時、または再度このメソッドを実行する前にすべてキャンセルしてください。
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  );

  /// Do the processing to execute the transaction.
  ///
  /// Create an adapter-specific [ModelTransactionRef] that internally inherits from [ModelTransactionRef], create a [ModelTransactionDocument] from that [ModelTransactionRef.read], pass it directly to the TransactionRef], create a [ModelTransactionDocument] from that [ModelTransactionRef.read], pass it directly to the [transaction] argument, and then execute the [transaction].
  ///
  /// トランザクションを実行するための処理を行います。
  ///
  /// 内部で[ModelTransactionRef]を継承したアダプター専用の[ModelTransactionRef]を作成し、その[ModelTransactionRef.read]から[ModelTransactionDocument]を作成、それをそのまま[transaction]の引数に渡し、[transaction]を実行するようにしてください。
  FutureOr<void> runTransaction(
    FutureOr<void> Function(
      ModelTransactionRef ref,
    ) transaction,
  );

  /// Describe the data acquisition process when performing a transaction.
  ///
  /// The [ModelTransactionRef] created by [runTransaction] is passed to [ref] and the query of the target document is passed to [query].
  ///
  /// Return a Json map retrieved from the database in the return value.
  ///
  /// トランザクションを行う際のデータ取得処理を記述します。
  ///
  /// [ref]に[runTransaction]で作成した[ModelTransactionRef]が渡され、[query]は対象のドキュメントのクエリが渡されます。
  ///
  /// 戻り値にデータベースから取得したJsonマップを返してください。
  FutureOr<DynamicMap> loadOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  );

  /// Describes the data storage process when performing a transaction.
  ///
  /// The [ModelTransactionRef] created by [runTransaction] is passed to [ref] and the query of the target document is passed to [query].
  ///
  /// The data to be stored is passed to [value].
  ///
  /// Keys with [value] value of [null] should be deleted from the database.
  ///
  /// トランザクションを行う際のデータ保存処理を記述します。
  ///
  /// [ref]に[runTransaction]で作成した[ModelTransactionRef]が渡され、[query]は対象のドキュメントのクエリが渡されます。
  ///
  /// [value]に保存するデータが渡されます。
  ///
  /// [value]の値に[Null]が入っているキーはデータベース上から削除するようにしてください。
  void saveOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  );

  /// Describe the data deletion process when performing a transaction.
  ///
  /// The [ModelTransactionRef] created by [runTransaction] is passed to [ref] and the query of the target document is passed to [query].
  ///
  /// トランザクションを行う際のデータ削除処理を記述します。
  ///
  /// [ref]に[runTransaction]で作成した[ModelTransactionRef]が渡され、[query]は対象のドキュメントのクエリが渡されます。
  void deleteOnTransaction(
    ModelTransactionRef ref,
    ModelAdapterDocumentQuery query,
  );

  /// Processes a batch for execution.
  ///
  /// Create an adapter-specific [ModelBatchRef] that inherits [ModelBatchRef] internally, create a [ModelBatchDocument] from the [ModelBatchRef.read], pass it as an argument to [batch], and execute [batch batch] and execute [batch].
  ///
  /// Split batches by specifying [splitLength].
  ///
  /// バッチを実行するための処理を行います。
  ///
  /// 内部で[ModelBatchRef]を継承したアダプター専用の[ModelBatchRef]を作成し、その[ModelBatchRef.read]から[ModelBatchDocument]を作成、それをそのまま[batch]の引数に渡し、[batch]を実行するようにしてください。
  ///
  /// [splitLength]を指定してバッチを分割することができます。
  FutureOr<void> runBatch(
    FutureOr<void> Function(
      ModelBatchRef ref,
    ) batch,
    int splitLength,
  );

  /// Describe the data storage process when performing a batch.
  ///
  /// The [ModelBatchRef] created by [runBatch] is passed to [ref], and [query] is the query of the target document.
  ///
  /// The data to be stored is passed to [value].
  ///
  /// Keys with [value] value of [null] should be deleted from the database.
  ///
  /// バッチを行う際のデータ保存処理を記述します。
  ///
  /// [ref]に[runBatch]で作成した[ModelBatchRef]が渡され、[query]は対象のドキュメントのクエリが渡されます。
  ///
  /// [value]に保存するデータが渡されます。
  ///
  /// [value]の値に[Null]が入っているキーはデータベース上から削除するようにしてください。
  void saveOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  );

  /// Describe the data deletion process when performing a batch.
  ///
  /// The [ModelBatchRef] created by [runBatch] is passed to [ref], and [query] is the query of the target document.
  ///
  /// バッチを行う際のデータ削除処理を記述します。
  ///
  /// [ref]に[runBatch]で作成した[ModelBatchRef]が渡され、[query]は対象のドキュメントのクエリが渡されます。
  void deleteOnBatch(
    ModelBatchRef ref,
    ModelAdapterDocumentQuery query,
  );

  /// Delete all data in the database.
  ///
  /// All locally stored data will also be deleted, but remote data may not be deleted.
  ///
  /// データベース内のすべてのデータを削除します。
  ///
  /// ローカルに保存されているデータもすべて削除されますがリモートのデータは削除されない可能性があります。
  Future<void> clearAll();

  @override
  String toString() {
    return "$runtimeType[$hashCode]";
  }
}

/// Widget for setting [ModelAdapter].
///
/// You can set a child widget in [child] and an adapter for use in [adapter].
///
/// You can get the nearest ancestor [adapter] from [ModelAdapterScope.of].
///
/// By passing the [adapter] obtained here to [CollectionModelQuery] or [DocumentModelQuery], it is possible to change the internal processing of the model.
///
/// [ModelAdapter]を設定するためのウィジェットです。
///
/// [child]に子のウィジェットを設定し、[adapter]に利用するためのアダプターを設定できます。
///
/// [ModelAdapterScope.of]から近い先祖の[adapter]を取得することができます。
///
/// ここで設定した[adapter]を[CollectionModelQuery]や[DocumentModelQuery]に渡すことでモデルの内部処理を変更することが可能です。
class ModelAdapterScope extends StatefulWidget {
  /// Widget for setting [ModelAdapter].
  ///
  /// You can set a child widget in [child] and an adapter for use in [adapter].
  ///
  /// You can get the nearest ancestor [adapter] from [ModelAdapterScope.of].
  ///
  /// By passing the [adapter] obtained here to [CollectionModelQuery] or [DocumentModelQuery], it is possible to change the internal processing of the model.
  ///
  /// [ModelAdapter]を設定するためのウィジェットです。
  ///
  /// [child]に子のウィジェットを設定し、[adapter]に利用するためのアダプターを設定できます。
  ///
  /// [ModelAdapterScope.of]から近い先祖の[adapter]を取得することができます。
  ///
  /// ここで設定した[adapter]を[CollectionModelQuery]や[DocumentModelQuery]に渡すことでモデルの内部処理を変更することが可能です。
  const ModelAdapterScope({
    super.key,
    required this.child,
    required this.adapter,
  });

  /// Widgets to give to children.
  ///
  /// 子供に渡すウィジェット。
  final Widget child;

  /// An adapter that defines the model internal processing.
  ///
  /// モデル内部処理を定義したアダプター。
  final ModelAdapter adapter;

  /// You can get [adapter] of a close ancestor.
  ///
  /// By passing the [adapter] obtained here to [CollectionModelQuery] or [DocumentModelQuery], it is possible to change the internal processing of the model.
  ///
  /// 近い先祖の[adapter]を取得することができます。
  ///
  /// ここで取得した[adapter]を[CollectionModelQuery]や[DocumentModelQuery]に渡すことでモデルの内部処理を変更することが可能です。
  // ignore: library_private_types_in_public_api
  static _ModelAdapterScope? of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<_ModelAdapterScope>();
    assert(
      scope != null,
      "ModelAdapterScope is not found. Place [ModelAdapterScope] widget closer to the root.",
    );
    return scope?.widget as _ModelAdapterScope?;
  }

  @override
  State<StatefulWidget> createState() => _ModelAdapterScopeState();
}

class _ModelAdapterScopeState extends State<ModelAdapterScope> {
  @override
  void initState() {
    super.initState();
    ModelAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _ModelAdapterScope(adapter: widget.adapter, child: widget.child);
  }
}

class _ModelAdapterScope extends InheritedWidget {
  const _ModelAdapterScope({
    required super.child,
    required this.adapter,
  });

  final ModelAdapter adapter;

  @override
  bool updateShouldNotify(covariant _ModelAdapterScope oldWidget) => false;
}

/// Query class to be passed when executing each function of [ModelAdapter].
///
/// Use this when executing functions for documents. Use [ModelAdapterCollectionQuery] when performing collection queries.
///
/// [ModelAdapter]の各機能を実行する際に渡すクエリークラス。
///
/// ドキュメント用の機能を実行する際に利用します。コレクションのクエリを実行する際は[ModelAdapterCollectionQuery]をご利用ください。
@immutable
class ModelAdapterDocumentQuery {
  /// Query class to be passed when executing each function of [ModelAdapter].
  ///
  /// Use this when executing functions for documents. Use [ModelAdapterCollectionQuery] when performing collection queries.
  ///
  /// [ModelAdapter]の各機能を実行する際に渡すクエリークラス。
  ///
  /// ドキュメント用の機能を実行する際に利用します。コレクションのクエリを実行する際は[ModelAdapterCollectionQuery]をご利用ください。
  const ModelAdapterDocumentQuery({
    required this.query,
    this.callback,
    this.origin,
    this.listen = true,
    this.headers = const {},
    this.method,
  });

  /// Document query.
  ///
  /// ドキュメントのクエリー。
  final DocumentModelQuery query;

  /// The original document object from which to perform the query.
  ///
  /// クエリを実行する元のドキュメントオブジェクト。
  final Object? origin;

  /// Set to `true` to monitor query changes.
  ///
  /// クエリの変更を監視する場合`true`に設定します。
  final bool listen;

  /// Headers for sending a request.
  ///
  /// リクエストを送る際のヘッダー。
  final Map<String, String> headers;

  /// Method for sending a request.
  ///
  /// リクエストを送る際のメソッド。
  final String? method;

  /// A callback that is notified when changes are made to the relevant document.
  ///
  /// Contains information on changes to `update`.
  ///
  /// 該当ドキュメントに変更があった場合、通知されるコールバック。
  ///
  /// `update`に変更された場合の情報が含まれています。
  final void Function(ModelUpdateNotification update)? callback;

  /// Change [headers] or [method] and copy.
  ///
  /// Copied objects are recognized as the same object.
  ///
  /// [headers]もしくは[method]を変更してコピーします。
  ///
  /// コピーされたオブジェクトは同一オブジェクトとして認識されます。
  ModelAdapterDocumentQuery copyWith({
    Map<String, String>? headers,
    String? method,
  }) {
    return ModelAdapterDocumentQuery(
      query: query,
      listen: listen,
      origin: origin,
      callback: callback,
      headers: headers ?? this.headers,
      method: method ?? this.method,
    );
  }

  @override
  String toString() {
    return "$runtimeType(query: $query, listen: $listen, origin: ${origin.hashCode}, headers: $headers, method: $method)";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    if (origin != null) {
      return origin.hashCode;
    }
    return query.hashCode;
  }
}

/// Query class to be passed when executing each function of [ModelAdapter].
///
/// Use [ModelAdapterDocumentQuery] when executing functions for collections. Use [ModelAdapterDocumentQuery] to execute document queries.
///
/// [ModelAdapter]の各機能を実行する際に渡すクエリークラス。
///
/// コレクション用の機能を実行する際に利用します。ドキュメントのクエリを実行する際は[ModelAdapterDocumentQuery]をご利用ください。
@immutable
class ModelAdapterCollectionQuery {
  /// Query class to be passed when executing each function of [ModelAdapter].
  ///
  /// Use [ModelAdapterDocumentQuery] when executing functions for collections. Use [ModelAdapterDocumentQuery] to execute document queries.
  ///
  /// [ModelAdapter]の各機能を実行する際に渡すクエリークラス。
  ///
  /// コレクション用の機能を実行する際に利用します。ドキュメントのクエリを実行する際は[ModelAdapterDocumentQuery]をご利用ください。
  const ModelAdapterCollectionQuery({
    required this.query,
    this.callback,
    this.origin,
    this.listen = true,
    this.page = 1,
    this.headers = const {},
    this.method,
  });

  /// Collection queries.
  ///
  /// コレクションのクエリー。
  final CollectionModelQuery query;

  /// The collection object from which to perform the query.
  ///
  /// クエリを実行する元のコレクションオブジェクト。
  final Object? origin;

  /// Set to `true` to monitor query changes.
  ///
  /// クエリの変更を監視する場合`true`に設定します。
  final bool listen;

  /// Headers for sending a request.
  ///
  /// リクエストを送る際のヘッダー。
  final Map<String, String> headers;

  /// Method for sending a request.
  ///
  /// リクエストを送る際のメソッド。
  final String? method;

  /// Page number to be read. If [ModelQueryFilterType.limit] is set, additional reading is performed according to this page number.
  ///
  /// 読込のページ番号。[ModelQueryFilterType.limit]が設定されている場合、こちらのページ番号に応じて追加読込を行います。
  final int page;

  /// A callback that is notified when there is a change in the corresponding collection.
  ///
  /// Contains information on changes to `update`.
  ///
  /// 該当コレクションに変更があった場合、通知されるコールバック。
  ///
  /// `update`に変更された場合の情報が含まれています。
  final void Function(ModelUpdateNotification update)? callback;

  /// Create a [ModelAdapterDocumentQuery] for a document under a collection using its own [CollectionModelQuery] and [id].
  ///
  /// If [id] is [Null], [uuid] (32-byte non-hyphenated string) is used.
  ///
  /// [origin], [callback] will be [null], and [listen] will be `false`.
  ///
  /// 自身の[CollectionModelQuery]と[id]を用いてコレクション配下のドキュメント用の[ModelAdapterDocumentQuery]を作成します。
  ///
  /// [id]が[Null]の場合は[uuid]（32バイトのハイフン無しの文字列）が利用されます。
  ///
  /// [origin]、[callback]は[Null]になり、[listen]は`false`になります。
  ModelAdapterDocumentQuery create<T>([
    String? id,
  ]) {
    return ModelAdapterDocumentQuery(
      query: query.create(id),
      origin: null,
      callback: null,
      listen: false,
      headers: headers,
      method: method,
    );
  }

  /// Change [headers] or [method], [page], and [query] and copy.
  ///
  /// Copied objects are recognized as the same object.
  ///
  /// [headers]もしくは[method]、[page]、[query]を変更してコピーします。
  ///
  /// コピーされたオブジェクトは同一オブジェクトとして認識されます。
  ModelAdapterCollectionQuery copyWith({
    Map<String, String>? headers,
    String? method,
    int? page,
    CollectionModelQuery? query,
  }) {
    return ModelAdapterCollectionQuery(
      query: query ?? this.query,
      callback: callback,
      origin: origin,
      listen: listen,
      headers: headers ?? this.headers,
      method: method ?? this.method,
      page: page ?? this.page,
    );
  }

  @override
  String toString() {
    return "$runtimeType(query: $query, listen: $listen, origin: ${origin.hashCode}, headers: $headers, method: $method)";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode {
    return query.hashCode;
  }
}
