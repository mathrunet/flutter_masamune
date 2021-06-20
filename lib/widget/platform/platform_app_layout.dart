part of masamune;

class PlatformAppLayout extends StatefulWidget {
  const PlatformAppLayout({
    required this.initialPath,
    required this.builder,
  });

  final String initialPath;
  final Widget Function(
    BuildContext context,
    bool isMobile,
    NavigatorController? controller,
    String? routeId,
  ) builder;

  @override
  State<StatefulWidget> createState() => _PlatformAppLayoutState();
}

class _PlatformAppLayoutState extends State<PlatformAppLayout> {
  NavigatorController? _controller;
  Widget? _inlinePageCache;

  @override
  void initState() {
    super.initState();
    if (Config.isMobile) {
      return;
    }
    _controller = NavigatorController(widget.initialPath);
    _controller?.addListener(_handledOnUpdate);
  }

  @override
  void didUpdateWidget(PlatformAppLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (Config.isMobile) {
      return;
    }
    if (widget.initialPath != oldWidget.initialPath) {
      _inlinePageCache = null;
      _controller?.dispose();
      _controller = NavigatorController(widget.initialPath);
      _controller?.addListener(_handledOnUpdate);
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Config.isMobile;
    if (isMobile) {
      return widget.builder.call(context, isMobile, null, null);
    } else {
      final routeId = _controller?.route?.name?.last();
      return CMSLayout(
        sideBorder: const BorderSide(),
        leftBar: widget.builder.call(context, isMobile, _controller, routeId),
        child: _inlinePage(context),
      );
    }
  }

  Widget _inlinePage(BuildContext context) {
    if (_inlinePageCache != null) {
      return _inlinePageCache!;
    }
    _inlinePageCache = InlinePageBuilder(controller: _controller);
    return _inlinePageCache!;
  }
}
