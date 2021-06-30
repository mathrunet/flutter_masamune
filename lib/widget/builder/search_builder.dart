part of masamune;

/// Builder widget for searching.
class SearchBuilder<T extends Object> extends StatefulWidget {
  /// Builder widget for searching.
  ///
  /// [emptyWidget]: Builder when the data is empty.
  /// [padding]: Padding.
  /// [initialWidget]: The first widget shown.
  /// [initialValue]: Default search text.
  /// [minLength]: The minimum length of search text required to perform a search.
  /// [controller]: Controller for entering a search string.
  /// [indicatorColor]: Loading indicator color.
  /// [search]: Callback to be executed during the search.
  /// [builder]: Builder when the task is completed.
  const SearchBuilder({
    this.emptyWidget,
    this.padding = const EdgeInsets.all(10),
    this.controller,
    this.minLength = 1,
    this.initialWidget,
    this.indicatorColor,
    this.history,
    required this.search,
    this.initialValue,
    required this.builder,
    this.top,
    this.insert,
    this.insertPosition = 0,
    this.bottom,
  });

  /// Search history builder.
  final SearchBuilderHistory? history;

  /// Builder when the data is empty.
  final Widget? emptyWidget;

  /// The first widget shown.
  final Widget? initialWidget;

  /// Padding.
  final EdgeInsetsGeometry padding;

  /// Default search text.
  final String? initialValue;

  /// The minimum length of search text required to perform a search.
  final int minLength;

  /// Controller for entering a search string.
  final TextEditingController? controller;

  /// Loading indicator color.
  final Color? indicatorColor;

  /// Callback to be executed during the search.
  final Future<Iterable<T>> Function(String text) search;

  /// Builder when the task is completed.
  final List<Widget> Function(BuildContext context, T item) builder;

  final int insertPosition;
  final List<Widget>? insert;
  final List<Widget>? top;
  final List<Widget>? bottom;

  @override
  _SearchBuilderState<T> createState() => _SearchBuilderState<T>();
}

class _SearchBuilderState<T extends Object> extends State<SearchBuilder<T>> {
  String? value;
  TextEditingController? _controller;
  final List<String> _histories = [];

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  void didUpdateWidget(SearchBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(_effectiveController?.text ?? "");
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
    if (widget.initialValue != oldWidget.initialValue) {
      setValue(widget.initialValue ?? "");
    }
    if (widget.history != oldWidget.history &&
        widget.history != null &&
        widget.history!.source.isNotEmpty) {
      _histories.clear();
      _histories.addAll(widget.history!.source);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
    value = _effectiveController?.text;
    if (widget.history != null && widget.history!.source.isNotEmpty) {
      _histories.addAll(widget.history!.source);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty || value.length < widget.minLength) {
      if (widget.history?.builder != null &&
          widget.history!.source.isNotEmpty) {
        return ListBuilder<String>(
          listenWhenListenable: false,
          source: widget.history!.source,
          top: widget.history!.top,
          builder: (context, item) {
            return [widget.history!.builder.call(context, item, _history)];
          },
        );
      }
      if (widget.initialWidget != null) {
        return _builder(
          context,
          widget.initialWidget!,
        );
      }
      if (widget.emptyWidget != null) {
        return _builder(
          context,
          widget.emptyWidget!,
        );
      }
      return _builder(
        context,
        Center(child: Text("No data.".localize())),
      );
    }
    return FutureBuilder<Iterable<T>>(
      future: widget.search(value ?? ""),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _builder(
            context,
            Center(
              child: context.widgetTheme.loadingIndicator?.call(
                    context,
                    widget.indicatorColor ?? context.theme.disabledColor,
                  ) ??
                  LoadingBouncingGrid.square(
                    backgroundColor:
                        widget.indicatorColor ?? context.theme.disabledColor,
                  ),
            ),
          );
        } else {
          if (snapshot.data.isEmpty) {
            if (widget.emptyWidget != null) {
              return _builder(
                context,
                widget.emptyWidget!,
              );
            }
            return _builder(
              context,
              Center(child: Text("No data.".localize())),
            );
          }
          return _builder(
            context,
            ListBuilder<T>(
              source: snapshot.data?.toList() ?? <T>[],
              padding: const EdgeInsets.all(0),
              bottom: widget.bottom,
              insert: widget.insert,
              insertPosition: widget.insertPosition,
              builder: widget.builder,
            ),
          );
        }
      },
    );
  }

  Widget _builder(BuildContext context, Widget child) {
    if (widget.top.isEmpty) {
      return Padding(
        padding: widget.padding,
        child: child,
      );
    }
    return Padding(
      padding: widget.padding,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...widget.top!,
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void setValue(String value) {
    if (value == this.value) {
      return;
    }
    this.value = value;
    setState(() {});
  }

  void _history(String text) {
    _effectiveController?.text = text;
    setState(() {});
  }

  void _handleControllerChanged() {
    final text = _effectiveController?.text ?? "";
    if (widget.history != null &&
        text.isNotEmpty &&
        text.length < widget.minLength) {
      _histories.insertFirst(text);
      widget.history!.onSaved?.call(text);
    }
    setValue(text);
  }
}

class SearchBuilderHistory {
  const SearchBuilderHistory({
    required this.source,
    required this.builder,
    this.top,
    this.onSaved,
  });

  /// Search histories.
  final List<String> source;

  /// History builder.
  final Widget Function(BuildContext context, String history,
      void Function(String text) search) builder;

  final void Function(String text)? onSaved;

  /// History header.
  final List<Widget>? top;
}
