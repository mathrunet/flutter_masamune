part of masamune.form;

class FormItemLabeledDropdownField extends StatelessWidget implements FormItem {
  const FormItemLabeledDropdownField({
    this.controller,
    required this.items,
    this.labelText,
    this.prefix,
    this.height,
    this.dropdownWidth = 100,
    this.backgroundColor,
    this.dense = false,
    this.enabled = true,
    this.suffix,
    this.onSaved,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? labelText;
  final Map<String, String> items;
  final Widget? prefix;
  final bool enabled;
  final Widget? suffix;
  final bool dense;
  final Color? backgroundColor;
  final double? height;
  final double dropdownWidth;
  final void Function(String? value)? onSaved;
  final void Function(String? value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          border: Border.all(
            color: context.theme.disabledColor,
            style: dense ? BorderStyle.none : BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(4.0)),
      margin: dense
          ? const EdgeInsets.all(0)
          : const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 12, top: 4.5, bottom: 4.5),
              child: Text(
                labelText ?? "",
                overflow: TextOverflow.visible,
                style: TextStyle(
                  color: enabled ? null : context.theme.disabledColor,
                ),
              ),
            ),
          ),
          Container(
            width: dropdownWidth,
            color: backgroundColor,
            padding: const EdgeInsets.fromLTRB(12, 4.5, 8, 4.5),
            alignment: Alignment.center,
            child: DropdownTextFormField(
              controller: controller,
              isExpanded: true,
              textAlign: TextAlign.right,
              items: items,
              enabled: enabled,
              style: TextStyle(
                  fontSize: 18,
                  color: context.theme.textTheme.bodyText1?.color,
                  height: 1.2),
              decoration: InputDecoration(
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  prefix: prefix,
                  suffix: suffix),
              onChanged: onChanged,
              onSaved: (value) {
                if (value.isEmpty) {
                  return;
                }
                onSaved?.call(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
