part of masamune.form;

class FormItemCheckbox extends FormField<bool> {
  FormItemCheckbox({
    this.controller,
    this.leading,
    this.dense = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    this.type = FormItemCheckboxType.form,
    this.onChanged,
    this.backgroundColor,
    this.borderColor,
    this.color,
    this.activeColor,
    this.checkColor,
    this.hintText,
    this.errorText,
    this.labelText,
    this.needToCheck = false,
    this.linkTextStyle,
    this.checkboxWidth = 48,
    Key? key,
    void Function(bool? value)? onSaved,
    String? Function(bool? value)? validator,
    bool initialValue = false,
    bool enabled = true,
  }) : super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: onSaved,
          validator: (value) {
            if (needToCheck && !(value ?? false)) {
              return errorText;
            }
            return validator?.call(value);
          },
          initialValue: initialValue,
          enabled: enabled,
        );

  final TextEditingController? controller;
  final FormItemCheckboxType type;
  final bool needToCheck;
  final void Function(bool? value)? onChanged;
  final Color? activeColor;
  final bool dense;
  final Color? checkColor;
  final Widget? leading;
  final String? hintText;
  final String? errorText;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final String? labelText;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final TextStyle? linkTextStyle;
  final double checkboxWidth;
  @override
  _FormItemCheckboxState createState() => _FormItemCheckboxState();
}

class _FormItemCheckboxState extends FormFieldState<bool> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemCheckbox get widget => super.widget as FormItemCheckbox;

  @override
  void didUpdateWidget(FormItemCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(_parse(widget.controller?.text ?? ""));
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  bool _parse(String text) {
    if (text.isEmpty) {
      return false;
    }
    if (text.toLowerCase() == "true") {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController();
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
    setValue(_parse(_effectiveController?.text ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    switch (widget.type) {
      case FormItemCheckboxType.form:
        return Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(
              color: widget.borderColor ?? Theme.of(context).disabledColor,
              style: widget.dense ? BorderStyle.none : BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          margin: widget.dense ? const EdgeInsets.all(0) : widget.margin,
          padding: widget.padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: widget.checkboxWidth,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Checkbox(
                    value: value,
                    side: widget.color != null
                        ? BorderSide(color: widget.color!)
                        : null,
                    activeColor: widget.activeColor,
                    checkColor: widget.checkColor,
                    onChanged: (bool? value) {
                      setValue(value);
                      if (widget.onChanged != null) {
                        widget.onChanged?.call(value);
                      }
                      setState(() {});
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UIMarkdown(
                      widget.labelText ?? "",
                      color: widget.enabled
                          ? widget.color
                          : Theme.of(context).disabledColor,
                      linkTextStyle: widget.linkTextStyle,
                    ),
                    if (errorText.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          errorText ?? "",
                          style: context.theme.inputDecorationTheme.errorStyle,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      default:
        return CheckboxListTile(
          dense: widget.dense,
          activeColor: widget.activeColor,
          checkColor: widget.checkColor,
          onChanged: (bool? value) {
            setValue(value);
            widget.onChanged?.call(value);
            setState(() {});
          },
          title: UIMarkdown(
            widget.labelText ?? "",
            color: widget.color,
            linkTextStyle: widget.linkTextStyle,
          ),
          subtitle: errorText.isNotEmpty
              ? Text(
                  errorText ?? "",
                  style: context.theme.inputDecorationTheme.errorStyle,
                )
              : widget.hintText.isNotEmpty
                  ? UIMarkdown(widget.hintText!, color: widget.color)
                  : null,
          secondary: widget.leading,
          value: value,
        );
    }
  }

  @override
  void didChange(bool? value) {
    super.didChange(value);
    if (_parse(_effectiveController?.text ?? "false") != value) {
      _effectiveController?.text = value?.toString().toLowerCase() ?? "false";
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController?.text =
          widget.initialValue?.toString().toLowerCase() ?? "false";
    });
  }

  void _handleControllerChanged() {
    final parsed = _parse(_effectiveController?.text ?? "false");
    if (parsed != value) {
      didChange(parsed);
    }
  }
}

enum FormItemCheckboxType { list, form }
