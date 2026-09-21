import "dart:io";
import "do_socket.dart";

/// ネイティブの接続。
Future<DurableObjectSocket> connect(Uri uri) async {
  try {
    return _Socket(await WebSocket.connect(uri.toString()));
  } on WebSocketException {
    // 例外に含まれる一回限りticket URLをログへ渡さない。
    throw StateError("WebSocket接続に失敗しました。");
  }
}

class _Socket implements DurableObjectSocket {
  _Socket(this.socket);
  final WebSocket socket;
  @override
  Stream<String> get messages => socket.cast<String>();
  @override
  Future<void> close() async {
    await socket.close();
  }
}
