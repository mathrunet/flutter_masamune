part of "/katana_ui.dart";

/// Default height of [AvatarTile].
///
/// [AvatarTile]のデフォルトの高さ。
const kAvatarTileHeight = 128.0;

/// A tile widget for displaying profile cards and user overviews.
///
/// This widget provides a customizable profile card layout with an avatar image,
/// title, subtitle, and description. Perfect for user profiles, author cards,
/// and social media user displays.
///
/// Features:
/// - Large avatar image display (width/height match tile height)
/// - Three-tier information display (title, subtitle, description)
/// - Customizable text styles for each text element
/// - Flexible styling options (background color, border, border radius)
/// - Theme-based default styling
/// - Fixed height layout (default: [kAvatarTileHeight])
///
/// Example:
/// ```dart
/// AvatarTile(
///   avatar: CircleAvatar(
///     backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
///   ),
///   title: Text("Username"),
///   subtitle: Text("@username"),
///   description: Text("Profile description goes here."),
/// )
/// ```
///
/// プロフィールなどの概要を表示するためのタイル。
///
/// アバター画像、タイトル、サブタイトル、説明文を含むカスタマイズ可能なプロフィールカードレイアウトを提供します。
/// ユーザープロフィール、著者カード、ソーシャルメディアのユーザー表示に最適です。
///
/// 特徴:
/// - 大きなアバター画像の表示（幅/高さはタイルの高さと一致）
/// - 3段階の情報表示（タイトル、サブタイトル、説明文）
/// - 各テキスト要素のカスタマイズ可能なテキストスタイル
/// - 柔軟なスタイリングオプション（背景色、ボーダー、角丸）
/// - テーマベースのデフォルトスタイリング
/// - 固定高さレイアウト（デフォルト: [kAvatarTileHeight]）
///
/// 例:
/// ```dart
/// AvatarTile(
///   avatar: CircleAvatar(
///     backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
///   ),
///   title: Text("ユーザー名"),
///   subtitle: Text("@username"),
///   description: Text("プロフィール説明文をここに記載します。"),
/// )
/// ```
class AvatarTile extends StatelessWidget {
  /// A tile widget for displaying profile cards and user overviews.
  ///
  /// This widget provides a customizable profile card layout with an avatar image,
  /// title, subtitle, and description. Perfect for user profiles, author cards,
  /// and social media user displays.
  ///
  /// Features:
  /// - Large avatar image display (width/height match tile height)
  /// - Three-tier information display (title, subtitle, description)
  /// - Customizable text styles for each text element
  /// - Flexible styling options (background color, border, border radius)
  /// - Theme-based default styling
  /// - Fixed height layout (default: [kAvatarTileHeight])
  ///
  /// Example:
  /// ```dart
  /// AvatarTile(
  ///   avatar: CircleAvatar(
  ///     backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ///   ),
  ///   title: Text("Username"),
  ///   subtitle: Text("@username"),
  ///   description: Text("Profile description goes here."),
  /// )
  /// ```
  ///
  /// プロフィールなどの概要を表示するためのタイル。
  ///
  /// アバター画像、タイトル、サブタイトル、説明文を含むカスタマイズ可能なプロフィールカードレイアウトを提供します。
  /// ユーザープロフィール、著者カード、ソーシャルメディアのユーザー表示に最適です。
  ///
  /// 特徴:
  /// - 大きなアバター画像の表示（幅/高さはタイルの高さと一致）
  /// - 3段階の情報表示（タイトル、サブタイトル、説明文）
  /// - 各テキスト要素のカスタマイズ可能なテキストスタイル
  /// - 柔軟なスタイリングオプション（背景色、ボーダー、角丸）
  /// - テーマベースのデフォルトスタイリング
  /// - 固定高さレイアウト（デフォルト: [kAvatarTileHeight]）
  ///
  /// 例:
  /// ```dart
  /// AvatarTile(
  ///   avatar: CircleAvatar(
  ///     backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ///   ),
  ///   title: Text("ユーザー名"),
  ///   subtitle: Text("@username"),
  ///   description: Text("プロフィール説明文をここに記載します。"),
  /// )
  /// ```
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
