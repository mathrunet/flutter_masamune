import "dart:async";
import "dart:io";

import "ai_debug_voice_socket.dart";

/// Opens a WebSocket with `dart:io`.
Future<AIDebugVoiceSocket> connectAIDebugVoiceSocket(Uri url) async {
  final socket = await WebSocket.connect(url.toString())
      .timeout(const Duration(seconds: 10));
  return _AIDebugIOVoiceSocket(socket);
}

class _AIDebugIOVoiceSocket implements AIDebugVoiceSocket {
  _AIDebugIOVoiceSocket(this._socket);

  final WebSocket _socket;

  @override
  Stream<Object?> get messages => _socket;

  @override
  void send(String message) {
    if (_socket.readyState == WebSocket.open) _socket.add(message);
  }

  @override
  Future<void> close() async {
    try {
      await _socket
          .close(WebSocketStatus.normalClosure)
          .timeout(const Duration(seconds: 2));
    } catch (_) {
      // Closing is best effort.
    }
  }
}
