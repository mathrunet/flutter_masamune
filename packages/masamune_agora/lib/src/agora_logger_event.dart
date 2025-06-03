part of "/masamune_agora.dart";

/// Agora events for logging.
///
/// ロギング用のAgoraイベント。
enum AgoraLoggerEvent {
  /// Join Channel
  ///
  /// ChannelへのJoin
  join,

  /// User disengagement.
  ///
  /// ユーザーの離脱。
  leave,

  /// Update user information.
  ///
  /// ユーザー情報のアップデート。
  updateUserInformation,

  /// First frame received.
  ///
  /// 最初のフレーム受信。
  firstRemoteVideoReceived,

  /// Start of screen capture.
  ///
  /// スクリーンキャプチャーの開始。
  startScreenCapture,

  /// Stop of screen capture.
  ///
  /// スクリーンキャプチャーの終了。
  stopScreenCapture,

  /// Start of recording.
  ///
  /// 録画の開始。
  startRecording,

  /// Recording.
  ///
  /// 録画中。
  recording,

  /// End of recording.
  ///
  /// 録画の終了。
  stopRecording;

  /// User ID key.
  ///
  /// ユーザーIDのキー。
  static const userNumberKey = "userNumber";

  /// Key for the user's name.
  ///
  /// ユーザーの名前のキー。
  static const userNameKey = "userName";

  /// Channel key.
  ///
  /// チャンネルのキー。
  static const channelKey = "channel";

  /// Key for being a local user or not.
  ///
  /// ローカルユーザーであるかどうかのキー。
  static const isLocalUserKey = "isLocalUser";

  /// Screen horizontal size key.
  ///
  /// スクリーンの横サイズのキー。
  static const widthKey = "width";

  /// Screen vertical size key.
  ///
  /// スクリーンの縦サイズのキー。
  static const heightKey = "height";

  /// SID for capture.
  ///
  /// キャプチャー用のSID。
  static const captureSid = "captureSid";

  /// Resource ID for the capture.
  ///
  /// キャプチャー用のリソースID。
  static const captureResourceId = "captureResourceId";

  /// Status during recording.
  ///
  /// 録画中のステータス。
  static const recordingStatus = "recordingStatus";
}
