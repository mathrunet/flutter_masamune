part of masamune.form;

/// Form-headline widget.
class FormItemHeadline extends StatelessWidget implements FormItem {
  /// Form-headline widget.
  ///
  /// [bottomBorder]: Border designation.
  /// [icon]: Icon data.
  /// [title]: Headline title.
  const FormItemHeadline(
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
      padding: const EdgeInsets.only(left: 10, right: 15, bottom: 5, top: 25),
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
            const SizedBox(width: 20),
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
