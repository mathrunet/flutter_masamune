part of masamune;

/// Place the video as a widget.
///
/// A preview is also possible.
class Video extends StatefulWidget {
  /// Place the video as a widget.
  ///
  /// A preview is also possible.
  ///
  /// [path]: Asset path.
  /// [loop]: True to loop the video.
  /// [width]: Horizontal size of the video.
  /// [height]: Vertical size of the video.
  /// [fit]: Video fit.
  /// [autoplay]: True for auto play.
  /// [controllable]: True if it can be played and stopped.
  /// [mute]: True to mute.
  const Video.asset(String path,
      {this.loop = true,
      this.width,
      this.height,
      this.fit,
      this.autoplay = false,
      this.mute = false,
      this.iconSize = 64,
      this.controllable = false})
      : _type = _VideoType.asset,
        file = null,
        // ignore: prefer_initializing_formals
        uri = path;

  /// Place the video as a widget.
  ///
  /// A preview is also possible.
  ///
  /// [file]: File objects.
  /// [loop]: True to loop the video.
  /// [width]: Horizontal size of the video.
  /// [height]: Vertical size of the video.
  /// [autoplay]: True for auto play.
  /// [controllable]: True if it can be played and stopped.
  /// [mute]: True to mute.
  /// [fit]: Video fit.
  const Video.file(this.file,
      {this.loop = true,
      this.width,
      this.height,
      this.fit,
      this.iconSize = 64,
      this.autoplay = false,
      this.mute = false,
      this.controllable = false})
      : _type = _VideoType.file,
        uri = null;

  /// Place the video as a widget.
  ///
  /// A preview is also possible.
  ///
  /// [url]: Network urls.
  /// [loop]: True to loop the video.
  /// [width]: Horizontal size of the video.
  /// [height]: Vertical size of the video.
  /// [autoplay]: True for auto play.
  /// [controllable]: True if it can be played and stopped.
  /// [mute]: True to mute.
  /// [fit]: Video fit.
  const Video.network(String url,
      {this.loop = true,
      this.width,
      this.height,
      this.fit,
      this.iconSize = 64,
      this.autoplay = false,
      this.mute = false,
      this.controllable = false})
      : _type = _VideoType.network,
        file = null,
        // ignore: prefer_initializing_formals
        uri = url;

  /// Video URL and path.
  final String? uri;

  /// Video file.
  final File? file;

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
  final _VideoType _type;

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
    switch (widget._type) {
      case _VideoType.file:
        _controller = VideoPlayerController.file(widget.file!);
        break;
      case _VideoType.network:
        _controller = VideoPlayerController.network(widget.uri!);
        break;
      default:
        _controller = VideoPlayerController.asset(widget.uri!);
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

enum _VideoType { asset, file, network }
