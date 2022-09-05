part of masamune_ui.list;

/// Display a message box.
///
/// Please use it for notes of each item.
class MessageBox extends StatelessWidget {
  /// Display a message box.
  ///
  /// Please use it for notes of each item.
  ///
  /// [text]: Text content.
  /// [icon]: Icon.
  /// [color]: Color. The whole color changes.
  /// [onTap]: Processing when tapped.
  const MessageBox(
    this.text, {
    this.icon = Icons.info,
    this.color,
    this.onTap,
    this.margin,
    this.padding,
  });

  /// Text content.
  final String text;

  /// Icon.
  final IconData? icon;

  /// Color. The whole color changes.
  final Color? color;

  /// Processing when tapped.
  final VoidCallback? onTap;

  /// Margin.
  final EdgeInsetsGeometry? margin;

  /// Padding.
  final EdgeInsetsGeometry? padding;

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ?? const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: padding ?? const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: color ?? context.theme.colorScheme.error,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4.0),
            color: (color ?? context.theme.colorScheme.error).withOpacity(0.12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: color ?? context.theme.colorScheme.error,
                ),
                const Space.width(15),
              ],
              Flexible(
                child: Text(
                  text,
                  style: TextStyle(
                    color: color ?? context.theme.colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
