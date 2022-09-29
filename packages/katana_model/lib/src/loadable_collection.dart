part of katana_model;

/// Define a readable collection model.
/// 読込可能なコレクションモデルを定義します。
///
/// The entire collection can be loaded with the [LoadableCollection.load] method.
/// [LoadableCollection.load]メソッドでコレクション全体の読込が可能です。
///
/// Reloads a collection that has been loaded with the [LoadableCollection.reload] method.
/// [LoadableCollection.reload]メソッドで読み込んだコレクションを再度読み込みます。
///
/// The [LoadableCollection.next] method additionally loads the next element in the collection whose number of elements is limited by [ModelQuery.limit].
/// [LoadableCollection.next]メソッドで[ModelQuery.limit]で要素数を制限したコレクションの次の要素を追加で読み込みます。
///
/// During loading, you can monitor the loading status with [LoadableCollection.loading]. After loading is finished, the [LoadableCollection.loaded] flag will be set to `true`.
/// 読込中は[LoadableCollection.loading]で読込状態を監視できます。読み込み終わったあとは[LoadableCollection.loaded]フラグが`true`になります。
abstract class LoadableCollection<TModel extends DocumentBase<T>, T>
    implements CollectionBase<TModel, T> {
  /// Reads the collection corresponding to [query].
  /// [query]に対応したコレクションの読込を行います。
  ///
  /// The return value is the [CollectionBase] itself, and the loaded data is available as is.
  /// 戻り値は[CollectionBase]そのものが返され、そのまま読込済みのデータの利用が可能になります。
  ///
  /// Set [listenWhenPossible] to `true` to monitor changes against change monitorable databases.
  /// [listenWhenPossible]を`true`にすると変更監視可能なデータベースに対して変更を監視するように設定します。
  /// Once content is loaded, no new loading is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  /// 一度読み込んだコンテンツに対しては、新しい読込は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  ///
  /// If you wish to reload the file, use the [reload] method.
  /// 再読み込みを行いたい場合は[reload]メソッドを利用してください。
  Future<CollectionBase<TModel, T>> load([bool listenWhenPossible = true]);

  /// Reload the collection corresponding to [query].
  /// [query]に対応したコレクションの再読込を行います。
  ///
  /// The return value is the [CollectionBase] itself, and the loaded data is available as is.
  /// 戻り値は[CollectionBase]そのものが返され、そのまま読込済みのデータの利用が可能になります。
  ///
  /// Set [listenWhenPossible] to `true` to monitor changes against change monitorable databases.
  /// [listenWhenPossible]を`true`にすると変更監視可能なデータベースに対して変更を監視するように設定します。
  ///
  /// Unlike the [load] method, this method performs a new load each time it is executed. Therefore, do not use this method in a method that is read repeatedly, such as in the `build` method of a `widget`.
  /// [load]メソッドとは違い実行されるたびに新しい読込を行います。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内では利用しないでください。
  Future<CollectionBase<TModel, T>> reload([
    bool listenWhenPossible = true,
  ]);

  /// If the number of elements is limited by [ModelQuery.limit], additional elements are loaded for the next [ModelQuery.limit] number of elements.
  /// [ModelQuery.limit]で要素数を制限されている場合、次の[ModelQuery.limit]個数分だけ追加要素を読み込みます。
  ///
  /// If the number of elements does not change when executed, [canNext] will be `false`, but this method will be executed even if [canNext] is `false`.
  /// 実行した際に要素数が変わらなかった場合、[canNext]は`false`になりますがこのメソッドは[canNext]が`false`でも実行されます。
  ///
  /// Unlike the [load] method, this method performs a new load each time it is executed. Therefore, do not use this method in a method that is read repeatedly, such as in the `build` method of a `widget`.
  /// [load]メソッドとは違い実行されるたびに新しい読込を行います。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内では利用しないでください。
  Future<CollectionBase<TModel, T>> next([bool listenWhenPossible = true]);

  /// If the number of elements is limited by [ModelQuery.limit], returns `true` if the next element can be added.
  /// [ModelQuery.limit]で要素数を制限されている場合、次の要素が追加可能な場合`true`を返します。
  ///
  /// If the number of elements does not change when the [next] method is executed, [canNext] will be `false`.
  /// [next]メソッドを実行した際に要素数が変わらなかった場合、[canNext]は`false`になります。
  bool get canNext;

  /// Returns `true` if the data was successfully loaded by the [load] method.
  /// [load]メソッドでデータが読み込みに成功した場合`true`を返します。
  ///
  /// If this is set to `true`, the [load] method will not be loaded when executed.
  /// これが`true`になっている場合、[load]メソッドは実行しても読込は行われません。
  bool get loaded;

  /// If [load], [reload] or [next] is executed, it waits until the reading process is completed.
  /// [load]や[reload]、[next]を実行した場合、その読込処理が終わるまで待ちます。
  ///
  /// After reading, [CollectionBase] itself is returned.
  /// 読込終了後、[CollectionBase]自身が返されます。
  ///
  /// If [load], [reload] or [next] is not in progress, [Null] is returned.
  /// [load]や[reload]、[next]を実行中でない場合、[Null]が返されます。
  Future<CollectionBase<TModel, T>>? get loading;

  /// Implement internal processing when [load], [reload], or [next] is executed.
  /// [load]や[reload]、[next]を実行した際の内部処理を実装します。
  ///
  /// If [listenWhenPossible] is `true`, set the database to monitor changes against change-monitorable databases.
  /// [listenWhenPossible]が`true`な場合、変更監視可能なデータベースに対して変更を監視するように設定します。
  ///
  /// If [Null] is returned, the value is not updated.
  /// [Null]が返された場合は値をアップデートしません。
  @protected
  @mustCallSuper
  Future<Map<String, DynamicMap>?> loadRequest(bool listenWhenPossible);
}

/// [LoadableCollection]を実装したMixinを定義します。
abstract class LoadableCollectionMixin<TModel extends DocumentBase<T>, T>
    implements LoadableCollection<TModel, T> {
  bool _loaded = false;
  bool _canNext = true;
  Completer<CollectionBase<TModel, T>>? _loadCompleter;

  @override
  bool get loaded => _loaded;

  @override
  Future<CollectionBase<TModel, T>>? get loading => _loadCompleter?.future;

  @override
  Future<CollectionBase<TModel, T>> load([
    bool listenWhenPossible = true,
  ]) async {
    if (loaded) {
      return this;
    }
    if (_loadCompleter != null) {
      return loading!;
    }
    try {
      _loadCompleter = Completer<CollectionBase<TModel, T>>();
      final res = await loadRequest(listenWhenPossible);
      if (res != null) {
        _value = fromMap(
          res,
          query.limit != null ? (query.limit! * databaseQuery.page) : null,
        );
      }
      _loaded = true;
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

  @override
  Future<CollectionBase<TModel, T>> reload([
    bool listenWhenPossible = true,
  ]) {
    _loaded = false;
    return load(listenWhenPossible);
  }

  @override
  bool get canNext => _canNext;

  @override
  Future<CollectionBase<TModel, T>> next([
    bool listenWhenPossible = true,
  ]) async {
    _loaded = false;
    _databaseQuery = databaseQuery.pageWith(page: databaseQuery.page + 1);
    final _prevLength = length;
    final loaded = await load(listenWhenPossible);
    if (length == _prevLength) {
      _canNext = false;
      _databaseQuery = databaseQuery.pageWith(page: databaseQuery.page - 1);
    }
    return loaded;
  }

  @override
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
    if (listenWhenPossible && query.adapter.availableListen) {
      subscriptions.addAll(
        await query.adapter.listenCollection(databaseQuery),
      );
      return null;
    } else {
      return await query.adapter.loadCollection(databaseQuery);
    }
  }
}
