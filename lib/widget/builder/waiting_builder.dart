part of masamune;

class WaitingBuilder extends StatefulWidget {
  const WaitingBuilder({
    required this.futures,
    required this.builder,
    this.indicatorColor,
    this.loading,
  });

  final List<Future<dynamic>> futures;

  final Widget Function(BuildContext context) builder;

  /// Builder when the data is empty.
  final Widget? loading;

  /// Loading indicator color.
  final Color? indicatorColor;

  @override
  State<StatefulWidget> createState() => _WaitingBuilder();
}

class _WaitingBuilder extends State<WaitingBuilder> {
  Future<dynamic>? _wait;

  @override
  void initState() {
    super.initState();
    _wait = Future.wait(widget.futures);
  }

  @override
  void didUpdateWidget(WaitingBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.futures != oldWidget.futures) {
      _wait = Future.wait(widget.futures);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _wait,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: widget.loading ??
                context.widgetTheme.loadingIndicator?.call(
                  context,
                  widget.indicatorColor ?? context.theme.disabledColor,
                ) ??
                LoadingBouncingGrid.square(
                  backgroundColor:
                      widget.indicatorColor ?? context.theme.disabledColor,
                ),
          );
        } else {
          return widget.builder(context);
        }
      },
    );
  }
}
