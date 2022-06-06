part of masamune;

/// Builder to create widgets that allow you to switch to full screen.
class FullScreenBuilder extends StatefulWidget {
  /// Builder to create widgets that allow you to switch to full screen.
  ///
  /// [aspectRatio]: The aspect ratio of the elements that make it full screen.
  /// [backgroundColor]: Background color of the full-screen element.
  /// [background]: Full Screen Element Background.
  /// [foreground]: Foreground of full screen elements.
  /// [bottom]: Elements to be displayed when not in full screen.
  /// [defaultOrientations]: The orientation of the device under normal conditions.
  /// [fullscreenOrientations]: The orientation of the device while in full screen.
  /// [useMediaQuery]: Use media queries to determine orientation.
  const FullScreenBuilder({
    this.aspectRatio = 1,
    this.backgroundColor,
    required this.foreground,
    this.useMediaQuery = false,
    this.defaultOrientations = const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp
    ],
    this.fullscreenOrientations = const [
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ],
    this.bottom,
    this.background,
  });

  /// Use media queries to determine orientation.
  final bool useMediaQuery;

  /// The aspect ratio of the elements that make it full screen.
  final double aspectRatio;

  /// Background color of the full-screen element.
  final Color? backgroundColor;

  /// Full Screen Element Background.
  final Widget? background;

  /// Foreground of full screen elements.
  final Widget Function(
    BuildContext context,
    bool fullscreen,
    Function onToggle,
  ) foreground;

  /// Elements to be displayed when not in full screen.
  final Widget? bottom;

  /// The orientation of the device under normal conditions.
  final List<DeviceOrientation> defaultOrientations;

  /// The orientation of the device while in full screen.
  final List<DeviceOrientation> fullscreenOrientations;

  @override
  State<StatefulWidget> createState() => _FullStreenBuilderState();
}

class _FullStreenBuilderState extends State<FullScreenBuilder> {
  bool _fullscreen = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, oriantation) {
            if (widget.useMediaQuery) {
              oriantation = MediaQuery.of(context).orientation;
            }
            final fullscreen = oriantation == Orientation.landscape;
            return Column(
              children: [
                Container(
                  width: constraints.maxWidth,
                  height: !fullscreen
                      ? constraints.maxWidth / widget.aspectRatio
                      : constraints.maxHeight,
                  color: widget.backgroundColor,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (widget.background != null)
                        FittedBox(fit: BoxFit.cover, child: widget.background),
                      widget.foreground(context, fullscreen, _onToggle),
                    ],
                  ),
                ),
                if (widget.bottom != null) Expanded(child: widget.bottom!)
              ],
            );
          },
        );
      },
    );
  }

  void _onToggle() {
    setState(() {
      if (_fullscreen) {
        _fullscreen = false;
        SystemChrome.setPreferredOrientations(widget.defaultOrientations);
      } else {
        _fullscreen = true;
        SystemChrome.setPreferredOrientations(widget.fullscreenOrientations);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (!_fullscreen) {
      return;
    }
    SystemChrome.setPreferredOrientations(widget.defaultOrientations);
  }
}
