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
    this.minLength = 2,
    this.initialWidget,
    this.indicatorColor,
    required this.search,
    this.initialValue,
    required this.builder,
  });

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
  final List<Widget> Function(BuildContext context, Iterable<T> collection)
      builder;

  @override
  _SearchBuilderState<T> createState() => _SearchBuilderState<T>();
}

class _SearchBuilderState<T extends Object> extends State<SearchBuilder<T>> {
  String? value;
  TextEditingController? _controller;

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
  }

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty || value.length < widget.minLength) {
      if (widget.initialWidget != null) {
        return widget.initialWidget!;
      }
      if (widget.emptyWidget != null) {
        return widget.emptyWidget!;
      }
      return Center(child: Text("No data.".localize()));
    }
    return FutureBuilder<Iterable<T>>(
      future: widget.search(value ?? ""),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(
            child: context.widgetTheme.loadingIndicator?.call(
                  context,
                  widget.indicatorColor ?? context.theme.disabledColor,
                ) ??
                LoadingBouncingGrid.square(
                  backgroundColor:
                      widget.indicatorColor ?? context.theme.disabledColor,
                ),
          );
        } else {
          if (snapshot.data.isEmpty) {
            if (widget.emptyWidget != null) {
              return widget.emptyWidget!;
            }
            return Center(child: Text("No data.".localize()));
          }
          return ListView(
            padding: widget.padding,
            children: widget.builder(context, snapshot.data ?? []),
          );
        }
      },
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

  void _handleControllerChanged() {
    setValue(_effectiveController?.text ?? "");
  }
}
