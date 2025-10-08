part of "/katana_ui.dart";

/// A container widget that displays a shimmer loading effect.
///
/// This widget creates a shimmer effect placeholder that can be used during
/// loading states. Perfect for skeleton screens, loading placeholders, and
/// content loading indicators.
///
/// Features:
/// - Customizable shimmer animation colors
/// - Adjustable width and height
/// - Configurable border radius
/// - Rectangle or circle shapes
/// - Theme-based default colors
/// - Optional child widget
/// - Enable/disable shimmer effect
///
/// Example:
/// ```dart
/// ShimmerBox(
///   width: 200,
///   height: 20,
///   borderRadius: BorderRadius.circular(4),
///   baseColor: Colors.grey[300],
///   highlightColor: Colors.grey[100],
/// )
/// ```
///
/// シマーローディングエフェクトを表示するコンテナウィジェット。
///
/// このウィジェットはローディング状態中に使用できるシマーエフェクトの
/// プレースホルダーを作成します。スケルトンスクリーン、ローディングプレースホルダー、
/// コンテンツローディングインジケータに最適です。
///
/// 特徴:
/// - カスタマイズ可能なシマーアニメーションカラー
/// - 調整可能な幅と高さ
/// - 設定可能なボーダー半径
/// - 矩形または円形の形状
/// - テーマベースのデフォルトカラー
/// - オプションの子ウィジェット
/// - シマーエフェクトの有効/無効化
///
/// 例:
/// ```dart
/// ShimmerBox(
///   width: 200,
///   height: 20,
///   borderRadius: BorderRadius.circular(4),
///   baseColor: Colors.grey[300],
///   highlightColor: Colors.grey[100],
/// )
/// ```
class ShimmerBox extends StatelessWidget {
  /// A container widget that displays a shimmer loading effect.
  ///
  /// This widget creates a shimmer effect placeholder that can be used during
  /// loading states. Perfect for skeleton screens, loading placeholders, and
  /// content loading indicators.
  ///
  /// Features:
  /// - Customizable shimmer animation colors
  /// - Adjustable width and height
  /// - Configurable border radius
  /// - Rectangle or circle shapes
  /// - Theme-based default colors
  /// - Optional child widget
  /// - Enable/disable shimmer effect
  ///
  /// Example:
  /// ```dart
  /// ShimmerBox(
  ///   width: 200,
  ///   height: 20,
  ///   borderRadius: BorderRadius.circular(4),
  ///   baseColor: Colors.grey[300],
  ///   highlightColor: Colors.grey[100],
  /// )
  /// ```
  ///
  /// シマーローディングエフェクトを表示するコンテナウィジェット。
  ///
  /// このウィジェットはローディング状態中に使用できるシマーエフェクトの
  /// プレースホルダーを作成します。スケルトンスクリーン、ローディングプレースホルダー、
  /// コンテンツローディングインジケータに最適です。
  ///
  /// 特徴:
  /// - カスタマイズ可能なシマーアニメーションカラー
  /// - 調整可能な幅と高さ
  /// - 設定可能なボーダー半径
  /// - 矩形または円形の形状
  /// - テーマベースのデフォルトカラー
  /// - オプションの子ウィジェット
  /// - シマーエフェクトの有効/無効化
  ///
  /// 例:
  /// ```dart
  /// ShimmerBox(
  ///   width: 200,
  ///   height: 20,
  ///   borderRadius: BorderRadius.circular(4),
  ///   baseColor: Colors.grey[300],
  ///   highlightColor: Colors.grey[100],
  /// )
  /// ```
  const ShimmerBox({
    super.key,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
    this.width = double.infinity,
    this.height,
    this.padding = const EdgeInsets.all(0),
    this.shape = BoxShape.rectangle,
    this.child,
    this.enabled = true,
  });

  /// Whether to display the shimmer effect.
  ///
  /// シマーエフェクトを表示するかどうか。
  final bool enabled;

  /// Widget for the container inside.
  ///
  /// 中身のコンテナのウィジェット。
  final Widget? child;

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
    if (!enabled) {
      return child ??
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius ?? BorderRadius.circular(h / 4),
              color: baseColor ?? Theme.of(context).colorScheme.surface,
              shape: shape,
            ),
            margin: padding,
            height: h,
            width: width,
          );
    }
    return sm.Shimmer.fromColors(
      baseColor: baseColor ?? Theme.of(context).colorScheme.surface,
      highlightColor:
          highlightColor ?? Theme.of(context).scaffoldBackgroundColor,
      child: child ??
          Container(
            decoration: BoxDecoration(
              borderRadius: shape == BoxShape.circle
                  ? null
                  : borderRadius ?? BorderRadius.circular(h / 4),
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

/// A multi-line shimmer effect widget for paragraph-style loading placeholders.
///
/// This widget creates multiple ShimmerBox instances stacked vertically to
/// simulate multi-line text loading. Perfect for article previews, comment
/// placeholders, and multi-line content loading states.
///
/// Features:
/// - Multiple shimmer lines stacked vertically
/// - Customizable line count
/// - Adjustable spacing between lines
/// - Shared shimmer effect colors across all lines
/// - Theme-based default colors
/// - Configurable line dimensions
///
/// Example:
/// ```dart
/// ShimmerMultiLine(
///   lineCount: 4,
///   lineSpace: 12,
///   height: 16,
///   baseColor: Colors.grey[300],
///   highlightColor: Colors.grey[100],
///   padding: EdgeInsets.all(16),
/// )
/// ```
///
/// 段落スタイルのローディングプレースホルダー用の複数行シマーエフェクトウィジェット。
///
/// このウィジェットは複数のShimmerBoxインスタンスを垂直に積み重ねて
/// 複数行のテキストローディングをシミュレートします。記事プレビュー、コメント
/// プレースホルダー、複数行コンテンツのローディング状態に最適です。
///
/// 特徴:
/// - 垂直に積み重ねられた複数のシマーライン
/// - カスタマイズ可能な行数
/// - 行間の調整可能な間隔
/// - すべての行で共有されるシマーエフェクトカラー
/// - テーマベースのデフォルトカラー
/// - 設定可能な行のサイズ
///
/// 例:
/// ```dart
/// ShimmerMultiLine(
///   lineCount: 4,
///   lineSpace: 12,
///   height: 16,
///   baseColor: Colors.grey[300],
///   highlightColor: Colors.grey[100],
///   padding: EdgeInsets.all(16),
/// )
/// ```
class ShimmerMultiLine extends StatelessWidget {
  /// A multi-line shimmer effect widget for paragraph-style loading placeholders.
  ///
  /// This widget creates multiple ShimmerBox instances stacked vertically to
  /// simulate multi-line text loading. Perfect for article previews, comment
  /// placeholders, and multi-line content loading states.
  ///
  /// Features:
  /// - Multiple shimmer lines stacked vertically
  /// - Customizable line count
  /// - Adjustable spacing between lines
  /// - Shared shimmer effect colors across all lines
  /// - Theme-based default colors
  /// - Configurable line dimensions
  ///
  /// Example:
  /// ```dart
  /// ShimmerMultiLine(
  ///   lineCount: 4,
  ///   lineSpace: 12,
  ///   height: 16,
  ///   baseColor: Colors.grey[300],
  ///   highlightColor: Colors.grey[100],
  ///   padding: EdgeInsets.all(16),
  /// )
  /// ```
  ///
  /// 段落スタイルのローディングプレースホルダー用の複数行シマーエフェクトウィジェット。
  ///
  /// このウィジェットは複数のShimmerBoxインスタンスを垂直に積み重ねて
  /// 複数行のテキストローディングをシミュレートします。記事プレビュー、コメント
  /// プレースホルダー、複数行コンテンツのローディング状態に最適です。
  ///
  /// 特徴:
  /// - 垂直に積み重ねられた複数のシマーライン
  /// - カスタマイズ可能な行数
  /// - 行間の調整可能な間隔
  /// - すべての行で共有されるシマーエフェクトカラー
  /// - テーマベースのデフォルトカラー
  /// - 設定可能な行のサイズ
  ///
  /// 例:
  /// ```dart
  /// ShimmerMultiLine(
  ///   lineCount: 4,
  ///   lineSpace: 12,
  ///   height: 16,
  ///   baseColor: Colors.grey[300],
  ///   highlightColor: Colors.grey[100],
  ///   padding: EdgeInsets.all(16),
  /// )
  /// ```
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
            ShimmerBox(
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
