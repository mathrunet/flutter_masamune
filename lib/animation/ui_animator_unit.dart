part of masamune;

/// Unit for storing animation information.
///
/// Please use it together with [UIAnimatorScenario].
class UIAnimatorUnit {
  const UIAnimatorUnit(
      {required this.animatable,
      required this.from,
      required this.to,
      this.tag,
      this.curve = Curves.linear});

  final Animatable animatable;
  final Duration from;
  final Duration to;
  final String? tag;
  final Curve curve;

  UIAnimatorUnit copyWith({
    Animatable? animatable,
    Duration? from,
    Duration? to,
    String? tag,
    Curve? curve,
  }) {
    return UIAnimatorUnit(
      animatable: animatable ?? this.animatable,
      from: from ?? this.from,
      to: to ?? this.to,
      tag: tag ?? this.tag,
      curve: curve ?? this.curve,
    );
  }
}
