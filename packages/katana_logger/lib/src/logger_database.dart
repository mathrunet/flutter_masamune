part of katana_logger;

/// A simple database for logging information.
///
/// Logging can be done in memory or locally on the terminal.
///
/// The logs are recorded in an array of {time, parameters}. The name of the log is recorded in the `@name` key in the parameters.
///
/// It is possible to change the log save location by specifying [onInitialize], [onLoad], and [onSaved] appropriately.
///
/// ログの情報を記録するための簡易データベース。
///
/// メモリ上や端末ローカルにログを記録することができます。
///
/// {時間, パラメーター}の配列で記録されます。パラメーターの中の`@name`キーにログの名前が記録されます。
///
/// [onInitialize]、[onLoad]、[onSaved]を適切に指定することでログの保存場所を変更することが可能です。
class LoggerDatabase {
  /// A simple database for logging information.
  ///
  /// Logging can be done in memory or locally on the terminal.
  ///
  /// The logs are recorded in an array of {time, parameters}. The name of the log is recorded in the `@name` key in the parameters.
  ///
  /// It is possible to change the log save location by specifying [onInitialize], [onLoad], and [onSaved] appropriately.
  ///
  /// ログの情報を記録するための簡易データベース。
  ///
  /// メモリ上や端末ローカルにログを記録することができます。
  ///
  /// {時間, パラメーター}の配列で記録されます。パラメーターの中の`@name`キーにログの名前が記録されます。
  ///
  /// [onInitialize]、[onLoad]、[onSaved]を適切に指定することでログの保存場所を変更することが可能です。
  LoggerDatabase({
    this.onInitialize,
    this.onLoad,
    this.onSaved,
  });

  /// Key where the name of the log is stored.
  ///
  /// ログの名前が保存されるキー。
  static const nameKey = "@name";

  // ignore: prefer_final_fields
  Map<String, DynamicMap> _data = {};
  bool _initialized = false;
  Completer<void>? _completer;

  /// Executed at Database initialization time.
  ///
  /// Databaseの初期化時に実行されます。
  final Future<void> Function(LoggerDatabase database)? onInitialize;

  /// Executed when saving the Database.
  ///
  /// Databaseの保存時に実行されます。
  final Future<void> Function(LoggerDatabase database)? onSaved;

  /// Executed when loading Database.
  ///
  /// Databaseの読み込み時に実行されます。
  final Future<void> Function(LoggerDatabase database)? onLoad;

  Future<void> _initialize() async {
    if (_completer != null) {
      return _completer?.future;
    }
    if (_initialized) {
      return;
    }
    _completer = Completer();
    try {
      _initialized = true;
      await onInitialize?.call(this);
      _completer?.complete();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Each log data can be entered directly.
  ///
  /// それぞれのログデータを直接入力することができます。
  void setRawData(Map<DateTime, DynamicMap> data) {
    _data.addAll(
      data.map((key, value) => MapEntry(key.toIso8601String(), value)),
    );
  }

  /// Reads values from the database.
  ///
  /// データベースから値を読み取ります。
  Future<Map<String, DynamicMap>> read() async {
    await _initialize();
    await onLoad?.call(this);
    return _data;
  }

  /// Pass [name], the name of the log, and parameters [parameters] to save the log.
  ///
  /// Logs are saved at the date and time of execution, but can be saved at a specified date and time if [dateTime] is specified.
  ///
  /// ログの名前である[name]とパラメーター[parameters]を渡して、ログを保存します。
  ///
  /// 実行した日時でログは保存されますが、[dateTime]を指定すると指定した日時で保存することが可能です。
  Future<void> write(
    String name, {
    DynamicMap? parameters,
    DateTime? dateTime,
  }) async {
    await _initialize();
    final date = (dateTime ?? DateTime.now()).toIso8601String();
    _data[date] = {
      if (parameters != null) ...parameters,
      nameKey: name,
    };
    await onSaved?.call(this);
  }
}
