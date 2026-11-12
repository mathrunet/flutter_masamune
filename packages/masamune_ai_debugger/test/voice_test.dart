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
  Object? startError;
  Completer<void>? startGate;

  @override
  Stream<Uint8List> get chunks => controller.stream;

  @override
  Future<void> start() async {
    starts += 1;
    await startGate?.future;
    final error = startError;
    if (error != null) throw error;
  }

  @override
  Future<void> stop() async {
    stops += 1;
  }

  void emit(int length, [int value = 1]) =>
      controller.add(Uint8List(length)..fillRange(0, length, value));
}

class _FakeSocket implements AIDebugVoiceSocket {
  final StreamController<Object?> incoming = StreamController<Object?>();
  final List<Map<String, Object?>> sent = [];
  Uri? url;
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
}

Map<String, Object?> _tokenJson({List<String> library = const ["Riverpod"]}) =>
    {
      "success": true,
      "url": "wss://api.elevenlabs.io/v1/speech-to-text/realtime?token=t",
      "modelId": "scribe_v3_live",
      "sampleRate": 16000,
      "keytermCount": 3,
      "keytermLibrary": library,
      "skippedKeyterms": 0,
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

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    AIDebugVoiceSession.debugAudioSourceOverride = null;
    AIDebugVoiceSession.debugConnectorOverride = null;
  });

  group("speech token", () {
    test("parses the SamuraiAI response", () {
      final token = AIDebugSpeechToken.fromJson(_tokenJson(
        library: ["Flutter", "", "useEffect"],
      ));
      expect(token.url, startsWith("wss://"));
      expect(token.modelId, "scribe_v3_live");
      expect(token.sampleRate, 16000);
      expect(token.keytermLibrary, ["Flutter", "useEffect"]);
      expect(token.expiresAt, DateTime.utc(2026, 11, 12, 10));
      expect(
        () => AIDebugSpeechToken.fromJson(const {"success": true}),
        throwsFormatException,
      );
    });

    test("registers the run and posts to the speech-token endpoint", () async {
      final paths = <String>[];
      final adapter = _adapter(paths: paths);
      final token = await adapter.controller.requestSpeechToken();
      expect(token.keytermLibrary, ["Riverpod"]);
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
          "ElevenLabs API key is not configured",
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
    test("audio chunks carry keyterms only when given", () {
      final first = AIDebugVoiceProtocol.buildAudioChunk(
        [1, 0, 2, 0],
        sampleRate: 16000,
        keytermLibrary: ["Riverpod"],
      );
      expect(first, {
        "message_type": "input_audio_chunk",
        "audio_base_64": base64Encode([1, 0, 2, 0]),
        "commit": false,
        "sample_rate": 16000,
        "keyterm_library": ["Riverpod"],
      });
      final last = AIDebugVoiceProtocol.buildAudioChunk(
        [0, 0],
        sampleRate: 16000,
        commit: true,
        keytermLibrary: const [],
      );
      expect(last.containsKey("keyterm_library"), isFalse);
      expect(last["commit"], isTrue);
      expect(AIDebugVoiceProtocol.chunkBytes(16000), 3200);
    });

    test("server messages are classified", () {
      AIDebugVoiceMessage parse(Map<String, Object?> json) =>
          AIDebugVoiceProtocol.parse(jsonEncode(json));
      expect(
        parse({"message_type": "session_started"}).type,
        AIDebugVoiceMessageType.started,
      );
      final partial =
          parse({"message_type": "partial_transcript", "text": "Flu"});
      expect(partial.type, AIDebugVoiceMessageType.partial);
      expect(partial.text, "Flu");
      for (final kind in [
        "committed_transcript",
        "committed_transcript_with_timestamps",
      ]) {
        final committed = parse({"message_type": kind, "text": "Flutter"});
        expect(committed.type, AIDebugVoiceMessageType.committed);
        expect(committed.text, "Flutter");
      }
      final error = parse({"message_type": "quota_exceeded", "error": "x"});
      expect(error.type, AIDebugVoiceMessageType.error);
      expect(error.code, "quota_exceeded");
      expect(error.text, "x");
      expect(
        parse({"message_type": "auth_error"}).text,
        "auth_error",
      );
      expect(
        AIDebugVoiceProtocol.parse("not json").type,
        AIDebugVoiceMessageType.other,
      );
      expect(
        parse({"message_type": "unknown"}).type,
        AIDebugVoiceMessageType.other,
      );
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
      Object? tokenError,
    }) {
      return AIDebugVoiceSession(
        controller: _adapter(paths: paths, tokenError: tokenError).controller,
        audioSource: audio,
        connector: (url) async {
          socket.url = url;
          return socket;
        },
        onPartial: partials?.add,
        onCommitted: committed?.add,
        onError: errors?.add,
      );
    }

    setUp(() {
      audio = _FakeAudioSource();
      socket = _FakeSocket();
      paths = [];
    });

    test("streams 100 ms chunks and commits the rest on stop", () async {
      final partials = <String>[];
      final committed = <String>[];
      final states = <AIDebugVoiceState>[];
      final tracked = AIDebugVoiceSession(
        controller: _adapter(paths: paths).controller,
        audioSource: audio,
        connector: (url) async {
          socket.url = url;
          return socket;
        },
        onPartial: partials.add,
        onCommitted: committed.add,
        onStateChanged: states.add,
      );
      final starting = tracked.start();
      // Speech captured before the connection is buffered.
      audio.emit(1000);
      await starting;
      expect(tracked.state, AIDebugVoiceState.recording);
      expect(socket.url.toString(), startsWith("wss://api.elevenlabs.io"));
      audio.emit(6000);
      await Future<void>.delayed(Duration.zero);
      expect(socket.sent, hasLength(2));
      expect(socket.sent[0]["keyterm_library"], ["Riverpod"]);
      expect(socket.sent[1].containsKey("keyterm_library"), isFalse);
      for (final message in socket.sent) {
        expect(base64Decode(message["audio_base_64"]! as String).length, 3200);
        expect(message["commit"], isFalse);
        expect(message["sample_rate"], 16000);
      }

      socket.receive({"message_type": "partial_transcript", "text": "Flu"});
      await Future<void>.delayed(Duration.zero);
      expect(partials.last, "Flu");

      final stopping = tracked.stop();
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      expect(tracked.state, AIDebugVoiceState.stopping);
      expect(audio.stops, greaterThanOrEqualTo(1));
      final last = socket.sent.last;
      expect(last["commit"], isTrue);
      expect(base64Decode(last["audio_base_64"]! as String).length, 600);

      socket
          .receive({"message_type": "committed_transcript", "text": "Flutter"});
      await stopping;
      expect(committed, ["Flutter"]);
      expect(partials.last, "");
      expect(socket.closed, isTrue);
      expect(tracked.state, AIDebugVoiceState.idle);
      expect(states, [
        AIDebugVoiceState.connecting,
        AIDebugVoiceState.recording,
        AIDebugVoiceState.stopping,
        AIDebugVoiceState.idle,
      ]);
    });

    test("stop without remaining audio commits 100 ms of silence", () async {
      final errors = <Object>[];
      final session = createSession(errors: errors);
      await session.start();
      final stopping = session.stop();
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);
      final last = socket.sent.single;
      final audioBytes = base64Decode(last["audio_base_64"]! as String);
      expect(audioBytes.length, 3200);
      expect(audioBytes.every((byte) => byte == 0), isTrue);
      expect(last["commit"], isTrue);
      expect(last["keyterm_library"], ["Riverpod"]);
      // No speech: the server reports insufficient audio, which is not shown.
      socket.receive({"message_type": "insufficient_audio_activity"});
      await stopping;
      expect(errors, isEmpty);
      expect(session.state, AIDebugVoiceState.idle);
    });

    testWidgets("stop gives up waiting for the transcript after 3 seconds",
        (tester) async {
      final session = createSession();
      await session.start();
      var done = false;
      unawaited(session.stop().then((_) => done = true));
      await tester.pump(const Duration(seconds: 2));
      expect(done, isFalse);
      await tester.pump(const Duration(seconds: 2));
      expect(done, isTrue);
      expect(socket.closed, isTrue);
    });

    test("server errors while recording are reported once", () async {
      final errors = <Object>[];
      final session = createSession(errors: errors);
      await session.start();
      socket.receive({"message_type": "quota_exceeded", "error": "quota"});
      await Future<void>.delayed(Duration.zero);
      expect(errors, hasLength(1));
      expect(
        errors.single,
        isA<AIDebugVoiceException>()
            .having((error) => error.code, "code", "quota_exceeded"),
      );
      expect(session.state, AIDebugVoiceState.idle);
      expect(socket.closed, isTrue);
      expect(audio.stops, greaterThanOrEqualTo(1));
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
      final adapter = _adapter(paths: [], tokenError: tokenError);
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
      AIDebugVoiceSession.debugConnectorOverride = (url) async => socket;
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
          .receive({"message_type": "partial_transcript", "text": "Riverpod"});
      await tester.pump();
      expect(find.text("Riverpod"), findsOneWidget);

      socket.receive(
          {"message_type": "committed_transcript", "text": "Riverpod"});
      await tester.pump();
      expect(field.controller!.text, "画面のRiverpod bug");
      expect(field.controller!.selection.baseOffset, 12);
      expect(find.text("Riverpod"), findsNothing);

      await tester.tap(find.byIcon(Icons.stop_circle));
      await tester.pump(const Duration(milliseconds: 10));
      await tester.pump(const Duration(milliseconds: 10));
      expect(socket.sent.last["commit"], isTrue);
      socket.receive({"message_type": "committed_transcript", "text": ""});
      await tester.pump();
      await tester.pump();
      expect(find.byIcon(Icons.mic), findsOneWidget);
      expect(socket.closed, isTrue);
      await adapter.controller.end();
    }, skip: !kAIDebugVoiceEnabled);

    testWidgets("a missing ElevenLabs key explains where to register it",
        (tester) async {
      AIDebugVoiceSession.debugAudioSourceOverride = _FakeAudioSource();
      AIDebugVoiceSession.debugConnectorOverride = (url) async => _FakeSocket();
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
      expect(find.textContaining("ElevenLabs"), findsOneWidget);
      expect(find.byIcon(Icons.mic), findsOneWidget);
      await adapter.controller.end();
    }, skip: !kAIDebugVoiceEnabled);
  });
}
