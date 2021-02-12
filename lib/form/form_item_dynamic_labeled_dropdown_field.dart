part of masamune.form;

class FormItemDynamicLabeledDropdownField extends StatefulWidget
    implements FormItem {
  const FormItemDynamicLabeledDropdownField(
      {this.controller,
      required this.items,
      this.labelText = "",
      this.lengthErrorText,
      this.prefix,
      this.suffix,
      this.onSaved,
      this.dropdownWidth = 100,
      this.dense = false,
      this.backgroundColor,
      this.dropdownColor,
      this.onChanged,
      this.enabled = true,
      this.suggestion = const [],
      this.validator,
      this.separator = ":",
      this.keyboardType = TextInputType.text,
      this.maxLength,
      this.minLength,
      this.maxLines,
      this.minLines = 1,
      this.onDeleteSuggestion,
      this.allowEmpty = false,
      this.hintText = "",
      this.readOnly = false,
      this.obscureText = false,
      this.counterText = ""});

  static String value(String key, String value) {
    return "$key:$value";
  }

  final TextEditingController? controller;
  final String labelText;
  final Map<String, String> items;
  final Widget? prefix;
  final Widget? suffix;
  final String Function(String? key, String? value)? validator;
  final void Function(String? key, String? value)? onSaved;
  final void Function(String? key, String? value)? onChanged;
  final TextInputType keyboardType;
  final int? maxLength;
  final int? minLength;
  final int? maxLines;
  final int minLines;
  final String hintText;
  final String counterText;
  final String? lengthErrorText;
  final bool readOnly;
  final bool obscureText;
  final String separator;
  final bool dense;
  final Color? backgroundColor;
  final Color? dropdownColor;
  final List<String> suggestion;
  final bool enabled;
  final double dropdownWidth;
  final bool allowEmpty;
  final void Function(String value)? onDeleteSuggestion;

  @override
  State<StatefulWidget> createState() =>
      _FormItemDynamicLabeledDropdownFieldState();
}

class _FormItemDynamicLabeledDropdownFieldState
    extends State<FormItemDynamicLabeledDropdownField> {
  TextEditingController? _textController;
  TextEditingController? _dropdownController;

  @override
  void initState() {
    super.initState();
    if (widget.controller.isNotEmpty) {
      final tmp = widget.controller!.text.split(":");
      _textController = TextEditingController(text: tmp.first);
      _dropdownController = TextEditingController(text: tmp.last);
    } else {
      _textController = TextEditingController();
      _dropdownController = TextEditingController();
    }
    widget.controller?.addListener(_listnerController);
    _textController?.addListener(_listener);
    _dropdownController?.addListener(_listener);
  }

  void _listener() {
    if (widget.controller == null) {
      return;
    }
    final dropDown = _dropdownController.isEmpty
        ? widget.items.entries.first.key
        : _dropdownController!.text;
    widget.controller?.text =
        "${_textController?.text ?? ""}${widget.separator}$dropDown";
  }

  @override
  void dispose() {
    super.dispose();
    _textController?.removeListener(_listener);
    _dropdownController?.removeListener(_listener);
    widget.controller?.removeListener(_listnerController);
  }

  void _listnerController() {
    if (widget.controller.isNotEmpty) {
      final tmp = widget.controller!.text.split(":");
      if (_textController?.text != tmp.first) {
        _textController?.text = tmp.first;
      }
      if (_dropdownController?.text != tmp.last) {
        _dropdownController?.text = tmp.last;
      }
    } else {
      if (_textController?.text != "") {
        _textController?.text = "";
      }
      if (_dropdownController?.text != "") {
        _dropdownController?.text = "";
      }
    }
  }

  @override
  void didUpdateWidget(FormItemDynamicLabeledDropdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_listnerController);
      widget.controller?.addListener(_listnerController);
      if (widget.controller.isNotEmpty) {
        final tmp = widget.controller?.text.split(":");
        if (_textController?.text != tmp?.first) {
          _textController?.text = tmp?.first ?? "";
        }
        if (_dropdownController?.text != tmp?.last) {
          _dropdownController?.text = tmp?.last ?? "";
        }
      } else {
        if (_textController?.text != "") {
          _textController?.text = "";
        }
        if (_dropdownController?.text != "") {
          _dropdownController?.text = "";
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SuggestionOverlayBuilder(
      items: widget.suggestion,
      controller: _textController,
      onDeleteSuggestion: widget.onDeleteSuggestion,
      builder: (context, controller, onTap) => Container(
        height: widget.dense ? 60 : 80,
        padding: widget.dense
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(vertical: 10),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          fit: StackFit.expand,
          children: [
            TextFormField(
                enabled: widget.enabled,
                controller: controller,
                keyboardType: TextInputType.text,
                maxLength: widget.maxLength,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                decoration: InputDecoration(
                  fillColor: widget.backgroundColor,
                  filled: widget.backgroundColor != null,
                  border: OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
                  hintText: widget.hintText,
                  labelText: widget.labelText,
                  counterText: widget.counterText,
                  contentPadding: EdgeInsets.only(
                    top: 20,
                    left: 12,
                    bottom: 20,
                    right: widget.dropdownWidth + 12,
                  ),
                  prefix: widget.prefix,
                ),
                obscureText: widget.obscureText,
                readOnly: widget.readOnly,
                onTap: widget.enabled ? onTap : null,
                validator: (value) {
                  if (!widget.allowEmpty && value.isEmpty) {
                    return widget.hintText;
                  }

                  if (!widget.allowEmpty &&
                      widget.lengthErrorText.isNotEmpty &&
                      widget.minLength.def(0) > value.length) {
                    return widget.lengthErrorText;
                  }
                  return widget.validator?.call(
                    value,
                    _dropdownController.isEmpty
                        ? widget.items.entries.first.key
                        : _dropdownController!.text,
                  );
                },
                onSaved: (value) {
                  if (!widget.allowEmpty && value.isEmpty) {
                    return;
                  }
                  widget.onSaved?.call(
                    value,
                    _dropdownController.isEmpty
                        ? widget.items.entries.first.key
                        : _dropdownController!.text,
                  );
                }),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: widget.dropdownWidth,
                margin: const EdgeInsets.fromLTRB(0, 2, 1, 2),
                decoration: BoxDecoration(
                  color: widget.dropdownColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4.0),
                    bottomRight: Radius.circular(4.0),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(12, 4.5, 8, 4.5),
                alignment: Alignment.centerRight,
                child: DropdownTextFormField(
                  controller: _dropdownController,
                  items: widget.items,
                  enabled: widget.enabled,
                  style: TextStyle(
                      fontSize: 20,
                      color: context.theme.textTheme.bodyText1?.color,
                      height: 1.15),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                  onChanged: (value) {
                    widget.onChanged?.call(
                      _textController?.text,
                      value.isEmpty ? widget.items.entries.first.key : value,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
