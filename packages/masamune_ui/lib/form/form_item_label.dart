part of masamune_ui.form;

class FormItemLabel extends StatelessWidget {
  const FormItemLabel(
    this.label, {
    this.padding = const EdgeInsets.fromLTRB(0, 10, 0, 0),
    this.backgroundColor,
    this.color,
    this.decoration,
    this.textDecoration,
    this.fontWeight = FontWeight.bold,
    this.fontSize,
  });
  final String label;
  final EdgeInsetsGeometry padding;
  final Color? backgroundColor;
  final Color? color;
  final FontWeight fontWeight;
  final double? fontSize;
  final TextDecoration? textDecoration;
  final Decoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      color: backgroundColor,
      decoration: decoration,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          decoration: textDecoration,
        ),
      ),
    );
  }
}
