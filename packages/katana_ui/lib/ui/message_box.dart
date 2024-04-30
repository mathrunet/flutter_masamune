part of '/katana_ui.dart';

/// A box for displaying messages.
///
/// You can set a message in [label]. You can set an icon at [icon]. If not set, `Icons.info_outline` will be set.
///
/// You can set the main color in [color] and the background color in [backgroundColor].
///
/// メッセージを表示するためのボックス。
///
/// [label]にメッセージを設定します。[icon]にアイコンを設定できます。設定されていない場合は`Icons.info_outline`が設定されます。
///
/// [color]にメインの色、[backgroundColor]に背景色を設定することができます。
class MessageBox extends StatelessWidget {
  /// A box for displaying messages.
  ///
  /// You can set a message in [label]. You can set an icon at [icon]. If not set, `Icons.info_outline` will be set.
  ///
  /// You can set the main color in [color] and the background color in [backgroundColor].
  ///
  /// メッセージを表示するためのボックス。
  ///
  /// [label]にメッセージを設定します。[icon]にアイコンを設定できます。設定されていない場合は`Icons.info_outline`が設定されます。
  ///
  /// [color]にメインの色、[backgroundColor]に背景色を設定することができます。
  const MessageBox({
    super.key,
    required this.label,
    this.icon,
    this.textStyle,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.padding = const EdgeInsets.all(16),
    this.color,
  });

  /// Main color.
  ///
  /// メインのカラー。
  final Color? color;

  /// Background color.
  ///
  /// 背景色。
  final Color? backgroundColor;

  /// Content Padding.
  ///
  /// コンテンツのパディング。
  final EdgeInsetsGeometry padding;

  /// A widget that can be placed in the message section.
  ///
  /// メッセージ部分にいれるウィジェット。
  final Widget label;

  /// A widget that can be placed in the icon section.
  ///
  /// アイコン部にいれるウィジェット。
  final Widget? icon;

  /// Message text style.
  ///
  /// メッセージのテキストスタイル。
  final TextStyle? textStyle;

  /// Box rounded corners.
  ///
  /// ボックスの角丸。
  final BorderRadiusGeometry? borderRadius;

  /// Box borders.
  ///
  /// ボックスのボーダー。
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).primaryColor;
    final backgroundColor = this.backgroundColor ?? color.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: border ?? Border.all(color: color, width: 1),
      ),
      child: IconTheme(
        data: IconThemeData(color: color, size: 48),
        child: DefaultTextStyle(
          style: TextStyle(color: color),
          child: Row(
            children: [
              icon ?? const Icon(Icons.info_outline),
              const SizedBox(width: 16),
              Expanded(
                child: label,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
