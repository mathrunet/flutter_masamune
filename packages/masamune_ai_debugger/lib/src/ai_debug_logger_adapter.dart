part of '/masamune_ai_debugger.dart';

class _AIDebugLoggerAdapter extends LoggerAdapter {
  const _AIDebugLoggerAdapter(
    this.controller, {
    required this.modelLoadTimeout,
    required this.indicatorTimeout,
  });

  final AIDebugController controller;
  final Duration modelLoadTimeout;
  final Duration indicatorTimeout;

  @override
  Future<List<LogValue>> logList() => Future.value(const []);

  @override
  Future<void> send(String name, {DynamicMap? parameters}) async {
    controller.addLog(
        name, parameters?.map((key, value) => MapEntry(key, value)));
  }

  @override
  LoggerTraceValue trace(String name) {
    if (name.startsWith("$_modelLoadTracePrefix|")) {
      return _AIDebugLoggerTrace(
        name,
        this,
        category: "model_load",
        timeout: modelLoadTimeout,
      );
    }
    if (name.startsWith("$_indicatorTracePrefix|")) {
      return _AIDebugLoggerTrace(
        name,
        this,
        category: "indicator",
        timeout: indicatorTimeout,
      );
    }
    return _AIDebugLoggerTrace(name, this);
  }
}

class _AIDebugLoggerTrace extends LoggerTraceValue {
  _AIDebugLoggerTrace(
    super.name,
    super.adapter, {
    this.category,
    this.timeout,
  });

  final String? category;
  final Duration? timeout;
  Timer? _timeoutTimer;
  bool _thresholdExceeded = false;

  @override
  Future<void> start(DateTime startTime) async {
    final configuredTimeout = timeout;
    final configuredCategory = category;
    if (configuredTimeout == null ||
        configuredCategory == null ||
        configuredTimeout <= Duration.zero) {
      return;
    }
    _timeoutTimer = Timer(configuredTimeout, () {
      if (_thresholdExceeded) return;
      _thresholdExceeded = true;
      final elapsed = DateTime.now().difference(startTime);
      final aiDebuggerAdapter = adapter as _AIDebugLoggerAdapter;
      unawaited(
        aiDebuggerAdapter.controller.reportPerformanceTrace(
          category: configuredCategory,
          traceName: name,
          startedAt: startTime,
          elapsed: elapsed,
          threshold: configuredTimeout,
        ),
      );
    });
  }

  @override
  Future<void> stop(DateTime startTime, DateTime endTime) async {
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    await adapter.send(
      name,
      parameters: {
        "duration_ms": endTime.difference(startTime).inMilliseconds,
        if (category != null) "category": category,
        if (timeout != null) "threshold_ms": timeout!.inMilliseconds,
        if (category != null) "threshold_exceeded": _thresholdExceeded,
      },
    );
  }
}
