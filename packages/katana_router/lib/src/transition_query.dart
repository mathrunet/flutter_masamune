part of katana_router;

/// Route queries for page transitions.
///
/// You can define page transitions by specifying [transition].
///
/// [TransitionQuery.fullscreen], [TransitionQuery.fade], [TransitionQuery.immediately], and [TransitionQuery.modal] to get the [TransitionQuery] that defines each transition as is.
///
/// ページ遷移するためのルートクエリー。
///
/// [transition]を指定することでページのトランジションを定義できます。
///
/// [TransitionQuery.fullscreen]、[TransitionQuery.fade]、[TransitionQuery.immediately]、[TransitionQuery.modal]で各トランジションを定義した[TransitionQuery]をそのまま取得できます。
@immutable
class TransitionQuery {
  const TransitionQuery._({
    this.transition = TransitionQueryType.initial,
  });

  /// Page transitions.
  ///
  /// ページのトランジション。
  final TransitionQueryType transition;

  /// Create a new [TransitionQuery] with parameters.
  ///
  /// パラメーターを与えて新しい[TransitionQuery]を作成します。
  TransitionQuery copyWith({
    TransitionQueryType? transition,
  }) {
    return TransitionQuery._(
      transition: transition ?? this.transition,
    );
  }

  /// [TransitionQuery] for full screen transitions.
  ///
  /// フルスクリーンのトランジションを行う[TransitionQuery]。
  static TransitionQuery get fullscreen =>
      const TransitionQuery._(transition: TransitionQueryType.fullscreen);

  /// No transitions [TransitionQuery].
  ///
  /// トランジションを行なわない[TransitionQuery]。
  static TransitionQuery get immediately =>
      const TransitionQuery._(transition: TransitionQueryType.none);

  /// [TransitionQuery] to perform fade transitions.
  ///
  /// フェードのトランジションを行なう[TransitionQuery]。
  static TransitionQuery get fade =>
      const TransitionQuery._(transition: TransitionQueryType.fade);

  /// [TransitionQuery] that performs modal transitions.
  ///
  /// The back page will be visible.
  ///
  /// モーダルのトランジションを行なう[TransitionQuery]。
  ///
  /// 裏のページが見えるようになります。
  static TransitionQuery get modal =>
      const TransitionQuery._(transition: TransitionQueryType.modal);

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => transition.hashCode;

  @override
  String toString() => "$runtimeType($transition)";
}
