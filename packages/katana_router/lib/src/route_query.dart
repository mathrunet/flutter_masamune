part of '/katana_router.dart';

/// Base class for creating queries to perform page transitions.
///
/// Enter the path name of the page in [path] and make [route] return [Route] for the page transition.
///
/// You can get the object corresponding to the query from [value].
///
/// ページ遷移を行うためのクエリーを作成するためのベースクラス。
///
/// [path]にページのパス名を入力し、[route]にページ遷移を行うための[Route]を返すようにします。
///
/// [value]からクエリーに対応したオブジェクトを取得することができます。
@immutable
abstract class RouteQuery {
  /// Base class for creating queries to perform page transitions.
  ///
  /// Enter the path name of the page in [path] and make [route] return [Route] for the page transition.
  ///
  /// You can get the object corresponding to the query from [value].
  ///
  /// ページ遷移を行うためのクエリーを作成するためのベースクラス。
  ///
  /// [path]にページのパス名を入力し、[route]にページ遷移を行うための[Route]を返すようにします。
  ///
  /// [key]からクエリーに対応したオブジェクトを取得することができます。
  const RouteQuery();

  /// The path name of the page.
  ///
  /// ページのパス名。
  String get path;

  /// Page Name. The name by which the page is identified is defined.
  ///
  /// Default is the same as [path].
  ///
  /// ページ名。ページを識別する際の名前が定義されています。
  ///
  /// デフォルトは[path]と同じです。
  String get name => path;

  /// Returns `true` for nested pages (i.e., pages with no path information).
  ///
  /// ネストされたページ（つまりパス情報が無いページ）の場合は`true`を返します。
  bool get nested => false;

  /// Specifies the default transition tied to the page. Transitions specified by [AppRouter.push] or other methods will take precedence.
  ///
  /// ページに紐付けられたデフォルトのトランジションを指定します。[AppRouter.push]などで指定されたトランジションが優先されます。
  TransitionQuery? get transition => null;

  /// A key to identify the query.
  ///
  /// It can be obtained as an object of [E] by specifying [E].
  ///
  /// クエリーを識別するためのキー。
  ///
  /// [E]を指定することで[E]のオブジェクトとして取得できます。
  E? key<E>();

  /// Returns a [Widget] created from the query.
  ///
  /// It is returned with parameters passed, so it can be used to retrieve parameters, etc.
  ///
  /// クエリから作成される[Widget]を返します。
  ///
  /// パラメーターが渡された状態で返されるのでパラメーターの取得などに利用してください。
  W? widget<W extends Widget>();

  /// Make [AppPageRoute] return to perform page transitions.
  ///
  /// You can specify the method of transition, etc. by passing [TransitionQuery] for page transitions to [query].
  ///
  /// ページ遷移を行うための[AppPageRoute]を返すようにします。
  ///
  /// [query]にページ遷移を行う際の[TransitionQuery]を渡すことでトランジションの方法などを指定できます。
  AppPageRoute<E> route<E>([TransitionQuery? query]);

  /// The reroute settings associated with this page are done by giving a list of classes that extend [RedirectQuery].
  ///
  /// This reroute setting applies only to transitions to this page.
  ///
  /// このページに紐づくリルート設定を[RedirectQuery]を継承したクラスのリストを与えることで行います。
  ///
  /// このリルート設定はこのページに遷移する際のみに適用されます。
  List<RedirectQuery> redirect() => const [];

  TransitionQuery? get _transition => null;

  @override
  String toString() => path;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => path.hashCode;
}

@immutable
class _InnerRouteQueryImpl extends RouteQuery {
  const _InnerRouteQueryImpl({
    required this.routeQuery,
    this.transitionQuery,
  });

  final RouteQuery routeQuery;
  final TransitionQuery? transitionQuery;

  @override
  E? key<E>() => routeQuery.key<E>();

  @override
  W? widget<W extends Widget>() => routeQuery.widget<W>();

  @override
  String get path => routeQuery.path;

  @override
  bool get nested => routeQuery.nested;

  @override
  AppPageRoute<E> route<E>([TransitionQuery? query]) => routeQuery.route(
        query ?? transitionQuery,
      );

  @override
  TransitionQuery? get _transition => transitionQuery;
}
