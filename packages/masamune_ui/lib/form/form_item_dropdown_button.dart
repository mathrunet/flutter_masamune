part of masamune_ui.form;

/// Widget that displays a dropdown button and generates an action when tapped.
class FormItemDropdownButton extends StatelessWidget implements FormItem {
  /// Widget that displays a dropdown button and generates an action when tapped.
  ///
  /// [onTap]: Action when tapped.
  /// [onLongPress]: Action when long pressed.
  /// [controller]: Text edit controller.
  /// [initialValue]: First value.
  /// [decoration]: Input form decoration.
  /// [dense]: True for dense.
  /// [backgroundColor]: Background color.
  const FormItemDropdownButton({
    required this.onTap,
    this.backgroundColor,
    this.controller,
    this.enabled = true,
    this.initialValue,
    this.dense = false,
    this.onLongPress,
    this.decoration,
  });

  /// Action when tapped.
  final VoidCallback onTap;

  /// Action when long pressed.
  final VoidCallback? onLongPress;

  /// Text edit controller.
  final TextEditingController? controller;

  /// First value.
  final String? initialValue;

  /// Input form decoration.
  final Decoration? decoration;

  /// True if enabled.
  final bool enabled;

  /// True for dense.
  final bool dense;

  /// Background color.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: dense
          ? const EdgeInsets.symmetric(horizontal: 20)
          : const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: InkWell(
        onLongPress: enabled ? onLongPress : null,
        onTap: enabled ? onTap : null,
        child: Container(
          height: 60,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(12),
          decoration: decoration ??
              BoxDecoration(
                color: backgroundColor,
                border: Border.all(
                  color: context.theme.disabledColor,
                  style: dense ? BorderStyle.none : BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Text(
                controller?.text ?? initialValue ?? "",
                style: context.theme.inputDecorationTheme.helperStyle?.copyWith(
                  color: enabled ? null : context.theme.disabledColor,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: enabled ? null : context.theme.disabledColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
