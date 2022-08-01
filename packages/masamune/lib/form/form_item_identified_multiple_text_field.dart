part of masamune.form;

class FormItemIdentifiedMultipleTextField
    extends FormField<Map<String, String>> {
  FormItemIdentifiedMultipleTextField({
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.onTap,
    this.minLength,
    this.contentPadding,
    this.maxLines,
    this.minLines = 1,
    this.minItems,
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
    this.addLabel = "Add",
    Key? key,
    void Function(Map<String, String>? value)? onSaved,
    String? Function(Map<String, String>? value)? validator,
    Map<String, String>? initialValue,
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
  final int? minItems;
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
  final void Function(Map<String, String>? value)? onSubmitted;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final void Function(Map<String, String>? value)? onChanged;

  @override
  _FormItemIdentifiedMultipleTextFieldState createState() =>
      _FormItemIdentifiedMultipleTextFieldState();
}

class _FormItemIdentifiedMultipleTextFieldState
    extends FormFieldState<Map<String, String>> {
  TextEditingController? _controller;
  final List<_FormItemIdentifiedMultipleTextFieldValue> _values = [];

  void _updateValues() {
    _values.clear();
    for (final val in value?.entries ?? <MapEntry<String, String>>[]) {
      _values
          .add(_FormItemIdentifiedMultipleTextFieldValue(val.key, val.value));
    }
  }

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemIdentifiedMultipleTextField get widget =>
      super.widget as FormItemIdentifiedMultipleTextField;

  String _encode(Map<String, String> map) {
    return jsonEncode(map);
  }

  Map<String, String> _decode(String? value) {
    if (value.isEmpty) {
      return {};
    }
    return jsonDecodeAsMap(value!).map(
      (key, value) => MapEntry(key, value.toString()),
    );
  }

  @override
  void didUpdateWidget(FormItemIdentifiedMultipleTextField oldWidget) {
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
    if (widget.minItems != null) {
      final _value = value ?? {};
      while (widget.minItems! > _values.length) {
        final uid = uuid;
        _values.add(_FormItemIdentifiedMultipleTextFieldValue(uid, ""));
        _value[uid] = "";
      }
      setValue(_value);
    }
  }

  Future<void> _onAdd() async {
    final uid = uuid;
    _values.add(_FormItemIdentifiedMultipleTextFieldValue(uid, ""));
    didChange(Map.from(value ?? {})..addAll({uid: ""}));
    setState(() {});
  }

  void _onRemove(String key) {
    assert(
      key.isNotEmpty && value.containsKey(key),
      "The value of key is wrong.",
    );
    value?.remove(key);
    _values.removeWhere((e) => e.key == key);
    didChange(Map.from(value ?? {}));
    setState(() {});
  }

  Widget _builder(
    BuildContext context,
    _FormItemIdentifiedMultipleTextFieldValue item,
    int index,
  ) {
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
        onSubmitted: (_) {
          widget.onSubmitted?.call(value);
        },
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
          value?[item.key] = val ?? "";
          final field = _values.firstWhereOrNull((e) => e.key == item.key);
          if (field == null) {
            _values.add(
              _FormItemIdentifiedMultipleTextFieldValue(item.key, val ?? ""),
            );
          } else {
            field.value = val ?? "";
          }
          setValue(Map.from(value ?? {}));
        },
        contentPadding: const EdgeInsets.all(0),
      ),
      trailing: widget.minItems != null && index < widget.minItems!
          ? null
          : IconButton(
              onPressed: () {
                _onRemove(item.key);
              },
              color: widget.color ?? context.theme.textColor,
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
          ReorderableListBuilder<_FormItemIdentifiedMultipleTextFieldValue>(
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
              didChange(
                reordered.toMap((e) => MapEntry(e.key, e.value)),
              );
              _updateValues();
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          ),
          ListTile(
            onTap: () {
              _onAdd();
            },
            title: Text(
              widget.addLabel.localize(),
              textAlign: TextAlign.right,
              style: TextStyle(color: widget.color),
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add,
                    color: widget.color ?? context.theme.textColor,
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
  void didChange(Map<String, String>? value) {
    super.didChange(value);
    if (this.value != value) {
      value ??= {};
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

class _FormItemIdentifiedMultipleTextFieldValue {
  _FormItemIdentifiedMultipleTextFieldValue(this.key, this.value)
      : controller = TextEditingController(text: value);
  String key;
  String value;
  TextEditingController controller;
}
