part of masamune.form;

class FormItemPassword extends StatefulWidget implements FormItem {
  const FormItemPassword({
    this.confirm = false,
    this.border,
    this.maxLength,
    this.minLength,
    this.disabledBorder,
    this.backgroundColor,
    this.hintText,
    this.labelText,
    this.confirmLabelText = "",
    this.lengthErrorText = "",
    this.prefix,
    this.suffix,
    this.dense = false,
    this.padding = const EdgeInsets.all(10),
    this.allowEmpty = false,
    this.enabled = true,
    this.counterText = "",
    this.onDeleteSuggestion,
    this.notMatchText = "",
    this.validator,
    this.onSaved,
    this.color,
    this.subColor,
    this.focusNode,
  });

  final String? hintText;
  final FocusNode? focusNode;
  final bool dense;
  final String? labelText;
  final String? confirmLabelText;
  final String? lengthErrorText;
  final String? counterText;
  final Widget? prefix;
  final int? maxLength;
  final int? minLength;
  final bool enabled;
  final Widget? suffix;
  final bool allowEmpty;
  final InputBorder? border;
  final InputBorder? disabledBorder;
  final Color? backgroundColor;
  final bool confirm;
  final void Function(String? value)? onDeleteSuggestion;
  final void Function(String? value)? onSaved;
  final String? Function(String? value)? validator;
  final EdgeInsetsGeometry padding;
  final String? notMatchText;
  final Color? color;
  final Color? subColor;

  @override
  State<StatefulWidget> createState() => _FormItemPasswordState();
}

class _FormItemPasswordState extends State<FormItemPassword> {
  final TextEditingController _mainController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            controller: _mainController,
            keyboardType: TextInputType.visiblePassword,
            maxLength: widget.maxLength,
            maxLines: 1,
            minLines: 1,
            expands: false,
            decoration: InputDecoration(
              fillColor: widget.backgroundColor,
              filled: widget.backgroundColor != null,
              isDense: widget.dense,
              border: widget.border ??
                  OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
              enabledBorder: widget.border ??
                  OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
              disabledBorder: widget.disabledBorder ??
                  widget.border ??
                  OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
              errorBorder: widget.border ??
                  OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
              focusedBorder: widget.border ??
                  OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
              focusedErrorBorder: widget.border ??
                  OutlineInputBorder(
                    borderSide:
                        widget.dense ? BorderSide.none : const BorderSide(),
                  ),
              hintText: widget.hintText,
              labelText: widget.labelText,
              counterText: widget.counterText,
              prefix: widget.prefix,
              suffix: widget.suffix,
              labelStyle: TextStyle(color: widget.color),
              hintStyle: TextStyle(color: widget.subColor),
              suffixStyle: TextStyle(color: widget.subColor),
              prefixStyle: TextStyle(color: widget.subColor),
              counterStyle: TextStyle(color: widget.subColor),
              helperStyle: TextStyle(color: widget.subColor),
            ),
            style: TextStyle(color: widget.color),
            obscureText: true,
            readOnly: false,
            validator: (value) {
              if (!widget.allowEmpty && value.isEmpty) {
                return widget.hintText;
              }
              if (!widget.allowEmpty &&
                  widget.lengthErrorText.isNotEmpty &&
                  widget.minLength.def(0) > value.length) {
                return widget.lengthErrorText;
              }
              if (widget.confirm && _confirmController.text != value) {
                return widget.notMatchText;
              }
              return widget.validator?.call(value);
            },
            onSaved: (value) {
              if (!widget.allowEmpty && value.isEmpty) {
                return;
              }
              widget.onSaved?.call(value);
            },
          ),
          if (widget.confirm) ...[
            const Space.height(10),
            TextFormField(
              enabled: widget.enabled,
              controller: _confirmController,
              keyboardType: TextInputType.visiblePassword,
              maxLength: widget.maxLength,
              maxLines: 1,
              minLines: 1,
              expands: false,
              decoration: InputDecoration(
                fillColor: widget.backgroundColor,
                filled: widget.backgroundColor != null,
                isDense: widget.dense,
                border: widget.border ??
                    OutlineInputBorder(
                      borderSide:
                          widget.dense ? BorderSide.none : const BorderSide(),
                    ),
                enabledBorder: widget.border ??
                    OutlineInputBorder(
                      borderSide:
                          widget.dense ? BorderSide.none : const BorderSide(),
                    ),
                disabledBorder: widget.disabledBorder ??
                    widget.border ??
                    OutlineInputBorder(
                      borderSide:
                          widget.dense ? BorderSide.none : const BorderSide(),
                    ),
                errorBorder: widget.border ??
                    OutlineInputBorder(
                      borderSide:
                          widget.dense ? BorderSide.none : const BorderSide(),
                    ),
                focusedBorder: widget.border ??
                    OutlineInputBorder(
                      borderSide:
                          widget.dense ? BorderSide.none : const BorderSide(),
                    ),
                focusedErrorBorder: widget.border ??
                    OutlineInputBorder(
                      borderSide:
                          widget.dense ? BorderSide.none : const BorderSide(),
                    ),
                hintText: widget.hintText,
                labelText: widget.confirmLabelText,
                counterText: widget.counterText,
                prefix: widget.prefix,
                suffix: widget.suffix,
                labelStyle: TextStyle(color: widget.color),
                hintStyle: TextStyle(color: widget.subColor),
                suffixStyle: TextStyle(color: widget.subColor),
                prefixStyle: TextStyle(color: widget.subColor),
                counterStyle: TextStyle(color: widget.subColor),
                helperStyle: TextStyle(color: widget.subColor),
              ),
              style: TextStyle(color: widget.color),
              obscureText: true,
              readOnly: false,
              validator: (value) {
                if (!widget.allowEmpty && value.isEmpty) {
                  return widget.hintText;
                }
                if (widget.confirm && _mainController.text != value) {
                  return widget.notMatchText;
                }
                return widget.validator?.call(value);
              },
              onSaved: (value) {
                if (!widget.allowEmpty && value.isEmpty) {
                  return;
                }
                widget.onSaved?.call(value);
              },
            ),
          ]
        ],
      ),
    );
  }
}
