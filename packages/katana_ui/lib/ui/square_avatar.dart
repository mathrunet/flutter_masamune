part of '/katana_ui.dart';

/// Square version of [CircleAvatar].
///
/// Can be used in place of [CircleAvatar].
///
/// 四角版の[CircleAvatar]。
///
/// [CircleAvatar]の代わりに使用できます。
class SquareAvatar extends StatelessWidget {
  /// Square version of [CircleAvatar].
  ///
  /// Can be used in place of [CircleAvatar].
  ///
  /// 四角版の[CircleAvatar]。
  ///
  /// [CircleAvatar]の代わりに使用できます。
  const SquareAvatar({
    super.key,
    this.radius,
    this.backgroundColor,
    this.backgroundImage,
    this.width,
    this.height,
  });

  /// Rounded corners.
  ///
  /// 角丸。
  final double? radius;

  /// Width.
  ///
  /// 幅。
  final double? width;

  /// Height.
  ///
  /// 高さ。
  final double? height;

  /// Background color.
  ///
  /// 背景色。
  final Color? backgroundColor;

  /// Background image.
  ///
  /// 背景画像。
  final ImageProvider<Object>? backgroundImage;

  @override
  Widget build(BuildContext context) {
    return _buildSize(
      context,
      ClipRRect(
        borderRadius: BorderRadius.circular(radius ?? 0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (backgroundColor != null) ColoredBox(color: backgroundColor!),
            if (backgroundImage != null)
              Image(
                image: backgroundImage!,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSize(BuildContext context, Widget child) {
    if (width != null && height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: child,
      );
    }
    return child;
  }
}
