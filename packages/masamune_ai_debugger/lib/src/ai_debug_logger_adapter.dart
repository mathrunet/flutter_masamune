part of '/masamune_ai_debugger.dart';

class _AIDebugLoggerAdapter extends LoggerAdapter {
  const _AIDebugLoggerAdapter(this.controller);

  final AIDebugController controller;

  @override
  Future<List<LogValue>> logList() => Future.value(const []);

  @override
  Future<void> send(String name, {DynamicMap? parameters}) async {
    controller.addLog(
        name, parameters?.map((key, value) => MapEntry(key, value)));
  }

  @override
  Future<void> error(
    Object exception,
    StackTrace? stackTrace, {
    String? name,
    DynamicMap? parameters,
  }) async {
    if (!controller.reportHandledErrors) {
      controller.addLog(
        name ?? "error",
        {
          ...?parameters,
          "error": exception.toString(),
          "stackTrace": stackTrace?.toString(),
        },
        severity: "error",
      );
      return;
    }
    await controller.reportError(exception, stackTrace);
  }

  @override
  LoggerTraceValue trace(String name) {
    if (name.startsWith("$_modelLoadTracePrefix|")) {
      return _AIDebugLoggerTrace(
        name,
        this,
        category: "model_load",
      );
    }
    if (name.startsWith("$_indicatorTracePrefix|")) {
      return _AIDebugLoggerTrace(
        name,
        this,
        category: "indicator",
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
  });

  final String? category;
  Duration? _activeTimeout;
  Timer? _timeoutTimer;
  bool _thresholdExceeded = false;

  @override
  Future<void> start(DateTime startTime) async {
    final configuredCategory = category;
    if (configuredCategory == null) {
      return;
    }
    final aiDebuggerAdapter = adapter as _AIDebugLoggerAdapter;
    final settings = await aiDebuggerAdapter.controller.loadSettings();
    final configuredTimeout = configuredCategory == "model_load"
        ? settings.modelLoadTimeout
        : settings.indicatorTimeout;
    _activeTimeout = configuredTimeout;
    if (configuredTimeout <= Duration.zero) return;
    _timeoutTimer = Timer(configuredTimeout, () {
      if (_thresholdExceeded) return;
      _thresholdExceeded = true;
      final elapsed = DateTime.now().difference(startTime);
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
        if (_activeTimeout != null)
          "threshold_ms": _activeTimeout!.inMilliseconds,
        if (category != null) "threshold_exceeded": _thresholdExceeded,
      },
    );
  }
}
