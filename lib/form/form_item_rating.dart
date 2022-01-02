part of masamune.form;

class FormItemRating extends FormField<double> {
  FormItemRating({
    this.controller,
    this.count = 5,
    this.size = 40,
    this.readOnly = false,
    this.onChanged,
    this.activeColor,
    this.inaciveColor,
    this.minRating,
    this.maxRating,
    this.itemBuilder,
    this.allowHalfRating = true,
    this.tapOnlyMode = false,
    this.padding = const EdgeInsets.all(8),
    this.direction = Axis.horizontal,
    this.showLabel = false,
    this.labelTextStyle,
    this.format = "0.#",
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

  final bool tapOnlyMode;
  final bool allowHalfRating;
  final TextStyle? labelTextStyle;
  final bool showLabel;
  final Color? activeColor;
  final double? minRating;
  final double? maxRating;
  final EdgeInsetsGeometry padding;
  final Color? inaciveColor;
  final String format;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final int count;
  final double size;
  final bool readOnly;
  final Axis direction;
  final void Function(double value)? onChanged;
  final TextEditingController? controller;

  @override
  _FormItemRatingState createState() => _FormItemRatingState();
}

class _FormItemRatingState extends FormFieldState<double> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemRating get widget => super.widget as FormItemRating;

  @override
  void didUpdateWidget(FormItemRating oldWidget) {
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
    if (widget.readOnly != oldWidget.readOnly) {
      setState(() {});
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
    final min = widget.minRating ?? 1.0;
    if (widget.readOnly) {
      return RatingBarIndicator(
        rating: value ?? min,
        itemBuilder: (context, index) {
          if (widget.itemBuilder != null) {
            return widget.itemBuilder!.call(context, index);
          }
          return Icon(Icons.star, color: widget.activeColor ?? Colors.amber);
        },
        unratedColor: widget.inaciveColor,
        direction: widget.direction,
        itemSize: widget.size,
        itemCount: widget.count,
      );
    } else {
      return RatingBar.builder(
        minRating: min,
        maxRating: widget.maxRating ?? widget.count.toDouble(),
        itemBuilder: (context, index) {
          if (widget.itemBuilder != null) {
            return widget.itemBuilder!.call(context, index);
          }
          return Icon(Icons.star, color: widget.activeColor ?? Colors.amber);
        },
        onRatingUpdate: (value) {
          widget.onChanged?.call(value);
          setValue(value);
          if (_parse(_effectiveController?.text ?? "") != value) {
            _effectiveController?.text = value.toString();
          }
        },
        tapOnlyMode: widget.tapOnlyMode,
        initialRating: value ?? min,
        allowHalfRating: widget.allowHalfRating,
        unratedColor: widget.inaciveColor,
        direction: widget.direction,
        itemSize: widget.size,
        itemCount: widget.count,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final min = widget.minRating ?? 1.0;
    if (widget.showLabel) {
      return Padding(
        padding: widget.padding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: widget.showLabel ? MainAxisSize.max : MainAxisSize.min,
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
      return Padding(padding: widget.padding, child: _build(context));
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
