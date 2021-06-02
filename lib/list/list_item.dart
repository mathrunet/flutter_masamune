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
    this.color,
    this.textColor,
    this.iconColor,
    this.onTap,
    required this.title,
    this.text,
    this.dense = false,
    this.padding,
    this.indent = 0,
    this.subtitle,
    this.trailing,
    this.textWidth = 200,
    this.selected = false,
    this.tileColor,
    this.selectedColor,
    this.selectedTileColor,
    this.disabledTapOnSelected = false,
  });

  /// Leading widget for items.
  final Widget? leading;

  /// The title of the item.
  final Widget title;

  /// The subtitle of the item.
  final Widget? subtitle;

  /// The text of the item.
  final Widget? text;

  /// Foreground color.
  final Color? color;

  /// Text color.
  final Color? textColor;

  /// Icon color.
  final Color? iconColor;

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

  /// If selected, `true`.
  final bool selected;

  /// Background view.
  final Color? tileColor;

  /// Foreground view when in focus.
  final Color? selectedColor;

  /// Background view when in focus.
  final Color? selectedTileColor;

  /// If it is selected, the tap should not respond.
  final bool disabledTapOnSelected;

  @override
  Widget build(BuildContext context) {
    final style = ListTileTheme.of(context);
    return ListTileTheme(
      style: style.style,
      textColor: textColor ?? color,
      iconColor: iconColor ?? color,
      tileColor: tileColor,
      selectedColor: selectedColor,
      selectedTileColor: selectedTileColor,
      child: ListTile(
        leading: leading,
        dense: dense,
        onTap: disabledTapOnSelected && selected ? null : onTap,
        selected: selected,
        subtitle: subtitle,
        contentPadding: padding,
        title: text != null
            ? Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _title(context),
                  ),
                  SizedBox(
                    width: textWidth,
                    child: text,
                  )
                ],
              )
            : _title(context),
        trailing: trailing,
      ),
    );
  }

  Widget _title(BuildContext context) {
    var child = title;
    if (indent > 0) {
      child = Padding(
        padding: EdgeInsets.only(
          left: 20 * indent.toDouble(),
        ),
        child: child,
      );
    }
    return child;
  }
}
