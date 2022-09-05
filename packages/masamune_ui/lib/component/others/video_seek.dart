part of masamune_ui.component.others;

class VideoSeek extends StatefulWidget {
  const VideoSeek({
    required this.controller,
    this.textStyle,
    this.activeColor,
    this.inactiveColor,
    this.padding = const EdgeInsets.all(8),
  });

  final VideoController controller;

  final TextStyle? textStyle;

  final EdgeInsetsGeometry padding;

  final Color? activeColor;

  final Color? inactiveColor;

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
  _VideoSeekState createState() => _VideoSeekState();
}

class _VideoSeekState extends State<VideoSeek> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handledOnUpdate);
  }

  @override
  void didUpdateWidget(VideoSeek oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handledOnUpdate);
      widget.controller.addListener(_handledOnUpdate);
    }
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_handledOnUpdate);
  }

  @override
  Widget build(BuildContext context) {
    final positionMinutes = widget.controller.position.inMinutes;
    final positionSeconds = widget.controller.position.inSeconds -
        (widget.controller.position.inMinutes * 60);
    final durationMinutes = widget.controller.duration.inMinutes;
    final durationSeconds = widget.controller.duration.inSeconds -
        (widget.controller.duration.inMinutes * 60);

    return Padding(
      padding: widget.padding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${positionMinutes.format("00")}:${positionSeconds.format("00")}/${durationMinutes.format("00")}:${durationSeconds.format("00")}",
            style: widget.textStyle ??
                TextStyle(
                  color: context.theme.textColorOnPrimary,
                  fontSize: 12,
                ),
          ),
          Expanded(
            child: Slider(
              activeColor: widget.activeColor ?? context.theme.primaryColor,
              inactiveColor:
                  widget.inactiveColor ?? context.theme.textColorOnPrimary,
              onChanged: (double value) {},
              onChangeEnd: (double value) {
                widget.controller.seekTo(
                  Duration(
                    milliseconds:
                        (value * widget.controller.duration.inMilliseconds)
                            .round(),
                  ),
                );
              },
              max: 1.0,
              min: 0.0,
              value: widget.controller.position.inMilliseconds /
                  widget.controller.duration.inMilliseconds,
            ),
          ),
        ],
      ),
    );
  }
}
