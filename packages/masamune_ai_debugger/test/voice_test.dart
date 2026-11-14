import "dart:async";
import "dart:convert";
import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:masamune_ai_debugger/masamune_ai_debugger.dart";
import "package:shared_preferences/shared_preferences.dart";

// Run the UI tests that need the voice input compiled in with:
// flutter test --dart-define=MASAMUNE_AI_DEBUGGER_VOICE=true test/voice_test.dart

class _FakeAudioSource implements AIDebugVoiceAudioSource {
  final StreamController<Uint8List> controller =
      StreamController<Uint8List>.broadcast();
  int starts = 0;
  int stops = 0;
  int? sampleRate;
  Object? startError;
  Completer<void>? startGate;

  @override
  Stream<Uint8List> get chunks => controller.stream;

  @override
  Future<void> start({int sampleRate = 24000}) async {
    starts += 1;
    this.sampleRate = sampleRate;
    await startGate?.future;
    final error = startError;
    if (error != null) throw error;
  }

  @override
  Future<void> stop() async {
    stops += 1;
  }

  /// Emits [length] bytes filled with [value] (0x20 is loud, 0x01 is quiet).
  void emit(int length, [int value = 1]) =>
      controller.add(Uint8List(length)..fillRange(0, length, value));

  /// Emits [count] chunks of 100 ms at 24 kHz.
  void chunks100ms(int count, {bool loud = false}) {
    for (var i = 0; i < count; i++) {
      emit(4800, loud ? 0x20 : 0x01);
    }
  }
}

class _FakeSocket implements AIDebugVoiceSocket {
  final StreamController<Object?> incoming = StreamController<Object?>();
  final List<Map<String, Object?>> sent = [];
  Uri? url;
  List<String>? protocols;
  bool closed = false;

  @override
  Stream<Object?> get messages => incoming.stream;

  @override
  void send(String message) =>
      sent.add(Map<String, Object?>.from(jsonDecode(message) as Map));

  @override
  Future<void> close() async {
    closed = true;
  }

  void receive(Map<String, Object?> message) =>
      incoming.add(jsonEncode(message));

  Iterable<Map<String, Object?>> ofType(String type) =>
      sent.where((message) => message["type"] == type);

  int get commits => ofType("input_audio_buffer.commit").length;

  void delta(String itemId, String text) => receive({
        "type": "conversation.item.input_audio_transcription.delta",
        "item_id": itemId,
        "delta": text,
      });

  void completed(String itemId, String text) => receive({
        "type": "conversation.item.input_audio_transcription.completed",
        "item_id": itemId,
        "transcript": text,
      });

  void committed(String itemId) => receive({
        "type": "input_audio_buffer.committed",
        "item_id": itemId,
      });
}

Map<String, Object?> _tokenJson({
  int sampleRate = 24000,
  Map<String, Object?>? client,
}) =>
    {
      "success": true,
      "provider": "openai",
      "url": "wss://api.openai.com/v1/realtime?intent=transcription",
      "protocols": ["realtime", "openai-insecure-api-key.ek_secret"],
      "sessionUpdate": {
        "type": "session.update",
        "session": {"type": "transcription"},
      },
      "modelId": "gpt-live-transcribe",
      "sampleRate": sampleRate,
      "keytermCount": 3,
      "skippedKeyterms": <String>[],
      "client": client ??
          {
            "autoStopSilenceSec": 0,
            "sounds": true,
            "localPreview": true,
            "commitSilenceMs": 700,
            "noiseGateDb": null,
            "languageCode": "ja",
            "replacements": [
              {"from": "フラッター", "to": "Flutter"},
            ],
          },
      "expiresAt": "2026-11-12T10:00:00.000Z",
    };

AIDebuggerMasamuneAdapter _adapter({
  required List<String> paths,
  Map<String, Object?> Function()? token,
  Object? tokenError,
}) =>
    AIDebuggerMasamuneAdapter(
      projectId: "voice-test",
      endpoint: "https://ai-debugger.example.test/",
      apiKey: "test-key",
      post: (url, headers, body) async {
        final path = Uri.parse(url).path;
        paths.add(path);
        if (path.endsWith("/speech-token")) {
          expect(headers["x-api-key"], "test-key");
          final error = tokenError;
          if (error != null) throw error;
          return token?.call() ?? _tokenJson();
        }
        return {"success": true};
      },
    );

Future<void> _settle() async {
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

Uint8List _pcm(List<int> samples) {
  final bytes = Uint8List(samples.length * 2);
  for (var i = 0; i < samples.length; i++) {
    final value = samples[i] & 0xffff;
    bytes[i * 2] = value & 0xff;
    bytes[i * 2 + 1] = value >> 8;
  }
  return bytes;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    AIDebugVoiceSession.debugResetLastToken();
  });

  tearDown(() {
    AIDebugVoiceSession.debugAudioSourceOverride = null;
    AIDebugVoiceSession.debugConnectorOverride = null;
    AIDebugVoiceSession.debugResetLastToken();
  });

  group("speech token", () {
    test("parses the SamuraiAI response", () {
      final token = AIDebugSpeechToken.fromJson(_tokenJson(client: {
        "commitSilenceMs": 50,
        "noiseGateDb": -45,
        "autoStopSilenceSec": 0,
        "replacements": [
          {"from": "リバーポッド", "to": "Riverpod"},
          {"from": "", "to": "x"},
          {"from": "a"},
        ],
      }));
      expect(
          token.url, "wss://api.openai.com/v1/realtime?intent=transcription");
      expect(
          token.protocols, ["realtime", "openai-insecure-api-key.ek_secret"]);
      expect(token.sessionUpdate?["type"], "session.update");
      expect(token.modelId, "gpt-live-transcribe");
      expect(token.sampleRate, 24000);
      expect(token.client.commitSilenceMs, 200);
      expect(token.client.noiseGateDb, -45);
      expect(token.client.autoStopSilenceSec, 0);
      expect(token.client.replacements, const [
        AIDebugSpeechReplacement(from: "リバーポッド", to: "Riverpod"),
      ]);
      expect(token.expiresAt, DateTime.utc(2026, 11, 12, 10));
      expect(token.toString(), isNot(contains("ek_secret")));
      expect(token.toString(), isNot(contains("wss://")));
      expect(
        () => AIDebugSpeechToken.fromJson(const {"success": true}),
        throwsFormatException,
      );
    });

    test("missing values fall back to the defaults", () {
      final token = AIDebugSpeechToken.fromJson(const {"url": "wss://x"});
      expect(token.protocols, isEmpty);
      expect(token.sessionUpdate, isNull);
      expect(token.sampleRate, 24000);
      expect(token.client.commitSilenceMs, 700);
      expect(token.client.noiseGateDb, isNull);
      expect(token.client.autoStopSilenceSec, 5);
      expect(token.client.replacements, isEmpty);
      final clamped = AIDebugSpeechClientConfig.fromJson(const {
        "commitSilenceMs": 99999,
        "autoStopSilenceSec": -3,
      });
      expect(clamped.commitSilenceMs, 5000);
      expect(clamped.autoStopSilenceSec, 0);
    });

    test("registers the run and posts to the speech-token endpoint", () async {
      final paths = <String>[];
      final adapter = _adapter(paths: paths);
      final token = await adapter.controller.requestSpeechToken();
      expect(token.protocols, hasLength(2));
      final runId = adapter.controller.runId;
      expect(paths, [
        "/api/app-debug/runs",
        "/api/app-debug/runs/$runId/speech-token",
      ]);
    });

    test("an expired run is recreated once", () async {
      final paths = <String>[];
      var calls = 0;
      final adapter = AIDebuggerMasamuneAdapter(
        projectId: "voice-test",
        endpoint: "https://ai-debugger.example.test",
        apiKey: "test-key",
        post: (url, headers, body) async {
          final path = Uri.parse(url).path;
          paths.add(path);
          if (path.endsWith("/speech-token") && calls++ == 0) {
            throw const AIDebugHttpException(410, "Debug run has stopped");
          }
          return path.endsWith("/speech-token")
              ? _tokenJson()
              : {"success": true};
        },
      );
      final firstRun = adapter.controller.runId;
      await adapter.controller.requestSpeechToken();
      expect(adapter.controller.runId, isNot(firstRun));
      expect(
        paths.where((path) => path == "/api/app-debug/runs").length,
        2,
      );
    });

    test("not configured errors keep their status and code", () async {
      final adapter = _adapter(
        paths: [],
        tokenError: const AIDebugHttpException(
          412,
          "OpenAI API key is not configured",
          code: "not_configured",
        ),
      );
      await expectLater(
        adapter.controller.requestSpeechToken(),
        throwsA(isA<AIDebugHttpException>()
            .having((error) => error.statusCode, "statusCode", 412)
            .having((error) => error.code, "code", "not_configured")),
      );
    });
  });

  group("protocol", () {
    test("builds append, commit, and session.update messages", () {
      expect(AIDebugVoiceProtocol.buildAppendMessage([1, 0, 2, 0]), {
        "type": "input_audio_buffer.append",
        "audio": base64Encode([1, 0, 2, 0]),
      });
      expect(AIDebugVoiceProtocol.commitMessage, {
        "type": "input_audio_buffer.commit",
      });
      expect(
        AIDebugVoiceProtocol.buildSessionUpdate(const {
          "type": "session.update",
          "session": {"type": "transcription"},
        }),
        {
          "type": "session.update",
          "session": {"type": "transcription"},
          "event_id": "samurai_session_update",
        },
      );
      expect(AIDebugVoiceProtocol.chunkBytes(24000), 4800);
      expect(AIDebugVoiceProtocol.chunkBytes(16000), 3200);
    });

    test("server messages are classified", () {
      AIDebugVoiceMessage parse(Map<String, Object?> json) =>
          AIDebugVoiceProtocol.parse(jsonEncode(json));
      final delta = parse({
        "type": "conversation.item.input_audio_transcription.delta",
        "item_id": "i1",
        "delta": "Flu",
      });
      expect(delta.type, AIDebugVoiceMessageType.delta);
      expect(delta.itemId, "i1");
      expect(delta.text, "Flu");
      final completed = parse({
        "type": "conversation.item.input_audio_transcription.completed",
        "item_id": "i1",
        "transcript": "Flutter",
      });
      expect(completed.type, AIDebugVoiceMessageType.completed);
      expect(completed.text, "Flutter");
      final failed = parse({
        "type": "conversation.item.input_audio_transcription.failed",
        "item_id": "i2",
      });
      expect(failed.type, AIDebugVoiceMessageType.failed);
      expect(failed.code, "transcription_failed");
      final committed = parse({
        "type": "input_audio_buffer.committed",
        "item_id": "i3",
        "previous_item_id": "i2",
      });
      expect(committed.type, AIDebugVoiceMessageType.committed);
      expect(committed.previousItemId, "i2");
      final error = parse({
        "type": "error",
        "error": {
          "type": "invalid_request_error",
          "code": "input_audio_buffer_commit_empty",
          "message": "empty",
          "event_id": "e1",
        },
      });
      expect(error.type, AIDebugVoiceMessageType.error);
      expect(error.code, "input_audio_buffer_commit_empty");
      expect(error.text, "empty");
      expect(error.eventId, "e1");
      expect(
        parse({
          "type": "error",
          "error": {"type": "invalid_request_error"},
        }).code,
        "invalid_request_error",
      );
      expect(parse({"type": "error"}).code, "error");
      expect(
        AIDebugVoiceProtocol.parse("not json").type,
        AIDebugVoiceMessageType.other,
      );
      expect(
        parse({"type": "session.updated"}).type,
        AIDebugVoiceMessageType.other,
      );
    });

    test("levels and resampling", () {
      expect(AIDebugVoiceProtocol.computeRms(Uint8List(0)), 0);
      expect(AIDebugVoiceProtocol.computeRms(_pcm([0x4000, -0x4000])), 0.5);
      expect(AIDebugVoiceProtocol.rmsToDb(0), double.negativeInfinity);
      expect(AIDebugVoiceProtocol.rmsToDb(0.1), closeTo(-20, 1e-9));
      expect(AIDebugVoiceProtocol.dbToRms(-20), closeTo(0.1, 1e-9));
      final input = _pcm([0, 300, 600]);
      expect(AIDebugVoiceProtocol.resamplePcm16(input, 24000, 24000), input);
      final down = AIDebugVoiceProtocol.resamplePcm16(
        _pcm([0, 300, 600, 900, 1200, 1500]),
        24000,
        16000,
      );
      expect(down, _pcm([0, 450, 900, 1350]));
      expect(
        AIDebugVoiceProtocol.resamplePcm16(_pcm([-2, 2]), 16000, 32000),
        _pcm([-2, 0, 2, 2]),
      );
    });

    test("noise gate holds for 300 ms and silences closed chunks", () {
      final open = AIDebugVoiceNoiseGate();
      expect(open.enabled, isFalse);
      expect(open.push(0), isTrue);
      final gate = AIDebugVoiceNoiseGate(thresholdDb: -20);
      expect(gate.push(0.2), isTrue);
      expect(gate.push(0.01), isTrue);
      expect(gate.push(0.01), isTrue);
      expect(gate.push(0.01), isTrue);
      expect(gate.push(0.01), isFalse);
      final quiet = AIDebugVoiceNoiseGate(thresholdDb: -20).apply(
        _pcm([10, -10]),
      );
      expect(quiet.pcm, Uint8List(4));
      expect(quiet.rms, 0);
      final loud = _pcm([0x4000, -0x4000]);
      final passed = AIDebugVoiceNoiseGate(thresholdDb: -20).apply(loud);
      expect(passed.pcm, same(loud));
      expect(passed.rms, 0.5);
    });

    test("turn detector commits after speech and silence", () {
      final turns = AIDebugVoiceTurnDetector();
      // Silence alone never commits.
      for (var i = 0; i < 20; i++) {
        expect(turns.push(0), isFalse);
      }
      expect(turns.push(0.2), isFalse);
      expect(turns.hasSpeech, isFalse);
      expect(turns.push(0.2), isFalse);
      expect(turns.hasSpeech, isTrue);
      for (var i = 0; i < 6; i++) {
        expect(turns.push(0), isFalse);
      }
      expect(turns.push(0), isTrue);
      expect(turns.hasSpeech, isFalse);

      // A click shorter than 200 ms does not commit.
      final click = AIDebugVoiceTurnDetector();
      expect(click.push(0.2), isFalse);
      final results = [for (var i = 0; i < 7; i++) click.push(0)];
      expect(results, everyElement(isFalse));

      // The noise gate threshold raises the speech level.
      final gated = AIDebugVoiceTurnDetector(minSpeechRms: 0.1);
      gated.push(0.05);
      gated.push(0.05);
      expect(gated.hasSpeech, isFalse);
      gated
        ..push(0.2)
        ..push(0.2)
        ..reset();
      expect(gated.hasSpeech, isFalse);
    });

    test("transcripts are assembled in commit order", () {
      final partials = <String>[];
      final committed = <String>[];
      final assembler = AIDebugVoiceTranscriptAssembler(
        onPartial: partials.add,
        onCommitted: committed.add,
      );
      assembler
        ..committed("a")
        ..committed("b")
        ..delta("a", "use")
        ..delta("b", "Effect");
      expect(partials, ["use", "use Effect"]);
      assembler.completed("b", "Effect ");
      expect(committed, isEmpty);
      expect(assembler.pendingCount, 2);
      assembler.completed("a", " use");
      expect(committed, ["use", "Effect"]);
      expect(assembler.pendingCount, 0);
      // Late events for finished items are ignored.
      assembler.delta("a", "x");
      expect(assembler.pendingCount, 0);
      assembler
        ..committed("c")
        ..failed("c");
      expect(committed, ["use", "Effect", ""]);
      expect(
        AIDebugVoiceProtocol.joinTranscripts(["画面の", " Flutter", "", null]),
        "画面のFlutter",
      );
    });

    test("replacements follow the SamuraiAI rules", () {
      String apply(String text) => AIDebugVoiceProtocol.applyReplacements(
            text,
            const [
              AIDebugSpeechReplacement(from: "フラッター", to: "Flutter"),
              AIDebugSpeechReplacement(from: "フラッターフロー", to: "FlutterFlow"),
              AIDebugSpeechReplacement(from: "ダート", to: "Dart"),
              AIDebugSpeechReplacement(from: "flutter", to: "Flutter"),
            ],
          );
      expect(apply("フラッターフローで"), "FlutterFlowで");
      expect(apply("フラッターダート"), "Flutter Dart");
      expect(apply("フラッターの"), "Flutterの");
      expect(apply("abcフラッター"), "abc Flutter");
      expect(apply("FLUTTER is fluttering"), "Flutter is fluttering");
      expect(apply(""), "");
      expect(
          AIDebugVoiceProtocol.applyReplacements("フラッター", const []), "フラッター");
    });

    test("insertion adds spaces only between ASCII words", () {
      ({String value, int cursor}) insert(
        String value,
        String text, [
        int? start,
        int? end,
      ]) =>
          AIDebugVoiceProtocol.insertTranscript(
            value,
            text,
            start: start,
            end: end,
          );
      expect(insert("use", "Effect"), (value: "use Effect", cursor: 10));
      expect(insert("", "  Flutterの "), (value: "Flutterの", cursor: 8));
      expect(insert("画面で", "Flutter"), (value: "画面でFlutter", cursor: 10));
      expect(insert("ab", "x", 1, 1), (value: "a x b", cursor: 4));
      expect(insert("abc", "設定", 1, 2), (value: "a設定c", cursor: 3));
      expect(insert("abc", "Z", 99), (value: "abc Z", cursor: 5));
      expect(insert("abc", "  ", 1), (value: "abc", cursor: 1));
    });
  });

  group("session", () {
    late _FakeAudioSource audio;
    late _FakeSocket socket;
    late List<String> paths;

    AIDebugVoiceSession createSession({
      List<String>? partials,
      List<String>? committed,
      List<Object>? errors,
      List<AIDebugVoiceState>? states,
      Object? tokenError,
      Map<String, Object?> Function()? token,
    }) {
      return AIDebugVoiceSession(
        controller: _adapter(paths: paths, tokenError: tokenError, token: token)
            .controller,
        audioSource: audio,
        connector: (url, protocols) async {
          socket.url = url;
          socket.protocols = protocols;
          return socket;
        },
        onPartial: partials?.add,
        onCommitted: committed?.add,
        onError: errors?.add,
        onStateChanged: states?.add,
      );
    }

    setUp(() {
      audio = _FakeAudioSource();
      socket = _FakeSocket();
      paths = [];
    });

    test("streams 100 ms chunks, commits turns, and settles on stop", () async {
      final partials = <String>[];
      final committed = <String>[];
      final states = <AIDebugVoiceState>[];
      final session = createSession(
        partials: partials,
        committed: committed,
        states: states,
      );
      final starting = session.start();
      await _settle();
      expect(audio.sampleRate, 24000);
      expect(session.state, AIDebugVoiceState.recording);
      // Speech captured before the connection is buffered.
      audio.chunks100ms(3, loud: true);
      await starting;
      await _settle();
      expect(socket.url.toString(),
          "wss://api.openai.com/v1/realtime?intent=transcription");
      expect(
          socket.protocols, ["realtime", "openai-insecure-api-key.ek_secret"]);
      expect(socket.sent.first["type"], "session.update");
      expect(socket.sent.first["event_id"], "samurai_session_update");
      expect(socket.ofType("input_audio_buffer.append"), hasLength(3));
      for (final message in socket.ofType("input_audio_buffer.append")) {
        expect(base64Decode(message["audio"]! as String).length, 4800);
      }

      // 700 ms of silence ends the turn.
      audio.chunks100ms(7);
      await _settle();
      expect(socket.commits, 1);
      expect(socket.sent.last["type"], "input_audio_buffer.commit");
      socket
        ..committed("i1")
        ..delta("i1", "フラッター");
      await _settle();
      expect(partials.last, "Flutter");
      socket.completed("i1", "フラッターの");
      await _settle();
      expect(committed, ["Flutterの"]);
      expect(partials.last, "");

      // Speech, then stop with 50 ms left over.
      audio.chunks100ms(3, loud: true);
      audio.emit(2400, 0x20);
      await _settle();
      final stopping = session.stop();
      await _settle();
      expect(session.state, AIDebugVoiceState.stopping);
      expect(audio.stops, greaterThanOrEqualTo(1));
      expect(socket.commits, 2);
      final appends = socket.ofType("input_audio_buffer.append").toList();
      expect(base64Decode(appends.last["audio"]! as String).length, 2400);

      socket.committed("i2");
      await _settle();
      expect(session.state, AIDebugVoiceState.stopping);
      socket.completed("i2", "Riverpod");
      await stopping;
      expect(committed, ["Flutterの", "Riverpod"]);
      expect(socket.closed, isTrue);
      expect(session.state, AIDebugVoiceState.idle);
      expect(states, [
        AIDebugVoiceState.connecting,
        AIDebugVoiceState.recording,
        AIDebugVoiceState.stopping,
        AIDebugVoiceState.idle,
      ]);
    });

    test("stop without speech finishes immediately", () async {
      final errors = <Object>[];
      final session = createSession(errors: errors);
      await session.start();
      audio.chunks100ms(2);
      await _settle();
      await session.stop();
      expect(socket.commits, 0);
      expect(errors, isEmpty);
      expect(session.state, AIDebugVoiceState.idle);
      expect(socket.closed, isTrue);
    });

    test("stop before the connection sends the buffered audio", () async {
      final tokenGate = Completer<void>();
      final session = AIDebugVoiceSession(
        controller: AIDebuggerMasamuneAdapter(
          projectId: "voice-test",
          endpoint: "https://ai-debugger.example.test/",
          apiKey: "test-key",
          post: (url, headers, body) async {
            if (Uri.parse(url).path.endsWith("/speech-token")) {
              await tokenGate.future;
              return _tokenJson();
            }
            return {"success": true};
          },
        ).controller,
        audioSource: audio,
        connector: (url, protocols) async => socket,
      );
      unawaited(session.start());
      await _settle();
      audio.chunks100ms(3, loud: true);
      await _settle();
      final stopping = session.stop();
      await _settle();
      expect(session.state, AIDebugVoiceState.stopping);
      expect(socket.sent, isEmpty);
      tokenGate.complete();
      await _settle();
      expect(socket.sent.first["type"], "session.update");
      expect(socket.ofType("input_audio_buffer.append"), hasLength(3));
      expect(socket.sent.last["type"], "input_audio_buffer.commit");
      socket
        ..committed("i1")
        ..completed("i1", "");
      await stopping;
      expect(session.state, AIDebugVoiceState.idle);
    });

    test("audio is resampled when the token rate differs", () async {
      final session = createSession(token: () => _tokenJson(sampleRate: 16000));
      await session.start();
      audio.chunks100ms(1, loud: true);
      await _settle();
      final append = socket.ofType("input_audio_buffer.append").single;
      expect(base64Decode(append["audio"]! as String).length, 3200);
      session.cancel();
      // The next session captures at the rate of the last token.
      final next = createSession();
      await next.start();
      expect(audio.sampleRate, 16000);
      next.cancel();
    });

    test("the noise gate sends quiet chunks as silence", () async {
      final session = createSession(
          token: () => _tokenJson(client: {
                "noiseGateDb": -20,
                "autoStopSilenceSec": 0,
              }));
      await session.start();
      audio.chunks100ms(1);
      await _settle();
      final append = socket.ofType("input_audio_buffer.append").single;
      final bytes = base64Decode(append["audio"]! as String);
      expect(bytes.length, 4800);
      expect(bytes.every((byte) => byte == 0), isTrue);
      session.cancel();
    });

    testWidgets("stop gives up waiting for the transcript after 3 seconds",
        (tester) async {
      final session = createSession();
      await session.start();
      audio.chunks100ms(3, loud: true);
      await tester.pump();
      var done = false;
      unawaited(session.stop().then((_) => done = true));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1));
      expect(socket.commits, 1);
      await tester.pump(const Duration(seconds: 2));
      expect(done, isFalse);
      await tester.pump(const Duration(seconds: 2));
      expect(done, isTrue);
      expect(socket.closed, isTrue);
    });

    testWidgets("stops automatically when the text stops changing",
        (tester) async {
      final errors = <Object>[];
      final session = createSession(
        errors: errors,
        token: () => _tokenJson(client: {"autoStopSilenceSec": 2}),
      );
      await session.start();
      await tester.pump(const Duration(milliseconds: 1500));
      socket.delta("i1", "あ");
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500));
      expect(session.state, AIDebugVoiceState.recording);
      await tester.pump(const Duration(milliseconds: 600));
      expect(session.state, AIDebugVoiceState.stopping);
      await tester.pump(const Duration(seconds: 4));
      expect(session.state, AIDebugVoiceState.idle);
      expect(errors, isEmpty);
    });

    test("ignored errors do not stop the session", () async {
      final errors = <Object>[];
      final session = createSession(errors: errors);
      await session.start();
      socket
        ..receive({
          "type": "error",
          "error": {
            "type": "invalid_request_error",
            "code": "unknown_parameter",
            "event_id": "samurai_session_update",
          },
        })
        ..receive({
          "type": "error",
          "error": {"code": "input_audio_buffer_commit_empty"},
        });
      await _settle();
      expect(errors, isEmpty);
      expect(session.state, AIDebugVoiceState.recording);
      session.cancel();
    });

    test("server errors while recording are reported once", () async {
      final errors = <Object>[];
      final session = createSession(errors: errors);
      await session.start();
      socket.receive({
        "type": "error",
        "error": {
          "type": "invalid_request_error",
          "code": "invalid_value",
          "message": "bad",
        },
      });
      await _settle();
      expect(errors, hasLength(1));
      expect(
        errors.single,
        isA<AIDebugVoiceException>()
            .having((error) => error.code, "code", "invalid_value")
            .having((error) => error.message, "message", "bad"),
      );
      expect(session.state, AIDebugVoiceState.idle);
      expect(socket.closed, isTrue);
      expect(audio.stops, greaterThanOrEqualTo(1));
    });

    test("a closed connection while recording is an error", () async {
      final errors = <Object>[];
      final session = createSession(errors: errors);
      await session.start();
      await socket.incoming.close();
      await _settle();
      expect(
        errors.single,
        isA<AIDebugVoiceException>()
            .having((error) => error.code, "code", "connection_closed"),
      );
      expect(session.state, AIDebugVoiceState.idle);
    });

    test("permission denial stops before requesting a token", () async {
      final errors = <Object>[];
      audio.startError = const AIDebugVoiceException(
        "permission_denied",
        "Microphone permission was denied.",
      );
      final session = createSession(errors: errors);
      await session.start();
      expect(errors.single, isA<AIDebugVoiceException>());
      expect(paths.where((path) => path.endsWith("/speech-token")), isEmpty);
      expect(session.state, AIDebugVoiceState.idle);
    });

    test("token errors are reported and release the microphone", () async {
      final errors = <Object>[];
      final session = createSession(
        errors: errors,
        tokenError: const AIDebugHttpException(412, "not configured"),
      );
      await session.start();
      expect(errors.single, isA<AIDebugHttpException>());
      expect(audio.stops, greaterThanOrEqualTo(1));
      expect(socket.url, isNull);
    });

    test("cancel during the permission prompt still stops the microphone",
        () async {
      audio.startGate = Completer<void>();
      final session = createSession();
      final starting = session.start();
      await Future<void>.delayed(Duration.zero);
      session.cancel();
      final stopsAfterCancel = audio.stops;
      audio.startGate!.complete();
      await starting;
      expect(audio.stops, greaterThan(stopsAfterCancel));
      expect(paths.where((path) => path.endsWith("/speech-token")), isEmpty);
      expect(session.state, AIDebugVoiceState.idle);
    });
  });

  group("overlay", () {
    Future<AIDebuggerMasamuneAdapter> openPanel(
      WidgetTester tester, {
      Object? tokenError,
    }) async {
      final adapter = _adapter(
        paths: [],
        tokenError: tokenError,
        token: () => _tokenJson(client: {
          "autoStopSilenceSec": 0,
          "replacements": [
            {"from": "リバーポッド", "to": "Riverpod"},
          ],
        }),
      );
      await tester.pumpWidget(
        Builder(
          builder: (context) => adapter.onBuildApp(
            context,
            const MaterialApp(home: ColoredBox(color: Colors.blue)),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byIcon(Icons.auto_awesome));
      await tester.pump();
      return adapter;
    }

    testWidgets("the voice button is absent unless compiled in",
        (tester) async {
      final adapter = await openPanel(tester);
      expect(find.text("AI Debugger"), findsOneWidget);
      expect(find.bySemanticsLabel(kAIDebugVoiceInputLabel), findsNothing);
      expect(find.byIcon(Icons.mic), findsNothing);
      await adapter.controller.end();
    }, skip: kAIDebugVoiceEnabled);

    testWidgets("voice input inserts committed text at the cursor",
        (tester) async {
      final audio = _FakeAudioSource();
      final socket = _FakeSocket();
      AIDebugVoiceSession.debugAudioSourceOverride = audio;
      AIDebugVoiceSession.debugConnectorOverride =
          (url, protocols) async => socket;
      final adapter = await openPanel(tester);
      expect(find.bySemanticsLabel(kAIDebugVoiceInputLabel), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.enterText(find.byType(TextField), "画面のbug");
      final field = tester.widget<TextField>(find.byType(TextField));
      field.controller!.selection = const TextSelection.collapsed(offset: 3);
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pump();
      await tester.pump();
      expect(find.byIcon(Icons.stop_circle), findsOneWidget);

      socket
        ..committed("i1")
        ..delta("i1", "リバーポッド");
      await tester.pump();
      expect(find.text("Riverpod"), findsOneWidget);

      socket.completed("i1", "リバーポッド");
      await tester.pump();
      expect(field.controller!.text, "画面のRiverpod bug");
      expect(field.controller!.selection.baseOffset, 12);
      expect(find.text("Riverpod"), findsNothing);

      // Nothing was said after the last turn, so stopping finishes at once.
      await tester.tap(find.byIcon(Icons.stop_circle));
      await tester.pump(const Duration(milliseconds: 10));
      await tester.pump(const Duration(milliseconds: 10));
      expect(socket.commits, 0);
      await tester.pump();
      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(socket.closed, isTrue);
      await adapter.controller.end();
    }, skip: !kAIDebugVoiceEnabled);

    testWidgets("a missing OpenAI key explains where to register it",
        (tester) async {
      AIDebugVoiceSession.debugAudioSourceOverride = _FakeAudioSource();
      AIDebugVoiceSession.debugConnectorOverride =
          (url, protocols) async => _FakeSocket();
      final adapter = await openPanel(
        tester,
        tokenError: const AIDebugHttpException(
          412,
          "not configured",
          code: "not_configured",
        ),
      );
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pump();
      await tester.pump();
      expect(
        find.textContaining("音声入力 で OpenAI の API キー"),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.mic), findsOneWidget);
      await adapter.controller.end();
    }, skip: !kAIDebugVoiceEnabled);
  });
}
