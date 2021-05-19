part of masamune;

/// Place the video as a widget.
///
/// A preview is also possible.
class Video extends StatefulWidget {
  /// Place the video as a widget.
  ///
  /// A preview is also possible.
  const Video(
    this.videoProvider, {
    this.loop = true,
    this.width,
    this.height,
    this.fit,
    this.autoplay = false,
    this.mute = false,
    this.iconSize = 64,
    this.controllable = false,
    this.mixWithOthers = false,
  });

  /// Mix with others.
  final bool mixWithOthers;

  /// Video Provider.
  final VideoProvider videoProvider;

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

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  Future<void>? _initializing;
  VideoPlayerController? _controller;

  @override
  void initState() {
    final provider = widget.videoProvider;
    switch (provider.runtimeType) {
      case FileVideoProvider:
        _controller = VideoPlayerController.file(
          (provider as FileVideoProvider).file,
          videoPlayerOptions: widget.mixWithOthers
              ? VideoPlayerOptions(mixWithOthers: true)
              : null,
        );
        break;
      case NetworkVideoProvider:
        _controller = VideoPlayerController.network(
          (provider as NetworkVideoProvider).url,
          videoPlayerOptions: widget.mixWithOthers
              ? VideoPlayerOptions(mixWithOthers: true)
              : null,
        );
        break;
      case AssetVideoProvider:
        _controller = VideoPlayerController.asset(
          (provider as AssetVideoProvider).path,
          videoPlayerOptions: widget.mixWithOthers
              ? VideoPlayerOptions(mixWithOthers: true)
              : null,
        );
        break;
    }
    _initializing = _controller?.initialize().then((value) {
      if (widget.autoplay) {
        _controller?.play();
      }
    });
    _controller?.setLooping(widget.loop);
    if (widget.mute) {
      _controller?.setVolume(0);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializing,
      builder: (context, snapshot) {
        if (_controller != null &&
            snapshot.connectionState == ConnectionState.done) {
          if (widget.width != null && widget.height != null) {
            return SizedBox(
              width: widget.width!,
              height: widget.height!,
              child: _videoWidget(context),
            );
          } else if (widget.width != null) {
            return SizedBox(
              width: widget.width!,
              height: widget.width! / _controller!.value.aspectRatio,
              child: _videoWidget(context),
            );
          } else if (widget.height != null) {
            return SizedBox(
              width: widget.height! * _controller!.value.aspectRatio,
              height: widget.height!,
              child: _videoWidget(context),
            );
          } else {
            return AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
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
      },
    );
  }

  Widget _videoWidget(BuildContext context) {
    if (_controller == null) {
      return const Empty();
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        if (widget.fit == null)
          VideoPlayer(_controller!)
        else
          FittedBox(
              fit: widget.fit!,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              )),
        if (widget.controllable)
          Center(
            child: IconButton(
              iconSize: widget.iconSize,
              icon: Icon(
                  _controller!.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  color: _controller!.value.isPlaying
                      ? Colors.transparent
                      : context.theme.backgroundColor),
              onPressed: () {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
                setState(() {});
              },
            ),
          ),
      ],
    );
  }
}

@immutable
abstract class VideoProvider {
  const VideoProvider();
}

@immutable
class AssetVideoProvider extends VideoProvider {
  const AssetVideoProvider(this.path);
  final String path;
}

@immutable
class NetworkVideoProvider extends VideoProvider {
  const NetworkVideoProvider(this.url);
  final String url;
}

@immutable
class FileVideoProvider extends VideoProvider {
  const FileVideoProvider(this.file);
  final File file;
}
