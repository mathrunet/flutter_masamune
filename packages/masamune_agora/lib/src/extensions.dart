part of masamune_agora;

/// Extend [VideoFrameRate].
///
/// [VideoFrameRate]を拡張します。
extension AgoraVideoFrameRateExtensions on VideoFrameRate {
  /// Converts the FPS of [VideoFrameRate] to [int].
  ///
  /// [VideoFrameRate]のFPSを[int]に変換します。
  int toInt() {
    switch (this) {
      case VideoFrameRate.Fps1:
        return 1;
      case VideoFrameRate.Fps7:
        return 7;
      case VideoFrameRate.Fps10:
        return 10;
      case VideoFrameRate.Fps15:
        return 15;
      case VideoFrameRate.Fps24:
        return 24;
      case VideoFrameRate.Fps30:
        return 30;
      case VideoFrameRate.Fps60:
        return 60;
    }
  }
}

/// Extend [AgoraUser].
///
/// [AgoraUser]を拡張します。
extension AgoraUserExtensions on AgoraUser {
  /// Convert [AgoraUser] to [AgoraScreen] as it is.
  ///
  /// [AgoraUser]をそのまま[AgoraScreen]に変換します。
  Widget toScreen({
    double iconSize = 48.0,
    Color? disabledColor,
    Color? disabledBackgroundColor,
    Widget? disabled,
  }) {
    return AgoraScreen(
      value: this,
      iconSize: iconSize,
      disabled: disabled,
      disabledColor: disabledColor,
      disabledBackgroundColor: disabledBackgroundColor,
    );
  }
}
