part of masamune.list;

class DividHeadline extends StatelessWidget {
  const DividHeadline(
    this.label, {
    this.icon,
    this.color,
    this.prefix,
    this.suffix,
  });
  final IconData? icon;
  final Color? color;
  final Widget? prefix;
  final Widget? suffix;

  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(width: 12, child: Divid(color: color)),
        const Space.width(4),
        if (prefix != null) ...[
          prefix!,
          const Space.width(4),
        ],
        if (icon != null) ...[
          Icon(
            icon,
            color: color ?? context.theme.disabledColor,
            size: 12,
          ),
          const Space.width(4),
        ],
        Text(
          label,
          style: TextStyle(
            color: color ?? context.theme.disabledColor,
            fontSize: 12,
          ),
        ),
        const Space.width(4),
        Expanded(child: Divid(color: color)),
        if (suffix != null) ...[
          const Space.width(4),
          suffix!,
          SizedBox(width: 12, child: Divid(color: color)),
        ],
      ],
    );
  }
}
