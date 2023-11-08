part of '/katana_ui.dart';

/// This widget is used to create a chat screen.
///
/// The body of the chat is described in [label].
///
/// Icons can be specified for [leading] and [trailing].
///
/// By manipulating [alignment], you can visually change whether you are speaking for yourself or for others.
///
/// チャット画面を作成するためのウィジェットです。
///
/// [label]にチャットの本文を記載します。
///
/// [leading]や[trailing]にはアイコンなどを指定することができます。
///
/// [alignment]を操作することで自分の発言か他人の発言かを視覚的に変えることができます。
@immutable
class ChatTile extends StatelessWidget {
  /// This widget is used to create a chat screen.
  ///
  /// The body of the chat is described in [label].
  ///
  /// Icons can be specified for [leading] and [trailing].
  ///
  /// By manipulating [alignment], you can visually change whether you are speaking for yourself or for others.
  ///
  /// チャット画面を作成するためのウィジェットです。
  ///
  /// [label]にチャットの本文を記載します。
  ///
  /// [leading]や[trailing]にはアイコンなどを指定することができます。
  ///
  /// [alignment]を操作することで自分の発言か他人の発言かを視覚的に変えることができます。
  const ChatTile(
    this.label, {
    super.key,
    this.backgroundColor,
    this.foregroundColor,
    this.textStyle,
    this.actions = const [],
    this.leading,
    this.trailing,
    this.elevation = 0.0,
    this.borderRadius,
    this.padding = const EdgeInsets.symmetric(vertical: 4),
    this.contentPadding = const EdgeInsets.all(16),
    this.alignment = MainAxisAlignment.start,
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

  /// Chat container height.
  ///
  /// チャットコンテナの高さ。
  final double elevation;

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
  final MainAxisAlignment alignment;

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
            mainAxisAlignment: alignment,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 16),
              ],
              Flexible(
                child: Card(
                  elevation: elevation,
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(8.0),
                  ),
                  color:
                      backgroundColor ?? Theme.of(context).colorScheme.surface,
                  surfaceTintColor:
                      backgroundColor ?? Theme.of(context).colorScheme.surface,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: actions,
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 16),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
