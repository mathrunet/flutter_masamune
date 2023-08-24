part of masamune_module;

/// [MasamuneAdapter] for creating module plug-ins.
///
/// Follow the steps below to create it.
///
/// 1. Create a class that extends [ModuleOptions].
/// 2. Create a class inheriting from [ModuleMasamuneAdapter].
/// 3. Include the following methods in class 2.
///   - Static method of `primary`.
///   - Members returning RouteQuery for each page, including arguments
///   - Include in [routeQueries] a list that returns the RouteQuery for each page as is.
///   - When using other plug-ins in the module, specify the related [MasamuneAdapter] and [MasamuneControllerBase] as arguments.
///   - Include all [MasamuneAdapter] in [masamuneAdapters] when using the above.
///
/// モジュールプラグインを作成するための[MasamuneAdapter]。
///
/// 下記の手順で作成します。
///
/// 1. [ModuleOptions]を継承したクラスを作成します。
/// 2. [ModuleMasamuneAdapter]を継承したクラスを作成します。
/// 3. 2のクラスに下記のメソッドを含めます。
///   - `primary`のStaticメソッド。
///   - 各ページのRouteQueryを返すメンバー（引数も含めて）
///   - 各ページのRouteQueryをそのまま返すリストを[routeQueries]に含めます。
///   - モジュール内で他プラグインを利用する場合は関連の[MasamuneAdapter]と[MasamuneControllerBase]を引数にて指定するようにします。
///   - 上記を利用する場合すべての[MasamuneAdapter]を[masamuneAdapters]に含めます。
@immutable
abstract class ModuleMasamuneAdapter<TOptions extends ModuleOptions>
    extends MasamuneAdapter {
  /// [MasamuneAdapter] for creating module plug-ins.
  ///
  /// Follow the steps below to create it.
  ///
  /// 1. Create a class that extends [ModuleOptions].
  /// 2. Create a class inheriting from [ModuleMasamuneAdapter].
  /// 3. Include the following methods in class 2.
  ///   - Static method of `primary`.
  ///   - Members returning RouteQuery for each page, including arguments
  ///   - Include in [routeQueries] a list that returns the RouteQuery for each page as is.
  ///   - When using other plug-ins in the module, specify the related [MasamuneAdapter] and [MasamuneControllerBase] as arguments.
  ///   - Include all [MasamuneAdapter] in [masamuneAdapters] when using the above.
  ///
  /// モジュールプラグインを作成するための[MasamuneAdapter]。
  ///
  /// 下記の手順で作成します。
  ///
  /// 1. [ModuleOptions]を継承したクラスを作成します。
  /// 2. [ModuleMasamuneAdapter]を継承したクラスを作成します。
  /// 3. 2のクラスに下記のメソッドを含めます。
  ///   - `primary`のStaticメソッド。
  ///   - 各ページのRouteQueryを返すメンバー（引数も含めて）
  ///   - 各ページのRouteQueryをそのまま返すリストを[routeQueries]に含めます。
  ///   - モジュール内で他プラグインを利用する場合は関連の[MasamuneAdapter]と[MasamuneControllerBase]を引数にて指定するようにします。
  ///   - 上記を利用する場合すべての[MasamuneAdapter]を[masamuneAdapters]に含めます。
  const ModuleMasamuneAdapter({
    required this.options,
    required AppRef appRef,
    required this.router,
  }) : ref = appRef;

  /// Additional pages for internal use.
  ///
  /// 内部で利用する追加のページ。
  List<RouteQueryBuilder> get routeQueries => const [];

  /// Additional [MasamuneAdapter] for internal use.
  ///
  /// 内部で利用する追加の[MasamuneAdapter]。
  List<MasamuneAdapter> get masamuneAdapters => const [];

  /// Config for router used by `katana_router`.
  ///
  /// `katana_router`で利用されるルーター用のコンフィグ。
  final AppRouter router;

  /// Module Options.
  ///
  /// Defines module-specific words and settings.
  ///
  /// モジュールのオプション。
  ///
  /// モジュール特有の単語や設定を定義します。
  final TOptions options;

  /// Ref for application scope called by `katana_scoped`.
  ///
  /// `katana_scoped`で呼び出されるアプリケーションスコープ用のref。
  final AppRef ref;

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
    for (final tmp in routeQueries) {
      router.registerPage(tmp);
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
