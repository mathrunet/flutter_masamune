part of masamune_ui.list;

/// Headline widget.
class Headline extends StatelessWidget {
  /// Headline widget.
  const Headline(
    this.title, {
    this.bottomBorder,
    this.icon,
  });

  /// Border designation.
  final BorderSide? bottomBorder;

  /// Icon data.
  final IconData? icon;

  /// Headline title.
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5, top: 25),
      decoration: BoxDecoration(
        border: Border(
          bottom: bottomBorder ??
              BorderSide(
                color: context.theme.dividerColor,
              ),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: context.theme.textTheme.caption?.color,
              size: context.theme.textTheme.caption?.fontSize,
            ),
            const Space.width(20),
          ],
          Text(
            title,
            style: context.theme.textTheme.caption,
          ),
        ],
      ),
    );
  }
}
