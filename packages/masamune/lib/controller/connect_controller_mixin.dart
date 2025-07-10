part of "/masamune.dart";

/// Provides the ability to load data into the controller.
///
/// Describe the data connecting process in [connectRequest].
///
/// Connect data by calling [connect].
///
/// コントローラーにデータを接続する機能を提供します。
///
/// [connectRequest]にデータの接続処理を記述します。
///
/// [connect]を呼び出すことでデータを接続します。
mixin ConnectControllerMixin on ChangeNotifier {
  /// Returns [Future] if connecting is being performed.
  ///
  /// 接続を行っている場合に[Future]を返します。
  Future<void>? get connecting => _connectingCompleter?.future;
  Completer<void>? _connectingCompleter;

  /// Describe the process for connecting data.
  ///
  /// Return connected results.
  ///
  /// データを接続する場合の処理を記述します。
  ///
  /// 接続した結果を返してください。
  Future<void> connectRequest();

  /// Execute the process of [connectRequest] and connect data.
  ///
  /// Once content is connected, no new connecting is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// [connectRequest]の処理を実行しデータを接続します。
  ///
  /// 一度接続したコンテンツに対しては、新しい接続は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  Future<void> connect() async {
    if (_connectingCompleter != null) {
      return _connectingCompleter!.future;
    }
    _connectingCompleter = Completer<void>();
    try {
      await connectRequest();
      _connectingCompleter?.complete();
      _connectingCompleter = null;
      notifyListeners();
    } catch (e, stacktrace) {
      _connectingCompleter?.completeError(e, stacktrace);
      _connectingCompleter = null;
      rethrow;
    } finally {
      _connectingCompleter?.complete();
      _connectingCompleter = null;
    }
  }
}
