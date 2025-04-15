part of '/masamune_ai.dart';

/// Class for message passing between [LocalClientTransport] and [LocalServerTransport].
///
/// [LocalClientTransport]と[LocalServerTransport]間のメッセージ受け渡しを行うクラス。
class Transporter {
  /// Class for message passing between [LocalClientTransport] and [LocalServerTransport].
  ///
  /// [LocalClientTransport]と[LocalServerTransport]間のメッセージ受け渡しを行うクラス。
  Transporter();

  /// Class for message passing between [LocalClientTransport] and [LocalServerTransport].
  ///
  /// [LocalClientTransport]と[LocalServerTransport]間のメッセージ受け渡しを行うクラス。
  static final Transporter instance = Transporter();

  /// Whether they are connected or not.
  ///
  /// 接続されているかどうか。
  bool get connected => _connected;
  bool _connected = false;

  /// The stream of messages from the client to the server.
  ///
  /// クライアントからサーバーへのメッセージストリーム。
  Stream<mcp.JsonRpcMessage> get clientToServerStream =>
      _clientToServerController.stream;
  final StreamController<mcp.JsonRpcMessage> _clientToServerController =
      StreamController.broadcast();

  /// The stream of messages from the server to the client.
  ///
  /// サーバーからクライアントへのメッセージストリーム。
  Stream<mcp.JsonRpcMessage> get serverToClientStream =>
      _serverToClientController.stream;
  final StreamController<mcp.JsonRpcMessage> _serverToClientController =
      StreamController.broadcast();

  /// Send a message to the server.
  ///
  /// サーバーにメッセージを送信します。
  void sendToServer(mcp.JsonRpcMessage message) {
    if (!_connected) return;
    _clientToServerController.add(message);
  }

  /// Send a message to the client.
  ///
  /// クライアントにメッセージを送信します。
  void sendToClient(mcp.JsonRpcMessage message) {
    if (!_connected) return;
    _serverToClientController.add(message);
  }

  /// Start the connection.
  ///
  /// 接続を開始します。
  void connect() {
    _connected = true;
  }

  /// Close the connection.
  ///
  /// 接続を閉じます。両方のストリームコントローラーも閉じます。
  void close() {
    if (!_connected) return;
    _connected = false;
    _clientToServerController.close();
    _serverToClientController.close();
  }
}

/// Class for communicating with the server via local method calls.
///
/// ローカルメソッド呼び出しを介してサーバーと通信するクライアントトランスポート。
class LocalClientTransport implements Transport {
  /// Class for communicating with the server via local method calls.
  ///
  /// ローカルメソッド呼び出しを介してサーバーと通信するクライアントトランスポート。
  LocalClientTransport(this._transporter);

  final Transporter _transporter;
  StreamSubscription<mcp.JsonRpcMessage>? _subscription;

  Completer<void>? _startCompleter;
  Completer<void>? _sendCompleter;
  Completer<void>? _closeCompleter;

  /// Whether the transport is started.
  ///
  /// トランスポートが開始されているかどうか。
  bool get started => _started;
  bool _started = false;

  @override
  void Function()? onclose;

  @override
  void Function(Error error)? onerror;

  @override
  void Function(mcp.JsonRpcMessage message)? onmessage;

  @override
  String? get sessionId => null;

  @override
  Future<void> start() async {
    if (_startCompleter != null) {
      return _startCompleter?.future;
    }
    if (_started) {
      return;
    }
    _startCompleter = Completer<void>();
    try {
      _transporter.connect();

      _subscription = _transporter.serverToClientStream.listen(
        (message) {
          try {
            onmessage?.call(message);
          } catch (e, s) {
            debugPrint("Error in onmessage handler: $e\n$s");
            onerror?.call(StateError("Error in onmessage handler: $e"));
          }
        },
        onError: (error, stackTrace) {
          final Error err = (error is Error)
              ? error
              : StateError("Transport stream error: $error\n$stackTrace");
          try {
            onerror?.call(err);
          } catch (e) {
            debugPrint("Error in onerror handler: $e");
          }
          close();
        },
        onDone: () {
          debugPrint("LocalClientTransport: Server stream closed.");
          close();
        },
        cancelOnError: false,
      );
      _started = true;
      _startCompleter?.complete();
      _startCompleter = null;
    } catch (e) {
      _startCompleter?.completeError(e);
      _startCompleter = null;
      rethrow;
    } finally {
      _startCompleter?.complete();
      _startCompleter = null;
    }
  }

  @override
  Future<void> send(mcp.JsonRpcMessage message) async {
    if (!_started || !_transporter.connected) {
      throw StateError(
        "Cannot send message: LocalClientTransport is not running or connected.",
      );
    }
    if (_sendCompleter != null) {
      return _sendCompleter?.future;
    }
    _sendCompleter = Completer<void>();
    try {
      _transporter.sendToServer(message);
      _sendCompleter?.complete();
      _sendCompleter = null;
    } catch (error, stackTrace) {
      final sendError = (error is Error)
          ? error
          : StateError("Send error: $error\n$stackTrace");
      try {
        onerror?.call(sendError);
      } catch (e) {
        debugPrint("Error in onerror handler: $e");
      }
      close();
      _sendCompleter?.completeError(sendError);
      _sendCompleter = null;
      throw sendError;
    } finally {
      _sendCompleter?.complete();
      _sendCompleter = null;
    }
  }

  @override
  Future<void> close() async {
    if (_closeCompleter != null) {
      return _closeCompleter?.future;
    }
    if (!_started) {
      return;
    }
    _closeCompleter = Completer<void>();
    try {
      _started = false;
      await _subscription?.cancel();
      _subscription = null;
      onclose?.call();
      _closeCompleter?.complete();
      _closeCompleter = null;
    } catch (e) {
      _closeCompleter?.completeError(e);
      _closeCompleter = null;
      debugPrint("Error in onclose handler: $e");
    } finally {
      _closeCompleter?.complete();
      _closeCompleter = null;
    }
    debugPrint("LocalClientTransport closed.");
  }
}

/// Server transport that communicates with the client via local method calls.
///
/// ローカルメソッド呼び出しを介してクライアントと通信するサーバートランスポート。
class LocalServerTransport implements Transport {
  /// Server transport that communicates with the client via local method calls.
  ///
  /// ローカルメソッド呼び出しを介してクライアントと通信するサーバートランスポート。
  LocalServerTransport(this._transporter);

  final Transporter _transporter;
  StreamSubscription<mcp.JsonRpcMessage>? _subscription;
  Completer<void>? _startCompleter;
  Completer<void>? _sendCompleter;
  Completer<void>? _closeCompleter;

  /// Whether the transport is started.
  ///
  /// トランスポートが開始されているかどうか。
  bool get started => _started;
  bool _started = false;

  @override
  void Function()? onclose;

  @override
  void Function(Error error)? onerror;

  @override
  void Function(mcp.JsonRpcMessage message)? onmessage;

  @override
  String? get sessionId => null;

  @override
  Future<void> start() async {
    if (_startCompleter != null) {
      return _startCompleter?.future;
    }
    if (_started) {
      return;
    }
    _startCompleter = Completer<void>();
    try {
      _transporter.connect();
      _subscription = _transporter.clientToServerStream.listen(
        (message) {
          try {
            onmessage?.call(message);
          } catch (e, s) {
            debugPrint("Error in onmessage handler: $e\n$s");
            onerror?.call(StateError("Error in onmessage handler: $e"));
          }
        },
        onError: (error, stackTrace) {
          final err = (error is Error)
              ? error
              : StateError("Transport stream error: $error\n$stackTrace");
          try {
            onerror?.call(err);
          } catch (e) {
            debugPrint("Error in onerror handler: $e");
          }
          close();
        },
        onDone: () {
          debugPrint("LocalServerTransport: Client stream closed.");
          close();
        },
        cancelOnError: false,
      );
      _started = true;
      _startCompleter?.complete();
      _startCompleter = null;
    } catch (e) {
      _startCompleter?.completeError(e);
      _startCompleter = null;
      rethrow;
    } finally {
      _startCompleter?.complete();
      _startCompleter = null;
    }
  }

  @override
  Future<void> send(mcp.JsonRpcMessage message) async {
    if (!_started || !_transporter.connected) {
      throw StateError(
        "Cannot send message: LocalServerTransport is not running or connected.",
      );
    }
    if (_sendCompleter != null) {
      return _sendCompleter?.future;
    }
    _sendCompleter = Completer<void>();
    try {
      _transporter.sendToClient(message);
      _sendCompleter?.complete();
      _sendCompleter = null;
    } catch (error, stackTrace) {
      final sendError = (error is Error)
          ? error
          : StateError("Send error: $error\n$stackTrace");
      try {
        onerror?.call(sendError);
      } catch (e) {
        debugPrint("Error in onerror handler: $e");
      }
      close();
      _sendCompleter?.completeError(sendError);
      _sendCompleter = null;
      throw sendError;
    } finally {
      _sendCompleter?.complete();
      _sendCompleter = null;
    }
  }

  @override
  Future<void> close() async {
    if (_closeCompleter != null) {
      return _closeCompleter?.future;
    }
    if (!_started) {
      return;
    }
    _closeCompleter = Completer<void>();
    try {
      _started = false;
      await _subscription?.cancel();
      _subscription = null;
      _transporter.close();
      onclose?.call();
      _closeCompleter?.complete();
      _closeCompleter = null;
    } catch (e) {
      _closeCompleter?.completeError(e);
      _closeCompleter = null;
      debugPrint("Error in onclose handler: $e");
    } finally {
      _closeCompleter?.complete();
      _closeCompleter = null;
    }
    debugPrint("LocalServerTransport closed.");
  }
}
