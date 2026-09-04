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

  ImageProvider? _debugPicture;

  /// Whether the camera is initialized.
  ///
  /// カメラが初期化されているかどうか。
  bool get initialized => _initialized;
  bool _initialized = false;

  Future<void>? _initializeFuture;
  bool _disposed = false;
  int _initializationGeneration = 0;

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
    final debugPicture = _debugPicture;
    if (debugPicture != null) {
      return Image(image: debugPicture);
    }
    return adapter.preview(controller: _controller);
  }

  /// Sets an image to use instead of the camera preview and captured pictures.
  ///
  /// The image is kept only while this [Camera] is alive. Video recording is
  /// not affected.
  ///
  /// カメラのプレビューおよび撮影画像の代わりに使用する画像を設定します。
  ///
  /// 画像はこの[Camera]が破棄されるまでの間だけ保持されます。動画撮影には
  /// 影響しません。
  void setDebugPicture(ImageProvider picture) {
    if (_disposed) {
      throw StateError("Camera has already been disposed.");
    }
    if (_debugPicture == picture) {
      return;
    }
    _debugPicture = picture;
    notifyListeners();
  }

  /// Removes the image set by [setDebugPicture].
  ///
  /// [setDebugPicture]で設定した画像を削除します。
  void unsetDebugPicture() {
    if (_disposed) {
      throw StateError("Camera has already been disposed.");
    }
    if (_debugPicture == null) {
      return;
    }
    _debugPicture = null;
    notifyListeners();
  }

  /// Initialize the camera.
  ///
  /// カメラの初期化を行います。
  Future<void> initialize() {
    if (_disposed) {
      return Future<void>.error(
        StateError("Camera has already been disposed."),
      );
    }
    if (_initialized && _controller != null) {
      return Future<void>.value();
    }
    final initializeFuture = _initializeFuture;
    if (initializeFuture != null) {
      return initializeFuture;
    }
    final future = _initialize().whenComplete(() {
      _initializeFuture = null;
    });
    return _initializeFuture = future;
  }

  Future<void> _initialize() async {
    final generation = _initializationGeneration;
    try {
      final initializedController = _controller ??
          await adapter.initialize(resolutionPreset: resolutionPreset);
      if (_disposed || generation != _initializationGeneration) {
        adapter.dispose(controller: initializedController);
        throw StateError("Camera was disposed during initialization.");
      }
      _controller = initializedController;
      _initialized = true;
      notifyListeners();
    } catch (_) {
      _initialized = false;
      rethrow;
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
    _recordingCompleter = Completer<CameraValue?>();
    try {
      final debugPicture = _debugPicture;
      final value = debugPicture != null
          ? await CameraValue.fromImageProvider(
              provider: debugPicture,
              format: format ?? adapter.defaultImageFormat,
              width: width,
              height: height,
            )
          : await _takePicture(
              width: width,
              height: height,
              format: format,
              retryCount: 0,
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

  Future<CameraValue?> _takePicture({
    int? width,
    int? height,
    MediaFormat? format,
    int retryCount = 0,
  }) async {
    try {
      await initialize();
      final value = await adapter.takePicture(
        controller: _controller,
        width: width,
        height: height,
        format: format,
      );
      return value;
    } catch (e) {
      try {
        await _controller?.dispose();
      } catch (e) {
        debugPrint(e.toString());
      }
      _controller = null;
      // 失敗しても3回まで再試行
      if (retryCount < 3) {
        return _takePicture(
          width: width,
          height: height,
          format: format,
          retryCount: retryCount + 1,
        );
      }
      rethrow;
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
    _recordingCompleter = Completer<CameraValue?>();
    try {
      await initialize();
      await _startVideoRecording();
      notifyListeners();
    } catch (e, stacktrace) {
      _recordingCompleter?.completeError(e, stacktrace);
      _recordingCompleter = null;
      rethrow;
    }
  }

  Future<void> _startVideoRecording({
    int retryCount = 0,
  }) async {
    try {
      await initialize();
      _startRecordingTime = DateTime.now();
      await adapter.startVideoRecording(
        controller: _controller,
      );
    } catch (e) {
      try {
        await _controller?.dispose();
      } catch (e) {
        debugPrint(e.toString());
      }
      _controller = null;
      // 失敗しても3回まで再試行
      if (retryCount < 3) {
        return _startVideoRecording(
          retryCount: retryCount + 1,
        );
      }
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
      final value = await _stopVideoRecording();
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

  Future<CameraValue?> _stopVideoRecording({
    int retryCount = 0,
  }) async {
    try {
      final value = await adapter.stopVideoRecording(
        controller: _controller,
        startRecordingTime: _startRecordingTime!,
      );
      return value;
    } catch (e) {
      try {
        await _controller?.dispose();
      } catch (e) {
        debugPrint(e.toString());
      }
      _controller = null;
      // 失敗しても3回まで再試行
      if (retryCount < 3) {
        return _stopVideoRecording(
          retryCount: retryCount + 1,
        );
      }
      rethrow;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _initializationGeneration++;
    _initialized = false;
    _debugPicture = null;
    if (_controller == null) {
      super.dispose();
      return;
    }
    adapter.dispose(controller: _controller);
    _controller = null;
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
