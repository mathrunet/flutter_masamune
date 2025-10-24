part of "/katana_ui.dart";

/// A customizable label widget for displaying section headers and titles.
///
/// This widget provides a flexible label component with support for icons,
/// text styling, and action buttons. Perfect for section headers, category
/// labels, and form field labels.
///
/// Features:
/// - Optional leading icon/widget
/// - Customizable text styling
/// - Background color and decoration support
/// - Action buttons on the right side
/// - Flexible alignment and padding
/// - Theme-based default styling
/// - Adjustable icon size and spacing
///
/// Example:
/// ```dart
/// Label(
///   "Section Title",
///   leading: const Icon(Icons.settings),
///   backgroundColor: Colors.blue.withOpacity(0.1),
///   padding: const EdgeInsets.all(16),
///   actions: [
///     IconButton(
///       icon: const Icon(Icons.add),
///       onPressed: () {
///         // Handle action
///       },
///     ),
///   ],
/// )
/// ```
///
/// セクションヘッダーやタイトルを表示するためのカスタマイズ可能なラベルウィジェット。
///
/// アイコン、テキストスタイリング、アクションボタンのサポートを備えた
/// 柔軟なラベルコンポーネントを提供します。セクションヘッダー、カテゴリラベル、
/// フォームフィールドラベルに最適です。
///
/// 特徴:
/// - オプションのリーディングアイコン/ウィジェット
/// - カスタマイズ可能なテキストスタイリング
/// - 背景色と装飾のサポート
/// - 右側のアクションボタン
/// - 柔軟な配置とパディング
/// - テーマベースのデフォルトスタイリング
/// - 調整可能なアイコンサイズと間隔
///
/// 例:
/// ```dart
/// Label(
///   "セクションタイトル",
///   leading: const Icon(Icons.settings),
///   backgroundColor: Colors.blue.withOpacity(0.1),
///   padding: const EdgeInsets.all(16),
///   actions: [
///     IconButton(
///       icon: const Icon(Icons.add),
///       onPressed: () {
///         // アクション処理
///       },
///     ),
///   ],
/// )
/// ```
class Label extends StatelessWidget {
  /// A customizable label widget for displaying section headers and titles.
  ///
  /// This widget provides a flexible label component with support for icons,
  /// text styling, and action buttons. Perfect for section headers, category
  /// labels, and form field labels.
  ///
  /// Features:
  /// - Optional leading icon/widget
  /// - Customizable text styling
  /// - Background color and decoration support
  /// - Action buttons on the right side
  /// - Flexible alignment and padding
  /// - Theme-based default styling
  /// - Adjustable icon size and spacing
  ///
  /// Example:
  /// ```dart
  /// Label(
  ///   "Section Title",
  ///   leading: const Icon(Icons.settings),
  ///   backgroundColor: Colors.blue.withOpacity(0.1),
  ///   padding: const EdgeInsets.all(16),
  ///   actions: [
  ///     IconButton(
  ///       icon: const Icon(Icons.add),
  ///       onPressed: () {
  ///         // Handle action
  ///       },
  ///     ),
  ///   ],
  /// )
  /// ```
  ///
  /// セクションヘッダーやタイトルを表示するためのカスタマイズ可能なラベルウィジェット。
  ///
  /// アイコン、テキストスタイリング、アクションボタンのサポートを備えた
  /// 柔軟なラベルコンポーネントを提供します。セクションヘッダー、カテゴリラベル、
  /// フォームフィールドラベルに最適です。
  ///
  /// 特徴:
  /// - オプションのリーディングアイコン/ウィジェット
  /// - カスタマイズ可能なテキストスタイリング
  /// - 背景色と装飾のサポート
  /// - 右側のアクションボタン
  /// - 柔軟な配置とパディング
  /// - テーマベースのデフォルトスタイリング
  /// - 調整可能なアイコンサイズと間隔
  ///
  /// 例:
  /// ```dart
  /// Label(
  ///   "セクションタイトル",
  ///   leading: const Icon(Icons.settings),
  ///   backgroundColor: Colors.blue.withOpacity(0.1),
  ///   padding: const EdgeInsets.all(16),
  ///   actions: [
  ///     IconButton(
  ///       icon: const Icon(Icons.add),
  ///       onPressed: () {
  ///         // アクション処理
  ///       },
  ///     ),
  ///   ],
  /// )
  /// ```
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
    final textTheme = textStyle ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            );

    return Container(
      padding: padding,
      alignment: alignment,
      decoration: decoration,
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[
            IconTheme(
              data: IconThemeData(
                color: color ?? textTheme?.color,
                size: iconSize ?? textTheme?.fontSize * 1.5,
              ),
              child: leading!,
            ),
            SizedBox(width: leadingSpace ?? 8),
          ],
          Text(
            text,
            style: textTheme?.copyWith(color: color, height: 1.0),
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
