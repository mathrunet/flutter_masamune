part of masamune.list;

/// Place button on the right.
///
/// Please use it in the list.
class RightButton extends StatelessWidget {
  /// Place button on the right.
  ///
  /// Please use it in the list.
  const RightButton(
      {this.color = Colors.blue, required this.label, required this.onPressed});

  /// What happens when a button is pressed.
  final VoidCallback onPressed;

  /// The collection path to read.
  final Color color;

  /// Button label.
  final String label;

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.all(0),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
