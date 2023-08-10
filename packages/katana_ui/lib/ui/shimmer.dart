part of katana_ui;

/// Create a container to display the shimmer effect.
///
/// Used to display a shimmer effect instead of text.
///
/// シマーエフェクトを表示するコンテナを作成します。
///
/// 文字の変わりにシマーエフェクトを表示する場合に利用します。
class Shimmer extends StatelessWidget {
  /// Create a container to display the shimmer effect.
  ///
  /// Used to display a shimmer effect instead of text.
  ///
  /// シマーエフェクトを表示するコンテナを作成します。
  ///
  /// 文字の変わりにシマーエフェクトを表示する場合に利用します。
  const Shimmer({
    super.key,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.width = double.infinity,
    this.height,
    this.padding = const EdgeInsets.all(0),
    this.shape = BoxShape.rectangle,
  });

  /// Container height.
  ///
  /// コンテナの高さ。
  final double? height;

  /// Container width.
  ///
  /// コンテナの幅。
  final double width;

  /// Rounded corners of containers.
  ///
  /// コンテナの角丸。
  final BorderRadiusGeometry? borderRadius;

  /// Base color for shimmer effects.
  ///
  /// シマーエフェクトを利用する場合のベースカラー。
  final Color? baseColor;

  /// Highlight color when using shimmer effect.
  ///
  /// シマーエフェクトを利用する場合のハイライトカラー。
  final Color? highlightColor;

  /// Form of shimmer effect.
  ///
  /// シマーエフェクトの形。
  final BoxShape shape;

  /// Padding around shimmer effects.
  ///
  /// シマーエフェクトの周りのパディング。
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final h = height ?? Theme.of(context).textTheme.bodyMedium?.fontSize ?? 12;
    return sm.Shimmer.fromColors(
      baseColor: baseColor ?? Theme.of(context).colorScheme.surface,
      highlightColor:
          highlightColor ?? Theme.of(context).colorScheme.background,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(h / 4),
          color: baseColor ?? Theme.of(context).colorScheme.surface,
          shape: shape,
        ),
        margin: padding,
        height: h,
        width: width,
      ),
    );
  }
}

/// Create a [Shimmer] effect that spans multiple lines.
///
/// 複数行に渡る[Shimmer]エフェクトを作成します。
class ShimmerMultiLine extends StatelessWidget {
  /// Create a [Shimmer] effect that spans multiple lines.
  ///
  /// 複数行に渡る[Shimmer]エフェクトを作成します。
  const ShimmerMultiLine({
    super.key,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.width = double.infinity,
    this.height,
    this.lineSpace = 8,
    this.lineCount = 3,
    this.padding = const EdgeInsets.all(0),
    this.shape = BoxShape.rectangle,
  });

  /// Space between lines.
  ///
  /// 行間のスペース。
  final double lineSpace;

  /// Number of lines.
  ///
  /// 行数。
  final int lineCount;

  /// Container height.
  ///
  /// コンテナの高さ。
  final double? height;

  /// Container width.
  ///
  /// コンテナの幅。
  final double width;

  /// Rounded corners of containers.
  ///
  /// コンテナの角丸。
  final BorderRadiusGeometry? borderRadius;

  /// Base color for shimmer effects.
  ///
  /// シマーエフェクトを利用する場合のベースカラー。
  final Color? baseColor;

  /// Highlight color when using shimmer effect.
  ///
  /// シマーエフェクトを利用する場合のハイライトカラー。
  final Color? highlightColor;

  /// Form of shimmer effect.
  ///
  /// シマーエフェクトの形。
  final BoxShape shape;

  /// Padding around shimmer effects.
  ///
  /// シマーエフェクトの周りのパディング。
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < lineCount; i++) ...[
            Shimmer(
              baseColor: baseColor,
              highlightColor: highlightColor,
              width: width,
              height: height,
            ),
            SizedBox(height: lineSpace),
          ],
        ],
      ),
    );
  }
}
