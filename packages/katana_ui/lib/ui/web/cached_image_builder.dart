part of "web.dart";

/// Cached image widget.
///
/// キャッシュされた画像を表示するためのウィジェット。
@immutable
class CachedImageWidget extends StatefulWidget {
  /// Cached image widget.
  ///
  /// キャッシュされた画像を表示するためのウィジェット。
  const CachedImageWidget({
    required super.key,
    required this.builder,
    this.width,
    this.height,
    this.showLoadingIndicator = false,
    this.coverBackgroundColor,
  }) : assert(coverBackgroundColor == null || showLoadingIndicator,
            "coverBackgroundColor is only used when showLoadingIndicator is true");

  /// Builder that returns the widget to be converted to an image.
  ///
  /// 画像を生成するためのウィジェットを返すビルダー。
  final Widget Function(BuildContext context) builder;

  /// Image width (optional).
  ///
  /// 画像の幅 (オプション)。
  final double? width;

  /// Image height (optional).
  ///
  /// 画像の高さ (オプション)。
  final double? height;

  /// Show loading indicator while caching (optional).
  final bool showLoadingIndicator;

  /// Cover background color (optional).
  ///
  /// 背景色 (オプション)。
  final Color? coverBackgroundColor;

  @override
  State<CachedImageWidget> createState() => _CachedImageWidgetState();
}

class _CachedImageWidgetState extends State<CachedImageWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
