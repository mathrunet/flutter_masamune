part of katana_logger;

const _kLocalDatabaseId = "logger://";

/// Logging can be done locally on the terminal [LoggerAdapter].
///
/// You can check the logs recorded at [logs].
///
/// 端末ローカル上にログを記録することができる[LoggerAdapter]。
///
/// [logList]で記録されたログを確認することができます。
class LocalLoggerAdapter extends LoggerAdapter {
  /// Logging can be done locally on the terminal [LoggerAdapter].
  ///
  /// You can check the logs recorded at [logs].
  ///
  /// 端末ローカル上にログを記録することができる[LoggerAdapter]。
  ///
  /// [logList]で記録されたログを確認することができます。
  const LocalLoggerAdapter();

  /// Designated database.
  ///
  /// 指定のデータベース。
  LoggerDatabase get database => sharedDatabase;

  /// A common database throughout the application.
  ///
  /// アプリ内全体での共通のデータベース。
  static final LoggerDatabase sharedDatabase = LoggerDatabase(
    onInitialize: (database) async {
      try {
        database._data = await LoggerExporter.import(
          "${LoggerExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        );
      } catch (e) {
        database._data = {};
      }
    },
    onSaved: (database) async {
      await LoggerExporter.export(
        "${LoggerExporter.documentDirectory}/${_kLocalDatabaseId.toSHA1()}",
        database._data,
      );
    },
  );

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
    return _LocalLoggerTracer._(name, this, onStart: onStart, onStop: onStop);
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

class _LocalLoggerTracer extends LoggerTracer {
  _LocalLoggerTracer._(
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
