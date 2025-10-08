part of "/katana_ui.dart";

/// A widget for displaying social media-style content with profile layout.
///
/// This widget creates a Twitter/X-style post layout with a leading avatar,
/// title (username), subtitle (handle/timestamp), main content, and optional bottom actions.
/// Perfect for social media feeds, comment sections, and user-generated content displays.
///
/// Features:
/// - Leading widget area (typically for profile avatars)
/// - Title and subtitle in header row (username and handle/timestamp)
/// - Main content area with customizable padding
/// - Optional bottom action area (like, share, comment buttons)
/// - Customizable spacing between elements
/// - Theme-based text and icon styling
/// - Tap interaction support
///
/// Example:
/// ```dart
/// SnsContentTile(
///   leading: CircleAvatar(child: Icon(Icons.person)),
///   title: Text("Username"),
///   subtitle: Text("@handle · 2h"),
///   content: Text("This is the post content..."),
///   bottom: Row(
///     children: [
///       IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
///       IconButton(icon: Icon(Icons.chat_bubble_outline), onPressed: () {}),
///     ],
///   ),
/// )
/// ```
///
/// SNSのコンテンツを表示するウィジェット。
///
/// このウィジェットはTwitter/Xスタイルの投稿レイアウトを作成し、リーディングアバター、
/// タイトル（ユーザー名）、サブタイトル（ハンドル/タイムスタンプ）、メインコンテンツ、
/// オプションのボトムアクションを含みます。ソーシャルメディアフィード、コメントセクション、
/// ユーザー生成コンテンツの表示に最適です。
///
/// 特徴:
/// - リーディングウィジェットエリア（通常はプロフィールアバター用）
/// - ヘッダー行のタイトルとサブタイトル（ユーザー名とハンドル/タイムスタンプ）
/// - カスタマイズ可能なパディングを持つメインコンテンツエリア
/// - オプションのボトムアクションエリア（いいね、シェア、コメントボタン）
/// - 要素間のカスタマイズ可能なスペーシング
/// - テーマベースのテキストとアイコンのスタイリング
/// - タップインタラクションのサポート
///
/// 例:
/// ```dart
/// SnsContentTile(
///   leading: CircleAvatar(child: Icon(Icons.person)),
///   title: Text("ユーザー名"),
///   subtitle: Text("@handle · 2時間前"),
///   content: Text("投稿内容がここに入ります..."),
///   bottom: Row(
///     children: [
///       IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
///       IconButton(icon: Icon(Icons.chat_bubble_outline), onPressed: () {}),
///     ],
///   ),
/// )
/// ```
class SnsContentTile extends StatelessWidget {
  /// A widget for displaying social media-style content with profile layout.
  ///
  /// This widget creates a Twitter/X-style post layout with a leading avatar,
  /// title (username), subtitle (handle/timestamp), main content, and optional bottom actions.
  /// Perfect for social media feeds, comment sections, and user-generated content displays.
  ///
  /// Features:
  /// - Leading widget area (typically for profile avatars)
  /// - Title and subtitle in header row (username and handle/timestamp)
  /// - Main content area with customizable padding
  /// - Optional bottom action area (like, share, comment buttons)
  /// - Customizable spacing between elements
  /// - Theme-based text and icon styling
  /// - Tap interaction support
  ///
  /// Example:
  /// ```dart
  /// SnsContentTile(
  ///   leading: CircleAvatar(child: Icon(Icons.person)),
  ///   title: Text("Username"),
  ///   subtitle: Text("@handle · 2h"),
  ///   content: Text("This is the post content..."),
  ///   bottom: Row(
  ///     children: [
  ///       IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
  ///       IconButton(icon: Icon(Icons.chat_bubble_outline), onPressed: () {}),
  ///     ],
  ///   ),
  /// )
  /// ```
  ///
  /// SNSのコンテンツを表示するウィジェット。
  ///
  /// このウィジェットはTwitter/Xスタイルの投稿レイアウトを作成し、リーディングアバター、
  /// タイトル（ユーザー名）、サブタイトル（ハンドル/タイムスタンプ）、メインコンテンツ、
  /// オプションのボトムアクションを含みます。ソーシャルメディアフィード、コメントセクション、
  /// ユーザー生成コンテンツの表示に最適です。
  ///
  /// 特徴:
  /// - リーディングウィジェットエリア（通常はプロフィールアバター用）
  /// - ヘッダー行のタイトルとサブタイトル（ユーザー名とハンドル/タイムスタンプ）
  /// - カスタマイズ可能なパディングを持つメインコンテンツエリア
  /// - オプションのボトムアクションエリア（いいね、シェア、コメントボタン）
  /// - 要素間のカスタマイズ可能なスペーシング
  /// - テーマベースのテキストとアイコンのスタイリング
  /// - タップインタラクションのサポート
  ///
  /// 例:
  /// ```dart
  /// SnsContentTile(
  ///   leading: CircleAvatar(child: Icon(Icons.person)),
  ///   title: Text("ユーザー名"),
  ///   subtitle: Text("@handle · 2時間前"),
  ///   content: Text("投稿内容がここに入ります..."),
  ///   bottom: Row(
  ///     children: [
  ///       IconButton(icon: Icon(Icons.favorite_border), onPressed: () {}),
  ///       IconButton(icon: Icon(Icons.chat_bubble_outline), onPressed: () {}),
  ///     ],
  ///   ),
  /// )
  /// ```
  const SnsContentTile({
    super.key,
    this.onTap,
    this.backgroundColor,
    this.margin,
    this.leading,
    this.space = 8,
    this.title,
    this.content,
    this.subtitle,
    this.iconColor,
    this.textColor,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 16),
    this.bottom,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
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
  final double space;

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
  final EdgeInsetsGeometry contentPadding;

  /// The padding around the widget.
  ///
  /// ウィジェットの周囲のパディング。
  final EdgeInsetsGeometry padding;

  /// The widget below this widget in the tree.
  ///
  /// このウィジェットの下のウィジェット。
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = this.backgroundColor;
    final textColor = this.textColor;
    final iconColor = this.iconColor;

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: textColor),
      child: IconTheme(
        data: IconThemeData(color: iconColor),
        child: InkWell(
          onTap: onTap,
          child: Container(
            color: backgroundColor,
            margin: margin,
            padding: padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: space),
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
                          if (title != null) ...[
                            title!,
                            SizedBox(width: space),
                          ],
                          if (subtitle != null) subtitle!,
                        ],
                      ),
                      if (content != null)
                        Padding(
                          padding: contentPadding,
                          child: content!,
                        ),
                      if (bottom != null) bottom!,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
