part of katana_model;

/// Define a readable document model.
/// 読込可能なドキュメントモデルを定義します。
///
/// The [LoadableDocument.load] method can be used to load individual documents.
/// [LoadableDocument.load]メソッドでドキュメント単体の読込が可能です。
///
/// Reloads a document that has been loaded with the [LoadableCollection.reload] method.
/// [LoadableCollection.reload]メソッドで読み込んだドキュメントを再度読み込みます。
///
/// During loading, you can monitor the loading status with [LoadableCollection.loading]. After loading is finished, the [LoadableCollection.loaded] flag will be set to `true`.
/// 読込中は[LoadableCollection.loading]で読込状態を監視できます。読み込み終わったあとは[LoadableCollection.loaded]フラグが`true`になります。
///
/// [LoadableCollection.loadRequest] implements internal processing during data loading.
/// [LoadableCollection.loadRequest]でデータロード時の内部処理を実装します。
abstract class LoadableDocument<T> implements DocumentBase<T> {
  /// Reads documents corresponding to [query].
  /// [query]に対応したドキュメントの読込を行います。
  ///
  /// The return value is a [T] object, and the loaded data is available as is.
  /// 戻り値は[T]オブジェクトが返され、そのまま読込済みのデータの利用が可能になります。
  ///
  /// Set [listenWhenPossible] to `true` to monitor changes against change monitorable databases.
  /// [listenWhenPossible]を`true`にすると変更監視可能なデータベースに対して変更を監視するように設定します。
  ///
  /// Once content is loaded, no new loading is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  /// 一度読み込んだコンテンツに対しては、新しい読込は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  ///
  /// If you wish to reload the file, use the [reload] method.
  /// 再読み込みを行いたい場合は[reload]メソッドを利用してください。
  Future<T> load([bool listenWhenPossible = true]);

  /// Reload the document corresponding to [query].
  /// [query]に対応したドキュメントの再読込を行います。
  ///
  /// The return value is a [T] object, and the loaded data is available as is.
  /// 戻り値は[T]オブジェクトが返され、そのまま読込済みのデータの利用が可能になります。
  ///
  /// Set [listenWhenPossible] to `true` to monitor changes against change monitorable databases.
  /// [listenWhenPossible]を`true`にすると変更監視可能なデータベースに対して変更を監視するように設定します。
  ///
  /// Unlike the [load] method, this method performs a new load each time it is executed. Therefore, do not use this method in a method that is read repeatedly, such as in the `build` method of a `widget`.
  /// [load]メソッドとは違い実行されるたびに新しい読込を行います。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内では利用しないでください。
  Future<T> reload([bool listenWhenPossible = true]);

  /// Returns `true` if the data was successfully loaded by the [load] method.
  /// [load]メソッドでデータが読み込みに成功した場合`true`を返します。
  ///
  /// If this is set to `true`, the [load] method will not be loaded when executed.
  /// これが`true`になっている場合、[load]メソッドは実行しても読込は行われません。
  bool get loaded;

  /// If [load] or [reload] is executed, it waits until the loading process is completed.
  /// [load]や[reload]を実行した場合、その読込処理が終わるまで待ちます。
  ///
  /// After reading is completed, a [T] object is returned.
  /// 読込終了後、[T]オブジェクトが返されます。
  ///
  /// If neither [load] nor [reload] is in progress, [Null] is returned.
  /// [load]や[reload]を実行中でない場合、[Null]が返されます。
  Future<T>? get loading;

  /// Implement internal processing when [load] or [reload] is executed.
  /// [load]や[reload]を実行した際の内部処理を実装します。
  ///
  /// If [listenWhenPossible] is `true`, set the database to monitor changes against change-monitorable databases.
  /// [listenWhenPossible]が`true`な場合、変更監視可能なデータベースに対して変更を監視するように設定します。
  @protected
  @mustCallSuper
  Future<DynamicMap?> loadRequest(bool listenWhenPossible);

  /// Implement filters when loading data.
  /// データをロードする際のフィルターを実装します。
  ///
  /// The decoded object is passed to [value] and the original [DynamicMap] data to [rawData].
  /// [value]にデコードされたオブジェクトと[rawData]に元の[DynamicMap]のデータが渡されます。
  ///
  /// Returning a value of [T] will cause that value to be retained in the object.
  /// 戻り値に[T]の値を戻すことでその値がオブジェクト内に保持されます。
  @protected
  @mustCallSuper
  FutureOr<T> filterOnLoad(T value, DynamicMap rawData);
}

/// Define a Mixin that implements [LoadableDocument].
/// [LoadableDocument]を実装したMixinを定義します。
abstract class LoadableDocumentMixin<T> implements LoadableDocument<T> {
  bool _loaded = false;
  Completer<T>? _loadCompleter;

  @override
  bool get loaded => _loaded;

  @override
  Future<T>? get loading => _loadCompleter?.future;

  @override
  Future<T> load([bool listenWhenPossible = true]) async {
    if (loaded) {
      return value;
    }
    if (_loadCompleter != null) {
      return loading!;
    }
    try {
      _loadCompleter = Completer<T>();
      final res = await loadRequest(listenWhenPossible);
      if (res != null) {
        value = await filterOnLoad(fromMap(res), res);
      }
      _loaded = true;
      _loadCompleter?.complete(value);
      _loadCompleter = null;
    } catch (e) {
      _loadCompleter?.completeError(e);
      _loadCompleter = null;
      rethrow;
    } finally {
      _loadCompleter?.complete();
      _loadCompleter = null;
    }
    return value;
  }

  @override
  Future<T> reload([bool listenWhenPossible = true]) {
    _loaded = false;
    return load(listenWhenPossible);
  }

  @override
  @protected
  @mustCallSuper
  Future<DynamicMap?> loadRequest(bool listenWhenPossible) async {
    if (subscriptions.isNotEmpty) {
      await Future.forEach<StreamSubscription>(
        subscriptions,
        (subscription) => subscription.cancel(),
      );
      subscriptions.clear();
    }
    if (listenWhenPossible && query.adapter.availableListen) {
      subscriptions.addAll(
        await query.adapter.listenDocument(databaseQuery),
      );
      return null;
    } else {
      return await query.adapter.loadDocument(databaseQuery);
    }
  }

  @override
  @protected
  @mustCallSuper
  FutureOr<T> filterOnLoad(T value, DynamicMap rawData) => value;
}
