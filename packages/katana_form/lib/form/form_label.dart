part of "/katana_form.dart";

/// Displays the label for each item on the form.
///
/// フォームフィールドのラベルを表示するためのウィジェット。
/// `FormStyle`で共通したデザインを適用可能。必須マーク、ヘルプテキスト、エラーメッセージなどの表示機能を備えています。
///
/// ## 基本的な使い方
///
/// Pass the text to be displayed to [label].
///
/// [label]に表示するテキストを渡します。
///
/// ## アイコンの表示
///
/// By specifying [icon], an icon is displayed before [label].
///
/// [icon]を指定することで[label]の前にアイコンが表示されます。
///
/// ## 色の変更
///
/// You can change the color of [label] and [icon] by specifying [color].
///
/// [color]を指定すると[label]と[icon]の色を変えることができます。
///
/// ## プレフィックス・サフィックス
///
/// If [prefix] and [suffix] are specified, widgets can be placed before and after the dividing line.
///
/// [prefix]と[suffix]を指定すると分断線の前後にWidgetを配置することができます。
///
/// ## 基本的な使用例
///
/// ```dart
/// FormLabel(
///   "ユーザー名",
/// );
/// ```
///
/// ## アイコン付きの使用例
///
/// ```dart
/// FormLabel(
///   "ユーザー名",
///   icon: Icons.person,
/// );
/// ```
///
/// ## ヘルプテキスト付きの使用例
///
/// ```dart
/// FormLabel(
///   "ユーザー名",
///   icon: Icons.person,
///   notice: Text("8文字以上の英数字を入力してください"),
/// );
/// ```
class FormLabel extends StatelessWidget {
  /// Displays the label for each item on the form.
  ///
  /// フォームフィールドのラベルを表示するためのウィジェット。
  /// `FormStyle`で共通したデザインを適用可能。必須マーク、ヘルプテキスト、エラーメッセージなどの表示機能を備えています。
  ///
  /// ## 基本的な使い方
  ///
  /// Pass the text to be displayed to [label].
  ///
  /// [label]に表示するテキストを渡します。
  ///
  /// ## アイコンの表示
  ///
  /// By specifying [icon], an icon is displayed before [label].
  ///
  /// [icon]を指定することで[label]の前にアイコンが表示されます。
  ///
  /// ## 色の変更
  ///
  /// You can change the color of [label] and [icon] by specifying [color].
  ///
  /// [color]を指定すると[label]と[icon]の色を変えることができます。
  ///
  /// ## プレフィックス・サフィックス
  ///
  /// If [prefix] and [suffix] are specified, widgets can be placed before and after the dividing line.
  ///
  /// [prefix]と[suffix]を指定すると分断線の前後にWidgetを配置することができます。
  ///
  /// ## 基本的な使用例
  ///
  /// ```dart
  /// FormLabel(
  ///   "ユーザー名",
  /// );
  /// ```
  ///
  /// ## アイコン付きの使用例
  ///
  /// ```dart
  /// FormLabel(
  ///   "ユーザー名",
  ///   icon: Icons.person,
  /// );
  /// ```
  ///
  /// ## ヘルプテキスト付きの使用例
  ///
  /// ```dart
  /// FormLabel(
  ///   "ユーザー名",
  ///   icon: Icons.person,
  ///   notice: Text("8文字以上の英数字を入力してください"),
  /// );
  /// ```
  const FormLabel(
    this.label, {
    super.key,
    this.icon,
    this.style,
    this.color,
    this.prefix,
    this.suffix,
    this.notice,
    this.showDivider = true,
  });

  /// Display the icon in front of [label].
  ///
  /// [label]の前にアイコンを表示します。
  final IconData? icon;

  /// Form style.
  ///
  /// フォームのスタイル。
  final FormStyle? style;

  /// Change the color of [label] and [icon].
  ///
  /// [label]と[icon]の色を変更します。
  final Color? color;

  /// Widget displayed before the dividing line.
  ///
  /// 分断線の前に表示されるWidget。
  final Widget? prefix;

  /// Widget displayed after the dividing line.
  ///
  /// 分断線の後に表示されるWidget。
  final Widget? suffix;

  /// Form labels.
  ///
  /// フォームのラベル。
  final String label;

  /// Widget for annotations. It appears after the label.
  ///
  /// 注釈用のウィジェット。ラベルの後に表示されます。
  final Widget? notice;

  /// `true` if you want to display the separator line.
  ///
  /// 区切り線を表示する場合`true`。
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final dividerColor = style?.borderColor ??
        Theme.of(context).textTheme.titleMedium?.color?.withValues(alpha: 0.5);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (showDivider) ...[
          SizedBox(width: 12, child: Divider(color: dividerColor)),
          const SizedBox(width: 4),
        ],
        if (prefix != null) ...[
          prefix!,
          const SizedBox(width: 4),
        ],
        if (icon != null) ...[
          Icon(
            icon,
            color: color ?? style?.color,
            size: 12,
          ),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: TextStyle(
            color: color ?? style?.color,
            fontSize: 12,
          ),
        ),
        if (notice != null) ...[
          const SizedBox(width: 4),
          notice!,
        ],
        if (showDivider) ...[
          const SizedBox(width: 4),
          Expanded(child: Divider(color: dividerColor)),
        ] else ...[
          const Spacer(),
        ],
        if (suffix != null) ...[
          const SizedBox(width: 4),
          suffix!,
          if (showDivider) ...[
            SizedBox(width: 12, child: Divider(color: dividerColor)),
          ],
        ],
      ],
    );
  }
}
