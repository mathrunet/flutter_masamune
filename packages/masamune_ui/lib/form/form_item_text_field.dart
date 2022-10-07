part of masamune_ui.form;

class FormItemTextField extends StatefulWidget implements FormItem {
  const FormItemTextField({
    Key? key,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.onTap,
    this.minLength,
    this.padding,
    this.contentPadding,
    this.maxLines,
    this.minLines = 1,
    this.border,
    this.disabledBorder,
    this.errorBorder,
    this.backgroundColor,
    this.expands = false,
    this.hintText,
    this.labelText,
    this.lengthErrorText = "",
    this.prefix,
    this.suffix,
    this.prefixText,
    this.suffixText,
    this.prefixIcon,
    this.prefixIconConstraints,
    this.suffixIcon,
    this.suffixIconConstraints,
    this.dense = false,
    this.suggestion = const [],
    this.allowEmpty = false,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.counterText = "",
    this.onDeleteSuggestion,
    this.validator,
    this.inputFormatters,
    this.onSaved,
    this.onSubmitted,
    this.onChanged,
    this.showCursor,
    this.focusNode,
    this.color,
    this.fontSize,
    this.textStyle,
    this.subColor,
    this.height,
    this.errorText,
    this.errorColor,
    this.helperFontSize,
    this.cursorColor,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.initialValue,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? initialValue;
  final int? maxLength;
  final int? minLength;
  final int? maxLines;
  final double? height;
  final int minLines;
  final Color? cursorColor;
  final bool dense;
  final String? hintText;
  final String? errorText;
  final String? labelText;
  final String? counterText;
  final String? lengthErrorText;
  final bool enabled;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? fontSize;
  final String? prefixText;
  final String? suffixText;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final bool readOnly;
  final bool obscureText;
  final bool expands;
  final bool allowEmpty;
  final TextStyle? textStyle;
  final InputBorder? border;
  final InputBorder? disabledBorder;
  final InputBorder? errorBorder;
  final List<String> suggestion;
  final Color? backgroundColor;
  final void Function(String value)? onDeleteSuggestion;
  final void Function(String? value)? onSaved;
  final void Function(String? value)? onChanged;
  final String? Function(String? value)? validator;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final Color? color;
  final Color? subColor;
  final Color? errorColor;
  final double? helperFontSize;
  final bool? showCursor;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String? value)? onSubmitted;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;

  @override
  State<StatefulWidget> createState() => _FormItemTextFieldState();
}

class _FormItemTextFieldState extends State<FormItemTextField> {
  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = TextEditingController(text: widget.initialValue);
    }
    _effectiveController?.addListener(_handledOnUpdate);
  }

  @override
  void didUpdateWidget(FormItemTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handledOnUpdate);
      widget.controller?.addListener(_handledOnUpdate);
    }
    if (oldWidget.initialValue != widget.initialValue &&
        widget.initialValue != null) {
      _effectiveController?.text = widget.initialValue!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _effectiveController?.removeListener(_handledOnUpdate);
    _controller?.dispose();
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final mainTextStyle = widget.textStyle?.copyWith(
          color: widget.color,
          fontSize: widget.fontSize,
        ) ??
        TextStyle(
          color: widget.color ?? context.theme.textColor,
          fontSize: widget.fontSize,
        );
    final subTextStyle = widget.textStyle?.copyWith(
          color: widget.subColor,
          fontSize: widget.fontSize,
        ) ??
        TextStyle(
          color: widget.subColor ??
              widget.color?.withOpacity(0.5) ??
              context.theme.textColor.withOpacity(0.5),
          fontSize: widget.fontSize,
        );
    final errorTextStyle = widget.textStyle?.copyWith(
          color: widget.errorColor,
          fontSize: widget.helperFontSize,
        ) ??
        TextStyle(
          color: widget.errorColor ?? context.theme.errorColor,
          fontSize: widget.helperFontSize,
        );

    return SuggestionOverlayBuilder(
      items: widget.suggestion,
      onDeleteSuggestion: widget.onDeleteSuggestion,
      controller: widget.controller,
      focusNode: widget.focusNode,
      builder: (context, controller, onTap) => Container(
        height: widget.height,
        padding: widget.padding ??
            (widget.dense
                ? const EdgeInsets.symmetric(vertical: 20)
                : const EdgeInsets.symmetric(vertical: 10)),
        child: TextFormField(
          key: widget.key,
          cursorColor: widget.cursorColor,
          inputFormatters: widget.inputFormatters,
          focusNode: widget.focusNode,
          textAlign: widget.textAlign,
          textAlignVertical: widget.textAlignVertical,
          showCursor: widget.showCursor,
          enabled: widget.enabled,
          controller: controller,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          maxLines: widget.obscureText
              ? 1
              : (widget.expands ? null : widget.maxLines),
          minLines: widget.obscureText
              ? 1
              : (widget.expands ? null : widget.minLines),
          expands: !widget.obscureText && widget.expands,
          decoration: InputDecoration(
            contentPadding: widget.contentPadding ??
                (widget.dense
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 0)
                    : null),
            fillColor: widget.backgroundColor,
            filled: widget.backgroundColor != null,
            isDense: widget.dense,
            border: widget.border ??
                OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide(),
                ),
            enabledBorder: widget.border ??
                OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide(),
                ),
            disabledBorder: widget.disabledBorder ??
                widget.border ??
                OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide(),
                ),
            errorBorder: widget.errorBorder ??
                widget.border ??
                OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide(),
                  gapPadding: 0,
                ),
            focusedBorder: widget.border ??
                OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide(),
                ),
            focusedErrorBorder: widget.errorBorder ??
                widget.border ??
                OutlineInputBorder(
                  borderSide:
                      widget.dense ? BorderSide.none : const BorderSide(),
                ),
            hintText: widget.hintText,
            labelText: widget.labelText,
            counterText: widget.counterText,
            prefix: widget.prefix,
            suffix: widget.suffix,
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            prefixIconConstraints: widget.prefixIconConstraints,
            suffixIconConstraints: widget.suffixIconConstraints,
            labelStyle: mainTextStyle,
            hintStyle: subTextStyle,
            suffixStyle: subTextStyle,
            prefixStyle: subTextStyle,
            counterStyle: subTextStyle,
            helperStyle: subTextStyle,
            errorStyle: errorTextStyle,
          ),
          style: mainTextStyle,
          obscureText: widget.obscureText,
          readOnly: widget.readOnly,
          onFieldSubmitted: (value) {
            widget.onSubmitted?.call(value);
          },
          onTap: widget.enabled
              ? () {
                  if (widget.onTap != null) {
                    widget.onTap?.call();
                  } else {
                    onTap.call();
                  }
                }
              : null,
          validator: (value) {
            if (!widget.allowEmpty &&
                widget.errorText.isNotEmpty &&
                value.isEmpty) {
              return widget.errorText;
            }
            if (!widget.allowEmpty &&
                widget.lengthErrorText.isNotEmpty &&
                widget.minLength.def(0) > value.length) {
              return widget.lengthErrorText;
            }
            return widget.validator?.call(value);
          },
          onChanged: widget.onChanged,
          onSaved: (value) {
            if (!widget.allowEmpty && value.isEmpty) {
              return;
            }
            widget.onSaved?.call(value);
          },
        ),
      ),
    );
  }
}
