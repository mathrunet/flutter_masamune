part of '/katana_ui.dart';

/// Default height of [AvatarTile].
///
/// [AvatarTile]のデフォルトの高さ。
const kAvatarTileHeight = 128.0;

/// Tiles for displaying profiles and other overviews.
///
/// You can set a large image for [avatar].
///
/// You can set large text for [title] and small text or tags for [subtitle].
///
/// The [description] field allows you to set a description.
///
/// プロフィールなどの概要を表示するためのタイル。
///
/// [avatar]に大きな画像を設定することができます。
///
/// [title]には大きな文字を、[subtitle]には小さな文字やタグを設定することができます。
///
/// [description]には説明文を設定することができます。
class AvatarTile extends StatelessWidget {
  /// Tiles for displaying profiles and other overviews.
  ///
  /// You can set a large image for [avatar].
  ///
  /// You can set large text for [title] and small text or tags for [subtitle].
  ///
  /// The [description] field allows you to set a description.
  ///
  /// プロフィールなどの概要を表示するためのタイル。
  ///
  /// [avatar]に大きな画像を設定することができます。
  ///
  /// [title]には大きな文字を、[subtitle]には小さな文字やタグを設定することができます。
  ///
  /// [description]には説明文を設定することができます。
  const AvatarTile({
    super.key,
    this.height = kAvatarTileHeight,
    this.avatar,
    this.titleTextStyle,
    this.title,
    this.subtitle,
    this.subtitleTextStyle,
    this.description,
    this.descriptionTextStyle,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.foregroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  /// Tile Height.
  ///
  /// タイルの高さ。
  final double height;

  /// Tile padding.
  ///
  /// タイルのパディング。
  final EdgeInsetsGeometry padding;

  /// Widget to be placed in the avatar image section.
  ///
  /// アバター画像部分に入れるウィジェット。
  final Widget? avatar;

  /// Widget to be placed in the title section.
  ///
  /// タイトル部分に入れるウィジェット。
  final Widget? title;

  /// Widget to be placed in the subtitle section.
  ///
  /// サブタイトル部分に入れるウィジェット。
  final Widget? subtitle;

  /// Widget to be placed in the description section.
  ///
  /// 説明部分に入れるウィジェット。
  final Widget? description;

  /// Text style for title.
  ///
  /// タイトルのテキストスタイル。
  final TextStyle? titleTextStyle;

  /// Text style for subtitle.
  ///
  /// サブタイトルのテキストスタイル。
  final TextStyle? subtitleTextStyle;

  /// Text style for description.
  ///
  /// 説明のテキストスタイル。
  final TextStyle? descriptionTextStyle;

  /// Tile background color.
  ///
  /// タイルの背景色。
  final Color? backgroundColor;

  /// Tile foreground view.
  ///
  /// タイルの前景色。
  final Color? foregroundColor;

  /// Tile corner rounding.
  ///
  /// タイルの角丸。
  final BorderRadiusGeometry? borderRadius;

  /// Tile borders.
  ///
  /// タイルのボーダー。
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = this.titleTextStyle ??
        Theme.of(context).textTheme.displaySmall ??
        const TextStyle(fontSize: 36);
    final descriptionTextStyle = this.descriptionTextStyle ??
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle(fontSize: 14);
    final subtitleTextStyle = this.subtitleTextStyle ??
        Theme.of(context).textTheme.labelSmall ??
        const TextStyle(fontSize: 11);

    return IconTheme(
      data: IconThemeData(
          color: foregroundColor ?? Theme.of(context).colorScheme.onSurface),
      child: DefaultTextStyle(
        style: TextStyle(
            color: foregroundColor ?? Theme.of(context).colorScheme.onSurface),
        child: Container(
          margin: padding,
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).colorScheme.surface,
            borderRadius: borderRadius,
            border: border,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (avatar != null) ...[
                SizedBox(
                  width: height,
                  height: height,
                  child: avatar!,
                ),
                const SizedBox(width: 32),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null) ...[
                      DefaultTextStyle(
                        style: titleTextStyle,
                        child: title!,
                      ),
                    ],
                    if (subtitle != null) ...[
                      DefaultTextStyle(
                        style: subtitleTextStyle,
                        child: subtitle!,
                      ),
                    ],
                    if (description != null) ...[
                      const Spacer(),
                      DefaultTextStyle(
                        style: descriptionTextStyle,
                        child: description!,
                      ),
                    ],
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
