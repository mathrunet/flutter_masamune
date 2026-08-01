part of "/katana_model.dart";

/// Prefix used for model loading performance traces.
///
/// モデル読込のパフォーマンストレースで使用するPrefix。
const katanaModelLoadTracePrefix = "katana.model.load";

Future<LoggerTrace?> _startModelLoadTrace({
  required String modelType,
  required String target,
  required String operation,
}) async {
  try {
    final trace = Logger().trace(
      "$katanaModelLoadTracePrefix|$target|$operation|$modelType",
    );
    await trace.start();
    return trace;
  } on AssertionError {
    return null;
  } catch (error) {
    debugPrint("Failed to start model load trace: $error");
    return null;
  }
}

Future<void> _stopModelLoadTrace(LoggerTrace? trace) async {
  if (trace == null || !trace.tracing) {
    return;
  }
  try {
    await trace.stop();
  } catch (error) {
    debugPrint("Failed to stop model load trace: $error");
  }
}
