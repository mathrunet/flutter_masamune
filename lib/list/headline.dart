part of masamune.list;

/// Headline widget.
class Headline extends StatelessWidget {
  /// Headline widget.
  ///
  /// [margin]: Headline margin.
  /// [elevation]: Headline height.
  /// [icon]: Icon data.
  /// [title]: Headline title.
  /// [leading]: Headline leagding widget.
  /// [tailing]: Headline tailing widget.
  /// [color]: Text / Icon color.
  /// [crossAxisAlignment]: Vertical placement.
  /// [backgroundColor]: Background color.
  /// [padding]: Padding.
  const Headline(
    this.title, {
    this.margin = const EdgeInsets.all(0),
    this.elevation = 8.0,
    this.icon,
    this.tailing,
    this.color,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.leading,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  });

  /// Headline margin.
  final EdgeInsetsGeometry margin;

  /// Headline height.
  final double elevation;

  /// Icon data.
  final IconData? icon;

  /// Headline title.
  final String? title;

  /// Headline leagding widget.
  final Widget? leading;

  /// Vertical placement.
  final CrossAxisAlignment crossAxisAlignment;

  /// Headline tailing widget.
  final Widget? tailing;

  /// Background color.
  final Color? backgroundColor;

  /// Text / Icon color.
  final Color? color;

  /// Padding.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin,
      elevation: elevation,
      child: Container(
        padding: padding,
        color: backgroundColor ?? context.theme.secondaryColor,
        child: Row(
          crossAxisAlignment: crossAxisAlignment,
          children: <Widget>[
            if (icon != null) ...[
              Icon(
                icon,
                color: color ?? context.theme.backgroundColor,
              ),
              const Space.width(20),
            ],
            if (leading != null) ...[
              leading!,
              const Space.width(20),
            ],
            Expanded(
              child: Text(
                title ?? "",
                style: TextStyle(
                  color: color ?? context.theme.backgroundColor,
                  fontSize: 20,
                ),
              ),
            ),
            if (tailing != null) tailing!
          ],
        ),
      ),
    );
  }
}
