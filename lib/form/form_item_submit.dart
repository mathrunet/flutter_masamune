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
    this.icon,
    this.style,
    this.disabledColor,
    this.disabledBackgroundColor,
    this.borderRadius = 8.0,
    this.borderColor,
    this.width = 0.0,
  });
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
  final double height;
  final double fontSize;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(height: height),
      padding: dense ? const EdgeInsets.all(0) : padding,
      child: icon != null
          ? TextButton.icon(
              style: style ??
                  DefaultTextButtonStyle(
                      padding: const EdgeInsets.all(10),
                      color: color ?? context.theme.textColorOnPrimary,
                      disabledColor: disabledColor,
                      backgroundColor: backgroundColor ??
                          context.theme.primaryColor,
                      disabledBackgroundColor:
                          backgroundColor == Colors.transparent
                              ? backgroundColor
                              : (disabledBackgroundColor ??
                                  context.theme.disabledColor),
                      borderColor: borderColor,
                      width: width,
                      radius: dense ? 0 : borderRadius),
              icon: Icon(
                icon,
                size: fontSize * 1.2,
              ),
              label: Text(label, style: TextStyle(fontSize: fontSize)),
              onPressed: enabled ? onPressed : null)
          : TextButton(
              style: style ??
                  DefaultTextButtonStyle(
                      padding: const EdgeInsets.all(10),
                      color: color ?? context.theme.textColorOnPrimary,
                      disabledColor: disabledColor,
                      backgroundColor: backgroundColor ??
                          context.theme.primaryColor,
                      disabledBackgroundColor:
                          backgroundColor == Colors.transparent
                              ? backgroundColor
                              : (disabledBackgroundColor ??
                                  context.theme.disabledColor),
                      borderColor: borderColor,
                      width: width,
                      radius: dense ? 0 : borderRadius),
              child: Text(label, style: TextStyle(fontSize: fontSize)),
              onPressed: enabled ? onPressed : null,
            ),
    );
  }
}
