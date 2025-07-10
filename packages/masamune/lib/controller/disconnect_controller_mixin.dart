part of "/masamune.dart";

/// Provides the ability to load data into the controller.
///
/// Describe the data disconnecting process in [disconnectRequest].
///
/// Disconnect data by calling [disconnect].
///
/// コントローラーにデータを切断する機能を提供します。
///
/// [disconnectRequest]にデータの切断処理を記述します。
///
/// [disconnect]を呼び出すことでデータを切断します。
mixin DisconnectControllerMixin on ChangeNotifier {
  /// Returns [Future] if disconnecting is being performed.
  ///
  /// 切断を行っている場合に[Future]を返します。
  Future<void>? get disconnecting => _disconnectingCompleter?.future;
  Completer<void>? _disconnectingCompleter;

  /// Describe the process for disconnecting data.
  ///
  /// Return disconnected results.
  ///
  /// データを切断する場合の処理を記述します。
  ///
  /// 切断した結果を返してください。
  Future<void> disconnectRequest();

  /// Execute the process of [disconnectRequest] and disconnect data.
  ///
  /// Once content is disconnected, no new disconnecting is performed. Therefore, it can be used in a method that is read any number of times, such as in the `build` method of a `widget`.
  ///
  /// [disconnectRequest]の処理を実行しデータを切断します。
  ///
  /// 一度切断したコンテンツに対しては、新しい切断は行われません。そのため`Widget`の`build`メソッド内など何度でも読み出されるメソッド内でも利用可能です。
  Future<void> disconnect() async {
    if (_disconnectingCompleter != null) {
      return _disconnectingCompleter!.future;
    }
    _disconnectingCompleter = Completer<void>();
    try {
      await disconnectRequest();
      _disconnectingCompleter?.complete();
      _disconnectingCompleter = null;
      notifyListeners();
    } catch (e, stacktrace) {
      _disconnectingCompleter?.completeError(e, stacktrace);
      _disconnectingCompleter = null;
      rethrow;
    } finally {
      _disconnectingCompleter?.complete();
      _disconnectingCompleter = null;
    }
  }
}
