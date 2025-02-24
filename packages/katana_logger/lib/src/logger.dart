part of '/katana_logger.dart';

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
  Logger({List<LoggerAdapter> adapters = const []}) : _adapters = adapters;

  /// List of adapters that define loggers.
  ///
  /// ロガーを定義するアダプターのリスト。
  List<LoggerAdapter> get adapters {
    if (LoggerAdapter._test != null) {
      return LoggerAdapter._test!;
    }
    final adapters = [
      ...LoggerAdapter.primary,
      ..._adapters,
    ];
    assert(
      adapters.isNotEmpty,
      "LoggerAdapter is not set. Place [LoggerAdapterScope] widget closer to the root.",
    );
    return adapters;
  }

  final List<LoggerAdapter> _adapters;

  /// Get a list of logs recorded.
  ///
  /// 記録されたログの一覧を取得します。
  Future<List<LogValue>> logList() async {
    final list = await Future.wait(
      adapters.map((e) => e.logList()),
    );
    return list.expand((e) => e).toList(growable: false);
  }

  /// Logs by passing [loggable].
  ///
  /// The type [T] of [loggable] is the name of the log and [Loggable.toJson] is the parameter.
  ///
  /// [loggable]を渡すことにより、ログを記録します。
  ///
  /// [loggable]の型[T]がログの名前、[Loggable.toJson]がパラメーターとなります。
  Future<void> send<T extends Loggable>(T loggable) async {
    await Future.wait(
      adapters.map(
        (adapter) => adapter.send(
          loggable.name,
          parameters: loggable.toJson(),
        ),
      ),
    );
    notifyListeners();
  }

  /// Logs by specifying [name] and [parameters] directly.
  ///
  /// [name]と[parameters]を直接指定してログを記録します。
  Future<void> sendRawData(String name, {DynamicMap? parameters}) async {
    await Future.wait(
      adapters.map(
        (adapter) => adapter.send(name, parameters: parameters),
      ),
    );
    notifyListeners();
  }

  /// Get [LoggerTrace] to record performance.
  ///
  /// [LoggerTrace.start] starts recording and [LoggerTrace.stop] completes and saves the recording.
  ///
  /// パフォーマンスを記録する[LoggerTrace]を取得します。
  ///
  /// [LoggerTrace.start]で記録を開始し、[LoggerTrace.stop]で記録を完了、保存します。
  LoggerTrace trace(String name) {
    return LoggerTrace._(
      adapters.map((e) => e.trace(name)).toList(),
      notifyListeners,
      notifyListeners,
    );
  }
}
