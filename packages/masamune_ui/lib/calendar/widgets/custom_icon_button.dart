part of masamune_calendar;

class _CustomIconButton extends StatelessWidget {
  const _CustomIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
  }) : super(key: key);

  final Icon icon;
  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100.0),
        child: Padding(
          padding: padding,
          child: icon,
        ),
      ),
    );
  }
}
