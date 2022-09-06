part of masamune_agora;

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
final agoraRTCChannelModel =
    ChangeNotifierProviderFamily<AgoraRTCChannelModel, String>(
  (_, path) => AgoraRTCChannelModel(path),
);

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
final agoraRTCChannelDisposableModel =
    ChangeNotifierProvider.autoDispose.family<AgoraRTCChannelModel, String>(
  (_, path) => AgoraRTCChannelModel(path),
);

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
class AgoraRTCChannelModel extends ValueModel<Map<String, DynamicMap>>
    implements StreamingModel<Map<String, DynamicMap>> {
  AgoraRTCChannelModel(this.path) : super({});

  final String path;
  bool _connected = false;

  static const String _agoraURL = "https://api.agora.io/v1/apps";
  DynamicMap Function(DynamicMap userInfo)? _filter;

  /// The name of the local account.
  @override
  String get localName => AgoraRTCCore.instance.name;

  /// The uid of the local account.
  @override
  int get localUID => AgoraRTCCore.instance.uid;

  /// The width of the screen to send to the remote.
  int get width => _width;
  int _width = 320;

  /// The height of the screen to send to the remote.
  int get height => _height;
  int _height = 180;

  /// The frame rate of the screen sent to the remote.
  VideoFrameRate get frameRate => _frameRate;
  VideoFrameRate _frameRate = VideoFrameRate.Fps15;

  /// The bit rate of the screen sent to the remote.
  int get bitRate => _bitRate;
  int _bitRate = 150;

  /// True if the connection process is in progress.
  @override
  bool get connected => _connected;

  /// True if [userId] has entered the room.
  ///
  /// When [userId] is not specified,
  /// it checks whether it is entering the room based on [localUID].
  @override
  bool joined([int? userId]) {
    userId ??= localUID;
    return value.containsKey(userId.toString());
  }

  /// Orientation mode.
  VideoOutputOrientationMode get orientationMode => _orientationMode;
  VideoOutputOrientationMode _orientationMode =
      VideoOutputOrientationMode.Adaptative;

  /// Returns itself after the connecting finishes.
  @override
  Future<void>? get connecting => _connectingCompleter?.future;
  Completer<void>? _connectingCompleter;

  /// Returns itself after the disconnecting finishes.
  @override
  Future<void>? get disconnecting => _disconnectingCompleter?.future;
  Completer<void>? _disconnectingCompleter;

  /// Channel profile settings.
  ChannelProfile get channelProfile => _channelProfile;
  ChannelProfile _channelProfile = ChannelProfile.Communication;

  /// Client role settings.
  ClientRole get clientRole => _clientRole;
  ClientRole _clientRole = ClientRole.Broadcaster;

  /// True to enable audio.
  @override
  bool get enableAudio => _enableAudio;
  bool _enableAudio = true;

  /// True to enable video.
  @override
  bool get enableVideo => _enableVideo;
  bool _enableVideo = true;

  /// True to mute the call.
  @override
  bool get mute => _mute;
  bool _mute = false;

  bool _isRecordingAudio = false;
  String? __recordingCaptureId;
  String? __recordingVideoId;
  String? _sidCapture;
  String? _sidVideo;
  String? _resourceCaptureId;
  String? _resourceVideoId;
  String? _token;

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
  @override
  Future<void> connect({
    String? appId,
    String? userName,
    String? customerId,
    String? customerSecret,
    String? tokenServerPath,
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
  }) async {
    _width = width;
    _height = height;
    _bitRate = bitRate;
    _orientationMode = VideoOutputOrientationMode.values
            .firstWhereOrNull((e) => e.index == orientationMode.index) ??
        VideoOutputOrientationMode.FixedPortrait;
    _frameRate = _changeFrameRate(frameRate);
    _enableAudio = enableAudio;
    _enableVideo = enableVideo;
    _channelProfile = ChannelProfile.values
            .firstWhereOrNull((e) => e.index == channelProfile.index) ??
        ChannelProfile.LiveBroadcasting;
    _clientRole = ClientRole.values
            .firstWhereOrNull((e) => e.index == clientRole.index) ??
        ClientRole.Broadcaster;
    _filter = filter;
    await _joinRoom(
      appId: appId,
      userName: userName,
      customerId: customerId,
      customerSecret: customerSecret,
      timeout: timeout,
      tokenServerPath: tokenServerPath,
      enableRecordingOnConnect: enableRecordingOnConnect,
      enableScreenCaptureOnConnect: enableScreenCaptureOnConnect,
    );
  }

  VideoFrameRate _changeFrameRate(int frameRate) {
    if (frameRate >= 60) {
      return VideoFrameRate.Fps60;
    } else if (frameRate >= 30) {
      return VideoFrameRate.Fps30;
    } else if (frameRate >= 24) {
      return VideoFrameRate.Fps24;
    } else if (frameRate >= 15) {
      return VideoFrameRate.Fps15;
    } else if (frameRate >= 10) {
      return VideoFrameRate.Fps10;
    } else if (frameRate >= 7) {
      return VideoFrameRate.Fps7;
    } else {
      return VideoFrameRate.Fps1;
    }
  }

  Future<void> _joinRoom({
    String? userName,
    String? appId,
    String? customerId,
    String? customerSecret,
    String? tokenServerPath,
    Duration timeout = const Duration(seconds: 60),
    bool enableRecordingOnConnect = false,
    bool enableScreenCaptureOnConnect = false,
  }) async {
    if (_connectingCompleter != null) {
      return connecting;
    }
    _connectingCompleter = Completer<void>();
    try {
      _connected = true;
      if (appId.isNotEmpty &&
          userName.isNotEmpty &&
          tokenServerPath.isNotEmpty) {
        await AgoraRTCCore.initialize(
          appId: appId!,
          userName: userName!,
          customerId: customerId,
          customerSecret: customerSecret,
          tokenServerPath: tokenServerPath!,
        );
      }
      if (!AgoraRTCCore.isInitialized) {
        throw Exception(
          "The engine is not initialized. Initialize the engine first.",
        );
      }
      final core = AgoraRTCCore.instance;
      if (enableVideo) {
        var status = await permission_handler.Permission.camera.status;
        if (status == permission_handler.PermissionStatus.denied) {
          await permission_handler.Permission.camera.request();
          status = await permission_handler.Permission.camera.status;
          if (status != permission_handler.PermissionStatus.granted) {
            throw Exception(
              "You are not authorized to use the camera service. "
                      "Check the permission settings."
                  .localize(),
            );
          }
        }
      }
      if (enableAudio) {
        var status = await permission_handler.Permission.microphone.status;
        if (status == permission_handler.PermissionStatus.denied) {
          await permission_handler.Permission.microphone.request();
          status = await permission_handler.Permission.microphone.status;
          if (status != permission_handler.PermissionStatus.granted) {
            throw Exception(
              "You are not authorized to use the microphone service. "
                      "Check the permission settings."
                  .localize(),
            );
          }
        }
      }
      final channelName = path.replaceAll(RegExp(r"[^0-9a-zA-Z]"), "");
      final token = await _getToken(channelName);
      core._engine.setEventHandler(
        RtcEngineEventHandler(
          error: (err) {
            print("Error: ${err.toString()}");
            _connectingCompleter?.completeError(err);
            _connectingCompleter = null;
            _disconnectingCompleter?.completeError(err);
            _disconnectingCompleter = null;
            dispose();
          },
          userInfoUpdated: (uid, info) {
            final id = uid.toString();
            if (!value.containsKey(id)) {
              return;
            }
            final data = value.get<DynamicMap?>(id, null);
            if (data == null) {
              return;
            }
            data[Const.name] = info.userAccount;
            value[id] = _filter?.call(data) ?? data;
            print("Update user information: $uid, ${info.userAccount}");
            notifyListeners();
          },
          joinChannelSuccess: (channel, uid, elapsed) async {
            final id = uid.toString();
            if (!value.containsKey(id)) {
              final data = <String, dynamic>{
                Const.uid: uid,
                "local": true,
                "channel": channel,
              };
              value[id] = _filter?.call(data) ?? data;
              if (enableScreenCaptureOnConnect &&
                  channelProfile == ChannelProfile.LiveBroadcasting &&
                  clientRole == ClientRole.Broadcaster) {
                await startScreenCapture();
              }
              if (enableRecordingOnConnect &&
                  channelProfile == ChannelProfile.LiveBroadcasting &&
                  clientRole == ClientRole.Broadcaster) {
                await startRecording();
              }
            } else {
              final data = value[id];
              if (data != null) {
                data["channel"] = channel;
              }
            }
            print("Joined the channel: $uid, $channel");
            notifyListeners();
            _connectingCompleter?.complete();
            _connectingCompleter = null;
          },
          remoteVideoStateChanged: (uid, state, reason, elapsed) {
            final id = uid.toString();
            if (!value.containsKey(id)) {
              return;
            }
            final data = value.get<DynamicMap?>(id, null);
            if (data == null) {
              return;
            }
            data["video"] = !(state == VideoRemoteState.Stopped ||
                state == VideoRemoteState.Failed ||
                state == VideoRemoteState.Frozen);
            notifyListeners();
          },
          userJoined: (uid, elapsed) {
            final id = uid.toString();
            if (value.containsKey(id)) {
              return;
            }
            final data = <String, dynamic>{
              Const.uid: uid,
              "local": false,
            };
            value[id] = _filter?.call(data) ?? data;
            print("The user has joined: $uid");
            notifyListeners();
          },
          userOffline: (uid, reason) {
            final id = uid.toString();
            if (!value.containsKey(id)) {
              return;
            }
            value.remove(id);
            print("The user has left: $uid");
            notifyListeners();
          },
          leaveChannel: (stats) {
            print("Left the channel.");
            _disconnectingCompleter?.complete();
            _disconnectingCompleter = null;
            dispose();
          },
          firstRemoteVideoFrame: (
            uid,
            width,
            height,
            elapsed,
          ) {
            print("First remote video received: $uid, ($width x $height)");
          },
        ),
      );
      if (enableAudio) {
        await core._engine.enableAudio().timeout(timeout);
      } else {
        await core._engine.disableAudio().timeout(timeout);
      }
      if (enableVideo) {
        await core._engine.enableVideo().timeout(timeout);
      } else {
        await core._engine.disableVideo().timeout(timeout);
      }
      final videoConfig = VideoEncoderConfiguration();
      videoConfig.orientationMode = orientationMode;
      videoConfig.dimensions = VideoDimensions(width: width, height: height);
      videoConfig.frameRate = frameRate;
      videoConfig.bitrate = bitRate;
      await core._engine
          .setVideoEncoderConfiguration(videoConfig)
          .timeout(timeout);
      await core._engine.enableDualStreamMode(true).timeout(timeout);
      await core._engine
          .setRemoteDefaultVideoStreamType(VideoStreamType.High)
          .timeout(timeout);
      await core._engine
          .setCameraCapturerConfiguration(
            CameraCapturerConfiguration(
              preference: CameraCaptureOutputPreference.Performance,
              cameraDirection: CameraDirection.Rear,
            ),
          )
          .timeout(timeout);
      await core._engine.setChannelProfile(channelProfile).timeout(timeout);
      if (channelProfile == ChannelProfile.LiveBroadcasting) {
        await core._engine.setClientRole(clientRole).timeout(timeout);
      }
      _token = token;
      core._engine
          .joinChannelWithUserAccount(
            token,
            channelName,
            core.name,
          )
          .timeout(timeout);
      await _connectingCompleter?.future;
      _connectingCompleter?.complete();
      _connectingCompleter = null;
    } catch (e) {
      _token = null;
      _connectingCompleter?.completeError(e);
      _connectingCompleter = null;
      rethrow;
    } finally {
      _connectingCompleter?.complete();
      _connectingCompleter = null;
    }
  }

  Future<String> _getToken(String channelName) async {
    if (AgoraRTCCore.instance._tokenServerPath.isEmpty) {
      return "";
    }
    final functions = readProvider(
      functionsDocumentProvider(AgoraRTCCore.instance._tokenServerPath),
    );
    final res = await functions.call(
      parameters: {
        "role": clientRole == ClientRole.Audience ? "subscriber" : "publisher",
        "name": channelName,
      },
    );
    if (res.isEmpty) {
      throw Exception("Response is invalid.");
    }
    final token = res.get("token", "");
    if (token.isEmpty) {
      throw Exception("Response is invalid.");
    }
    return token;
  }

  /// Close the connection.
  @override
  Future<void> disconnect() async {
    if (_disconnectingCompleter != null) {
      return disconnecting;
    }
    _disconnectingCompleter = Completer<void>();
    try {
      if (!AgoraRTCCore.isInitialized) {
        throw Exception(
          "The engine is not initialized. Initialize the engine first.",
        );
      }
      final core = AgoraRTCCore.instance;
      core._engine.leaveChannel();
      await _disconnectingCompleter?.future;
      _token = null;
      _connected = false;
      _disconnectingCompleter?.complete();
      _disconnectingCompleter = null;
    } catch (e) {
      _disconnectingCompleter?.completeError(e);
      _disconnectingCompleter = null;
      rethrow;
    } finally {
      _disconnectingCompleter?.complete();
      _disconnectingCompleter = null;
    }
  }

  /// Start taking screenshots.
  @override
  Future<void> startScreenCapture() async {
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    if (core.customerId.isEmpty || core._customerSecret.isEmpty) {
      throw Exception(
        "Either it has not been initialized or the Customer ID and Customer Secret have not been set.",
      );
    }
    if (_token.isEmpty) {
      throw Exception("Token does not exist. Please run [connect] first.");
    }
    final channelName = path.replaceAll(RegExp(r"[^0-9a-zA-Z]"), "");
    __recordingCaptureId = null;
    final credential = base64Encode(
      utf8.encode(core.customerId! + ":" + core._customerSecret!),
    );
    final res = await Api.post(
      "$_agoraURL/${core.appId}/cloud_recording/acquire",
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "Authorization": "Basic $credential",
      },
      body: jsonEncode(
        {
          "cname": channelName,
          "uid": _recordingCaptureId,
          "clientRequest": {"resourceExpiredHour": 1},
        },
      ),
    );
    if (res.statusCode == 200) {
      final map = jsonDecodeAsMap(res.body);
      if (map.containsKey("resourceId")) {
        final result = await Api.post(
          "$_agoraURL/${core.appId}/cloud_recording/resourceid/${map.get("resourceId", "")}/mode/individual/start",
          headers: {
            "Content-Type": "application/json;charset=utf-8",
            "Authorization": "Basic $credential",
          },
          body: jsonEncode(
            {
              "cname": channelName,
              "uid": _recordingCaptureId,
              "clientRequest": {
                "token": _token,
                "recordingConfig": {
                  "maxIdleTime": 30,
                  "streamTypes": 2,
                  "channelType": 1,
                  "subscribeUidGroup": 0
                },
                "snapshotConfig": {
                  "captureInterval": 30,
                  "fileType": ["jpg"]
                },
                "storageConfig": {
                  "accessKey": core._storageBucketConfig?.accessKey,
                  "region": core._storageBucketConfig?.region.index ?? 0,
                  "bucket": core._storageBucketConfig?.bucketName,
                  "secretKey": core._storageBucketConfig?.secretKey,
                  "vendor": core._storageBucketConfig?.vendor.index ?? 6,
                  "fileNamePrefix": core._storageBucketConfig == null ||
                          core._storageBucketConfig!.path.isEmpty
                      ? []
                      : core._storageBucketConfig?.path.split("/")
                }
              },
            },
          ),
        );
        if (result.statusCode == 200) {
          final resultMap = jsonDecodeAsMap(result.body);
          if (resultMap.containsKey("sid")) {
            _sidCapture = resultMap.get("sid", "");
            _resourceCaptureId = map.get("resourceId", "");
            print("Start capturing: $_sidCapture / $_resourceCaptureId");
          } else {
            throw Exception("The capture could not be started.");
          }
        } else {
          throw Exception(result.body);
        }
      } else {
        throw Exception("The response is invalid.");
      }
    } else {
      throw Exception(res.body);
    }
  }

  /// Stop taking screen shots.
  @override
  Future<void> stopScreenCapture() async {
    if (_sidCapture.isEmpty || _resourceCaptureId.isEmpty) {
      return;
    }
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    final channelName = path.replaceAll(RegExp(r"[^0-9a-zA-Z]"), "");
    final credential = base64Encode(
      utf8.encode(core.customerId! + ":" + core._customerSecret!),
    );
    await Api.post(
      "$_agoraURL/${core.appId}/cloud_recording/resourceid/$_resourceCaptureId/sid/$_sidCapture/mode/individual/stop",
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "Authorization": "Basic $credential",
      },
      body: jsonEncode(
        {"cname": channelName, "uid": _recordingCaptureId, "clientRequest": {}},
      ),
    );
    _sidCapture = null;
    _resourceCaptureId = null;
  }

  /// Start taking screenshots.
  @override
  Future<void> startRecording() async {
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    if (core.customerId.isEmpty || core._customerSecret.isEmpty) {
      throw Exception(
        "Either it has not been initialized or the Customer ID and Customer Secret have not been set.",
      );
    }
    if (_token.isEmpty) {
      throw Exception("Token does not exist. Please run [connect] first.");
    }
    final channelName = path.replaceAll(RegExp(r"[^0-9a-zA-Z]"), "");
    __recordingVideoId = null;
    final credential = base64Encode(
      utf8.encode(core.customerId! + ":" + core._customerSecret!),
    );
    final res = await Api.post(
      "$_agoraURL/${core.appId}/cloud_recording/acquire",
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "Authorization": "Basic $credential",
      },
      body: jsonEncode(
        {
          "cname": channelName,
          "uid": _recordingVideoId,
          "clientRequest": {"resourceExpiredHour": 1},
        },
      ),
    );
    if (res.statusCode == 200) {
      final map = jsonDecodeAsMap(res.body);
      if (map.containsKey("resourceId")) {
        final result = await Api.post(
          "$_agoraURL/${core.appId}/cloud_recording/resourceid/${map.get("resourceId", "")}/mode/mix/start",
          headers: {
            "Content-Type": "application/json;charset=utf-8",
            "Authorization": "Basic $credential",
          },
          body: jsonEncode(
            {
              "cname": channelName,
              "uid": _recordingVideoId,
              "clientRequest": {
                "token": _token,
                "recordingConfig": {
                  "maxIdleTime": 30,
                  "streamTypes": 2,
                  "audioProfile": 1,
                  "channelType": 1,
                  "transcodingConfig": {
                    "height": 720,
                    "width": 1280,
                    "bitrate": 2000,
                    "fps": 24,
                    "mixedVideoLayout": 1,
                    "backgroundColor": "#000000"
                  },
                },
                "storageConfig": {
                  "accessKey": core._storageBucketConfig?.accessKey,
                  "region": core._storageBucketConfig?.region.index ?? 0,
                  "bucket": core._storageBucketConfig?.bucketName,
                  "secretKey": core._storageBucketConfig?.secretKey,
                  "vendor": core._storageBucketConfig?.vendor.index ?? 6,
                  "fileNamePrefix": core._storageBucketConfig == null ||
                          core._storageBucketConfig!.path.isEmpty
                      ? []
                      : core._storageBucketConfig?.path.split("/")
                }
              },
            },
          ),
        );
        if (result.statusCode == 200) {
          final resultMap = jsonDecodeAsMap(result.body);
          if (resultMap.containsKey("sid")) {
            _sidVideo = resultMap.get("sid", "");
            _resourceVideoId = resultMap.get("resourceId", "");
            print("Start recording: $_sidCapture / $_resourceVideoId");
            if (core._storageBucketConfig?.enableDebug ?? false) {
              _debugRecording();
            }
          } else {
            throw Exception("The capture could not be started.");
          }
        } else {
          throw Exception(result.body);
        }
      } else {
        throw Exception("The response is invalid.");
      }
    } else {
      throw Exception(res.body);
    }
  }

  /// Stop taking screen shots.
  @override
  Future<void> stopRecording() async {
    if (_sidCapture.isEmpty || _resourceVideoId.isEmpty) {
      return;
    }
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    final credential = base64Encode(
      utf8.encode(core.customerId! + ":" + core._customerSecret!),
    );
    await Api.post(
      "$_agoraURL/${core.appId}/cloud_recording/resourceid/$_resourceVideoId/sid/$_sidVideo/mode/mix/stop",
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "Authorization": "Basic $credential",
      },
      body: jsonEncode(
        {
          "cname": path.replaceAll(RegExp(r"[^0-9a-zA-Z]"), ""),
          "uid": _recordingVideoId,
          "clientRequest": {}
        },
      ),
    );
    _sidCapture = null;
    _resourceVideoId = null;
  }

  Future<void> _debugRecording() async {
    final core = AgoraRTCCore.instance;
    final credential = base64Encode(
      utf8.encode(core.customerId! + ":" + core._customerSecret!),
    );
    await Future.delayed(const Duration(seconds: 5));
    while (_resourceVideoId != null && _sidVideo != null) {
      final result = await Api.get(
        "$_agoraURL/${core.appId}/cloud_recording/resourceid/$_resourceVideoId/sid/$_sidVideo/mode/mix/query",
        headers: {
          "Content-Type": "application/json;charset=utf-8",
          "Authorization": "Basic $credential",
        },
      );
      print(result.body);
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  /// Start recording audio.
  ///
  /// [filePath]: Path to save the recording.
  /// [sampleRate]: Sample rate to be recorded.
  /// [quality]: Quality to record.
  @override
  Future<void> startAudioRecording(
    String filePath, {
    int sampleRate = 44100,
    StreamingAudioRecordingQuality quality =
        StreamingAudioRecordingQuality.Medium,
  }) async {
    if (_isRecordingAudio) {
      return;
    }
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    _isRecordingAudio = true;
    await core._engine.startAudioRecordingWithConfig(
      AudioRecordingConfiguration(
        filePath,
        recordingQuality: AudioRecordingQuality.values
            .firstWhereOrNull((e) => e.index == quality.index),
        recordingSampleRate: _changeSampleRate(sampleRate),
      ),
    );
    notifyListeners();
  }

  AudioSampleRateType _changeSampleRate(int sampleRate) {
    if (sampleRate >= 48000) {
      return AudioSampleRateType.Type48000;
    } else if (sampleRate >= 44100) {
      return AudioSampleRateType.Type44100;
    } else {
      return AudioSampleRateType.Type32000;
    }
  }

  /// Stop Recording.
  @override
  Future<void> stopAudioRecording() async {
    if (!_isRecordingAudio) {
      return;
    }
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    _isRecordingAudio = false;
    await core._engine.stopAudioRecording();
    notifyListeners();
  }

  /// URL for screen captures.
  @override
  String get screenCaptureURL {
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    final vendor = core._storageBucketConfig?.vendor;
    switch (vendor) {
      case AgoraStorageVendor.googleCloud:
        return "https://storage.googleapis.com/${core._storageBucketConfig?.bucketName}/${path.replaceAll(RegExp(r"[^0-9a-zA-Z]"), "")}.jpg";
      case AgoraStorageVendor.amazonWebService:
        final region = core._storageBucketConfig?.region
            .toString()
            .replaceAll("AWSRegion", "")
            .replaceAll("_", "-");
        return "https://${core._storageBucketConfig?.bucketName}.s3-$region.amazonaws.com/${path.replaceAll(RegExp(r"[^0-9a-zA-Z]"), "")}.jpg";
      default:
        throw Exception("This vendor has not been implemented.");
    }
  }

  /// URL for screen captures.
  @override
  String get recordURL {
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    final vendor = core._storageBucketConfig?.vendor;
    switch (vendor) {
      case AgoraStorageVendor.googleCloud:
        return "https://storage.googleapis.com/${core._storageBucketConfig?.bucketName}/${path.replaceAll(RegExp(r"[^0-9a-zA-Z]"), "")}.m3u8";
      case AgoraStorageVendor.amazonWebService:
        final region = core._storageBucketConfig?.region
            .toString()
            .replaceAll("AWSRegion", "")
            .replaceAll("_", "-");
        return "https://${core._storageBucketConfig?.bucketName}.s3-$region.amazonaws.com/${path.replaceAll(RegExp(r"[^0-9a-zA-Z]"), "")}.m3u8";
      default:
        throw Exception("This vendor has not been implemented.");
    }
  }

  @override
  Future<bool> checkActiveRecordURL() async {
    final res = await Api.get(recordURL);
    if (res.statusCode != 200) {
      return false;
    }
    return res.body.contains(".ts");
  }

  String get _recordingCaptureId {
    if (__recordingCaptureId.isNotEmpty) {
      return __recordingCaptureId!;
    }
    int id = 0;
    do {
      id = Random().nextInt(100000);
    } while (value.containsKey(id.toString()));
    return __recordingCaptureId = id.toString();
  }

  String get _recordingVideoId {
    if (__recordingVideoId.isNotEmpty) {
      return __recordingVideoId!;
    }
    int id = 0;
    do {
      id = Random().nextInt(100000);
    } while (value.containsKey(id.toString()));
    return __recordingVideoId = id.toString();
  }

  /// Own user id.
  // String? get localId {
  //   final doc =
  //       value.values.firstWhereOrNull((item) => item.get("local", false));
  //   return doc?.get<int?>(Const.uid, null)?.toString();
  // }

  /// Gets the current local screen as a widget.
  @override
  Widget localScreen() {
    return const rtc_local_view.SurfaceView();
  }

  /// Get all screens as widgets, including remote locals.
  @override
  List<Widget> allScreens() {
    return value.toList<Widget?>((key, value) {
      final uid = value.get<int?>(Const.uid, null);
      final channel = value.get("channel", nullOfString);
      if (uid == null || channel == null) {
        return null;
      }
      if (!value.get("video", true)) {
        return Container(
          color: Colors.black,
          alignment: Alignment.center,
          child: const Icon(Icons.videocam_off, color: Colors.grey, size: 48),
        );
      }
      if (localUID == uid) {
        if (channelProfile == ChannelProfile.LiveBroadcasting &&
            clientRole == ClientRole.Audience) {
          return null;
        }
        return const rtc_local_view.SurfaceView();
      }
      return rtc_remote_view.SurfaceView(
        uid: uid,
        channelId: channel,
      );
    }).removeEmpty();
  }

  /// Set the screen
  @override
  Future<void> setScreen(
    int width,
    int height, {
    int? frameRate,
    int? bitRate,
  }) async {
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    _width = width;
    _height = height;
    _frameRate = frameRate != null ? _changeFrameRate(frameRate) : _frameRate;
    _bitRate = bitRate ?? _bitRate;
    final videoConfig = VideoEncoderConfiguration();
    videoConfig.orientationMode = orientationMode;
    videoConfig.dimensions = VideoDimensions(width: width, height: height);
    videoConfig.frameRate = this.frameRate;
    videoConfig.bitrate = this.bitRate;
    await core._engine.setVideoEncoderConfiguration(videoConfig);
  }

  /// True to enable audio.
  ///
  /// [enableAudio]: True to enable audio.
  @override
  set enableAudio(bool enableAudio) {
    if (_enableAudio == enableAudio) {
      return;
    }
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    _enableAudio = enableAudio;
    if (_enableAudio) {
      core._engine.enableAudio();
    } else {
      core._engine.disableAudio();
    }
    notifyListeners();
  }

  /// True to enable video.
  ///
  /// [enableVideo]: True to enable video.
  @override
  set enableVideo(bool enableVideo) {
    if (_enableVideo == enableVideo) {
      return;
    }
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    _enableVideo = enableVideo;
    if (_enableVideo) {
      core._engine.enableVideo();
    } else {
      core._engine.disableVideo();
    }
    notifyListeners();
  }

  /// True to mute the call.
  ///
  /// [mute]: True to mute the call.
  @override
  set mute(bool mute) {
    if (mute == _mute) {
      return;
    }
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    _mute = mute;
    core._engine.muteAllRemoteAudioStreams(_mute);
    notifyListeners();
  }

  /// Switches the camera in / out.
  @override
  void switchCamera() {
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    final core = AgoraRTCCore.instance;
    core._engine.switchCamera();
    notifyListeners();
  }

  /// Destroys the object.
  ///
  /// Destroyed objects are not allowed.
  @override
  void dispose() {
    super.dispose();
    if (!AgoraRTCCore.isInitialized) {
      throw Exception(
        "The engine is not initialized. Initialize the engine first.",
      );
    }
    if (connected) {
      _token = null;
      _connected = false;
      stopScreenCapture();
      stopRecording();
      stopAudioRecording();
      AgoraRTCCore.instance._engine.leaveChannel();
    }
    AgoraRTCCore.instance._engine.setEventHandler(RtcEngineEventHandler());
  }

  /// Get the toolbar as a widget.
  ///
  /// [context]: BuildContext.
  /// [onDisconnect]: Callback on disconnect.
  Widget toolBar(BuildContext context, {VoidCallback? onDisconnect}) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () {
              mute = !mute;
            },
            child: Icon(
              mute ? Icons.mic_off : Icons.mic,
              color: mute ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: mute ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () {
              disconnect();
              onDisconnect?.call();
            },
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: switchCamera,
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }
}
