part of "/katana_indicator.dart";

/// Prefix used for indicator visibility performance traces.
///
/// インジケーター表示のパフォーマンストレースで使用するPrefix。
const katanaIndicatorTracePrefix = "katana.indicator.show";

const _firebasePerformanceTraceNameMaxLength = 100;
const _traceNameHashLength = 8;

Future<LoggerTrace?> _startIndicatorTrace(
  StackTrace stackTrace, {
  String? traceName,
}) async {
  try {
    final resolvedTraceName = traceName?.trim();
    final name =
        "$katanaIndicatorTracePrefix|${resolvedTraceName == null || resolvedTraceName.isEmpty ? _indicatorCaller(stackTrace) : resolvedTraceName}";
    final trace = Logger().trace(_firebasePerformanceTraceName(name));
    await trace.start();
    return trace;
  } on AssertionError {
    return null;
  } catch (error) {
    debugPrint("Failed to start indicator trace: $error");
    return null;
  }
}

String _firebasePerformanceTraceName(String name) {
  if (name.length <= _firebasePerformanceTraceNameMaxLength) {
    return name;
  }
  final hash = _traceNameHash(name);
  const prefixLength =
      _firebasePerformanceTraceNameMaxLength - _traceNameHashLength - 1;
  var prefixEnd = prefixLength;
  final lastCodeUnit = name.codeUnitAt(prefixEnd - 1);
  if (lastCodeUnit >= 0xd800 && lastCodeUnit <= 0xdbff) {
    prefixEnd--;
  }
  return "${name.substring(0, prefixEnd)}-$hash";
}

String _traceNameHash(String name) {
  var hash = 0x811c9dc5;
  for (final codeUnit in name.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(_traceNameHashLength, "0");
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
