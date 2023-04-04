part of masamune_module;

@immutable
class MasamuneModuleApp extends MasamuneApp {
  const MasamuneModuleApp(this.adapter, {super.key});

  final ModuleMasamuneAdapter adapter;

  @override
  List<MasamuneAdapter> get masamuneAdapters =>
      adapter.additionalMasamuneAdapters;

  @override
  AppThemeData? get theme => adapter.theme;

  @override
  ThemeMode? get themeMode => adapter.themeMode;

  @override
  AppLocalizeBase? get localize => adapter.localize;

  @override
  AppRef? get appRef => adapter.ref;

  @override
  AuthAdapter? get authAdapter => adapter.authAdapter;

  @override
  ModelAdapter? get modelAdapter => adapter.modelAdapter;

  @override
  StorageAdapter? get storageAdapter => adapter.storageAdapter;

  @override
  FunctionsAdapter? get functionsAdapter => adapter.functionsAdapter;

  @override
  List<LoggerAdapter> get loggerAdapters => adapter.additionalLoggerAdapters;

  @override
  RouterConfig<Object>? get routerConfig => adapter.router;

  @override
  GlobalKey<ScaffoldMessengerState>? get scaffoldMessengerKey =>
      adapter.scaffoldMessengerKey;

  @override
  bool get debugShowCheckedModeBanner => adapter.debugShowCheckedModeBanner;

  @override
  bool get showPerformanceOverlay => adapter.showPerformanceOverlay;

  @override
  String get title => adapter.title;

  @override
  String Function(BuildContext)? get onGenerateTitle => adapter.onGenerateTitle;
}
