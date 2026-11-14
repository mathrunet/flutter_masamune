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

/// A reading-to-spelling replacement applied to received transcripts
/// (for example `フラッター` to `Flutter`).
///
/// 受信した文字起こしに当てる読み → 表記の置き換え
/// （例：`フラッター` → `Flutter`）。
@immutable
class AIDebugSpeechReplacement {
  /// Creates a replacement from [from] to [to].
  ///
  /// [from]を[to]へ置き換える規則を作成します。
  const AIDebugSpeechReplacement({required this.from, required this.to});

  /// Reading to search for.
  ///
  /// 探す読み。
  final String from;

  /// Spelling to write instead.
  ///
  /// 代わりに書く表記。
  final String to;

  @override
  bool operator ==(Object other) =>
      other is AIDebugSpeechReplacement && other.from == from && other.to == to;

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() => "AIDebugSpeechReplacement($from -> $to)";
}

/// Client-side settings delivered with the speech token (`client`).
///
/// 音声認識トークンと一緒に届くクライアント側の設定（`client`）。
@immutable
class AIDebugSpeechClientConfig {
  /// Creates client settings.
  ///
  /// クライアント側の設定を作成します。
  const AIDebugSpeechClientConfig({
    this.commitSilenceMs = defaultCommitSilenceMs,
    this.noiseGateDb,
    this.autoStopSilenceSec = defaultAutoStopSilenceSec,
    this.replacements = const [],
  });

  /// Parses the `client` object of the speech token response.
  ///
  /// 音声認識トークンの応答の`client`を解析します。
  factory AIDebugSpeechClientConfig.fromJson(Object? json) {
    if (json is! Map) return const AIDebugSpeechClientConfig();
    final commit = json["commitSilenceMs"];
    final gate = json["noiseGateDb"];
    final autoStop = json["autoStopSilenceSec"];
    final replacements = json["replacements"];
    return AIDebugSpeechClientConfig(
      commitSilenceMs: commit is num && commit.isFinite
          ? commit.round().clamp(minCommitSilenceMs, maxCommitSilenceMs).toInt()
          : defaultCommitSilenceMs,
      noiseGateDb: gate is num && gate.isFinite ? gate.toDouble() : null,
      autoStopSilenceSec: autoStop is num && autoStop.isFinite
          ? math.max(0, autoStop.toDouble())
          : defaultAutoStopSilenceSec,
      replacements: replacements is List
          ? List.unmodifiable(
              replacements.whereType<Map>().where((entry) {
                final from = entry["from"];
                return from is String &&
                    from.isNotEmpty &&
                    entry["to"] is String;
              }).map(
                (entry) => AIDebugSpeechReplacement(
                  from: entry["from"] as String,
                  to: entry["to"] as String,
                ),
              ),
            )
          : const [],
    );
  }

  /// Default of [commitSilenceMs].
  ///
  /// [commitSilenceMs]の既定値。
  static const int defaultCommitSilenceMs = 700;

  /// Lower bound of [commitSilenceMs].
  ///
  /// [commitSilenceMs]の下限。
  static const int minCommitSilenceMs = 200;

  /// Upper bound of [commitSilenceMs].
  ///
  /// [commitSilenceMs]の上限。
  static const int maxCommitSilenceMs = 5000;

  /// Default of [autoStopSilenceSec].
  ///
  /// [autoStopSilenceSec]の既定値。
  static const double defaultAutoStopSilenceSec = 5;

  /// Silence after speech, in milliseconds, that ends a turn
  /// (`input_audio_buffer.commit`).
  ///
  /// 発話のあと、区切り（`input_audio_buffer.commit`）を送るまでの無音の長さ（ミリ秒）。
  final int commitSilenceMs;

  /// Chunks quieter than this (dBFS) are sent as silence. `null` disables the
  /// noise gate.
  ///
  /// これより小さい（dBFS）チャンクは無音にして送ります。`null`ならゲートを使いません。
  final double? noiseGateDb;

  /// Stops automatically when the transcript does not change for this many
  /// seconds. `0` disables it.
  ///
  /// 文字が変わらないままこの秒数たったら自動で止めます。`0`で無効です。
  final double autoStopSilenceSec;

  /// Reading-to-spelling replacements applied to received transcripts.
  ///
  /// 受信した文字起こしに当てる読み → 表記の置き換え。
  final List<AIDebugSpeechReplacement> replacements;

  @override
  String toString() => "AIDebugSpeechClientConfig("
      "commitSilenceMs: $commitSilenceMs, noiseGateDb: $noiseGateDb, "
      "autoStopSilenceSec: $autoStopSilenceSec, "
      "replacements: ${replacements.length})";
}

/// Connection information for OpenAI Realtime transcription returned by
/// `POST /api/app-debug/runs/{runId}/speech-token`.
///
/// `POST /api/app-debug/runs/{runId}/speech-token`が返す、
/// OpenAI Realtimeの文字起こしの接続情報。
@immutable
class AIDebugSpeechToken {
  /// Creates speech token information.
  ///
  /// 音声認識トークンの情報を作成します。
  const AIDebugSpeechToken({
    required this.url,
    this.protocols = const [],
    this.sessionUpdate,
    this.modelId,
    this.sampleRate = defaultSampleRate,
    this.client = const AIDebugSpeechClientConfig(),
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
    final protocols = json["protocols"];
    final sessionUpdate = json["sessionUpdate"];
    final sampleRate = json["sampleRate"];
    final expiresAt = json["expiresAt"];
    return AIDebugSpeechToken(
      url: url,
      protocols: protocols is List
          ? List.unmodifiable(
              protocols.whereType<String>().where((value) => value.isNotEmpty),
            )
          : const [],
      sessionUpdate: sessionUpdate is Map
          ? Map<String, Object?>.unmodifiable(
              sessionUpdate
                  .map((key, value) => MapEntry(key.toString(), value)),
            )
          : null,
      modelId: json["modelId"]?.toString(),
      sampleRate: sampleRate is num && sampleRate > 0
          ? sampleRate.toInt()
          : defaultSampleRate,
      client: AIDebugSpeechClientConfig.fromJson(json["client"]),
      expiresAt: expiresAt is String ? DateTime.tryParse(expiresAt) : null,
    );
  }

  /// Sample rate used when the response has none. The Realtime API expects
  /// 24 kHz PCM16.
  ///
  /// 応答に無いときのサンプリングレート。Realtime APIのPCM16は24kHzです。
  static const int defaultSampleRate = 24000;

  /// WebSocket URL.
  ///
  /// WebSocketのURL。
  final String url;

  /// WebSocket subprotocols. They carry the single-use key, so never log them.
  ///
  /// WebSocketのサブプロトコル。使い捨てのキーを含むため、ログに出さないでください。
  final List<String> protocols;

  /// `session.update` event sent right after connecting.
  ///
  /// 接続直後に送る`session.update`イベント。
  final Map<String, Object?>? sessionUpdate;

  /// Transcription model identifier.
  ///
  /// 文字起こしのモデルID。
  final String? modelId;

  /// Sample rate of the PCM16 audio to send.
  ///
  /// 送信するPCM16音声のサンプリングレート。
  final int sampleRate;

  /// Client-side settings.
  ///
  /// クライアント側の設定。
  final AIDebugSpeechClientConfig client;

  /// Expiration time of the single-use key.
  ///
  /// 使い捨てのキーの有効期限。
  final DateTime? expiresAt;

  @override
  String toString() => "AIDebugSpeechToken(modelId: $modelId, "
      "sampleRate: $sampleRate, expiresAt: ${expiresAt?.toIso8601String()}, "
      "client: $client)";
}

/// Kind of a message received from the transcription server.
///
/// 文字起こしサーバーから受信したメッセージの種類。
enum AIDebugVoiceMessageType {
  /// Text appended to the interim transcript of a turn.
  delta,

  /// The final transcript of a turn.
  completed,

  /// Transcription of a turn failed.
  failed,

  /// The server accepted a commit and created a turn.
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
  const AIDebugVoiceMessage(
    this.type, {
    this.text = "",
    this.itemId,
    this.previousItemId,
    this.code,
    this.eventId,
  });

  /// Message kind.
  ///
  /// メッセージの種類。
  final AIDebugVoiceMessageType type;

  /// Transcript or error text.
  ///
  /// 文字起こしまたはエラーの文字列。
  final String text;

  /// `item_id` of the turn.
  ///
  /// 区切りの`item_id`。
  final String? itemId;

  /// `previous_item_id` of a committed turn.
  ///
  /// 受け付けた区切りの`previous_item_id`。
  final String? previousItemId;

  /// Error code for errors and failures.
  ///
  /// エラーや失敗のコード。
  final String? code;

  /// `event_id` of the client event that caused an error.
  ///
  /// エラーの原因になったクライアントイベントの`event_id`。
  final String? eventId;
}

/// Error raised by the voice input.
///
/// 音声入力で発生したエラー。
class AIDebugVoiceException implements Exception {
  /// Creates a voice input error.
  ///
  /// 音声入力のエラーを作成します。
  const AIDebugVoiceException(this.code, this.message);

  /// Error code such as `permission_denied` or a server error code.
  ///
  /// `permission_denied`やサーバーのエラーコードなど。
  final String code;

  /// Human-readable message.
  ///
  /// 表示用のメッセージ。
  final String message;

  @override
  String toString() => "AIDebugVoiceException($code): $message";
}

/// Message format of OpenAI Realtime transcription and the helpers for audio
/// levels and transcript text.
///
/// OpenAI Realtimeの文字起こしのメッセージ形式と、音量・文字起こしの補助関数。
abstract final class AIDebugVoiceProtocol {
  /// Length of one audio chunk.
  ///
  /// 1つの音声チャンクの長さ。
  static const Duration chunkDuration = Duration(milliseconds: 100);

  /// How long to wait for the outstanding transcripts after the last audio
  /// is sent on stop.
  ///
  /// 停止時に最後の音声を送ってから、残りの確定文を待つ時間。
  static const Duration stopTimeout = Duration(seconds: 3);

  /// How long a stop requested before the connection waits for it.
  ///
  /// 接続前に停止したとき、接続を待つ時間。
  static const Duration connectTimeout = Duration(seconds: 10);

  /// Maximum number of chunks buffered while connecting (15 seconds).
  ///
  /// 接続までにためるチャンクの上限（15秒）。
  static const int maxPendingChunks = 150;

  /// `event_id` of the `session.update` sent after connecting. Errors for it
  /// are ignored because the single-use key already carries the settings.
  ///
  /// 接続後に送る`session.update`の`event_id`。一時キー側の設定で動くため、
  /// これに対するエラーは無視します。
  static const String sessionUpdateEventId = "samurai_session_update";

  /// Server error codes that are not shown (an empty commit and so on).
  ///
  /// 表示しないサーバーのエラーコード（空の区切りなど）。
  static const Set<String> ignoredErrorCodes = {
    "input_audio_buffer_commit_empty",
  };

  /// The `input_audio_buffer.commit` message that ends a turn.
  ///
  /// 区切りを送る`input_audio_buffer.commit`メッセージ。
  static const Map<String, Object?> commitMessage = {
    "type": "input_audio_buffer.commit",
  };

  /// Number of PCM16 bytes in one chunk at [sampleRate].
  ///
  /// [sampleRate]での1チャンクあたりのPCM16のバイト数。
  static int chunkBytes(int sampleRate) =>
      sampleRate * 2 * chunkDuration.inMilliseconds ~/ 1000;

  /// Builds an `input_audio_buffer.append` message for PCM16 LE mono [pcm].
  ///
  /// PCM16 LEモノラルの[pcm]から`input_audio_buffer.append`メッセージを作成します。
  static Map<String, Object?> buildAppendMessage(List<int> pcm) => {
        "type": "input_audio_buffer.append",
        "audio": base64Encode(pcm),
      };

  /// Builds the `session.update` sent after connecting from
  /// [sessionUpdate] of the token.
  ///
  /// トークンの[sessionUpdate]から、接続後に送る`session.update`を作成します。
  static Map<String, Object?> buildSessionUpdate(
    Map<String, Object?> sessionUpdate,
  ) =>
      {...sessionUpdate, "event_id": sessionUpdateEventId};

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
    final itemId = message["item_id"]?.toString();
    final error = message["error"];
    final errorMap = error is Map ? error : const {};
    String? text(Object? value) =>
        value is String && value.isNotEmpty ? value : null;
    switch (message["type"]) {
      case "conversation.item.input_audio_transcription.delta":
        return AIDebugVoiceMessage(
          AIDebugVoiceMessageType.delta,
          itemId: itemId,
          text: text(message["delta"]) ?? "",
        );
      case "conversation.item.input_audio_transcription.completed":
        return AIDebugVoiceMessage(
          AIDebugVoiceMessageType.completed,
          itemId: itemId,
          text: text(message["transcript"]) ?? "",
        );
      case "conversation.item.input_audio_transcription.failed":
        return AIDebugVoiceMessage(
          AIDebugVoiceMessageType.failed,
          itemId: itemId,
          code: text(errorMap["code"]) ?? "transcription_failed",
          text: text(errorMap["message"]) ?? "Transcription failed.",
        );
      case "input_audio_buffer.committed":
        return AIDebugVoiceMessage(
          AIDebugVoiceMessageType.committed,
          itemId: itemId,
          previousItemId: message["previous_item_id"]?.toString(),
        );
      case "error":
        return AIDebugVoiceMessage(
          AIDebugVoiceMessageType.error,
          code: text(errorMap["code"]) ?? text(errorMap["type"]) ?? "error",
          text: text(errorMap["message"]) ??
              "The speech recognition server reported an error.",
          eventId: text(errorMap["event_id"]),
        );
    }
    return const AIDebugVoiceMessage(AIDebugVoiceMessageType.other);
  }

  static int _sample(List<int> pcm, int index) {
    final value = pcm[index * 2] | (pcm[index * 2 + 1] << 8);
    return value >= 0x8000 ? value - 0x10000 : value;
  }

  /// Level (RMS, 0 to 1) of PCM16 LE [pcm].
  ///
  /// PCM16 LEの[pcm]の音量（RMS、0〜1）。
  static double computeRms(List<int> pcm) {
    final count = pcm.length ~/ 2;
    if (count == 0) return 0;
    var sum = 0.0;
    for (var i = 0; i < count; i++) {
      final value = _sample(pcm, i) / 0x8000;
      sum += value * value;
    }
    return math.sqrt(sum / count);
  }

  /// Converts a level (RMS) to dBFS. Silence is negative infinity.
  ///
  /// 音量（RMS）をdBFSにします。無音は負の無限大です。
  static double rmsToDb(double rms) =>
      rms > 0 ? 20 * math.log(rms) / math.ln10 : double.negativeInfinity;

  /// Converts dBFS to a level (RMS).
  ///
  /// dBFSを音量（RMS）にします。
  static double dbToRms(double db) => math.pow(10, db / 20).toDouble();

  /// Resamples PCM16 LE [pcm] from [fromRate] to [toRate] with linear
  /// interpolation.
  ///
  /// PCM16 LEの[pcm]を線形補間で[fromRate]から[toRate]へ変換します。
  static Uint8List resamplePcm16(Uint8List pcm, int fromRate, int toRate) {
    final count = pcm.length ~/ 2;
    if (fromRate == toRate || count == 0 || fromRate <= 0 || toRate <= 0) {
      return pcm;
    }
    final length = math.max(1, (count * toRate / fromRate).round());
    final output = Uint8List(length * 2);
    final step = fromRate / toRate;
    for (var i = 0; i < length; i++) {
      final position = i * step;
      final index = position.floor();
      final a = _sample(pcm, math.min(index, count - 1));
      final b = _sample(pcm, math.min(index + 1, count - 1));
      final value = (a + (b - a) * (position - index)).round() & 0xffff;
      output[i * 2] = value & 0xff;
      output[i * 2 + 1] = value >> 8;
    }
    return output;
  }

  static final RegExp _asciiWord = RegExp(r"[A-Za-z0-9_]");

  static bool _isAsciiWord(String value, int index) =>
      index >= 0 && index < value.length && _asciiWord.hasMatch(value[index]);

  /// Joins transcript pieces, adding a half-width space only between ASCII
  /// words.
  ///
  /// 文をつなぎます。英数字どうしが隣り合うときだけ半角スペースを挟みます。
  static String joinTranscripts(Iterable<String?> pieces) {
    var result = "";
    for (final raw in pieces) {
      final piece = (raw ?? "").trim();
      if (piece.isEmpty) continue;
      result +=
          _isAsciiWord(result, result.length - 1) && _isAsciiWord(piece, 0)
              ? " $piece"
              : piece;
    }
    return result;
  }

  /// Applies reading-to-spelling [replacements] to [text].
  ///
  /// Longer readings are applied first. ASCII readings ignore case and are
  /// not replaced inside an ASCII word. A half-width space is added where the
  /// replacement makes ASCII words touch.
  ///
  /// 読み → 表記の置き換えを[text]に当てます。長い読みから順に当て、英字の読みは
  /// 大文字小文字を無視し、英単語の途中では置き換えません。
  static String applyReplacements(
    String text,
    List<AIDebugSpeechReplacement> replacements,
  ) {
    if (text.isEmpty || replacements.isEmpty) return text;
    final entries =
        replacements.where((entry) => entry.from.isNotEmpty).toList();
    if (entries.isEmpty) return text;
    mergeSort(entries, compare: (a, b) => b.from.length - a.from.length);
    final pattern = RegExp(
      entries.map((entry) {
        final head = _isAsciiWord(entry.from, 0) ? "(?<![A-Za-z0-9_])" : "";
        final tail = _isAsciiWord(entry.from, entry.from.length - 1)
            ? "(?![A-Za-z0-9_])"
            : "";
        return "$head${RegExp.escape(entry.from)}$tail";
      }).join("|"),
      caseSensitive: false,
    );
    final lookup = <String, String>{
      for (final entry in entries) entry.from.toLowerCase(): entry.to,
    };
    var result = "";
    var last = 0;
    for (final match in pattern.allMatches(text)) {
      final matched = match[0]!;
      final to = lookup[matched.toLowerCase()] ?? matched;
      final before = result + text.substring(last, match.start);
      final after = text.substring(match.end);
      final spaceBefore =
          _isAsciiWord(before, before.length - 1) && _isAsciiWord(to, 0)
              ? " "
              : "";
      result = before + spaceBefore + to;
      last = match.end;
      if (_isAsciiWord(to, to.length - 1) && _isAsciiWord(after, 0)) {
        result += " ";
      }
    }
    return result + text.substring(last);
  }

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

/// Minimum input level (noise gate). Chunks quieter than [thresholdDb] are
/// sent as silence so that distant voices are not transcribed.
///
/// 拾う最小の音量（ノイズゲート）。[thresholdDb]より小さいチャンクは無音にして
/// 送り、遠くの声を文字にしないようにします。
class AIDebugVoiceNoiseGate {
  /// Creates a noise gate. A `null` [thresholdDb] passes everything.
  ///
  /// ノイズゲートを作成します。[thresholdDb]が`null`なら常に通します。
  AIDebugVoiceNoiseGate({
    double? thresholdDb,
    this.hold = const Duration(milliseconds: 300),
    this.chunk = AIDebugVoiceProtocol.chunkDuration,
  }) : thresholdDb =
            thresholdDb != null && thresholdDb.isFinite ? thresholdDb : null;

  /// Threshold in dBFS, or `null` when disabled.
  ///
  /// 閾値（dBFS）。無効なら`null`。
  final double? thresholdDb;

  /// How long the gate stays open after the level falls below the threshold.
  ///
  /// 閾値を下回ってからも開いたままにする時間。
  final Duration hold;

  /// Length of one chunk.
  ///
  /// 1チャンクの長さ。
  final Duration chunk;

  int _holdLeftMs = 0;

  /// Whether the gate is used.
  ///
  /// ゲートを使うかどうか。
  bool get enabled => thresholdDb != null;

  /// Pushes the level of the next chunk and returns whether to pass it.
  ///
  /// 次のチャンクの音量を渡し、そのチャンクを通すかどうかを返します。
  bool push(double rms) {
    final threshold = thresholdDb;
    if (threshold == null) return true;
    if (AIDebugVoiceProtocol.rmsToDb(rms) >= threshold) {
      _holdLeftMs = hold.inMilliseconds;
      return true;
    }
    if (_holdLeftMs <= 0) return false;
    _holdLeftMs -= chunk.inMilliseconds;
    return true;
  }

  /// Gates [pcm] and returns the chunk to send with its level. A closed gate
  /// returns silence of the same length and a level of `0`.
  ///
  /// [pcm]にゲートを通し、送るチャンクと音量を返します。閉じていれば同じ長さの
  /// 無音と音量`0`を返します。
  ({Uint8List pcm, double rms}) apply(Uint8List pcm) {
    final rms = AIDebugVoiceProtocol.computeRms(pcm);
    if (push(rms)) return (pcm: pcm, rms: rms);
    return (pcm: Uint8List(pcm.length), rms: 0);
  }
}

/// Client-side turn detection. `gpt-live-transcribe` has no server VAD, so the
/// client commits a turn after speech followed by silence.
///
/// クライアント側の発話の区切りの判定。`gpt-live-transcribe`はサーバー側のVADに
/// 対応しないため、発話のあとの無音でクライアントが区切ります。
class AIDebugVoiceTurnDetector {
  /// Creates a turn detector.
  ///
  /// [minSpeechRms] raises the minimum speech level, for example to the noise
  /// gate threshold.
  ///
  /// 区切りの判定を作成します。
  AIDebugVoiceTurnDetector({
    this.commitSilence = const Duration(
      milliseconds: AIDebugSpeechClientConfig.defaultCommitSilenceMs,
    ),
    this.chunk = AIDebugVoiceProtocol.chunkDuration,
    double minSpeechRms = defaultMinSpeechRms,
  }) : _minRms = math.max(defaultMinSpeechRms, minSpeechRms);

  /// Minimum level treated as speech.
  ///
  /// 発話とみなす音量の下限。
  static const double defaultMinSpeechRms = 0.02;

  /// Speech must also be this many times louder than the noise floor.
  ///
  /// 発話は周りの音のこの倍数より大きいことも条件にします。
  static const double noiseFloorFactor = 3;

  /// Shorter speech (clicks and so on) does not end a turn.
  ///
  /// これより短い発話（クリック音など）では区切りません。
  static const Duration minSpeech = Duration(milliseconds: 200);

  /// Silence after speech that ends a turn.
  ///
  /// 区切るまでの発話のあとの無音の長さ。
  final Duration commitSilence;

  /// Length of one chunk.
  ///
  /// 1チャンクの長さ。
  final Duration chunk;

  final double _minRms;
  double _noiseFloor = 0.005;
  int _speechMs = 0;
  int _silenceMs = 0;

  /// Pushes the level of the next chunk and returns `true` when a turn should
  /// be committed.
  ///
  /// 次のチャンクの音量を渡し、区切りを送るべきときに`true`を返します。
  bool push(double rms) {
    final speaking = rms >= math.max(_minRms, _noiseFloor * noiseFloorFactor);
    if (speaking) {
      _speechMs += chunk.inMilliseconds;
      _silenceMs = 0;
      return false;
    }
    // Follow the ambient level slowly, only while quiet.
    _noiseFloor = _noiseFloor * 0.95 + rms * 0.05;
    if (_speechMs == 0) return false;
    _silenceMs += chunk.inMilliseconds;
    if (_silenceMs < commitSilence.inMilliseconds) return false;
    final enough = _speechMs >= minSpeech.inMilliseconds;
    _speechMs = 0;
    _silenceMs = 0;
    return enough;
  }

  /// Whether there was enough speech since the last turn.
  ///
  /// 前の区切りのあとに十分な発話があったかどうか。
  bool get hasSpeech => _speechMs >= minSpeech.inMilliseconds;

  /// Forgets the current turn.
  ///
  /// 現在の区切りを忘れます。
  void reset() {
    _speechMs = 0;
    _silenceMs = 0;
  }
}

/// Orders the transcripts of each turn (`item_id`). Completions may arrive
/// out of order, so only completed turns from the head are passed to
/// [onCommitted] and the rest is joined and passed to [onPartial].
///
/// 区切り（`item_id`）ごとの文を現れた順に並べて持ちます。確定が届く順は保証
/// されないため、先頭から順に確定したものだけを[onCommitted]に渡し、残りを
/// つないだ文を[onPartial]に渡します。
class AIDebugVoiceTranscriptAssembler {
  /// Creates an assembler.
  ///
  /// 文の組み立てを作成します。
  AIDebugVoiceTranscriptAssembler({this.onPartial, this.onCommitted});

  /// Called with the joined interim transcript when it changes.
  ///
  /// 途中の文が変わったときに、つないだ文で呼ばれます。
  final void Function(String text)? onPartial;

  /// Called with each committed transcript in order (may be empty).
  ///
  /// 確定した文ごとに順に呼ばれます（空の場合があります）。
  final void Function(String text)? onCommitted;

  final List<_AIDebugVoiceTranscriptItem> _items = [];
  final Set<String?> _finished = {};
  String _lastPartial = "";

  _AIDebugVoiceTranscriptItem _find(String? itemId) {
    for (final item in _items) {
      if (item.id == itemId) return item;
    }
    final item = _AIDebugVoiceTranscriptItem(itemId);
    _items.add(item);
    return item;
  }

  void _emit() {
    while (_items.isNotEmpty && _items.first.done) {
      final item = _items.removeAt(0);
      _finished.add(item.id);
      _lastPartial = "";
      onCommitted?.call(item.text.trim());
    }
    final partial =
        AIDebugVoiceProtocol.joinTranscripts(_items.map((item) => item.text));
    if (partial != _lastPartial) {
      _lastPartial = partial;
      onPartial?.call(partial);
    }
  }

  /// Registers a turn accepted by the server.
  ///
  /// サーバーが受け付けた区切りを登録します。
  void committed(String? itemId) {
    if (itemId != null && !_finished.contains(itemId)) _find(itemId);
  }

  /// Appends [text] to the interim transcript of [itemId].
  ///
  /// [itemId]の途中の文に[text]を足します。
  void delta(String? itemId, String text) {
    if (_finished.contains(itemId)) return;
    final item = _find(itemId);
    if (item.done) return;
    item.text += text;
    _emit();
  }

  /// Completes [itemId] with [text].
  ///
  /// [itemId]を[text]で確定します。
  void completed(String? itemId, String text) {
    if (_finished.contains(itemId)) return;
    final item = _find(itemId);
    item.text = text;
    item.done = true;
    _emit();
  }

  /// Completes [itemId] with an empty transcript.
  ///
  /// [itemId]を空の文で確定します。
  void failed(String? itemId) => completed(itemId, "");

  /// Number of turns not passed to [onCommitted] yet.
  ///
  /// まだ[onCommitted]に渡していない区切りの数。
  int get pendingCount => _items.length;
}

class _AIDebugVoiceTranscriptItem {
  _AIDebugVoiceTranscriptItem(this.id);

  final String? id;
  String text = "";
  bool done = false;
}

/// Microphone audio delivered as PCM16 LE mono chunks.
///
/// PCM16 LEモノラルのチャンクとして届くマイク音声。
abstract class AIDebugVoiceAudioSource {
  /// Audio bytes captured after [start].
  ///
  /// [start]以降に取得した音声のバイト列。
  Stream<Uint8List> get chunks;

  /// Requests the microphone permission and starts capturing at
  /// [sampleRate].
  ///
  /// マイクの権限を要求し、[sampleRate]で取得を開始します。
  Future<void> start({int sampleRate = AIDebugSpeechToken.defaultSampleRate});

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
  Future<void> start({
    int sampleRate = AIDebugSpeechToken.defaultSampleRate,
  }) async {
    try {
      await _methods.invokeMethod<bool>("start", {"sampleRate": sampleRate});
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

  /// Requesting the microphone permission.
  connecting,

  /// Capturing audio. Audio is buffered until the connection is ready.
  recording,

  /// Waiting for the final transcripts.
  stopping,
}

/// One real-time voice input from the microphone button to the last
/// committed transcript.
///
/// The audio is captured natively and streamed straight to OpenAI Realtime
/// transcription with a single-use key issued by SamuraiAI; SamuraiAI never
/// relays audio. The client detects turns from the audio level and sends
/// `input_audio_buffer.commit` after speech followed by silence.
///
/// マイクボタンの押下から最後の確定文までの1回分のリアルタイム音声入力。
/// 音声はSamuraiAIが発行した使い捨てのキーでOpenAIへ直接送ります。
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
            connector ?? debugConnectorOverride ?? connectAIDebugVoiceSocket,
        _captureRate = _lastSampleRate,
        _client = _lastClient {
    _gate = AIDebugVoiceNoiseGate(thresholdDb: _client.noiseGateDb);
    _turns = _createTurnDetector();
    _transcripts = AIDebugVoiceTranscriptAssembler(
      onPartial: _onAssembledPartial,
      onCommitted: _onAssembledCommitted,
    );
  }

  /// Replaces the native audio source in tests.
  @visibleForTesting
  static AIDebugVoiceAudioSource? debugAudioSourceOverride;

  /// Replaces the WebSocket connector in tests.
  @visibleForTesting
  static AIDebugVoiceSocketConnector? debugConnectorOverride;

  // The microphone starts before the token arrives, so the settings of the
  // last token are used until then.
  static int _lastSampleRate = AIDebugSpeechToken.defaultSampleRate;
  static AIDebugSpeechClientConfig _lastClient =
      const AIDebugSpeechClientConfig();

  /// Forgets the settings remembered from the last token.
  @visibleForTesting
  static void debugResetLastToken() {
    _lastSampleRate = AIDebugSpeechToken.defaultSampleRate;
    _lastClient = const AIDebugSpeechClientConfig();
  }

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
  // Messages waiting for the connection. `null` is a commit.
  final List<Uint8List?> _queue = [];
  final int _captureRate;
  AIDebugSpeechClientConfig _client;
  late AIDebugVoiceNoiseGate _gate;
  late AIDebugVoiceTurnDetector _turns;
  late final AIDebugVoiceTranscriptAssembler _transcripts;
  bool _audioStarted = false;
  bool _audioReady = false;
  bool _connected = false;
  bool _closed = false;
  bool _started = false;
  bool _finalReady = false;
  bool _finalSent = false;
  // Commits sent without `input_audio_buffer.committed` yet.
  int _awaitingCommits = 0;
  String _lastText = "";
  Completer<void>? _stopCompleter;
  Timer? _stopTimer;
  Timer? _autoStopTimer;

  /// Current state.
  ///
  /// 現在の状態。
  AIDebugVoiceState get state => _state;

  void _setState(AIDebugVoiceState value) {
    if (_state == value) return;
    _state = value;
    onStateChanged?.call(value);
  }

  AIDebugVoiceTurnDetector _createTurnDetector() {
    final threshold = _gate.thresholdDb;
    return AIDebugVoiceTurnDetector(
      commitSilence: Duration(milliseconds: _client.commitSilenceMs),
      minSpeechRms:
          threshold == null ? 0 : AIDebugVoiceProtocol.dbToRms(threshold),
    );
  }

  /// Starts capturing and transcribing. Errors are reported to [onError].
  ///
  /// The microphone starts before the connection; up to 15 seconds of audio
  /// captured while connecting is buffered and sent once connected.
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
      await _audioSource.start(sampleRate: _captureRate);
      if (_closed) return _release();
      _audioReady = true;
      _setState(AIDebugVoiceState.recording);
      _armAutoStop();
      final token = await controller.requestSpeechToken();
      _token = token;
      _lastSampleRate = token.sampleRate;
      _lastClient = token.client;
      if (_closed) return _release();
      _applyClient(token.client);
      final socket = await _connector(Uri.parse(token.url), token.protocols);
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
      _connected = true;
      final update = token.sessionUpdate;
      if (update != null) {
        socket.send(
          jsonEncode(AIDebugVoiceProtocol.buildSessionUpdate(update)),
        );
      }
      _flushQueue();
      _sendFinalIfReady();
    } catch (error) {
      _fail(error);
    }
  }

  /// Stops capturing, sends the remaining audio and the last turn, and waits
  /// for the outstanding transcripts for up to
  /// [AIDebugVoiceProtocol.stopTimeout].
  ///
  /// A stop requested while connecting waits for the connection and sends
  /// the buffered audio first.
  ///
  /// 取得を止めて残りの音声と最後の区切りを送り、残りの確定文を待ちます。
  Future<void> stop() async {
    if (_closed) return;
    final existing = _stopCompleter;
    if (existing != null) return existing.future;
    if (!_audioReady) {
      _teardown();
      return;
    }
    final completer = Completer<void>();
    _stopCompleter = completer;
    _autoStopTimer?.cancel();
    _setState(AIDebugVoiceState.stopping);
    _stopTimer = Timer(
      AIDebugVoiceProtocol.connectTimeout + AIDebugVoiceProtocol.stopTimeout,
      _teardown,
    );
    try {
      await _stopAudio();
      // Let audio events that were already queued arrive first.
      await Future<void>.delayed(Duration.zero);
    } catch (_) {
      // Stopping proceeds even if the native side failed to stop.
    }
    if (_closed) return completer.future;
    final rest = _pending.takeBytes();
    if (rest.isNotEmpty) _processChunk(rest);
    if (_turns.hasSpeech) _commit();
    _turns.reset();
    _finalReady = true;
    _sendFinalIfReady();
    return completer.future;
  }

  /// Stops immediately without waiting for the final transcript.
  ///
  /// 最後の確定文を待たずにすぐ停止します。
  void cancel() => _teardown();

  void _applyClient(AIDebugSpeechClientConfig client) {
    final previous = _client;
    _client = client;
    // Rebuild the detectors if the settings changed before any speech.
    if ((client.commitSilenceMs != previous.commitSilenceMs ||
            client.noiseGateDb != _gate.thresholdDb) &&
        !_turns.hasSpeech) {
      _gate = AIDebugVoiceNoiseGate(thresholdDb: client.noiseGateDb);
      _turns = _createTurnDetector();
    }
  }

  void _onAudio(Uint8List bytes) {
    if (_closed || _finalReady) return;
    _pending.add(bytes);
    final size = AIDebugVoiceProtocol.chunkBytes(_captureRate);
    if (_pending.length < size) return;
    final all = _pending.takeBytes();
    var offset = 0;
    while (all.length - offset >= size) {
      _processChunk(Uint8List.sublistView(all, offset, offset + size));
      offset += size;
    }
    if (offset < all.length) _pending.add(Uint8List.sublistView(all, offset));
  }

  void _processChunk(Uint8List pcm) {
    final gated = _gate.apply(pcm);
    final commit = _turns.push(gated.rms);
    _enqueue(gated.pcm);
    if (commit) _commit();
  }

  void _commit() {
    _awaitingCommits += 1;
    _enqueue(null);
  }

  void _enqueue(Uint8List? item) {
    final socket = _socket;
    if (_connected && socket != null) {
      socket.send(_encode(item));
      return;
    }
    _queue.add(item);
    while (_queue.length > AIDebugVoiceProtocol.maxPendingChunks) {
      if (_queue.removeAt(0) == null) {
        _awaitingCommits = math.max(0, _awaitingCommits - 1);
      }
    }
  }

  String _encode(Uint8List? item) {
    if (item == null) return jsonEncode(AIDebugVoiceProtocol.commitMessage);
    final rate = _token?.sampleRate ?? _captureRate;
    return jsonEncode(
      AIDebugVoiceProtocol.buildAppendMessage(
        AIDebugVoiceProtocol.resamplePcm16(item, _captureRate, rate),
      ),
    );
  }

  void _flushQueue() {
    final socket = _socket;
    if (!_connected || socket == null) return;
    while (_queue.isNotEmpty) {
      socket.send(_encode(_queue.removeAt(0)));
    }
  }

  void _sendFinalIfReady() {
    if (_finalSent || !_finalReady || !_connected || _closed) return;
    _finalSent = true;
    _flushQueue();
    _stopTimer?.cancel();
    _stopTimer = Timer(AIDebugVoiceProtocol.stopTimeout, _teardown);
    _closeIfSettled();
  }

  void _closeIfSettled() {
    if (_stopCompleter != null &&
        _finalSent &&
        _awaitingCommits == 0 &&
        _transcripts.pendingCount == 0) {
      _teardown();
    }
  }

  void _onAssembledPartial(String text) {
    _handleText(text);
    onPartial?.call(
      AIDebugVoiceProtocol.applyReplacements(text, _client.replacements),
    );
  }

  void _onAssembledCommitted(String text) {
    _handleText("");
    onPartial?.call("");
    if (text.isEmpty) return;
    onCommitted?.call(
      AIDebugVoiceProtocol.applyReplacements(text, _client.replacements),
    );
  }

  void _handleText(String text) {
    if (text == _lastText) return;
    _lastText = text;
    if (_stopCompleter == null) _armAutoStop();
  }

  /// Stops like the stop button when the text does not change for
  /// `autoStopSilenceSec` seconds.
  void _armAutoStop() {
    _autoStopTimer?.cancel();
    _autoStopTimer = null;
    final seconds = _client.autoStopSilenceSec;
    if (_closed || _stopCompleter != null || seconds <= 0) return;
    _autoStopTimer = Timer(
      Duration(milliseconds: (seconds * 1000).round()),
      () => unawaited(stop()),
    );
  }

  void _onMessage(Object? raw) {
    if (_closed) return;
    final message = AIDebugVoiceProtocol.parse(raw);
    switch (message.type) {
      case AIDebugVoiceMessageType.delta:
        _transcripts.delta(message.itemId, message.text);
      case AIDebugVoiceMessageType.completed:
        _transcripts.completed(message.itemId, message.text);
        _closeIfSettled();
      case AIDebugVoiceMessageType.failed:
        _transcripts.failed(message.itemId);
        _closeIfSettled();
      case AIDebugVoiceMessageType.committed:
        _awaitingCommits = math.max(0, _awaitingCommits - 1);
        _transcripts.committed(message.itemId);
        _closeIfSettled();
      case AIDebugVoiceMessageType.error:
        // The single-use key already carries the session settings.
        if (message.eventId == AIDebugVoiceProtocol.sessionUpdateEventId) {
          return;
        }
        if (AIDebugVoiceProtocol.ignoredErrorCodes.contains(message.code)) {
          _awaitingCommits = math.max(0, _awaitingCommits - 1);
          _closeIfSettled();
          return;
        }
        _fail(AIDebugVoiceException(message.code ?? "error", message.text));
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
    _autoStopTimer?.cancel();
    _autoStopTimer = null;
    unawaited(_stopAudio().catchError((Object _) {}));
    unawaited(_audioSubscription?.cancel());
    _audioSubscription = null;
    unawaited(_socketSubscription?.cancel());
    _socketSubscription = null;
    final socket = _socket;
    _socket = null;
    _connected = false;
    if (socket != null) unawaited(socket.close());
    _pending.clear();
    _queue.clear();
  }
}
