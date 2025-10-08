part of "/katana_ui.dart";

/// A customizable chat bubble widget for messaging interfaces.
///
/// This widget creates chat message bubbles with support for avatars, titles,
/// actions, and flexible styling. Perfect for chat applications, messaging
/// interfaces, and conversation displays.
///
/// Features:
/// - Left/right alignment for sent/received messages
/// - Avatar/icon support (leading/trailing)
/// - Optional title for sender name
/// - Action buttons below message
/// - Customizable styling and colors
/// - Flexible padding and spacing
/// - Theme-based default styling
/// - Reverse mode for message direction
///
/// Example:
/// ```dart
/// ChatTile(
///   Text("Hello! How are you?"),
///   leading: CircleAvatar(
///     child: Text("JS"),
///   ),
///   title: Text("John Smith"),
///   backgroundColor: Colors.grey[100],
///   mainAxisAlignment: MainAxisAlignment.start,
/// )
/// ```
///
/// メッセージングインターフェース用のカスタマイズ可能なチャット吹き出しウィジェット。
///
/// このウィジェットはアバター、タイトル、アクション、柔軟なスタイリングをサポートする
/// チャットメッセージバブルを作成します。チャットアプリケーション、メッセージング
/// インターフェース、会話表示に最適です。
///
/// 特徴:
/// - 送信/受信メッセージの左右配置
/// - アバター/アイコンサポート（leading/trailing）
/// - 送信者名のオプションタイトル
/// - メッセージ下部のアクションボタン
/// - カスタマイズ可能なスタイリングとカラー
/// - 柔軟なパディングと間隔
/// - テーマベースのデフォルトスタイリング
/// - メッセージ方向のリバースモード
///
/// 例:
/// ```dart
/// ChatTile(
///   Text("こんにちは！元気ですか？"),
///   leading: CircleAvatar(
///     child: Text("田中"),
///   ),
///   title: Text("田中太郎"),
///   backgroundColor: Colors.grey[100],
///   mainAxisAlignment: MainAxisAlignment.start,
/// )
/// ```
@immutable
class ChatTile extends StatelessWidget {
  /// A customizable chat bubble widget for messaging interfaces.
  ///
  /// This widget creates chat message bubbles with support for avatars, titles,
  /// actions, and flexible styling. Perfect for chat applications, messaging
  /// interfaces, and conversation displays.
  ///
  /// Features:
  /// - Left/right alignment for sent/received messages
  /// - Avatar/icon support (leading/trailing)
  /// - Optional title for sender name
  /// - Action buttons below message
  /// - Customizable styling and colors
  /// - Flexible padding and spacing
  /// - Theme-based default styling
  /// - Reverse mode for message direction
  ///
  /// Example:
  /// ```dart
  /// ChatTile(
  ///   Text("Hello! How are you?"),
  ///   leading: CircleAvatar(
  ///     child: Text("JS"),
  ///   ),
  ///   title: Text("John Smith"),
  ///   backgroundColor: Colors.grey[100],
  ///   mainAxisAlignment: MainAxisAlignment.start,
  /// )
  /// ```
  ///
  /// メッセージングインターフェース用のカスタマイズ可能なチャット吹き出しウィジェット。
  ///
  /// このウィジェットはアバター、タイトル、アクション、柔軟なスタイリングをサポートする
  /// チャットメッセージバブルを作成します。チャットアプリケーション、メッセージング
  /// インターフェース、会話表示に最適です。
  ///
  /// 特徴:
  /// - 送信/受信メッセージの左右配置
  /// - アバター/アイコンサポート（leading/trailing）
  /// - 送信者名のオプションタイトル
  /// - メッセージ下部のアクションボタン
  /// - カスタマイズ可能なスタイリングとカラー
  /// - 柔軟なパディングと間隔
  /// - テーマベースのデフォルトスタイリング
  /// - メッセージ方向のリバースモード
  ///
  /// 例:
  /// ```dart
  /// ChatTile(
  ///   Text("こんにちは！元気ですか？"),
  ///   leading: CircleAvatar(
  ///     child: Text("田中"),
  ///   ),
  ///   title: Text("田中太郎"),
  ///   backgroundColor: Colors.grey[100],
  ///   mainAxisAlignment: MainAxisAlignment.start,
  /// )
  /// ```
  const ChatTile(
    this.label, {
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.actions = const [],
    this.leading,
    this.trailing,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(vertical: 4),
    this.contentPadding = const EdgeInsets.all(16),
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.space = 4,
    this.title,
    this.reverse = false,
    this.bottom,
  });

  /// Body of chat.
  ///
  /// チャットの本文。
  final Widget label;

  /// Background color.
  ///
  /// 背景色。
  final Color? backgroundColor;

  /// Color of text and icons.
  ///
  /// テキストやアイコンの色。
  final Color? foregroundColor;

  /// Text Style.
  ///
  /// テキストのスタイル。
  final TextStyle? textStyle;

  /// Action to be placed below the body of the chat.
  ///
  /// チャット本文の下に配置するアクション。
  final List<Widget> actions;

  /// Rounded corners for chat containers.
  ///
  /// チャットコンテナの角丸。
  final BorderRadiusGeometry? borderRadius;

  /// Icon to be placed on the left side of the chat container.
  ///
  /// チャットコンテナの左側に配置するアイコン。
  final Widget? leading;

  /// Icon to be placed on the right side of the chat container.
  ///
  /// チャットコンテナの右側に配置するアイコン。
  final Widget? trailing;

  /// Widget to be displayed in the title section.
  ///
  /// タイトル部に表示するウィジェット。
  final Widget? title;

  /// Padding throughout the chat.
  ///
  /// チャット全体のパディング。
  final EdgeInsetsGeometry padding;

  /// Padding inside the chat container.
  ///
  /// チャットコンテナの内側のパディング。
  final EdgeInsetsGeometry contentPadding;

  /// Alignment of the chat container.
  ///
  /// チャットコンテナの配置。
  final MainAxisAlignment mainAxisAlignment;

  /// Alignment of the chat container.
  ///
  /// チャットコンテナの配置。
  final CrossAxisAlignment crossAxisAlignment;

  /// Space between chat containers.
  ///
  /// チャットコンテナ間のスペース。
  final double space;

  /// If `true`, reverse the orientation.
  ///
  /// `true`の場合、向きを逆にします。
  final bool reverse;

  /// Widget to be displayed at the bottom of the chat container.
  ///
  /// チャットコンテナの下部に表示するウィジェット。
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: IconThemeData(
        color: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
      ),
      child: DefaultTextStyle(
        style: (textStyle ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(
              color: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
            ) ??
            TextStyle(
              color: foregroundColor ?? Theme.of(context).colorScheme.onSurface,
            ),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (reverse) ...[
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      if (trailing != null) ...[
                        trailing!,
                        SizedBox(width: space),
                      ],
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (title != null) ...[
                              title!,
                            ],
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius:
                                    borderRadius ?? BorderRadius.circular(8.0),
                                color: backgroundColor ??
                                    Theme.of(context).colorScheme.surface,
                              ),
                              child: Padding(
                                padding: contentPadding,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    label,
                                    if (actions.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: actions,
                                      )
                                    ]
                                  ],
                                ),
                              ),
                            ),
                            if (bottom != null) ...[
                              bottom!,
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: space),
                ],
              ] else ...[
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: space),
                ],
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (title != null) ...[
                              title!,
                            ],
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius:
                                    borderRadius ?? BorderRadius.circular(8.0),
                                color: backgroundColor ??
                                    Theme.of(context).colorScheme.surface,
                              ),
                              child: Padding(
                                padding: contentPadding,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    label,
                                    if (actions.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: actions,
                                      )
                                    ]
                                  ],
                                ),
                              ),
                            ),
                            if (bottom != null) ...[
                              bottom!,
                            ],
                          ],
                        ),
                      ),
                      if (trailing != null) ...[
                        SizedBox(width: space),
                        trailing!,
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
