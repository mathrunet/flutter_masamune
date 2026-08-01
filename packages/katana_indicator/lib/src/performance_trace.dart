part of "/katana_indicator.dart";

/// Prefix used for indicator visibility performance traces.
///
/// インジケーター表示のパフォーマンストレースで使用するPrefix。
const katanaIndicatorTracePrefix = "katana.indicator.show";

Future<LoggerTrace?> _startIndicatorTrace(StackTrace stackTrace) async {
  try {
    final trace = Logger().trace(
      "$katanaIndicatorTracePrefix|${_indicatorCaller(stackTrace)}",
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
