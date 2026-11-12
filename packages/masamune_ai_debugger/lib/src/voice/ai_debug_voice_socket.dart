import "dart:async";

/// A text WebSocket used by the AI debugger voice input.
///
/// AIデバッガーの音声入力が使用するテキストのWebSocket。
abstract class AIDebugVoiceSocket {
  /// Frames received from the server.
  ///
  /// サーバーから受信したフレーム。
  Stream<Object?> get messages;

  /// Sends a text frame.
  ///
  /// テキストフレームを送信します。
  void send(String message);

  /// Closes the connection.
  ///
  /// 接続を閉じます。
  Future<void> close();
}

/// Opens an [AIDebugVoiceSocket] for [url].
///
/// [url]への[AIDebugVoiceSocket]を開きます。
typedef AIDebugVoiceSocketConnector = Future<AIDebugVoiceSocket> Function(
  Uri url,
);
