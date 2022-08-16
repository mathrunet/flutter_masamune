part of masamune;

@deprecated
class PlatformAppLayout extends StatefulWidget {
  const PlatformAppLayout({
    required this.initialPath,
    required this.builder,
    this.futures = const [],
    this.loading,
    this.indicatorColor,
    this.appBar,
  });

  /// Loading indicator color.
  final Color? indicatorColor;

  /// Builder when the data is empty.
  final Widget? loading;
  final List<FutureOr<dynamic>> futures;
  final String initialPath;
  final Widget Function(
    BuildContext context,
    bool isMobile,
    NavigatorController? controller,
    String? routeId,
  ) builder;

  final SliverAppBar? appBar;

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
    if (widget.futures != oldWidget.futures && widget.futures.isNotEmpty) {
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
    if (widget.futures.isNotEmpty) {
      return _sliverScroll(
        context,
        LoadingBuilder(futures: widget.futures, builder: _build),
      );
    } else {
      return _sliverScroll(
        context,
        _build(context),
      );
    }
  }

  Widget _build(BuildContext context) {
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

  Widget _sliverScroll(BuildContext context, Widget child) {
    if (!Config.isMobile) {
      return child;
    }
    return CustomScrollView(
      slivers: [
        if (widget.appBar != null) widget.appBar!,
        child,
      ],
    );
  }
}
