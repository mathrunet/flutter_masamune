import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:masamune_logger_firebase/masamune_logger_firebase.dart";
import "package:test/test.dart";
import "package:masamune/masamune.dart";

class _Analytics implements FirebaseAnalytics {
  final events = <({String name, Map<String, Object>? parameters})>[];
  int tutorials = 0;

  @override
  Future<void> logEvent(
      {required String name,
      Map<String, Object>? parameters,
      List<AnalyticsEventItem>? items,
      AnalyticsCallOptions? callOptions}) async {
    events.add((name: name, parameters: parameters));
  }

  @override
  Future<void> logTutorialBegin(
      {Map<String, Object>? parameters,
      AnalyticsCallOptions? callOptions}) async {
    tutorials++;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Crashlytics implements FirebaseCrashlytics {
  Object? error;
  StackTrace? trace;
  @override
  Future<void> recordError(dynamic exception, StackTrace? stack,
      {dynamic reason,
      Iterable<Object> information = const [],
      bool? printDetails,
      bool fatal = false}) async {
    error = exception as Object;
    trace = stack;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Goal extends Loggable {
  const _Goal();
  @override
  String get name => "goal_completed";
  @override
  Map<String, dynamic> toJson() => {"count": 2};
}

void main() {
  late _Analytics analytics;
  late Logger logger;
  setUp(() {
    analytics = _Analytics();
    TestLoggerAdapterScope.setTestAdapters(
        [FirebaseLoggerAdapter(analytics: analytics)]);
    logger = Logger();
  });
  tearDown(() => TestLoggerAdapterScope.setTestAdapters([]));

  test("sendRawData forwards custom event with typed parameters", () async {
    await logger.sendRawData("goal_completed",
        parameters: {"count": 2, "score": 1.5, "variant": "control"});
    expect(analytics.events, hasLength(1));
    expect(analytics.events.single.name, "goal_completed");
    expect(analytics.events.single.parameters,
        {"count": 2, "score": 1.5, "variant": "control"});
  });
  test("Loggable uses its explicit event name", () async {
    await logger.send(const _Goal());
    expect(analytics.events.single.name, "goal_completed");
  });
  test("caught errors use Crashlytics and preserve the original error",
      () async {
    final crash = _Crashlytics();
    TestLoggerAdapterScope.setTestAdapters([
      FirebaseLoggerAdapter(analytics: analytics, crashlytics: crash),
    ]);
    final error = StateError("boom");
    final trace = StackTrace.current;
    await logger.error(error, trace);
    expect(identical(crash.error, error), isTrue);
    expect(identical(crash.trace, trace), isTrue);
    expect(analytics.events, isEmpty);
  });

  test("dedicated events are not duplicated", () async {
    await logger.send(const FirebaseAnalyticsTutorialStartLoggable());
    expect(analytics.tutorials, 1);
    expect(analytics.events, isEmpty);
  });
  for (final name in [
    "",
    "a.b",
    "2event",
    "firebase_custom",
    "google_custom",
    "ga_custom",
    "a" * 41
  ]) {
    test("invalid event name is rejected: $name", () async {
      await expectLater(logger.sendRawData(name), throwsArgumentError);
      expect(analytics.events, isEmpty);
    });
  }
  for (final value in [
    true,
    null,
    [1],
    {"x": 1},
    double.nan
  ]) {
    test("invalid parameter value is rejected: $value", () async {
      await expectLater(
          logger.sendRawData("goal", parameters: {"value": value}),
          throwsArgumentError);
      expect(analytics.events, isEmpty);
    });
  }
  test("parameter names and count are validated", () async {
    await expectLater(logger.sendRawData("goal", parameters: {"firebase_x": 1}),
        throwsArgumentError);
    await expectLater(
        logger.sendRawData("goal",
            parameters: {for (var i = 0; i < 26; i++) "p$i": i}),
        throwsArgumentError);
    expect(analytics.events, isEmpty);
  });
  test("parameter values are not silently truncated", () async {
    await expectLater(
        logger.sendRawData("goal", parameters: {"text": "a" * 101}),
        throwsArgumentError);
  });
}
