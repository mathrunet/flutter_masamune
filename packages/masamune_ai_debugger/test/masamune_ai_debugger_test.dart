import "dart:typed_data";

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:masamune_ai_debugger/masamune_ai_debugger.dart";

void main() {
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
        calls.add("request:$instruction:${screenshotNames.join(",")}");
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
    expect(calls, contains("request:custom instruction:"));
    expect(calls, contains("events:1"));
    expect(calls,
        contains(contains("incident:exception:Bad state: custom error")));
    expect(calls, contains(startsWith("end:")));
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

  testWidgets("successful manual send closes the AI Debugger panel",
      (tester) async {
    final requests = <String>[];
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "Users-example-app",
      endpoint: "https://ai-debugger.example.test",
      apiKey: "test-key",
      post: (url, headers, body) async {
        final path = Uri.parse(url).path;
        requests.add(path);
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
    expect(requests, contains(endsWith("/request")));
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
