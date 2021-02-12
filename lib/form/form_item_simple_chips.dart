part of masamune.form;

class FormItemSimpleChips extends FormField<String> {
  FormItemSimpleChips({
    Key? key,
    this.controller,
    this.maxChips,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.contentPadding,
    this.separatePadding = const EdgeInsets.only(right: 5),
    this.color,
    this.subColor,
    this.dialogLabelText = "Tag",
    this.backgroundColor,
    this.dense = false,
    this.labelText = "",
    this.border,
    this.disabledBorder,
    this.separator = ",",
    required this.chipBuilder,
    required this.additioanlChipBuilder,
    this.onChanged,
    void Function(List<String> values)? onSaved,
    String? Function(String? value)? validator,
    this.initialItems,
    bool enabled = true,
  }) : super(
          key: key,
          builder: (state) {
            return const Empty();
          },
          onSaved: (value) {
            if (value.isEmpty) {
              return;
            }
            onSaved?.call(value?.split(separator) ?? const []);
          },
          validator: validator,
          initialValue: initialItems?.join(separator),
          enabled: enabled,
        );

  final TextEditingController? controller;
  final String separator;
  final Widget Function(BuildContext context, _FormItemSimpleChipsState state,
      String key, bool selected) chipBuilder;

  final Widget? Function(BuildContext context, _FormItemSimpleChipsState state)
      additioanlChipBuilder;
  final List<String>? initialItems;
  final void Function(List<String> values)? onChanged;
  final int? maxChips;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry separatePadding;
  final Color? color;
  final Color? subColor;
  final String dialogLabelText;
  final Color? backgroundColor;
  final bool dense;
  final String labelText;
  final InputBorder? border;
  final InputBorder? disabledBorder;
  @override
  _FormItemSimpleChipsState createState() => _FormItemSimpleChipsState();
}

class _FormItemSimpleChipsState extends FormFieldState<String> {
  Map<String, bool> _chips = <String, bool>{};
  TextEditingController? _controller;
  final FocusNode _focusNode = FocusNode();

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;
  @override
  FormItemSimpleChips get widget => super.widget as FormItemSimpleChips;

  void deleteChip(String tag) {
    if (tag.isEmpty) {
      return;
    }
    if (!_chips.containsKey(tag)) {
      return;
    }
    if (widget.initialItems.contains(tag)) {
      return;
    }
    _chips.remove(tag);
    final list =
        _chips.toList((key, value) => value ? key : null).removeEmpty();
    widget.onChanged?.call(list);
    setValue(list.join(widget.separator));
    setState(() {});
  }

  void selectChip(String tag) {
    if (tag.isEmpty) {
      return;
    }
    if (!_chips.containsKey(tag)) {
      return;
    }
    if (_chips.get(tag).def(false)) {
      _chips[tag] = false;
    } else {
      _chips[tag] = true;
    }
    final list =
        _chips.toList((key, value) => value ? key : null).removeEmpty();
    widget.onChanged?.call(list);
    setValue(list.join(widget.separator));
    setState(() {});
  }

  Future<void> addChip() async {
    UISimpleFormDialog.show(
      context,
      submitBackgroundColor: context.theme.primaryColor,
      builder: (context, form) {
        return FormItemTextField(
          allowEmpty: true,
          labelText: widget.dialogLabelText.localize(),
          controller: TextEditingController(),
          onSaved: (value) {
            form["tag"] = value;
          },
        );
      },
      onSubmit: (form) {
        final text = form.get<String>("tag") ?? "";
        if (text.isEmpty) {
          return;
        }
        _chips[text] = true;
        final list =
            _chips.toList((key, value) => value ? key : null).removeEmpty();
        widget.onChanged?.call(list);
        setValue(list.join(widget.separator));
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final additional = widget.additioanlChipBuilder(context, this);
    return Padding(
      padding: widget.dense ? const EdgeInsets.all(0) : widget.padding,
      child: InputDecorator(
        decoration: InputDecoration(
          contentPadding: widget.contentPadding,
          fillColor: widget.backgroundColor,
          filled: widget.backgroundColor != null,
          isDense: widget.dense,
          border: widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          enabledBorder: widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          disabledBorder: widget.disabledBorder ??
              widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          errorBorder: widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          focusedBorder: widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          focusedErrorBorder: widget.border ??
              OutlineInputBorder(
                borderSide: widget.dense ? BorderSide.none : const BorderSide(),
              ),
          labelText: widget.labelText,
          labelStyle: TextStyle(color: widget.color),
          hintStyle: TextStyle(color: widget.subColor),
          suffixStyle: TextStyle(color: widget.subColor),
          prefixStyle: TextStyle(color: widget.subColor),
          counterStyle: TextStyle(color: widget.subColor),
          helperStyle: TextStyle(color: widget.subColor),
        ),
        isEmpty: false,
        isFocused: true,
        child: Wrap(
          children: [
            ..._chips.toList((key, value) {
              final tmp = widget.chipBuilder(context, this, key, value);
              return Padding(
                padding: widget.separatePadding,
                child: tmp,
              );
            }).removeEmpty(),
            if (additional != null)
              Padding(
                padding: widget.separatePadding,
                child: additional,
              )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _chips = widget.initialItems
            ?.toMap(key: (key) => key, value: (value) => false) ??
        const {};
    _focusNode.addListener(_handleFocus);
    if (widget.controller == null) {
      _controller = TextEditingController(text: widget.initialValue);
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
  }

  @override
  void didUpdateWidget(FormItemSimpleChips oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(widget.controller?.text);
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.removeListener(_handleFocus);
  }

  void _handleFocus() {
    if (!_focusNode.hasFocus) {
      return;
    }
  }

  void _handleControllerChanged() {
    if (_effectiveController?.text != value)
      didChange(_effectiveController?.text);
  }
}
