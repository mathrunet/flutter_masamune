part of masamune;

class LoadingBuilder<T> extends StatefulWidget {
  const LoadingBuilder({
    required this.source,
    required this.builder,
    this.indicatorColor,
    this.loading,
    this.emptyWidget,
  });

  final FutureOr<T> source;

  final Widget Function(BuildContext context, T data) builder;

  /// Builder when the data is empty.
  final Widget? loading;

  /// Loading indicator color.
  final Color? indicatorColor;

  /// Builder when the data is empty.
  final Widget? emptyWidget;

  @override
  State<StatefulWidget> createState() => _LoadingBuilder<T>();
}

class _LoadingBuilder<T> extends State<LoadingBuilder<T>> {
  @override
  Widget build(BuildContext context) {
    final source = widget.source;
    if (source is T) {
      return widget.builder(context, source);
    } else if (source is Future<T>) {
      return FutureBuilder<T>(
        future: source,
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
            if (snapshot.data == null) {
              return widget.emptyWidget ??
                  Center(child: Text("No data.".localize()));
            }
            // ignore: null_check_on_nullable_type_parameter
            return widget.builder(context, snapshot.data!);
          }
        },
      );
    }
    return const Empty();
  }
}
