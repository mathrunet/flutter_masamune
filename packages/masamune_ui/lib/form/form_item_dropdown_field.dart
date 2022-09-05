part of masamune_ui.form;

class FormItemDropdownField extends StatelessWidget implements FormItem {
  const FormItemDropdownField({
    this.controller,
    this.hintText,
    this.errorText,
    required this.items,
    this.enabled = true,
    this.border,
    this.padding,
    this.backgroundColor,
    this.dense = false,
    this.labelText,
    this.contentPadding,
    this.prefix,
    this.suffix,
    this.allowEmpty = false,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.counterText = "",
    this.onSaved,
    this.onChanged,
    this.builder,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final String? labelText;
  final String? counterText;
  final Map<String, String> items;
  final Widget? prefix;
  final Widget? suffix;
  final bool enabled;
  final bool dense;
  final InputBorder? border;
  final EdgeInsetsGeometry? padding;
  final bool allowEmpty;
  final Color? backgroundColor;
  final void Function(String? value)? onSaved;
  final void Function(String? value)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final Widget Function(String key, String value)? builder;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          (dense
              ? const EdgeInsets.all(0)
              : const EdgeInsets.symmetric(vertical: 8)),
      child: DropdownTextFormField(
        controller: controller,
        items: items,
        builder: builder,
        enabled: enabled,
        decoration: InputDecoration(
          fillColor: backgroundColor,
          filled: backgroundColor != null,
          border: border ??
              OutlineInputBorder(
                borderSide: dense ? BorderSide.none : const BorderSide(),
              ),
          enabledBorder: border ??
              OutlineInputBorder(
                borderSide: dense ? BorderSide.none : const BorderSide(),
              ),
          disabledBorder: border ??
              OutlineInputBorder(
                borderSide: dense ? BorderSide.none : const BorderSide(),
              ),
          errorBorder: border ??
              OutlineInputBorder(
                borderSide: dense ? BorderSide.none : const BorderSide(),
              ),
          focusedBorder: border ??
              OutlineInputBorder(
                borderSide: dense ? BorderSide.none : const BorderSide(),
              ),
          focusedErrorBorder: border ??
              OutlineInputBorder(
                borderSide: dense ? BorderSide.none : const BorderSide(),
              ),
          contentPadding: contentPadding ?? const EdgeInsets.all(16),
          hintText: hintText,
          labelText: labelText,
          counterText: counterText,
          prefix: prefix,
          suffix: suffix,
        ),
        textAlign: textAlign,
        textAlignVertical: textAlignVertical,
        validator: (value) {
          if (!allowEmpty && errorText.isNotEmpty && value.isEmpty) {
            return errorText;
          }
          return null;
        },
        onChanged: onChanged,
        onSaved: (value) {
          if (!allowEmpty && value.isEmpty) {
            return;
          }
          onSaved?.call(value);
        },
      ),
    );
  }
}

/// Selectable type text field
///
/// Use with Form.
class DropdownTextFormField extends StatefulWidget {
  /// Selectable type text field
  ///
  /// Use with Form.
  const DropdownTextFormField({
    Key? key,
    this.value,
    this.controller,
    required this.items,
    this.children,
    this.selectedItemBuilder,
    this.hint,
    this.onChanged,
    this.onTap,
    this.decoration = const InputDecoration(),
    this.onSaved,
    this.enabled = true,
    this.validator,
    this.disabledHint,
    this.elevation = 8,
    this.style,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = true,
    this.isExpanded = true,
    this.itemHeight,
    this.itemBackgroundColor,
    this.builder,
    this.itemTextColor,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
  }) : super(key: key);

  final Map<String, String> items;
  final String? value;
  final List<DropdownMenuItem<String>>? children;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final Widget? hint;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final InputDecoration decoration;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final bool enabled;
  final Widget? disabledHint;
  final int elevation;
  final TextStyle? style;
  final Widget? icon;
  final Color? iconDisabledColor;
  final Color? iconEnabledColor;
  final double iconSize;
  final bool isDense;
  final bool isExpanded;
  final double? itemHeight;
  final Color? itemBackgroundColor;
  final Color? itemTextColor;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final Widget Function(String key, String value)? builder;
  @override
  _DropdownTextFormFieldState createState() => _DropdownTextFormFieldState();
}

class _DropdownTextFormFieldState extends State<DropdownTextFormField> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller =
          TextEditingController(text: widget.value ?? widget.items.keys.first);
    }
    _effectiveController?.addListener(_listener);
  }

  @override
  void dispose() {
    _effectiveController?.removeListener(_listener);
    if (_controller != null) {
      _controller?.removeListener(_listener);
      _controller?.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(DropdownTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_listener);
      widget.controller?.addListener(_listener);
      setState(() {});
    }
    if (oldWidget.value != widget.value) {
      setState(() {
        if (_effectiveController == null ||
            !widget.items.containsKey(widget.value)) {
          return;
        }
        _effectiveController?.text = widget.value ?? "";
      });
    }
  }

  void _listener() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: context.theme.copyWith(
        canvasColor:
            widget.itemBackgroundColor ?? context.theme.backgroundColor,
      ),
      child: MouseRegion(
        cursor: widget.enabled ? SystemMouseCursors.click : MouseCursor.defer,
        child: DropdownButtonFormField<String>(
          hint: widget.hint,
          decoration: widget.decoration,
          value: _effectiveController.isEmpty
              ? widget.items.keys.first
              : _effectiveController!.text,
          validator: (value) {
            if (!widget.enabled) {
              return null;
            }
            if (_effectiveController.isEmpty) {
              return null;
            }
            return widget.validator?.call(value);
          },
          onTap: widget.onTap,
          onSaved: (value) {
            if (!widget.enabled) {
              return;
            }
            if (_effectiveController.isEmpty) {
              return;
            }
            widget.onSaved?.call(value);
          },
          onChanged: widget.enabled
              ? (value) {
                  _effectiveController?.text = value ?? "";
                  widget.onChanged?.call(value);
                }
              : null,
          disabledHint: widget.disabledHint ??
              Text(
                _effectiveController.isNotEmpty &&
                        widget.items.containsKey(_effectiveController!.text)
                    ? widget.items[_effectiveController!.text]?.localize() ?? ""
                    : widget.items.values.first.localize(),
                textAlign: widget.textAlign,
              ),
          elevation: widget.elevation,
          style: widget.style,
          icon: widget.icon,
          iconDisabledColor: widget.iconDisabledColor,
          iconEnabledColor: widget.iconEnabledColor,
          iconSize: widget.iconSize,
          isDense: widget.isDense,
          isExpanded: widget.isExpanded,
          itemHeight: widget.itemHeight,
          selectedItemBuilder: widget.selectedItemBuilder ??
              (context) {
                return widget.items.toList<Widget>(
                  (String key, String value) {
                    if (widget.builder != null) {
                      return widget.builder!.call(key, value);
                    }
                    return Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _effectiveController.isEmpty
                            ? (widget.decoration.hintText ?? "--")
                            : value.localize(),
                        textAlign: widget.textAlign,
                        style: widget.itemTextColor != null
                            ? TextStyle(color: widget.itemTextColor)
                            : null,
                      ),
                    );
                  },
                ).toList();
              },
          items: widget.children ??
              widget.items.toList(
                (String key, String value) {
                  if (widget.builder != null) {
                    return DropdownMenuItem(
                      value: key,
                      child: widget.builder!.call(key, value),
                    );
                  }
                  return DropdownMenuItem(
                    value: key,
                    child: Text(
                      value.localize(),
                      style: widget.itemTextColor != null
                          ? TextStyle(color: widget.itemTextColor)
                          : null,
                    ),
                  );
                },
              ).toList(),
        ),
      ),
    );
  }
}
