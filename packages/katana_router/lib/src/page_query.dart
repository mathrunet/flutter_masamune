part of katana_router;

/// Base class for creating queries to perform page transitions.
/// ページ遷移を行うためのクエリーを作成するためのベースクラス。
///
/// Enter the path name of the page in [path] and make [route] return [Route] for the page transition.
/// [path]にページのパス名を入力し、[route]にページ遷移を行うための[Route]を返すようにします。
@immutable
abstract class PageQuery {
  /// Base class for creating queries to perform page transitions.
  /// ページ遷移を行うためのクエリーを作成するためのベースクラス。
  ///
  /// Enter the path name of the page in [path] and make [route] return [Route] for the page transition.
  /// [path]にページのパス名を入力し、[route]にページ遷移を行うための[Route]を返すようにします。
  const PageQuery();

  /// The path name of the page.
  /// ページのパス名。
  String get path;

  /// Make [PageRouteQuery] return to perform page transitions.
  /// ページ遷移を行うための[PageRouteQuery]を返すようにします。
  ///
  /// You can specify the method of transition, etc. by passing [RouteQuery] for page transitions to [query].
  /// [query]にページ遷移を行う際の[RouteQuery]を渡すことでトランジションの方法などを指定できます。
  PageRouteQuery<T> route<T>(RouteQuery? query);

  /// The reroute settings associated with this page are done by giving a list of classes that extend [RerouteQuery].
  /// このページに紐づくリルート設定を[RerouteQuery]を継承したクラスのリストを与えることで行います。
  ///
  /// This reroute setting applies only to transitions to this page.
  /// このリルート設定はこのページに遷移する際のみに適用されます。
  List<RerouteQuery> reroute() => const [];

  @override
  String toString() => path;
}
