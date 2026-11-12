part of '/masamune_ai_debugger.dart';

class _AIDebugLoggerAdapter extends LoggerAdapter {
  const _AIDebugLoggerAdapter(this.controller);

  final AIDebugController controller;

  @override
  Future<List<LogValue>> logList() => Future.value(const []);

  @override
  Future<void> send(String name, {DynamicMap? parameters}) async {
    controller.addLog(
      name,
      parameters?.map((key, value) => MapEntry(key, value)),
    );
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
          severity: "error");
      return;
    }
    await controller.reportError(exception, stackTrace);
  }

  @override
  LoggerTraceValue trace(String name) {
    if (name.startsWith("$_modelLoadTracePrefix|")) {
      return _AIDebugLoggerTrace(name, this, category: "model_load");
    }
    if (name.startsWith("$_indicatorTracePrefix|")) {
      return _AIDebugLoggerTrace(name, this, category: "indicator");
    }
    return _AIDebugLoggerTrace(name, this);
  }
}

class _AIDebugLoggerTrace extends LoggerTraceValue {
  _AIDebugLoggerTrace(super.name, super.adapter, {this.category})
      : _expectedDelay =
            Zone.current[AIDebuggerMasamuneAdapter._expectedDelayZoneKey]
                as bool Function(String)?;

  final String? category;
  final bool Function(String name)? _expectedDelay;
  Duration? _activeTimeout;
  Timer? _timeoutTimer;
  bool _thresholdExceeded = false;
  final Stopwatch _stopwatch = Stopwatch();
  DateTime? _wallStartedAt;
  bool _stopped = false;

  @override
  Future<void> start(DateTime startTime) async {
    _wallStartedAt = DateTime.now().toUtc();
    _stopwatch.start();
    final configuredCategory = category;
    if (configuredCategory == null) {
      return;
    }
    final aiDebuggerAdapter = adapter as _AIDebugLoggerAdapter;
    final settings = await aiDebuggerAdapter.controller.loadSettings();
    if (_stopped) return;
    final configuredTimeout = configuredCategory == "model_load"
        ? settings.modelLoadTimeout
        : settings.indicatorTimeout;
    _activeTimeout = configuredTimeout;
    if (configuredTimeout <= Duration.zero) return;
    _timeoutTimer = Timer.periodic(configuredTimeout, (timer) {
      if (_thresholdExceeded) return;
      if (_expectedDelay?.call(name) ?? false) {
        unawaited(
          adapter.send(
            name,
            parameters: {
              "category": configuredCategory,
              "expected_delay": true,
              "duration_ms": _stopwatch.elapsedMilliseconds,
            },
          ),
        );
        return;
      }
      _thresholdExceeded = true;
      timer.cancel();
      final elapsed = _stopwatch.elapsed;
      unawaited(
        aiDebuggerAdapter.controller.reportPerformanceTrace(
          category: configuredCategory,
          traceName: name,
          startedAt: _wallStartedAt!,
          elapsed: elapsed,
          threshold: configuredTimeout,
        ),
      );
    });
  }

  @override
  Future<void> stop(DateTime startTime, DateTime endTime) async {
    _stopped = true;
    _stopwatch.stop();
    _timeoutTimer?.cancel();
    _timeoutTimer = null;
    await adapter.send(
      name,
      parameters: {
        "duration_ms": _stopwatch.elapsedMilliseconds,
        if (category != null) "category": category,
        if (_activeTimeout != null)
          "threshold_ms": _activeTimeout!.inMilliseconds,
        if (category != null) "threshold_exceeded": _thresholdExceeded,
      },
    );
  }
}
