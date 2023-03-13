part of katana_ui;

/// Widget for displaying labels used for item titles, etc.
///
/// Icons can be displayed in [text] and [leading] to give easy-to-understand labels.
///
/// Labels can also be decorated by adding [backgroundColor] and [decoration].
///
/// 項目のタイトルなどで使うラベルを表示するためのウィジェット。
///
/// [text]と[leading]にアイコンを表示することでわかりやすいラベルを付与することができます。
///
/// また、[backgroundColor]や[decoration]を追加することでラベルを装飾することが可能です。
class Label extends StatelessWidget {
  /// Widget for displaying labels used for item titles, etc.
  ///
  /// Icons can be displayed in [text] and [leading] to give easy-to-understand labels.
  ///
  /// Labels can also be decorated by adding [backgroundColor] and [decoration].
  ///
  /// 項目のタイトルなどで使うラベルを表示するためのウィジェット。
  ///
  /// [text]と[leading]にアイコンを表示することでわかりやすいラベルを付与することができます。
  ///
  /// また、[backgroundColor]や[decoration]を追加することでラベルを装飾することが可能です。
  const Label(
    this.text, {
    super.key,
    this.leading,
    this.backgroundColor,
    this.color,
    this.padding,
    this.decoration,
    this.textStyle,
    this.iconSize,
    this.leadingSpace,
    this.alignment,
    this.textAlign = TextAlign.start,
    this.actions = const [],
  });

  /// The text to display.
  ///
  /// 表示するテキスト。
  final String text;

  /// The widget to display before the text.
  ///
  /// テキストの前に表示するウィジェット。
  final Widget? leading;

  /// The background color of the label.
  ///
  /// ラベルの背景色。
  final Color? backgroundColor;

  /// The color of the text and icon.
  ///
  /// テキストとアイコンの色。
  final Color? color;

  /// The padding of the label.
  ///
  /// ラベルのパディング。
  final EdgeInsetsGeometry? padding;

  /// The decoration of the label.
  ///
  /// ラベルの装飾。
  final Decoration? decoration;

  /// The style of the text.
  ///
  /// テキストのスタイル。
  final TextStyle? textStyle;

  /// The size of the icon.
  ///
  /// アイコンのサイズ。
  final double? iconSize;

  /// The space between the icon and the text.
  ///
  /// アイコンとテキストの間のスペース。
  final double? leadingSpace;

  /// Text position.
  ///
  /// テキストの位置。
  final TextAlign textAlign;

  /// Label Location.
  ///
  /// ラベルの位置。
  final Alignment? alignment;

  /// List of actions to be displayed on the right.
  ///
  /// 右側に表示するアクションのリスト。
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final textTheme = textStyle ?? Theme.of(context).textTheme.titleLarge;

    return Container(
      padding: padding,
      alignment: alignment,
      decoration: decoration,
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            IconTheme(
              data: IconThemeData(
                color: color ?? textTheme?.color,
                size: iconSize ?? textTheme?.fontSize,
              ),
              child: leading!,
            ),
            SizedBox(width: leadingSpace ?? 16),
          ],
          Text(
            text,
            style: textTheme?.copyWith(color: color),
            textAlign: textAlign,
          ),
          if (actions.isNotEmpty) ...[
            const Spacer(),
            ...actions.map(
              (e) => Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: e,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
