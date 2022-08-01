part of masamune;

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  const SearchBar({
    this.controller,
    this.focusNode,
    this.hintText,
    this.backgroundColor,
    this.color,
    this.actions = const [],
    this.suggestion = const [],
    this.onChanged,
    this.onSubmitted,
    this.elevation,
    this.contentPadding = const EdgeInsets.all(0),
    this.shadowColor,
    this.onDeleteSuggestion,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final Color? shadowColor;
  final Color? backgroundColor;
  final Color? color;
  final double? elevation;
  final List<Widget> actions;
  final List<String> suggestion;
  final EdgeInsetsGeometry contentPadding;
  final void Function(String value)? onDeleteSuggestion;
  final void Function(String? value)? onChanged;
  final void Function(String? value)? onSubmitted;

  @override
  State<StatefulWidget> createState() => _SearchBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController? _controller;
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
  }

  @override
  void didUpdateWidget(SearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (widget.controller == null) {
        _controller = TextEditingController(text: oldWidget.controller?.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      iconTheme: IconThemeData(
        color: widget.color ?? context.theme.textColor,
      ),
      elevation: widget.elevation,
      actionsIconTheme: IconThemeData(
        color: widget.color ?? context.theme.textColor,
      ),
      actions: [
        ...widget.actions,
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            widget.onSubmitted?.call(_effectiveController?.text);
          },
        )
      ],
      shadowColor: widget.shadowColor,
      leading: context.navigator.canPop()
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.navigator.pop();
              },
            )
          : null,
      backgroundColor: widget.backgroundColor ?? context.theme.backgroundColor,
      title: FormItemTextField(
        dense: true,
        focusNode: widget.focusNode,
        controller: _effectiveController,
        color: widget.color ?? context.theme.textColor,
        hintText: widget.hintText,
        onChanged: widget.onChanged,
        padding: const EdgeInsets.all(0),
        contentPadding: widget.contentPadding,
        suggestion: widget.suggestion,
        onSubmitted: widget.onSubmitted,
        onDeleteSuggestion: widget.onDeleteSuggestion,
      ),
    );
  }
}
