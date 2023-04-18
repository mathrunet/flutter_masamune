part of masamune_agora.web;

class AgoraPermission {
  const AgoraPermission();

  Future<bool> request({
    bool enableVideo = true,
    bool enableAudio = true,
  }) async {
    if (enableVideo) {
      var status =
          await window.navigator.permissions?.query({"name": "camera"});
      if (status?.state == "denied") {
        return false;
      }
      await window.navigator.getUserMedia(video: true);
    }
    if (enableAudio) {
      var status =
          await window.navigator.permissions?.query({"name": "microphone"});
      if (status?.state == "denied") {
        return false;
      }
      await window.navigator.getUserMedia(audio: true);
    }
    return true;
  }
}
