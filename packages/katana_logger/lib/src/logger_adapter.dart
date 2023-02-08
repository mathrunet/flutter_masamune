part of katana_logger;

/// Base class for defining platform adapters for storing logs.
///
/// ログを保存するためのプラットフォームアダプターを定義するためのベースクラス。
abstract class LoggerAdapter {
  /// Base class for defining platform adapters for storing logs.
  ///
  /// ログを保存するためのプラットフォームアダプターを定義するためのベースクラス。
  const LoggerAdapter();

  /// You can retrieve the [LoggerAdapter] first given by [LoggerAdapterScope].
  ///
  /// 最初に[LoggerAdapterScope]で与えた[LoggerAdapter]を取得することができます。
  static LoggerAdapter? get primary {
    return _primary;
  }

  static LoggerAdapter? _primary;

  /// Get a list of logs recorded.
  ///
  /// 記録されたログの一覧を取得します。
  Future<List<LogValue>> logList();

  /// Execute the process of saving the log by passing [name] and [parameters], which is the name of the log.
  ///
  /// ログの名前である[name]と[parameters]を渡してログを保存する処理を実行してください。
  void send(String name, {DynamicMap? parameters});

  /// Create [LoggerTracer] by passing [name], the name of the log.
  ///
  /// [LoggerTracer.start] to start tracking logs, [LoggerTracer.stop] to complete and save.
  ///
  /// Write callbacks for [LoggerTracer.start] and [LoggerTracer.stop] in [onStart] and [onStop].
  ///
  /// ログの名前である[name]を渡して[LoggerTracer]を作成してください。
  ///
  /// [LoggerTracer.start]でログの追跡を開始して、[LoggerTracer.stop]で完了、保存します。
  ///
  /// [onStart]、[onStop]で[LoggerTracer.start]、[LoggerTracer.stop]の際のコールバックを記述します。
  LoggerTracer trace(
    String name, {
    VoidCallback? onStart,
    VoidCallback? onStop,
  });
}

/// Place it on top of [MaterialApp], etc., and set [LoggerAdapter] for the entire app.
///
/// Pass [LoggerAdapter] to [adapter].
///
/// Also, by using [LoggerAdapterScope.of] in a descendant widget, you can retrieve the [LoggerAdapter] set in the [LoggerAdapterScope].
///
/// [MaterialApp]などの上に配置して、アプリ全体に[LoggerAdapter]を設定します。
///
/// [adapter]に[LoggerAdapter]を渡してください。
///
/// また[LoggerAdapterScope.of]を子孫のウィジェット内で利用することにより[LoggerAdapterScope]で設定された[LoggerAdapter]を取得することができます。
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return LoggerAdapterScope(
///       adapter: const RuntimeLoggerAdapter(),
///       child: MaterialApp(
///         home: const AuthPage(),
///       ),
///     );
///   }
/// }
/// ```
class LoggerAdapterScope extends StatefulWidget {
  /// Place it on top of [MaterialApp], etc., and set [LoggerAdapter] for the entire app.
  ///
  /// Pass [LoggerAdapter] to [adapter].
  ///
  /// Also, by using [LoggerAdapterScope.of] in a descendant widget, you can retrieve the [LoggerAdapter] set in the [LoggerAdapterScope].
  ///
  /// [MaterialApp]などの上に配置して、アプリ全体に[LoggerAdapter]を設定します。
  ///
  /// [adapter]に[LoggerAdapter]を渡してください。
  ///
  /// また[LoggerAdapterScope.of]を子孫のウィジェット内で利用することにより[LoggerAdapterScope]で設定された[LoggerAdapter]を取得することができます。
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return LoggerAdapterScope(
  ///       adapter: const RuntimeLoggerAdapter(),
  ///       child: MaterialApp(
  ///         home: const AuthPage(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const LoggerAdapterScope({
    super.key,
    required this.child,
    required this.adapter,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// [LoggerAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[LoggerAdapter]。
  final LoggerAdapter adapter;

  /// By passing [context], the [LoggerAdapter] set in [LoggerAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [LoggerAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[LoggerAdapterScope]で設定された[LoggerAdapter]を取得することができます。
  ///
  /// 祖先に[LoggerAdapterScope]がない場合はエラーになります。
  static LoggerAdapter? of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<_LoggerAdapterScope>();
    assert(
      scope != null,
      "LoggerAdapterScope is not found. Place [LoggerAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as _LoggerAdapterScope?)?.adapter;
  }

  @override
  State<StatefulWidget> createState() => _LoggerAdapterScopeState();
}

class _LoggerAdapterScopeState extends State<LoggerAdapterScope> {
  @override
  void initState() {
    super.initState();
    LoggerAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _LoggerAdapterScope(
      adapter: widget.adapter,
      child: widget.child,
    );
  }
}

class _LoggerAdapterScope extends InheritedWidget {
  const _LoggerAdapterScope({
    required super.child,
    required this.adapter,
  });

  final LoggerAdapter adapter;

  @override
  bool updateShouldNotify(covariant _LoggerAdapterScope oldWidget) => false;
}
