part of masamune.form;

class FormItemSlider extends FormField<double> {
  FormItemSlider({
    this.controller,
    this.readOnly = false,
    this.onChanged,
    this.activeColor,
    this.inaciveColor,
    this.thumbColor,
    this.min,
    this.max,
    this.divisions,
    this.padding = const EdgeInsets.all(8),
    this.focusNode,
    this.format = "0.##",
    this.showLabel = false,
    this.labelTextStyle,
    Key? key,
    void Function(double? value)? onSaved,
    String? Function(double? value)? validator,
    num? initialValue,
    bool enabled = true,
  }) : super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue?.toDouble(),
          enabled: enabled,
        );

  final Color? activeColor;
  final TextStyle? labelTextStyle;
  final bool showLabel;
  final String format;
  final double? min;
  final double? max;
  final int? divisions;
  final EdgeInsetsGeometry padding;
  final Color? inaciveColor;
  final bool readOnly;
  final FocusNode? focusNode;
  final Color? thumbColor;
  final void Function(double value)? onChanged;
  final TextEditingController? controller;

  @override
  _FormItemSliderState createState() => _FormItemSliderState();
}

class _FormItemSliderState extends FormFieldState<double> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemSlider get widget => super.widget as FormItemSlider;

  @override
  void didUpdateWidget(FormItemSlider oldWidget) {
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
    if (widget.initialValue != oldWidget.initialValue) {
      didChange(widget.initialValue);
    }
  }

  double? _parse(String text) {
    if (text.isEmpty) {
      return 0.0;
    }
    return double.tryParse(text);
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller =
          TextEditingController(text: (widget.initialValue ?? 0.0).toString());
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
    setValue(_parse(_effectiveController?.text ?? ""));
  }

  Widget _build(BuildContext context) {
    final min = widget.min ?? 0.0;
    final max = widget.max ?? 1.0;
    return Slider(
      value: value ?? min,
      onChanged: (value) {
        if (widget.readOnly) {
          return;
        }
        widget.onChanged?.call(value);
        didChange(value);
      },
      label: (value ?? min).format(widget.format),
      min: min,
      max: max,
      divisions: widget.divisions,
      activeColor: widget.activeColor,
      inactiveColor: widget.inaciveColor,
      thumbColor: widget.thumbColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final min = widget.min ?? 0.0;
    if (widget.showLabel) {
      return Padding(
        padding: widget.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: _build(context),
            ),
            if (widget.showLabel)
              Text(
                (value ?? min).format(widget.format),
                textAlign: TextAlign.end,
                style: widget.labelTextStyle,
              ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: widget.padding,
        child: _build(context),
      );
    }
  }

  @override
  void didChange(double? value) {
    super.didChange(value);
    if (_parse(_effectiveController?.text ?? "") != value) {
      _effectiveController?.text = value?.toString() ?? "";
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
      _effectiveController?.text = widget.initialValue?.toString() ?? "";
    });
  }

  void _handleControllerChanged() {
    final parsed = _parse(_effectiveController?.text ?? "");
    if (parsed != value) {
      didChange(parsed);
    }
  }
}
