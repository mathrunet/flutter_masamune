part of "/katana_logger.dart";

class LoggerTrace {
  LoggerTrace._(this.values, this._onStart, this._onStop);

  DateTime? _startTime;

  /// List of output [LoggerTraceValue].
  ///
  /// 出力された[LoggerTraceValue]のリスト。
  final List<LoggerTraceValue> values;

  final VoidCallback _onStart;
  final VoidCallback _onStop;

  /// Returns `true` if tracing is currently in progress.
  ///
  /// 現在トレース中の場合`true`を返します。
  bool get tracing => _startTime != null;

  /// Start logging.
  ///
  /// Errors occur if they are executed consecutively.
  ///
  /// ログの記録を開始します。
  ///
  /// 連続して実行するとエラーがでます。
  Future<void> start() async {
    assert(
      _startTime == null,
      "You have already started. Please execute [stop] before starting.",
    );
    if (_startTime != null) {
      return;
    }
    _startTime = DateTime.now();
    await Future.wait(values.map((e) => e.start(_startTime!)));
    _onStart.call();
  }

  /// Complete and save the logging.
  ///
  /// Errors occur if they are executed consecutively.
  ///
  /// ログの記録を完了して保存します。
  ///
  /// 連続して実行するとエラーがでます。
  Future<void> stop() async {
    assert(
      _startTime != null,
      "It has not started yet. Please execute [start] first.",
    );
    if (_startTime == null) {
      return;
    }
    final endTime = DateTime.now();
    await Future.wait(values.map((e) => e.stop(_startTime!, endTime)));
    _onStop.call();
  }
}

/// Base class for tracing logs and measuring performance.
///
/// Press [start] to start recording, and [stop] to complete and save the recording.
///
/// Logs are stored in [name].
///
/// ログをトレースしパフォーマンスを計測するためのベースクラス。
///
/// [start]で記録を開始し、[stop]で記録を完了、保存します。
///
/// [name]でログが保存されます。
abstract class LoggerTraceValue {
  /// Base class for tracing logs and measuring performance.
  ///
  /// Press [start] to start recording, and [stop] to complete and save the recording.
  ///
  /// Logs are stored in [name].
  ///
  /// ログをトレースしパフォーマンスを計測するためのベースクラス。
  ///
  /// [start]で記録を開始し、[stop]で記録を完了、保存します。
  ///
  /// [name]でログが保存されます。
  const LoggerTraceValue(this.name, this.adapter);

  /// Log Name.
  ///
  /// ログの名前。
  final String name;

  /// Output [LoggerAdapter].
  ///
  /// 出力された[LoggerAdapter]。
  final LoggerAdapter adapter;

  /// Start logging.
  ///
  /// The start time is passed to [startTime].
  ///
  /// ログの記録を開始します。
  ///
  /// [startTime]に開始時間が渡されます。
  Future<void> start(DateTime startTime);

  /// Complete and save the logging.
  ///
  /// The start time is passed to [startTime] and the end time to [endTime].
  ///
  /// ログの記録を完了して保存します。
  ///
  /// [startTime]に開始時間、[endTime]に終了時間が渡されます。
  Future<void> stop(DateTime startTime, DateTime endTime);
}
