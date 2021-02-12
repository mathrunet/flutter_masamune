part of masamune.form;

class FormItemSubmit extends StatelessWidget implements FormItem {
  const FormItemSubmit(
    this.label, {
    this.onPressed,
    this.backgroundColor,
    this.color,
    this.padding = const EdgeInsets.symmetric(vertical: 10),
    this.height = 60,
    this.fontSize = 18,
    this.dense = false,
    this.enabled = true,
    this.borderRadius,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? color;
  final IconData? icon;
  final bool enabled;
  final bool dense;
  final double height;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: height),
      padding: dense ? const EdgeInsets.all(0) : padding,
      child: icon != null
          ? TextButton.icon(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(10),
                backgroundColor: enabled
                    ? (backgroundColor ?? context.theme.primaryColor)
                    : context.theme.disabledColor,
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ??
                      BorderRadius.all(
                        Radius.circular(dense ? 0 : 8.0),
                      ),
                ),
              ),
              icon: Icon(icon,
                  size: fontSize * 1.2,
                  color: color ?? context.theme.backgroundColor),
              label: Text(label,
                  style: TextStyle(
                      color: color ?? context.theme.backgroundColor,
                      fontSize: fontSize)),
              onPressed: enabled ? onPressed : null)
          : TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(10),
                backgroundColor: enabled
                    ? (backgroundColor ?? context.theme.primaryColor)
                    : context.theme.disabledColor,
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ??
                      BorderRadius.all(
                        Radius.circular(dense ? 0 : 8.0),
                      ),
                ),
              ),
              child: Text(label,
                  style: TextStyle(
                      color: color ?? context.theme.backgroundColor,
                      fontSize: fontSize)),
              onPressed: enabled ? onPressed : null,
            ),
    );
  }
}
