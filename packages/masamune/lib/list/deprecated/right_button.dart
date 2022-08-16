part of masamune.list;

/// Place button on the right.
///
/// Please use it in the list.
@deprecated
class RightButton extends StatelessWidget {
  /// Place button on the right.
  ///
  /// Please use it in the list.
  const RightButton({
    this.color = Colors.blue,
    required this.label,
    required this.onPressed,
    this.icon = Icons.open_in_new,
    this.padding = const EdgeInsets.fromLTRB(0, 8, 16, 8),
  });

  /// What happens when a button is pressed.
  final VoidCallback onPressed;

  /// Icon.
  final IconData icon;

  /// The collection path to read.
  final Color color;

  /// Button label.
  final String label;

  final EdgeInsetsGeometry padding;

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: padding,
        child: TextButton.icon(
          icon: Icon(icon, color: color),
          style: TextButton.styleFrom(
            visualDensity: VisualDensity.compact,
            padding: const EdgeInsets.all(0),
          ),
          onPressed: onPressed,
          label: Text(
            label,
            style: TextStyle(color: color),
          ),
        ),
      ),
    );
  }
}
