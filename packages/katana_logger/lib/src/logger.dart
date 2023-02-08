part of katana_logger;

/// Used for active logging.
///
/// Log events can be sent using [send] and [sendRawData].
///
/// You can trace the performance with [trace].
///
/// Logging can be performed on various platforms by specifying [adapter].
///
/// 能動的にログを記録するために利用します。
///
/// [send]、[sendRawData]でログイベントを送信できます。
///
/// [trace]でパフォーマンスをトレースできます。
///
/// [adapter]を指定することにより様々なプラットフォームでログを記録することができます。
class Logger extends ChangeNotifier {
  /// Used for active logging.
  ///
  /// Log events can be sent using [send] and [sendRawData].
  ///
  /// You can trace the performance with [trace].
  ///
  /// Logging can be performed on various platforms by specifying [adapter].
  ///
  /// 能動的にログを記録するために利用します。
  ///
  /// [send]、[sendRawData]でログイベントを送信できます。
  ///
  /// [trace]でパフォーマンスをトレースできます。
  ///
  /// [adapter]を指定することにより様々なプラットフォームでログを記録することができます。
  Logger({LoggerAdapter? adapter}) : _adapter = adapter;

  /// Adapter to define loggers.
  ///
  /// ロガーを定義するアダプター。
  LoggerAdapter get adapter {
    final adapter = _adapter ?? LoggerAdapter.primary;
    assert(
      adapter != null,
      "LoggerAdapter is not set. Place [LoggerAdapterScope] widget closer to the root.",
    );
    return adapter!;
  }

  final LoggerAdapter? _adapter;

  /// Get a list of logs recorded.
  ///
  /// 記録されたログの一覧を取得します。
  Future<List<LogValue>> logList() {
    return adapter.logList();
  }

  /// Logs by passing [loggable].
  ///
  /// The type [T] of [loggable] is the name of the log and [Loggable.toJson] is the parameter.
  ///
  /// [loggable]を渡すことにより、ログを記録します。
  ///
  /// [loggable]の型[T]がログの名前、[Loggable.toJson]がパラメーターとなります。
  void send<T extends Loggable>(T loggable) {
    adapter.send(
      loggable.runtimeType.toString(),
      parameters: loggable.toJson(),
    );
    notifyListeners();
  }

  /// Logs by specifying [name] and [parameters] directly.
  ///
  /// [name]と[parameters]を直接指定してログを記録します。
  void sendRawData(String name, {DynamicMap? parameters}) {
    adapter.send(name, parameters: parameters);
    notifyListeners();
  }

  /// Get [LoggerTracer] to record performance.
  ///
  /// [LoggerTracer.start] starts recording and [LoggerTracer.stop] completes and saves the recording.
  ///
  /// パフォーマンスを記録する[LoggerTracer]を取得します。
  ///
  /// [LoggerTracer.start]で記録を開始し、[LoggerTracer.stop]で記録を完了、保存します。
  LoggerTracer trace(String name) {
    return adapter.trace(name, onStop: notifyListeners);
  }
}
