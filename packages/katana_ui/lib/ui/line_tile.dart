part of "/katana_ui.dart";

/// An enhanced ListTile with a text widget positioned to the right of the title.
///
/// This widget extends ListTile by adding a [text] property that displays content
/// to the right of the title. Perfect for key-value displays, settings rows,
/// and form field layouts.
///
/// Features:
/// - Additional [text] widget alongside title
/// - Adjustable flex ratios for title and text ([titleFlex], [textFlex])
/// - Customizable spacing between title and text
/// - Shimmer effect support for loading states
/// - Full ListTile functionality inheritance
/// - Works with ListTileGroup for grouped styling
///
/// Example:
/// ```dart
/// LineTile(
///   title: const Text("Username"),
///   text: const Text(
///     "john_doe",
///     style: TextStyle(color: Colors.grey),
///   ),
///   leading: const Icon(Icons.person),
///   onTap: () {
///     // Handle tap
///   },
/// )
/// ```
///
/// タイトルの右側にテキストウィジェットを配置できる拡張ListTile。
///
/// このウィジェットはListTileを拡張し、タイトルの右側にコンテンツを表示する
/// [text]プロパティを追加します。キー値表示、設定行、フォームフィールドレイアウトに最適です。
///
/// 特徴:
/// - タイトルと並んで表示される追加の[text]ウィジェット
/// - タイトルとテキストの調整可能なフレックス比率（[titleFlex]、[textFlex]）
/// - タイトルとテキスト間のカスタマイズ可能な間隔
/// - ローディング状態のシマーエフェクトサポート
/// - ListTileの全機能を継承
/// - グループ化されたスタイリングのためのListTileGroupと連携
///
/// 例:
/// ```dart
/// LineTile(
///   title: const Text("ユーザー名"),
///   text: const Text(
///     "john_doe",
///     style: TextStyle(color: Colors.grey),
///   ),
///   leading: const Icon(Icons.person),
///   onTap: () {
///     // タップ処理
///   },
/// )
/// ```
@immutable
class LineTile extends ListTile {
  /// An enhanced ListTile with a text widget positioned to the right of the title.
  ///
  /// This widget extends ListTile by adding a [text] property that displays content
  /// to the right of the title. Perfect for key-value displays, settings rows,
  /// and form field layouts.
  ///
  /// Features:
  /// - Additional [text] widget alongside title
  /// - Adjustable flex ratios for title and text ([titleFlex], [textFlex])
  /// - Customizable spacing between title and text
  /// - Shimmer effect support for loading states
  /// - Full ListTile functionality inheritance
  /// - Works with ListTileGroup for grouped styling
  ///
  /// Example:
  /// ```dart
  /// LineTile(
  ///   title: const Text("Username"),
  ///   text: const Text(
  ///     "john_doe",
  ///     style: TextStyle(color: Colors.grey),
  ///   ),
  ///   leading: const Icon(Icons.person),
  ///   onTap: () {
  ///     // Handle tap
  ///   },
  /// )
  /// ```
  ///
  /// タイトルの右側にテキストウィジェットを配置できる拡張ListTile。
  ///
  /// このウィジェットはListTileを拡張し、タイトルの右側にコンテンツを表示する
  /// [text]プロパティを追加します。キー値表示、設定行、フォームフィールドレイアウトに最適です。
  ///
  /// 特徴:
  /// - タイトルと並んで表示される追加の[text]ウィジェット
  /// - タイトルとテキストの調整可能なフレックス比率（[titleFlex]、[textFlex]）
  /// - タイトルとテキスト間のカスタマイズ可能な間隔
  /// - ローディング状態のシマーエフェクトサポート
  /// - ListTileの全機能を継承
  /// - グループ化されたスタイリングのためのListTileGroupと連携
  ///
  /// 例:
  /// ```dart
  /// LineTile(
  ///   title: const Text("ユーザー名"),
  ///   text: const Text(
  ///     "john_doe",
  ///     style: TextStyle(color: Colors.grey),
  ///   ),
  ///   leading: const Icon(Icons.person),
  ///   onTap: () {
  ///     // タップ処理
  ///   },
  /// )
  /// ```
  const LineTile({
    super.key,
    super.leading,
    super.title,
    this.text,
    this.space = 8.0,
    this.titleFlex = 1,
    this.textFlex = 1,
    super.subtitle,
    super.trailing,
    super.isThreeLine = false,
    super.dense,
    super.visualDensity,
    super.shape,
    super.style,
    super.selectedColor,
    super.iconColor,
    super.textColor,
    super.contentPadding,
    super.enabled = true,
    super.onTap,
    super.onLongPress,
    super.onFocusChange,
    super.mouseCursor,
    super.selected = false,
    super.focusColor,
    super.hoverColor,
    super.splashColor,
    super.focusNode,
    super.autofocus = false,
    super.tileColor,
    super.selectedTileColor,
    super.enableFeedback,
    super.horizontalTitleGap,
    super.minVerticalPadding,
    super.minLeadingWidth,
    this.shimmer = false,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
  });

  /// Widget to display next to the title.
  ///
  /// タイトルの横に表示するためのウィジェット。
  final Widget? text;

  /// Flex. in the title section.
  ///
  /// タイトル部分のflex.
  final int titleFlex;

  /// Flex. in the text section.
  ///
  /// テキスト部分のflex.
  final int textFlex;

  /// Space between title and text.
  ///
  /// タイトルとテキスト間のスペース。
  final double space;

  /// Specify `true` to use shimmer effect.
  ///
  /// シマーエフェクトを利用する場合に`true`を指定します。
  final bool shimmer;

  /// Base color for shimmer effects.
  ///
  /// シマーエフェクトを利用する場合のベースカラー。
  final Color? shimmerBaseColor;

  /// Highlight color when using shimmer effect.
  ///
  /// シマーエフェクトを利用する場合のハイライトカラー。
  final Color? shimmerHighlightColor;

  @override
  Widget build(BuildContext context) {
    final scope = _LineTileGroupScope.of(context);
    if (shimmer) {
      return sm.Shimmer.fromColors(
        baseColor: shimmerBaseColor ?? Theme.of(context).colorScheme.surface,
        highlightColor:
            shimmerHighlightColor ?? Theme.of(context).scaffoldBackgroundColor,
        child: Material(
          color: Colors.transparent,
          child: ListTile(
            leading: leading,
            title: _buildTitle(context),
            subtitle: subtitle != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: shimmerBaseColor ??
                          Theme.of(context).colorScheme.surface,
                    ),
                    height: Theme.of(context)
                            .listTileTheme
                            .subtitleTextStyle
                            ?.fontSize ??
                        12,
                    width: double.infinity,
                  )
                : null,
            trailing: trailing,
            isThreeLine: isThreeLine,
            dense: dense,
            visualDensity:
                visualDensity ?? (scope != null ? VisualDensity.compact : null),
            shape: shape,
            style: style,
            selectedColor: selectedColor,
            iconColor: iconColor,
            textColor: textColor,
            contentPadding: contentPadding,
            enabled: enabled,
            onTap: onTap,
            onLongPress: onLongPress,
            onFocusChange: onFocusChange,
            mouseCursor: mouseCursor,
            selected: selected,
            focusColor: focusColor,
            hoverColor: hoverColor,
            splashColor: splashColor,
            focusNode: focusNode,
            autofocus: autofocus,
            tileColor: tileColor ??
                (scope?.tileColor != null ? Colors.transparent : null),
            selectedTileColor: selectedTileColor ??
                (scope?.tileColor != null ? Colors.transparent : null),
            enableFeedback: enableFeedback,
            horizontalTitleGap: horizontalTitleGap,
            minVerticalPadding: minVerticalPadding,
            minLeadingWidth: minLeadingWidth,
          ),
        ),
      );
    } else {
      return Material(
        color: Colors.transparent,
        child: ListTile(
          leading: leading,
          title: _buildTitle(context),
          subtitle: subtitle,
          trailing: trailing,
          isThreeLine: isThreeLine,
          dense: dense,
          visualDensity:
              visualDensity ?? (scope != null ? VisualDensity.compact : null),
          shape: shape,
          style: style,
          selectedColor: selectedColor,
          iconColor: iconColor,
          textColor: textColor,
          contentPadding: contentPadding,
          enabled: enabled,
          onTap: onTap,
          onLongPress: onLongPress,
          onFocusChange: onFocusChange,
          mouseCursor: mouseCursor,
          selected: selected,
          focusColor: focusColor,
          hoverColor: hoverColor,
          splashColor: splashColor,
          focusNode: focusNode,
          autofocus: autofocus,
          tileColor: tileColor ??
              (scope?.tileColor != null ? Colors.transparent : null),
          selectedTileColor: selectedTileColor ??
              (scope?.tileColor != null ? Colors.transparent : null),
          enableFeedback: enableFeedback,
          horizontalTitleGap: horizontalTitleGap,
          minVerticalPadding: minVerticalPadding,
          minLeadingWidth: minLeadingWidth,
        ),
      );
    }
  }

  Widget? _buildTitle(BuildContext context) {
    if (shimmer) {
      final mock = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: shimmerBaseColor ?? Theme.of(context).colorScheme.surface,
        ),
        height: Theme.of(context).listTileTheme.titleTextStyle?.fontSize ?? 13,
        width: double.infinity,
      );

      if (title != null && text != null) {
        return Row(
          children: [
            Expanded(
              flex: titleFlex,
              child: mock,
            ),
            SizedBox(width: space),
            Flexible(flex: textFlex, child: mock),
          ],
        );
      } else {
        return mock;
      }
    } else {
      if (title != null) {
        if (text == null) {
          return title;
        }
        return Row(
          children: [
            Expanded(
              flex: titleFlex,
              child: title!,
            ),
            SizedBox(width: space),
            Flexible(
              flex: textFlex,
              child: text!,
            ),
          ],
        );
      } else {
        return text;
      }
    }
  }
}
