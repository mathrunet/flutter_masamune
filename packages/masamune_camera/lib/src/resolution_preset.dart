part of "/masamune_camera.dart";

/// Preset resolution for using the camera.
///
/// カメラを利用するための解像度のプリセット。
enum ResolutionPreset {
  /// 352x288 on iOS, ~240p on Android and Web.
  ///
  /// IOSは352x288, AndroidやWebだと~240p。
  low,

  /// ~480p.
  ///
  /// ~480p。
  medium,

  /// ~720p.
  ///
  /// ~720p。
  high,

  /// ~1080p.
  ///
  /// ~1080p。
  veryHigh,

  /// ~2160p.
  ///
  /// ~2160p。
  ultraHigh,

  /// The highest resolution available.
  ///
  /// 最高解像度。
  max;

  camera.ResolutionPreset _toResolutionPreset() {
    switch (this) {
      case ResolutionPreset.low:
        return camera.ResolutionPreset.low;
      case ResolutionPreset.medium:
        return camera.ResolutionPreset.medium;
      case ResolutionPreset.high:
        return camera.ResolutionPreset.high;
      case ResolutionPreset.veryHigh:
        return camera.ResolutionPreset.veryHigh;
      case ResolutionPreset.ultraHigh:
        return camera.ResolutionPreset.ultraHigh;
      case ResolutionPreset.max:
        return camera.ResolutionPreset.max;
    }
  }
}
