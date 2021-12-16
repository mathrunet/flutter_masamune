part of masamune.form;

class FormItemMultipleDropdownField extends FormField<List<String>> {
  FormItemMultipleDropdownField({
    this.onChanged,
    this.controller,
    this.hintText,
    this.errorText,
    required this.items,
    this.border,
    this.backgroundColor,
    this.dense = false,
    this.labelText,
    this.prefix,
    this.allowEmpty = false,
    this.suffix,
    this.counterText = "",
    this.separator = ",",
    this.addLabel = "Add",
    Key? key,
    void Function(List<String>? value)? onSaved,
    String? Function(List<String>? value)? validator,
    List<String>? initialValue,
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

  final String addLabel;
  final TextEditingController? controller;
  final String? hintText;
  final String separator;
  final String? errorText;
  final String? labelText;
  final String? counterText;
  final Map<String, String> items;
  final Widget? prefix;
  final Widget? suffix;
  final bool dense;
  final InputBorder? border;
  final bool allowEmpty;
  final Color? backgroundColor;
  final void Function(List<String>? value)? onChanged;

  @override
  _FormItemMultipleDropdownFieldState createState() =>
      _FormItemMultipleDropdownFieldState();
}

class _FormItemMultipleDropdownFieldState extends FormFieldState<List<String>> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemMultipleDropdownField get widget =>
      super.widget as FormItemMultipleDropdownField;

  String _encode(List<String> list) {
    return list.join(widget.separator);
  }

  List<String> _decode(String? value) {
    if (value.isEmpty) {
      return [];
    }
    return value!.split(widget.separator);
  }

  @override
  void didUpdateWidget(FormItemMultipleDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(_decode(widget.controller?.text ?? ""));
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
      _controller = TextEditingController();
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
    setValue(_decode(_effectiveController?.text ?? ""));
  }

  Future<void> _onAdd() async {
    didChange(List.from(value ?? [])..add(""));
    setState(() {});
  }

  void _onRemove(int index) {
    assert(index >= 0 && index < value.length, "The value of Index is wrong.");
    value?.removeAt(index);
    didChange(List.from(value ?? []));
    setState(() {});
  }

  Widget _builder(BuildContext context, String item, int index) {
    return ListTile(
      title: FormItemDropdownField(
        padding: const EdgeInsets.all(0),
        controller: TextEditingController(text: item),
        hintText: widget.hintText,
        errorText: widget.errorText,
        labelText: widget.labelText,
        counterText: widget.counterText,
        items: widget.items,
        prefix: widget.prefix,
        suffix: widget.suffix,
        enabled: widget.enabled,
        dense: widget.dense,
        border: widget.border,
        allowEmpty: widget.allowEmpty,
        backgroundColor: widget.backgroundColor,
        onChanged: (val) {
          value?[index] = val ?? "";
          didChange(List.from(value ?? []));
        },
        contentPadding: const EdgeInsets.all(0),
      ),
      trailing: IconButton(
        onPressed: () {
          _onRemove(index);
        },
        color: context.theme.textColor,
        icon: const Icon(Icons.close),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ReorderableListBuilder<String>(
            source: value ?? [],
            builder: (context, item, index) {
              return [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _builder(context, item, index),
                ),
              ];
            },
            onReorder: (o, n, item, reordered) {
              didChange(reordered);
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          ListTile(
            onTap: () {
              _onAdd();
            },
            title: Text(widget.addLabel.localize(), textAlign: TextAlign.right),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: context.theme.textColor,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChange(List<String>? value) {
    super.didChange(value);
    if (this.value != value) {
      value ??= [];
      _effectiveController?.text = _encode(value);
      setValue(value);
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
          widget.initialValue?.toString().toLowerCase() ?? "";
    });
  }

  void _handleControllerChanged() {
    final value = _decode(_effectiveController?.text ?? "");
    if (this.value != value) {
      didChange(value);
    }
  }
}
