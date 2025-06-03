part of "/masamune_universal_ui.dart";

/// Tiles that can be used as headers for profiles, etc.
///
/// Specify a title in [title].
///
/// You can specify [subtitle] under [title] and [description] below it.
///
/// プロフィールなどのヘッダーに用いることのできるタイル。
///
/// [title]にはタイトルを指定します。
///
/// [title]の下に[subtitle]を指定し、その下に[description]を指定することができます。
class UniversalHeaderTile extends StatelessWidget {
  /// Tiles that can be used as headers for profiles, etc.
  ///
  /// Specify a title in [title].
  ///
  /// You can specify [subtitle] under [title] and [description] below it.
  ///
  /// プロフィールなどのヘッダーに用いることのできるタイル。
  ///
  /// [title]にはタイトルを指定します。
  ///
  /// [title]の下に[subtitle]を指定し、その下に[description]を指定することができます。
  const UniversalHeaderTile({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.descriptionTextStyle,
    this.actions = const [],
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.contentPadding = const EdgeInsets.all(16),
  });

  /// Title.
  ///
  /// タイトル。
  final Widget title;

  /// Subtitle.
  ///
  /// サブタイトル。
  final Widget? subtitle;

  /// Description.
  ///
  /// 説明。
  final Widget? description;

  /// Style of the title.
  ///
  /// タイトルのスタイル。
  final TextStyle? titleTextStyle;

  /// Style of the subtitle.
  ///
  /// サブタイトルのスタイル。
  final TextStyle? subtitleTextStyle;

  /// Style of the description.
  ///
  /// 説明のスタイル。
  final TextStyle? descriptionTextStyle;

  /// Actions.
  ///
  /// アクション。
  final List<Widget> actions;

  /// Padding.
  ///
  /// パディング。
  final EdgeInsetsGeometry padding;

  /// Content padding.
  ///
  /// コンテンツのパディング。
  final EdgeInsetsGeometry contentPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleTextStyle = this.titleTextStyle ??
        theme.textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
        );
    final descriptionTextStyle =
        this.descriptionTextStyle ?? theme.textTheme.bodyMedium;
    final subtitleTextStyle = this.subtitleTextStyle ??
        theme.textTheme.labelLarge?.copyWith(
          color: theme.disabledColor,
        );
    final iconColor = theme.disabledColor;

    return Container(
      margin: padding,
      padding: contentPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTextStyle(
            style: titleTextStyle ?? const TextStyle(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: title,
                  ),
                ),
                ...actions,
              ],
            ),
          ),
          if (subtitle != null) ...[
            4.sy,
            IconTheme(
              data: IconThemeData(
                color: iconColor,
                size: subtitleTextStyle?.fontSize,
              ),
              child: DefaultTextStyle(
                style: subtitleTextStyle ?? const TextStyle(),
                child: subtitle!,
              ),
            ),
          ],
          if (description != null) ...[
            16.sy,
            DefaultTextStyle(
              style: descriptionTextStyle ?? const TextStyle(),
              child: description!,
            ),
          ],
        ],
      ),
    );
  }
}
