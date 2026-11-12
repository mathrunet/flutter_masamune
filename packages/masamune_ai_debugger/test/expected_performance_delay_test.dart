import "package:flutter_test/flutter_test.dart";
import "package:masamune_ai_debugger/masamune_ai_debugger.dart";
import "package:shared_preferences/shared_preferences.dart";

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test("run registration preserves explicit flavor", () async {
    final requests = <Map<String, Object?>>[];
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "flavor-test",
      endpoint: "https://example.test",
      apiKey: "test",
      flavor: "test",
      post: (url, headers, body) async {
        requests.add(body);
        return {"success": true};
      },
    );
    await adapter.controller.resume();
    expect(requests.first["flavor"], "test");
    await adapter.controller.end();
  });

  test("expected delay is scoped and monitoring resumes", () async {
    final incidents = <String>[];
    var expected = true;
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "expected-delay-test",
      modelLoadTimeout: const Duration(milliseconds: 20),
      registerRun: (_) async {},
      uploadEvents: (_, __) async {},
      reportIncident: (_,
              {required kind,
              required message,
              required stackTrace,
              required timestamp,
              required metadata}) async =>
          incidents.add(message),
    );
    late final dynamic trace;
    final started = DateTime.now();
    await AIDebuggerMasamuneAdapter.runWithExpectedPerformanceDelay(() async {
      trace = adapter.loggerAdapters.single.trace(
        "katana.model.load|document|load|Held",
      );
      await trace.start(started);
    }, isExpected: (name) => expected && name.endsWith("Held"));
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(incidents, isEmpty);
    expected = false;
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(incidents, hasLength(1));
    await trace.stop(started, DateTime.now());
    await adapter.controller.end();
  });

  test("unrelated slow traces still report while a fixture is held", () async {
    final incidents = <String>[];
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "unrelated-delay-test",
      modelLoadTimeout: const Duration(milliseconds: 20),
      registerRun: (_) async {},
      uploadEvents: (_, __) async {},
      reportIncident: (_,
              {required kind,
              required message,
              required stackTrace,
              required timestamp,
              required metadata}) async =>
          incidents.add(message),
    );
    final trace = adapter.loggerAdapters.single.trace(
      "katana.model.load|document|load|Other",
    );
    final started = DateTime.now();
    await trace.start(started);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(incidents, hasLength(1));
    await trace.stop(started, DateTime.now());
    await adapter.controller.end();
  });

  test("concurrent documents with the same trace name are independent",
      () async {
    final incidents = <String>[];
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "parallel-documents-test",
      modelLoadTimeout: const Duration(milliseconds: 20),
      registerRun: (_) async {},
      uploadEvents: (_, __) async {},
      reportIncident: (_,
              {required kind,
              required message,
              required stackTrace,
              required timestamp,
              required metadata}) async =>
          incidents.add(message),
    );
    const name = "katana.model.load|document|load|_StatsDocument";
    final started = DateTime.now();
    late final dynamic held;
    await AIDebuggerMasamuneAdapter.runWithExpectedPerformanceDelay(() async {
      held = adapter.loggerAdapters.single.trace(name);
      await held.start(started);
    }, isExpected: (name) => true);
    final other = adapter.loggerAdapters.single.trace(name);
    await other.start(started);
    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(incidents, hasLength(1));
    await held.stop(started, DateTime.now());
    await other.stop(started, DateTime.now());
    await adapter.controller.end();
  });

  test("released expected trace does not leave a timer", () async {
    final incidents = <String>[];
    final adapter = AIDebuggerMasamuneAdapter(
      projectId: "released-delay-test",
      modelLoadTimeout: const Duration(milliseconds: 20),
      registerRun: (_) async {},
      uploadEvents: (_, __) async {},
      reportIncident: (_,
              {required kind,
              required message,
              required stackTrace,
              required timestamp,
              required metadata}) async =>
          incidents.add(message),
    );
    late final dynamic trace;
    final started = DateTime.now();
    await AIDebuggerMasamuneAdapter.runWithExpectedPerformanceDelay(() async {
      trace = adapter.loggerAdapters.single.trace(
        "katana.model.load|document|load|Held",
      );
      await trace.start(started);
    }, isExpected: (_) => true);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    await trace.stop(started, DateTime.now());
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(incidents, isEmpty);
    await adapter.controller.end();
  });
}
