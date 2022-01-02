part of masamune;

/// Draw a dividing line.
class Divid extends StatelessWidget {
  /// Draw a dividing line.
  const Divid({
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.height = 1,
  })  : _vertical = false,
        width = null;

  /// Draw a dividing line for vertical.
  const Divid.vertical(
    this.height, {
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.width = 16,
  }) : _vertical = true;

  final bool _vertical;
  final double height;
  final double? width;
  final double? thickness;
  final double? indent;
  final double? endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    if (_vertical) {
      return SizedBox(
        height: height,
        child: VerticalDivider(
          width: width,
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          color: color,
        ),
      );
    } else {
      return Divider(
        height: height,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
        color: color,
      );
    }
  }
}
