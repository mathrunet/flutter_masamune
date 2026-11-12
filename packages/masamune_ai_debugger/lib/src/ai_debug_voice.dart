part of '/masamune_ai_debugger.dart';

/// Whether the real-time voice input is compiled into this build.
///
/// Enable it with `--dart-define=MASAMUNE_AI_DEBUGGER_VOICE=true`. When this is
/// `false`, no recording or WebSocket code is reachable and the compiler
/// removes it from the build.
///
/// リアルタイム音声入力がこのビルドに組み込まれているかどうか。
/// `--dart-define=MASAMUNE_AI_DEBUGGER_VOICE=true`で有効になります。
const bool kAIDebugVoiceEnabled = bool.fromEnvironment(
  "MASAMUNE_AI_DEBUGGER_VOICE",
);

/// Semantics label of the voice input button. Shared with the Whisker
/// implementation so automation can target both.
///
/// 音声入力ボタンのセマンティクスラベル。Whisker版と共通です。
const String kAIDebugVoiceInputLabel = "AI debugger voice input";

/// Issues a single-use real-time speech token for the current run.
///
/// 現在の実行に対してリアルタイム音声認識用の使い捨てトークンを発行します。
typedef AIDebugSpeechTokenCallback = Future<AIDebugSpeechToken> Function(
  AIDebugController controller,
);

/// Connection information for ElevenLabs Scribe real-time transcription
/// returned by `POST /api/app-debug/runs/{runId}/speech-token`.
///
/// `POST /api/app-debug/runs/{runId}/speech-token`が返す、
/// ElevenLabs Scribeのリアルタイム文字起こしの接続情報。
@immutable
class AIDebugSpeechToken {
  /// Creates speech token information.
  ///
  /// 音声認識トークンの情報を作成します。
  const AIDebugSpeechToken({
    required this.url,
    this.modelId,
    this.sampleRate = 16000,
    this.keytermLibrary = const [],
    this.expiresAt,
  });

  /// Parses the JSON body returned by SamuraiAI.
  ///
  /// SamuraiAIが返したJSONを解析します。
  factory AIDebugSpeechToken.fromJson(Map<String, Object?> json) {
    final url = json["url"];
    if (url is! String || url.isEmpty) {
      throw const FormatException("The speech token response has no url.");
    }
    final sampleRate = json["sampleRate"];
    final library = json["keytermLibrary"];
    final expiresAt = json["expiresAt"];
    return AIDebugSpeechToken(
      url: url,
      modelId: json["modelId"]?.toString(),
      sampleRate:
          sampleRate is num && sampleRate > 0 ? sampleRate.toInt() : 16000,
      keytermLibrary: library is List
          ? List.unmodifiable(
              library.whereType<String>().where((term) => term.isNotEmpty),
            )
          : const [],
      expiresAt: expiresAt is String ? DateTime.tryParse(expiresAt) : null,
    );
  }

  /// WebSocket URL including the single-use token.
  ///
  /// 使い捨てトークンを含むWebSocketのURL。
  final String url;

  /// Transcription model identifier.
  ///
  /// 文字起こしのモデルID。
  final String? modelId;

  /// Sample rate of the PCM16 audio to send.
  ///
  /// 送信するPCM16音声のサンプリングレート。
  final int sampleRate;

  /// Key terms attached to the first audio chunk only.
  ///
  /// 最初の音声チャンクだけに付ける用語。
  final List<String> keytermLibrary;

  /// Expiration time of the token.
  ///
  /// トークンの有効期限。
  final DateTime? expiresAt;
}

/// Kind of a message received from the transcription server.
///
/// 文字起こしサーバーから受信したメッセージの種類。
enum AIDebugVoiceMessageType {
  /// The session started.
  started,

  /// An interim transcript.
  partial,

  /// A committed transcript.
  committed,

  /// An error reported by the server.
  error,

  /// Any other message.
  other,
}

/// A parsed message received from the transcription server.
///
/// 文字起こしサーバーから受信したメッセージの解析結果。
@immutable
class AIDebugVoiceMessage {
  /// Creates a parsed message.
  ///
  /// 解析済みのメッセージを作成します。
  const AIDebugVoiceMessage(this.type, {this.text = "", this.code});

  /// Message kind.
  ///
  /// メッセージの種類。
  final AIDebugVoiceMessageType type;

  /// Transcript or error text.
  ///
  /// 文字起こしまたはエラーの文字列。
  final String text;

  /// Server `message_type` for errors.
  ///
  /// エラー時のサーバーの`message_type`。
  final String? code;
}

/// Error raised by the voice input.
///
/// 音声入力で発生したエラー。
class AIDebugVoiceException implements Exception {
  /// Creates a voice input error.
  ///
  /// 音声入力のエラーを作成します。
  const AIDebugVoiceException(this.code, this.message);

  /// Error code such as `permission_denied` or a server `message_type`.
  ///
  /// `permission_denied`やサーバーの`message_type`などのエラーコード。
  final String code;

  /// Human-readable message.
  ///
  /// 表示用のメッセージ。
  final String message;

  @override
  String toString() => "AIDebugVoiceException($code): $message";
}

/// Message format of ElevenLabs Scribe real-time transcription and the rule
/// for inserting committed text.
///
/// ElevenLabs Scribeのリアルタイム文字起こしのメッセージ形式と、
/// 確定文を挿入する規則。
abstract final class AIDebugVoiceProtocol {
  /// Length of one audio chunk.
  ///
  /// 1つの音声チャンクの長さ。
  static const Duration chunkDuration = Duration(milliseconds: 100);

  /// How long to wait for the final committed transcript after stopping.
  ///
  /// 停止後に最後の確定文を待つ時間。
  static const Duration stopTimeout = Duration(seconds: 3);

  /// Server message types treated as errors.
  ///
  /// エラーとして扱うサーバーのメッセージ種別。
  static const Set<String> errorTypes = {
    "error",
    "auth_error",
    "quota_exceeded",
    "commit_throttled",
    "unaccepted_terms",
    "rate_limited",
    "queue_overflow",
    "resource_exhausted",
    "session_time_limit_exceeded",
    "input_error",
    "invalid_request",
    "chunk_size_exceeded",
    "insufficient_audio_activity",
    "transcriber_error",
  };

  /// Number of PCM16 bytes in one chunk at [sampleRate].
  ///
  /// [sampleRate]での1チャンクあたりのPCM16のバイト数。
  static int chunkBytes(int sampleRate) =>
      sampleRate * 2 * chunkDuration.inMilliseconds ~/ 1000;

  /// Builds an `input_audio_chunk` message for PCM16 LE mono [pcm].
  ///
  /// [keytermLibrary] is added only when it is non-empty; pass it for the
  /// first chunk only.
  ///
  /// PCM16 LEモノラルの[pcm]から`input_audio_chunk`メッセージを作成します。
  static Map<String, Object?> buildAudioChunk(
    List<int> pcm, {
    required int sampleRate,
    bool commit = false,
    List<String>? keytermLibrary,
  }) =>
      {
        "message_type": "input_audio_chunk",
        "audio_base_64": base64Encode(pcm),
        "commit": commit,
        "sample_rate": sampleRate,
        if (keytermLibrary != null && keytermLibrary.isNotEmpty)
          "keyterm_library": keytermLibrary,
      };

  /// Parses a frame received from the server.
  ///
  /// サーバーから受信したフレームを解析します。
  static AIDebugVoiceMessage parse(Object? raw) {
    Object? message;
    try {
      message = raw is String ? jsonDecode(raw) : raw;
    } catch (_) {
      return const AIDebugVoiceMessage(AIDebugVoiceMessageType.other);
    }
    if (message is! Map) {
      return const AIDebugVoiceMessage(AIDebugVoiceMessageType.other);
    }
    final kind = message["message_type"]?.toString();
    final text = message["text"]?.toString() ?? "";
    switch (kind) {
      case "session_started":
        return const AIDebugVoiceMessage(AIDebugVoiceMessageType.started);
      case "partial_transcript":
        return AIDebugVoiceMessage(
          AIDebugVoiceMessageType.partial,
          text: text,
        );
      case "committed_transcript":
      case "committed_transcript_with_timestamps":
        return AIDebugVoiceMessage(
          AIDebugVoiceMessageType.committed,
          text: text,
        );
    }
    if (kind != null && errorTypes.contains(kind)) {
      final detail = message["error"] ?? message["message"];
      return AIDebugVoiceMessage(
        AIDebugVoiceMessageType.error,
        text: detail?.toString() ?? kind,
        code: kind,
      );
    }
    return const AIDebugVoiceMessage(AIDebugVoiceMessageType.other);
  }

  static final RegExp _asciiWord = RegExp(r"[A-Za-z0-9_]");

  static bool _isAsciiWord(String value, int index) =>
      index >= 0 && index < value.length && _asciiWord.hasMatch(value[index]);

  /// Inserts [text] into [value] replacing `[start, end)`.
  ///
  /// A half-width space is added only where ASCII letters or digits would
  /// touch (`"use"` + `"Effect"` becomes `"use Effect"`, while Japanese text
  /// is joined as is). Out-of-range positions fall back to the end.
  /// Returns the new value and the cursor position after the insertion.
  ///
  /// [value]の`[start, end)`を[text]で置き換えます。英数字どうしが隣り合う
  /// 場合だけ半角スペースを挟みます。
  static ({String value, int cursor}) insertTranscript(
    String value,
    String text, {
    int? start,
    int? end,
  }) {
    final piece = text.trim();
    final from = (start == null || start < 0 ? value.length : start)
        .clamp(0, value.length);
    final to = (end == null || end < 0 ? from : end).clamp(from, value.length);
    if (piece.isEmpty) return (value: value, cursor: to);
    final before = value.substring(0, from);
    final after = value.substring(to);
    final lead =
        _isAsciiWord(before, before.length - 1) && _isAsciiWord(piece, 0)
            ? " "
            : "";
    final trail =
        _isAsciiWord(piece, piece.length - 1) && _isAsciiWord(after, 0)
            ? " "
            : "";
    final inserted = "$lead$piece$trail";
    return (
      value: "$before$inserted$after",
      cursor: before.length + inserted.length,
    );
  }
}

/// Microphone audio delivered as PCM16 LE mono chunks.
///
/// PCM16 LEモノラルのチャンクとして届くマイク音声。
abstract class AIDebugVoiceAudioSource {
  /// Audio bytes captured after [start].
  ///
  /// [start]以降に取得した音声のバイト列。
  Stream<Uint8List> get chunks;

  /// Requests the microphone permission and starts capturing.
  ///
  /// マイクの権限を要求して取得を開始します。
  Future<void> start();

  /// Stops capturing.
  ///
  /// 取得を停止します。
  Future<void> stop();
}

class _AIDebugMethodChannelVoiceAudioSource implements AIDebugVoiceAudioSource {
  static const _methods = MethodChannel("masamune_ai_debugger/voice");
  static const _events = EventChannel("masamune_ai_debugger/voice/audio");

  @override
  Stream<Uint8List> get chunks => _events.receiveBroadcastStream().map(
        (event) => event is Uint8List
            ? event
            : Uint8List.fromList(List<int>.from(event as List)),
      );

  @override
  Future<void> start() async {
    try {
      await _methods.invokeMethod<bool>("start");
    } on PlatformException catch (error) {
      throw AIDebugVoiceException(error.code, error.message ?? error.code);
    } on MissingPluginException {
      throw const AIDebugVoiceException(
        "unavailable",
        "The masamune_ai_debugger native plugin is not registered.",
      );
    }
  }

  @override
  Future<void> stop() async {
    try {
      await _methods.invokeMethod<void>("stop");
    } on MissingPluginException {
      // Nothing was started.
    }
  }
}

/// State of an [AIDebugVoiceSession].
///
/// [AIDebugVoiceSession]の状態。
enum AIDebugVoiceState {
  /// Not running.
  idle,

  /// Requesting permission, a token, or the connection.
  connecting,

  /// Capturing and streaming audio.
  recording,

  /// Waiting for the final committed transcript.
  stopping,
}

/// One real-time voice input from the microphone button to the last
/// committed transcript.
///
/// The audio is captured natively and streamed straight to ElevenLabs Scribe
/// with a single-use token issued by SamuraiAI; SamuraiAI never relays audio.
///
/// マイクボタンの押下から最後の確定文までの1回分のリアルタイム音声入力。
class AIDebugVoiceSession {
  /// Creates a voice input session for [controller].
  ///
  /// [controller]用の音声入力セッションを作成します。
  AIDebugVoiceSession({
    required this.controller,
    this.onPartial,
    this.onCommitted,
    this.onError,
    this.onStateChanged,
    AIDebugVoiceAudioSource? audioSource,
    AIDebugVoiceSocketConnector? connector,
  })  : _audioSource = audioSource ??
            debugAudioSourceOverride ??
            _AIDebugMethodChannelVoiceAudioSource(),
        _connector =
            connector ?? debugConnectorOverride ?? connectAIDebugVoiceSocket;

  /// Replaces the native audio source in tests.
  @visibleForTesting
  static AIDebugVoiceAudioSource? debugAudioSourceOverride;

  /// Replaces the WebSocket connector in tests.
  @visibleForTesting
  static AIDebugVoiceSocketConnector? debugConnectorOverride;

  /// Whether this build and platform can use the voice input.
  ///
  /// Always `false` unless [kAIDebugVoiceEnabled] is `true`. Web and desktop
  /// platforms are not supported.
  ///
  /// このビルドとプラットフォームで音声入力を使えるかどうか。
  static bool get isSupported =>
      kAIDebugVoiceEnabled &&
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  /// Controller used to issue the speech token.
  ///
  /// 音声認識トークンの発行に使うコントローラー。
  final AIDebugController controller;

  /// Called with the current interim transcript, or an empty string.
  ///
  /// 途中の文字起こし（無い場合は空文字）で呼ばれます。
  final void Function(String text)? onPartial;

  /// Called with each committed transcript.
  ///
  /// 確定した文字起こしごとに呼ばれます。
  final void Function(String text)? onCommitted;

  /// Called once when the session fails.
  ///
  /// セッションが失敗したときに1回呼ばれます。
  final void Function(Object error)? onError;

  /// Called when [state] changes.
  ///
  /// [state]が変わったときに呼ばれます。
  final void Function(AIDebugVoiceState state)? onStateChanged;

  final AIDebugVoiceAudioSource _audioSource;
  final AIDebugVoiceSocketConnector _connector;

  AIDebugVoiceState _state = AIDebugVoiceState.idle;
  AIDebugSpeechToken? _token;
  AIDebugVoiceSocket? _socket;
  StreamSubscription<Uint8List>? _audioSubscription;
  StreamSubscription<Object?>? _socketSubscription;
  final BytesBuilder _pending = BytesBuilder(copy: false);
  bool _audioStarted = false;
  bool _firstChunk = true;
  bool _closed = false;
  bool _started = false;
  Completer<void>? _stopCompleter;
  Timer? _stopTimer;

  /// Current state.
  ///
  /// 現在の状態。
  AIDebugVoiceState get state => _state;

  int get _sampleRate => _token?.sampleRate ?? 16000;

  void _setState(AIDebugVoiceState value) {
    if (_state == value) return;
    _state = value;
    onStateChanged?.call(value);
  }

  /// Starts capturing and transcribing. Errors are reported to [onError].
  ///
  /// The microphone starts before the connection so that speech during the
  /// connection is buffered and sent once connected.
  ///
  /// 取得と文字起こしを開始します。エラーは[onError]へ通知されます。
  Future<void> start() async {
    if (_started) return;
    _started = true;
    _setState(AIDebugVoiceState.connecting);
    try {
      _audioSubscription = _audioSource.chunks.listen(
        _onAudio,
        onError: (Object error) => _fail(error),
      );
      _audioStarted = true;
      await _audioSource.start();
      if (_closed) return _release();
      final token = await controller.requestSpeechToken();
      _token = token;
      if (_closed) return _release();
      final socket = await _connector(Uri.parse(token.url));
      _socket = socket;
      if (_closed) return _release();
      _socketSubscription = socket.messages.listen(
        _onMessage,
        onError: (Object error) => _fail(
          AIDebugVoiceException("connection", error.toString()),
        ),
        onDone: () {
          if (!_closed && _stopCompleter == null) {
            _fail(const AIDebugVoiceException(
              "connection_closed",
              "The transcription server closed the connection.",
            ));
          } else {
            _teardown();
          }
        },
        cancelOnError: true,
      );
      _setState(AIDebugVoiceState.recording);
      _flush();
    } catch (error) {
      _fail(error);
    }
  }

  /// Stops capturing, commits the remaining audio, and waits up to
  /// [AIDebugVoiceProtocol.stopTimeout] for the final transcript.
  ///
  /// 取得を止めて残りの音声を確定させ、最後の確定文を待ちます。
  Future<void> stop() async {
    if (_closed) return;
    final socket = _socket;
    if (_state != AIDebugVoiceState.recording || socket == null) {
      _teardown();
      return;
    }
    final existing = _stopCompleter;
    if (existing != null) return existing.future;
    final completer = Completer<void>();
    _stopCompleter = completer;
    _setState(AIDebugVoiceState.stopping);
    _stopTimer = Timer(AIDebugVoiceProtocol.stopTimeout, _teardown);
    try {
      await _stopAudio();
      // Let audio events that were already queued arrive before committing.
      await Future<void>.delayed(Duration.zero);
    } catch (_) {
      // Committing proceeds even if the native side failed to stop.
    }
    if (_closed) return completer.future;
    final size = AIDebugVoiceProtocol.chunkBytes(_sampleRate);
    final rest = _pending.takeBytes();
    var offset = 0;
    while (rest.length - offset > size) {
      _sendChunk(Uint8List.sublistView(rest, offset, offset + size));
      offset += size;
    }
    _sendChunk(
      offset < rest.length
          ? Uint8List.sublistView(rest, offset)
          : Uint8List(size),
      commit: true,
    );
    return completer.future;
  }

  /// Stops immediately without waiting for the final transcript.
  ///
  /// 最後の確定文を待たずにすぐ停止します。
  void cancel() => _teardown();

  void _onAudio(Uint8List bytes) {
    if (_closed) return;
    _pending.add(bytes);
    // Keep at most 10 seconds while the connection is being established.
    final limit = AIDebugVoiceProtocol.chunkBytes(_sampleRate) * 100;
    if (_socket == null && _pending.length > limit) {
      final all = _pending.takeBytes();
      _pending.add(Uint8List.sublistView(all, all.length - limit));
    }
    _flush();
  }

  void _flush() {
    if (_state != AIDebugVoiceState.recording) return;
    final size = AIDebugVoiceProtocol.chunkBytes(_sampleRate);
    if (_pending.length < size) return;
    final all = _pending.takeBytes();
    var offset = 0;
    while (all.length - offset >= size) {
      _sendChunk(Uint8List.sublistView(all, offset, offset + size));
      offset += size;
    }
    if (offset < all.length) _pending.add(Uint8List.sublistView(all, offset));
  }

  void _sendChunk(Uint8List pcm, {bool commit = false}) {
    final socket = _socket;
    if (socket == null || _closed) return;
    final message = AIDebugVoiceProtocol.buildAudioChunk(
      pcm,
      sampleRate: _sampleRate,
      commit: commit,
      keytermLibrary: _firstChunk ? _token?.keytermLibrary : null,
    );
    _firstChunk = false;
    socket.send(jsonEncode(message));
  }

  void _onMessage(Object? raw) {
    if (_closed) return;
    final message = AIDebugVoiceProtocol.parse(raw);
    switch (message.type) {
      case AIDebugVoiceMessageType.partial:
        onPartial?.call(message.text);
      case AIDebugVoiceMessageType.committed:
        onPartial?.call("");
        if (message.text.trim().isNotEmpty) onCommitted?.call(message.text);
        if (_stopCompleter != null) _teardown();
      case AIDebugVoiceMessageType.error:
        // Stopping without speech is not an error.
        if (message.code == "insufficient_audio_activity" &&
            _stopCompleter != null) {
          _teardown();
          return;
        }
        _fail(AIDebugVoiceException(message.code ?? "error", message.text));
      case AIDebugVoiceMessageType.started:
      case AIDebugVoiceMessageType.other:
        break;
    }
  }

  Future<void> _stopAudio() async {
    // Stopping is idempotent on the native side, so it is repeated for a
    // start that completed after the session was closed.
    if (!_audioStarted) return;
    await _audioSource.stop();
  }

  void _fail(Object error) {
    if (_closed) return;
    onError?.call(error);
    _teardown();
  }

  void _teardown() {
    if (_closed) return;
    _closed = true;
    _release();
    onPartial?.call("");
    _setState(AIDebugVoiceState.idle);
    final completer = _stopCompleter;
    if (completer != null && !completer.isCompleted) completer.complete();
  }

  /// Releases every resource acquired so far. Safe to call repeatedly, also
  /// for resources acquired after [_teardown] by an in-flight [start].
  void _release() {
    _stopTimer?.cancel();
    _stopTimer = null;
    unawaited(_stopAudio().catchError((Object _) {}));
    unawaited(_audioSubscription?.cancel());
    _audioSubscription = null;
    unawaited(_socketSubscription?.cancel());
    _socketSubscription = null;
    final socket = _socket;
    _socket = null;
    if (socket != null) unawaited(socket.close());
    _pending.clear();
  }
}
