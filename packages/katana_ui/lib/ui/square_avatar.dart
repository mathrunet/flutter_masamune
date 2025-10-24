part of "/katana_ui.dart";

/// A square avatar widget that works as a rectangular alternative to CircleAvatar.
///
/// This widget provides a customizable square or rounded rectangle avatar display,
/// perfect for profile pictures, icons, and feature images where a square shape
/// is preferred over the circular shape of CircleAvatar.
///
/// Features:
/// - Adjustable corner radius (from square to rounded corners)
/// - Background color support
/// - Background image support with BoxFit.cover
/// - Optional width and height specification
/// - Layer system (background color behind image)
///
/// Example:
/// ```dart
/// SquareAvatar(
///   backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
///   backgroundColor: Colors.grey,
///   radius: 12.0,
///   width: 48,
///   height: 48,
/// )
/// ```
///
/// 四角版の[CircleAvatar]。
///
/// このウィジェットは、CircleAvatarの円形の代わりに四角形や角丸四角形のアバター表示を提供します。
/// プロフィール画像、アイコン、フィーチャー画像などで四角形が好まれる場合に最適です。
///
/// 特徴:
/// - 調整可能な角丸半径（四角から角丸まで）
/// - 背景色のサポート
/// - BoxFit.coverによる背景画像のサポート
/// - オプションのwidth/height指定
/// - レイヤーシステム（画像の背後に背景色）
///
/// 例:
/// ```dart
/// SquareAvatar(
///   backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
///   backgroundColor: Colors.grey,
///   radius: 12.0,
///   width: 48,
///   height: 48,
/// )
/// ```
class SquareAvatar extends StatelessWidget {
  /// A square avatar widget that works as a rectangular alternative to CircleAvatar.
  ///
  /// This widget provides a customizable square or rounded rectangle avatar display,
  /// perfect for profile pictures, icons, and feature images where a square shape
  /// is preferred over the circular shape of CircleAvatar.
  ///
  /// Features:
  /// - Adjustable corner radius (from square to rounded corners)
  /// - Background color support
  /// - Background image support with BoxFit.cover
  /// - Optional width and height specification
  /// - Layer system (background color behind image)
  ///
  /// Example:
  /// ```dart
  /// SquareAvatar(
  ///   backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ///   backgroundColor: Colors.grey,
  ///   radius: 12.0,
  ///   width: 48,
  ///   height: 48,
  /// )
  /// ```
  ///
  /// 四角版の[CircleAvatar]。
  ///
  /// このウィジェットは、CircleAvatarの円形の代わりに四角形や角丸四角形のアバター表示を提供します。
  /// プロフィール画像、アイコン、フィーチャー画像などで四角形が好まれる場合に最適です。
  ///
  /// 特徴:
  /// - 調整可能な角丸半径（四角から角丸まで）
  /// - 背景色のサポート
  /// - BoxFit.coverによる背景画像のサポート
  /// - オプションのwidth/height指定
  /// - レイヤーシステム（画像の背後に背景色）
  ///
  /// 例:
  /// ```dart
  /// SquareAvatar(
  ///   backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ///   backgroundColor: Colors.grey,
  ///   radius: 12.0,
  ///   width: 48,
  ///   height: 48,
  /// )
  /// ```
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
