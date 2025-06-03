part of "/katana_logger.dart";

/// Base class for defining platform adapters for storing logs.
///
/// ログを保存するためのプラットフォームアダプターを定義するためのベースクラス。
abstract class LoggerAdapter {
  /// Base class for defining platform adapters for storing logs.
  ///
  /// ログを保存するためのプラットフォームアダプターを定義するためのベースクラス。
  const LoggerAdapter();

  /// You can retrieve the list of [LoggerAdapter] given in [LoggerAdapterScope] first.
  ///
  /// 最初に[LoggerAdapterScope]で与えた[LoggerAdapter]のリストを取得することができます。
  static List<LoggerAdapter> get primary {
    return _primary ?? [];
  }

  static List<LoggerAdapter>? _primary;
  static List<LoggerAdapter>? _test;

  /// Get a list of logs recorded.
  ///
  /// 記録されたログの一覧を取得します。
  Future<List<LogValue>> logList();

  /// Execute the process of saving the log by passing [name] and [parameters], which is the name of the log.
  ///
  /// ログの名前である[name]と[parameters]を渡してログを保存する処理を実行してください。
  Future<void> send(String name, {DynamicMap? parameters});

  /// Create [LoggerTraceValue] by passing [name], the name of the log.
  ///
  /// [LoggerTraceValue.start] to start tracking logs, [LoggerTraceValue.stop] to complete and save.
  ///
  /// ログの名前である[name]を渡して[LoggerTraceValue]を作成してください。
  ///
  /// [LoggerTraceValue.start]でログの追跡を開始して、[LoggerTraceValue.stop]で完了、保存します。
  LoggerTraceValue trace(String name);

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is LoggerAdapter) {
      return runtimeType == other.runtimeType;
    }
    return false;
  }
}

/// Place it on top of [MaterialApp], etc., and set [LoggerAdapter] for the entire app.
///
/// Pass the list of [LoggerAdapter] to [adapters].
///
/// Also, by using [LoggerAdapterScope.of] in a descendant widget, you can retrieve the [LoggerAdapter] set in the [LoggerAdapterScope].
///
/// [MaterialApp]などの上に配置して、アプリ全体に[LoggerAdapter]を設定します。
///
/// [adapters]に[LoggerAdapter]のリストを渡してください。
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
///       adapters: [const RuntimeLoggerAdapter()],
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
  /// Pass the list of [LoggerAdapter] to [adapters].
  ///
  /// Also, by using [LoggerAdapterScope.of] in a descendant widget, you can retrieve the [LoggerAdapter] set in the [LoggerAdapterScope].
  ///
  /// [MaterialApp]などの上に配置して、アプリ全体に[LoggerAdapter]を設定します。
  ///
  /// [adapters]に[LoggerAdapter]のリストを渡してください。
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
  ///       adapters: [const RuntimeLoggerAdapter()],
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
    required this.adapters,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// A list of [LoggerAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[LoggerAdapter]のリスト。
  final List<LoggerAdapter> adapters;

  /// A list of [LoggerAdapter] set in [LoggerAdapterScope] can be obtained by passing [context].
  ///
  /// If the ancestor does not have [LoggerAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[LoggerAdapterScope]で設定された[LoggerAdapter]のリストを取得することができます。
  ///
  /// 祖先に[LoggerAdapterScope]がない場合はエラーになります。
  static List<LoggerAdapter> of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<_LoggerAdapterScope>();
    assert(
      scope != null,
      "LoggerAdapterScope is not found. Place [LoggerAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as _LoggerAdapterScope?)?.adapters ?? [];
  }

  @override
  State<StatefulWidget> createState() => _LoggerAdapterScopeState();
}

class _LoggerAdapterScopeState extends State<LoggerAdapterScope> {
  @override
  void initState() {
    super.initState();
    LoggerAdapter._primary ??= widget.adapters;
  }

  @override
  Widget build(BuildContext context) {
    return _LoggerAdapterScope(
      adapters: widget.adapters,
      child: widget.child,
    );
  }
}

class _LoggerAdapterScope extends InheritedWidget {
  const _LoggerAdapterScope({
    required super.child,
    required this.adapters,
  });

  final List<LoggerAdapter> adapters;

  @override
  bool updateShouldNotify(covariant _LoggerAdapterScope oldWidget) => false;
}

/// Test scope for [LoggerAdapter].
///
/// [LoggerAdapter]のテスト用スコープ。
class TestLoggerAdapterScope {
  const TestLoggerAdapterScope._();

  /// Set the [LoggerAdapter] for testing.
  ///
  /// テスト用に[LoggerAdapter]を設定します。
  static void setTestAdapters(List<LoggerAdapter> adapters) {
    LoggerAdapter._test = adapters;
  }
}
