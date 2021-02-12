part of masamune.list;

/// Button for list.
class ListButton extends StatelessWidget {
  /// Button for list.
  ///
  /// [margin]: Button margin.
  /// [padding]: Button padding.
  /// [title]: The title of the button.
  /// [color]: Text color.
  /// [backgroundColor]: List trailing.
  /// [onPressed]: The action when the button is pressed.
  const ListButton({
    this.margin = const EdgeInsets.all(10),
    required this.title,
    this.padding,
    this.backgroundColor,
    this.color,
    required this.onPressed,
  });

  /// Button margin.
  final EdgeInsetsGeometry margin;

  /// Button padding.
  final EdgeInsetsGeometry? padding;

  /// The title of the button.
  final String title;

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
      child: TextButton(
        style: TextButton.styleFrom(
          padding: padding,
          backgroundColor: backgroundColor ?? context.theme.primaryColor,
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(color: color ?? context.theme.backgroundColor),
        ),
      ),
    );
  }
}
