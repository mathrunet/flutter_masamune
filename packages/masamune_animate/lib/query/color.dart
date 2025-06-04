part of "query.dart";

/// Extension method for [EffectQuery] for color animation.
///
/// 色のアニメーションのための[EffectQuery]用の拡張メソッド。
extension ColorEffectQueryExtensions on AnimateRunner {
  /// Perform color animation.
  ///
  /// Set the starting color to [begin].
  ///
  /// Set the end time to [end].
  ///
  /// Set the blend mode to [blendMode].
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// 色アニメーションを行います。
  ///
  /// [begin]に開始時の色を設定します。
  ///
  /// [end]に終了時の々を設定します。
  ///
  /// [blendMode]にブレンドモードを設定します。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> color({
    required Duration duration,
    Curve curve = Curves.linear,
    Color begin = Colors.transparent,
    Color end = Colors.transparent,
    BlendMode blendMode = BlendMode.color,
  }) {
    return runAnimateQuery(
      _ColorEffectQuery(
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        blendMode: blendMode,
      ),
    );
  }
}

class _ColorEffectQuery extends EffectQuery<Color> {
  const _ColorEffectQuery({
    required super.duration,
    super.curve = Curves.linear,
    super.begin = Colors.transparent,
    super.end = Colors.transparent,
    this.blendMode = BlendMode.color,
  });

  final BlendMode blendMode;

  @override
  Widget build(BuildContext context, Color value, Widget child) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(value, blendMode),
      child: child,
    );
  }

  @override
  Color transform(double value) {
    return Color.lerp(begin, end, curve.transform(value)) ?? begin;
  }
}
