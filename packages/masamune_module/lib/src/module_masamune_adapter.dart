part of masamune_module;

@immutable
abstract class ModuleMasamuneAdapter extends MasamuneAdapter {
  const ModuleMasamuneAdapter({
    this.additionalMasamuneAdapters = const [],
    this.theme,
    this.authAdapter = const RuntimeAuthAdapter(),
    this.modelAdapter = const RuntimeModelAdapter(),
    this.storageAdapter = const RuntimeStorageAdapter(),
    this.functionsAdapter = const RuntimeFunctionsAdapter(),
    this.additionalLoggerAdapters = const [
      ConsoleLoggerAdapter(),
    ],
    this.scaffoldMessengerKey,
    this.debugShowCheckedModeBanner = true,
    this.showPerformanceOverlay = false,
    this.title = "",
    this.onGenerateTitle,
    this.themeMode,
    this.routerBootOverride,
    this.routerInitialQueryOverride,
    this.additionalRouterPages = const [],
    this.additionalRouterRedirect = const [],
    this.additionalNavigatorObservers = const [],
    this.localize,
  });

  /// You can specify the plug-in adapter used by Masamune Framework.
  ///
  /// Masamune Frameworkで用いられるプラグインアダプターを指定することができます。
  final List<MasamuneAdapter> additionalMasamuneAdapters;

  /// Theme data used by `katana_theme`.
  ///
  /// `katana_theme`で利用されるテーマデータ。
  final AppThemeData? theme;

  /// Specify the theme mode for the application.
  ///
  /// If [ThemeMode.system], it follows the system settings.
  ///
  /// アプリのテーマモードを指定します。
  ///
  /// [ThemeMode.system]だとシステムの設定に従います。
  final ThemeMode? themeMode;

  /// Adapter for authentication used by `katana_auth`.
  ///
  /// `katana_auth`で利用される認証用のアダプター。
  final AuthAdapter authAdapter;

  /// Adapter for database used by `katana_model`.
  ///
  /// `katana_model`で利用されるデータベース用のアダプター。
  final ModelAdapter modelAdapter;

  /// Adapter for file storage used by `katana_storage`.
  ///
  /// `katana_storage`で利用されるファイルストレージ用のアダプター。
  final StorageAdapter storageAdapter;

  /// Adapter for server processing used by `katana_functions`.
  ///
  /// `katana_functions`で利用されるサーバー処理用のアダプター。
  final FunctionsAdapter functionsAdapter;

  /// Adapter for logging used by `katana_logger`.
  ///
  /// `katana_logger`で利用されるロギング用のアダプター。
  final List<LoggerAdapter> additionalLoggerAdapters;

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
  final String Function(BuildContext context, AppLocalizeBase? localize)?
      onGenerateTitle;

  @mustCallSuper
  List<MasamuneAdapter> get masamuneAdapters => [
        this,
        ...additionalMasamuneAdapters,
      ];

  @override
  @mustCallSuper
  List<LoggerAdapter> get loggerAdapters => additionalLoggerAdapters;

  final BootRouteQueryBuilder? routerBootOverride;
  final RouteQuery? routerInitialQueryOverride;

  final List<RouteQueryBuilder> additionalRouterPages;
  final List<RedirectQuery> additionalRouterRedirect;
  final List<NavigatorObserver> additionalNavigatorObservers;

  @mustCallSuper
  List<RouteQueryBuilder> get routerPages;

  RouteQuery get routerInitialQuery;
  BootRouteQueryBuilder? get routerBoot => null;
  List<RedirectQuery> get routerRedirect => const [];
  List<NavigatorObserver> get routerNavigatorObservers => const [];

  /// Config for router used by `katana_router`.
  ///
  /// `katana_router`で利用されるルーター用のコンフィグ。
  AppRouter get router => AppRouter(
        boot: routerBootOverride ?? routerBoot,
        initialQuery: routerInitialQueryOverride ?? routerInitialQuery,
        redirect: [
          ...routerRedirect,
          ...additionalRouterRedirect,
        ],
        observers: [
          ...routerNavigatorObservers,
          ...additionalNavigatorObservers,
        ],
        pages: [
          ...routerPages,
          ...additionalRouterPages,
        ],
      );

  /// Data for localization used by `katana_localize`.
  ///
  /// `katana_localize`で利用されるローカライズ用のデータ。
  final AppLocalizeBase? localize;

  /// Ref for application scope called by `katana_scoped`.
  ///
  /// `katana_scoped`で呼び出されるアプリケーションスコープ用のref。
  AppRef get ref => AppRef();

  /// App authentication.
  ///
  /// ```dart
  /// appAuth.signIn(
  ///   EmailAndPasswordSignInAuthProvider(
  ///     email: email,
  ///     password: password,
  ///   ),
  /// );
  /// ```
  Authentication get auth => Authentication();

  Functions get function => Functions();

  /// App Flavor.
  String get flavor => const String.fromEnvironment("FLAVOR");
}
