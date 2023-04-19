part of masamune_agora;

/// Controller for connecting and disconnecting Agora.io, etc.
///
/// First give [channelName] to specify the channel.
///
/// [connect] to make a connection and [disconnect] to disconnect.
///
/// Agora.ioの接続や切断等を行うコントローラー。
///
/// 最初に[channelName]を与えてチャンネルを指定してください。
///
/// [connect]で接続を行い、[disconnect]で切断を行います。
class AgoraController
    extends MasamuneControllerBase<List<AgoraUser>, AgoraMasamuneAdapter> {
  /// Controller for connecting and disconnecting Agora.io, etc.
  ///
  /// First give [channelName] to specify the channel.
  ///
  /// [connect] to make a connection and [disconnect] to disconnect.
  ///
  /// Agora.ioの接続や切断等を行うコントローラー。
  ///
  /// 最初に[channelName]を与えてチャンネルを指定してください。
  ///
  /// [connect]で接続を行い、[disconnect]で切断を行います。
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

  /// Controller around authority.
  ///
  /// 権限周りのコントローラー。
  final AgoraPermission permission = const AgoraPermission();

  /// Name of the channel to connect.
  ///
  /// 接続するチャンネル名。
  final String channelName;

  /// User name for the connection.
  ///
  /// 接続した際のユーザー名。
  String? get localName => _localName;
  String? _localName;

  /// User number used by Agora.io when connecting.
  ///
  /// 接続した際のAgora.ioで利用されるユーザー番号。
  int? get localUserNumber => _localUserNumber;
  int? _localUserNumber;

  /// Screen size when connecting to a remote.
  ///
  /// This is determined by [AgoraVideoProfile]. If you want to change it, use [setScreen].
  ///
  /// リモートに接続する際の画面サイズ。
  ///
  /// [AgoraVideoProfile]によって決定されます。変更したい場合は[setScreen]を利用してください。
  VideoDimensions get videoDimensions {
    switch (orientation) {
      case AgoraVideoOrientation.landscape:
        return _videoProfile.landscape;
      case AgoraVideoOrientation.portrait:
        return _videoProfile.portrait;
    }
  }

  /// Screen frame rate when connecting to a remote.
  ///
  /// This is determined by [AgoraVideoProfile]. If you want to change it, use [setScreen].
  ///
  /// リモートに接続する際の画面フレームレート。
  ///
  /// [AgoraVideoProfile]によって決定されます。変更したい場合は[setScreen]を利用してください。
  VideoFrameRate get frameRate => _videoProfile.frameRate;

  /// Communication bit rate when connecting to a remote.
  ///
  /// This is determined by [AgoraVideoProfile]. If you want to change it, use [setScreen].
  ///
  /// リモートに接続する際の通信ビットレート。
  ///
  /// [AgoraVideoProfile]によって決定されます。変更したい場合は[setScreen]を利用してください。
  int get bitRate => _videoProfile.bitrate(channelProfile);

  /// Specifies the orientation of the screen for shooting.
  ///
  /// 撮影する画面の向きを指定します。
  AgoraVideoOrientation get orientation => _orientation;
  AgoraVideoOrientation _orientation = AgoraVideoOrientation.landscape;

  AgoraVideoProfile _videoProfile = AgoraVideoProfile.size640x360Rate15;

  /// By passing [videoProfile] and [orientation], the screen size and frame rate can be specified.
  ///
  /// If [Null] is passed, the respective current value is retained.
  ///
  /// [videoProfile]と[orientation]を渡すことによって、スクリーンサイズとフレームレートを指定することができます。
  ///
  /// [Null]が渡された場合、それぞれの現在の値が保持されます。
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

  /// Returns `true` if connected.
  ///
  /// 接続されている場合`true`を返します。
  bool get connected => _connected;
  bool _connected = false;

  /// If a connection is currently being attempted, it returns its [Future].
  ///
  /// Once the connection is made, [Future] is completed.
  ///
  /// 現在接続試行中の場合、その[Future]を返します。
  ///
  /// 接続が完了すると[Future]が完了します。
  Future<void>? get connecting => _connectingCompleter?.future;
  Completer<void>? _connectingCompleter;

  /// If a disconnect attempt is currently in progress, returns its [Future].
  ///
  /// When the disconnection is complete, [Future] is completed.
  ///
  /// 現在切断試行中の場合、その[Future]を返します。
  ///
  /// 切断が完了すると[Future]が完了します。
  Future<void>? get disconnecting => _disconnectingCompleter?.future;
  Completer<void>? _disconnectingCompleter;

  Completer<void>? _initializeCompleter;

  /// Specify the profile of the channel to be connected.
  ///
  /// [ChannelProfile.Communication] is a call type communication like Zoom, and [ChannelProfile.LiveBroadcasting] is a type of communication where a small number of people distribute to a large number of users.
  ///
  /// 接続するチャンネルのプロファイルを指定します。
  ///
  /// [ChannelProfile.Communication]だと、Zoomのような通話タイプの通信となり、[ChannelProfile.LiveBroadcasting]だと少人数が大人数のユーザーに配信するタイプの通信となります。
  ChannelProfile get channelProfile => _channelProfile;
  ChannelProfile _channelProfile = ChannelProfile.Communication;

  /// Specify your role if you specify [ChannelProfile.LiveBroadcasting].
  ///
  /// [ClientRole.Broadcaster] is the distributor and [ClientRole.Audience] is the audience.
  ///
  /// [ChannelProfile.LiveBroadcasting]を指定した場合の、自分の役割を指定します。
  ///
  /// [ClientRole.Broadcaster]だと配信者、[ClientRole.Audience]だと視聴者になります。
  ClientRole get clientRole => _clientRole;
  ClientRole _clientRole = ClientRole.Broadcaster;

  /// Swap the camera In and Out.
  ///
  /// カメラのInとOutを入れ替えます。
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

  /// Get the In and Out of the current camera.
  ///
  /// 現在のカメラのInとOutを取得します。
  CameraDirection get cameraDirection => _cameraDirection;
  CameraDirection _cameraDirection = CameraDirection.Rear;

  /// Returns `true` if Audio is enabled.
  ///
  /// Audioを有効にする場合`true`が返ります。
  bool get enableAudio => _enableAudio;

  /// Returns `true` if Audio is enabled.
  ///
  /// Audioを有効にする場合`true`が返ります。
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

  /// Returns `true` if Video is enabled.
  ///
  /// Videoを有効にする場合`true`が返ります。
  bool get enableVideo => _enableVideo;

  /// Returns `true` if Video is enabled.
  ///
  /// Videoを有効にする場合`true`が返ります。
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

  /// If the audio is muted, `true` is returned.
  ///
  /// 音声がミュートされている場合は`true`が返ります。
  bool get mute => _mute;

  /// If the audio is muted, `true` is returned.
  ///
  /// 音声がミュートされている場合は`true`が返ります。
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

  /// If a screenshot of the delivered video is currently being taken, `true` is returned.
  ///
  /// 現在配信映像のスクリーンショットを撮影中の場合は`true`が返ります。
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

  /// If the delivery video is currently being recorded, `true` is returned.
  ///
  /// 現在配信映像を録画中の場合は`true`が返ります。
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

  /// If the delivery video is currently being recorded, `true` is returned.
  ///
  /// 現在配信映像を録音中の場合は`true`が返ります。
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
            _localName = name;
            _localUserNumber = uid;
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

  /// Connect to a new channel.
  ///
  /// Identify the user by passing [userName].
  ///
  /// Passing [videoProfile] and [orientation] will set the screen size, bit rate, etc.
  ///
  /// The [cameraDirection] allows you to specify the camera to shoot first.
  ///
  /// You can explicitly enable or disable video and audio by specifying [enableVideo] and [enableAudio].
  ///
  /// You can specify that a recording or screenshot be taken when the connection is established with [enableRecordingOnConnect] or [enableScreenCaptureOnConnect].
  /// If not specified, the settings of [AgoraMasamuneAdapter.enableRecordingByDefault] and [AgoraMasamuneAdapter.enableScreenCaptureByDefault] are followed.
  ///
  /// You can specify the type of communication by specifying [channelProfile] or [clientRole].
  ///
  /// 新規にチャンネルに接続します。
  ///
  /// [userName]を渡すことでユーザーを識別します。
  ///
  /// [videoProfile]や[orientation]を渡すことで画面サイズやビットレート等の設定を行います。
  ///
  /// [cameraDirection]を利用することで最初に撮影するカメラを指定することができます。
  ///
  /// [enableVideo]、[enableAudio]を指定して、明示的に映像や音声を有効・無効にすることができます。
  ///
  /// [enableRecordingOnConnect]や[enableScreenCaptureOnConnect]で接続が完了したときに録画やスクリーンショットの撮影を指定することができます。
  /// 指定されない場合は、[AgoraMasamuneAdapter.enableRecordingByDefault]や[AgoraMasamuneAdapter.enableScreenCaptureByDefault]の設定に従います。
  ///
  /// [channelProfile]や[clientRole]を指定して、通信のタイプを指定することができます。
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
              AgoraLoggerEvent.userNumberKey: _localUserNumber,
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

  /// Disconnect from channel.
  ///
  /// チャンネルから切断します。
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

  /// If already connected, take a screenshot of the delivered video.
  ///
  /// The [AgoraMasamuneAdapter.storageBucketConfig] setting is mandatory and must also be configured in each Cloud and Functions.
  ///
  /// The corresponding screenshot image can be obtained from the URL in [screenCaptureURL].
  ///
  /// すでに接続されている場合、配信映像のスクリーンショットを撮影します。
  ///
  /// [AgoraMasamuneAdapter.storageBucketConfig]の設定が必須で、各クラウドやFunctionsでも設定が必要になります。
  ///
  /// [screenCaptureURL]のURLから該当のスクリーンショット画像を取得できます。
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

  /// Stops taking screenshots that have already been started.
  ///
  /// すでに開始されているスクリーンショットの撮影を停止します。
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

  /// Get the URL of the image when a screenshot is taken with [startScreenCapture].
  ///
  /// Currently only available at [AgoraStorageVendor.googleCloud].
  ///
  /// [startScreenCapture]でスクリーンショットを撮影した際の画像のURLを取得します。
  ///
  /// 現在[AgoraStorageVendor.googleCloud]でのみ利用可能です。
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

  /// If already connected, record the delivered video.
  ///
  /// The [AgoraMasamuneAdapter.storageBucketConfig] setting is mandatory and must also be configured in each Cloud and Functions.
  ///
  /// You can get the corresponding video from the URL in [recordURL]. m3u8 format files must be able to be played.
  ///
  /// すでに接続されている場合、配信映像の録画を行います。
  ///
  /// [AgoraMasamuneAdapter.storageBucketConfig]の設定が必須で、各クラウドやFunctionsでも設定が必要になります。
  ///
  /// [recordURL]のURLから該当の映像を取得できます。m3u8形式のファイルを再生できる必要があります。
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

  /// Stops a recording that has already started.
  ///
  /// すでに開始されている録画を停止します。
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

  /// Get the URL of the video when recording with [startRecording].
  ///
  /// Currently only available at [AgoraStorageVendor.googleCloud].
  ///
  /// Must be able to play m3u8 format files.
  ///
  /// [startRecording]で録画した際の映像のURLを取得します。
  ///
  /// 現在[AgoraStorageVendor.googleCloud]でのみ利用可能です。
  ///
  /// m3u8形式のファイルを再生できる必要があります。
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

  /// Check if [recordURL] is currently available.
  ///
  /// Returns `true` if available.
  ///
  /// [recordURL]が現在利用可能かどうかを確認します。
  ///
  /// 利用可能な場合`true`を返します。
  Future<bool> checkRecordURLIsActive() async {
    final res = await Api.get(recordURL);
    if (res.statusCode != 200) {
      return false;
    }
    return res.body.contains(".ts");
  }

  /// If already connected, record the delivered video.
  ///
  /// The recorded file is saved in [filePath].
  ///
  /// You can set the quality of the recording with [sampleRate] and [quality].
  ///
  /// すでに接続されている場合、配信映像の録音を行います。
  ///
  /// [filePath]に録音されたファイルが保存されます。
  ///
  /// [sampleRate]や[quality]で録音の質を設定できます。
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

  /// Stops recording that has already started.
  ///
  /// すでに開始されている録音を停止します。
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
