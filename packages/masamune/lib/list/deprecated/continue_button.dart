part of masamune.list;

/// Button for continue.
@deprecated
class ContinueButton extends StatelessWidget {
  /// Button for continue.
  const ContinueButton({
    this.margin = const EdgeInsets.all(8),
    this.title = "Continue",
    this.padding = const EdgeInsets.fromLTRB(8, 4, 16, 4),
    this.backgroundColor,
    this.color,
    this.icon,
    this.elevation = 4.0,
    this.fontSize = 12,
    required this.onPressed,
  });

  /// Button icon.
  final IconData? icon;

  /// Button elevation.
  final double elevation;

  /// Button margin.
  final EdgeInsetsGeometry margin;

  /// Button padding.
  final EdgeInsetsGeometry padding;

  /// The title of the button.
  final String title;

  /// Text font size.
  final double fontSize;

  /// The background color.
  final Color? backgroundColor;

  /// Text color.
  final Color? color;

  /// The action when the button is pressed.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          padding: padding,
          elevation: elevation,
          shape: const StadiumBorder(),
          backgroundColor: backgroundColor ?? context.theme.cardColor,
          primary: context.theme.textColor,
        ),
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.arrow_right),
        label: Text(
          title.localize(),
          style: TextStyle(
            color: color ?? context.theme.textColor,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
