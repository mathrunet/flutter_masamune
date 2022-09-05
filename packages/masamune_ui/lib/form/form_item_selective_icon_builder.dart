part of masamune_ui.form;

class FormItemSelectiveIconBuilder extends FormField<String> {
  FormItemSelectiveIconBuilder({
    required List<Widget> Function(
      BuildContext context,
      Map<String, Widget> items,
      String selected,
      void Function(String value) onSelect,
    )
        builder,
    String? initialValue,
    this.controller,
    required this.items,
    this.onPressed,
    this.padding,
    Key? key,
    this.space = 8.0,
    void Function(String? value)? onSaved,
    this.onChanged,
    String? Function(String? value)? validator,
    bool enabled = true,
    this.readOnly = false,
  })  : _builder = builder,
        super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: readOnly ? null : onSaved,
          validator: readOnly ? null : validator,
          initialValue: controller != null ? controller.text : initialValue,
          enabled: enabled,
        );

  final double space;
  final void Function(String? value)? onChanged;
  final Map<String, Widget> items;
  final bool readOnly;
  final EdgeInsetsGeometry? padding;
  final TextEditingController? controller;
  final List<Widget> Function(
    BuildContext context,
    Map<String, Widget> items,
    String selected,
    void Function(String value) onSelect,
  ) _builder;
  final void Function(
    void Function(dynamic fileOrURL, AssetType type) onUpdate,
  )? onPressed;

  @override
  _FormItemSelectiveIconBuilderState createState() =>
      _FormItemSelectiveIconBuilderState();
}

class _FormItemSelectiveIconBuilderState extends FormFieldState<String> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemSelectiveIconBuilder get widget =>
      super.widget as FormItemSelectiveIconBuilder;

  @override
  void didUpdateWidget(FormItemSelectiveIconBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(_effectiveController?.text);
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
    setValue(_effectiveController?.text);
  }

  void _onSelect(String value) {
    if (widget.readOnly) {
      return;
    }
    if (this.value != value) {
      didChange(value);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget._builder
            .call(context, widget.items, value ?? "", _onSelect)
            .insertEvery(Space(width: widget.space), 1)
            .toList(),
      ),
    );
  }

  @override
  void didChange(String? value) {
    super.didChange(value);
    widget.onChanged?.call(value);
    if (_effectiveController?.text != value) {
      _effectiveController?.text = value ?? "";
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
      _effectiveController?.text = widget.initialValue ?? "";
    });
  }

  void _handleControllerChanged() {
    if (_effectiveController?.text != value)
      didChange(_effectiveController?.text);
  }
}
