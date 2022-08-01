part of masamune.form;

/// Widget to enable the suggest feature and autocomplete feature.
class SuggestionOverlayBuilder extends StatefulWidget {
  /// Widget to enable the suggest feature and autocomplete feature.
  ///
  /// [items]: Source list for suggestion.
  /// [controller]: Text editing controller.
  /// [onTap]: Processing when tapping a child element (text field).
  /// [elevation]: Suggest window height.
  /// [backgroundColor]: Background color of suggestion window.
  /// [onDeleteSuggestion]: What to do if the suggestion is deleted.
  /// [color]: Suggestion window text color.
  /// [builder]: Builder for child elements.
  /// [showOnTap]: True to show suggestions when tapping the element.
  /// [maxHeight]: Maximum height of choices.
  const SuggestionOverlayBuilder({
    required this.builder,
    required this.items,
    this.onDeleteSuggestion,
    this.maxHeight = 260,
    this.color,
    this.focusNode,
    this.backgroundColor,
    this.elevation = 8.0,
    this.controller,
    this.onTap,
    this.offset = const Offset(0, 20),
    this.showOnTap = true,
  });

  /// Source list for suggestion.
  final List<String> items;

  /// FocusNode.
  final FocusNode? focusNode;

  /// Offset.
  final Offset offset;

  /// Text editing controller.
  final TextEditingController? controller;

  /// Processing when tapping a child element (text field).
  final VoidCallback? onTap;

  /// Suggest window height.
  final double elevation;

  /// Background color of suggestion window.
  final Color? backgroundColor;

  /// What to do if the suggestion is deleted.
  final void Function(String value)? onDeleteSuggestion;

  /// Suggestion window text color.
  final Color? color;

  /// Builder for child elements.
  final Widget Function(
    BuildContext context,
    TextEditingController controller,
    VoidCallback onTap,
  ) builder;

  /// True to show suggestions when tapping the element.
  final bool showOnTap;

  /// Maximum height of choices.
  final double maxHeight;

  @override
  State<StatefulWidget> createState() => _SuggestionOverlayBuilderState();
}

class _SuggestionOverlayBuilderState extends State<SuggestionOverlayBuilder> {
  OverlayEntry? _overlay;
  TextEditingController? _controller;
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  final LayerLink _layerLink = LayerLink();
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    widget.focusNode?.addListener(_listener);
    _effectiveController?.addListener(_listener);
  }

  @override
  void didUpdateWidget(SuggestionOverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_listener);
      widget.controller?.addListener(_listener);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_listener);
      widget.focusNode?.addListener(_listener);
    }
  }

  void _listener() {
    if (_overlay != null) {
      return;
    }
    if (_effectiveController == null) {
      return;
    }
    if (widget.items.isEmpty) {
      return;
    }
    final search = _effectiveController?.text;
    final wordList = search?.split(" ") ?? const <String>[];
    if (widget.focusNode != null &&
        widget.focusNode!.hasFocus &&
        search.isEmpty) {
      _updateOverlay();
      return;
    }
    if (!widget.items.any(
      (element) =>
          element.isNotEmpty &&
          wordList.isNotEmpty &&
          wordList.last.isNotEmpty &&
          element != wordList.last &&
          element.toLowerCase().startsWith(wordList.last.toLowerCase()),
    )) {
      return;
    }
    _updateOverlay();
  }

  @override
  void dispose() {
    super.dispose();
    widget.focusNode?.removeListener(_listener);
    _effectiveController?.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return widget.builder(
        context,
        _effectiveController!,
        widget.onTap ?? () {},
      );
    }
    return WillPopScope(
      onWillPop: () {
        if (_overlay == null) {
          return Future.value(true);
        } else {
          _overlay!.remove();
          _overlay = null;
          return Future.value(false);
        }
      },
      child: CompositedTransformTarget(
        link: _layerLink,
        child: widget.builder(
          context,
          _effectiveController!,
          () {
            if (widget.showOnTap) {
              _updateOverlay();
            }
            widget.onTap?.call();
          },
        ),
      ),
    );
  }

  void _updateOverlay() {
    final itemBox = context.findRenderObject() as RenderBox?;
    if (itemBox == null) {
      return;
    }
    final textFieldSize = itemBox.size;
    final width = textFieldSize.width;
    final height = textFieldSize.height;
    final rect = itemBox.localToGlobal(Offset.zero) & textFieldSize;
    final screen = MediaQuery.of(context).size;
    final up = rect.top > (screen.height / 2.0);
    _overlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _overlay?.remove();
              _overlay = null;
            },
            child: Container(
              constraints: const BoxConstraints.expand(),
              color: Colors.transparent,
            ),
          ),
          Positioned(
            width: width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, -widget.maxHeight),
              child: SizedBox(
                width: width,
                child: _SuggestionOverlay(
                  items: widget.items,
                  color: widget.color ?? context.theme.textColorOnSurface,
                  offset: Offset(
                    widget.offset.dx,
                    up
                        ? widget.offset.dy
                        : widget.maxHeight + height + widget.offset.dy,
                  ),
                  maxHeight: widget.maxHeight,
                  direction: up ? VerticalDirection.up : VerticalDirection.down,
                  onDeleteSuggestion: widget.onDeleteSuggestion,
                  backgroundColor: widget.backgroundColor ??
                      context.theme.colorScheme.surface,
                  controller: _effectiveController!,
                  elevation: widget.elevation,
                  onTap: () {
                    _overlay?.remove();
                    _overlay = null;
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
    if (_overlay != null) {
      Navigator.of(context).overlay?.insert(_overlay!);
    }
  }
}

class _SuggestionOverlay extends StatefulWidget {
  const _SuggestionOverlay({
    required this.items,
    this.controller,
    this.offset = Offset.zero,
    this.maxHeight = 260,
    this.direction = VerticalDirection.down,
    this.onDeleteSuggestion,
    this.elevation = 8.0,
    this.color = Colors.black,
    this.onTap,
    this.backgroundColor = Colors.white,
  });
  final double elevation;
  final Color backgroundColor;
  final Color color;
  final List<String> items;
  final VerticalDirection direction;
  final void Function(String value)? onDeleteSuggestion;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final double maxHeight;
  final Offset offset;
  @override
  State<StatefulWidget> createState() => _SuggestionOverlayState();
}

class _SuggestionOverlayState extends State<_SuggestionOverlay> {
  String? _search;
  TextEditingController? _controller;
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  List<String> _wordList = [];
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _search = _effectiveController?.text;
    _wordList = _search?.split(" ") ?? const <String>[];
    _effectiveController?.addListener(_listener);
  }

  @override
  void didUpdateWidget(_SuggestionOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_listener);
      widget.controller?.addListener(_listener);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  void _listener() {
    setState(() {
      _search = _effectiveController?.text;
      _wordList = _search?.split(" ") ?? const <String>[];
    });
  }

  @override
  void dispose() {
    super.dispose();
    _effectiveController?.removeListener(_listener);
  }

  @override
  Widget build(BuildContext context) {
    final widgets = widget.items.mapAndRemoveEmpty(
      (e) {
        if (e.isNotEmpty &&
            _wordList.isNotEmpty &&
            _wordList.last.isNotEmpty &&
            e != _wordList.last &&
            !e.toLowerCase().startsWith(_wordList.last.toLowerCase())) {
          return null;
        }
        return GestureDetector(
          onTap: () {
            if (_wordList.isNotEmpty) {
              _wordList[_wordList.length - 1] = e;
            }
            final text = _wordList.join(" ");
            _effectiveController?.clearComposing();
            _effectiveController?.clear();
            _effectiveController?.text = text;
            _effectiveController?.selection = TextSelection.fromPosition(
              TextPosition(offset: _effectiveController?.text.length ?? 0),
            );
            widget.onTap?.call();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints.expand(height: 50),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    e,
                    style: TextStyle(fontSize: 18, color: widget.color),
                  ),
                ),
                if (widget.onDeleteSuggestion != null)
                  Container(
                    width: 80,
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(0),
                      icon: Icon(Icons.close, size: 20, color: widget.color),
                      onPressed: () {
                        setState(() {
                          widget.items.remove(e);
                          widget.onDeleteSuggestion?.call(e);
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (widgets.isEmpty) {
      widget.onTap?.call();
      return const Empty();
    }
    final height = min((widgets.length * 50).toDouble() + 20, widget.maxHeight);

    final offset = widget.offset.dy +
        (widget.direction == VerticalDirection.down
            ? 0
            : (widget.maxHeight - height));
    return Container(
      height: height + offset,
      padding: EdgeInsets.only(top: offset),
      child: Card(
        elevation: widget.elevation,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        color: widget.backgroundColor,
        child: SingleChildScrollView(
          reverse: widget.direction == VerticalDirection.up,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            verticalDirection: widget.direction,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          ),
        ),
      ),
    );
  }
}
