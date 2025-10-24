part of "/katana_ui.dart";

/// A widget for displaying multiple images in SNS-style layouts.
///
/// This widget automatically arranges 1-4 images in grid layouts optimized
/// for social media post displays. Perfect for photo galleries, social feeds,
/// and multi-image content.
///
/// Features:
/// - Automatic layout based on image count (1-4 images)
/// - Single image: Full width display
/// - Two images: Side-by-side layout
/// - Three images: One large + two stacked
/// - Four images: 2x2 grid layout
/// - Customizable image fitting and spacing
/// - Tap callback for each image
/// - Configurable border radius and height
///
/// Example:
/// ```dart
/// SnsImage(
///   images: [
///     NetworkImage('https://example.com/photo1.jpg'),
///     NetworkImage('https://example.com/photo2.jpg'),
///     NetworkImage('https://example.com/photo3.jpg'),
///   ],
///   height: 300,
///   borderRadius: BorderRadius.circular(12),
///   onTap: (image) {
///     // Handle image tap
///     print('Image tapped');
///   },
/// )
/// ```
///
/// SNSスタイルのレイアウトで複数の画像を表示するウィジェット。
///
/// ソーシャルメディアの投稿表示に最適化された、1〜4枚の画像を自動的にグリッドレイアウトで配置します。
/// フォトギャラリー、ソーシャルフィード、複数画像コンテンツに最適です。
///
/// 特徴:
/// - 画像枚数に基づく自動レイアウト（1〜4枚）
/// - 1枚: 全幅表示
/// - 2枚: 横並びレイアウト
/// - 3枚: 1枚大+2枚積み重ね
/// - 4枚: 2x2グリッドレイアウト
/// - カスタマイズ可能な画像フィッティングと間隔
/// - 各画像のタップコールバック
/// - 設定可能なボーダー半径と高さ
///
/// 例:
/// ```dart
/// SnsImage(
///   images: [
///     NetworkImage('https://example.com/photo1.jpg'),
///     NetworkImage('https://example.com/photo2.jpg'),
///     NetworkImage('https://example.com/photo3.jpg'),
///   ],
///   height: 300,
///   borderRadius: BorderRadius.circular(12),
///   onTap: (image) {
///     // 画像タップの処理
///     print('画像がタップされました');
///   },
/// )
/// ```
class SnsImage extends StatelessWidget {
  /// A widget for displaying multiple images in SNS-style layouts.
  ///
  /// This widget automatically arranges 1-4 images in grid layouts optimized
  /// for social media post displays. Perfect for photo galleries, social feeds,
  /// and multi-image content.
  ///
  /// Features:
  /// - Automatic layout based on image count (1-4 images)
  /// - Single image: Full width display
  /// - Two images: Side-by-side layout
  /// - Three images: One large + two stacked
  /// - Four images: 2x2 grid layout
  /// - Customizable image fitting and spacing
  /// - Tap callback for each image
  /// - Configurable border radius and height
  ///
  /// Example:
  /// ```dart
  /// SnsImage(
  ///   images: [
  ///     NetworkImage('https://example.com/photo1.jpg'),
  ///     NetworkImage('https://example.com/photo2.jpg'),
  ///     NetworkImage('https://example.com/photo3.jpg'),
  ///   ],
  ///   height: 300,
  ///   borderRadius: BorderRadius.circular(12),
  ///   onTap: (image) {
  ///     // Handle image tap
  ///     print('Image tapped');
  ///   },
  /// )
  /// ```
  ///
  /// SNSスタイルのレイアウトで複数の画像を表示するウィジェット。
  ///
  /// ソーシャルメディアの投稿表示に最適化された、1〜4枚の画像を自動的にグリッドレイアウトで配置します。
  /// フォトギャラリー、ソーシャルフィード、複数画像コンテンツに最適です。
  ///
  /// 特徴:
  /// - 画像枚数に基づく自動レイアウト（1〜4枚）
  /// - 1枚: 全幅表示
  /// - 2枚: 横並びレイアウト
  /// - 3枚: 1枚大+2枚積み重ね
  /// - 4枚: 2x2グリッドレイアウト
  /// - カスタマイズ可能な画像フィッティングと間隔
  /// - 各画像のタップコールバック
  /// - 設定可能なボーダー半径と高さ
  ///
  /// 例:
  /// ```dart
  /// SnsImage(
  ///   images: [
  ///     NetworkImage('https://example.com/photo1.jpg'),
  ///     NetworkImage('https://example.com/photo2.jpg'),
  ///     NetworkImage('https://example.com/photo3.jpg'),
  ///   ],
  ///   height: 300,
  ///   borderRadius: BorderRadius.circular(12),
  ///   onTap: (image) {
  ///     // 画像タップの処理
  ///     print('画像がタップされました');
  ///   },
  /// )
  /// ```
  const SnsImage({
    required this.images,
    super.key,
    this.fit = BoxFit.cover,
    this.space = 2,
    this.height = 240,
    this.borderRadius,
    this.onTap,
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

  /// The callback when the image is tapped.
  ///
  /// 画像がタップされた時のコールバック。
  final ValueChanged<ImageProvider>? onTap;

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
          child: InkWell(
            onTap: () {
              onTap?.call(images[0]);
            },
            child: Image(image: images[0], fit: fit),
          ),
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
              Expanded(
                child: InkWell(
                  onTap: () {
                    onTap?.call(images[0]);
                  },
                  child: Image(image: images[0], fit: fit),
                ),
              ),
              SizedBox(width: space),
              Expanded(
                child: InkWell(
                  onTap: () {
                    onTap?.call(images[1]);
                  },
                  child: Image(image: images[1], fit: fit),
                ),
              ),
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
              Expanded(
                child: InkWell(
                  onTap: () {
                    onTap?.call(images[0]);
                  },
                  child: Image(image: images[0], fit: fit),
                ),
              ),
              SizedBox(width: space),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          onTap?.call(images[1]);
                        },
                        child: Image(image: images[1], fit: fit),
                      ),
                    ),
                    SizedBox(height: space),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          onTap?.call(images[2]);
                        },
                        child: Image(image: images[2], fit: fit),
                      ),
                    ),
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
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          onTap?.call(images[0]);
                        },
                        child: Image(image: images[0], fit: fit),
                      ),
                    ),
                    SizedBox(height: space),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          onTap?.call(images[1]);
                        },
                        child: Image(image: images[1], fit: fit),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: space),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          onTap?.call(images[2]);
                        },
                        child: Image(image: images[2], fit: fit),
                      ),
                    ),
                    SizedBox(height: space),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          onTap?.call(images[3]);
                        },
                        child: Image(image: images[3], fit: fit),
                      ),
                    ),
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
