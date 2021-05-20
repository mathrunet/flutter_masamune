part of masamune.list;

class DividHeadline extends StatelessWidget {
  const DividHeadline(
    this.label, {
    this.icon,
  });
  final IconData? icon;

  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(width: 12, child: Divid()),
        const Space.width(4),
        if (icon != null) ...[
          Icon(
            icon,
            color: context.theme.disabledColor,
            size: 12,
          ),
          const Space.width(4),
        ],
        Text(
          label,
          style: TextStyle(
            color: context.theme.disabledColor,
            fontSize: 12,
          ),
        ),
        const Space.width(4),
        const Expanded(child: Divid())
      ],
    );
  }
}
