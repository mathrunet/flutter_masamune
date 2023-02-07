part of katana_logger;

/// Logging in memory [LoggerAdapter].
///
/// Logging can be done in advance using [rawData].
///
/// [LoggerDatabase] specified in [database].
/// Please use for testing purposes.
///
/// You can check the logs recorded at [logs].
///
/// メモリ上でログを記録する[LoggerAdapter]。
///
/// [rawData]を利用して予めログを記録しておくことができます。
///
/// [database]で指定された[LoggerDatabase]を利用することができます。
/// テスト用にお使いください。
///
/// [logList]で記録されたログを確認することができます。
class RuntimeLoggerAdapter extends LoggerAdapter {
  /// Logging in memory [LoggerAdapter].
  ///
  /// Logging can be done in advance using [rawData].
  ///
  /// [LoggerDatabase] specified in [database].
  /// Please use for testing purposes.
  ///
  /// You can check the logs recorded at [logs].
  ///
  /// メモリ上でログを記録する[LoggerAdapter]。
  ///
  /// [rawData]を利用して予めログを記録しておくことができます。
  ///
  /// [database]で指定された[LoggerDatabase]を利用することができます。
  /// テスト用にお使いください。
  ///
  /// [logList]で記録されたログを確認することができます。
  const RuntimeLoggerAdapter({
    this.rawData = const {},
    LoggerDatabase? database,
  }) : _database = database;

  /// Actual log data when used as a mock-up.
  ///
  /// モックアップとして利用する際の実ログデータ。
  final Map<DateTime, DynamicMap> rawData;

  /// Designated database. Please use for testing purposes, etc.
  ///
  /// 指定のデータベース。テスト用途などにご利用ください。
  LoggerDatabase get database {
    final database = _database ?? sharedDatabase;
    if (database._data.isEmpty) {
      database.setRawData(rawData);
    }
    return database;
  }

  final LoggerDatabase? _database;

  /// A common database throughout the application.
  ///
  /// アプリ内全体での共通のデータベース。
  static final LoggerDatabase sharedDatabase = LoggerDatabase();

  @override
  void send(String name, {DynamicMap? parameters}) {
    database.write(name, parameters: parameters);
  }

  @override
  LoggerTracer trace(
    String name, {
    VoidCallback? onStart,
    VoidCallback? onStop,
  }) {
    return _RuntimeLoggerTracer._(name, this, onStart: onStart, onStop: onStop);
  }

  @override
  Future<List<LogValue>> logList() async {
    final data = await database.read();
    return data
        .toList(
          (key, value) => LogValue(
              dateTime: DateTime.parse(key),
              name: value.get(LoggerDatabase.nameKey, ""),
              parameters: Map.from(value)
                ..removeWhere(
                  (key, value) => key == LoggerDatabase.nameKey,
                )),
        )
        .toList();
  }
}

class _RuntimeLoggerTracer extends LoggerTracer {
  _RuntimeLoggerTracer._(
    super.name,
    super.adapter, {
    this.onStart,
    this.onStop,
  });

  final VoidCallback? onStart;
  final VoidCallback? onStop;
  DateTime? _startTime;

  @override
  Future<void> start() async {
    assert(
      _startTime == null,
      "You have already started. Please execute [stop] before starting.",
    );
    _startTime = DateTime.now();
    onStart?.call();
  }

  @override
  Future<void> stop() async {
    assert(
      _startTime != null,
      "It has not started yet. Please execute [start] first.",
    );
    final diff = DateTime.now().difference(_startTime!);
    adapter.send(
      name,
      parameters: {"duration": diff.inMilliseconds},
    );
    onStop?.call();
  }
}
