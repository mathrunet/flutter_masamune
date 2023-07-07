part of masamune_agora;

/// Defines the orientation of the video.
///
/// ビデオの向きを定義します。
enum AgoraVideoOrientation {
  /// Landscape.
  ///
  /// 横向き。
  landscape,

  /// Portrait.
  ///
  /// 縦向き。
  portrait;

  /// Convert to [AgoraVideoOrientation] used on AgoraSDK.
  ///
  /// AgoraSDK上で利用する[AgoraVideoOrientation]に変換します。
  OrientationMode toVideoOutputOrientationMode() {
    switch (this) {
      case AgoraVideoOrientation.landscape:
        return OrientationMode.orientationModeFixedLandscape;
      case AgoraVideoOrientation.portrait:
        return OrientationMode.orientationModeFixedPortrait;
    }
  }
}
