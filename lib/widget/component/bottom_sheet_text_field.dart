part of masamune;

class BottomSheetTextField extends StatefulWidget {
  const BottomSheetTextField({
    this.hintText,
    this.focusNode,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 4,
    this.minLines = 1,
    this.onSubmitted,
    this.padding = const EdgeInsets.all(0),
    this.backgroundColor,
    this.borderColor,
    this.mediaIcon,
    this.onTapMediaIcon,
    this.iconColor,
    this.sendIcon,
    this.autofocus = false,
  });
  final String? hintText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int? maxLines;
  final int minLines;
  final void Function(String? value)? onSubmitted;
  final VoidCallback? onTapMediaIcon;
  final IconData? mediaIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final Color? iconColor;
  final IconData? sendIcon;
  final bool autofocus;

  @override
  State<StatefulWidget> createState() => _BottomSheetTextFieldState();
}

class _BottomSheetTextFieldState extends State<BottomSheetTextField> {
  TextEditingController? _controller;
  TextEditingController? get effectiveController =>
      widget.controller ?? _controller;
  FocusNode? _focusNode;
  FocusNode? get effectiveFocusNode => widget.focusNode ?? _focusNode;
  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    }
    if (widget.focusNode == null) {
      _focusNode = FocusNode();
    }
    if (widget.autofocus) {
      effectiveFocusNode?.requestFocus();
    }
  }

  @override
  void didUpdateWidget(BottomSheetTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (widget.controller == null) {
        _controller = TextEditingController();
      }
      setState(() {});
    }
    if (widget.focusNode != oldWidget.focusNode) {
      if (widget.focusNode == null) {
        _focusNode = FocusNode();
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? context.theme.backgroundColor,
        border: Border(
          top: BorderSide(
            color: widget.borderColor ?? context.theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Stack(
        children: [
          FormItemTextField(
            dense: true,
            hintText: widget.hintText,
            focusNode: effectiveFocusNode,
            controller: effectiveController,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.start,
            contentPadding: EdgeInsets.fromLTRB(
                widget.onTapMediaIcon != null ? 56 : 16, 0, 56, 0),
            onSubmitted: (value) {
              widget.onSubmitted?.call(value);
              effectiveFocusNode?.requestFocus();
              effectiveController?.text = "";
            },
          ),
          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: IconButton(
              onPressed: () {
                final value = effectiveController?.text;
                widget.onSubmitted?.call(value);
                effectiveFocusNode?.requestFocus();
                effectiveController?.text = "";
              },
              padding: const EdgeInsets.all(0),
              visualDensity: VisualDensity.compact,
              icon: Icon(
                widget.sendIcon ?? Icons.send,
                size: 25,
                color: widget.iconColor ?? context.theme.disabledColor,
              ),
            ),
          ),
          if (widget.onTapMediaIcon != null)
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: IconButton(
                onPressed: widget.onTapMediaIcon,
                padding: const EdgeInsets.all(0),
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  widget.mediaIcon ?? Icons.add_photo_alternate,
                  size: 25,
                  color: widget.iconColor ?? context.theme.disabledColor,
                ),
              ),
            )
        ],
      ),
    );
  }
}
