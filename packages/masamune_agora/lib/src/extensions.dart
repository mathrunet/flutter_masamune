part of masamune_agora;

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
