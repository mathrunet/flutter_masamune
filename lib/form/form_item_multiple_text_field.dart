part of masamune.form;

class FormItemMultipleTextField extends FormField<List<String>> {
  FormItemMultipleTextField({
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.onTap,
    this.minLength,
    this.contentPadding,
    this.maxLines,
    this.minLines = 1,
    this.border,
    this.disabledBorder,
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
    this.padding,
    this.allowEmpty = false,
    this.obscureText = false,
    this.counterText = "",
    this.inputFormatters,
    this.onSubmitted,
    this.onChanged,
    this.showCursor,
    this.focusNode,
    this.color,
    this.fontSize,
    this.subColor,
    this.height,
    this.errorText,
    this.cursorColor,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
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
  final String separator;
  final TextEditingController? controller;
  final TextInputType keyboardType;
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
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? fontSize;
  final String? prefixText;
  final String? suffixText;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final bool obscureText;
  final bool expands;
  final bool allowEmpty;
  final InputBorder? border;
  final InputBorder? disabledBorder;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final Color? color;
  final Color? subColor;
  final bool? showCursor;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String? value)? onSubmitted;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final void Function(List<String>? value)? onChanged;

  @override
  _FormItemMultipleTextFieldState createState() =>
      _FormItemMultipleTextFieldState();
}

class _FormItemMultipleTextFieldState extends FormFieldState<List<String>> {
  TextEditingController? _controller;
  final List<_FormItemMultipleTextFieldValue> _values = [];

  void _updateValues() {
    _values.clear();
    for (final val in value ?? []) {
      _values.add(_FormItemMultipleTextFieldValue(val));
    }
  }

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemMultipleTextField get widget =>
      super.widget as FormItemMultipleTextField;

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
  void didUpdateWidget(FormItemMultipleTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(_decode(widget.controller?.text ?? ""));
        _updateValues();
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
    _updateValues();
  }

  Future<void> _onAdd() async {
    _values.add(_FormItemMultipleTextFieldValue(""));
    didChange(List.from(value ?? [])..add(""));
    setState(() {});
  }

  void _onRemove(int index) {
    assert(index >= 0 && index < value.length, "The value of Index is wrong.");
    value?.removeAt(index);
    _values.removeAt(index);
    didChange(List.from(value ?? []));
    setState(() {});
  }

  Widget _builder(
      BuildContext context, _FormItemMultipleTextFieldValue item, int index) {
    return ListTile(
      title: FormItemTextField(
        padding: const EdgeInsets.all(0),
        controller: item.controller,
        keyboardType: widget.keyboardType,
        maxLength: widget.maxLength,
        onTap: widget.onTap,
        minLength: widget.minLength,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        border: widget.border,
        disabledBorder: widget.disabledBorder,
        backgroundColor: widget.backgroundColor,
        expands: widget.expands,
        hintText: widget.hintText,
        labelText: widget.labelText,
        lengthErrorText: widget.lengthErrorText,
        prefix: widget.prefix,
        suffix: widget.suffix,
        prefixText: widget.prefixText,
        suffixText: widget.suffixText,
        prefixIcon: widget.prefixIcon,
        prefixIconConstraints: widget.prefixIconConstraints,
        suffixIcon: widget.suffixIcon,
        suffixIconConstraints: widget.suffixIconConstraints,
        dense: widget.dense,
        allowEmpty: widget.allowEmpty,
        readOnly: false,
        obscureText: widget.obscureText,
        counterText: widget.counterText,
        inputFormatters: widget.inputFormatters,
        onSubmitted: widget.onSubmitted,
        showCursor: widget.showCursor,
        focusNode: widget.focusNode,
        color: widget.color,
        fontSize: widget.fontSize,
        subColor: widget.subColor,
        height: widget.height,
        errorText: widget.errorText,
        cursorColor: widget.cursorColor,
        textAlign: widget.textAlign,
        textAlignVertical: widget.textAlignVertical,
        onChanged: (val) {
          value?[index] = val ?? "";
          _values[index].value = val ?? "";
          setValue(List.from(value ?? []));
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
          ReorderableListBuilder<_FormItemMultipleTextFieldValue>(
            source: _values,
            builder: (context, item, index) {
              return [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _builder(context, item, index),
                ),
              ];
            },
            onReorder: (o, n, item, reordered) {
              context.unfocus();
              didChange(reordered.map((e) => e.value).toList());
              _updateValues();
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
    _values.forEach((element) => element.controller.dispose());
    _values.clear();
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
      _updateValues();
    }
  }
}

class _FormItemMultipleTextFieldValue {
  _FormItemMultipleTextFieldValue(this.value)
      : controller = TextEditingController(text: value);
  String value;
  TextEditingController controller;
}
