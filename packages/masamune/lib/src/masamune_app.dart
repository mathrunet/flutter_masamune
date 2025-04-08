part of '/masamune.dart';

/// Default locale.
///
/// デフォルトのロケール。
const kDefaultLocales = [Locale("en", "US")];

/// Function to apply [MasamuneAdapter] for Masamune Framework just before [runApp], etc.
///
/// Runs instead of [runApp].
///
/// [runApp] internally by passing [masamuneApp] to [masamuneApp].
///
/// Passing [masamuneAdapters] makes it easy to use additional plug-ins for the Masamune Framework.
///
/// (If [masamuneAdapters] is specified, `adapters` must also be passed in [MasamuneApp].
///
/// Masamune Framework用の[MasamuneAdapter]を[runApp]の直前などに適用するためのファンクション。
///
/// [runApp]の代わりに実行します。
///
/// [masamuneApp]に[MasamuneApp]を渡すことで内部で[runApp]を実行します。
///
/// [masamuneAdapters]を渡すことでMasamune Frameworkの追加プラグインを楽に利用することができます。
/// （[masamuneAdapters]を指定する場合は[MasamuneApp]内でも`adapters`を渡してください。）
Future<void> runMasamuneApp(
  MasamuneApp Function(MasamuneRef ref) masamuneApp, {
  // TODO: 非アクティブにするが一応残しておく
  // bool setPathUrlStrategy = true,
  List<MasamuneAdapter> masamuneAdapters = const [],
  List<LoggerAdapter> loggerAdapters = const [],
}) async {
  // TODO: 非アクティブにするが一応残しておく
  // if (setPathUrlStrategy) {
  //   AppRouter.setPathUrlStrategy();
  // }
  masamuneAdapters = masamuneAdapters.sortTo(
    (a, b) => a.priority.compareTo(b.priority),
  );
  final useRunZonedGuarded = masamuneAdapters.any((e) => e.runZonedGuarded);
  if (useRunZonedGuarded) {
    runZonedGuarded(() async {
      final binding = WidgetsFlutterBinding.ensureInitialized();
      for (final adapter in masamuneAdapters) {
        await adapter.onPreRunApp(binding);
      }
      runApp(
        masamuneApp.call(
          MasamuneRef._(
            adapters: masamuneAdapters,
            loggerAdapters: loggerAdapters,
          ),
        ),
      );
    }, (error, stack) {
      for (final adapter in masamuneAdapters) {
        adapter.onError(error, stack);
      }
    });
  } else {
    final binding = WidgetsFlutterBinding.ensureInitialized();
    for (final adapter in masamuneAdapters) {
      await adapter.onPreRunApp(binding);
    }
    runApp(
      masamuneApp.call(
        MasamuneRef._(
          adapters: masamuneAdapters,
          loggerAdapters: loggerAdapters,
        ),
      ),
    );
  }
}

/// `runMasamuneApp`で返されるオブジェクト。
///
/// このオブジェクトを用いてMasamune Frameworkのアダプターを取得することができます。
class MasamuneRef {
  MasamuneRef._({
    required this.adapters,
    required List<LoggerAdapter> loggerAdapters,
  }) : _loggerAdapters = loggerAdapters;

  /// Adapters for Masamune Framework.
  ///
  /// Masamune Framework用のアダプター。
  final List<MasamuneAdapter> adapters;

  /// Adapters for logging.
  ///
  /// ロギング用のアダプター。
  final List<LoggerAdapter> _loggerAdapters;

  /// Observers can be set up to monitor transitions between pages.
  ///
  /// ページ間の遷移を監視するためのオブザーバーを設置することができます。
  List<NavigatorObserver> get navigatorObservers =>
      adapters.expand((e) => e.navigatorObservers).toList();

  /// Adapters can be defined to add logger functionality.
  ///
  /// ロガー機能を追加するためのアダプターを定義することができます。
  List<LoggerAdapter> get loggerAdapters => [
        ..._loggerAdapters,
        ...adapters.expand((e) => e.loggerAdapters),
      ];
}

/// [MaterialApp] for Masamune Framework.
///
/// It encapsulates the XXScope widget used in a series of katana packages. In addition, XXXScope can be specified by adding [onBuildAppFilters].
///
/// You can pass the [AppRef] used in `katana_scoped` in [appRef].
///
/// You can pass [AppThemeData] used in `katana_theme` in [theme]. You can also specify [ThemeMode] in [themeMode].
///
/// You can pass [AppLocalizeBase] used by `katana_localize` in [localize].
///
/// Other adapters for data and authentication such as [modelAdapter] and [authAdapter] can be passed.
///
/// It is also possible to install additional plug-in adapters for the Masamune Framework in [masamuneAdapters].
///
/// You can pass the [AppRouter] used by `katana_router` in [routerConfig].
///
/// If you do not pass [routerConfig], you can also use Flutter"s native routing functionality as you normally would with [MaterialApp], using [routes], [initialRoute], [onGenerateRoute], [onGenerateInitialRoutes], [onUnknownRoute ], [builder], [navigatorObservers], and [scaffoldMessengerKey] to take advantage of Flutter"s native routing capabilities.
///
/// You can also use [home] to display a single widget. (available in Example, for example).
///
/// The application title can be set with [title] and [onGenerateTitle].
///
/// The debug banner can be displayed with [debugShowCheckedModeBanner] and the performance overlay can be displayed with [showPerformanceOverlay].
///
/// Masamune Framework用の[MaterialApp]。
///
/// 一連のkatanaのパッケージで利用されているXXScopeのウィジェットを内包しています。さらに[onBuildAppFilters]を追加することでXXXScopeを指定することも可能です。
///
/// [appRef]で`katana_scoped`で使われている[AppRef]を渡すことができます。
///
/// [theme]で`katana_theme`で使われている[AppThemeData]を渡すことができます。また、[themeMode]で[ThemeMode]をあわせて指定できます。
///
/// [localize]で`katana_localize`で利用されている[AppLocalizeBase]を渡すことができます。
///
/// その他、[modelAdapter]や[authAdapter]といったデータや認証用のアダプターを渡すことが可能です。
/// また、[masamuneAdapters]でMasamune Frameworkの追加プラグインアダプターを導入することが可能です。
///
/// [routerConfig]で`katana_router`で使われている[AppRouter]を渡すことができます。
///
/// [routerConfig]を渡さなかった場合、通常の[MaterialApp]と同じ様に[routes]や[initialRoute]、[onGenerateRoute]、[onGenerateInitialRoutes]、[onUnknownRoute]、[builder]、[navigatorObservers]、[scaffoldMessengerKey]を用いてFlutterネイティブのルーティング機能を利用することも可能です。
///
/// また、[home]を用いて単一のウィジェットを表示することができます。（Exampleなどで利用可能です）
///
/// [title]、[onGenerateTitle]でアプリタイトルを設定することが可能です。
///
/// [debugShowCheckedModeBanner]でデバッグ用のバナーを表示することができ、[showPerformanceOverlay]でパフォーマンスのオーバーレイを表示することができます。
@immutable
class MasamuneApp extends StatefulWidget {
  /// [MaterialApp] for Masamune Framework.
  ///
  /// It encapsulates the XXScope widget used in a series of katana packages. In addition, XXXScope can be specified by adding [onBuildAppFilters].
  ///
  /// You can pass the [AppRef] used in `katana_scoped` in [appRef].
  ///
  /// You can pass [AppThemeData] used in `katana_theme` in [theme]. You can also specify [ThemeMode] in [themeMode].
  ///
  /// You can pass [AppLocalizeBase] used by `katana_localize` in [localize].
  ///
  /// Other adapters for data and authentication such as [modelAdapter] and [authAdapter] can be passed.
  ///
  /// It is also possible to install additional plug-in adapters for the Masamune Framework in [masamuneAdapters].
  ///
  /// You can pass the [AppRouter] used by `katana_router` in [routerConfig].
  ///
  /// If you do not pass [routerConfig], you can also use Flutter"s native routing functionality as you normally would with [MaterialApp], using [routes], [initialRoute], [onGenerateRoute], [onGenerateInitialRoutes], [onUnknownRoute ], [builder], [navigatorObservers], and [scaffoldMessengerKey] to take advantage of Flutter"s native routing capabilities.
  ///
  /// You can also use [home] to display a single widget. (available in Example, for example).
  ///
  /// The application title can be set with [title] and [onGenerateTitle].
  ///
  /// The debug banner can be displayed with [debugShowCheckedModeBanner] and the performance overlay can be displayed with [showPerformanceOverlay].
  ///
  /// Masamune Framework用の[MaterialApp]。
  ///
  /// 一連のkatanaのパッケージで利用されているXXScopeのウィジェットを内包しています。さらに[onBuildAppFilters]を追加することでXXXScopeを指定することも可能です。
  ///
  /// [appRef]で`katana_scoped`で使われている[AppRef]を渡すことができます。
  ///
  /// [theme]で`katana_theme`で使われている[AppThemeData]を渡すことができます。また、[themeMode]で[ThemeMode]をあわせて指定できます。
  ///
  /// [localize]で`katana_localize`で利用されている[AppLocalizeBase]を渡すことができます。
  ///
  /// その他、[modelAdapter]や[authAdapter]といったデータや認証用のアダプターを渡すことが可能です。
  /// また、[masamuneAdapters]でMasamune Frameworkの追加プラグインアダプターを導入することが可能です。
  ///
  /// [routerConfig]で`katana_router`で使われている[AppRouter]を渡すことができます。
  ///
  /// [routerConfig]を渡さなかった場合、通常の[MaterialApp]と同じ様に[routes]や[initialRoute]、[onGenerateRoute]、[onGenerateInitialRoutes]、[onUnknownRoute]、[builder]、[navigatorObservers]、[scaffoldMessengerKey]を用いてFlutterネイティブのルーティング機能を利用することも可能です。
  ///
  /// また、[home]を用いて単一のウィジェットを表示することができます。（Exampleなどで利用可能です）
  ///
  /// [title]、[onGenerateTitle]でアプリタイトルを設定することが可能です。
  ///
  /// [debugShowCheckedModeBanner]でデバッグ用のバナーを表示することができ、[showPerformanceOverlay]でパフォーマンスのオーバーレイを表示することができます。
  const MasamuneApp({
    super.key,
    this.appRef,
    this.authAdapter,
    this.storageAdapter,
    this.functionsAdapter,
    this.loggerAdapters = const [],
    this.theme,
    this.localize,
    this.routerConfig,
    this.modelAdapter = const RuntimeModelAdapter(),
    this.debugShowCheckedModeBanner = true,
    this.showPerformanceOverlay = false,
    this.title = "",
    this.themeMode = ThemeMode.system,
    this.routes = const <String, WidgetBuilder>{},
    this.navigatorObservers = const <NavigatorObserver>[],
    this.scaffoldMessengerKey,
    this.onGenerateTitle,
    this.home,
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.builder,
    this.onBuildAppFilters,
    this.masamuneAdapters = const <MasamuneAdapter>[],
    this.localizationsDelegates,
    this.supportedLocales,
    this.onBuildPageFilters,
  });

  /// Restart the application by passing [context].
  ///
  /// Reload all widgets and states.
  ///
  /// You can describe the process at restart by passing [onRestart].
  ///
  /// [context]を渡すことでアプリをリスタートします。
  ///
  /// すべてのウィジェットや状態をリロードします。
  ///
  /// [onRestart]を渡すことでリスタート時の処理を記述することができます。
  static Future<void> restartApp(
    BuildContext context, {
    FutureOr<void> Function()? onRestart,
  }) async {
    final state = context.findAncestorStateOfType<_MasamuneAppState>();
    await state?._restart(onRestart);
  }

  /// You can specify a list of supported locales.
  ///
  /// サポートするロケールの一覧を指定することができます。
  final List<Locale>? supportedLocales;

  /// You can specify the plug-in adapter used by Masamune Framework.
  ///
  /// Masamune Frameworkで用いられるプラグインアダプターを指定することができます。
  final List<MasamuneAdapter> masamuneAdapters;

  /// Theme data used by `katana_theme`.
  ///
  /// `katana_theme`で利用されるテーマデータ。
  final AppThemeData? theme;

  /// Data for localization used by `katana_localize`.
  ///
  /// `katana_localize`で利用されるローカライズ用のデータ。
  final AppLocalizeBase? localize;

  /// Ref for application scope called by `katana_scoped`.
  ///
  /// `katana_scoped`で呼び出されるアプリケーションスコープ用のref。
  final AppRef? appRef;

  /// Adapter for authentication used by `katana_auth`.
  ///
  /// `katana_auth`で利用される認証用のアダプター。
  final AuthAdapter? authAdapter;

  /// Adapter for database used by `katana_model`.
  ///
  /// `katana_model`で利用されるデータベース用のアダプター。
  final ModelAdapter? modelAdapter;

  /// Adapter for file storage used by `katana_storage`.
  ///
  /// `katana_storage`で利用されるファイルストレージ用のアダプター。
  final StorageAdapter? storageAdapter;

  /// Adapter for server processing used by `katana_functions`.
  ///
  /// `katana_functions`で利用されるサーバー処理用のアダプター。
  final FunctionsAdapter? functionsAdapter;

  /// Adapter for logging used by `katana_logger`.
  ///
  /// `katana_logger`で利用されるロギング用のアダプター。
  final List<LoggerAdapter> loggerAdapters;

  /// Config for router used by `katana_router`.
  ///
  /// `katana_router`で利用されるルーター用のコンフィグ。
  final RouterConfig<Object>? routerConfig;

  /// [GlobalKey] for storing [ScaffoldMessengerState].
  ///
  /// This is used when putting out a SnackBar.
  ///
  /// [ScaffoldMessengerState]を格納するための[GlobalKey]。
  ///
  /// SnackBarを出したりする場合に利用します。
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// If this is set to `true`, a banner is displayed in the upper right corner in debug mode.
  ///
  /// これが`true`になっている場合、デバッグモード時右上にバナーが表示されます。
  final bool debugShowCheckedModeBanner;

  /// If this is `true`, the performance status is displayed in an overlay.
  ///
  /// これが`true`になっている場合、パフォーマンスの状況がオーバーレイで表示されます。
  final bool showPerformanceOverlay;

  /// Specify the title of the application.
  ///
  /// If you want to dynamically generate the title, use [onGenerateTitle].
  ///
  /// アプリのタイトルを指定します。
  ///
  /// タイトルを動的に出したい場合は[onGenerateTitle]を利用してください。
  final String title;

  /// Specify the title of the application dynamically.
  ///
  /// Return the title in the return value of the callback.
  ///
  /// アプリのタイトルを動的に指定します。
  ///
  /// コールバックの戻り値でタイトルを返してください。
  final String Function(BuildContext)? onGenerateTitle;

  /// Specify the theme mode for the application.
  ///
  /// If [ThemeMode.system], it follows the system settings.
  ///
  /// アプリのテーマモードを指定します。
  ///
  /// [ThemeMode.system]だとシステムの設定に従います。
  final ThemeMode? themeMode;

  /// Specify the widget to be displayed first.
  ///
  /// If this is not [Null], priority is given even if [routerConfig] is specified.
  ///
  /// 最初に表示するウィジェットを指定します。
  ///
  /// これが[Null]でない場合、[routerConfig]が指定された場合でも優先的に表示されます。
  final Widget? home;

  /// If [routerConfig] is not specified or [home] is specified, this is used to specify subsequent routing.
  ///
  /// Specify a route name as the key for [Map] and a callback that returns the widget to be displayed as the value.
  ///
  /// [routerConfig]が指定されていない場合や[home]が指定されている場合、その後のルーティングを指定する際に利用します。
  ///
  /// [Map]のキーにルート名を指定し、値に表示するウィジェットを返すコールバックを指定します。
  final Map<String, Widget Function(BuildContext)> routes;

  /// Specifies the initial route name when [routes] is used.
  ///
  /// [routes]を用いる場合の初期ルート名を指定します。
  final String? initialRoute;

  /// If [routerConfig] is not specified, a callback that is executed when the route is generated.
  ///
  /// The route information to be generated is passed to [routeSettings].
  ///
  /// Return the generated [Route] in the return value.
  ///
  /// [routerConfig]が指定されていない場合、ルートが生成される際に実行されるコールバック。
  ///
  /// [routeSettings]に生成したいルートの情報が渡されます。
  ///
  /// 戻り値に生成した[Route]を返してください。
  final Route<dynamic>? Function(RouteSettings routeSettings)? onGenerateRoute;

  /// If [routerConfig] is not specified, this callback is executed when the first route is configured.
  ///
  /// The route name is passed to [routePath] for the first time.
  ///
  /// Return a list of generated [Route] in the return value.
  ///
  /// [routerConfig]が指定されていない場合、初回のルートが設定されている場合に実行されるコールバック。
  ///
  /// [routePath]に初回のルート名が渡されます。
  ///
  /// 戻り値に生成した[Route]のリストを返してください。
  final List<Route<dynamic>> Function(String routePath)?
      onGenerateInitialRoutes;

  /// If [routerConfig] is not specified, this callback is called when a route name not listed in [routes] is queried.
  ///
  /// The route information to be generated is passed to [routeSettings].
  ///
  /// Return the generated [Route] in the return value.
  ///
  /// [routerConfig]が指定されていない場合、[routes]に記載されていないルート名がクエリされたときに呼ばれるコールバック。
  ///
  /// [routeSettings]に生成したいルートの情報が渡されます。
  ///
  /// 戻り値に生成した[Route]を返してください。
  final Route<dynamic>? Function(RouteSettings routeSettings)? onUnknownRoute;

  /// Observer to monitor navigation transitions.
  ///
  /// Enabled when [routerConfig] is not specified.
  ///
  /// When specifying [routerConfig], specify it as an argument to [RouterConfig] such as [AppRouter].
  ///
  /// ナビゲーションの遷移を監視するためのオブザーバー。
  ///
  /// [routerConfig]が指定されていない場合に有効になります。
  ///
  /// [routerConfig]を指定する際は、[AppRouter]など[RouterConfig]の引数に指定してください。
  final List<NavigatorObserver> navigatorObservers;

  /// If [routerConfig] is not specified, a callback that is executed after the widget created by [onGenerateRoute] or other methods is generated.
  ///
  /// The build context is passed to [context] and the generated widget to [child].
  ///
  /// Return a widget with [child] wrapped in the return value.
  ///
  /// [routerConfig]が指定されていない場合、[onGenerateRoute]などで作成されたウィジェットが生成された後に実行されるコールバック。
  ///
  /// [context]にビルドコンテキスト、[child]に生成されたウィジェットが渡されます。
  ///
  /// 戻り値に[child]をラッピングしたウィジェットを返してください。
  final Widget Function(BuildContext context, Widget? child)? builder;

  /// It is executed when the application is built.
  ///
  /// The widget generated by [build] of [MasamuneApp] is passed to [app].
  /// Wrap widgets to add functionality.
  ///
  /// Use it to add `Scope` widgets for other plug-ins, for example.
  ///
  /// アプリケーションをビルドする際に実行されます。
  ///
  /// [app]に[MasamuneApp]の[build]で生成されたウィジェットが渡されます。
  /// ウィジェットをラップして機能を追加してください。
  ///
  /// 他プラグインの`Scope`ウィジェットを追加する際などに用いてください。
  final List<Widget Function(BuildContext context, Widget app)>?
      onBuildAppFilters;

  /// It is executed when the page is built.
  ///
  /// The page generated in [MasamuneApp] is passed to [page].
  ///
  /// Returning [Widget] will build the widget.
  ///
  /// [MasamuneApp]のビルド時にウィジェットを追加することが可能です。
  final List<Widget Function(BuildContext context, Widget page)>?
      onBuildPageFilters;

  /// Define a list of [LocalizationsDelegate].
  ///
  /// [LocalizationsDelegate]のリストを定義します。
  final List<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  @override
  State<StatefulWidget> createState() => _MasamuneAppState();
}

class _MasamuneAppState extends State<MasamuneApp> {
  UniqueKey? _key = UniqueKey();
  late Locale _locale;

  Iterable<Locale> get _supportedLocales =>
      widget.supportedLocales ??
      widget.localize?.supportedLocales() ??
      kDefaultLocales;

  @override
  void initState() {
    super.initState();
    _locale = _resolveLocales(
      WidgetsBinding.instance.platformDispatcher.locales,
      _supportedLocales,
    );
    widget.theme?.applyLocale(_locale);
    for (final adapter in widget.masamuneAdapters) {
      BootRouteQuery.register(adapter.onMaybeBoot);
    }
  }

  Locale _resolveLocales(
    List<Locale>? preferredLocales,
    Iterable<Locale> supportedLocales,
  ) {
    if (widget.localize?.localeResolutionCallback() != null) {
      final locale = widget.localize?.localeResolutionCallback()(
        preferredLocales != null && preferredLocales.isNotEmpty
            ? preferredLocales.first
            : null,
        supportedLocales,
      );
      if (locale != null) {
        return locale;
      }
    }
    return basicLocaleListResolution(preferredLocales, supportedLocales);
  }

  Future<void> _restart(FutureOr<void> Function()? onRestart) async {
    if (onRestart != null) {
      setState(() {
        _key = null;
      });
      try {
        widget.appRef?.clear();
        await onRestart();
        final router = widget.routerConfig;
        if (router != null && router is AppRouter) {
          router.clear();
        }
        final modelAdapter = widget.modelAdapter;
        if (modelAdapter != null) {
          await modelAdapter.clearCache();
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    setState(() {
      _key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_key == null) {
      return const Empty();
    }
    var child = _buildAppFunctions(
      context,
      _buildAppStorage(
        context,
        _buildAppAuth(
          context,
          _buildAppLogger(
            context,
            _buildAppModel(
              context,
              _buildAppScoped(
                context,
                _buildAppTheme(
                  context,
                  _buildAppLocalize(
                    context,
                    _buildAppRouter(context),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final appFilters = [
      ...widget.masamuneAdapters.map((e) => e.onBuildApp),
      if (widget.onBuildAppFilters != null) ...widget.onBuildAppFilters!,
    ];
    if (appFilters.isEmpty) {
      return child;
    }
    for (final builder in appFilters) {
      child = builder.call(context, child);
    }
    return Container(
      key: _key,
      child: child,
    );
  }

  Widget _buildAppModel(BuildContext context, Widget child) {
    if (widget.modelAdapter != null) {
      return ModelAdapterScope(
        adapter: widget.modelAdapter!,
        child: child,
      );
    }
    return child;
  }

  Widget _buildAppFunctions(BuildContext context, Widget child) {
    if (widget.functionsAdapter != null) {
      return FunctionsAdapterScope(
        adapter: widget.functionsAdapter!,
        child: child,
      );
    }
    return child;
  }

  Widget _buildAppScoped(BuildContext context, Widget child) {
    if (widget.appRef != null) {
      return AppScoped(
        appRef: widget.appRef!,
        child: child,
      );
    }
    return child;
  }

  Widget _buildAppAuth(BuildContext context, Widget child) {
    if (widget.authAdapter != null) {
      return AuthAdapterScope(
        adapter: widget.authAdapter!,
        child: child,
      );
    }
    return child;
  }

  Widget _buildAppTheme(BuildContext context, Widget child) {
    if (widget.theme != null) {
      return AppThemeScope(
        theme: widget.theme!,
        child: child,
      );
    }
    return child;
  }

  Widget _buildAppLocalize(BuildContext context, Widget child) {
    if (widget.localize != null) {
      return LocalizeScope(
        localize: widget.localize!,
        builder: (context, localize) => child,
      );
    }
    return child;
  }

  Widget _buildAppLogger(BuildContext context, Widget child) {
    final loggerAdapters = <LoggerAdapter>[];
    for (final adapter in widget.loggerAdapters) {
      if (loggerAdapters.contains(adapter)) {
        continue;
      }
      loggerAdapters.add(adapter);
    }
    for (final adapter
        in widget.masamuneAdapters.expand((e) => e.loggerAdapters)) {
      if (loggerAdapters.contains(adapter)) {
        continue;
      }
      loggerAdapters.add(adapter);
    }

    if (loggerAdapters.isNotEmpty) {
      return LoggerAdapterScope(
        adapters: loggerAdapters,
        child: child,
      );
    }
    return child;
  }

  Widget _buildAppStorage(BuildContext context, Widget child) {
    if (widget.storageAdapter != null) {
      return StorageAdapterScope(
        adapter: widget.storageAdapter!,
        child: child,
      );
    }
    return child;
  }

  Widget _buildAppRouter(BuildContext context) {
    final observers = <NavigatorObserver>[];
    for (final observer in widget.navigatorObservers) {
      if (observers.contains(observer)) {
        continue;
      }
      observers.add(observer);
    }
    for (final observer
        in widget.masamuneAdapters.expand((e) => e.navigatorObservers)) {
      if (observers.contains(observer)) {
        continue;
      }
      observers.add(observer);
    }
    final pageFilters = [
      ...widget.masamuneAdapters.map((e) => e.onBuildPage),
      if (widget.onBuildPageFilters != null) ...widget.onBuildPageFilters!,
    ];

    if (widget.home != null || widget.routerConfig == null) {
      return MaterialApp(
        locale: _locale,
        supportedLocales: widget.supportedLocales ??
            widget.localize?.supportedLocales() ??
            kDefaultLocales,
        localizationsDelegates: widget.localize
                ?.delegates(widget.localizationsDelegates ?? const []) ??
            widget.localizationsDelegates,
        localeResolutionCallback: widget.localize?.localeResolutionCallback(),
        theme: widget.theme?.toThemeData(brightness: Brightness.light),
        darkTheme: widget.theme?.toThemeData(brightness: Brightness.dark),
        scaffoldMessengerKey: widget.scaffoldMessengerKey,
        title: widget.title,
        onGenerateTitle: widget.onGenerateTitle,
        themeMode: widget.theme?.themeMode ?? widget.themeMode,
        home: widget.home,
        routes: widget.routes,
        initialRoute: widget.initialRoute,
        onGenerateRoute: widget.onGenerateRoute,
        onGenerateInitialRoutes: widget.onGenerateInitialRoutes,
        onUnknownRoute: widget.onUnknownRoute,
        navigatorObservers: observers,
        builder: (context, child) {
          child ??= const SizedBox.shrink();
          for (final builder in pageFilters) {
            child = builder.call(context, child!);
          }
          return widget.builder?.call(context, child!) ?? child!;
        },
      );
    } else {
      if (widget.routerConfig is AppRouter) {
        final navigatorObservers =
            (widget.routerConfig as AppRouter).navigatorObservers;
        for (final observer in observers) {
          if (navigatorObservers.contains(observer)) {
            continue;
          }
          navigatorObservers.add(observer);
        }
      }
      return MaterialApp.router(
        routerConfig: widget.routerConfig,
        locale: widget.localize?.locale,
        supportedLocales: widget.supportedLocales ??
            widget.localize?.supportedLocales() ??
            kDefaultLocales,
        localizationsDelegates: widget.localize
                ?.delegates(widget.localizationsDelegates ?? const []) ??
            widget.localizationsDelegates,
        localeResolutionCallback: widget.localize?.localeResolutionCallback(),
        theme: widget.theme?.toThemeData(brightness: Brightness.light),
        darkTheme: widget.theme?.toThemeData(brightness: Brightness.dark),
        debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
        showPerformanceOverlay: widget.showPerformanceOverlay,
        scaffoldMessengerKey: widget.scaffoldMessengerKey,
        title: widget.title,
        onGenerateTitle: widget.onGenerateTitle,
        themeMode: widget.theme?.themeMode ?? widget.themeMode,
        builder: (context, child) {
          child ??= const SizedBox.shrink();
          for (final builder in pageFilters) {
            child = builder.call(context, child!);
          }
          return widget.builder?.call(context, child!) ?? child!;
        },
      );
    }
  }
}
