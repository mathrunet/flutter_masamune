part of '/katana_functions.dart';

/// An adapter to provide an interface to perform server-side processing.
///
/// Communicate with each server to return the appropriate response.
///
/// サーバー側の処理を実行するためのインターフェースを提供するためのアダプター。
///
/// 各サーバーと通信して適切なレスポンスを返すようにしてください。
@immutable
abstract class FunctionsAdapter {
  /// An adapter to provide an interface to perform server-side processing.
  ///
  /// Communicate with each server to return the appropriate response.
  ///
  /// サーバー側の処理を実行するためのインターフェースを提供するためのアダプター。
  ///
  /// 各サーバーと通信して適切なレスポンスを返すようにしてください。
  const FunctionsAdapter();

  /// You can retrieve the [FunctionsAdapter] first given by [FunctionsAdapterScope].
  ///
  /// 最初に[FunctionsAdapterScope]で与えた[FunctionsAdapter]を取得することができます。
  static FunctionsAdapter get primary {
    assert(
      _primary != null,
      "FunctionsAdapter is not set. Place [FunctionsAdapterScope] widget closer to the root.",
    );
    return _primary ?? const RuntimeFunctionsAdapter();
  }

  static FunctionsAdapter? _primary;

  /// URL of the endpoint where the Functions are executed.
  ///
  /// Functionsを実行するエンドポイントのURL。
  String get endpoint;

  /// Executes a Function with [action].
  ///
  /// A [FunctionsAction] and [FunctionsActionResponse] must be prepared for each mode.
  ///
  /// [action]を持つFunctionを実行します。
  ///
  /// 各モードに応じた[FunctionsAction]と[FunctionsActionResponse]を用意する必要があります。
  Future<TResponse> execute<TResponse>(
    FunctionsAction<TResponse> action,
  );
}

/// [FunctionsAdapter] for the entire app by placing it on top of [MaterialApp], etc.
///
/// Pass [FunctionsAdapter] to [adapter].
///
/// Also, by using [FunctionsAdapterScope.of] in a descendant widget, you can retrieve the [FunctionsAdapter] set in the [FunctionsAdapterScope].
///
/// [MaterialApp]などの上に配置して、アプリ全体に[FunctionsAdapter]を設定します。
///
/// [adapter]に[FunctionsAdapter]を渡してください。
///
/// また[FunctionsAdapterScope.of]を子孫のウィジェット内で利用することにより[FunctionsAdapterScope]で設定された[FunctionsAdapter]を取得することができます。
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return FunctionsAdapterScope(
///       adapter: const RuntimeFunctionsAdapter(),
///       child: MaterialApp(
///         home: const StoragePage(),
///       ),
///     );
///   }
/// }
/// ```
class FunctionsAdapterScope extends StatefulWidget {
  /// [FunctionsAdapter] for the entire app by placing it on top of [MaterialApp], etc.
  ///
  /// Pass [FunctionsAdapter] to [adapter].
  ///
  /// Also, by using [FunctionsAdapterScope.of] in a descendant widget, you can retrieve the [FunctionsAdapter] set in the [FunctionsAdapterScope].
  ///
  /// [MaterialApp]などの上に配置して、アプリ全体に[FunctionsAdapter]を設定します。
  ///
  /// [adapter]に[FunctionsAdapter]を渡してください。
  ///
  /// また[FunctionsAdapterScope.of]を子孫のウィジェット内で利用することにより[FunctionsAdapterScope]で設定された[FunctionsAdapter]を取得することができます。
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return FunctionsAdapterScope(
  ///       adapter: const RuntimeFunctionsAdapter(),
  ///       child: MaterialApp(
  ///         home: const StoragePage(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const FunctionsAdapterScope({
    super.key,
    required this.child,
    required this.adapter,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// [FunctionsAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[FunctionsAdapter]。
  final FunctionsAdapter adapter;

  /// By passing [context], the [FunctionsAdapter] set in [FunctionsAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [FunctionsAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[FunctionsAdapterScope]で設定された[FunctionsAdapter]を取得することができます。
  ///
  /// 祖先に[FunctionsAdapterScope]がない場合はエラーになります。
  static FunctionsAdapter? of(BuildContext context) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<_FunctionsAdapterScope>();
    assert(
      scope != null,
      "FunctionsAdapterScope is not found. Place [FunctionsAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as _FunctionsAdapterScope?)?.adapter;
  }

  @override
  State<StatefulWidget> createState() => _FunctionsAdapterScopeState();
}

class _FunctionsAdapterScopeState extends State<FunctionsAdapterScope> {
  @override
  void initState() {
    super.initState();
    FunctionsAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _FunctionsAdapterScope(
      adapter: widget.adapter,
      child: widget.child,
    );
  }
}

class _FunctionsAdapterScope extends InheritedWidget {
  const _FunctionsAdapterScope({
    required super.child,
    required this.adapter,
  });

  final FunctionsAdapter adapter;

  @override
  bool updateShouldNotify(covariant _FunctionsAdapterScope oldWidget) => false;
}
