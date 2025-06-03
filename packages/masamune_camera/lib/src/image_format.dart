part of "/masamune_camera.dart";

/// Image format.
///
/// 画像フォーマット。
enum ImageFormat {
  /// Jpeg format.
  ///
  /// Jpegフォーマット。
  jpg,

  /// Png format.
  ///
  /// Pngフォーマット。
  png;

  /// Extension.
  ///
  /// 拡張子。
  String get extension {
    switch (this) {
      case ImageFormat.jpg:
        return "jpg";
      case ImageFormat.png:
        return "png";
    }
  }
}
