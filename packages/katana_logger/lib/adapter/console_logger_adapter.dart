part of katana_logger;

const _kLogName = "Katana";

/// [LoggerAdapter] for outputting logs to the console.
///
/// The log will be output with the name "katana".
///
/// You can filter the log contents by specifying [filter].
///
/// コンソールにログを出力するための[LoggerAdapter]。
///
/// "katana"という名前でログが出力されます。
///
/// [filter]を指定するとログ内容をフィルタリングできます。
class ConsoleLoggerAdapter extends LoggerAdapter {
  /// [LoggerAdapter] for outputting logs to the console.
  ///
  /// The log will be output with the name "katana".
  ///
  /// You can filter the log contents by specifying [filter].
  ///
  /// コンソールにログを出力するための[LoggerAdapter]。
  ///
  /// "katana"という名前でログが出力されます。
  ///
  /// [filter]を指定するとログ内容をフィルタリングできます。
  const ConsoleLoggerAdapter({this.filter});

  /// Filter for when the [send] method is sent.
  ///
  /// If `true` is returned, it will appear in the log.
  ///
  /// [send]メソッドが送信された場合のフィルター。
  ///
  /// `true`を返すとログに表示されます。
  final bool Function(String name, DynamicMap? parameters)? filter;

  @override
  Future<void> send(String name, {DynamicMap? parameters}) async {
    if (!(filter?.call(name, parameters) ?? true)) {
      return;
    }
    final now = DateTime.now();
    developer.log(
      "[${now.toIso8601String()}] $name\n${_printMap(parameters)}",
      name: _kLogName,
    );
  }

  @override
  LoggerTraceValue trace(String name) {
    return _ConsoleLoggerTraceValue._(name, this);
  }

  @override
  Future<List<LogValue>> logList() => Future.value([]);

  String _printMap(DynamicMap? parameters) {
    parameters ??= {};
    return "{ ${parameters.entries.map((e) => "${e.key}: ${e.value}").join(",\t")} }";
  }
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
