part of masamune_ui.component.mobile;

class VideoController extends ChangeNotifier {
  VideoPlayerController? _playerController;

  void _setController(VideoPlayerController? controller) {
    _playerController = controller;
    _playerController?.addListener(_handledOnUpdate);
  }

  void _handledOnUpdate() {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _playerController?.removeListener(_handledOnUpdate);
    _playerController?.dispose();
    _playerController = null;
  }

  /// Starts playing the video.
  ///
  /// If the video is at the end, this method starts playing from the beginning.
  ///
  /// This method returns a future that completes as soon as the "play" command
  /// has been sent to the platform, not when playback itself is totally
  /// finished.
  Future<void> play() async {
    assert(
      _playerController != null,
      "VideoController is not initialized; pass it to the Video widget for initialization.",
    );
    await _playerController?.play();
  }

  /// Sets whether or not the video should loop after playing once. See also
  /// [isLooping].
  Future<void> setLooping(bool looping) async {
    assert(
      _playerController != null,
      "VideoController is not initialized; pass it to the Video widget for initialization.",
    );
    await _playerController?.setLooping(looping);
  }

  /// Pauses the video.
  Future<void> pause() async {
    assert(
      _playerController != null,
      "VideoController is not initialized; pass it to the Video widget for initialization.",
    );
    await _playerController?.pause();
  }

  /// Sets the video's current timestamp to be at [moment]. The next
  /// time the video is played it will resume from the given [moment].
  ///
  /// If [moment] is outside of the video's full range it will be automatically
  /// and silently clamped.
  Future<void> seekTo(Duration position) async {
    assert(
      _playerController != null,
      "VideoController is not initialized; pass it to the Video widget for initialization.",
    );
    await _playerController?.seekTo(position);
  }

  /// Sets the audio volume of [this].
  ///
  /// [volume] indicates a value between 0.0 (silent) and 1.0 (full volume) on a
  /// linear scale.
  Future<void> setVolume(double volume) async {
    assert(
      _playerController != null,
      "VideoController is not initialized; pass it to the Video widget for initialization.",
    );
    await _playerController?.setVolume(volume);
  }

  /// Sets the playback speed of [this].
  ///
  /// [speed] indicates a speed value with different platforms accepting
  /// different ranges for speed values. The [speed] must be greater than 0.
  ///
  /// The values will be handled as follows:
  /// * On web, the audio will be muted at some speed when the browser
  ///   determines that the sound would not be useful anymore. For example,
  ///   "Gecko mutes the sound outside the range `0.25` to `5.0`" (see https://developer.mozilla.org/en-US/docs/Web/API/HTMLMediaElement/playbackRate).
  /// * On Android, some very extreme speeds will not be played back accurately.
  ///   Instead, your video will still be played back, but the speed will be
  ///   clamped by ExoPlayer (but the values are allowed by the player, like on
  ///   web).
  /// * On iOS, you can sometimes not go above `2.0` playback speed on a video.
  ///   An error will be thrown for if the option is unsupported. It is also
  ///   possible that your specific video cannot be slowed down, in which case
  ///   the plugin also reports errors.
  Future<void> setPlaybackSpeed(double speed) async {
    assert(
      _playerController != null,
      "VideoController is not initialized; pass it to the Video widget for initialization.",
    );
    await _playerController?.setPlaybackSpeed(speed);
  }

  /// The total duration of the video.
  ///
  /// The duration is [Duration.zero] if the video hasn't been initialized.
  Duration get duration {
    return _playerController?.value.duration ?? Duration.zero;
  }

  /// The current playback position.
  Duration get position {
    return _playerController?.value.position ?? Duration.zero;
  }

  /// True if the video is playing. False if it's paused.
  bool get isPlaying {
    return _playerController?.value.isPlaying ?? false;
  }

  /// True if the video is looping.
  bool get isLooping {
    return _playerController?.value.isLooping ?? false;
  }

  /// True if the video is currently buffering.
  bool get isBuffering {
    return _playerController?.value.isBuffering ?? false;
  }

  /// The current volume of the playback.
  double get volume {
    return _playerController?.value.volume ?? 0;
  }

  /// The current speed of the playback.
  double get playbackSpeed {
    return _playerController?.value.playbackSpeed ?? 1.0;
  }

  /// The [size] of the currently loaded video.
  Size get size {
    return _playerController?.value.size ?? Size.zero;
  }

  /// Indicates whether or not the video has been loaded and is ready to play.
  bool get isInitialized {
    return _playerController?.value.isInitialized ?? false;
  }

  /// Returns [size.width] / [size.height].
  ///
  /// Will return `1.0` if:
  /// * [isInitialized] is `false`
  /// * [size.width], or [size.height] is equal to `0.0`
  /// * aspect ratio would be less than or equal to `0.0`
  double get aspectRatio {
    return _playerController?.value.aspectRatio ?? 1.0;
  }
}

extension WidgetRefVideoControllerExtensions on WidgetRef {
  VideoController useVideoController() {
    return valueBuilder<VideoController, _VideoControllerValue>(
      key: "videoController",
      builder: () {
        return const _VideoControllerValue();
      },
    );
  }
}

@immutable
class _VideoControllerValue extends ScopedValue<VideoController> {
  const _VideoControllerValue();

  @override
  ScopedValueState<VideoController, _VideoControllerValue> createState() {
    return _VideoControllerValueState();
  }
}

class _VideoControllerValueState
    extends ScopedValueState<VideoController, _VideoControllerValue> {
  late final VideoController _controller;

  @override
  void initValue() {
    super.initValue();
    _controller = VideoController();
    _controller.addListener(_handledOnUpdate);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.removeListener(_handledOnUpdate);
    _controller.dispose();
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  VideoController build() => _controller;
}
