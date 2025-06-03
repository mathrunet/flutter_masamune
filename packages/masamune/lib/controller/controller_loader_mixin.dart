part of "/masamune.dart";

/// Provides the ability to load data into the controller.
///
/// Describe the data loading process in [loadRequest].
///
/// Load data by calling [load]. Reload data by calling [reload].
///
/// コントローラーにデータをロードする機能を提供します。
///
/// [loadRequest]にデータのロード処理を記述します。
///
/// [load]を呼び出すことでデータをロードします。[reload]でデータを再ロードします。
mixin ControllerLoaderMixin<T> on ChangeNotifier
    implements ValueListenable<T?> {
  /// Return `true` if data is loaded.
  ///
  /// データがロードされた場合`true`を返す。
  bool get loaded => _loaded;
  bool _loaded = false;

  /// Returns [Future] if loading is being performed.
  ///
  /// ロードを行っている場合に[Future]を返します。
  Future<void>? get loading => _loadingCompleter?.future;
  Completer<void>? _loadingCompleter;

  @override
  T? get value => _value;
  T? _value;

  /// Describe the process for loading data.
  ///
  /// Return loaded results.
  ///
  /// データをロードする場合の処理を記述します。
  ///
  /// ロードした結果を返してください。
  Future<T?> loadRequest();

  /// Execute the process of [loadRequest] and load data.
  ///
  /// Once content is loaded, no new loading is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// If you wish to reload the file, use the [reload] method.
  ///
  /// [loadRequest]の処理を実行しデータをロードします。
  ///
  /// 一度読み込んだコンテンツに対しては、新しい読込は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  ///
  /// 再読み込みを行いたい場合は[reload]メソッドを利用してください。
  Future<void> load() async {
    if (_loadingCompleter != null) {
      return _loadingCompleter!.future;
    }
    if (loaded) {
      return;
    }
    _loadingCompleter = Completer<void>();
    try {
      _value = await loadRequest();
      _loaded = true;
      _loadingCompleter?.complete();
      _loadingCompleter = null;
      notifyListeners();
    } catch (e, stacktrace) {
      _loaded = false;
      _loadingCompleter?.completeError(e, stacktrace);
      _loadingCompleter = null;
      rethrow;
    } finally {
      _loadingCompleter?.complete();
      _loadingCompleter = null;
    }
  }

  /// Execute the process of [loadRequest] and load data.
  ///
  /// Unlike the [load] method, this method performs a new load each time it is executed. Therefore, do not use this method in a method that is read repeatedly, such as in the `build` method of a `widget`.
  ///
  /// [loadRequest]の処理を実行しデータをロードします。
  ///
  /// [load]メソッドとは違い実行されるたびに新しい読込を行います。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内では利用しないでください。
  Future<void> reload() async {
    _loaded = false;
    return load();
  }
}
