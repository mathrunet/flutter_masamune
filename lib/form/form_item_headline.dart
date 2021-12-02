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
      padding: const EdgeInsets.only(left: 8, right: 16, bottom: 4, top: 24),
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
            const SizedBox(width: 24),
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
