part of masamune.component.mobile;

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
    this.iconColor,
    this.fit,
    this.autoplay = false,
    this.mute = false,
    this.iconSize = 64,
    this.controllable = false,
    this.mixWithOthers = false,
    this.onTap,
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

  /// Tap action.
  final VoidCallback? onTap;

  /// Icon color.
  final Color? iconColor;

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
  VideoPlayerController? _controller;

  @override
  void initState() {
    _updateVideoController();
    super.initState();
  }

  Future<void> _updateVideoController() async {
    if (_completer != null) {
      await _completer!.future;
    }
    try {
      _completer = Completer<void>();
      _controller?.dispose();
      _controller = null;
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
          final cacheManager = DefaultCacheManager();
          final url = (provider as NetworkVideoProvider).url;
          final file = await cacheManager.getFileFromCache(url);
          if (file == null) {
            unawaited(cacheManager.downloadFile(url));
            _controller = VideoPlayerController.network(
              url,
              videoPlayerOptions: widget.mixWithOthers
                  ? VideoPlayerOptions(mixWithOthers: true)
                  : null,
            );
          } else {
            _controller = VideoPlayerController.file(
              file.file,
              videoPlayerOptions: widget.mixWithOthers
                  ? VideoPlayerOptions(mixWithOthers: true)
                  : null,
            );
          }
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
      final initializing = _controller?.initialize();
      _controller?.setLooping(widget.loop);
      if (widget.mute) {
        _controller?.setVolume(0);
      }
      await initializing;
      if (widget.autoplay) {
        _controller?.play();
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
      _updateVideoController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller != null &&
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
            ),
          ),
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
                    : (widget.iconColor ?? context.theme.dividerColor),
              ),
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

@immutable
abstract class VideoProvider {
  const VideoProvider();

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => super.hashCode;
}

@immutable
class AssetVideoProvider extends VideoProvider {
  const AssetVideoProvider(this.path);
  final String path;

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => path.hashCode;
}

@immutable
class NetworkVideoProvider extends VideoProvider {
  const NetworkVideoProvider(this.url);
  final String url;

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => url.hashCode;
}

@immutable
class FileVideoProvider extends VideoProvider {
  const FileVideoProvider(this.file);
  final File file;

  /// The equality operator.
  ///
  /// The default behavior for all [Object]s is to return true if and only if this object and [other] are the same object.
  ///
  /// Override this method to specify a different equality relation on a class. The overriding method must still be an equivalence relation. That is, it must be:
  ///
  /// Total: It must return a boolean for all arguments. It should never throw.
  ///
  /// Reflexive: For all objects o, o == o must be true.
  ///
  /// Symmetric: For all objects o1 and o2, o1 == o2 and o2 == o1 must either both be true, or both be false.
  ///
  /// Transitive: For all objects o1, o2, and o3, if o1 == o2 and o2 == o3 are true, then o1 == o3 must be true.
  ///
  /// The method should also be consistent over time, so whether two objects are equal should only change if at least one of the objects was modified.
  ///
  /// If a subclass overrides the equality operator, it should override the [hashCode] method as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  /// The hash code for this object.
  ///
  /// A hash code is a single integer which represents the state of the object that affects [operator ==] comparisons.
  ///
  /// All objects have hash codes. The default hash code implemented by [Object] represents only the identity of the object,
  /// the same way as the default [operator ==] implementation only considers objects equal if they are identical (see [identityHashCode]).
  ///
  /// If [operator ==] is overridden to use the object state instead,
  /// the hash code must also be changed to represent that state,
  /// otherwise the object cannot be used in hash based data structures like the default [Set] and [Map] implementations.
  ///
  /// Hash codes must be the same for objects that are equal to each other according to [operator ==].
  /// The hash code of an object should only change if the object changes in a way that affects equality.
  /// There are no further requirements for the hash codes. They need not be consistent between executions of the same program and there are no distribution guarantees.
  ///
  /// Objects that are not equal are allowed to have the same hash code.
  /// It is even technically allowed that all instances have the same hash code,
  /// but if clashes happen too often, it may reduce the efficiency of hash-based data structures like [HashSet] or [HashMap].
  ///
  /// If a subclass overrides [hashCode],
  /// it should override the [operator ==] operator as well to maintain consistency.
  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => file.path.hashCode;
}
