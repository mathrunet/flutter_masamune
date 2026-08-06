import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:masamune_ai_debugger/masamune_ai_debugger.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test("adapter reads the project ID from dart-define by default", () {
    final adapter = AIDebuggerMasamuneAdapter();

    expect(
      adapter.projectId,
      const String.fromEnvironment("MASAMUNE_AI_DEBUGGER_PROJECT_ID"),
    );
  });

  test("an explicit project ID overrides the dart-define", () {
    final adapter = AIDebuggerMasamuneAdapter(projectId: "explicit-project");

    expect(adapter.projectId, "explicit-project");
  });

  test("default SamuraiAI callbacks require a project ID", () async {
    AIDebugController.debugModeOverride = true;
    addTearDown(() => AIDebugController.debugModeOverride = null);
    final controller = AIDebugController(
      projectId: "",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      maxSessionsPerHour: 6,
    );

    await expectLater(
      AIDebuggerMasamuneAdapter.defaultRegisterRun(controller),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          "message",
          "MASAMUNE_AI_DEBUGGER_PROJECT_ID is not configured",
        ),
      ),
    );
  });

  test("one reported error uses only the explicit incident endpoint", () async {
    final requests = <String>[];
    final controller = AIDebugController(
      projectId: "Users-example-app",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      maxSessionsPerHour: 6,
      post: (url, headers, body) async {
        requests.add(Uri.parse(url).path);
        return {"success": true};
      },
    );

    await controller.reportError(StateError("boom"), StackTrace.current);
    await controller.reportError(StateError("boom"), StackTrace.current);

    expect(requests, hasLength(2));
    expect(requests.first, "/api/app-debug/runs");
    expect(requests.last, startsWith("/api/app-debug/runs/app-"));
    expect(requests.last, endsWith("/incidents"));
    expect(requests, isNot(contains(endsWith("/events"))));
  });

  test("foreground heartbeat and end use the same run", () async {
    final requests = <String>[];
    final controller = AIDebugController(
      projectId: "Users-example-app",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      maxSessionsPerHour: 6,
      post: (url, headers, body) async {
        requests.add(Uri.parse(url).path);
        return {"success": true};
      },
    );

    final runId = controller.runId;
    await controller.resume();
    controller.pause();
    await controller.end();
    await controller.end();

    expect(requests, [
      "/api/app-debug/runs",
      "/api/app-debug/runs/$runId/heartbeat",
      "/api/app-debug/runs/$runId/end",
    ]);
  });

  test("failed registration can be retried", () async {
    var registrationAttempts = 0;
    final controller = AIDebugController(
      projectId: "Users-example-app",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      maxSessionsPerHour: 6,
      post: (url, headers, body) async {
        if (Uri.parse(url).path == "/api/app-debug/runs") {
          registrationAttempts += 1;
          if (registrationAttempts == 1) throw StateError("offline");
        }
        return {"success": true};
      },
    );

    await expectLater(controller.register(), throwsStateError);
    await controller.register();

    expect(registrationAttempts, 2);
  });

  test("expired heartbeat rotates the run and registers again", () async {
    final requests = <String>[];
    var heartbeatAttempts = 0;
    final controller = AIDebugController(
      projectId: "Users-example-app",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      maxSessionsPerHour: 6,
      post: (url, headers, body) async {
        final path = Uri.parse(url).path;
        requests.add(path);
        if (path.endsWith("/heartbeat") && heartbeatAttempts++ == 0) {
          throw const AIDebugHttpException(410, "stopped");
        }
        return {"success": true};
      },
    );

    final expiredRunId = controller.runId;
    await controller.heartbeat();

    expect(controller.runId, isNot(expiredRunId));
    expect(
        requests.where((path) => path == "/api/app-debug/runs"), hasLength(2));
    expect(requests, contains("/api/app-debug/runs/$expiredRunId/heartbeat"));
    expect(requests.last, "/api/app-debug/runs/${controller.runId}/heartbeat");
  });

  test("custom callbacks work without SamuraiAI configuration", () async {
    final calls = <String>[];
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "custom-project",
      contextProvider: () => const AIDebugContextSnapshot(
        pageName: "CustomPage",
        values: {"count": 3},
      ),
      registerRun: (controller) async {
        calls.add("register:${controller.runId}");
      },
      heartbeat: (controller) async {
        calls.add("heartbeat:${controller.runId}");
      },
      endRun: (controller) async {
        calls.add("end:${controller.runId}");
      },
      uploadScreenshot: (controller, bytes, {required name}) async {
        calls.add("screenshot:$name:${bytes.length}");
        return "custom-screenshot";
      },
      sendRequest: (controller, instruction, screenshotNames) async {
        calls.add(
          "request:$instruction:${screenshotNames.join(",")}:${controller.currentContext?.pageName}",
        );
        return "custom-session";
      },
      reportIncident: (
        controller, {
        required kind,
        required message,
        required stackTrace,
        required timestamp,
        required metadata,
      }) async {
        calls.add("incident:$kind:$message");
      },
      uploadEvents: (controller, events) async {
        calls.add("events:${events.length}");
      },
    );
    final controller = adapter.controller;

    await controller.resume();
    controller.pause();
    expect(
      await controller.upload(Uint8List.fromList([1, 2, 3]), name: "image.png"),
      "custom-screenshot",
    );
    expect(await controller.send("custom instruction", const []),
        "custom-session");
    controller.addLog("custom-log", const {"value": 1});
    await controller.flushLogs();
    await controller.reportError(
        StateError("custom error"), StackTrace.current);
    await controller.end();

    expect(calls.where((call) => call.startsWith("register:")), hasLength(1));
    expect(calls, contains(startsWith("heartbeat:")));
    expect(calls, contains("screenshot:image.png:3"));
    expect(calls, contains("request:custom instruction::CustomPage"));
    expect(calls, contains("events:1"));
    expect(calls,
        contains(contains("incident:exception:Bad state: custom error")));
    expect(calls, contains(startsWith("end:")));
  });

  test("disabled debug mode prevents controller communication", () async {
    final calls = <String>[];
    AIDebugController.debugModeOverride = false;
    addTearDown(() => AIDebugController.debugModeOverride = null);
    final controller = AIDebugController(
      projectId: "Users-example-app",
      endpoint: "",
      apiKey: "",
      maxSessionsPerHour: 6,
      registerRun: (_) async => calls.add("register"),
      heartbeatCallback: (_) async => calls.add("heartbeat"),
      endRun: (_) async => calls.add("end"),
      uploadScreenshot: (_, __, {required name}) async {
        calls.add("upload");
        return name;
      },
      sendRequest: (_, __, ___) async {
        calls.add("send");
        return "session";
      },
      reportIncident: (
        _, {
        required kind,
        required message,
        required stackTrace,
        required timestamp,
        required metadata,
      }) async =>
          calls.add("incident"),
      uploadEvents: (_, __) async => calls.add("events"),
    );

    await controller.register();
    await controller.resume();
    await controller.heartbeat();
    expect(
      await controller.upload(Uint8List.fromList([1]), name: "image.png"),
      isEmpty,
    );
    expect(await controller.send("instruction", const []), isNull);
    await controller.reportError(StateError("boom"), StackTrace.current);
    await controller.reportPerformanceTrace(
      category: "model_load",
      traceName: "ExampleModel.load",
      startedAt: DateTime.now(),
      elapsed: const Duration(seconds: 6),
      threshold: const Duration(seconds: 5),
    );
    controller.addLog("event", const {"value": 1});
    await controller.flushLogs();
    await controller.end();

    await AIDebuggerMasamuneAdapter.defaultRegisterRun(controller);
    expect(
      await AIDebuggerMasamuneAdapter.defaultUploadScreenshot(
        controller,
        Uint8List.fromList([1]),
        name: "image.png",
      ),
      isEmpty,
    );
    expect(
      await AIDebuggerMasamuneAdapter.defaultSendRequest(
        controller,
        "instruction",
        const [],
      ),
      isNull,
    );
    expect(calls, isEmpty);
  });

  test("settings persist per project", () async {
    final first = AIDebugController(
      projectId: "Users-example-settings-a",
      endpoint: "",
      apiKey: "",
      maxSessionsPerHour: 6,
    );
    const saved = AIDebugSettings(
      manualModel: AIDebugModel.mythos,
      manualPermissionMode: AIDebugPermissionMode.bypassPermissions,
      errorModel: AIDebugModel.opus,
      errorPermissionMode: AIDebugPermissionMode.bypassPermissions,
      performanceModel: AIDebugModel.haiku,
      modelLoadTimeout: Duration(milliseconds: 2500),
      indicatorTimeout: Duration(seconds: 17),
    );
    await first.updateSettings(saved);

    final restored = await AIDebugController(
      projectId: "Users-example-settings-a",
      endpoint: "",
      apiKey: "",
      maxSessionsPerHour: 6,
    ).loadSettings();
    final otherProject = await AIDebugController(
      projectId: "Users-example-settings-b",
      endpoint: "",
      apiKey: "",
      maxSessionsPerHour: 6,
    ).loadSettings();

    expect(restored.manualModel, AIDebugModel.mythos);
    expect(
      restored.manualPermissionMode,
      AIDebugPermissionMode.bypassPermissions,
    );
    expect(restored.errorModel, AIDebugModel.opus);
    expect(restored.performanceModel, AIDebugModel.haiku);
    expect(restored.modelLoadTimeout, const Duration(milliseconds: 2500));
    expect(restored.indicatorTimeout, const Duration(seconds: 17));
    expect(otherProject.manualModel, AIDebugModel.opus);
  });

  test("manual and incident requests include selected model and mode",
      () async {
    final requests = <MapEntry<String, Map<String, Object?>>>[];
    final controller = AIDebugController(
      projectId: "Users-example-options",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      maxSessionsPerHour: 6,
      contextProvider: () => const AIDebugContextSnapshot(
        pageName: "CheckoutPage",
        route: "/checkout",
        values: {
          "cartCount": 2,
          "apiToken": "must-not-leak",
          "email": "customer@example.com",
        },
      ),
      settings: const AIDebugSettings(
        errorModel: AIDebugModel.opus,
        errorPermissionMode: AIDebugPermissionMode.bypassPermissions,
      ),
      post: (url, headers, body) async {
        requests.add(MapEntry(Uri.parse(url).path, body));
        return {"success": true};
      },
    );

    await controller.send(
      "manual",
      const [],
      model: AIDebugModel.mythos,
      permissionMode: AIDebugPermissionMode.bypassPermissions,
    );
    await controller.reportError(StateError("configured"), StackTrace.current);

    final manual = requests.singleWhere(
      (request) => request.key.endsWith("/request"),
    );
    final incident = requests.singleWhere(
      (request) => request.key.endsWith("/incidents"),
    );
    expect(manual.value["model"], "mythos");
    expect(manual.value["permissionMode"], "bypassPermissions");
    expect(incident.value["model"], "opus");
    expect(incident.value["permissionMode"], "bypassPermissions");
    for (final request in [manual, incident]) {
      final context = request.value["context"] as Map<String, Object?>;
      expect(context["pageName"], "CheckoutPage");
      expect(context["route"], "/checkout");
      final values = context["values"] as Map<String, Object?>;
      expect(values["cartCount"], 2);
      expect(values["apiToken"], "[REDACTED]");
      expect(values["email"], "[REDACTED_EMAIL]");
    }
  });

  test("context provider failures do not block a manual request", () async {
    final requests = <Map<String, Object?>>[];
    final controller = AIDebugController(
      projectId: "Users-example-context-failure",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      maxSessionsPerHour: 6,
      contextProvider: () => throw StateError("context unavailable"),
      post: (url, headers, body) async {
        if (Uri.parse(url).path.endsWith("/request")) requests.add(body);
        return {"success": true, "sessionId": "session-test"};
      },
    );

    expect(await controller.send("manual", const []), "session-test");
    expect(requests, hasLength(1));
    expect(requests.single.containsKey("context"), isFalse);
  });

  test("slow model trace reports one performance incident", () async {
    final requests = <MapEntry<String, Map<String, Object?>>>[];
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "Users-example-app",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      modelLoadTimeout: const Duration(milliseconds: 5),
      indicatorTimeout: const Duration(seconds: 1),
      post: (url, headers, body) async {
        requests.add(MapEntry(Uri.parse(url).path, body));
        return {"success": true};
      },
    );
    final trace = adapter.loggerAdapters.single.trace(
      "katana.model.load|document|load|ExampleModel",
    );
    final startedAt = DateTime.now();

    await trace.start(startedAt);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    await trace.stop(startedAt, DateTime.now());
    await Future<void>.delayed(const Duration(milliseconds: 10));

    final incidents = requests.where(
      (request) => request.key.endsWith("/incidents"),
    );
    expect(incidents, hasLength(1));
    expect(incidents.single.value["kind"], "performance");
    expect(
      (incidents.single.value["metadata"] as Map)["category"],
      "model_load",
    );
    await adapter.controller.end();
  });

  test("completed indicator trace cancels its performance timer", () async {
    final requests = <String>[];
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "Users-example-app",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      modelLoadTimeout: const Duration(seconds: 1),
      indicatorTimeout: const Duration(milliseconds: 30),
      post: (url, headers, body) async {
        requests.add(Uri.parse(url).path);
        return {"success": true};
      },
    );
    final trace = adapter.loggerAdapters.single.trace(
      "katana.indicator.show|ExamplePage.load@package:example/page.dart",
    );
    final startedAt = DateTime.now();

    await trace.start(startedAt);
    await trace.stop(startedAt, DateTime.now());
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(requests.where((path) => path.endsWith("/incidents")), isEmpty);
    await adapter.controller.end();
  });

  testWidgets("debug toggle opens the AI Debugger panel and stays on screen",
      (tester) async {
    final adapter = AIDebuggerMasamuneAdapter(projectId: "Users-example-app");
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => adapter.onBuildApp(
            context,
            const ColoredBox(color: Colors.blue),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    await tester.tap(find.byIcon(Icons.auto_awesome));
    await tester.pump();
    expect(find.text("AI Debugger"), findsOneWidget);
    expect(find.byIcon(Icons.screenshot_monitor), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.bySemanticsLabel("不具合修正"), findsOneWidget);
    expect(find.byIcon(Icons.bug_report), findsOneWidget);
    expect(find.bySemanticsLabel("Mode Plan"), findsOneWidget);
    expect(find.bySemanticsLabel("Model Opus"), findsOneWidget);
    expect(find.byIcon(Icons.send), findsOneWidget);
    final textField = tester.widget<TextField>(find.byType(TextField));
    expect(textField.textAlignVertical, TextAlignVertical.top);
    expect(textField.style?.fontSize, 14);
    expect(
      tester.getSize(find.byType(TextField)).height,
      greaterThanOrEqualTo(160),
    );

    await tester.drag(find.text("AI Debugger"), const Offset(2000, 2000));
    await tester.pump();
    final panel = tester.getRect(find.text("AI Debugger"));
    expect(panel.right, lessThanOrEqualTo(800));
    expect(panel.bottom, lessThanOrEqualTo(600));
  });

  testWidgets("settings dialog edits and persists incident settings",
      (tester) async {
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "Users-example-settings-widget",
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
    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();

    expect(find.text("AI Debugger設定"), findsOneWidget);
    expect(find.text("エラー時"), findsOneWidget);
    expect(find.text("計測超過時"), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, "Opus").first);
    await tester.tap(
      find.widgetWithText(ChoiceChip, "bypassPermissions").first,
    );
    final timeoutFields = find.byType(TextField);
    await tester.enterText(timeoutFields.at(1), "7.5");
    await tester.enterText(timeoutFields.at(2), "12");
    await tester.tap(find.widgetWithText(FilledButton, "保存"));
    await tester.pumpAndSettle();

    final settings = adapter.controller.settings;
    expect(settings.errorModel, AIDebugModel.opus);
    expect(
      settings.errorPermissionMode,
      AIDebugPermissionMode.bypassPermissions,
    );
    expect(settings.modelLoadTimeout, const Duration(milliseconds: 7500));
    expect(settings.indicatorTimeout, const Duration(seconds: 12));
  });

  testWidgets("successful manual send closes the AI Debugger panel",
      (tester) async {
    final requests = <MapEntry<String, Map<String, Object?>>>[];
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "Users-example-app",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      post: (url, headers, body) async {
        final path = Uri.parse(url).path;
        requests.add(MapEntry(path, body));
        if (path.endsWith("/request")) {
          return {"success": true, "sessionId": "session-test"};
        }
        return {"success": true};
      },
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => adapter.onBuildApp(
            context,
            const ColoredBox(color: Colors.blue),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.auto_awesome));
    await tester.pump();
    await tester.enterText(find.byType(TextField), "調査してください");
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.text("AI Debugger"), findsNothing);
    expect(find.byIcon(Icons.auto_awesome), findsOneWidget);
    final request = requests.singleWhere(
      (request) => request.key.endsWith("/request"),
    );
    expect(request.value["instruction"], "調査してください");
    final context = request.value["context"] as Map<String, Object?>;
    expect(context["widgetTree"], contains("ColoredBox"));
    await adapter.controller.end();
  });

  testWidgets("created incident sessions show a temporary notification",
      (tester) async {
    var sessionCreated = true;
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "Users-example-incident-notification",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      post: (url, headers, body) async {
        if (Uri.parse(url).path.endsWith("/incidents")) {
          return {
            "success": true,
            "sessionCreated": sessionCreated,
            "sessionId": sessionCreated ? "incident-session" : null,
          };
        }
        return {"success": true};
      },
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => adapter.onBuildApp(
            context,
            const ColoredBox(color: Colors.blue),
          ),
        ),
      ),
    );
    await tester.pump();

    await AIDebuggerMasamuneAdapter.defaultConfiguredReportIncident(
      adapter.controller,
      kind: "exception",
      message: "boom",
      stackTrace: "stack",
      timestamp: DateTime.now(),
      metadata: const {},
      model: AIDebugModel.opus,
      permissionMode: AIDebugPermissionMode.plan,
    );
    await tester.pump();
    expect(
      find.text("想定外エラーを検出し、AIセッションを作成しました"),
      findsOneWidget,
    );

    await tester.pump(const Duration(seconds: 4));
    expect(
      find.text("想定外エラーを検出し、AIセッションを作成しました"),
      findsNothing,
    );

    sessionCreated = false;
    await AIDebuggerMasamuneAdapter.defaultConfiguredReportIncident(
      adapter.controller,
      kind: "exception",
      message: "deduplicated",
      stackTrace: "stack",
      timestamp: DateTime.now(),
      metadata: const {},
      model: AIDebugModel.opus,
      permissionMode: AIDebugPermissionMode.plan,
    );
    await tester.pump();
    expect(
      find.text("想定外エラーを検出し、AIセッションを作成しました"),
      findsNothing,
    );

    sessionCreated = true;
    await AIDebuggerMasamuneAdapter.defaultConfiguredReportIncident(
      adapter.controller,
      kind: "performance",
      message: "slow trace",
      stackTrace: "",
      timestamp: DateTime.now(),
      metadata: const {"thresholdMs": 5000},
      model: AIDebugModel.sonnet,
      permissionMode: AIDebugPermissionMode.plan,
    );
    await tester.pump();
    expect(
      find.text("処理時間のしきい値超過を検出し、AIセッションを作成しました"),
      findsOneWidget,
    );
    await tester.pump(const Duration(seconds: 4));
    await adapter.controller.end();
  });

  testWidgets("requirements edit send prepends the kiwame edit command",
      (tester) async {
    final requests = <MapEntry<String, Map<String, Object?>>>[];
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "Users-example-requirements-edit",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      post: (url, headers, body) async {
        requests.add(MapEntry(Uri.parse(url).path, body));
        return {"success": true, "sessionId": "session-test"};
      },
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => adapter.onBuildApp(
            context,
            const ColoredBox(color: Colors.blue),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byIcon(Icons.auto_awesome));
    await tester.pump();
    await tester.tap(find.bySemanticsLabel("不具合修正"));
    await tester.pump();

    expect(find.bySemanticsLabel("要件修正"), findsOneWidget);
    expect(find.byIcon(Icons.edit_note), findsOneWidget);

    await tester.enterText(find.byType(TextField), "要件を変更してください");
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    final request = requests.singleWhere(
      (request) => request.key.endsWith("/request"),
    );
    expect(
      request.value["instruction"],
      "/dev:kiwame:edit\n\n要件を変更してください",
    );
    await adapter.controller.end();
  });

  testWidgets("long pressing the toggle captures a screenshot before opening",
      (tester) async {
    final adapter = AIDebuggerMasamuneAdapter(projectId: "Users-example-app");
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => adapter.onBuildApp(
            context,
            const ColoredBox(color: Colors.blue),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.longPress(find.byIcon(Icons.auto_awesome));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();

    expect(find.text("AI Debugger"), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
