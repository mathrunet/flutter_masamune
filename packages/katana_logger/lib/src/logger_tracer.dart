part of katana_logger;

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
abstract class LoggerTracer {
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
  const LoggerTracer(this.name, this.adapter);

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
  /// Errors occur if they are executed consecutively.
  ///
  /// ログの記録を開始します。
  ///
  /// 連続して実行するとエラーがでます。
  Future<void> start();

  /// Complete and save the logging.
  ///
  /// Errors occur if they are executed consecutively.
  ///
  /// ログの記録を完了して保存します。
  ///
  /// 連続して実行するとエラーがでます。
  Future<void> stop();
}
