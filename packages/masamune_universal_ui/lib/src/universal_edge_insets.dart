part of '/masamune_universal_ui.dart';

/// [EdgeInsets] for `MasamuneUniversalUI`.
///
/// It can be passed directly to [EdgeInsetsGeometry], and if the widget is compatible with `Masamune Universal UI`, the content will change depending on the [breakpoint] you set.
///
/// If the screen width is less than [breakpoint], [primary] is used.
///
/// If [greaterThanBreakpoint] is specified and the screen width is greater than [breakpoint], [greaterThanBreakpoint] is used.
///
/// `MasamuneUniversalUI`に対応した[EdgeInsets]。
///
/// [EdgeInsetsGeometry]にそのまま渡すことができ、`Masamune Universal UI`に対応したウィジェットであれば、設定した[breakpoint]によって内容が変化します。
///
/// 画面の横幅が[breakpoint]より下回っている場合は[primary]が利用されます。
///
/// [greaterThanBreakpoint]が指定されていて画面の横幅が[breakpoint]より上回っている場合は[greaterThanBreakpoint]が利用されます。
class ResponsiveEdgeInsets extends EdgeInsetsGeometry {
  /// [EdgeInsets] for `MasamuneUniversalUI`.
  ///
  /// It can be passed directly to [EdgeInsetsGeometry], and if the widget is compatible with `Masamune Universal UI`, the content will change depending on the [breakpoint] you set.
  ///
  /// If the screen width is less than [breakpoint], [primary] is used.
  ///
  /// If [greaterThanBreakpoint] is specified and the screen width is greater than [breakpoint], [greaterThanBreakpoint] is used.
  ///
  /// If the widget is not `Masamune Universal UI` compatible, [primary] will be applied as is.
  ///
  /// `MasamuneUniversalUI`に対応した[EdgeInsets]。
  ///
  /// [EdgeInsetsGeometry]にそのまま渡すことができ、`Masamune Universal UI`に対応したウィジェットであれば、設定した[breakpoint]によって内容が変化します。
  ///
  /// 画面の横幅が[breakpoint]より下回っている場合は[primary]が利用されます。
  ///
  /// [greaterThanBreakpoint]が指定されていて画面の横幅が[breakpoint]より上回っている場合は[greaterThanBreakpoint]が利用されます。
  ///
  /// `Masamune Universal UI`対応のウィジェットでない場合は[primary]がそのまま適用されます。
  const ResponsiveEdgeInsets(
    this.primary, {
    this.breakpoint,
    this.greaterThanBreakpoint,
  });

  /// Main [EdgeInsets].
  ///
  /// If the widget is not `Masamune Universal UI` compatible, [primary] will be applied as is.
  ///
  /// メインの[EdgeInsets]。通常はこちらが利用されます。
  ///
  /// `Masamune Universal UI`対応のウィジェットでない場合は[primary]がそのまま適用されます。
  final EdgeInsets primary;

  /// Breakpoints for responsive support.
  ///
  /// レスポンシブ対応するためのブレークポイント。
  final Breakpoint? breakpoint;

  /// If [greaterThanBreakpoint] is specified and the screen width is greater than [breakpoint], [greaterThanBreakpoint] is used.
  ///
  /// [greaterThanBreakpoint]が指定されていて画面の横幅が[breakpoint]より上回っている場合は[greaterThanBreakpoint]が利用されます。
  final EdgeInsets? greaterThanBreakpoint;

  /// Get the [EdgeInsets] corresponding to the current breakpoint by passing [context].
  ///
  /// If [breakpoint] is specified, you can specify a breakpoint to be used preferentially.
  ///
  /// [context]を渡すことで現在のブレークポイントに対応する[EdgeInsets]を取得します。
  ///
  /// [breakpoint]を指定すると優先的に使用するブレークポイントを指定できます。
  EdgeInsetsGeometry responsive(
    BuildContext context, {
    Breakpoint? breakpoint,
  }) {
    final bp = breakpoint ??
        this.breakpoint ??
        UniversalScaffold.of(context)?.breakpoint;
    if (bp == null) {
      return primary;
    }
    if (bp.width(context) != double.infinity) {
      return greaterThanBreakpoint ?? primary;
    }
    return primary;
  }

  static EdgeInsetsGeometry? _responsive(
    BuildContext context,
    EdgeInsetsGeometry? padding, {
    Breakpoint? breakpoint,
  }) {
    if (padding is ResponsiveEdgeInsets) {
      return padding.responsive(context, breakpoint: breakpoint);
    }
    return padding;
  }

  /// An Offset describing the vector from the top left of a rectangle to the
  /// top left of that rectangle inset by this object.
  Offset get topLeft => primary.topLeft;

  /// An Offset describing the vector from the top right of a rectangle to the
  /// top right of that rectangle inset by this object.
  Offset get topRight => primary.topRight;

  /// An Offset describing the vector from the bottom left of a rectangle to the
  /// bottom left of that rectangle inset by this object.
  Offset get bottomLeft => primary.bottomLeft;

  /// An Offset describing the vector from the bottom right of a rectangle to the
  /// bottom right of that rectangle inset by this object.
  Offset get bottomRight => primary.bottomRight;

  @override
  EdgeInsets get flipped => primary.flipped;

  /// Returns a new rect that is bigger than the given rect in each direction by
  /// the amount of inset in each direction. Specifically, the left edge of the
  /// rect is moved left by [left], the top edge of the rect is moved up by
  /// [top], the right edge of the rect is moved right by [right], and the
  /// bottom edge of the rect is moved down by [bottom].
  ///
  /// See also:
  ///
  ///  * [inflateSize], to inflate a [Size] rather than a [Rect].
  ///  * [deflateRect], to deflate a [Rect] rather than inflating it.
  Rect inflateRect(Rect rect) {
    return primary.inflateRect(rect);
  }

  /// Returns a new rect that is smaller than the given rect in each direction by
  /// the amount of inset in each direction. Specifically, the left edge of the
  /// rect is moved right by [left], the top edge of the rect is moved down by
  /// [top], the right edge of the rect is moved left by [right], and the
  /// bottom edge of the rect is moved up by [bottom].
  ///
  /// If the argument's [Rect.size] is smaller than [collapsedSize], then the
  /// resulting rectangle will have negative dimensions.
  ///
  /// See also:
  ///
  ///  * [deflateSize], to deflate a [Size] rather than a [Rect].
  ///  * [inflateRect], to inflate a [Rect] rather than deflating it.
  Rect deflateRect(Rect rect) {
    return primary.deflateRect(rect);
  }

  @override
  EdgeInsetsGeometry subtract(EdgeInsetsGeometry other) {
    return primary.subtract(other);
  }

  @override
  EdgeInsetsGeometry add(EdgeInsetsGeometry other) {
    return primary.add(other);
  }

  @override
  EdgeInsetsGeometry clamp(EdgeInsetsGeometry min, EdgeInsetsGeometry max) {
    return primary.clamp(min, max);
  }

  /// Returns the difference between two [EdgeInsets].
  EdgeInsets operator -(EdgeInsets other) {
    return primary - other;
  }

  /// Returns the sum of two [EdgeInsets].
  EdgeInsets operator +(EdgeInsets other) {
    return primary + other;
  }

  /// Returns the [EdgeInsets] object with each dimension negated.
  ///
  /// This is the same as multiplying the object by -1.0.
  @override
  EdgeInsets operator -() {
    return -primary;
  }

  /// Scales the [EdgeInsets] in each dimension by the given factor.
  @override
  EdgeInsets operator *(double other) {
    return primary * other;
  }

  /// Divides the [EdgeInsets] in each dimension by the given factor.
  @override
  EdgeInsets operator /(double other) {
    return primary / other;
  }

  /// Integer divides the [EdgeInsets] in each dimension by the given factor.
  @override
  EdgeInsets operator ~/(double other) {
    return primary ~/ other;
  }

  /// Computes the remainder in each dimension by the given factor.
  @override
  EdgeInsets operator %(double other) {
    return primary % other;
  }

  /// Linearly interpolate between two [EdgeInsets].
  ///
  /// If either is null, this function interpolates from [EdgeInsets.zero].
  ///
  /// {@macro dart.ui.shadow.lerp}
  static EdgeInsets? lerp(EdgeInsets? a, EdgeInsets? b, double t) {
    return EdgeInsets.lerp(a, b, t);
  }

  @override
  EdgeInsets resolve(TextDirection? direction) => primary;

  /// Creates a copy of this EdgeInsets but with the given fields replaced
  /// with the new values.
  EdgeInsets copyWith({
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    return primary.copyWith(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
}
