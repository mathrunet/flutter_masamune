part of "/masamune_agora.dart";

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
    bool useAndroidSurfaceView = false,
    bool useFlutterTexture = false,
  }) {
    return AgoraScreen(
      value: this,
      iconSize: iconSize,
      disabled: disabled,
      disabledColor: disabledColor,
      disabledBackgroundColor: disabledBackgroundColor,
      useAndroidSurfaceView: useAndroidSurfaceView,
      useFlutterTexture: useFlutterTexture,
    );
  }
}
