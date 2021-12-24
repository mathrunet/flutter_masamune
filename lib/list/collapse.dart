part of masamune.list;

class CollapseIcon extends StatefulWidget {
  const CollapseIcon({
    this.icon = Icons.arrow_drop_down,
    required this.show,
    this.direction = CollapseIconDirection.right,
    this.duration = const Duration(milliseconds: 320),
  });

  final IconData icon;
  final bool show;
  final Duration duration;
  final CollapseIconDirection direction;

  @override
  State<StatefulWidget> createState() => _CollapseIconState();
}

enum CollapseIconDirection { right, left }

class _CollapseIconState extends State<CollapseIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: widget.show ? 1.0 : 0.0,
      vsync: this,
      duration: widget.duration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CollapseIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show != oldWidget.show) {
      if (widget.show) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller.drive(Tween<double>(
          begin: widget.direction == CollapseIconDirection.right ? -0.25 : 0.25,
          end: 0)),
      child: Icon(widget.icon),
    );
  }
}

class Collapse extends StatelessWidget {
  const Collapse({
    Key? key,
    required this.children,
    required this.show,
    this.axis = CollapsibleAxis.vertical,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.alignment = Alignment.topCenter,
    this.minWidthFactor = 0.0,
    this.minHeightFactor = 0.0,
    this.fade = true,
    this.minOpacity = 0.0,
    this.duration = const Duration(milliseconds: 320),
    this.curve = Curves.easeOut,
    this.clipBehavior = Clip.hardEdge,
    this.onComplete,
    this.padding,
    this.maintainState = false,
    this.maintainAnimation = false,
  }) : super(key: key);

  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;
  final MainAxisSize mainAxisSize;
  final CrossAxisAlignment crossAxisAlignment;
  final List<Widget> children;
  final bool show;
  final CollapsibleAxis axis;
  final AlignmentGeometry alignment;
  final double minWidthFactor;
  final double minHeightFactor;
  final bool fade;
  final double minOpacity;
  final Duration duration;
  final Curve curve;
  final Clip clipBehavior;
  final void Function()? onComplete;
  final bool maintainState;
  final bool maintainAnimation;

  @override
  Widget build(BuildContext context) {
    return Collapsible(
      child: _padding(context),
      collapsed: !show,
      axis: axis,
      alignment: alignment,
      minWidthFactor: minWidthFactor + 0.00001,
      minHeightFactor: minHeightFactor + 0.00001,
      fade: fade,
      minOpacity: minOpacity,
      duration: duration,
      curve: curve,
      clipBehavior: clipBehavior,
      onComplete: onComplete,
      maintainState: maintainState,
      maintainAnimation: maintainAnimation,
    );
  }

  Widget _padding(BuildContext context) {
    if (padding == null) {
      return _build(context);
    }
    return Padding(padding: padding!, child: _build(context));
  }

  Widget _build(BuildContext context) {
    switch (axis) {
      case CollapsibleAxis.horizontal:
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children,
        );
      default:
        return Column(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: children,
        );
    }
  }
}
