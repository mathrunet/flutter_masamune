part of katana_logger;

const _kLogName = "katana";

/// [LoggerAdapter] for outputting logs to the console.
///
/// The log will be output with the name "katana".
///
/// コンソールにログを出力するための[LoggerAdapter]。
///
/// "katana"という名前でログが出力されます。
class ConsoleLoggerAdapter extends LoggerAdapter {
  /// [LoggerAdapter] for outputting logs to the console.
  ///
  /// The log will be output with the name "katana".
  ///
  /// コンソールにログを出力するための[LoggerAdapter]。
  ///
  /// "katana"という名前でログが出力されます。
  const ConsoleLoggerAdapter();

  @override
  Future<void> send(String name, {DynamicMap? parameters}) async {
    developer.log("$name: $parameters", name: _kLogName);
  }

  @override
  LoggerTraceValue trace(String name) {
    return _ConsoleLoggerTraceValue._(name, this);
  }

  @override
  Future<List<LogValue>> logList() => Future.value([]);
}

class _ConsoleLoggerTraceValue extends LoggerTraceValue {
  _ConsoleLoggerTraceValue._(super.name, super.adapter);

  @override
  Future<void> start(DateTime startTime) => Future.value();

  @override
  Future<void> stop(DateTime startTime, DateTime endTime) async {
    final diff = endTime.difference(startTime);
    adapter.send(
      name,
      parameters: {"duration": diff.inMilliseconds},
    );
  }
}
