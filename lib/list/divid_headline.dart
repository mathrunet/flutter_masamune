part of masamune.list;

class DividHeadline extends StatelessWidget {
  const DividHeadline(this.label);

  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(width: 12, child: Divid()),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: Text(
            label,
            style: TextStyle(
              color: context.theme.disabledColor,
              fontSize: 12,
            ),
          ),
        ),
        const Expanded(child: Divid())
      ],
    );
  }
}
