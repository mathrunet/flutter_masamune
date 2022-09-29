part of katana_model;

/// You can implement adapters that define the internal specifications of the model.
/// モデルの内部仕様を定義するアダプターを実装できます。
///
/// The loading process is implemented in [ModelAdapter.loadDocument] or [ModelAdapter.loadCollection].
/// 読み込み時の処理は[ModelAdapter.loadDocument]や[ModelAdapter.loadCollection]に実装します。
///
/// When saving data for a document (saving and deleting data for a collection is systematically prohibited) is implemented in [ModelAdapter.saveDocument], and deleting is implemented in [ModelAdapter.deleteDocument].
/// ドキュメントのデータ保存時（コレクションのデータ保存・削除はシステム的に禁止）は[ModelAdapter.saveDocument]に実装し、削除は[ModelAdapter.deleteDocument]に実装します。
///
/// If each model is to be destroyed, implement and execute [ModelAdapter.disposeDocument] or [ModelAdapter.disposeCollection].
/// 各モデルが破棄される場合は[ModelAdapter.disposeDocument]や[ModelAdapter.disposeCollection]を実装し実行してください。
///
/// You can also get the default adapter from [ModelAdapter.primary].
/// またデフォルトのアダプターを[ModelAdapter.primary]から取得できます。
///
/// [ModelAdapter.primary] is automatically set through [ModelAdapterScope] executed at the top level.
/// [ModelAdapter.primary]はトップレベルで実行された[ModelAdapterScope]を通して自動的に設定されます。
///
/// If [ModelAdapterScope] is not running, [RuntimeModelAdapter] will be called.
/// [ModelAdapterScope]が実行されていない場合には[RuntimeModelAdapter]が呼び出されます。
@immutable
abstract class ModelAdapter {
  /// You can implement adapters that define the internal specifications of the model.
  /// モデルの内部仕様を定義するアダプターを実装できます。
  ///
  /// The loading process is implemented in [ModelAdapter.loadDocument] or [ModelAdapter.loadCollection].
  /// 読み込み時の処理は[ModelAdapter.loadDocument]や[ModelAdapter.loadCollection]に実装します。
  ///
  /// When saving data for a document (saving and deleting data for a collection is systematically prohibited) is implemented in [ModelAdapter.saveDocument], and deleting is implemented in [ModelAdapter.deleteDocument].
  /// ドキュメントのデータ保存時（コレクションのデータ保存・削除はシステム的に禁止）は[ModelAdapter.saveDocument]に実装し、削除は[ModelAdapter.deleteDocument]に実装します。
  ///
  /// If each model is to be destroyed, implement and execute [ModelAdapter.disposeDocument] or [ModelAdapter.disposeCollection].
  /// 各モデルが破棄される場合は[ModelAdapter.disposeDocument]や[ModelAdapter.disposeCollection]を実装し実行してください。
  ///
  /// You can also get the default adapter from [ModelAdapter.primary].
  /// またデフォルトのアダプターを[ModelAdapter.primary]から取得できます。
  ///
  /// [ModelAdapter.primary] is automatically set through [ModelAdapterScope] executed at the top level.
  /// [ModelAdapter.primary]はトップレベルで実行された[ModelAdapterScope]を通して自動的に設定されます。
  ///
  /// If [ModelAdapterScope] is not running, [RuntimeModelAdapter] will be called.
  /// [ModelAdapterScope]が実行されていない場合には[RuntimeModelAdapter]が呼び出されます。
  const ModelAdapter();

  /// You can get the default adapter.
  /// デフォルトのアダプターを取得できます。
  ///
  /// [ModelAdapter.primary] is automatically set through [ModelAdapterScope] executed at the top level.
  /// [ModelAdapter.primary]はトップレベルで実行された[ModelAdapterScope]を通して自動的に設定されます。
  ///
  /// If [ModelAdapterScope] is not running, [RuntimeModelAdapter] will be called.
  /// [ModelAdapterScope]が実行されていない場合には[RuntimeModelAdapter]が呼び出されます。
  static ModelAdapter get primary {
    return _primary ?? const RuntimeModelAdapter();
  }

  static ModelAdapter? _primary;

  /// Set [rawData], such as mock data, to the platform set by the adapter.
  /// モックデータなどの[rawData]をアダプターで設定されたプラットフォームにセットします。
  void setRawData(Map<String, DynamicMap> rawData);

  /// Pass [query] to the platform set by the adapter to retrieve the document.
  /// アダプターで設定されたプラットフォームに[query]を渡してドキュメントを取得します。
  ///
  /// All return values are [DynamicMap].
  /// 戻り値はすべて[DynamicMap]になります。
  Future<DynamicMap> loadDocument(ModelAdapterDocumentQuery query);

  /// Pass [query] to the platform set by the adapter to retrieve the collection.
  /// アダプターで設定されたプラットフォームに[query]を渡してコレクションを取得します。
  ///
  /// All return values ​​will be [Map<String, DynamicMap>]. [String] contains the `ID` (not the path) of each document.
  /// 戻り値はすべて[Map<String, DynamicMap>]になります。[String]には各ドキュメントの`ID`（パスではない）が入ります。
  Future<Map<String, DynamicMap>> loadCollection(
    ModelAdapterCollectionQuery query,
  );

  /// By passing the [query] and the [value] to be stored, the data is stored on the platform set by the adapter.
  /// [query]と保存する[value]を渡すことでアダプターで設定されたプラットフォームにデータを保存します。
  Future<void> saveDocument(
    ModelAdapterDocumentQuery query,
    DynamicMap value,
  );

  /// Delete data from the platform set by the adapter by passing [query].
  /// [query]を渡すことでアダプターで設定されたプラットフォームからデータを削除します。
  Future<void> deleteDocument(ModelAdapterDocumentQuery query);

  /// The destruction of related documents is handled by passing [query].
  /// [query]を渡すことで関連したドキュメントの破棄処理を行います。
  ///
  /// It should always be performed when a document is destroyed.
  /// ドキュメントの破棄時にはかならず実行してください。
  void disposeDocument(ModelAdapterDocumentQuery query);

  /// The associated collection is discarded by passing [query].
  /// [query]を渡すことで関連したコレクションの破棄処理を行います。
  ///
  /// It should always be performed when destroying a collection.
  /// コレクションの破棄時にはかならず実行してください。
  void disposeCollection(ModelAdapterCollectionQuery query);

  // Set to `true` if changes can be monitored.
  // 変更を監視可能な場合`true`にします。
  bool get availableListen;

  /// Pass [query] to monitor the document.
  /// [query]を渡してドキュメントの監視を行います。
  ///
  /// When monitoring is started, [StreamSubscription] is passed, so keep it.
  /// 監視が開始された場合、[StreamSubscription]が渡されるので、それを保持しておいてください。
  ///
  /// All retained [StreamSubscription] should be canceled when the object is destroyed or before executing this method again.
  /// 保持した[StreamSubscription]はオブジェクトの破棄時、または再度このメソッドを実行する前にすべてキャンセルしてください。
  Future<List<StreamSubscription>> listenDocument(
    ModelAdapterDocumentQuery query,
  );

  /// Pass [query] to monitor the collection.
  /// [query]を渡してコレクションの監視を行います。
  ///
  /// When monitoring is started, [StreamSubscription] is passed, so keep it.
  /// 監視が開始された場合、[StreamSubscription]が渡されるので、それを保持しておいてください。
  ///
  /// All retained [StreamSubscription] should be canceled when the object is destroyed or before executing this method again.
  /// 保持した[StreamSubscription]はオブジェクトの破棄時、または再度このメソッドを実行する前にすべてキャンセルしてください。
  Future<List<StreamSubscription>> listenCollection(
    ModelAdapterCollectionQuery query,
  );
}

/// Widget for setting [ModelAdapter].
/// [ModelAdapter]を設定するためのウィジェットです。
///
/// You can set a child widget in [child] and an adapter for use in [adapter].
/// [child]に子のウィジェットを設定し、[adapter]に利用するためのアダプターを設定できます。
///
/// You can get the nearest ancestor [adapter] from [ModelAdapterScope.of].
/// [ModelAdapterScope.of]から近い先祖の[adapter]を取得することができます。
///
/// By passing the [adapter] obtained here to [CollectionModelQuery] or [DocumentModelQuery], it is possible to change the internal processing of the model.
/// ここで設定した[adapter]を[CollectionModelQuery]や[DocumentModelQuery]に渡すことでモデルの内部処理を変更することが可能です。
class ModelAdapterScope extends StatefulWidget {
  /// Widget for setting [ModelAdapter].
  /// [ModelAdapter]を設定するためのウィジェットです。
  ///
  /// You can set a child widget in [child] and an adapter for use in [adapter].
  /// [child]に子のウィジェットを設定し、[adapter]に利用するためのアダプターを設定できます。
  ///
  /// You can get the nearest ancestor [adapter] from [ModelAdapterScope.of].
  /// [ModelAdapterScope.of]から近い先祖の[adapter]を取得することができます。
  ///
  /// By passing the [adapter] obtained here to [CollectionModelQuery] or [DocumentModelQuery], it is possible to change the internal processing of the model.
  /// ここで設定した[adapter]を[CollectionModelQuery]や[DocumentModelQuery]に渡すことでモデルの内部処理を変更することが可能です。
  const ModelAdapterScope({
    required this.child,
    required this.adapter,
  });

  /// Widgets to give to children.
  /// 子供に渡すウィジェット。
  final Widget child;

  /// An adapter that defines the model internal processing.
  /// モデル内部処理を定義したアダプター。
  final ModelAdapter adapter;

  /// You can get [adapter] of a close ancestor.
  /// 近い先祖の[adapter]を取得することができます。
  ///
  /// By passing the [adapter] obtained here to [CollectionModelQuery] or [DocumentModelQuery], it is possible to change the internal processing of the model.
  /// ここで取得した[adapter]を[CollectionModelQuery]や[DocumentModelQuery]に渡すことでモデルの内部処理を変更することが可能です。
  static _ModelAdapterScope? of(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<_ModelAdapterScope>()
        ?.widget as _ModelAdapterScope?;
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
    return _ModelAdapterScope(child: widget.child, adapter: widget.adapter);
  }
}

class _ModelAdapterScope extends InheritedWidget {
  const _ModelAdapterScope({
    required super.child,
    required this.adapter,
  });

  final ModelAdapter adapter;

  @override
  bool updateShouldNotify(covariant _ModelAdapterScope oldWidget) => true;
}

/// Query class to be passed when executing each function of [ModelAdapter].
/// [ModelAdapter]の各機能を実行する際に渡すクエリークラス。
///
/// Use this when executing functions for documents. Use [ModelAdapterCollectionQuery] when performing collection queries.
/// ドキュメント用の機能を実行する際に利用します。コレクションのクエリを実行する際は[ModelAdapterCollectionQuery]をご利用ください。
@immutable
class ModelAdapterDocumentQuery {
  /// Query class to be passed when executing each function of [ModelAdapter].
  /// [ModelAdapter]の各機能を実行する際に渡すクエリークラス。
  ///
  /// Use this when executing functions for documents. Use [ModelAdapterCollectionQuery] when performing collection queries.
  /// ドキュメント用の機能を実行する際に利用します。コレクションのクエリを実行する際は[ModelAdapterCollectionQuery]をご利用ください。
  const ModelAdapterDocumentQuery({
    required this.query,
    this.callback,
    this.origin,
    this.listen = true,
  });

  /// Document query.
  /// ドキュメントのクエリー。
  final DocumentModelQuery query;

  /// The original document object from which to perform the query.
  /// クエリを実行する元のドキュメントオブジェクト。
  final Object? origin;

  /// Set to `true` to monitor query changes.
  /// クエリの変更を監視する場合`true`に設定します。
  final bool listen;

  /// A callback that is notified when changes are made to the relevant document.
  /// 該当ドキュメントに変更があった場合、通知されるコールバック。
  ///
  /// Contains information on changes to `update`.
  /// `update`に変更された場合の情報が含まれています。
  final void Function(ModelUpdateNotification update)? callback;

  @override
  String toString() {
    return "$runtimeType(query: $query, listen: $listen, origin: ${origin.hashCode})";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => query.hashCode ^ origin.hashCode;
}

/// Query class to be passed when executing each function of [ModelAdapter].
/// [ModelAdapter]の各機能を実行する際に渡すクエリークラス。
///
/// Use [ModelAdapterDocumentQuery] when executing functions for collections. Use [ModelAdapterDocumentQuery] to execute document queries.
/// コレクション用の機能を実行する際に利用します。ドキュメントのクエリを実行する際は[ModelAdapterDocumentQuery]をご利用ください。
@immutable
class ModelAdapterCollectionQuery {
  /// Query class to be passed when executing each function of [ModelAdapter].
  /// [ModelAdapter]の各機能を実行する際に渡すクエリークラス。
  ///
  /// Use [ModelAdapterDocumentQuery] when executing functions for collections. Use [ModelAdapterDocumentQuery] to execute document queries.
  /// コレクション用の機能を実行する際に利用します。ドキュメントのクエリを実行する際は[ModelAdapterDocumentQuery]をご利用ください。
  const ModelAdapterCollectionQuery({
    required this.query,
    this.callback,
    this.origin,
    this.listen = true,
    this.page = 1,
  });

  /// Collection queries.
  /// コレクションのクエリー。
  final CollectionModelQuery query;

  /// The collection object from which to perform the query.
  /// クエリを実行する元のコレクションオブジェクト。
  final Object? origin;

  /// Set to `true` to monitor query changes.
  /// クエリの変更を監視する場合`true`に設定します。
  final bool listen;

  // Page number to be read. If [ModelQuery.limit] is set, additional reading is performed according to this page number.
  // 読込のページ番号。[ModelQuery.limit]が設定されている場合、こちらのページ番号に応じて追加読込を行います。
  final int page;

  /// A callback that is notified when there is a change in the corresponding collection.
  /// 該当コレクションに変更があった場合、通知されるコールバック。
  ///
  /// Contains information on changes to `update`.
  /// `update`に変更された場合の情報が含まれています。
  final void Function(ModelUpdateNotification update)? callback;

  @override
  String toString() {
    return "$runtimeType(query: $query, listen: $listen, origin: ${origin.hashCode})";
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => query.hashCode ^ origin.hashCode;

  // Update [page] and create a new [ModelAdapterCollectionQuery].
  // [page]を更新して新しい[ModelAdapterCollectionQuery]を作成します。
  ModelAdapterCollectionQuery pageWith({
    int? page,
  }) {
    return ModelAdapterCollectionQuery(
      query: query,
      callback: callback,
      origin: origin,
      listen: listen,
      page: page ?? this.page,
    );
  }
}
