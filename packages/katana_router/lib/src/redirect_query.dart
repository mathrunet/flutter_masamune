part of katana_router;

/// Class for defining the page to be displayed in different locations depending on conditions.
/// 条件によりページの表示先を変えるための定義を行うためのクラス。
///
/// Reroute to the page by returning a new [PageQuery] based on the [PageQuery] and other information given in the `source` of the [redirect] method.
/// [redirect]メソッドの`source`で与えられた[PageQuery]とその他の情報を元に新しい[PageQuery]を返すことでそのページにリルートします。
@immutable
abstract class RedirectQuery {
  /// Class for defining the page to be displayed in different locations depending on conditions.
  /// 条件によりページの表示先を変えるための定義を行うためのクラス。
  ///
  /// Reroute to the page by returning a new [PageQuery] based on the [PageQuery] and other information given in the `source` of the [redirect] method.
  /// [redirect]メソッドの`source`で与えられた[PageQuery]とその他の情報を元に新しい[PageQuery]を返すことでそのページにリルートします。
  const RedirectQuery();

  /// Reroute to the page by returning a new [PageQuery] based on the [PageQuery] and other information given in the `source` of the [redirect] method.
  /// [redirect]メソッドの`source`で与えられた[PageQuery]とその他の情報を元に新しい[PageQuery]を返すことでそのページにリルートします。
  FutureOr<PageQuery?> redirect(BuildContext context, PageQuery source);
}
