part of katana_ui;

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
  });

  /// Rounded corners.
  ///
  /// 角丸。
  final double? radius;

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (backgroundImage != null) Image(image: backgroundImage!),
          if (backgroundColor != null) ColoredBox(color: backgroundColor!),
        ],
      ),
    );
  }
}
