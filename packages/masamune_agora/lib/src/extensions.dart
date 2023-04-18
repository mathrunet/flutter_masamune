part of masamune_agora;

extension AgoraVideoFrameRateExtensions on VideoFrameRate {
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

extension AgoraUserExtensions on AgoraUser {
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
