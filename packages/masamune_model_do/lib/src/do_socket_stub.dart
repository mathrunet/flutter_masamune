// Project imports:
import "do_socket.dart";

/// 非対応環境の接続。
Future<DurableObjectSocket> connect(Uri uri) =>
    Future.error(UnsupportedError("WebSocket非対応環境です。"));
