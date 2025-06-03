part of "/katana_logger.dart";

const _kLocalDatabaseId = "logger://";

/// Logging can be done locally on the terminal [LoggerAdapter].
///
/// You can check the logs recorded at [logList].
///
/// The log limit can be set with [limit]. The default value is `100`.
///
/// 端末ローカル上にログを記録することができる[LoggerAdapter]。
///
/// [logList]で記録されたログを確認することができます。
///
/// [limit]でログの上限を設定可能です。初期値は`100`です。
class LocalLoggerAdapter extends LoggerAdapter {
  /// Logging can be done locally on the terminal [LoggerAdapter].
  ///
  /// You can check the logs recorded at [logList].
  ///
  /// The log limit can be set with [limit]. The default value is `100`.
  ///
  /// 端末ローカル上にログを記録することができる[LoggerAdapter]。
  ///
  /// [logList]で記録されたログを確認することができます。
  ///
  /// [limit]でログの上限を設定可能です。初期値は`100`です。
  const LocalLoggerAdapter({
    this.limit = 100,
  });

  /// Log limit.
  ///
  /// ログの上限。
  final int limit;

  /// Designated database.
  ///
  /// 指定のデータベース。
  LoggerDatabase get database {
    final database = sharedDatabase;
    database.setLimit(limit);
    return database;
  }

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
  Future<void> send(String name, {DynamicMap? parameters}) async {
    database.write(name, parameters: parameters);
  }

  @override
  LoggerTraceValue trace(String name) {
    return _LocalLoggerTraceValue._(name, this);
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

class _LocalLoggerTraceValue extends LoggerTraceValue {
  const _LocalLoggerTraceValue._(super.name, super.adapter);

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
