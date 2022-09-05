part of masamune_ui.component.mobile;

class VideoControlPanel extends StatefulWidget {
  const VideoControlPanel({
    required this.controller,
    this.backgroundColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.videoSeekHeight = 40,
    this.iconSize = 40,
    this.padding = const EdgeInsets.all(16),
  });
  final VideoController controller;

  final Color? backgroundColor;
  final Duration animationDuration;

  final double videoSeekHeight;
  final EdgeInsetsGeometry padding;
  final double iconSize;
  @override
  State<StatefulWidget> createState() => _VideoControlPanelState();
}

class _VideoControlPanelState extends State<VideoControlPanel> {
  bool _showController = false;
  bool _isPlaying = true;
  Color _overlayColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    if (!widget.controller.isInitialized) {
      return const Empty();
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _showController = !_showController;
          _overlayColor = _showController
              ? (widget.backgroundColor ?? Colors.black38)
              : Colors.transparent;
        });
      },
      child: AnimatedContainer(
        duration: widget.animationDuration,
        color: _overlayColor,
        child: !_showController
            ? const Empty()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                iconSize: widget.iconSize,
                                icon: const Icon(
                                  Icons.fast_rewind,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  widget.controller.seekTo(
                                    Duration(
                                      milliseconds: (widget.controller.position
                                                  .inMilliseconds -
                                              10 * 1000)
                                          .round(),
                                    ),
                                  );
                                },
                              ),
                              if (_isPlaying)
                                IconButton(
                                  iconSize: widget.iconSize,
                                  icon: const Icon(
                                    Icons.pause,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    widget.controller.pause();
                                    setState(() {
                                      _isPlaying = false;
                                    });
                                  },
                                )
                              else
                                IconButton(
                                  iconSize: widget.iconSize,
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    widget.controller.play();
                                    setState(() {
                                      _isPlaying = true;
                                    });
                                    await Future.delayed(
                                      widget.animationDuration * 2,
                                    );
                                    _showController = false;
                                    _overlayColor = _showController
                                        ? (widget.backgroundColor ??
                                            Colors.black38)
                                        : Colors.transparent;
                                  },
                                ),
                              IconButton(
                                iconSize: 40,
                                icon: const Icon(
                                  Icons.fast_forward,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  widget.controller.seekTo(
                                    Duration(
                                      milliseconds: (widget.controller.position
                                                  .inMilliseconds +
                                              10 * 1000)
                                          .round(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: widget.padding,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: widget.videoSeekHeight,
                            child: VideoSeek(controller: widget.controller),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
