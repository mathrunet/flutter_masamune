part of masamune_module;

/// Base adapter to oversee and configure the entire application.
///
/// When used in conjunction with [MasamuneModuleApp], the application can be used as a package plug-in.
///
/// Inherit and specify [routerInitialQuery] and [routerPages] for use.
///
/// アプリ全体を統括し設定を行うためのベースアダプター。
///
/// [MasamuneModuleApp]と合わせて利用することでアプリをパッケージプラグインとして利用することができるようになります。
///
/// 継承して[routerInitialQuery]と[routerPages]を指定して利用してください。
@immutable
abstract class ModuleMasamuneAdapter<TOptions extends ModuleOptions>
    extends MasamuneAdapter {
  /// Base adapter to oversee and configure the entire application.
  ///
  /// When used in conjunction with [MasamuneModuleApp], the application can be used as a package plug-in.
  ///
  /// Inherit and specify [routerInitialQuery] and [routerPages] for use.
  ///
  /// アプリ全体を統括し設定を行うためのベースアダプター。
  ///
  /// [MasamuneModuleApp]と合わせて利用することでアプリをパッケージプラグインとして利用することができるようになります。
  ///
  /// 継承して[routerInitialQuery]と[routerPages]を指定して利用してください。
  ModuleMasamuneAdapter({
    this.additionalMasamuneAdapters = const [],
    required this.options,
    this.theme,
    this.authAdapter = const RuntimeAuthAdapter(),
    ModelAdapter? configModelAdapter,
    ModelAdapter? prefsModelAdapter,
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
  })  : _configModelAdapter = configModelAdapter,
        _prefsModelAdapter = prefsModelAdapter;

  /// Module Options.
  ///
  /// Defines module-specific words and settings.
  ///
  /// モジュールのオプション。
  ///
  /// モジュール特有の単語や設定を定義します。
  final TOptions options;

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

  /// Adapter for database used by `katana_model`. For config.
  ///
  /// `katana_model`で利用されるデータベース用のアダプター。コンフィグ用。
  ModelAdapter get configModelAdapter => _configModelAdapter ?? modelAdapter;
  final ModelAdapter? _configModelAdapter;

  /// Adapter for database used by `katana_model`. For config.
  ///
  /// `katana_model`で利用されるデータベース用のアダプター。SharedPrefereces用。
  ModelAdapter get prefsModelAdapter => _prefsModelAdapter ?? modelAdapter;
  final ModelAdapter? _prefsModelAdapter;

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

  /// Specify the Masamune Framework adapter.
  ///
  /// Masamune Frameworkのアダプターを指定します。
  @mustCallSuper
  late final List<MasamuneAdapter> masamuneAdapters = [
    this,
    ...additionalMasamuneAdapters,
  ];

  @override
  @mustCallSuper
  late final List<LoggerAdapter> loggerAdapters = additionalLoggerAdapters;

  /// Specifies the process to be performed before the first page is displayed when the application is launched.
  ///
  /// アプリ起動時に最初のページを表示する前の処理を指定します。
  final BootRouteQueryBuilder? routerBoot = null;

  /// Specify when overwriting [routerBoot] from the outside.
  ///
  /// If this is [Null], [routerBoot] is used.
  ///
  /// [routerBoot]を外部から上書きする際に指定します。
  ///
  /// これが[Null]の場合[routerBoot]が利用されます。
  final BootRouteQueryBuilder? routerBootOverride;

  /// Specifies the first page when the application is launched.
  ///
  /// アプリ起動時の最初のページを指定します。
  RouteQuery get routerInitialQuery;

  /// Specify when overwriting [routerInitialQuery] from the outside.
  ///
  /// If this is [Null], [routerInitialQuery] is used.
  ///
  /// [routerInitialQuery]を外部から上書きする際に指定します。
  ///
  /// これが[Null]の場合[routerInitialQuery]が利用されます。
  final RouteQuery? routerInitialQueryOverride;

  /// Specify the pages to be used in the package.
  ///
  /// パッケージ内で利用するページを指定します。
  @mustCallSuper
  List<RouteQueryBuilder> get routerPages;

  /// Used to add [routerPages] from outside.
  ///
  /// When extending package plug-ins, please look at the source code in the package and extend it so that the page paths are not covered.
  ///
  /// 外部から[routerPages]を追加する際に利用します。
  ///
  /// パッケージプラグインを拡張する際は、パッケージ内のソースコードを見てページパスが被らないように拡張してください。
  final List<RouteQueryBuilder> additionalRouterPages;

  /// Specify the [RedirectQuery] to be used in the package.
  ///
  /// パッケージ内で利用する[RedirectQuery]を指定します。
  final List<RedirectQuery> routerRedirect = const [];

  /// Used to add [routerRedirect] from outside.
  ///
  /// 外部から[routerRedirect]を追加する際に利用します。
  final List<RedirectQuery> additionalRouterRedirect;

  /// Specify [NavigatorObserver] to be used in the package.
  ///
  /// パッケージ内で利用する[NavigatorObserver]を指定します。
  final List<NavigatorObserver> routerNavigatorObservers = const [];

  /// Used to add [routerNavigatorObservers] from outside.
  ///
  /// 外部から[routerNavigatorObservers]を追加する際に利用します。
  final List<NavigatorObserver> additionalNavigatorObservers;

  /// Config for router used by `katana_router`.
  ///
  /// `katana_router`で利用されるルーター用のコンフィグ。
  late final AppRouter router = AppRouter(
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
  final AppLocalizeBase? localize = null;

  /// Ref for application scope called by `katana_scoped`.
  ///
  /// `katana_scoped`で呼び出されるアプリケーションスコープ用のref。
  final AppRef ref = AppRef();

  /// An object for authentication called by `katana_auth`.
  ///
  /// `katana_auth`で呼び出される認証用のオブジェクト。
  final Authentication auth = Authentication();

  /// Object for server functions called by `katana_functions`.
  ///
  /// `katana_functions`で呼び出されるサーバー関数用のオブジェクト。
  final Functions function = Functions();

  /// Gets the Flavor of the application.
  ///
  /// アプリケーションのFlavorを取得します。
  final String flavor = const String.fromEnvironment("FLAVOR");
}
