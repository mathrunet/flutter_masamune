part of masamune;

/// Adapter for easily adding functions to Masamune Framework.
///
/// Setting [runZonedGuarded] to `true` allows wrapping [runApp] with [runZonedGuarded].
/// At that time, [onPreRunApp] can be used to execute the process before [runApp], and [onError] can be used to describe the process in case of an error.
///
/// You can set up observers to monitor transitions between pages at [navigatorObservers].
///
/// Various adapters for the katana package are available at [loggerAdapters], etc.
///
/// Widgets can be added during the build of [MasamuneApp] with [onBuildApp].
///
/// Masamune Frameworkに機能を手軽に追加するためのアダプター。
///
/// アプリ起動時と[MasamuneApp]に渡す処理を記述することができます。
///
/// [runZonedGuarded]を`true`にすると[runApp]を[runZonedGuarded]でラッピングすることができます。
/// その際、[onPreRunApp]で[runApp]前の処理を実行することができ、[onError]でエラー時の処理を記述することができます。
///
/// [navigatorObservers]でページ間の遷移を監視するためのオブザーバーを設置することができます。
///
/// [loggerAdapters]などでkatanaパッケージの各種アダプターを利用することが可能です。
///
/// [onBuildApp]で[MasamuneApp]のビルド時にウィジェットを追加することが可能です。
abstract class MasamuneAdapter {
  /// Adapter for easily adding functions to Masamune Framework.
  ///
  /// Setting [runZonedGuarded] to `true` allows wrapping [runApp] with [runZonedGuarded].
  /// At that time, [onPreRunApp] can be used to execute the process before [runApp], and [onError] can be used to describe the process in case of an error.
  ///
  /// You can set up observers to monitor transitions between pages at [navigatorObservers].
  ///
  /// Various adapters for the katana package are available at [loggerAdapters], etc.
  ///
  /// Widgets can be added during the build of [MasamuneApp] with [onBuildApp].
  ///
  /// Masamune Frameworkに機能を手軽に追加するためのアダプター。
  ///
  /// アプリ起動時と[MasamuneApp]に渡す処理を記述することができます。
  ///
  /// [runZonedGuarded]を`true`にすると[runApp]を[runZonedGuarded]でラッピングすることができます。
  /// その際、[onPreRunApp]で[runApp]前の処理を実行することができ、[onError]でエラー時の処理を記述することができます。
  ///
  /// [navigatorObservers]でページ間の遷移を監視するためのオブザーバーを設置することができます。
  ///
  /// [loggerAdapters]などでkatanaパッケージの各種アダプターを利用することが可能です。
  ///
  /// [onBuildApp]で[MasamuneApp]のビルド時にウィジェットを追加することが可能です。
  const MasamuneAdapter();

  /// If you set this to `true`, you can wrap [runApp] with [runZonedGuarded].
  ///
  /// これを`true`にした場合、[runApp]を[runZonedGuarded]でラッピングすることができます。
  bool get runZonedGuarded => false;

  /// Observers can be set up to monitor transitions between pages.
  ///
  /// ページ間の遷移を監視するためのオブザーバーを設置することができます。
  List<NavigatorObserver> get navigatorObservers => const [];

  /// Adapters can be defined to add logger functionality.
  ///
  /// ロガー機能を追加するためのアダプターを定義することができます。
  List<LoggerAdapter> get loggerAdapters => const [];

  /// Widgets can be added during the build of [MasamuneApp].
  ///
  /// The widget generated in [MasamuneApp] is passed to [app].
  ///
  /// Returning [Widget] will build the widget.
  ///
  /// [MasamuneApp]のビルド時にウィジェットを追加することが可能です。
  ///
  /// [app]に[MasamuneApp]内で生成されたウィジェットが渡されます。
  ///
  /// [Widget]を返すとそのウィジェットがビルドされます。
  Widget onBuildApp(BuildContext context, Widget app) {
    return app;
  }

  /// Called when initializing [MasamuneAdapterScope].
  ///
  /// It is possible to describe processes such as receiving an `[adapter]' and making it a `primary` adapter.
  ///
  /// [MasamuneAdapterScope]を初期化するときに呼ばれます。
  ///
  /// [adapter]を受け取って`primary`のアダプターにするなどの処理を記述することができます。
  void onInitScope(MasamuneAdapter adapter) {}

  /// You can describe the process before [runApp].
  ///
  /// [runApp]前の処理を記述することができます。
  FutureOr<void> onPreRunApp() {}

  /// You can describe the process when [runZonedGuarded] is set to `true`.
  ///
  /// The object in which the error occurred is passed to [error] and [stackTrace].
  ///
  /// [runZonedGuarded]を`true`にした場合の処理を記述することができます。
  ///
  /// [error]と[stackTrace]にエラーが起きた際のオブジェクトが渡されます。
  void onError(Object error, StackTrace stackTrace) {}
}

/// [MasamuneAdapter] for the entire app by placing it on top of [MaterialApp], etc.
///
/// Pass [MasamuneAdapter] to [adapter].
///
/// Also, by using [MasamuneAdapterScope.of] in a descendant widget, you can retrieve the [MasamuneAdapter] set in the [MasamuneAdapterScope].
///
/// [MaterialApp]などの上に配置して、アプリ全体に[MasamuneAdapter]を設定します。
///
/// [adapter]に[MasamuneAdapter]を渡してください。
///
/// また[MasamuneAdapterScope.of]を子孫のウィジェット内で利用することにより[MasamuneAdapterScope]で設定された[MasamuneAdapter]を取得することができます。
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return MasamuneAdapterScope(
///       adapter: const FileMasamuneAdapter(),
///       child: MaterialApp(
///         home: const PickerPage(),
///       ),
///     );
///   }
/// }
/// ```
class MasamuneAdapterScope<TAdapter extends MasamuneAdapter>
    extends StatefulWidget {
  /// [MasamuneAdapter] for the entire app by placing it on top of [MaterialApp], etc.
  ///
  /// Pass [MasamuneAdapter] to [adapter].
  ///
  /// Also, by using [MasamuneAdapterScope.of] in a descendant widget, you can retrieve the [MasamuneAdapter] set in the [MasamuneAdapterScope].
  ///
  /// [MaterialApp]などの上に配置して、アプリ全体に[MasamuneAdapter]を設定します。
  ///
  /// [adapter]に[MasamuneAdapter]を渡してください。
  ///
  /// また[MasamuneAdapterScope.of]を子孫のウィジェット内で利用することにより[MasamuneAdapterScope]で設定された[MasamuneAdapter]を取得することができます。
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return MasamuneAdapterScope(
  ///       adapter: const FileMasamuneAdapter(),
  ///       child: MaterialApp(
  ///         home: const PickerPage(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const MasamuneAdapterScope({
    super.key,
    this.onInit,
    required this.child,
    required this.adapter,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// [MasamuneAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[MasamuneAdapter]。
  final TAdapter adapter;

  /// Describe the process when this widget is initialized.
  ///
  /// [MasamuneAdapter] is passed to [adapter].
  ///
  /// このウィジェットが初期化されたときの処理を記述します。
  ///
  /// [adapter]に[MasamuneAdapter]が渡されます。
  final void Function(TAdapter adapter)? onInit;

  /// By passing [context], the [MasamuneAdapter] set in [MasamuneAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [MasamuneAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[MasamuneAdapterScope]で設定された[MasamuneAdapter]を取得することができます。
  ///
  /// 祖先に[MasamuneAdapterScope]がない場合はエラーになります。
  static TAdapter? of<TAdapter extends MasamuneAdapter>(BuildContext context) {
    final scope = context.getElementForInheritedWidgetOfExactType<
        _MasamuneAdapterScope<TAdapter>>();
    assert(
      scope != null,
      "MasamuneAdapterScope<TAdapter> is not found. Place [MasamuneAdapterScope<TAdapter>] widget closer to the root.",
    );
    return (scope?.widget as _MasamuneAdapterScope<TAdapter>?)?.adapter;
  }

  @override
  State<StatefulWidget> createState() => _MasamuneAdapterScopeState<TAdapter>();
}

class _MasamuneAdapterScopeState<TAdapter extends MasamuneAdapter>
    extends State<MasamuneAdapterScope<TAdapter>> {
  @override
  void initState() {
    super.initState();
    widget.onInit?.call(widget.adapter);
  }

  @override
  Widget build(BuildContext context) {
    return _MasamuneAdapterScope<TAdapter>(
      adapter: widget.adapter,
      child: widget.child,
    );
  }
}

class _MasamuneAdapterScope<TAdapter extends MasamuneAdapter>
    extends InheritedWidget {
  const _MasamuneAdapterScope({
    required super.child,
    required this.adapter,
  });

  final TAdapter adapter;

  @override
  bool updateShouldNotify(
          covariant _MasamuneAdapterScope<TAdapter> oldWidget) =>
      false;
}
