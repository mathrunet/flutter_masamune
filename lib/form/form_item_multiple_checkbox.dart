part of masamune.form;

class FormItemMultipleCheckbox extends FormField<List<String>>
    implements FormItem {
  FormItemMultipleCheckbox(
      {this.controller,
      this.leading,
      required this.items,
      this.dense = false,
      this.padding = const EdgeInsets.fromLTRB(4, 0, 24, 0),
      this.margin = const EdgeInsets.symmetric(vertical: 4),
      this.onChanged,
      this.backgroundColor,
      this.color,
      this.activeColor,
      this.checkColor,
      this.hintText,
      this.errorText,
      this.minHeight = 48,
      this.labelText,
      this.submitText,
      this.cancelText,
      this.allowEmpty = false,
      this.separator = ",",
      this.unselectColor,
      this.border,
      this.scroll = false,
      Key? key,
      void Function(List<String>? value)? onSaved,
      String? Function(List<String>? value)? validator,
      List<String> initialValue = const [],
      bool enabled = true})
      : super(
            key: key,
            builder: (state) {
              return const Empty();
            },
            onSaved: onSaved,
            validator: (value) {
              if (!allowEmpty && value.isEmpty) {
                return errorText;
              }
              return validator?.call(value);
            },
            initialValue: initialValue,
            enabled: enabled);

  final String separator;
  final bool scroll;
  final BoxBorder? border;
  final Map<String, String> items;
  final TextEditingController? controller;
  final bool allowEmpty;
  final void Function(List<String>? value)? onChanged;
  final Color? activeColor;
  final bool dense;
  final Color? checkColor;
  final Widget? leading;
  final String? hintText;
  final String? errorText;
  final String? submitText;
  final String? cancelText;
  final Color? color;
  final double minHeight;
  final Color? unselectColor;
  final Color? backgroundColor;
  final String? labelText;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  @override
  _FormItemMultipleCheckboxState createState() =>
      _FormItemMultipleCheckboxState();
}

class _FormItemMultipleCheckboxState extends FormFieldState<List<String>> {
  TextEditingController? _controller;

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  FormItemMultipleCheckbox get widget =>
      super.widget as FormItemMultipleCheckbox;

  @override
  void didUpdateWidget(FormItemMultipleCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);

      if (oldWidget.controller != null && widget.controller == null)
        _controller =
            TextEditingController.fromValue(oldWidget.controller?.value);
      if (widget.controller != null) {
        setValue(_parseFromString(widget.controller?.text ?? ""));
        if (oldWidget.controller == null) {
          _controller = null;
        }
      }
    }
  }

  List<String> _parseFromString(String text) {
    if (text.isEmpty) {
      return [];
    }
    return text.split(widget.separator);
  }

  String _parseToString(List<String>? list) {
    if (list.isEmpty) {
      return "";
    }
    return list!.join(widget.separator);
  }

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = TextEditingController(text: value?.join(widget.separator));
    } else {
      widget.controller?.addListener(_handleControllerChanged);
    }
    setValue(_parseFromString(_effectiveController?.text ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        border: widget.border ??
            Border.fromBorderSide(
                widget.dense ? BorderSide.none : const BorderSide()),
      ),
      child: Column(
        children: [
          _MultiSelectDialogFieldView<String>(
            initialValue: value,
            padding: widget.padding,
            hintText: widget.hintText,
            confirmText: widget.submitText.isEmpty
                ? Text("Save".localize())
                : Text(widget.submitText!),
            cancelText: widget.cancelText.isEmpty
                ? Text("Close".localize())
                : Text(widget.cancelText!),
            title: widget.labelText.isEmpty
                ? Text(widget.hintText ?? "",
                    style: TextStyle(color: context.theme.textColorOnSurface))
                : Text(widget.labelText!,
                    style: TextStyle(color: context.theme.textColorOnSurface)),
            height: widget.minHeight,
            selectedColor: widget.activeColor ?? context.theme.primaryColor,
            selectedItemsTextStyle: TextStyle(
                color: widget.color ?? context.theme.textColorOnSurface),
            chipDisplay: MultiSelectChipDisplay<String>(
                scroll: widget.scroll,
                height: widget.minHeight,
                chipColor: widget.activeColor ?? context.theme.primaryColor,
                textStyle: TextStyle(
                    color: widget.color ?? context.theme.textColorOnPrimary)),
            itemsTextStyle: TextStyle(
              color: widget.unselectColor ?? context.theme.disabledColor,
            ),
            unselectedColor:
                widget.unselectColor ?? context.theme.disabledColor,
            checkColor: widget.checkColor ?? context.theme.textColorOnSurface,
            backgroundColor: context.theme.surfaceColor,
            items: widget.items
                .toList(
                  (key, value) => MultiSelectItem<String>(key, value),
                )
                .toList(),
            onConfirm: (value) {
              final val = value.mapAndRemoveEmpty((item) => item.toString());
              setValue(val);
              widget.onChanged?.call(val);
            },
          ),
          if (hasError) ...[
            const SizedBox(height: 5),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    errorText!,
                    style: TextStyle(
                      color: Colors.red[800],
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ],
            )
          ] else
            const Empty(),
        ],
      ),
    );
  }

  @override
  void didChange(List<String>? value) {
    super.didChange(value);
    if (_parseFromString(_effectiveController?.text ?? "") != value) {
      _effectiveController?.text = _parseToString(value);
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
    final parsed = _parseFromString(_effectiveController?.text ?? "");
    if (parsed != value) {
      didChange(parsed);
    }
  }
}

// ignore: must_be_immutable
@immutable
class _MultiSelectDialogFieldView<V> extends StatefulWidget {
  const _MultiSelectDialogFieldView({
    required this.items,
    this.title,
    this.buttonIcon,
    this.listType,
    this.decoration,
    this.onSelectionChanged,
    this.onConfirm,
    this.dialogHeight,
    this.chipDisplay,
    this.initialValue,
    this.searchable,
    this.confirmText,
    this.cancelText,
    this.hintText,
    this.barrierColor,
    this.selectedColor,
    this.searchHint,
    this.height,
    this.colorator,
    this.backgroundColor,
    this.unselectedColor,
    this.searchIcon,
    this.closeSearchIcon,
    this.itemsTextStyle,
    this.searchTextStyle,
    this.searchHintStyle,
    this.selectedItemsTextStyle,
    this.checkColor,
    this.padding = const EdgeInsets.fromLTRB(4, 4, 24, 4),
  });

  final MultiSelectListType? listType;
  final BoxDecoration? decoration;
  final IconData? buttonIcon;
  final Widget? title;
  final List<MultiSelectItem<V>> items;
  final void Function(List<V>)? onSelectionChanged;
  final MultiSelectChipDisplay<V>? chipDisplay;
  final List<V>? initialValue;
  final void Function(List<V>)? onConfirm;
  final bool? searchable;
  final Text? confirmText;
  final Text? cancelText;
  final Color? barrierColor;
  final Color? selectedColor;
  final double? height;
  final String? hintText;
  final double? dialogHeight;
  final String? searchHint;
  final EdgeInsetsGeometry padding;
  final Color Function(V)? colorator;
  final Color? backgroundColor;
  final Color? unselectedColor;
  final Icon? searchIcon;
  final Icon? closeSearchIcon;
  final TextStyle? itemsTextStyle;
  final TextStyle? selectedItemsTextStyle;
  final TextStyle? searchTextStyle;
  final TextStyle? searchHintStyle;
  final Color? checkColor;

  @override
  __MultiSelectDialogFieldViewState createState() =>
      __MultiSelectDialogFieldViewState<V>();
}

class __MultiSelectDialogFieldViewState<V>
    extends State<_MultiSelectDialogFieldView<V>> {
  List<V> _selectedItems = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _selectedItems.addAll(widget.initialValue!);
    }
  }

  Widget _buildInheritedChipDisplay() {
    final chipDisplayItems = _selectedItems
        .map((e) =>
            widget.items.firstWhereOrNull((element) => e == element.value))
        .toList();
    chipDisplayItems.removeWhere((element) => element == null);
    if (chipDisplayItems.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18.5),
        child: Text(
          widget.hintText ?? "",
          style: TextStyle(
            color: context.theme.disabledColor,
          ),
        ),
      );
    } else {
      if (widget.chipDisplay != null) {
        // if user has specified a chipDisplay, use its params
        if (widget.chipDisplay!.disabled!) {
          return const Empty();
        } else {
          return MultiSelectChipDisplay<V>(
            items: chipDisplayItems,
            colorator: widget.chipDisplay!.colorator ?? widget.colorator,
            onTap: (item) {
              if (widget.chipDisplay!.onTap != null) {
                List<V>? newValues;
                final result = widget.chipDisplay!.onTap!(item);
                if (result is List<V>) {
                  newValues = result;
                }
                if (newValues != null) {
                  _selectedItems = newValues;
                }
              } else {
                _showDialog(context);
              }
            },
            decoration: widget.chipDisplay!.decoration,
            chipColor: widget.chipDisplay!.chipColor ??
                ((widget.selectedColor != null &&
                        widget.selectedColor != Colors.transparent)
                    ? widget.selectedColor!.withOpacity(0.35)
                    : null),
            alignment: widget.chipDisplay!.alignment,
            textStyle: widget.chipDisplay!.textStyle,
            icon: widget.chipDisplay!.icon,
            shape: widget.chipDisplay!.shape,
            scroll: widget.chipDisplay!.scroll,
            scrollBar: widget.chipDisplay!.scrollBar,
            height: widget.chipDisplay!.height,
            chipWidth: widget.chipDisplay!.chipWidth,
          );
        }
      } else {
        // user didn't specify a chipDisplay, build the default
        return MultiSelectChipDisplay<V>(
          items: chipDisplayItems,
          colorator: widget.colorator,
          chipColor: (widget.selectedColor != null &&
                  widget.selectedColor != Colors.transparent)
              ? widget.selectedColor!.withOpacity(0.35)
              : null,
        );
      }
    }
  }

  /// Calls showDialog() and renders a MultiSelectDialog.
  Future<void> _showDialog(BuildContext ctx) async {
    await showDialog(
      barrierColor: widget.barrierColor,
      context: context,
      builder: (ctx) {
        return MultiSelectDialog<V>(
          checkColor: widget.checkColor,
          selectedItemsTextStyle: widget.selectedItemsTextStyle,
          searchHintStyle: widget.searchHintStyle,
          searchTextStyle: widget.searchTextStyle,
          itemsTextStyle: widget.itemsTextStyle,
          searchIcon: widget.searchIcon,
          closeSearchIcon: widget.closeSearchIcon,
          unselectedColor: widget.unselectedColor,
          backgroundColor: widget.backgroundColor,
          colorator: widget.colorator,
          searchHint: widget.searchHint,
          selectedColor: widget.selectedColor,
          onSelectionChanged: widget.onSelectionChanged,
          height: widget.dialogHeight ?? context.mediaQuery.size.height / 2.0,
          listType: widget.listType,
          items: widget.items,
          title: widget.title ?? const Text("Select"),
          initialValue: _selectedItems,
          searchable: widget.searchable ?? false,
          confirmText: widget.confirmText,
          cancelText: widget.cancelText,
          onConfirm: (selected) {
            setState(() {
              _selectedItems = selected;
              if (widget.onConfirm != null) {
                widget.onConfirm?.call(selected);
              }
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showDialog(context);
      },
      child: Container(
        padding: widget.padding,
        constraints: BoxConstraints(minHeight: widget.height ?? 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Wrap(
                    children: [
                      _buildInheritedChipDisplay(),
                    ],
                  ),
                ),
                if (widget.buttonIcon != null)
                  Icon(
                    widget.buttonIcon,
                    color: context.theme.dividerColor,
                  )
                else
                  Icon(
                    Icons.arrow_drop_down,
                    color: context.theme.dividerColor,
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
