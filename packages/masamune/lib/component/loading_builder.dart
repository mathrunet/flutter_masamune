part of masamune;

class LoadingBuilder extends StatelessWidget {
  const LoadingBuilder({
    required this.futures,
    required this.builder,
    this.indicatorColor,
    this.loading,
  });

  final List<FutureOr<dynamic>> futures;

  final Widget Function(BuildContext context) builder;

  /// Builder when the data is empty.
  final Widget? loading;

  /// Loading indicator color.
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    final _futures = futures.whereType<Future>();
    final _wait = _futures.isNotEmpty ? Future.wait(_futures) : null;
    if (_wait == null) {
      return builder(context);
    }
    return FutureBuilder(
      future: _wait,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: loading ??
                context.theme.widget.loadingIndicator?.call(
                  context,
                  indicatorColor ?? context.theme.disabledColor,
                ) ??
                CircularProgressIndicator(
                  backgroundColor:
                      indicatorColor ?? context.theme.disabledColor,
                ),
          );
        } else {
          return builder(context);
        }
      },
    );
  }
}
