part of "/masamune_camera.dart";

/// Media format.
///
/// メディアフォーマット。
enum MediaFormat {
  /// Jpeg format.
  ///
  /// Jpegフォーマット。
  jpg,

  /// Png format.
  ///
  /// Pngフォーマット。
  png,

  /// Mp4 format.
  ///
  /// Mp4フォーマット。
  mp4;

  /// Extension.
  ///
  /// 拡張子。
  String get extension {
    switch (this) {
      case MediaFormat.jpg:
        return "jpg";
      case MediaFormat.png:
        return "png";
      case MediaFormat.mp4:
        return "mp4";
    }
  }
}
