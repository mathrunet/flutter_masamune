part of "/katana_logger.dart";

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
    final adapters = _resolvedAdapters;
    assert(
      adapters.isNotEmpty,
      "LoggerAdapter is not set. Place [LoggerAdapterScope] widget closer to the root.",
    );
    return adapters;
  }

  /// Resolve the adapter without asserting that it exists.
  ///
  /// [LoggerAdapterScope] is only placed when there is at least one adapter, so an app without any [LoggerAdapter] will have this empty.
  ///
  /// アダプターの存在をアサートせずに解決します。
  ///
  /// [LoggerAdapterScope]はアダプターが1つ以上あるときのみ配置されるため、[LoggerAdapter]を一つも持たないアプリではこれが空になります。
  List<LoggerAdapter> get _resolvedAdapters {
    if (LoggerAdapter._test != null) {
      return LoggerAdapter._test!;
    }
    return [
      ...LoggerAdapter.primary,
      ..._adapters,
    ];
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

  /// Report [exception] and [stackTrace] caught by try-catch.
  ///
  /// Exceptions swallowed by try-catch do not reach [FlutterError.onError], [PlatformDispatcher.onError] or `runZonedGuarded`, so call this to make them visible.
  ///
  /// Unlike other methods, this does nothing if no [LoggerAdapter] is set, so it is safe to call unconditionally in a catch clause.
  ///
  /// try-catchでキャッチした[exception]と[stackTrace]を報告します。
  ///
  /// try-catchで握り潰された例外は[FlutterError.onError]や[PlatformDispatcher.onError]、`runZonedGuarded`に到達しないため、これを呼び出して可視化してください。
  ///
  /// 他のメソッドと異なり[LoggerAdapter]が一つも設定されていない場合は何もしないため、catch節で無条件に呼び出しても安全です。
  ///
  /// ```dart
  /// try {
  ///   await something();
  /// } catch (e, stackTrace) {
  ///   await appLogger.error(e, stackTrace);
  /// }
  /// ```
  Future<void> error(
    Object exception,
    StackTrace? stackTrace, {
    String? name,
    DynamicMap? parameters,
  }) async {
    final adapters = _resolvedAdapters;
    if (adapters.isEmpty) {
      return;
    }
    await Future.wait(
      adapters.map(
        (adapter) => adapter.error(
          exception,
          stackTrace,
          name: name,
          parameters: parameters,
        ),
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
