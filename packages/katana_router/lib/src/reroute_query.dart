part of katana_router;

/// Class for defining the page to be displayed in different locations depending on conditions.
/// 条件によりページの表示先を変えるための定義を行うためのクラス。
///
/// Reroute to the page by returning a new [PageQuery] based on the [PageQuery] and other information given in the `source` of the [validate] method.
/// [validate]メソッドの`source`で与えられた[PageQuery]とその他の情報を元に新しい[PageQuery]を返すことでそのページにリルートします。
///
/// You can set up a reroute to a page by placing the object that defines the reroute on top of [MaterialApp] in [RerouteQueryScope], or by defining it together when creating a [PageQuery] class.
/// リルートを定義したオブジェクトを[RerouteQueryScope]で[MaterialApp]の上に置くか、[PageQuery]のクラスを作成する際に一緒に定義する等でページに対するリルートの設定を行うことが可能です。
abstract class RerouteQuery {
  /// Reroute to the page by returning a new [PageQuery] based on the [PageQuery] and other information given in the `source` of the [validate] method.
  /// [validate]メソッドの`source`で与えられた[PageQuery]とその他の情報を元に新しい[PageQuery]を返すことでそのページにリルートします。
  FutureOr<PageQuery?> validate(BuildContext context, PageQuery source);
}

/// Widget for storing [RerouteQuery] when performing a reroute.
/// リルートを行う際の[RerouteQuery]を格納するためのウィジェット。
///
/// All navigation called by widgets below this will be affected by [RerouteQuery] passed in [rerouteQueries].
/// これ以下のウィジェットで呼ばれたナビゲーションはすべて[rerouteQueries]で渡された[RerouteQuery]の影響を受けます。
@immutable
class RerouteQueryScope extends InheritedWidget {
  /// Widget for storing [RerouteQuery] when performing a reroute.
  /// リルートを行う際の[RerouteQuery]を格納するためのウィジェット。
  ///
  /// All navigation called by widgets below this will be affected by [RerouteQuery] passed in [rerouteQueries].
  /// これ以下のウィジェットで呼ばれたナビゲーションはすべて[rerouteQueries]で渡された[RerouteQuery]の影響を受けます。
  const RerouteQueryScope({
    super.key,
    required this.rerouteQueries,
    required super.child,
  });

  /// List of [RerouteQuery] to reroute.
  /// リルートを行うための[RerouteQuery]のリスト。
  final List<RerouteQuery> rerouteQueries;

  static RerouteQueryScope? _of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<RerouteQueryScope>();
    return scope?.widget as RerouteQueryScope?;
  }

  @override
  bool updateShouldNotify(RerouteQueryScope oldWidget) {
    return true;
  }
}
