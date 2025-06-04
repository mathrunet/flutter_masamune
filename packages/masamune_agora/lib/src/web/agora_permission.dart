part of "web.dart";

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
    try {
      final constraints = <String, JSAny?>{};

      if (enableVideo) {
        constraints["video"] = true.toJS;
      }
      if (enableAudio) {
        constraints["audio"] = true.toJS;
      }

      if (constraints.isNotEmpty) {
        await web.window.navigator.mediaDevices
            .getUserMedia(constraints.jsify()! as web.MediaStreamConstraints)
            .toDart;
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
