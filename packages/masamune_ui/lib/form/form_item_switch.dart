part of masamune_ui.form;

class FormItemSwitch extends FormField<bool> {
  FormItemSwitch({
    this.controller,
    this.leading,
    this.dense = false,
    this.backgroundColor,
    this.borderColor,
    this.color,
    this.type = FormItemSwitchType.form,
    this.onChanged,
    this.activeColor,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
    this.margin,
    this.inactiveTrackColor,
    this.hintText,
    this.labelText,
    Key? key,
    void Function(bool? value)? onSaved,
    String? Function(bool? value)? validator,
    bool? initialValue,
    bool enabled = true,
  }) : super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          enabled: enabled,
        );

  final TextEditingController? controller;
  final FormItemSwitchType type;
  final void Function(bool? value)? onChanged;
  final Color? activeColor;
  final bool dense;
  final Color? activeTrackColor;
  final Color? inactiveThumbColor;
  final Color? inactiveTrackColor;
  final Color? color;
  final Color? backgroundColor;
  final Color? borderColor;
  final Widget? leading;
  final String? hintText;
  final String? labelText;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  @override
  _FormItemSwitchState createState() => _FormItemSwitchState();
}

class _FormItemSwitchState extends FormFieldState<bool> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemSwitch get widget => super.widget as FormItemSwitch;

  @override
  void didUpdateWidget(FormItemSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(_parse(widget.controller?.text ?? "false"));
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
    setValue(_parse(_effectiveController?.text ?? "false"));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    switch (widget.type) {
      case FormItemSwitchType.form:
        return Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(
              color: widget.borderColor ?? Theme.of(context).disabledColor,
              style: widget.dense ? BorderStyle.none : BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(4.0),
          ),
          margin: widget.margin ??
              (widget.dense
                  ? const EdgeInsets.all(0)
                  : const EdgeInsets.symmetric(vertical: 10)),
          padding: widget.padding,
          child: Row(
            children: [
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
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Switch(
                    value: value ?? false,
                    activeColor: widget.activeColor,
                    activeTrackColor: widget.activeTrackColor,
                    inactiveThumbColor: widget.inactiveThumbColor,
                    inactiveTrackColor: widget.inactiveTrackColor,
                    onChanged: (bool value) {
                      setValue(value);
                      widget.onChanged?.call(value);
                      setState(() {});
                    },
                  ),
                ),
              )
            ],
          ),
        );
      default:
        return SwitchListTile(
          dense: widget.dense,
          activeColor: widget.activeColor,
          activeTrackColor: widget.activeTrackColor,
          inactiveThumbColor: widget.inactiveThumbColor,
          inactiveTrackColor: widget.inactiveTrackColor,
          onChanged: (bool value) {
            setValue(value);
            widget.onChanged?.call(value);
            setState(() {});
          },
          title: UIMarkdown(widget.labelText ?? "", color: widget.color),
          subtitle: errorText.isNotEmpty
              ? Text(
                  errorText ?? "",
                  style: context.theme.inputDecorationTheme.errorStyle,
                )
              : (widget.hintText.isNotEmpty
                  ? UIMarkdown(widget.hintText ?? "", color: widget.color)
                  : null),
          secondary: widget.leading,
          value: value ?? false,
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

enum FormItemSwitchType { list, form }
