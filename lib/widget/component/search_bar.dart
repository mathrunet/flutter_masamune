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
    this.onDeleteSuggestion,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final Color? backgroundColor;
  final Color? color;
  final List<Widget> actions;
  final List<String> suggestion;
  final void Function(String value)? onDeleteSuggestion;
  final void Function(String? value)? onChanged;

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
      actionsIconTheme: IconThemeData(
        color: widget.color ?? context.theme.textColor,
      ),
      actions: [
        ...widget.actions,
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {},
        )
      ],
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          context.navigator.pop();
        },
      ),
      backgroundColor: widget.backgroundColor ?? context.theme.backgroundColor,
      title: FormItemTextField(
        dense: true,
        focusNode: widget.focusNode,
        controller: _effectiveController,
        color: widget.color ?? context.theme.textColor,
        hintText: widget.hintText,
        onChanged: widget.onChanged,
        padding: const EdgeInsets.all(0),
        contentPadding: const EdgeInsets.all(0),
        suggestion: widget.suggestion,
        onDeleteSuggestion: widget.onDeleteSuggestion,
      ),
    );
  }
}
