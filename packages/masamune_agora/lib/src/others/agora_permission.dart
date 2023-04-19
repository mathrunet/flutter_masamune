part of masamune_agora.others;

/// A class that manages the authorization area.
///
/// Requests the use of privileges with [request].
///
/// 権限周りを管理するクラス。
///
/// [request]で権限の利用を要求します。
class AgoraPermission {
  /// A class that manages the authorization area.
  ///
  /// Requests the use of privileges with [request].
  ///
  /// 権限周りを管理するクラス。
  ///
  /// [request]で権限の利用を要求します。
  const AgoraPermission();

  /// Requests the use of privileges.
  ///
  /// If [enableVideo] and [enableAudio] are set to `true` respectively, the related permissions are checked & requested.
  ///
  /// 権限の利用を要求します。
  ///
  /// [enableVideo]と[enableAudio]をそれぞれ`true`にすると関連する権限をチェック＆リクエストします。
  Future<bool> request({
    bool enableVideo = true,
    bool enableAudio = true,
  }) async {
    if (enableVideo) {
      var status = await permission_handler.Permission.camera.status;
      if (status != permission_handler.PermissionStatus.granted) {
        await permission_handler.Permission.camera.request();
        status = await permission_handler.Permission.camera.status;
        if (status != permission_handler.PermissionStatus.granted) {
          return false;
        }
      }
    }
    if (enableAudio) {
      var status = await permission_handler.Permission.microphone.status;
      if (status != permission_handler.PermissionStatus.granted) {
        await permission_handler.Permission.microphone.request();
        status = await permission_handler.Permission.microphone.status;
        if (status != permission_handler.PermissionStatus.granted) {
          return false;
        }
      }
    }
    return true;
  }
}
