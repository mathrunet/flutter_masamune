part of masamune.list;

/// List item.
class ListItem extends StatelessWidget {
  /// List item.
  ///
  /// [leading]: Leading widget for items.
  /// [title]: The title of the item.
  /// [text]: The text of the item.
  /// [indent]: Title indent.
  /// [dense]: List tile dense.
  /// [padding]: List tile padding.
  /// [trailing]: List trailing.
  /// [onTap]: Processing when tapped.
  const ListItem({
    this.leading,
    this.onTap,
    required this.title,
    this.text,
    this.dense = false,
    this.padding,
    this.indent = 0,
    this.trailing,
    this.textWidth = 200,
  });

  /// Leading widget for items.
  final Widget? leading;

  /// The title of the item.
  final Widget title;

  /// The text of the item.
  final Widget? text;

  /// Title indent.
  final int indent;

  /// List trailing.
  final Widget? trailing;

  /// Horizontal size of the text side.
  final double textWidth;

  /// List tile dense.
  final bool dense;

  /// List tile padding.
  final EdgeInsetsGeometry? padding;

  /// Processing when tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      dense: dense,
      onTap: onTap,
      contentPadding: padding,
      title: Row(
        children: [
          Expanded(
              flex: 1,
              child: Padding(
                  padding: EdgeInsets.only(
                    left: 20 * indent.toDouble(),
                  ),
                  child: title)),
          Container(
            width: text == null ? 0 : textWidth,
            child: text ?? const Empty(),
          )
        ],
      ),
      trailing: trailing,
    );
  }
}
