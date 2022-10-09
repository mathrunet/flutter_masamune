part of katana_router;

/// Route queries for page transitions.
/// ページ遷移するためのルートクエリー。
///
/// You can define page transitions by specifying [transition].
/// [transition]を指定することでページのトランジションを定義できます。
///
/// [RouteQuery.fullscreen], [RouteQuery.fade], [RouteQuery.immediately], and [RouteQuery.modal] to get the [RouteQuery] that defines each transition as is.
/// [RouteQuery.fullscreen]、[RouteQuery.fade]、[RouteQuery.immediately]、[RouteQuery.modal]で各トランジションを定義した[RouteQuery]をそのまま取得できます。
@immutable
class RouteQuery {
  /// Route queries for page transitions.
  /// ページ遷移するためのルートクエリー。
  ///
  /// You can define page transitions by specifying [transition].
  /// [transition]を指定することでページのトランジションを定義できます。
  ///
  /// [RouteQuery.fullscreen], [RouteQuery.fade], [RouteQuery.immediately], and [RouteQuery.modal] to get the [RouteQuery] that defines each transition as is.
  /// [RouteQuery.fullscreen]、[RouteQuery.fade]、[RouteQuery.immediately]、[RouteQuery.modal]で各トランジションを定義した[RouteQuery]をそのまま取得できます。
  const RouteQuery({
    this.transition = RouteQueryType.initial,
  });

  /// Page transitions.
  /// ページのトランジション。
  final RouteQueryType transition;

  /// Create a new [RouteQuery] with parameters.
  /// パラメーターを与えて新しい[RouteQuery]を作成します。
  RouteQuery copyWith({
    RouteQueryType? transition,
  }) {
    return RouteQuery(
      transition: transition ?? this.transition,
    );
  }

  /// [RouteQuery] for full screen transitions.
  /// フルスクリーンのトランジションを行う[RouteQuery]。
  static RouteQuery get fullscreen =>
      const RouteQuery(transition: RouteQueryType.fullscreen);

  /// No transitions [RouteQuery].
  /// トランジションを行なわない[RouteQuery]。
  static RouteQuery get immediately =>
      const RouteQuery(transition: RouteQueryType.none);

  /// [RouteQuery] to perform fade transitions.
  /// フェードのトランジションを行なう[RouteQuery]。
  static RouteQuery get fade =>
      const RouteQuery(transition: RouteQueryType.fade);

  /// [RouteQuery] that performs modal transitions.
  /// モーダルのトランジションを行なう[RouteQuery]。
  ///
  /// The back page will be visible.
  /// 裏のページが見えるようになります。
  static RouteQuery get modal =>
      const RouteQuery(transition: RouteQueryType.modal);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => transition.hashCode;

  @override
  String toString() => "$runtimeType($transition)";
}
