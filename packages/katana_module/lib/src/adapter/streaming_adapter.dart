part of katana_module;

/// Module adapter for setting up streaming.
///
/// [StreamingAdapter] can switch the data
/// when the module is used by passing it to [UIMaterialApp].
@immutable
abstract class StreamingAdapter<TModel extends StreamingModel>
    extends AdapterModule {
  const StreamingAdapter();

  /// Initializes the Streaming service.
  Future<void> initialize(BuildContext context);

  /// Get the model provider.
  ProviderBase<TModel> modelProvider(String path);

  /// True for streaming recording by default.
  bool get enableRecordingByDefault;

  /// True for screen capture by default.
  bool get enableScreenCaptureByDefault;

  /// URL for screen captures.
  String screenCaptureURL(String path);

  /// URL for screen captures.
  String recordURL(String path);

  /// Return True if recordURL is valid.
  Future<bool> checkActiveRecordURL(String path);

  /// Checks permissions. If `false`, it cannot be used.
  Future<bool> checkPermission(
      {bool enableVideo = true, bool enableAudio = true});
}

/// Model for Streaming.
abstract class StreamingModel<T> implements Model<T> {
  const StreamingModel();

  /// The name of the local account.
  String get localName;

  /// The uid of the local account.
  int get localUID;

  /// True if the connection process is in progress.
  bool get connected;

  /// True if [userId] has entered the room.
  ///
  /// When [userId] is not specified,
  /// it checks whether it is entering the room based on [localUID].
  bool joined([int? userId]);

  /// Returns itself after the connecting finishes.
  Future<void>? get connecting;

  /// Returns itself after the disconnecting finishes.
  Future<void>? get disconnecting;

  /// True to enable audio.
  bool get enableAudio;

  /// True to enable video.
  bool get enableVideo;

  /// True to mute the call.
  bool get mute;

  /// Class for using the real time communication function of Agora.
  ///
  /// First, [AgoraRTC.initialize()] must be executed.
  ///
  /// You can join a room by executing [connect()] with a path.
  /// At that time, it is possible to specify the settings for live streaming distribution and
  /// the presence or absence of audio and video.
  ///
  /// Members who are in the room including yourself are displayed in the collection.
  ///
  /// Finally, leave the room by executing [disconnect()].
  Future<void> connect({
    int width = 1280,
    int height = 720,
    int frameRate = 24,
    int bitRate = 0,
    bool enableAudio = true,
    bool enableVideo = true,
    bool enableRecordingOnConnect = false,
    bool enableScreenCaptureOnConnect = false,
    StreamingChannelProfile channelProfile =
        StreamingChannelProfile.LiveBroadcasting,
    StreamingClientRole clientRole = StreamingClientRole.Broadcaster,
    StreamingVideoOutputOrientationMode orientationMode =
        StreamingVideoOutputOrientationMode.FixedPortrait,
    Duration timeout = const Duration(seconds: 60),
    DynamicMap Function(DynamicMap userInfo)? filter,
  });

  /// Close the connection.
  Future<void> disconnect();

  /// Start taking screenshots.
  Future<void> startScreenCapture();

  /// Stop taking screen shots.
  Future<void> stopScreenCapture();

  /// Start taking screenshots.
  Future<void> startRecording();

  /// Stop taking screen shots.
  Future<void> stopRecording();

  /// Start recording audio.
  ///
  /// [filePath]: Path to save the recording.
  /// [sampleRate]: Sample rate to be recorded.
  /// [quality]: Quality to record.
  Future<void> startAudioRecording(
    String filePath, {
    int sampleRate = 44100,
    StreamingAudioRecordingQuality quality =
        StreamingAudioRecordingQuality.Medium,
  });

  /// Stop Recording.
  Future<void> stopAudioRecording();

  /// URL for screen captures.
  String get screenCaptureURL;

  /// URL for screen captures.
  String get recordURL;

  /// Return True if recordURL is valid.
  Future<bool> checkActiveRecordURL();

  /// Gets the current local screen as a widget.
  Widget localScreen();

  /// Get all screens as widgets, including remote locals.
  List<Widget> allScreens();

  /// Set the screen
  Future<void> setScreen(
    int width,
    int height, {
    int? frameRate,
    int? bitRate,
  });

  /// True to enable audio.
  ///
  /// [enableAudio]: True to enable audio.
  set enableAudio(bool enableAudio);

  /// True to enable video.
  ///
  /// [enableVideo]: True to enable video.
  set enableVideo(bool enableVideo);

  /// True to mute the call.
  ///
  /// [mute]: True to mute the call.
  set mute(bool mute);

  /// Switches the camera in / out.
  void switchCamera();

  /// Destroys the object.
  ///
  /// Destroyed objects are not allowed.
  @override
  void dispose();
}

/// Settings for storing Streaming video.
@immutable
abstract class StorageBucketConfig {
  const StorageBucketConfig();
}

/// Channel profile.
enum StreamingChannelProfile {
  /// The Communication profile.
  ///
  /// Use this profile in one-on-one calls or group calls, where all users can talk freely.
  Communication,

  /// The LiveBroadcasting profile.
  ///
  /// Users in a live-broadcast channel have a role as either broadcaster or audience. A broadcaster can both send and receive streams; an audience can only receive streams.
  LiveBroadcasting,

  /// The Gaming profile.
  ///
  /// This profile uses a codec with a lower bitrate and consumes less power. Applies to the gaming scenario, where all game players can talk freely.
  Game,
}

/// Client role in a live broadcast.
enum StreamingClientRole {
  /// A broadcaster can both send and receive streams.
  Broadcaster,

  /// The default role. An audience can only receive streams.
  Audience,
}

/// Video output orientation mode.
enum StreamingVideoOutputOrientationMode {
  /// Adaptive mode (Default).
  /// The video encoder adapts to the orientation mode of the video input device. When you use a custom video source, the output video from the encoder inherits the orientation of the original video.
  /// - If the width of the captured video from the SDK is greater than the height, the encoder sends the video in landscape mode. The encoder also sends the rotational information of the video, and the receiver uses the rotational information to rotate the received video.
  /// - If the original video is in portrait mode, the output video from the encoder is also in portrait mode. The encoder also sends the rotational information of the video to the receiver.
  Adaptative,

  /// Landscape mode.
  /// The video encoder always sends the video in landscape mode. The video encoder rotates the original video before sending it and the rotational information is 0. This mode applies to scenarios involving CDN live streaming.
  FixedLandscape,

  /// Portrait mode.
  /// The video encoder always sends the video in portrait mode. The video encoder rotates the original video before sending it and the rotational information is 0. This mode applies to scenarios involving CDN live streaming.
  FixedPortrait,
}

/// Audio recording quality.
enum StreamingAudioRecordingQuality {
  /// Low quality. For example, the size of an AAC file with a sample rate of 32,000 Hz and a 10-minute recording is approximately 1.2 MB.
  Low,

  /// (Default) Medium quality. For example, the size of an AAC file with a sample rate of 32,000 Hz and a 10-minute recording is approximately 2 MB.
  Medium,

  /// High quality. For example, the size of an AAC file with a sample rate of 32,000 Hz and a 10-minute recording is approximately 3.75 MB.
  High,
}
