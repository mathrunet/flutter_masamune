part of "/katana_ui.dart";

/// An informational message box widget with icon, label, and optional actions.
///
/// This widget creates a styled message container with an icon on the left,
/// message content in the center, and optional action buttons on the right.
/// Perfect for alerts, notifications, info boxes, warnings, and error messages.
///
/// Features:
/// - Icon + message + actions layout
/// - Customizable colors (main color and background)
/// - Default icon (Icons.info_outline) when not specified
/// - Automatic background color (10% opacity of main color)
/// - Optional action buttons
/// - Customizable border and border radius
/// - Adjustable padding and margin
///
/// Example:
/// ```dart
/// MessageBox(
///   label: Text("This is an important message"),
///   icon: Icon(Icons.warning),
///   color: Colors.orange,
///   actions: [
///     TextButton(
///       onPressed: () {},
///       child: Text("Dismiss"),
///     ),
///   ],
/// )
/// ```
///
/// メッセージを表示するためのボックス。
///
/// このウィジェットは、左側にアイコン、中央にメッセージコンテンツ、右側にオプションの
/// アクションボタンを持つスタイル付きメッセージコンテナを作成します。
/// アラート、通知、情報ボックス、警告、エラーメッセージに最適です。
///
/// 特徴:
/// - アイコン + メッセージ + アクションのレイアウト
/// - カスタマイズ可能な色（メインカラーと背景）
/// - 未指定時のデフォルトアイコン（Icons.info_outline）
/// - 自動背景色（メインカラーの10%不透明度）
/// - オプションのアクションボタン
/// - カスタマイズ可能なボーダーと角丸
/// - 調整可能なパディングとマージン
///
/// 例:
/// ```dart
/// MessageBox(
///   label: Text("これは重要なメッセージです"),
///   icon: Icon(Icons.warning),
///   color: Colors.orange,
///   actions: [
///     TextButton(
///       onPressed: () {},
///       child: Text("閉じる"),
///     ),
///   ],
/// )
/// ```
class MessageBox extends StatelessWidget {
  /// An informational message box widget with icon, label, and optional actions.
  ///
  /// This widget creates a styled message container with an icon on the left,
  /// message content in the center, and optional action buttons on the right.
  /// Perfect for alerts, notifications, info boxes, warnings, and error messages.
  ///
  /// Features:
  /// - Icon + message + actions layout
  /// - Customizable colors (main color and background)
  /// - Default icon (Icons.info_outline) when not specified
  /// - Automatic background color (10% opacity of main color)
  /// - Optional action buttons
  /// - Customizable border and border radius
  /// - Adjustable padding and margin
  ///
  /// Example:
  /// ```dart
  /// MessageBox(
  ///   label: Text("This is an important message"),
  ///   icon: Icon(Icons.warning),
  ///   color: Colors.orange,
  ///   actions: [
  ///     TextButton(
  ///       onPressed: () {},
  ///       child: Text("Dismiss"),
  ///     ),
  ///   ],
  /// )
  /// ```
  ///
  /// メッセージを表示するためのボックス。
  ///
  /// このウィジェットは、左側にアイコン、中央にメッセージコンテンツ、右側にオプションの
  /// アクションボタンを持つスタイル付きメッセージコンテナを作成します。
  /// アラート、通知、情報ボックス、警告、エラーメッセージに最適です。
  ///
  /// 特徴:
  /// - アイコン + メッセージ + アクションのレイアウト
  /// - カスタマイズ可能な色（メインカラーと背景）
  /// - 未指定時のデフォルトアイコン（Icons.info_outline）
  /// - 自動背景色（メインカラーの10%不透明度）
  /// - オプションのアクションボタン
  /// - カスタマイズ可能なボーダーと角丸
  /// - 調整可能なパディングとマージン
  ///
  /// 例:
  /// ```dart
  /// MessageBox(
  ///   label: Text("これは重要なメッセージです"),
  ///   icon: Icon(Icons.warning),
  ///   color: Colors.orange,
  ///   actions: [
  ///     TextButton(
  ///       onPressed: () {},
  ///       child: Text("閉じる"),
  ///     ),
  ///   ],
  /// )
  /// ```
  const MessageBox({
    required this.label,
    super.key,
    this.icon,
    this.textStyle,
    this.backgroundColor,
    this.border,
    this.borderRadius,
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.margin,
    this.actions = const [],
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

  /// Content Mergin.
  ///
  /// コンテンツのマージン。
  final EdgeInsetsGeometry? margin;

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

  /// List of message box actions.
  ///
  /// メッセージボックスのアクション一覧。
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).primaryColor;
    final backgroundColor =
        this.backgroundColor ?? color.withValues(alpha: 0.1);

    return Container(
      margin: margin,
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
              if (actions.isNotEmpty) const SizedBox(width: 16),
              ...actions,
            ],
          ),
        ),
      ),
    );
  }
}
