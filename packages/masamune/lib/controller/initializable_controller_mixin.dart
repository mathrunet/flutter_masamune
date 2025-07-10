part of "/masamune.dart";

/// Provides the ability to initialize data from the controller.
///
/// Describe the data initialization process in [initializeRequest].
///
/// Initialize data by calling [initialize].
///
/// コントローラーにデータを初期化する機能を提供します。
///
/// [initializeRequest]にデータの初期化処理を記述します。
///
/// [initialize]を呼び出すことでデータを初期化します。
mixin InitializableControllerMixin on ChangeNotifier {
  /// Return `true` if data is initialized.
  ///
  /// データが初期化された場合`true`を返す。
  bool get initialized => _initialized;
  bool _initialized = false;

  /// Returns [Future] if initializing is being performed.
  ///
  /// 初期化を行っている場合に[Future]を返します。
  Future<void>? get initializing => _initializingCompleter?.future;
  Completer<void>? _initializingCompleter;

  /// Describe the process for initializing data.
  ///
  /// Return initialized results.
  ///
  /// データを初期化する場合の処理を記述します。
  ///
  /// 初期化した結果を返してください。
  Future<void> initializeRequest();

  /// Execute the process of [initializeRequest] and initialize data.
  ///
  /// Once content is initialized, no new initializing is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// [initializeRequest]の処理を実行しデータを初期化します。
  ///
  /// 一度初期化したコンテンツに対しては、新しい初期化は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  Future<void> initialize() async {
    if (_initializingCompleter != null) {
      return _initializingCompleter!.future;
    }
    if (initialized) {
      return;
    }
    _initializingCompleter = Completer<void>();
    try {
      await initializeRequest();
      _initialized = true;
      _initializingCompleter?.complete();
      _initializingCompleter = null;
      notifyListeners();
    } catch (e, stacktrace) {
      _initialized = false;
      _initializingCompleter?.completeError(e, stacktrace);
      _initializingCompleter = null;
      rethrow;
    } finally {
      _initializingCompleter?.complete();
      _initializingCompleter = null;
    }
  }
}
