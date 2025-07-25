part of "/masamune_camera.dart";

/// Items for setting up the introductory page.
///
/// 導入ページ設定用のアイテム。
class Camera extends MasamuneControllerBase<void, CameraMasamuneAdapter> {
  /// Items for setting up the introductory page.
  ///
  /// 導入ページ設定用のアイテム。
  Camera({
    super.adapter,
    this.resolutionPreset,
  });

  /// Resolution preset.
  ///
  /// 解像度のプリセット。
  final ResolutionPreset? resolutionPreset;

  /// Available [CameraController].
  ///
  /// 利用される[CameraController]。
  camera.CameraController get controller {
    assert(_controller != null, "Camera is not initialized.");
    return _controller!;
  }

  camera.CameraController? _controller;

  /// Whether the camera is initialized.
  ///
  /// カメラが初期化されているかどうか。
  bool get initialized => _initialized;
  bool _initialized = false;

  Completer<void>? _initializeCompleter;

  /// [Future] is returned during shooting.
  ///
  /// 撮影中は[Future]が返されます。
  Future<CameraValue?>? get recording => _recordingCompleter?.future;

  Completer<CameraValue?>? _recordingCompleter;

  DateTime? _startRecordingTime;

  @override
  CameraMasamuneAdapter get primaryAdapter => CameraMasamuneAdapter.primary;

  /// Query for Camera.
  ///
  /// ```dart
  /// appRef.controller(Camera.query(parameters));     // Get from application scope.
  /// ref.app.controller(Camera.query(parameters));    // Watch at application scope.
  /// ref.page.controller(Camera.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$CameraQuery();

  /// Output widget for camera preview.
  ///
  /// カメラのプレビュー用のウィジェットを出力します。
  Widget get preview {
    return adapter.preview(controller: _controller);
  }

  /// Initialize the camera.
  ///
  /// カメラの初期化を行います。
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    if (_initializeCompleter != null) {
      return _initializeCompleter!.future;
    }
    _initializeCompleter = Completer<void>();
    try {
      _controller ??=
          await adapter.initialize(resolutionPreset: resolutionPreset);
      _initialized = true;
      _initializeCompleter?.complete();
      _initializeCompleter = null;
      notifyListeners();
    } catch (e, stacktrace) {
      _initialized = false;
      _initializeCompleter?.completeError(e, stacktrace);
      _initializeCompleter = null;
    } finally {
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    }
  }

  /// Grant camera and microphone permissions.
  ///
  /// Returns `false` if rejected.
  ///
  /// カメラおよびマイクの権限の許可を行います。
  ///
  /// 拒否されている場合は`false`を返します。
  Future<bool> requestPermission({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (kIsWeb) {
      return true;
    }
    try {
      var permissionStatus =
          await adapter.requestCameraPermission(timeout: timeout);
      if (permissionStatus != PermissionStatus.granted) {
        return false;
      }
      if (adapter.enableAudio) {
        permissionStatus =
            await adapter.requestMicrophonePermission(timeout: timeout);
        if (permissionStatus != PermissionStatus.granted) {
          return false;
        }
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Take a camera image.
  ///
  /// The value is returned as [CameraValue].
  ///
  /// カメラ画像を撮影します。
  ///
  /// [CameraValue]として値は返されます。
  Future<CameraValue?> takePicture({
    int? width,
    int? height,
    MediaFormat? format,
  }) async {
    if (_recordingCompleter != null) {
      return _recordingCompleter!.future;
    }
    _recordingCompleter = Completer<CameraValue>();
    try {
      await initialize();
      final value = await adapter.takePicture(
        controller: _controller,
        width: width,
        height: height,
        format: format,
      );
      notifyListeners();
      _recordingCompleter?.complete(value);
      _recordingCompleter = null;
      return value;
    } catch (e, stacktrace) {
      _recordingCompleter?.completeError(e, stacktrace);
      _recordingCompleter = null;
      rethrow;
    } finally {
      _recordingCompleter?.complete(null);
      _recordingCompleter = null;
    }
  }

  /// Start video recording.
  ///
  /// ビデオ撮影を開始します。
  Future<void> startVideoRecording() async {
    if (_recordingCompleter != null) {
      await _recordingCompleter!.future;
      return;
    }
    _recordingCompleter = Completer<CameraValue>();
    try {
      await initialize();
      _startRecordingTime = DateTime.now();
      await adapter.startVideoRecording(
        controller: _controller,
      );
      notifyListeners();
    } catch (e, stacktrace) {
      _recordingCompleter?.completeError(e, stacktrace);
      _recordingCompleter = null;
      rethrow;
    }
  }

  /// Stop video recording.
  ///
  /// If the video recording is not started, an exception will be thrown.
  ///
  /// ビデオ撮影を停止します。
  ///
  /// 撮影したファイルは[CameraValue]として返されます。
  Future<CameraValue?> stopVideoRecording() async {
    if (_recordingCompleter == null) {
      throw Exception("Video recording is not started.");
    }
    try {
      final value = await adapter.stopVideoRecording(
        controller: _controller,
        startRecordingTime: _startRecordingTime!,
      );
      notifyListeners();
      _recordingCompleter?.complete(value);
      _recordingCompleter = null;
      return value;
    } catch (e, stacktrace) {
      _recordingCompleter?.completeError(e, stacktrace);
      _recordingCompleter = null;
      rethrow;
    } finally {
      _recordingCompleter?.complete(null);
      _recordingCompleter = null;
    }
  }

  @override
  void dispose() {
    adapter.dispose(controller: _controller);
    super.dispose();
  }
}

@immutable
class _$CameraQuery {
  const _$CameraQuery();

  @useResult
  _$_CameraQuery call() => _$_CameraQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_CameraQuery extends ControllerQueryBase<Camera> {
  const _$_CameraQuery(
    this._name,
  );

  final String _name;

  @override
  Camera Function() call(Ref ref) => Camera.new;

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
