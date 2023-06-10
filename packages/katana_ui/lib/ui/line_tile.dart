part of katana_ui;

/// Items can be listed on the left and right [ListTile].
///
/// If [text] is specified, the widget can be placed to the right of [title].
///
/// The size can be adjusted by specifying [titleFlex] and [textFlex].
///
/// The spacing can be adjusted by specifying [space].
///
/// 左右に項目を記載可能な[ListTile]。
///
/// [text]を指定すると[title]の右側にウィジェットを配置できます。
///
/// [titleFlex]と[textFlex]を指定してサイズを調整することが可能です。
///
/// [space]を指定すると間隔を調整することが可能です。
@immutable
class LineTile extends ListTile {
  /// Items can be listed on the left and right [ListTile].
  ///
  /// If [text] is specified, the widget can be placed to the right of [title].
  ///
  /// The size can be adjusted by specifying [titleFlex] and [textFlex].
  ///
  /// The spacing can be adjusted by specifying [space].
  ///
  /// 左右に項目を記載可能な[ListTile]。
  ///
  /// [text]を指定すると[title]の右側にウィジェットを配置できます。
  ///
  /// [titleFlex]と[textFlex]を指定してサイズを調整することが可能です。
  ///
  /// [space]を指定すると間隔を調整することが可能です。
  const LineTile({
    super.key,
    super.leading,
    super.title,
    this.text,
    this.space = 8.0,
    this.titleFlex = 1,
    this.textFlex = 1,
    super.subtitle,
    super.trailing,
    super.isThreeLine = false,
    super.dense,
    super.visualDensity,
    super.shape,
    super.style,
    super.selectedColor,
    super.iconColor,
    super.textColor,
    super.contentPadding,
    super.enabled = true,
    super.onTap,
    super.onLongPress,
    super.onFocusChange,
    super.mouseCursor,
    super.selected = false,
    super.focusColor,
    super.hoverColor,
    super.splashColor,
    super.focusNode,
    super.autofocus = false,
    super.tileColor,
    super.selectedTileColor,
    super.enableFeedback,
    super.horizontalTitleGap,
    super.minVerticalPadding,
    super.minLeadingWidth,
  });

  /// Widget to display next to the title.
  ///
  /// タイトルの横に表示するためのウィジェット。
  final Widget? text;

  /// Flex. in the title section.
  ///
  /// タイトル部分のflex.
  final int titleFlex;

  /// Flex. in the text section.
  ///
  /// テキスト部分のflex.
  final int textFlex;

  /// Space between title and text.
  ///
  /// タイトルとテキスト間のスペース。
  final double space;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: _buildTitle(context),
      subtitle: subtitle,
      trailing: trailing,
      isThreeLine: isThreeLine,
      dense: dense,
      visualDensity: visualDensity,
      shape: shape,
      style: style,
      selectedColor: selectedColor,
      iconColor: iconColor,
      textColor: textColor,
      contentPadding: contentPadding,
      enabled: enabled,
      onTap: onTap,
      onLongPress: onLongPress,
      onFocusChange: onFocusChange,
      mouseCursor: mouseCursor,
      selected: selected,
      focusColor: focusColor,
      hoverColor: hoverColor,
      splashColor: splashColor,
      focusNode: focusNode,
      autofocus: autofocus,
      tileColor: tileColor,
      selectedTileColor: selectedTileColor,
      enableFeedback: enableFeedback,
      horizontalTitleGap: horizontalTitleGap,
      minVerticalPadding: minVerticalPadding,
      minLeadingWidth: minLeadingWidth,
    );
  }

  Widget? _buildTitle(BuildContext context) {
    if (title != null) {
      if (text == null) {
        return title;
      }
      return Row(
        children: [
          Expanded(
            flex: titleFlex,
            child: title!,
          ),
          SizedBox(width: space),
          Flexible(
            flex: textFlex,
            child: text!,
          ),
        ],
      );
    } else {
      return text;
    }
  }
}
