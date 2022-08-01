part of masamune.form;

class FormItemButton extends StatelessWidget implements FormItem {
  const FormItemButton(
    this.label, {
    this.onPressed,
    this.backgroundColor,
    this.color,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    this.mergin = EdgeInsets.zero,
    this.fontSize = 16,
    this.dense = false,
    this.enabled = true,
    this.icon,
    this.style,
    this.disabledColor,
    this.disabledBackgroundColor,
    this.borderRadius = 8.0,
    this.borderColor,
    this.textStyle,
    this.width,
    this.borderWidth,
  });
  final EdgeInsetsGeometry mergin;
  final double borderRadius;
  final ButtonStyle? style;
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? color;
  final Color? disabledColor;
  final Color? disabledBackgroundColor;
  final IconData? icon;
  final bool enabled;
  final bool dense;
  final TextStyle? textStyle;
  // final double height;
  final double fontSize;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final double? width;
  final double? borderWidth;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      margin: mergin,
      child: icon != null
          ? TextButton.icon(
              style: style ??
                  DefaultTextButtonStyle(
                    padding: padding,
                    color: color ?? context.theme.textColorOnPrimary,
                    disabledColor: disabledColor,
                    backgroundColor:
                        backgroundColor ?? context.theme.primaryColor,
                    disabledBackgroundColor:
                        backgroundColor == Colors.transparent
                            ? backgroundColor
                            : (disabledBackgroundColor ??
                                context.theme.disabledColor),
                    borderColor: borderColor,
                    radius: dense ? 0 : borderRadius,
                    borderWidth: borderWidth ?? 0.0,
                  ),
              icon: Icon(
                icon,
                size: fontSize * 1.2,
              ),
              label: Text(
                label,
                style: textStyle?.copyWith(fontSize: fontSize) ??
                    TextStyle(fontSize: fontSize),
              ),
              onPressed: enabled ? onPressed : null,
            )
          : TextButton(
              style: style ??
                  DefaultTextButtonStyle(
                    padding: padding,
                    color: color ?? context.theme.textColorOnPrimary,
                    disabledColor: disabledColor,
                    backgroundColor:
                        backgroundColor ?? context.theme.primaryColor,
                    disabledBackgroundColor:
                        backgroundColor == Colors.transparent
                            ? backgroundColor
                            : (disabledBackgroundColor ??
                                context.theme.disabledColor),
                    borderColor: borderColor,
                    radius: dense ? 0 : borderRadius,
                    borderWidth: borderWidth ?? 0.0,
                  ),
              child: Text(
                label,
                style: textStyle?.copyWith(fontSize: fontSize) ??
                    TextStyle(fontSize: fontSize),
              ),
              onPressed: enabled ? onPressed : null,
            ),
    );
  }
}
