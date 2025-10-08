part of "/masamune_universal_ui.dart";

/// Tiles that can be used as headers for profiles, etc.
///
/// [UniversalHeaderTile] is a specialized tile widget designed for header sections in profiles and similar layouts.
/// Supports [title], [subtitle], [description], and [actions] with customizable styling and shimmer effect for loading states.
///
/// ## Basic Usage
///
/// ```dart
/// UniversalHeaderTile(
///   title: const Text("User Name"),
///   subtitle: const Text("Subtitle"),
///   description: const Text("Description text"),
///   actions: [
///     IconButton(
///       icon: const Icon(Icons.settings),
///       onPressed: () {
///         // Handle settings action
///       },
///     ),
///   ],
/// );
/// ```
///
/// ---
///
/// プロフィールなどのヘッダーに用いることのできるタイル。
///
/// [UniversalHeaderTile]はプロフィールなどのヘッダーセクション用に設計された専用のタイルウィジェットです。
/// [title]、[subtitle]、[description]、[actions]をサポートし、カスタマイズ可能なスタイリングと読み込み状態用のシマーエフェクトを提供します。
///
/// ## 基本的な利用方法
///
/// ```dart
/// UniversalHeaderTile(
///   title: const Text("ユーザー名"),
///   subtitle: const Text("サブタイトル"),
///   description: const Text("説明文"),
///   actions: [
///     IconButton(
///       icon: const Icon(Icons.settings),
///       onPressed: () {
///         // 設定アクションを処理
///       },
///     ),
///   ],
/// );
/// ```
class UniversalHeaderTile extends StatelessWidget {
  /// Tiles that can be used as headers for profiles, etc.
  ///
  /// [UniversalHeaderTile] is a specialized tile widget designed for header sections in profiles and similar layouts.
  /// Supports [title], [subtitle], [description], and [actions] with customizable styling and shimmer effect for loading states.
  ///
  /// ## Basic Usage
  ///
  /// ```dart
  /// UniversalHeaderTile(
  ///   title: const Text("User Name"),
  ///   subtitle: const Text("Subtitle"),
  ///   description: const Text("Description text"),
  ///   actions: [
  ///     IconButton(
  ///       icon: const Icon(Icons.settings),
  ///       onPressed: () {
  ///         // Handle settings action
  ///       },
  ///     ),
  ///   ],
  /// );
  /// ```
  ///
  /// ---
  ///
  /// プロフィールなどのヘッダーに用いることのできるタイル。
  ///
  /// [UniversalHeaderTile]はプロフィールなどのヘッダーセクション用に設計された専用のタイルウィジェットです。
  /// [title]、[subtitle]、[description]、[actions]をサポートし、カスタマイズ可能なスタイリングと読み込み状態用のシマーエフェクトを提供します。
  ///
  /// ## 基本的な利用方法
  ///
  /// ```dart
  /// UniversalHeaderTile(
  ///   title: const Text("ユーザー名"),
  ///   subtitle: const Text("サブタイトル"),
  ///   description: const Text("説明文"),
  ///   actions: [
  ///     IconButton(
  ///       icon: const Icon(Icons.settings),
  ///       onPressed: () {
  ///         // 設定アクションを処理
  ///       },
  ///     ),
  ///   ],
  /// );
  /// ```
  const UniversalHeaderTile({
    required this.title,
    super.key,
    this.subtitle,
    this.description,
    this.titleTextStyle,
    this.subtitleTextStyle,
    this.descriptionTextStyle,
    this.actions = const [],
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.contentPadding = const EdgeInsets.all(16),
    this.shimmer = false,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.shimmerDescriptionLineCount = 4,
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

  /// Specify `true` to use shimmer effect.
  ///
  /// シマーエフェクトを利用する場合に`true`を指定します。
  final bool shimmer;

  /// Shimmer description line count.
  ///
  /// シマーエフェクトを利用する場合の説明の行数。
  final int shimmerDescriptionLineCount;

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

    if (shimmer) {
      return sm.Shimmer.fromColors(
        baseColor: shimmerBaseColor ?? Theme.of(context).colorScheme.surface,
        highlightColor:
            shimmerHighlightColor ?? Theme.of(context).scaffoldBackgroundColor,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: padding,
            padding: contentPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: shimmerBaseColor ??
                          Theme.of(context).colorScheme.surface,
                    ),
                    height: titleTextStyle?.fontSize ?? 32,
                    width: double.infinity,
                  ),
                ),
                if (subtitle != null) ...[
                  4.sy,
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: shimmerBaseColor ??
                          Theme.of(context).colorScheme.surface,
                    ),
                    height: subtitleTextStyle?.fontSize ?? 22,
                    width: double.infinity,
                  ),
                ],
                if (description != null) ...[
                  16.sy,
                  for (var i = 0; i < shimmerDescriptionLineCount; i++) ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: shimmerBaseColor ??
                            Theme.of(context).colorScheme.surface,
                      ),
                      height: descriptionTextStyle?.fontSize ?? 14,
                      width: double.infinity,
                    ),
                    4.sy,
                  ],
                ],
              ],
            ),
          ),
        ),
      );
    } else {
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
}
