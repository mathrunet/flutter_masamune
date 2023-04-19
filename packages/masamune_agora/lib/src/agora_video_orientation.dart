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

  /// Convert to [VideoOutputOrientationMode] used on AgoraSDK.
  ///
  /// AgoraSDK上で利用する[VideoOutputOrientationMode]に変換します。
  VideoOutputOrientationMode toVideoOutputOrientationMode() {
    switch (this) {
      case AgoraVideoOrientation.landscape:
        return VideoOutputOrientationMode.FixedLandscape;
      case AgoraVideoOrientation.portrait:
        return VideoOutputOrientationMode.FixedPortrait;
    }
  }
}
