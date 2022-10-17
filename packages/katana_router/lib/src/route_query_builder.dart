part of katana_router;

/// Class for building page queries.
///
/// Entering the current path in [resolve] will return [RouteQuery] only if it corresponds to that path.
///
/// This allows the transition to the appropriate path.
///
/// By passing it to [AppRouterBase] and invoking it in [MaterialApp.router], this builder can be used with named routing corresponding to a Web URL.
///
/// ページクエリをビルドするためのクラス。
///
/// [resolve]に現在のパスを入力するとそのパスに該当する場合のみ[RouteQuery]を戻すようにします。
///
/// それにより適切なパスへ遷移することが可能です。
///
/// [AppRouterBase]に渡して[MaterialApp.router]で起動することによりこのビルダーをWebのURLに対応した名前付きルーティングで利用することができるようになります。
@immutable
abstract class RouteQueryBuilder {
  /// Class for building page queries.
  ///
  /// Entering the current path in [resolve] will return [RouteQuery] only if it corresponds to that path.
  ///
  /// This allows the transition to the appropriate path.
  ///
  /// By passing it to [AppRouterBase] and invoking it in [MaterialApp.router], this builder can be used with named routing corresponding to a Web URL.
  ///
  /// ページクエリをビルドするためのクラス。
  ///
  /// [resolve]に現在のパスを入力するとそのパスに該当する場合のみ[RouteQuery]を戻すようにします。
  ///
  /// それにより適切なパスへ遷移することが可能です。
  ///
  /// [AppRouterBase]に渡して[MaterialApp.router]で起動することによりこのビルダーをWebのURLに対応した名前付きルーティングで利用することができるようになります。
  const RouteQueryBuilder();

  /// Passing the current path to [path] returns the corresponding [RouteQuery].
  ///
  /// Returns [Null] if [path] does not match.
  ///
  /// [path]に現在のパスを渡すとそれに応じた[RouteQuery]を返します。
  ///
  /// [path]に一致しない場合は[Null]を返します。
  RouteQuery? resolve(String? path);
}

/// [RouteQueryBuilder] for building the boot page (the page that is displayed only when the application is launched).
///
/// The boot page is displayed when the application is launched by passing it to [AppRouterBase].
///
/// The screen implemented by [build] will be displayed.
///
/// Execute [onInit], wait for [Future], then display the first page.
///
/// ブートページ（アプリ立ち上げ時のみ表示されるページ）をビルドするための[RouteQueryBuilder]。
///
/// [AppRouterBase]に渡すことによりブートページをアプリ立ち上げ時に表示します。
///
/// [build]で実装した画面が表示されます。
///
/// [onInit]を実行し、[Future]を待った後最初のページを表示します。
@immutable
abstract class BootRouteQueryBuilder extends StatefulWidget {
  /// [RouteQueryBuilder] for building the boot page (the page that is displayed only when the application is launched).
  ///
  /// The boot page is displayed when the application is launched by passing it to [AppRouterBase].
  ///
  /// The screen implemented by [build] will be displayed.
  ///
  /// Execute [onInit], wait for [Future], then display the first page.
  ///
  /// ブートページ（アプリ立ち上げ時のみ表示されるページ）をビルドするための[RouteQueryBuilder]。
  ///
  /// [AppRouterBase]に渡すことによりブートページをアプリ立ち上げ時に表示します。
  ///
  /// [build]で実装した画面が表示されます。
  ///
  /// [onInit]を実行し、[Future]を待った後最初のページを表示します。
  const BootRouteQueryBuilder({super.key});

  /// Run build.
  ///
  /// The context for the build is passed to [context].
  ///
  /// ビルドを行います。
  ///
  /// [context]にビルド用のコンテキストが渡されます。
  Widget build(BuildContext context);

  /// Define [TransitionQuery] for displaying the first page after the boot page.
  ///
  /// ブートページを表示した後最初のページを表示する際の[TransitionQuery]を定義します。
  TransitionQuery get initialTransitionQuery;

  /// Describe the initialization process after the screen is displayed.
  ///
  /// After this process is complete, the user is taken to the first screen.
  ///
  /// 画面表示後の初期化処理を記述します。
  ///
  /// この処理が終わると最初の画面に遷移します。
  FutureOr<void> onInit(BuildContext context);

  /// Passing the current path to [path] returns the corresponding [RouteQuery].
  ///
  /// [path]に現在のパスを渡すとそれに応じた[RouteQuery]を返します。
  RouteQuery resolve(String path) {
    return _BootRouteQuery(builder: this, sourcePath: path);
  }

  @override
  State<StatefulWidget> createState() => _BootRouteQueryBuilderState();
}

class _BootRouteQueryBuilderState extends State<BootRouteQueryBuilder> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _handledOnInit();
  }

  @override
  Widget build(BuildContext context) {
    return widget.build(context);
  }

  Future<void> _handledOnInit() async {
    await widget.onInit(context);
    AppRouterBase.of(context).pop();
  }
}

@immutable
class _BootRouteQuery extends RouteQuery {
  const _BootRouteQuery({
    required this.builder,
    required this.sourcePath,
  });

  final String sourcePath;
  final BootRouteQueryBuilder builder;

  @override
  String get path => sourcePath;

  @override
  AppPageRoute<T> route<T>(TransitionQuery? query) {
    return AppPageRoute(
      key: ValueKey(builder.hashCode),
      builder: (_) => builder,
      path: path,
      transitionQuery: TransitionQuery.immediately,
    );
  }
}

/// [RouteQueryBuilder] for building a page (404 page) to display if the page passed to [AppRouterBase] is not a hit for the entered path (URL).
///
/// Passing it to [AppRouterBase] will display a 404 page.
///
/// The screen implemented by [build] will be displayed.
///
/// 入力されたパス（URL）に対し、[AppRouterBase]に渡したページがヒットしなかった場合に表示するページ（404ページ）のビルドを行うための[RouteQueryBuilder]。
///
/// [AppRouterBase]に渡すことにより404ページを表示します。
///
/// [build]で実装した画面が表示されます。
@immutable
abstract class UnknownRouteQueryBuilder extends StatelessWidget {
  const UnknownRouteQueryBuilder({super.key});

  /// Passing the current path to [path] returns the corresponding [RouteQuery].
  /// [path]に現在のパスを渡すとそれに応じた[RouteQuery]を返します。
  RouteQuery resolve(String path) {
    return _UnknownRouteQuery(builder: this, sourcePath: path);
  }
}

@immutable
class _UnknownRouteQuery extends RouteQuery {
  const _UnknownRouteQuery({
    required this.builder,
    required this.sourcePath,
  });

  final String sourcePath;
  final UnknownRouteQueryBuilder builder;
  @override
  String get path => sourcePath;

  @override
  AppPageRoute<T> route<T>(TransitionQuery? query) {
    return AppPageRoute(
      key: ValueKey(builder.hashCode),
      builder: (_) => builder,
      path: path,
    );
  }
}

@immutable
class _EmptyRouteQuery extends RouteQuery {
  const _EmptyRouteQuery();

  @override
  String get path => "";

  @override
  AppPageRoute<T> route<T>(TransitionQuery? query) {
    return AppPageRoute(
      builder: (_) => const SizedBox.shrink(),
      path: path,
    );
  }
}
