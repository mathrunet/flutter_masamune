part of masamune.list;

/// Small-Headline widget.
class SmallHeadline extends StatelessWidget {
  /// Small-Headline widget.
  ///
  /// [margin]: Headline margin.
  /// [icon]: Icon data.
  /// [title]: Headline title.
  const SmallHeadline(
    this.title, {
    this.margin = const EdgeInsets.symmetric(vertical: 5),
    this.icon,
    this.color,
    this.backgroundColor,
  });

  /// Small-Headline margin.
  final EdgeInsetsGeometry margin;

  /// Icon data.
  final IconData? icon;

  /// Headline title.
  final String title;

  /// Background color.
  final Color? backgroundColor;

  /// Color.
  final Color? color;

  /// Build method.
  ///
  /// [BuildContext]: Build Context.
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.disabledColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon,
                size: 16, color: color ?? context.theme.textColorOnPrimary),
            const Space.width(8),
          ],
          Text(
            title,
            style: TextStyle(color: color ?? context.theme.textColorOnPrimary),
          ),
        ],
      ),
    );
  }
}
