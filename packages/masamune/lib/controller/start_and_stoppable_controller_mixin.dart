part of "/masamune.dart";

/// Provides the controller with the functionality to start and stop data.
///
/// The data start process is described in `[startRequest]`.
///
/// Call `[start]` to start the data.
///
/// The data stop process is described in `[stopRequest]`.
///
/// Call `[stop]` to stop the data.
///
/// コントローラーにデータを開始して停止する機能を提供します。
///
/// [startRequest]にデータの開始処理を記述します。
///
/// [start]を呼び出すことでデータを開始します。
///
/// [stopRequest]にデータの停止処理を記述します。
///
/// [stop]を呼び出すことでデータを停止します。
mixin StartAndStoppableControllerMixin on ChangeNotifier {
  /// Returns [Future] if active.
  ///
  /// アクティブな場合に[Future]を返します。
  Future<void>? get active => _activeCompleter?.future;
  Completer<void>? _activeCompleter;

  /// Returns [Future] if starting.
  ///
  /// 開始中の場合に[Future]を返します。
  Future<void>? get starting => _startingCompleter?.future;
  Completer<void>? _startingCompleter;

  /// Returns [Future] if stopping.
  ///
  /// 停止中の場合に[Future]を返します。
  Future<void>? get stopping => _stoppingCompleter?.future;
  Completer<void>? _stoppingCompleter;

  /// Describe the process for starting data.
  ///
  /// Return started results.
  ///
  /// データを開始する場合の処理を記述します。
  ///
  /// 開始した結果を返してください。
  Future<void> startRequest();

  /// Describe the process for stopping data.
  ///
  /// Return stopped results.
  ///
  /// データを停止する場合の処理を記述します。
  ///
  /// 停止した結果を返してください。
  Future<void> stopRequest();

  /// Execute the process of [startRequest] and start data.
  ///
  /// Once content is started, no new starting is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// [startRequest]の処理を実行しデータを開始します。
  ///
  /// 一度開始したコンテンツに対しては、新しい開始は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  Future<void> start() async {
    if (_startingCompleter != null) {
      return _startingCompleter!.future;
    }
    if (_activeCompleter != null) {
      return;
    }
    _activeCompleter = Completer<void>();
    _startingCompleter = Completer<void>();
    try {
      await startRequest();
      _startingCompleter?.complete();
      _startingCompleter = null;
      notifyListeners();
    } catch (e, stacktrace) {
      _activeCompleter?.completeError(e, stacktrace);
      _activeCompleter = null;
      _startingCompleter?.completeError(e, stacktrace);
      _startingCompleter = null;
      rethrow;
    } finally {
      _startingCompleter?.complete();
      _startingCompleter = null;
    }
  }

  /// Execute the process of [stopRequest] and stop data.
  ///
  /// Once content is stopped, no new stopping is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// [stopRequest]の処理を実行しデータを停止します。
  ///
  /// 一度停止したコンテンツに対しては、新しい停止は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  Future<void> stop() async {
    if (_stoppingCompleter != null) {
      return _stoppingCompleter!.future;
    }
    if (_activeCompleter == null) {
      return;
    }
    _stoppingCompleter = Completer<void>();
    try {
      await stopRequest();
      _activeCompleter?.complete();
      _activeCompleter = null;
      _stoppingCompleter?.complete();
      _stoppingCompleter = null;
      notifyListeners();
    } catch (e, stacktrace) {
      _activeCompleter?.completeError(e, stacktrace);
      _activeCompleter = null;
      _stoppingCompleter?.completeError(e, stacktrace);
      _stoppingCompleter = null;
      rethrow;
    } finally {
      _activeCompleter?.complete();
      _activeCompleter = null;
      _stoppingCompleter?.complete();
      _stoppingCompleter = null;
    }
  }
}
