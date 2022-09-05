part of masamune_ui.component.others;

/// Place the video as a widget.
///
/// A preview is also possible.
class Video extends StatefulWidget {
  /// Place the video as a widget.
  ///
  /// A preview is also possible.
  const Video(
    this.videoProvider, {
    this.controller,
    this.loop = true,
    this.width,
    this.height,
    this.fit,
    this.autoplay = false,
    this.mute = false,
    this.iconSize = 64,
    this.controllable = false,
    this.mixWithOthers = false,
    this.onTap,
    this.iconColor,
    this.enableCache = true,
  });

  /// Mix with others.
  final bool mixWithOthers;

  /// Video Provider.
  final VideoProvider videoProvider;

  /// Video controller.
  final VideoController? controller;

  /// True to loop the video.
  final bool loop;

  /// Horizontal size of the video.
  final double? width;

  /// Vertical size of the video.
  final double? height;

  /// Video fit.
  final BoxFit? fit;

  /// True for auto play.
  final bool autoplay;

  /// True if it can be played and stopped.
  final bool controllable;

  /// True to mute.
  final bool mute;

  /// Icon size.
  final double iconSize;

  /// Tap action.
  final VoidCallback? onTap;

  /// Icon color.
  final Color? iconColor;

  /// Enable cache.
  final bool enableCache;

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// Subclasses should override this method to return a newly created
  /// instance of their associated [State] subclass:
  ///
  /// ```dart
  /// @override
  /// _MyState createState() => _MyState();
  /// ```
  ///
  /// The framework can call this method multiple times over the lifetime of
  /// a [StatefulWidget]. For example, if the widget is inserted into the tree
  /// in multiple locations, the framework will create a separate [State] object
  /// for each location. Similarly, if the widget is removed from the tree and
  /// later inserted into the tree again, the framework will call [createState]
  /// again to create a fresh [State] object, simplifying the lifecycle of
  /// [State] objects.
  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  Completer<void>? _completer;
  VideoPlayerController? _playerController;

  @override
  void initState() {
    _updateVideoPlayerController();
    super.initState();
  }

  Future<void> _updateVideoPlayerController() async {
    if (_completer != null) {
      await _completer!.future;
    }
    try {
      _completer = Completer<void>();
      _playerController?.dispose();
      _playerController = null;
      final provider = widget.videoProvider;
      switch (provider.runtimeType) {
        case FileVideoProvider:
          throw UnsupportedError(
            "Video playback by passing [FileVideoProvider] is not supported on this platform.",
          );
        case NetworkVideoProvider:
          _playerController = VideoPlayerController.network(
            (provider as NetworkVideoProvider).url,
            videoPlayerOptions: widget.mixWithOthers
                ? VideoPlayerOptions(mixWithOthers: true)
                : null,
          );
          break;
        case AssetVideoProvider:
          _playerController = VideoPlayerController.asset(
            (provider as AssetVideoProvider).path,
            videoPlayerOptions: widget.mixWithOthers
                ? VideoPlayerOptions(mixWithOthers: true)
                : null,
          );
          break;
      }
      widget.controller?._setController(_playerController);
      final initializing = _playerController?.initialize();
      _playerController?.setLooping(widget.loop);
      if (widget.mute) {
        _playerController?.setVolume(0);
      }
      await initializing;
      if (widget.autoplay) {
        _playerController?.play();
      }
      _completer?.complete();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
    } finally {
      _completer?.complete();
      _completer = null;
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(Video oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.videoProvider != oldWidget.videoProvider) {
      _updateVideoPlayerController();
    }
  }

  @override
  void dispose() {
    _playerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_playerController != null &&
        (_completer == null || _completer!.isCompleted)) {
      if (widget.width != null && widget.height != null) {
        return SizedBox(
          width: widget.width!,
          height: widget.height!,
          child: _videoWidget(context),
        );
      } else if (widget.width != null) {
        return SizedBox(
          width: widget.width!,
          height: widget.width! / _playerController!.value.aspectRatio,
          child: _videoWidget(context),
        );
      } else if (widget.height != null) {
        return SizedBox(
          width: widget.height! * _playerController!.value.aspectRatio,
          height: widget.height!,
          child: _videoWidget(context),
        );
      } else {
        return AspectRatio(
          aspectRatio: _playerController!.value.aspectRatio,
          child: _videoWidget(context),
        );
      }
    } else {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).disabledColor,
        ),
      );
    }
  }

  Widget _videoWidget(BuildContext context) {
    if (_playerController == null) {
      return const Empty();
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.fit == null)
          VideoPlayer(_playerController!)
        else
          FittedBox(
            fit: widget.fit!,
            child: SizedBox(
              width: _playerController!.value.size.width,
              height: _playerController!.value.size.height,
              child: VideoPlayer(_playerController!),
            ),
          ),
        if (widget.controllable)
          Center(
            child: IconButton(
              iconSize: widget.iconSize,
              icon: Icon(
                _playerController!.value.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: _playerController!.value.isPlaying
                    ? Colors.transparent
                    : (widget.iconColor ?? context.theme.dividerColor),
              ),
              onPressed: () {
                if (_playerController!.value.isPlaying) {
                  _playerController!.pause();
                } else {
                  _playerController!.play();
                }
                setState(() {});
              },
            ),
          ),
        if (widget.onTap != null)
          Material(
            color: Colors.transparent,
            child: ClickableBox(
              hoverColor: context.theme.splashColor.withOpacity(0.1),
              onTap: widget.onTap,
            ),
          ),
      ],
    );
  }
}
