// SDK 3.0からの既存互換性を保つ。追加依存なしでブラウザーAPIへ接続する。
// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

// Dart imports:
import "dart:async";
import "dart:html" as html;

// Project imports:
import "do_socket.dart";

/// ブラウザーの接続。
Future<DurableObjectSocket> connect(Uri uri) async {
  final socket = _Socket(html.WebSocket(uri.toString()));
  await socket.ready.future.timeout(const Duration(seconds: 15), onTimeout: () {
    unawaited(socket.close());
    throw TimeoutException("WebSocket接続がタイムアウトしました。");
  });
  return socket;
}

class _Socket implements DurableObjectSocket {
  _Socket(this.socket) {
    subscriptions.add(socket.onOpen.listen((_) {
      if (!ready.isCompleted) {
        ready.complete();
      }
    }));
    subscriptions.add(socket.onMessage.listen((event) {
      if (event.data is String) {
        controller.add(event.data as String);
      }
    }));
    subscriptions.add(socket.onError.listen((_) {
      if (!ready.isCompleted) {
        ready.completeError(StateError("WebSocket接続に失敗しました。"));
      } else {
        controller.addError(StateError("WebSocket通信に失敗しました。"));
      }
      unawaited(close());
    }));
    subscriptions.add(socket.onClose.listen((_) {
      if (!ready.isCompleted) {
        ready.completeError(StateError("WebSocket接続が終了しました。"));
      }
      unawaited(close());
    }));
  }
  final html.WebSocket socket;
  final ready = Completer<void>();
  final controller = StreamController<String>();
  final subscriptions = <StreamSubscription<dynamic>>[];
  bool closed = false;
  @override
  Stream<String> get messages => controller.stream;
  @override
  Future<void> close() async {
    if (closed) {
      return;
    }
    closed = true;
    socket.close();
    for (final subscription in subscriptions) {
      await subscription.cancel();
    }
    unawaited(controller.close());
  }
}
