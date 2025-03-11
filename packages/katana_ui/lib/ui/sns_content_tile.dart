part of '/katana_ui.dart';

/// Widget to display SNS content.
///
/// Use in conjunction with [ListTile].
///
/// SNSのコンテンツを表示するウィジェット。
///
/// [ListTile]と併用して使ってください。
class SnsContentTile extends StatelessWidget {
  /// Widget to display SNS content.
  ///
  /// Use in conjunction with [ListTile].
  ///
  /// SNSのコンテンツを表示するウィジェット。
  ///
  /// [ListTile]と併用して使ってください。
  const SnsContentTile({
    super.key,
    this.onTap,
    this.backgroundColor,
    this.margin,
    this.leading,
    this.leadingSpace = 8,
    this.title,
    this.content,
    this.subtitle,
    this.iconColor,
    this.textColor,
    this.contentPadding,
    this.bottom,
  });

  /// A callback that is called when the card is tapped.
  ///
  /// カードがタップされたときに呼び出されるコールバック。
  final VoidCallback? onTap;

  /// The background color of the card.
  ///
  /// カードの背景色。
  final Color? backgroundColor;

  /// The margin around the card.
  ///
  /// カードの周囲のマージン。
  final EdgeInsetsGeometry? margin;

  /// The widget to display before the title.
  ///
  /// タイトルの前に表示するウィジェット。
  final Widget? leading;

  /// The space between the leading widget and the title.
  ///
  /// リーディングウィジェットとタイトルの間のスペース。
  final double leadingSpace;

  /// Title of the list item.
  ///
  /// リストアイテムのタイトル。
  final Widget? title;

  /// Content of the list item.
  ///
  /// リストアイテムのコンテンツ。
  final Widget? content;

  /// Widget to be displayed next to the title.
  ///
  /// タイトルの横に表示するウィジェット。
  final Widget? subtitle;

  /// The color to use for icons and text in the list tile.
  ///
  /// リストタイルのアイコンとテキストに使用する色。
  final Color? iconColor;

  /// The color to use for the text in the list tile.
  ///
  /// リストタイルのテキストに使用する色。
  final Color? textColor;

  /// The padding around the [ListTile] content.
  ///
  /// [ListTile]コンテンツの周囲のパディング。
  final EdgeInsetsGeometry? contentPadding;

  /// The widget below this widget in the tree.
  ///
  /// このウィジェットの下のウィジェット。
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        this.backgroundColor ?? Theme.of(context).colorScheme.surface;
    final textColor = this.textColor ?? Theme.of(context).colorScheme.onSurface;
    final iconColor = this.iconColor ?? Theme.of(context).colorScheme.onSurface;

    return DefaultTextStyle(
      style: TextStyle(color: textColor),
      child: IconTheme(
        data: IconThemeData(color: iconColor),
        child: Container(
          color: backgroundColor,
          margin: margin,
          padding: contentPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leading != null) ...[
                leading!,
                SizedBox(width: leadingSpace),
              ],
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null) title!,
                        if (subtitle != null) subtitle!,
                      ],
                    ),
                    if (content != null) content!,
                    if (bottom != null) bottom!,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
