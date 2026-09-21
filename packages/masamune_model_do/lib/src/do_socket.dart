import "do_socket_stub.dart"
    if (dart.library.io) "do_socket_io.dart"
    if (dart.library.html) "do_socket_web.dart" as platform;

/// テスト時は接続処理を差し替えられるWebSocket境界。
abstract class DurableObjectSocket {
  /// 通知と接続終了。
  Stream<String> get messages;

  /// 接続を終了する。
  Future<void> close();

  /// プラットフォーム標準WebSocketへ接続する。
  static Future<DurableObjectSocket> connect(Uri uri) => platform.connect(uri);
}
