part of katana_router;

/// Class for defining the page to be displayed in different locations depending on conditions.
///
/// Reroute to the page by returning a new [RouteQuery] based on the [RouteQuery] and other information given in the `source` of the [redirect] method.
///
/// 条件によりページの表示先を変えるための定義を行うためのクラス。
///
/// [redirect]メソッドの`source`で与えられた[RouteQuery]とその他の情報を元に新しい[RouteQuery]を返すことでそのページにリルートします。
@immutable
abstract class RedirectQuery {
  /// Class for defining the page to be displayed in different locations depending on conditions.
  ///
  /// Reroute to the page by returning a new [RouteQuery] based on the [RouteQuery] and other information given in the `source` of the [redirect] method.
  /// 
  /// 条件によりページの表示先を変えるための定義を行うためのクラス。
  /// 
  /// [redirect]メソッドの`source`で与えられた[RouteQuery]とその他の情報を元に新しい[RouteQuery]を返すことでそのページにリルートします。
  const RedirectQuery();

  /// Reroute to the page by returning a new [RouteQuery] based on the [RouteQuery] and other information given in the `source` of the [redirect] method.
  /// [redirect]メソッドの`source`で与えられた[RouteQuery]とその他の情報を元に新しい[RouteQuery]を返すことでそのページにリルートします。
  FutureOr<RouteQuery?> redirect(BuildContext context, RouteQuery source);
}
