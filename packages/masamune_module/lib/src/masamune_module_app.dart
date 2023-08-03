part of masamune_module;

/// By passing [ModuleMasamuneAdapter], the application settings defined in the package can be used as is.
///
/// Use in conjunction with [runMasamuneApp] to take advantage of the full functionality of the Masamune package.
///
/// [ModuleMasamuneAdapter]を渡すことでパッケージ内で定義されたアプリケーションの設定をそのまま利用することができるようになります。
///
/// [runMasamuneApp]と合わせて利用してMasamuneパッケージのフル機能を利用してください。
///
/// ```dart
/// void main() {
///   runMasamuneApp(
///     (adapters) => MasamuneModuleApp(module, adapters),
///     masamuneAdapters: module.masamuneAdapters,
///   );
/// }
/// ```
@immutable
class MasamuneModuleApp extends MasamuneApp {
  /// By passing [ModuleMasamuneAdapter], the application settings defined in the package can be used as is.
  ///
  /// Use in conjunction with [runMasamuneApp] to take advantage of the full functionality of the Masamune package.
  ///
  /// [ModuleMasamuneAdapter]を渡すことでパッケージ内で定義されたアプリケーションの設定をそのまま利用することができるようになります。
  ///
  /// [runMasamuneApp]と合わせて利用してMasamuneパッケージのフル機能を利用してください。
  ///
  /// ```dart
  /// void main() {
  ///   runMasamuneApp(
  ///     (adapters) => MasamuneModuleApp(module, adapters),
  ///     masamuneAdapters: module.masamuneAdapters,
  ///   );
  /// }
  /// ```
  const MasamuneModuleApp(
    this.module,
    this.adapters, {
    super.key,
  });

  /// ModuleMasamuneAdapter] to be used.
  ///
  /// 利用する[ModuleMasamuneAdapter]。
  final ModuleMasamuneAdapter module;

  /// List of [MasamuneAdapters] defined in [ModuleMasamuneAdapter].
  ///
  /// [ModuleMasamuneAdapter]で定義された[MasamuneAdapter]のリスト。
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
