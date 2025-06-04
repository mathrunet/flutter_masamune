part of "/masamune_universal_ui.dart";

/// ScrollPhysics for pull-to-refresh at a fixed location.
///
/// Scrolling from top to bottom is acceptable, but scrolling from bottom to top does not work.
///
/// 固定された場所でのPull-to-Refreshを実現するためのScrollPhysics。
///
/// 上から下へのスクロールは許容しますが、下から上へのスクロールは動きません。
class RefreshIndicatorScrollPhysics extends ScrollPhysics {
  /// ScrollPhysics for pull-to-refresh at a fixed location.
  ///
  /// Scrolling from top to bottom is acceptable, but scrolling from bottom to top does not work.
  ///
  /// 固定された場所でのPull-to-Refreshを実現するためのScrollPhysics。
  ///
  /// 上から下へのスクロールは許容しますが、下から上へのスクロールは動きません。
  const RefreshIndicatorScrollPhysics({super.parent});

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return RefreshIndicatorScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => true;

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    assert(() {
      if (value == position.pixels) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              "$runtimeType.applyBoundaryConditions() was called redundantly."),
          ErrorDescription(
            "The proposed new position, $value, is exactly equal to the current position of the "
            "given ${position.runtimeType}, ${position.pixels}.\n"
            "The applyBoundaryConditions method should only be called when the value is "
            "going to actually change the pixels, otherwise it is redundant.",
          ),
          DiagnosticsProperty<ScrollPhysics>(
            "The physics object in question was",
            this,
            style: DiagnosticsTreeStyle.errorProperty,
          ),
          DiagnosticsProperty<ScrollMetrics>(
            "The position object in question was",
            position,
            style: DiagnosticsTreeStyle.errorProperty,
          ),
        ]);
      }
      return true;
    }(), "Redundant call to applyBoundaryConditions");
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      // Overscroll.
      return value - position.pixels;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      // Hit bottom edge.
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }
}
