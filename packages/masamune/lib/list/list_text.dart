part of masamune.list;

/// Text-only list.
class ListText extends StatelessWidget {
  /// Text-only list.
  ///
  /// [text]: Text.
  /// [onTap]: Processing when tapped.
  const ListText({required this.text, this.onTap});

  /// Text.
  final Widget text;

  /// Processing when tapped.
  final VoidCallback? onTap;

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: context.theme.textTheme.subtitle1 ?? const TextStyle(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: InkWell(
          onTap: onTap,
          child: text,
        ),
      ),
    );
  }
}
