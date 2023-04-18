part of masamune_agora.others;

class AgoraPermission {
  const AgoraPermission();

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
