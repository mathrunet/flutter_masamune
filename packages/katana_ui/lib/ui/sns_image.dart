part of '/katana_ui.dart';

/// Widget to display an image with a specified size.
///
/// サイズを指定して画像を表示するウィジェット。
class SnsImage extends StatelessWidget {
  /// Widget to display an image with a specified size.
  ///
  /// サイズを指定して画像を表示するウィジェット。
  const SnsImage({
    super.key,
    required this.images,
    this.fit = BoxFit.cover,
    this.space = 2,
    this.height = 240,
    this.borderRadius,
  });

  /// The list of image providers to display.
  ///
  /// 表示する画像のリスト。
  final List<ImageProvider> images;

  /// The fit of the image.
  ///
  /// 画像のフィット。
  final BoxFit fit;

  /// The space between the images.
  ///
  /// 画像間のスペース。
  final double space;

  /// The height of the image.
  ///
  /// 画像の高さ。
  final double height;

  /// The border radius of the image.
  ///
  /// 画像の角の丸み。
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final length = images.length;
    if (length == 0) {
      return const SizedBox.shrink();
    } else if (length == 1) {
      return SizedBox(
        height: height,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Image(image: images.first, fit: fit),
        ),
      );
    } else if (length == 2) {
      return SizedBox(
        height: height,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: Image(image: images[0], fit: fit)),
              SizedBox(width: space),
              Expanded(child: Image(image: images[1], fit: fit)),
            ],
          ),
        ),
      );
    } else if (length == 3) {
      return SizedBox(
        height: height,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(child: Image(image: images[0], fit: fit)),
              SizedBox(width: space),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: Image(image: images[1], fit: fit)),
                    SizedBox(height: space),
                    Expanded(child: Image(image: images[2], fit: fit)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        height: height,
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: Image(image: images[0], fit: fit)),
                    SizedBox(height: space),
                    Expanded(child: Image(image: images[1], fit: fit)),
                  ],
                ),
              ),
              SizedBox(width: space),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: Image(image: images[2], fit: fit)),
                    SizedBox(height: space),
                    Expanded(child: Image(image: images[3], fit: fit)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
