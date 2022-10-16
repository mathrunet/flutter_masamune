part of katana_router;

/// Base class for creating queries to perform page transitions.
/// ページ遷移を行うためのクエリーを作成するためのベースクラス。
///
/// Enter the path name of the page in [path] and make [route] return [Route] for the page transition.
/// [path]にページのパス名を入力し、[route]にページ遷移を行うための[Route]を返すようにします。
@immutable
abstract class RouteQuery {
  /// Base class for creating queries to perform page transitions.
  /// ページ遷移を行うためのクエリーを作成するためのベースクラス。
  ///
  /// Enter the path name of the page in [path] and make [route] return [Route] for the page transition.
  /// [path]にページのパス名を入力し、[route]にページ遷移を行うための[Route]を返すようにします。
  const RouteQuery();

  /// The path name of the page.
  /// ページのパス名。
  String get path;

  /// Make [AppPageRoute] return to perform page transitions.
  /// ページ遷移を行うための[AppPageRoute]を返すようにします。
  ///
  /// You can specify the method of transition, etc. by passing [TransitionQuery] for page transitions to [query].
  /// [query]にページ遷移を行う際の[TransitionQuery]を渡すことでトランジションの方法などを指定できます。
  AppPageRoute<T> route<T>(TransitionQuery? query);

  /// The reroute settings associated with this page are done by giving a list of classes that extend [RedirectQuery].
  /// このページに紐づくリルート設定を[RedirectQuery]を継承したクラスのリストを与えることで行います。
  ///
  /// This reroute setting applies only to transitions to this page.
  /// このリルート設定はこのページに遷移する際のみに適用されます。
  List<RedirectQuery> redirect() => const [];

  @override
  String toString() => path;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => path.hashCode;
}
