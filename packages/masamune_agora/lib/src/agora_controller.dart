part of masamune_agora;

class AgoraController
    extends MasamuneControllerBase<List<AgoraUser>, AgoraMasamuneAdapter> {
  AgoraController(
    this.channelName, {
    List<LoggerAdapter> loggerAdapters = const [],
  })  : _loggerAdapters = loggerAdapters,
        super(defaultValue: []);

  static const String _agoraURL = "https://api.agora.io/v1/apps";

  static RtcEngine? _engine;

  @override
  AgoraMasamuneAdapter get primaryAdapter => AgoraMasamuneAdapter.primary;

  /// Adapter to define loggers.
  ///
  /// ロガーを定義するアダプター。
  List<LoggerAdapter> get loggerAdapters {
    return [...LoggerAdapter.primary, ..._loggerAdapters];
  }

  final List<LoggerAdapter> _loggerAdapters;

  final String channelName;

  /// The name of the local account.
  String? localName;

  int? localUserNumber;

  final AgoraPermission permission = const AgoraPermission();

  /// The width of the screen to send to the remote.
  VideoDimensions get videoDimensions {
    switch (orientation) {
      case AgoraVideoOrientation.landscape:
        return _videoProfile.landscape;
      case AgoraVideoOrientation.portrait:
        return _videoProfile.portrait;
    }
  }

  /// The frame rate of the screen sent to the remote.
  VideoFrameRate get frameRate => _videoProfile.frameRate;

  /// The bit rate of the screen sent to the remote.
  int get bitRate => _videoProfile.bitrate(channelProfile);

  AgoraVideoProfile _videoProfile = AgoraVideoProfile.size640x360Rate15;

  /// Set the screen
  Future<void> setScreen({
    AgoraVideoProfile? videoProfile,
    AgoraVideoOrientation? orientation,
  }) async {
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    _videoProfile = videoProfile ?? _videoProfile;
    _orientation = orientation ?? _orientation;
    final videoConfig = VideoEncoderConfiguration();
    videoConfig.orientationMode = _orientation.toVideoOutputOrientationMode();
    videoConfig.dimensions = videoDimensions;
    videoConfig.frameRate = frameRate;
    videoConfig.bitrate = bitRate;
    await _engine?.setVideoEncoderConfiguration(videoConfig);
    notifyListeners();
  }

  /// True if the connection process is in progress.
  bool get connected => _connected;
  bool _connected = false;

  /// Returns itself after the connecting finishes.
  Future<void>? get connecting => _connectingCompleter?.future;
  Completer<void>? _connectingCompleter;

  /// Returns itself after the disconnecting finishes.
  Future<void>? get disconnecting => _disconnectingCompleter?.future;
  Completer<void>? _disconnectingCompleter;

  Completer<void>? _initializeCompleter;

  /// Orientation mode.
  AgoraVideoOrientation get orientation => _orientation;
  AgoraVideoOrientation _orientation = AgoraVideoOrientation.landscape;

  /// Channel profile settings.
  ChannelProfile get channelProfile => _channelProfile;
  ChannelProfile _channelProfile = ChannelProfile.Communication;

  /// Client role settings.
  ClientRole get clientRole => _clientRole;
  ClientRole _clientRole = ClientRole.Broadcaster;

  /// Switches the camera in / out.
  void switchCamera() {
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    _engine?.switchCamera();
    _cameraDirection = _cameraDirection == CameraDirection.Rear
        ? CameraDirection.Front
        : CameraDirection.Rear;
    notifyListeners();
  }

  CameraDirection get cameraDirection => _cameraDirection;
  CameraDirection _cameraDirection = CameraDirection.Rear;

  /// True to enable audio.
  bool get enableAudio => _enableAudio;

  set enableAudio(bool enableAudio) {
    if (_enableAudio == enableAudio) {
      return;
    }
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    _enableAudio = enableAudio;
    if (_enableAudio) {
      _engine?.enableAudio();
    } else {
      _engine?.disableAudio();
    }
    notifyListeners();
  }

  bool _enableAudio = true;

  /// True to enable video.
  bool get enableVideo => _enableVideo;

  /// True to enable video.
  ///
  /// [enableVideo]: True to enable video.
  set enableVideo(bool enableVideo) {
    if (_enableVideo == enableVideo) {
      return;
    }
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    _enableVideo = enableVideo;
    if (_enableVideo) {
      _engine?.enableVideo();
    } else {
      _engine?.disableVideo();
    }
    notifyListeners();
  }

  bool _enableVideo = true;

  /// True to mute the call.
  bool get mute => _mute;

  /// True to mute the call.
  ///
  /// [mute]: True to mute the call.
  set mute(bool mute) {
    if (mute == _mute) {
      return;
    }
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    _mute = mute;
    _engine?.muteAllRemoteAudioStreams(_mute);
    notifyListeners();
  }

  bool _mute = false;

  String? _token;
  bool _disposed = false;

  bool get capturing =>
      __recordingCaptureId != null &&
      _sidCapture.isNotEmpty &&
      _recordingCaptureId.isNotEmpty;

  int get _recordingCaptureId {
    if (__recordingCaptureId.isNotEmpty) {
      return __recordingCaptureId!;
    }
    int number = 0;
    do {
      number = Random().nextInt(100000);
    } while (
        value!.any((e) => e.number == number) || number == __recordingVideoId);
    return __recordingCaptureId = number;
  }

  int? __recordingCaptureId;
  String? _sidCapture;
  String? _resourceCaptureId;

  bool get recordingVideo =>
      __recordingVideoId != null &&
      _sidVideo.isNotEmpty &&
      _resourceVideoId.isNotEmpty;

  int get _recordingVideoId {
    if (__recordingVideoId.isNotEmpty) {
      return __recordingVideoId!;
    }
    int number = 0;
    do {
      number = Random().nextInt(100000);
    } while (value!.any((e) => e.number == number) ||
        number == __recordingCaptureId);
    return __recordingVideoId = number;
  }

  int? __recordingVideoId;
  String? _sidVideo;
  String? _resourceVideoId;

  /// Returns itself after the disconnecting finishes.
  Future<void>? get recordingAudio => _recordingAudio?.future;
  Completer<void>? _recordingAudio;

  Future<void> _initialize({required String userName}) async {
    if (_initializeCompleter != null) {
      return _initializeCompleter!.future;
    }
    if (_engine != null) {
      return;
    }
    try {
      _initializeCompleter = Completer();
      _engine = await RtcEngine.create(primaryAdapter.appId);
      _engine?.setEventHandler(
        RtcEngineEventHandler(
          localUserRegistered: (uid, name) {
            localName = name;
            localUserNumber = uid;
          },
        ),
      );
      await _engine?.registerLocalUserAccount(primaryAdapter.appId, userName);
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    } catch (e) {
      _initializeCompleter?.completeError(e);
      _initializeCompleter = null;
      rethrow;
    } finally {
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    }
  }

  /// Destroys the object.
  ///
  /// Destroyed objects are not allowed.
  @override
  void dispose() {
    super.dispose();
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    if (connected) {
      _disposed = true;
      _token = null;
      _connected = false;
      value?.clear();
      stopScreenCapture();
      stopRecording();
      stopAudioRecording();
      _engine?.leaveChannel();
      _sendLog(AgoraLoggerEvent.leave);
    }
    _engine?.setEventHandler(RtcEngineEventHandler());
  }

  Future<void> connect({
    required String userName,
    AgoraVideoProfile videoProfile = AgoraVideoProfile.size640x360Rate15,
    CameraDirection cameraDirection = CameraDirection.Rear,
    bool enableAudio = true,
    bool enableVideo = true,
    bool? enableRecordingOnConnect,
    bool? enableScreenCaptureOnConnect,
    ChannelProfile channelProfile = ChannelProfile.LiveBroadcasting,
    ClientRole clientRole = ClientRole.Broadcaster,
    AgoraVideoOrientation orientation = AgoraVideoOrientation.landscape,
  }) async {
    _videoProfile = videoProfile;
    _orientation = orientation;
    _enableAudio = enableAudio;
    _enableVideo = enableVideo;
    _channelProfile = channelProfile;
    _clientRole = clientRole;
    _cameraDirection = cameraDirection;
    await _joinRoom(
      userName: userName,
      enableRecordingOnConnect: enableRecordingOnConnect,
      enableScreenCaptureOnConnect: enableScreenCaptureOnConnect,
    );
  }

  Future<void> _joinRoom({
    required String userName,
    bool? enableRecordingOnConnect,
    bool? enableScreenCaptureOnConnect,
  }) async {
    if (_connectingCompleter != null) {
      return connecting;
    }
    if (_disconnectingCompleter != null || connected) {
      throw Exception(
        "Already connected. Please disconnect with [disconnect].",
      );
    }
    if (!await permission.request(
        enableAudio: _enableAudio, enableVideo: _enableVideo)) {
      throw Exception(
        "Permission not granted.",
      );
    }
    _connectingCompleter = Completer<void>();
    try {
      _connected = true;
      await _initialize(userName: userName);
      _token = await adapter.functionsAdapter.getAgoraToken(
        channelName: channelName,
        clientRole: AgoraClientRole.values
                .firstWhereOrNull((item) => item.index == clientRole.index) ??
            AgoraClientRole.audience,
      );
      _token =
          "007eJxTYJhz/5BbYZhQrnXAdwbGHxZxTD2WD+12W/N8rg4tcPkflq7AYJiUZGCcZmJoYW5sbGJpnmhpbplkBARmqUlGaWaJaYdb7VIaAhkZpm3hZmVkgEAQn4PBJbUsNSe/oISBAQAkTh7P";
      _engine?.setEventHandler(
        RtcEngineEventHandler(
          error: (err) {
            debugPrint(err.toString());
            _connectingCompleter?.completeError(err);
            _connectingCompleter = null;
            _disconnectingCompleter?.completeError(err);
            _disconnectingCompleter = null;
          },
          userInfoUpdated: (number, info) {
            final data = value?.firstWhereOrNull((e) => e.number == number);
            if (data == null) {
              return;
            }
            if (data.name != info.userAccount) {
              data._setName(info.userAccount);
              _sendLog(AgoraLoggerEvent.updateUserInformation, parameters: {
                AgoraLoggerEvent.userNumberKey: number,
                AgoraLoggerEvent.userNameKey: info.userAccount,
              });
            }
          },
          joinChannelSuccess: (channel, number, elapsed) async {
            try {
              final data = value?.firstWhereOrNull((e) => e.number == number);
              if (data == null) {
                value?.add(AgoraUser._(
                  controller: this,
                  number: number,
                  isLocalUser: true,
                  channel: channel,
                  status: VideoRemoteState.Starting,
                ));
                if ((enableScreenCaptureOnConnect ??
                        adapter.enableScreenCaptureByDefault) &&
                    channelProfile == ChannelProfile.LiveBroadcasting &&
                    clientRole == ClientRole.Broadcaster) {
                  await startScreenCapture();
                }
                if ((enableRecordingOnConnect ??
                        adapter.enableRecordingByDefault) &&
                    channelProfile == ChannelProfile.LiveBroadcasting &&
                    clientRole == ClientRole.Broadcaster) {
                  await startRecording();
                }
              } else {
                if (data.channel != channel) {
                  data._setChannel(channel);
                }
              }
              _sendLog(AgoraLoggerEvent.join, parameters: {
                AgoraLoggerEvent.userNumberKey: number,
                AgoraLoggerEvent.channelKey: channel,
                AgoraLoggerEvent.isLocalUserKey: true,
              });
              notifyListeners();
              _connectingCompleter?.complete();
              _connectingCompleter = null;
            } catch (e) {
              debugPrint(e.toString());
              _connectingCompleter?.completeError(e);
              _connectingCompleter = null;
              rethrow;
            }
          },
          remoteVideoStateChanged: (number, state, reason, elapsed) {
            final data = value?.firstWhereOrNull((e) => e.number == number);
            if (data == null) {
              return;
            }
            data._setStatus(state);
          },
          userJoined: (number, elapsed) {
            final data = value?.firstWhereOrNull((e) => e.number == number);
            if (data != null) {
              return;
            }
            value?.add(AgoraUser._(
              controller: this,
              number: number,
              channel: channelName,
              status: VideoRemoteState.Starting,
              isLocalUser: false,
            ));
            _sendLog(AgoraLoggerEvent.join, parameters: {
              AgoraLoggerEvent.userNumberKey: number,
              AgoraLoggerEvent.isLocalUserKey: false,
            });
            notifyListeners();
          },
          userOffline: (number, reason) {
            final data = value?.firstWhereOrNull((e) => e.number == number);
            if (data == null) {
              return;
            }
            value?.remove(data);
            _sendLog(AgoraLoggerEvent.leave, parameters: {
              AgoraLoggerEvent.userNumberKey: number,
              AgoraLoggerEvent.isLocalUserKey: false,
            });
            notifyListeners();
          },
          leaveChannel: (stats) {
            value?.clear();
            _sendLog(AgoraLoggerEvent.leave, parameters: {
              AgoraLoggerEvent.userNumberKey: localUserNumber,
              AgoraLoggerEvent.isLocalUserKey: true,
            });
            _disconnectingCompleter?.complete();
            _disconnectingCompleter = null;
          },
          firstRemoteVideoFrame: (
            number,
            width,
            height,
            elapsed,
          ) {
            _sendLog(AgoraLoggerEvent.firstRemoteVideoReceived, parameters: {
              AgoraLoggerEvent.userNumberKey: number,
              AgoraLoggerEvent.widthKey: width,
              AgoraLoggerEvent.heightKey: height,
            });
          },
        ),
      );
      if (enableAudio) {
        await _engine?.enableAudio();
      } else {
        await _engine?.disableAudio();
      }
      if (enableVideo) {
        await _engine?.enableVideo();
      } else {
        await _engine?.disableVideo();
      }
      final videoConfig = VideoEncoderConfiguration();
      videoConfig.orientationMode = orientation.toVideoOutputOrientationMode();
      videoConfig.dimensions = videoDimensions;
      videoConfig.frameRate = frameRate;
      videoConfig.bitrate = bitRate;
      await _engine?.setVideoEncoderConfiguration(videoConfig);
      await _engine?.enableDualStreamMode(true);
      await _engine?.setRemoteDefaultVideoStreamType(VideoStreamType.High);
      await _engine?.setCameraCapturerConfiguration(
        CameraCapturerConfiguration(
          preference: CameraCaptureOutputPreference.Performance,
          cameraDirection: cameraDirection,
        ),
      );
      await _engine?.setChannelProfile(channelProfile);
      if (channelProfile == ChannelProfile.LiveBroadcasting) {
        await _engine?.setClientRole(clientRole);
      }
      _engine?.joinChannelWithUserAccount(
        _token,
        channelName,
        userName,
      );
      await _connectingCompleter?.future;
      _connectingCompleter?.complete();
      _connectingCompleter = null;
      _connected = true;
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

  /// Close the connection.
  Future<void> disconnect() async {
    if (_disconnectingCompleter != null) {
      return disconnecting;
    }
    if (_connectingCompleter != null || !connected) {
      return;
    }
    _disconnectingCompleter = Completer<void>();
    try {
      if (_engine == null) {
        throw Exception(
          "The engine is not initialized. [connect] the engine first.",
        );
      }
      _engine?.leaveChannel();
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
  Future<void> startScreenCapture() async {
    if (capturing) {
      throw Exception("Already started taking screen capture.");
    }
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    if (adapter.customerId.isEmpty || adapter.customerSecret.isEmpty) {
      throw Exception(
        "The Customer ID and Customer Secret have not been set.",
      );
    }
    if (_token.isEmpty) {
      throw Exception("Token does not exist. Please run [connect] first.");
    }
    final credential = base64Encode(
      utf8.encode("${adapter.customerId}:${adapter.customerSecret}"),
    );
    final res = await Api.post(
      "$_agoraURL/${adapter.appId}/cloud_recording/acquire",
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "Authorization": "Basic $credential",
      },
      body: jsonEncode(
        {
          "cname": channelName,
          "uid": _recordingCaptureId.toString(),
          "clientRequest": {"resourceExpiredHour": 1},
        },
      ),
    );
    if (res.statusCode == 200) {
      final map = jsonDecodeAsMap(res.body);
      if (map.containsKey("resourceId")) {
        final result = await Api.post(
          "$_agoraURL/${adapter.appId}/cloud_recording/resourceid/${map.get("resourceId", "")}/mode/individual/start",
          headers: {
            "Content-Type": "application/json;charset=utf-8",
            "Authorization": "Basic $credential",
          },
          body: jsonEncode(
            {
              "cname": channelName,
              "uid": _recordingCaptureId.toString(),
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
                  "accessKey": adapter.storageBucketConfig?.accessKey,
                  "region": 0,
                  "bucket": adapter.storageBucketConfig?.bucketName,
                  "secretKey": adapter.storageBucketConfig?.secretKey,
                  "vendor": adapter.storageBucketConfig?.vendor.index ??
                      AgoraStorageVendor.googleCloud.index,
                  "fileNamePrefix": adapter.storageBucketConfig == null ||
                          adapter.storageBucketConfig!.rootPath.isEmpty
                      ? []
                      : adapter.storageBucketConfig?.rootPath.split("/")
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
            _sendLog(AgoraLoggerEvent.startScreenCapture, parameters: {
              AgoraLoggerEvent.captureSid: _sidCapture,
              AgoraLoggerEvent.captureResourceId: _resourceCaptureId,
            });
            notifyListeners();
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
  Future<void> stopScreenCapture() async {
    if (!capturing) {
      return;
    }
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    final credential = base64Encode(
      utf8.encode("${adapter.customerId}:${adapter.customerSecret}"),
    );
    await Api.post(
      "$_agoraURL/${adapter.appId}/cloud_recording/resourceid/$_resourceCaptureId/sid/$_sidCapture/mode/individual/stop",
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "Authorization": "Basic $credential",
      },
      body: jsonEncode(
        {
          "cname": channelName,
          "uid": _recordingCaptureId.toString(),
          "clientRequest": {},
        },
      ),
    );
    _sendLog(AgoraLoggerEvent.stopScreenCapture, parameters: {
      AgoraLoggerEvent.captureSid: _sidCapture,
      AgoraLoggerEvent.captureResourceId: _resourceCaptureId,
    });
    _sidCapture = null;
    _resourceCaptureId = null;
    if (!_disposed) {
      notifyListeners();
    }
  }

  /// URL for screen captures.
  String get screenCaptureURL {
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    final vendor = adapter.storageBucketConfig?.vendor;
    switch (vendor) {
      case AgoraStorageVendor.googleCloud:
        return "https://storage.googleapis.com/${adapter.storageBucketConfig?.bucketName}/$channelName.jpg";
      default:
        throw Exception("This vendor has not been implemented.");
    }
  }

  /// Start taking screenshots.
  Future<void> startRecording() async {
    if (recordingVideo) {
      throw Exception("Already started recording video.");
    }
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    if (adapter.customerId.isEmpty || adapter.customerSecret.isEmpty) {
      throw Exception(
        "The Customer ID and Customer Secret have not been set.",
      );
    }
    if (_token.isEmpty) {
      throw Exception("Token does not exist. Please run [connect] first.");
    }
    final credential = base64Encode(
      utf8.encode("${adapter.customerId}:${adapter.customerSecret}"),
    );
    final res = await Api.post(
      "$_agoraURL/${adapter.appId}/cloud_recording/acquire",
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "Authorization": "Basic $credential",
      },
      body: jsonEncode(
        {
          "cname": channelName,
          "uid": _recordingVideoId.toString(),
          "clientRequest": {"resourceExpiredHour": 1},
        },
      ),
    );
    if (res.statusCode == 200) {
      final map = jsonDecodeAsMap(res.body);
      if (map.containsKey("resourceId")) {
        final result = await Api.post(
          "$_agoraURL/${adapter.appId}/cloud_recording/resourceid/${map.get("resourceId", "")}/mode/mix/start",
          headers: {
            "Content-Type": "application/json;charset=utf-8",
            "Authorization": "Basic $credential",
          },
          body: jsonEncode(
            {
              "cname": channelName,
              "uid": _recordingVideoId.toString(),
              "clientRequest": {
                "token": _token,
                "recordingConfig": {
                  "maxIdleTime": 30,
                  "streamTypes": 2,
                  "audioProfile": 1,
                  "channelType": 1,
                  "transcodingConfig": {
                    "height": videoDimensions.height,
                    "width": videoDimensions.width,
                    "bitrate": bitRate,
                    "fps": frameRate.toInt(),
                    "mixedVideoLayout": 1,
                    "backgroundColor": "#000000"
                  },
                },
                "storageConfig": {
                  "accessKey": adapter.storageBucketConfig?.accessKey,
                  "region": 0,
                  "bucket": adapter.storageBucketConfig?.bucketName,
                  "secretKey": adapter.storageBucketConfig?.secretKey,
                  "vendor": adapter.storageBucketConfig?.vendor.index ??
                      AgoraStorageVendor.googleCloud.index,
                  "fileNamePrefix": adapter.storageBucketConfig == null ||
                          adapter.storageBucketConfig!.rootPath.isEmpty
                      ? []
                      : adapter.storageBucketConfig?.rootPath.split("/")
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
            _sendLog(AgoraLoggerEvent.startRecording, parameters: {
              AgoraLoggerEvent.captureSid: _sidVideo,
              AgoraLoggerEvent.captureResourceId: _resourceVideoId,
            });
            if (adapter.storageBucketConfig?.enableDebug ?? false) {
              _debugRecording();
            }
            notifyListeners();
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
  Future<void> stopRecording() async {
    if (!recordingVideo) {
      return;
    }
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    final credential = base64Encode(
      utf8.encode("${adapter.customerId}:${adapter.customerSecret}"),
    );
    await Api.post(
      "$_agoraURL/${adapter.appId}/cloud_recording/resourceid/$_resourceVideoId/sid/$_sidVideo/mode/mix/stop",
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "Authorization": "Basic $credential",
      },
      body: jsonEncode(
        {
          "cname": channelName,
          "uid": _recordingVideoId.toString(),
          "clientRequest": {},
        },
      ),
    );
    _sendLog(AgoraLoggerEvent.stopRecording, parameters: {
      AgoraLoggerEvent.captureSid: _sidVideo,
      AgoraLoggerEvent.captureResourceId: _resourceVideoId,
    });
    _sidCapture = null;
    _resourceVideoId = null;
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> _debugRecording() async {
    final credential = base64Encode(
      utf8.encode("${adapter.customerId}:${adapter.customerSecret}"),
    );
    await Future.delayed(const Duration(seconds: 5));
    while (_resourceVideoId != null && _sidVideo != null) {
      final result = await Api.get(
        "$_agoraURL/${adapter.appId}/cloud_recording/resourceid/$_resourceVideoId/sid/$_sidVideo/mode/mix/query",
        headers: {
          "Content-Type": "application/json;charset=utf-8",
          "Authorization": "Basic $credential",
        },
      );
      _sendLog(AgoraLoggerEvent.startRecording, parameters: {
        AgoraLoggerEvent.captureSid: _sidVideo,
        AgoraLoggerEvent.captureResourceId: _resourceVideoId,
        AgoraLoggerEvent.recordingStatus: result.body,
      });
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  String get recordURL {
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    final vendor = adapter.storageBucketConfig?.vendor;
    switch (vendor) {
      case AgoraStorageVendor.googleCloud:
        return "https://storage.googleapis.com/${adapter.storageBucketConfig?.bucketName}/$channelName.m3u8";
      default:
        throw Exception("This vendor has not been implemented.");
    }
  }

  Future<bool> checkRecordURLIsActive() async {
    final res = await Api.get(recordURL);
    if (res.statusCode != 200) {
      return false;
    }
    return res.body.contains(".ts");
  }

  Future<void> startAudioRecording(
    String filePath, {
    AudioSampleRateType sampleRate = AudioSampleRateType.Type44100,
    AudioRecordingQuality quality = AudioRecordingQuality.Medium,
  }) async {
    if (_recordingAudio != null) {
      throw Exception(
        "Recording is already in progress. Please stop the recording first.",
      );
    }
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    _recordingAudio = Completer();
    try {
      await _engine?.startAudioRecordingWithConfig(
        AudioRecordingConfiguration(
          filePath,
          recordingQuality: quality,
          recordingSampleRate: sampleRate,
        ),
      );
      notifyListeners();
    } catch (e) {
      _recordingAudio?.completeError(e);
      _recordingAudio = null;
      rethrow;
    }
  }

  /// Stop Recording.
  Future<void> stopAudioRecording() async {
    if (_engine == null) {
      throw Exception(
        "The engine is not initialized. [connect] the engine first.",
      );
    }
    if (_recordingAudio == null) {
      return;
    }
    try {
      await _engine?.stopAudioRecording();
      if (!_disposed) {
        notifyListeners();
      }
      _recordingAudio?.complete();
      _recordingAudio = null;
    } catch (e) {
      _recordingAudio?.completeError(e);
      _recordingAudio = null;
      rethrow;
    }
  }

  void _sendLog(AgoraLoggerEvent event, {DynamicMap? parameters}) {
    for (final loggerAdapter in loggerAdapters) {
      loggerAdapter.send(event.toString(), parameters: parameters);
    }
  }
}
