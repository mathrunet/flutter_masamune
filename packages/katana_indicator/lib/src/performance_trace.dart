part of "/katana_indicator.dart";

/// Prefix used for indicator visibility performance traces.
///
/// インジケーター表示のパフォーマンストレースで使用するPrefix。
const katanaIndicatorTracePrefix = "katana.indicator.show";

Future<LoggerTrace?> _startIndicatorTrace(
  StackTrace stackTrace, {
  String? traceName,
}) async {
  try {
    final resolvedTraceName = traceName?.trim();
    final trace = Logger().trace(
      "$katanaIndicatorTracePrefix|${resolvedTraceName == null || resolvedTraceName.isEmpty ? _indicatorCaller(stackTrace) : resolvedTraceName}",
    );
    await trace.start();
    return trace;
  } on AssertionError {
    return null;
  } catch (error) {
    debugPrint("Failed to start indicator trace: $error");
    return null;
  }
}

class _IndicatorTraceLifecycle {
  Future<LoggerTrace?>? _trace;

  void start(String traceName) {
    stop();
    _trace = _startIndicatorTrace(
      StackTrace.current,
      traceName: traceName,
    );
  }

  void stop() {
    final trace = _trace;
    _trace = null;
    if (trace == null) {
      return;
    }
    unawaited(trace.then(_stopIndicatorTrace));
  }
}

Future<void> _stopIndicatorTrace(LoggerTrace? trace) async {
  if (trace == null || !trace.tracing) {
    return;
  }
  try {
    await trace.stop();
  } catch (error) {
    debugPrint("Failed to stop indicator trace: $error");
  }
}

String _indicatorCaller(StackTrace stackTrace) {
  for (final line in stackTrace.toString().split("\n")) {
    if (line.contains("package:katana_indicator/")) {
      continue;
    }
    final match = RegExp(r"#\d+\s+([^\s(]+).*\((package:[^)]+)\)")
        .firstMatch(line.trim());
    if (match == null) {
      continue;
    }
    final member = match.group(1) ?? "unknown";
    final location = (match.group(2) ?? "package:unknown")
        .replaceFirst(RegExp(r":\d+:\d+$"), "");
    return "$member@$location";
  }
  return "unknown";
}
