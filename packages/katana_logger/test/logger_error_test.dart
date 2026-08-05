// Package imports:
import "package:test/test.dart";

// Project imports:
import "package:katana_logger/katana_logger.dart";

class _RecordingLoggerAdapter extends LoggerAdapter {
  _RecordingLoggerAdapter();

  final List<({String name, DynamicMap? parameters})> sent = [];

  @override
  Future<List<LogValue>> logList() async => const [];

  @override
  Future<void> send(String name, {DynamicMap? parameters}) async {
    sent.add((name: name, parameters: parameters));
  }

  @override
  LoggerTraceValue trace(String name) => throw UnimplementedError();
}

class _NativeErrorLoggerAdapter extends _RecordingLoggerAdapter {
  final List<Object> errors = [];

  @override
  Future<void> error(
    Object exception,
    StackTrace? stackTrace, {
    String? name,
    DynamicMap? parameters,
  }) async {
    errors.add(exception);
  }
}

void main() {
  tearDown(() => TestLoggerAdapterScope.setTestAdapters([]));

  test("Logger.error does nothing when no adapter is set", () async {
    // `LoggerAdapterScope` is only placed when at least one adapter exists, so
    // an app without any adapter must not blow up on a call from a catch clause.
    TestLoggerAdapterScope.setTestAdapters([]);
    await expectLater(
      Logger().error(Exception("boom"), StackTrace.current),
      completes,
    );
  });

  test("LoggerAdapter.error falls back to send by default", () async {
    final adapter = _RecordingLoggerAdapter();
    TestLoggerAdapterScope.setTestAdapters([adapter]);

    await Logger().error(Exception("boom"), StackTrace.current);

    expect(adapter.sent, hasLength(1));
    expect(adapter.sent.single.name, "error");
    expect(adapter.sent.single.parameters?["error"], contains("boom"));
    expect(adapter.sent.single.parameters?["stackTrace"], isNotNull);
  });

  test("Logger.error prefers an overridden error over send", () async {
    final adapter = _NativeErrorLoggerAdapter();
    TestLoggerAdapterScope.setTestAdapters([adapter]);

    final exception = Exception("boom");
    await Logger().error(exception, StackTrace.current);

    expect(adapter.errors, [exception]);
    expect(adapter.sent, isEmpty);
  });

  test("Logger.error fans out to every adapter", () async {
    final first = _RecordingLoggerAdapter();
    final second = _NativeErrorLoggerAdapter();
    TestLoggerAdapterScope.setTestAdapters([first, second]);

    await Logger().error(Exception("boom"), StackTrace.current);

    expect(first.sent, hasLength(1));
    expect(second.errors, hasLength(1));
  });
}
