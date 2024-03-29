part of '/katana_model.dart';

/// Define a collection model that includes [DocumentBase] as an element.
///
/// Any changes made locally in the app will be notified and related objects will reflect the changes.
///
/// When changes are reflected, [notifyListeners] will notify all listeners of the changes.
///
/// Define [CollectionBase.create] to describe the process of creating a new document.
///
/// By defining [modelQuery], you can specify settings for loading, such as collection paths and conditions.
///
/// The collection implements [List], but changing an element is `Unmodifiable` and will result in an error.
///
/// Execute [DocumentBase.save] for each document to change elements, and [DocumentBase.delete] for each document to delete them.
///
/// To add elements, run [CollectionBase.create] to create a new document, then save it with [DocumentBase.save].
///
/// [DocumentBase]を要素に含めたコレクションモデルを定義します。
///
/// アプリのローカル内での変更はすべて通知され関連のあるオブジェクトは変更内容が反映されます。
///
/// 変更内容が反映された場合[notifyListeners]によって変更内容がすべてのリスナーに通知されます。
///
/// [CollectionBase.create]を定義することで新規にドキュメントを作成する処理を記述します。
///
/// [modelQuery]を定義することで、コレクションのパスや条件など読み込みを行うための設定を指定できます。
///
/// コレクションは[List]を実装していますが、要素の変更は`Unmodifiable`となりエラーになります。
///
/// 要素を変更する場合は各ドキュメントの[DocumentBase.save]を実行し、削除する場合は各ドキュメントの[DocumentBase.delete]を実行してください。
///
/// 要素を追加する場合は[CollectionBase.create]を実行し新しいドキュメントを作成したあと、[DocumentBase.save]で保存してください。
abstract class CollectionBase<TModel extends DocumentBase>
    extends ChangeNotifier
    with _InternalTransactionMixin
    implements List<TModel> {
  /// Define a collection model that includes [DocumentBase] as an element.
  ///
  /// Any changes made locally in the app will be notified and related objects will reflect the changes.
  ///
  /// When changes are reflected, [notifyListeners] will notify all listeners of the changes.
  ///
  /// Define [CollectionBase.create] to describe the process of creating a new document.
  ///
  /// By defining [modelQuery], you can specify settings for loading, such as collection paths and conditions.
  ///
  /// The collection implements [List], but changing an element is `Unmodifiable` and will result in an error.
  ///
  /// Execute [DocumentBase.save] for each document to change elements, and [DocumentBase.delete] for each document to delete them.
  ///
  /// To add elements, run [CollectionBase.create] to create a new document, then save it with [DocumentBase.save].
  ///
  /// [DocumentBase]を要素に含めたコレクションモデルを定義します。
  ///
  /// アプリのローカル内での変更はすべて通知され関連のあるオブジェクトは変更内容が反映されます。
  ///
  /// 変更内容が反映された場合[notifyListeners]によって変更内容がすべてのリスナーに通知されます。
  ///
  /// [CollectionBase.create]を定義することで新規にドキュメントを作成する処理を記述します。
  ///
  /// [modelQuery]を定義することで、コレクションのパスや条件など読み込みを行うための設定を指定できます。
  ///
  /// コレクションは[List]を実装していますが、要素の変更は`Unmodifiable`となりエラーになります。
  ///
  /// 要素を変更する場合は各ドキュメントの[DocumentBase.save]を実行し、削除する場合は各ドキュメントの[DocumentBase.delete]を実行してください。
  ///
  /// 要素を追加する場合は[CollectionBase.create]を実行し新しいドキュメントを作成したあと、[DocumentBase.save]で保存してください。
  CollectionBase(
    this._modelQuery, [
    List<TModel>? value,
  ])  : __value = value ?? [],
        assert(
          !(_modelQuery.path.trimQuery().trimString("/").splitLength() <= 0 ||
              _modelQuery.path.trimQuery().trimString("/").splitLength() % 2 !=
                  1),
          "The query path hierarchy must be an odd number: ${_modelQuery.path}",
        );

  /// Define a collection model that includes [DocumentBase] as an element.
  ///
  /// Any changes made locally in the app will be notified and related objects will reflect the changes.
  ///
  /// When changes are reflected, [notifyListeners] will notify all listeners of the changes.
  ///
  /// Define [CollectionBase.create] to describe the process of creating a new document.
  ///
  /// By defining [modelQuery], you can specify settings for loading, such as collection paths and conditions.
  ///
  /// The collection implements [List], but changing an element is `Unmodifiable` and will result in an error.
  ///
  /// Execute [DocumentBase.save] for each document to change elements, and [DocumentBase.delete] for each document to delete them.
  ///
  /// To add elements, run [CollectionBase.create] to create a new document, then save it with [DocumentBase.save].
  ///
  /// [DocumentBase]を要素に含めたコレクションモデルを定義します。
  ///
  /// アプリのローカル内での変更はすべて通知され関連のあるオブジェクトは変更内容が反映されます。
  ///
  /// 変更内容が反映された場合[notifyListeners]によって変更内容がすべてのリスナーに通知されます。
  ///
  /// [CollectionBase.create]を定義することで新規にドキュメントを作成する処理を記述します。
  ///
  /// [modelQuery]を定義することで、コレクションのパスや条件など読み込みを行うための設定を指定できます。
  ///
  /// コレクションは[List]を実装していますが、要素の変更は`Unmodifiable`となりエラーになります。
  ///
  /// 要素を変更する場合は各ドキュメントの[DocumentBase.save]を実行し、削除する場合は各ドキュメントの[DocumentBase.delete]を実行してください。
  ///
  /// 要素を追加する場合は[CollectionBase.create]を実行し新しいドキュメントを作成したあと、[DocumentBase.save]で保存してください。
  CollectionBase.unrestricted(
    this._modelQuery, [
    List<TModel>? value,
  ]) : __value = value ?? [];

  /// Create a new document of type [TModel] from the contents of the collection.
  ///
  /// The document will be created with the collection path of [modelQuery] plus [id] (if `null`, a random [uuid] will be used).
  ///
  /// コレクションの内容から新しく[TModel]型のドキュメントを作成します。
  ///
  /// [modelQuery]のコレクションパスに[id]（`null`の場合はランダムな[uuid]が使用されます）を加えたパスでドキュメントが作成されます。
  TModel create([String? id]);

  /// Query to read and save collections.
  ///
  /// コレクションを読込・保存するためのクエリ。
  @protected
  CollectionModelQuery get modelQuery => _modelQuery;
  // ignore: prefer_final_fields
  late CollectionModelQuery _modelQuery;

  /// Database queries for collections.
  ///
  /// コレクション用のデータベースクエリ。
  @protected
  ModelAdapterCollectionQuery get databaseQuery {
    return _databaseQuery ??= ModelAdapterCollectionQuery(
      query: modelQuery,
      callback: handledOnUpdate,
      origin: this,
    );
  }

  ModelAdapterCollectionQuery? _databaseQuery;

  /// List of currently subscribed notifications. All should be canceled when the object is destroyed.
  ///
  /// 現在購読中の通知一覧。オブジェクトの破棄時にすべてキャンセルするようにしてください。
  @protected
  List<StreamSubscription> get subscriptions => _subscriptions;
  final List<StreamSubscription> _subscriptions = [];

  @protected
  List<TModel> get _value => __value;

  @protected
  set _value(List<TModel> value) {
    if (__value == value) {
      return;
    }
    __value = value;
  }

  // ignore: prefer_final_fields
  @protected
  late List<TModel> __value;

  /// Returns `true` if the data was successfully loaded by the [load] method.
  ///
  /// If this is set to `true`, the [load] method will not be loaded when executed.
  ///
  /// [load]メソッドでデータが読み込みに成功した場合`true`を返します。
  ///
  /// これが`true`になっている場合、[load]メソッドは実行しても読込は行われません。
  bool get loaded => _loaded;
  bool _loaded = false;

  /// If [load], [reload] or [next] is executed, it waits until the reading process is completed.
  ///
  /// After reading, [CollectionBase] itself is returned.
  ///
  /// If [load], [reload] or [next] is not in progress, [Null] is returned.
  ///
  /// [load]や[reload]、[next]を実行した場合、その読込処理が終わるまで待ちます。
  ///
  /// 読込終了後、[CollectionBase]自身が返されます。
  ///
  /// [load]や[reload]、[next]を実行中でない場合、[Null]が返されます。
  Future<CollectionBase<TModel>>? get loading => _loadCompleter?.future;
  Completer<CollectionBase<TModel>>? _loadCompleter;

  /// If [reload] is done, it waits until the loading process is finished.
  ///
  /// After reading is completed, a [T] object is returned.
  ///
  /// If [reload] is not in progress, [Null] is returned.
  ///
  /// [reload]した場合にその読込処理が終わるまで待ちます。
  ///
  /// 読込終了後、[T]オブジェクトが返されます。
  ///
  /// [reload]を実行中でない場合、[Null]が返されます。
  Future<CollectionBase<TModel>>? get reloading => _reloadingCompleter?.future;
  Completer<CollectionBase<TModel>>? _reloadingCompleter;

  /// If the number of elements is limited by [ModelQueryFilterType.limit], returns `true` if the next element can be added.
  ///
  /// If the number of elements does not change when the [next] method is executed, [canNext] will be `false`.
  ///
  /// [ModelQueryFilterType.limit]で要素数を制限されている場合、次の要素が追加可能な場合`true`を返します。
  ///
  /// [next]メソッドを実行した際に要素数が変わらなかった場合、[canNext]は`false`になります。
  bool get canNext => _canNext;
  bool _canNext = true;

  /// Reads the collection corresponding to [modelQuery].
  ///
  /// The return value is the [CollectionBase] itself, and the loaded data is available as is.
  ///
  /// Once content is loaded, no new loading is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// If you wish to reload the file, use the [reload] method.
  ///
  /// [modelQuery]に対応したコレクションの読込を行います。
  ///
  /// 戻り値は[CollectionBase]そのものが返され、そのまま読込済みのデータの利用が可能になります。
  ///
  /// 一度読み込んだコンテンツに対しては、新しい読込は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  ///
  /// 再読み込みを行いたい場合は[reload]メソッドを利用してください。
  Future<CollectionBase<TModel>> load() async {
    if (loaded) {
      return this;
    }
    if (_loadCompleter != null) {
      return loading!;
    }
    await _enqueueInternalTransaction(() async {
      if (loaded) {
        return;
      }
      await _load();
    });
    return this;
  }

  Future<CollectionBase<TModel>> _load() async {
    if (_loadCompleter != null) {
      return loading!;
    }
    try {
      final tmpValue = _value;
      _loadCompleter = Completer<CollectionBase<TModel>>();
      if (!loaded) {
        final res = await loadRequest();
        final limitValue = modelQuery.filters
            .firstWhereOrNull((e) => e.type == ModelQueryFilterType.limit)
            ?.value as int?;
        if (res != null) {
          _value = await filterOnDidLoad(
            await fromMap(
              res,
              limitValue != null ? (limitValue * databaseQuery.page) : null,
            ),
          );
        }
        _loaded = true;
      }
      if (tmpValue != _value || _reloadingCompleter != null) {
        notifyListeners();
      }
      _loadCompleter?.complete(this);
      _loadCompleter = null;
    } catch (e) {
      _loadCompleter?.completeError(e);
      _loadCompleter = null;
      rethrow;
    } finally {
      _loadCompleter?.complete(this);
      _loadCompleter = null;
    }
    return this;
  }

  /// Reload the collection corresponding to [modelQuery].
  ///
  /// The return value is the [CollectionBase] itself, and the loaded data is available as is.
  ///
  /// Unlike the [load] method, this method performs a new load each time it is executed. Therefore, do not use this method in a method that is read repeatedly, such as in the `build` method of a `widget`.
  ///
  /// [modelQuery]に対応したコレクションの再読込を行います。
  ///
  /// 戻り値は[CollectionBase]そのものが返され、そのまま読込済みのデータの利用が可能になります。
  ///
  /// [load]メソッドとは違い実行されるたびに新しい読込を行います。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内では利用しないでください。
  Future<CollectionBase<TModel>> reload() async {
    await _enqueueInternalTransaction(() async {
      _reloadingCompleter = Completer();
      try {
        _loaded = false;
        await _load();
      } catch (e) {
        _reloadingCompleter?.completeError(e);
        _reloadingCompleter = null;
        rethrow;
      } finally {
        _reloadingCompleter?.complete(this);
        _reloadingCompleter = null;
      }
    });
    return this;
  }

  /// If the number of elements is limited by [ModelQueryFilterType.limit], additional elements are loaded for the next limited number.
  ///
  /// If the number of elements does not change when executed, [canNext] will be `false`, but this method will be executed even if [canNext] is `false`.
  ///
  /// Unlike the [load] method, this method performs a new load each time it is executed. Therefore, do not use this method in a method that is read repeatedly, such as in the `build` method of a `widget`.
  ///
  /// [ModelQueryFilterType.limit]で要素数を制限されている場合、次の制限個数分だけ追加要素を読み込みます。
  ///
  /// 実行した際に要素数が変わらなかった場合、[canNext]は`false`になりますがこのメソッドは[canNext]が`false`でも実行されます。
  ///
  /// [load]メソッドとは違い実行されるたびに新しい読込を行います。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内では利用しないでください。
  Future<CollectionBase<TModel>> next() async {
    await _enqueueInternalTransaction(() async {
      _loaded = false;
      _databaseQuery = databaseQuery.copyWith(page: databaseQuery.page + 1);
      final prevLength = length;
      await _load();
      if (length == prevLength) {
        _canNext = false;
        _databaseQuery = databaseQuery.copyWith(page: databaseQuery.page - 1);
      }
    });
    return this;
  }

  /// Get the number of elements in all collections existing in the database.
  ///
  /// [AsyncAggregateValue] is returned, wait a moment and then retrieve the value from [AsyncAggregateValue.value].
  ///
  /// Values loaded with [load] are normally retained, but will be reloaded when [reload] is executed.
  ///
  /// データベース上に存在するすべてのコレクションの要素数を取得します。
  ///
  /// [AsyncAggregateValue]が返されるので少し待ったあと[AsyncAggregateValue.value]から値を取得してください。
  ///
  /// [load]で読み込んだ値は通常は保持されますが、[reload]を実行した場合は再度読み込まれます。
  TValue aggregate<TValue extends AsyncAggregateValue>(
      ModelAggregateQuery<TValue> query) {
    if (_aggregate.containsKey(query)) {
      final val = _aggregate[query];
      if (val is TValue) {
        return val;
      }
    }
    final val = query.onCreate(query, this, notifyListeners);
    _aggregate[query] = val;
    return val;
  }

  final Map<ModelAggregateQuery, AsyncAggregateValue> _aggregate = {};

  /// Delete all retained documents.
  ///
  /// すべての保持しているドキュメントを削除します。
  Future<CollectionBase<TModel>> deleteAll() async {
    await _enqueueInternalTransaction(() async {
      final res = List<TModel>.from(this);
      final futures = res.map((e) => e.delete());
      await Future.wait(futures);
    });
    return this;
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
  ModelTransactionCollectionBuilder<TModel> transaction() {
    return ModelTransactionCollectionBuilder._(this);
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
  ModelBatchCollectionBuilder<TModel> batch({int splitLength = 100}) {
    return ModelBatchCollectionBuilder._(this, splitLength);
  }

  /// [callback] will redefine a new [CollectionModelQuery] and execute [reload].
  ///
  /// Use this function when you want to read the file again with new conditions.
  ///
  /// [callback]により新しく[CollectionModelQuery]を定義し直して[reload]を実行します。
  ///
  /// 新しい条件で再度読み込みをおこないたい場合に利用します。
  Future<CollectionBase<TModel>> replaceQuery(
    CollectionModelQuery Function(CollectionModelQuery source) callback,
  ) async {
    final prevQuery = modelQuery;
    _modelQuery = callback.call(modelQuery);
    if (modelQuery != prevQuery) {
      _databaseQuery = null;
      _databaseQuery = databaseQuery.copyWith(
        query: modelQuery,
      );
      _modelQuery.adapter.disposeCollection(databaseQuery);
      await reload();
    } else {
      _modelQuery = prevQuery;
    }
    return this;
  }

  /// Callback called after loading.
  ///
  /// If [loaded] is `true`, it will not be executed.
  ///
  /// If [value] is passed and a modified version of it is returned, it becomes the [value] of [DocumentBase].
  ///
  /// ロード後に呼ばれるコールバック。
  ///
  /// [loaded]が`true`の場合は実行されません。
  ///
  /// リストの中の[DocumentBase]が
  @protected
  @mustCallSuper
  Future<List<TModel>> filterOnDidLoad(List<TModel> value) async {
    return await Future.wait(
      value.map((e) async {
        final res = await e.filterOnDidLoad(e.value);
        if (res != e.value) {
          e._value = res;
        }
        return e;
      }),
    );
  }

  /// Implement internal processing when [load], [reload], or [next] is executed.
  ///
  /// If [Null] is returned, the value is not updated.
  ///
  /// [load]や[reload]、[next]を実行した際の内部処理を実装します。
  ///
  /// [Null]が返された場合は値をアップデートしません。
  @protected
  Future<Map<String, DynamicMap>?> loadRequest() async {
    if (subscriptions.isNotEmpty) {
      await Future.forEach<StreamSubscription>(
        subscriptions,
        (subscription) => subscription.cancel(),
      );
      subscriptions.clear();
      _value.clear();
    }
    if (modelQuery.adapter.availableListen) {
      subscriptions.addAll(
        await modelQuery.adapter.listenCollection(databaseQuery),
      );
    }
    return await modelQuery.adapter.loadCollection(databaseQuery);
  }

  /// Describe the callback process to pass to [ModelAdapterCollectionQuery.callback].
  ///
  /// This is executed when there is a change in the associated collection or document.
  ///
  /// Please take appropriate action according to the contents of [update].
  ///
  /// [ModelAdapterCollectionQuery.callback]に渡すためのコールバック処理を記述します。
  ///
  /// 関連するコレクションやドキュメントに変更があった場合、こちらが実行されます。
  ///
  /// [update]の内容に応じて適切な処理を行ってください。
  @protected
  Future<void> handledOnUpdate(ModelUpdateNotification update) async {
    if (update.query != modelQuery) {
      return;
    }
    var notify = false;
    switch (update.status) {
      case ModelUpdateNotificationStatus.added:
        if (update.newIndex == null) {
          return;
        }
        final value = create(update.id.trimQuery().trimString("?"));
        final val = value.value;
        final filtered = value._filterOnLoad(update.value);
        if (filtered.isEmpty) {
          value._value = null;
          // 最初にいれないと要素が無いエラーがでる場合がある
          _value.insert(update.newIndex!, value);
        } else {
          final fromMap = value._value = value.fromMap(filtered);
          // 最初にいれないと要素が無いエラーがでる場合がある
          _value.insert(update.newIndex!, value);
          value._value = await value.filterOnDidLoad(fromMap);
        }
        if (val != value.value) {
          value.notifyListeners();
        }
        notify = true;
        break;
      case ModelUpdateNotificationStatus.modified:
        if (update.oldIndex == null || update.newIndex == null) {
          return;
        }
        final found = _value.removeAt(update.oldIndex!);
        final val = found.value;
        final filtered = found._filterOnLoad(update.value);
        if (filtered.isEmpty) {
          found._value = null;
          // 最初にいれないと要素が無いエラーがでる場合がある
          _value.insert(update.newIndex!, found);
        } else {
          final fromMap = found._value = found.fromMap(filtered);
          // 最初にいれないと要素が無いエラーがでる場合がある
          _value.insert(update.newIndex!, found);
          found._value = await found.filterOnDidLoad(fromMap);
        }
        if (val != found.value) {
          found.notifyListeners();
          if (modelQuery.filters.any(
              (e) => e.type == ModelQueryFilterType.notifyDocumentChanges)) {
            notify = true;
          }
        }
        if (update.newIndex != update.oldIndex) {
          notify = true;
        }
        break;
      case ModelUpdateNotificationStatus.removed:
        if (update.oldIndex == null) {
          return;
        }
        if (_value.length <= update.oldIndex!) {
          return;
        }
        _value.removeAt(update.oldIndex!);
        notify = true;
        break;
    }
    if (notify) {
      notifyListeners();
    }
  }

  /// Creates a [List<TModel>] from a [map] of type [Map<String, DynamicMap>] decoded from Json.
  ///
  /// The number of elements output can be limited by specifying [limit].
  ///
  /// Jsonからデコードされた[Map<String, DynamicMap>]型の[map]から[List<TModel>]を作成します。
  ///
  /// [limit]を指定することで出力される要素数を制限することが可能です。
  @protected
  Future<List<TModel>> fromMap(Map<String, DynamicMap> map, int? limit) async {
    final res = <TModel>[];
    final sorted = modelQuery.sort(List.from(map.entries));
    for (final tmp in sorted) {
      final key =
          tmp.key.replaceAll("/", "").replaceAll("?", "").replaceAll("&", "");
      if (key.isEmpty) {
        continue;
      }
      final value = create(key);
      final filtered = value._filterOnLoad(
        Map<String, dynamic>.unmodifiable(tmp.value),
      );
      if (filtered.isEmpty) {
        value._value = null;
      } else {
        value._value = value.fromMap(filtered);
      }
      res.add(value);
    }
    return limit != null ? res.sublist(0, min(limit, res.length)) : res;
  }

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
    _value.clear();
    _transactionQueue.clear();
    modelQuery.adapter.disposeCollection(databaseQuery);
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
  }

  @override
  String toString() => IterableBase.iterableToShortString(this, "(", ")");

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  set length(int value) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  @override
  List<TModel> operator +(List<TModel> other) => _value + other;

  @override
  TModel operator [](int index) => _value[index];

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void operator []=(int index, TModel value) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void add(TModel value) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void addAll(Iterable<TModel> iterable) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void clear() {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void fillRange(int start, int end, [TModel? fillValue]) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void insert(int index, TModel element) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void insertAll(int index, Iterable<TModel> iterable) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  bool remove(Object? value) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  TModel removeAt(int index) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  TModel removeLast() {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void removeRange(int start, int end) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void removeWhere(bool Function(TModel element) test) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void replaceRange(int start, int end, Iterable<TModel> replacement) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void retainWhere(bool Function(TModel element) test) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void setAll(int index, Iterable<TModel> iterable) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void setRange(
    int start,
    int end,
    Iterable<TModel> iterable, [
    int skipCount = 0,
  ]) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void shuffle([Random? random]) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  void sort([int Function(TModel a, TModel b)? compare]) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  @override
  Iterable<TModel> get reversed => _value.reversed;

  @override
  bool any(bool Function(TModel element) test) => _value.any(test);

  @override
  List<E> cast<E>() => _value.cast<E>();

  @override
  bool contains(Object? element) => _value.contains(element);

  @override
  TModel elementAt(int index) => _value.elementAt(index);

  @override
  bool every(bool Function(TModel element) test) => _value.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> Function(TModel element) f) =>
      _value.expand(f);

  @override
  TModel get first => _value.first;

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  set first(TModel element) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  @override
  TModel firstWhere(bool Function(TModel element) test,
          {TModel Function()? orElse}) =>
      _value.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue,
          E Function(E previousValue, TModel element) combine) =>
      _value.fold(initialValue, combine);

  @override
  Iterable<TModel> followedBy(Iterable<TModel> other) =>
      _value.followedBy(other);

  @override
  void forEach(void Function(TModel element) f) => _value.forEach(f);

  @override
  bool get isEmpty => _value.isEmpty;

  @override
  bool get isNotEmpty => _value.isNotEmpty;

  @override
  Iterator<TModel> get iterator => _value.iterator;

  @override
  String join([String separator = ""]) => _value.join(separator);

  @override
  TModel get last => _value.last;

  /// This operation is not supported by an model collection.
  ///
  /// Model Collectionではこの操作はサポートされていません。
  @override
  set last(TModel element) {
    throw UnsupportedError("Cannot modify unmodifiable list");
  }

  @override
  TModel lastWhere(bool Function(TModel element) test,
          {TModel Function()? orElse}) =>
      _value.lastWhere(test, orElse: orElse);

  @override
  int get length => _value.length;

  @override
  Iterable<E> map<E>(E Function(TModel e) f) => _value.map(f);

  @override
  TModel reduce(TModel Function(TModel value, TModel element) combine) =>
      _value.reduce(combine);

  @override
  TModel get single => _value.single;

  @override
  TModel singleWhere(bool Function(TModel element) test,
          {TModel Function()? orElse}) =>
      _value.singleWhere(test, orElse: orElse);

  @override
  Iterable<TModel> skip(int n) => _value.skip(n);

  @override
  Iterable<TModel> skipWhile(bool Function(TModel value) test) =>
      _value.skipWhile(test);

  @override
  Iterable<TModel> take(int n) => _value.take(n);

  @override
  Iterable<TModel> takeWhile(bool Function(TModel value) test) =>
      _value.takeWhile(test);

  @override
  List<TModel> toList({bool growable = true}) =>
      _value.toList(growable: growable);

  @override
  Set<TModel> toSet() => _value.toSet();

  @override
  Iterable<TModel> where(bool Function(TModel element) test) =>
      _value.where(test);

  @override
  Iterable<E> whereType<E>() => _value.whereType<E>();

  @override
  Map<int, TModel> asMap() => _value.asMap();

  @override
  Iterable<TModel> getRange(int start, int end) => _value.getRange(start, end);

  @override
  int indexOf(TModel element, [int start = 0]) =>
      _value.indexOf(element, start);

  @override
  int indexWhere(bool Function(TModel element) test, [int start = 0]) =>
      _value.indexWhere(test, start);

  @override
  int lastIndexWhere(bool Function(TModel element) test, [int? start]) =>
      _value.lastIndexWhere(test, start);

  @override
  List<TModel> sublist(int start, [int? end]) => _value.sublist(start, end);

  @override
  int lastIndexOf(TModel element, [int? start]) =>
      _value.lastIndexOf(element, start);
}
