part of masamune.form;

class FormItemCommentField extends StatefulWidget {
  const FormItemCommentField({
    this.hintText,
    this.focusNode,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 4,
    this.minLines = 1,
    this.onSubmitted,
    this.padding = const EdgeInsets.all(0),
    this.color,
    this.subColor,
    this.backgroundColor,
    this.borderColor,
    this.mediaIcon,
    this.onTapMediaIcon,
    this.templateIcon,
    this.onTapTemplateIcon,
    this.iconColor,
    this.submitIcon,
    this.autofocus = false,
    this.suffix,
  });
  final Color? color;
  final Color? subColor;
  final String? hintText;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int? maxLines;
  final int minLines;
  final void Function(String? value)? onSubmitted;
  final VoidCallback? onTapMediaIcon;
  final VoidCallback? onTapTemplateIcon;
  final IconData? mediaIcon;
  final IconData? templateIcon;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final Color? iconColor;
  final IconData? submitIcon;
  final bool autofocus;
  final Widget? suffix;

  @override
  State<StatefulWidget> createState() => _FormItemCommentFieldState();
}

class _FormItemCommentFieldState extends State<FormItemCommentField> {
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
  void didUpdateWidget(FormItemCommentField oldWidget) {
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
    var left = 16.0;
    if (widget.onTapMediaIcon != null) {
      left += 40.0;
    }
    if (widget.onTapTemplateIcon != null) {
      left += 40.0;
    }

    return Container(
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        border: widget.borderColor != null
            ? Border(
                top: BorderSide(
                  color: widget.borderColor!,
                  width: 1,
                ),
              )
            : null,
      ),
      child: Stack(
        children: [
          FormItemTextField(
            dense: true,
            hintText: widget.hintText,
            focusNode: effectiveFocusNode,
            controller: effectiveController,
            keyboardType: widget.keyboardType,
            color: widget.color ?? context.theme.textColor,
            subColor:
                widget.subColor ?? context.theme.textColor.withOpacity(0.5),
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            textAlignVertical: TextAlignVertical.top,
            textAlign: TextAlign.start,
            contentPadding: EdgeInsets.fromLTRB(left, 0, 56, 0),
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
                widget.submitIcon ?? Icons.send,
                size: 25,
                color: widget.iconColor ??
                    widget.color ??
                    context.theme.textColor.withOpacity(0.5),
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
                  color: widget.iconColor ??
                      widget.color ??
                      context.theme.textColor.withOpacity(0.5),
                ),
              ),
            ),
          if (widget.onTapTemplateIcon != null)
            Positioned(
              left: widget.onTapMediaIcon != null ? 40 : 10,
              top: 0,
              bottom: 6,
              child: IconButton(
                onPressed: widget.onTapTemplateIcon,
                padding: const EdgeInsets.all(0),
                visualDensity: VisualDensity.compact,
                icon: Icon(
                  widget.templateIcon ?? FontAwesomeIcons.clipboardList,
                  size: 23,
                  color: widget.iconColor ??
                      widget.color ??
                      context.theme.textColor.withOpacity(0.5),
                ),
              ),
            ),
          if (widget.suffix != null)
            Positioned(
              right: 40,
              top: 0,
              bottom: 6,
              child: widget.suffix!,
            ),
        ],
      ),
    );
  }
}
