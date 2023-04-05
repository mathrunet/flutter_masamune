part of masamune_module;

@immutable
class MasamuneModuleApp extends MasamuneApp {
  const MasamuneModuleApp(
    this.module,
    this.adapters, {
    super.key,
  });

  final ModuleMasamuneAdapter module;
  final List<MasamuneAdapter> adapters;

  @override
  List<MasamuneAdapter> get masamuneAdapters => adapters;

  @override
  AppThemeData? get theme => module.theme;

  @override
  ThemeMode? get themeMode => module.themeMode;

  @override
  AppLocalizeBase? get localize => module.localize;

  @override
  AppRef? get appRef => module.ref;

  @override
  AuthAdapter? get authAdapter => module.authAdapter;

  @override
  ModelAdapter? get modelAdapter => module.modelAdapter;

  @override
  StorageAdapter? get storageAdapter => module.storageAdapter;

  @override
  FunctionsAdapter? get functionsAdapter => module.functionsAdapter;

  @override
  List<LoggerAdapter> get loggerAdapters => module.additionalLoggerAdapters;

  @override
  RouterConfig<Object>? get routerConfig => module.router;

  @override
  GlobalKey<ScaffoldMessengerState>? get scaffoldMessengerKey =>
      module.scaffoldMessengerKey;

  @override
  bool get debugShowCheckedModeBanner => module.debugShowCheckedModeBanner;

  @override
  bool get showPerformanceOverlay => module.showPerformanceOverlay;

  @override
  String get title => module.title;

  @override
  String Function(BuildContext)? get onGenerateTitle =>
      module.onGenerateTitle == null
          ? null
          : (context) => module.onGenerateTitle!.call(context, module.localize);
}
