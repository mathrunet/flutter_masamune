part of katana_router;

/// Class for building page queries.
/// ページクエリをビルドするためのクラス。
///
/// Entering the current path in [resolve] will return [PageQuery] only if it corresponds to that path.
/// [resolve]に現在のパスを入力するとそのパスに該当する場合のみ[PageQuery]を戻すようにします。
///
/// This allows the transition to the appropriate path.
/// それにより適切なパスへ遷移することが可能です。
///
/// By passing it to [AppRouter] and invoking it in [MaterialApp.router], this builder can be used with named routing corresponding to a Web URL.
/// [AppRouter]に渡して[MaterialApp.router]で起動することによりこのビルダーをWebのURLに対応した名前付きルーティングで利用することができるようになります。
@immutable
abstract class PageQueryBuilder {
  /// Class for building page queries.
  /// ページクエリをビルドするためのクラス。
  ///
  /// Entering the current path in [resolve] will return [PageQuery] only if it corresponds to that path.
  /// [resolve]に現在のパスを入力するとそのパスに該当する場合のみ[PageQuery]を戻すようにします。
  ///
  /// This allows the transition to the appropriate path.
  /// それにより適切なパスへ遷移することが可能です。
  ///
  /// By passing it to [AppRouter] and invoking it in [MaterialApp.router], this builder can be used with named routing corresponding to a Web URL.
  /// [AppRouter]に渡して[MaterialApp.router]で起動することによりこのビルダーをWebのURLに対応した名前付きルーティングで利用することができるようになります。
  const PageQueryBuilder();

  /// Passing the current path to [path] returns the corresponding [PageQuery].
  /// [path]に現在のパスを渡すとそれに応じた[PageQuery]を返します。
  ///
  /// Returns [Null] if [path] does not match.
  /// [path]に一致しない場合は[Null]を返します。
  PageQuery? resolve(String? path);
}

/// PageQueryBuilder] for building the boot page (the page that is displayed only when the application is launched).
/// ブートページ（アプリ立ち上げ時のみ表示されるページ）をビルドするための[PageQueryBuilder]。
///
/// The boot page is displayed when the application is launched by passing it to [AppRouter].
/// [AppRouter]に渡すことによりブートページをアプリ立ち上げ時に表示します。
///
/// The screen implemented by [build] will be displayed.
/// [build]で実装した画面が表示されます。
///
/// Execute [onInit], wait for [Future], then display the first page.
/// [onInit]を実行し、[Future]を待った後最初のページを表示します。
@immutable
abstract class BootPageQueryBuilder extends StatefulWidget {
  /// PageQueryBuilder] for building the boot page (the page that is displayed only when the application is launched).
  /// ブートページ（アプリ立ち上げ時のみ表示されるページ）をビルドするための[PageQueryBuilder]。
  ///
  /// The boot page is displayed when the application is launched by passing it to [AppRouter].
  /// [AppRouter]に渡すことによりブートページをアプリ立ち上げ時に表示します。
  ///
  /// The screen implemented by [build] will be displayed.
  /// [build]で実装した画面が表示されます。
  ///
  /// Execute [onInit], wait for [Future], then display the first page.
  /// [onInit]を実行し、[Future]を待った後最初のページを表示します。
  const BootPageQueryBuilder({super.key});

  /// Run build.
  /// ビルドを行います。
  ///
  /// The context for the build is passed to [context].
  /// [context]にビルド用のコンテキストが渡されます。
  Widget build(BuildContext context);

  /// Define [RouteQuery] for displaying the first page after the boot page.
  /// ブートページを表示した後最初のページを表示する際の[RouteQuery]を定義します。
  RouteQuery get initialRouteQuery;

  /// Describe the initialization process after the screen is displayed.
  /// 画面表示後の初期化処理を記述します。
  ///
  /// After this process is complete, the user is taken to the first screen.
  /// この処理が終わると最初の画面に遷移します。
  FutureOr<void> onInit(BuildContext context);

  /// Passing the current path to [path] returns the corresponding [PageQuery].
  /// [path]に現在のパスを渡すとそれに応じた[PageQuery]を返します。
  PageQuery resolve(String path) {
    return _BootPageQuery(builder: this, sourcePath: path);
  }

  @override
  State<StatefulWidget> createState() => _BootPageQueryBuilderState();
}

class _BootPageQueryBuilderState extends State<BootPageQueryBuilder> {
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
    AppRouter.of(context).pop();
  }
}

@immutable
class _BootPageQuery extends PageQuery {
  const _BootPageQuery({
    required this.builder,
    required this.sourcePath,
  });

  final String sourcePath;
  final BootPageQueryBuilder builder;

  @override
  String get path => sourcePath;

  @override
  PageRouteQuery<T> route<T>(RouteQuery? query) {
    return PageRouteQuery(
      key: ValueKey(builder.hashCode),
      builder: (_) => builder,
      path: path,
      transition: RouteQueryType.none,
    );
  }
}

/// PageQueryBuilder] for building a page (404 page) to display if the page passed to [AppRouter] is not a hit for the entered path (URL).
/// 入力されたパス（URL）に対し、[AppRouter]に渡したページがヒットしなかった場合に表示するページ（404ページ）のビルドを行うための[PageQueryBuilder]。
///
/// Passing it to [AppRouter] will display a 404 page.
/// [AppRouter]に渡すことにより404ページを表示します。
///
/// The screen implemented by [build] will be displayed.
/// [build]で実装した画面が表示されます。
@immutable
abstract class UnknownPageQueryBuilder extends StatelessWidget {
  const UnknownPageQueryBuilder({super.key});

  /// Passing the current path to [path] returns the corresponding [PageQuery].
  /// [path]に現在のパスを渡すとそれに応じた[PageQuery]を返します。
  PageQuery resolve(String path) {
    return _UnknownPageQuery(builder: this, sourcePath: path);
  }
}

@immutable
class _UnknownPageQuery extends PageQuery {
  const _UnknownPageQuery({
    required this.builder,
    required this.sourcePath,
  });

  final String sourcePath;
  final UnknownPageQueryBuilder builder;
  @override
  String get path => sourcePath;

  @override
  PageRouteQuery<T> route<T>(RouteQuery? query) {
    return PageRouteQuery(
      key: ValueKey(builder.hashCode),
      builder: (_) => builder,
      path: path,
      transition: RouteQueryType.initial,
    );
  }
}

@immutable
class _EmptyPageQuery extends PageQuery {
  const _EmptyPageQuery();

  @override
  String get path => "";

  @override
  PageRouteQuery<T> route<T>(RouteQuery? query) {
    return PageRouteQuery(
      builder: (_) => const SizedBox.shrink(),
      path: path,
      transition: RouteQueryType.initial,
    );
  }
}
