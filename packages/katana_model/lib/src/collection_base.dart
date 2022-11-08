part of katana_model;

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
    extends ChangeNotifier implements List<TModel> {
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
    this.modelQuery, [
    List<TModel>? value,
  ])  : __value = value ?? [],
        assert(
          !(modelQuery.path.splitLength() <= 0 ||
              modelQuery.path.splitLength() % 2 != 1),
          "The query path hierarchy must be an odd number: ${modelQuery.path}",
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
    this.modelQuery, [
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
  final CollectionModelQuery modelQuery;

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

  /// If the number of elements is limited by [ModelQuery.limit], returns `true` if the next element can be added.
  ///
  /// If the number of elements does not change when the [next] method is executed, [canNext] will be `false`.
  ///
  /// [ModelQuery.limit]で要素数を制限されている場合、次の要素が追加可能な場合`true`を返します。
  ///
  /// [next]メソッドを実行した際に要素数が変わらなかった場合、[canNext]は`false`になります。
  bool get canNext => _canNext;
  bool _canNext = true;

  /// Reads the collection corresponding to [modelQuery].
  ///
  /// The return value is the [CollectionBase] itself, and the loaded data is available as is.
  ///
  /// Set [listenWhenPossible] to `true` to monitor changes against change monitorable databases.
  ///
  /// Once content is loaded, no new loading is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// If you wish to reload the file, use the [reload] method.
  ///
  /// [modelQuery]に対応したコレクションの読込を行います。
  ///
  /// 戻り値は[CollectionBase]そのものが返され、そのまま読込済みのデータの利用が可能になります。
  ///
  /// [listenWhenPossible]を`true`にすると変更監視可能なデータベースに対して変更を監視するように設定します。
  ///
  /// 一度読み込んだコンテンツに対しては、新しい読込は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  ///
  /// 再読み込みを行いたい場合は[reload]メソッドを利用してください。
  Future<CollectionBase<TModel>> load([
    bool listenWhenPossible = true,
  ]) async {
    if (_loadCompleter != null) {
      return loading!;
    }
    try {
      final __value = _value;
      _loadCompleter = Completer<CollectionBase<TModel>>();
      if (!loaded) {
        final res = await loadRequest(listenWhenPossible);
        if (res != null) {
          _value = await filterOnDidLoad(
            await fromMap(
              res,
              modelQuery.limit != null
                  ? (modelQuery.limit! * databaseQuery.page)
                  : null,
            ),
            listenWhenPossible,
          );
        }
        _loaded = true;
      }
      if (__value != _value) {
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
  /// Set [listenWhenPossible] to `true` to monitor changes against change monitorable databases.
  ///
  /// Unlike the [load] method, this method performs a new load each time it is executed. Therefore, do not use this method in a method that is read repeatedly, such as in the `build` method of a `widget`.
  ///
  /// [modelQuery]に対応したコレクションの再読込を行います。
  ///
  /// 戻り値は[CollectionBase]そのものが返され、そのまま読込済みのデータの利用が可能になります。
  ///
  /// [listenWhenPossible]を`true`にすると変更監視可能なデータベースに対して変更を監視するように設定します。
  ///
  /// [load]メソッドとは違い実行されるたびに新しい読込を行います。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内では利用しないでください。
  Future<CollectionBase<TModel>> reload([
    bool listenWhenPossible = true,
  ]) {
    _loaded = false;
    return load(listenWhenPossible);
  }

  /// If the number of elements is limited by [ModelQuery.limit], additional elements are loaded for the next [ModelQuery.limit] number of elements.
  ///
  /// If the number of elements does not change when executed, [canNext] will be `false`, but this method will be executed even if [canNext] is `false`.
  ///
  /// Unlike the [load] method, this method performs a new load each time it is executed. Therefore, do not use this method in a method that is read repeatedly, such as in the `build` method of a `widget`.
  ///
  /// [ModelQuery.limit]で要素数を制限されている場合、次の[ModelQuery.limit]個数分だけ追加要素を読み込みます。
  ///
  /// 実行した際に要素数が変わらなかった場合、[canNext]は`false`になりますがこのメソッドは[canNext]が`false`でも実行されます。
  ///
  /// [load]メソッドとは違い実行されるたびに新しい読込を行います。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内では利用しないでください。
  Future<CollectionBase<TModel>> next([
    bool listenWhenPossible = true,
  ]) async {
    _loaded = false;
    _databaseQuery = databaseQuery.copyWith(page: databaseQuery.page + 1);
    final _prevLength = length;
    final loaded = await load(listenWhenPossible);
    if (length == _prevLength) {
      _canNext = false;
      _databaseQuery = databaseQuery.copyWith(page: databaseQuery.page - 1);
    }
    return loaded;
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
  Future<List<TModel>> filterOnDidLoad(
    List<TModel> value, [
    bool listenWhenPossible = true,
  ]) async {
    return await Future.wait(
      value.map((e) async {
        final res = await e.filterOnDidLoad(e.value, listenWhenPossible);
        if (res != e.value) {
          e.value = res;
        }
        return e;
      }),
    );
  }

  /// Implement internal processing when [load], [reload], or [next] is executed.
  ///
  /// If [listenWhenPossible] is `true`, set the database to monitor changes against change-monitorable databases.
  ///
  /// If [Null] is returned, the value is not updated.
  ///
  /// [load]や[reload]、[next]を実行した際の内部処理を実装します。
  ///
  /// [listenWhenPossible]が`true`な場合、変更監視可能なデータベースに対して変更を監視するように設定します。
  ///
  /// [Null]が返された場合は値をアップデートしません。
  @protected
  @mustCallSuper
  Future<Map<String, DynamicMap>?> loadRequest(bool listenWhenPossible) async {
    if (subscriptions.isNotEmpty) {
      await Future.forEach<StreamSubscription>(
        subscriptions,
        (subscription) => subscription.cancel(),
      );
      subscriptions.clear();
    }
    if (listenWhenPossible && modelQuery.adapter.availableListen) {
      subscriptions.addAll(
        await modelQuery.adapter.listenCollection(databaseQuery),
      );
      return null;
    } else {
      return await modelQuery.adapter.loadCollection(databaseQuery);
    }
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
    var notify = false;
    switch (update.status) {
      case ModelUpdateNotificationStatus.added:
        if (update.newIndex == null) {
          return;
        }
        final value = create(update.id.trimQuery().trimString("?"));
        final __value = value.value;
        value.value = await value.filterOnDidLoad(
          value.fromMap(value.filterOnLoad(update.value)),
          update.listen,
        );
        if (__value != value.value) {
          value.notifyListeners();
        }
        _value.insert(update.newIndex!, value);
        notify = true;
        break;
      case ModelUpdateNotificationStatus.modified:
        if (update.oldIndex == null || update.newIndex == null) {
          return;
        }
        final found = _value.removeAt(update.oldIndex!);
        final __value = found.value;
        found.value = await found.filterOnDidLoad(
          found.fromMap(found.filterOnLoad(update.value)),
          update.listen,
        );
        if (__value != found.value) {
          found.notifyListeners();
        }
        _value.insert(update.newIndex!, found);
        if (update.newIndex != update.oldIndex) {
          notify = true;
        }
        break;
      case ModelUpdateNotificationStatus.removed:
        if (update.oldIndex == null) {
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
      value.value = value.fromMap(
        value.filterOnLoad(
          Map<String, dynamic>.from(tmp.value),
        ),
      );
      res.add(value);
    }
    return limit != null ? res.sublist(0, limit) : res;
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    super.dispose();
    _value.clear();
    modelQuery.adapter.disposeCollection(databaseQuery);
    subscriptions.forEach((subscription) => subscription.cancel());
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
  bool any(bool test(TModel element)) => _value.any(test);

  @override
  List<E> cast<E>() => _value.cast<E>();

  @override
  bool contains(Object? element) => _value.contains(element);

  @override
  TModel elementAt(int index) => _value.elementAt(index);

  @override
  bool every(bool test(TModel element)) => _value.every(test);

  @override
  Iterable<E> expand<E>(Iterable<E> f(TModel element)) => _value.expand(f);

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
  TModel firstWhere(bool test(TModel element), {TModel Function()? orElse}) =>
      _value.firstWhere(test, orElse: orElse);

  @override
  E fold<E>(E initialValue, E combine(E previousValue, TModel element)) =>
      _value.fold(initialValue, combine);

  @override
  Iterable<TModel> followedBy(Iterable<TModel> other) =>
      _value.followedBy(other);

  @override
  void forEach(void f(TModel element)) => _value.forEach(f);

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
  TModel lastWhere(bool test(TModel element), {TModel Function()? orElse}) =>
      _value.lastWhere(test, orElse: orElse);

  @override
  int get length => _value.length;

  @override
  Iterable<E> map<E>(E f(TModel e)) => _value.map(f);

  @override
  TModel reduce(TModel combine(TModel value, TModel element)) =>
      _value.reduce(combine);

  @override
  TModel get single => _value.single;

  @override
  TModel singleWhere(bool test(TModel element), {TModel Function()? orElse}) =>
      _value.singleWhere(test, orElse: orElse);

  @override
  Iterable<TModel> skip(int n) => _value.skip(n);

  @override
  Iterable<TModel> skipWhile(bool test(TModel value)) => _value.skipWhile(test);

  @override
  Iterable<TModel> take(int n) => _value.take(n);

  @override
  Iterable<TModel> takeWhile(bool test(TModel value)) => _value.takeWhile(test);

  @override
  List<TModel> toList({bool growable = true}) =>
      _value.toList(growable: growable);

  @override
  Set<TModel> toSet() => _value.toSet();

  @override
  Iterable<TModel> where(bool test(TModel element)) => _value.where(test);

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
  int indexWhere(bool test(TModel element), [int start = 0]) =>
      _value.indexWhere(test, start);

  @override
  int lastIndexWhere(bool test(TModel element), [int? start]) =>
      _value.lastIndexWhere(test, start);

  @override
  List<TModel> sublist(int start, [int? end]) => _value.sublist(start, end);

  @override
  int lastIndexOf(TModel element, [int? start]) =>
      _value.lastIndexOf(element, start);
}
