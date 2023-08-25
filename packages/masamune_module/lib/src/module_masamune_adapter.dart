part of masamune_module;

/// {@template module_masamune_adapter}
/// [MasamuneAdapter] for creating module plug-ins.
///
/// Follow the steps below to create it.
///
/// 1. Create a class that extends [ModuleOptions].
/// 2. Create a class that inherits from [ModulePages].
///   - Include a list of pages.
///   - If the page is not needed, create a private class and pass it directly to super.
/// 3. Create a class inheriting from [ModuleMasamuneAdapter].
/// 4. Include the following methods in class 2.
///   - Static method of `primary`.
///   - When using other plug-ins in the module, specify the related [MasamuneAdapter] and [MasamuneControllerBase] as arguments.
///   - Include all [MasamuneAdapter] in [masamuneAdapters] when using the above.
///
/// モジュールプラグインを作成するための[MasamuneAdapter]。
///
/// 下記の手順で作成します。
///
/// 1. [ModuleOptions]を継承したクラスを作成します。
/// 2. [ModulePages]を継承したクラスを作成します。
///   - ページの一覧を含めます。
///   - ページが必要ない場合はプライベートなクラスを作りsuperにそのまま渡します。
/// 3. [ModuleMasamuneAdapter]を継承したクラスを作成します。
/// 4. 3のクラスに下記のメソッドを含めます。
///   - `primary`のStaticメソッド。
///   - モジュール内で他プラグインを利用する場合は関連の[MasamuneAdapter]と[MasamuneControllerBase]を引数にて指定するようにします。
///   - 上記を利用する場合すべての[MasamuneAdapter]を[masamuneAdapters]に含めます。
/// {@endtemplate}
@immutable
abstract class ModuleMasamuneAdapter<TPages extends ModulePages,
    TOptions extends ModuleOptions> extends MasamuneAdapter {
  /// {@template module_masamune_adapter}
  /// [MasamuneAdapter] for creating module plug-ins.
  ///
  /// Follow the steps below to create it.
  ///
  /// 1. Create a class that extends [ModuleOptions].
  /// 2. Create a class that inherits from [ModulePages].
  ///   - Include a list of pages.
  ///   - If the page is not needed, create a private class and pass it directly to super.
  /// 3. Create a class inheriting from [ModuleMasamuneAdapter].
  /// 4. Include the following methods in class 2.
  ///   - Static method of `primary`.
  ///   - When using other plug-ins in the module, specify the related [MasamuneAdapter] and [MasamuneControllerBase] as arguments.
  ///   - Include all [MasamuneAdapter] in [masamuneAdapters] when using the above.
  ///
  /// モジュールプラグインを作成するための[MasamuneAdapter]。
  ///
  /// 下記の手順で作成します。
  ///
  /// 1. [ModuleOptions]を継承したクラスを作成します。
  /// 2. [ModulePages]を継承したクラスを作成します。
  ///   - ページの一覧を含めます。
  ///   - ページが必要ない場合はプライベートなクラスを作りsuperにそのまま渡します。
  /// 3. [ModuleMasamuneAdapter]を継承したクラスを作成します。
  /// 4. 3のクラスに下記のメソッドを含めます。
  ///   - `primary`のStaticメソッド。
  ///   - モジュール内で他プラグインを利用する場合は関連の[MasamuneAdapter]と[MasamuneControllerBase]を引数にて指定するようにします。
  ///   - 上記を利用する場合すべての[MasamuneAdapter]を[masamuneAdapters]に含めます。
  /// {@endtemplate}
  const ModuleMasamuneAdapter({
    required this.option,
    required this.page,
    AppRef? appRef,
    AppRouter? router,
    Functions? function,
    Authentication? auth,
  })  : _ref = appRef,
        _router = router,
        _function = function,
        _auth = auth;

  /// Additional pages for internal use.
  ///
  /// 内部で利用する追加のページ。
  List<RouteQueryBuilder> get routeQueries => page.pages;

  /// Additional [MasamuneAdapter] for internal use.
  ///
  /// 内部で利用する追加の[MasamuneAdapter]。
  List<MasamuneAdapter> get masamuneAdapters => const [];

  /// Config for router used by `katana_router`.
  ///
  /// `katana_router`で利用されるルーター用のコンフィグ。
  AppRouter get router {
    assert(
      _router != null,
      "[AppRouter] is not given. Please specify [router] when creating [ModuleMasamuneAdapter].",
    );
    return _router!;
  }

  final AppRouter? _router;

  /// List of module pages.
  ///
  /// Defines module-specific pages.
  ///
  /// モジュールのページ一覧。
  ///
  /// モジュール特有のページを定義します。
  final TPages page;

  /// Module Options.
  ///
  /// Defines module-specific words and settings.
  ///
  /// モジュールのオプション。
  ///
  /// モジュール特有の単語や設定を定義します。
  final TOptions option;

  /// Ref for application scope called by `katana_scoped`.
  ///
  /// `katana_scoped`で呼び出されるアプリケーションスコープ用のref。
  AppRef get ref {
    assert(
      _ref != null,
      "[AppRef] is not given. Please specify [appRef] when creating [ModuleMasamuneAdapter].",
    );
    return _ref!;
  }

  final AppRef? _ref;

  /// Configuration for Functions used by `katana_functions`.
  ///
  /// `katana_functions`で利用されるFunctions用のコンフィグ。
  Functions get functions {
    assert(
      _function != null,
      "[Functions] is not given. Please specify [functions] when creating [ModuleMasamuneAdapter].",
    );
    return _function!;
  }

  final Functions? _function;

  /// Configuration for authentication used by `katana_auth`.
  ///
  /// `katana_auth`で利用される認証用のコンフィグ。
  Authentication get auth {
    assert(
      _auth != null,
      "[Authentication] is not given. Please specify [authentication] when creating [ModuleMasamuneAdapter].",
    );
    return _auth!;
  }

  final Authentication? _auth;

  @override
  @mustCallSuper
  bool get runZonedGuarded => masamuneAdapters.any((e) => e.runZonedGuarded);

  @override
  @mustCallSuper
  List<NavigatorObserver> get navigatorObservers => [
        ...masamuneAdapters.expand((e) => e.navigatorObservers),
      ];

  @override
  @mustCallSuper
  List<LoggerAdapter> get loggerAdapters => [
        ...masamuneAdapters.expand((e) => e.loggerAdapters),
      ];

  @override
  @mustCallSuper
  Widget onBuildApp(BuildContext context, Widget app) {
    for (final tmp in masamuneAdapters) {
      app = tmp.onBuildApp(context, app);
    }
    return app;
  }

  @override
  @mustCallSuper
  void onInitScope(MasamuneAdapter adapter) {
    for (final tmp in masamuneAdapters) {
      tmp.onInitScope(adapter);
    }
  }

  @override
  @mustCallSuper
  FutureOr<void> onPreRunApp() async {
    if (_router != null) {
      for (final tmp in routeQueries) {
        _router?.registerPage(tmp);
      }
    }
    for (final tmp in masamuneAdapters) {
      await tmp.onPreRunApp();
    }
  }

  @override
  @mustCallSuper
  FutureOr<void> onMaybeBoot() async {
    for (final tmp in masamuneAdapters) {
      await tmp.onMaybeBoot();
    }
  }

  @override
  @mustCallSuper
  void onError(Object error, StackTrace stackTrace) {
    for (final tmp in masamuneAdapters) {
      tmp.onError(error, stackTrace);
    }
  }
}
