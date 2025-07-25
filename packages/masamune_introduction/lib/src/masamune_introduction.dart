// Dart imports:
import "dart:async";

// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:introduction_screen/introduction_screen.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_introduction/masamune_introduction.dart";

part "masamune_introduction.page.dart";

/// [PageScopedWidget] in the introduction.
///
/// Page transition is possible with [MasamuneIntroductionPage.query].
///
/// If you want to specify the page after the introduction, specify [routeQuery].
/// If [routeQuery] is [Null], it returns to the previous page after the introduction is finished.
///
/// If you do not want to use it as a page, please use [MasamuneIntroduction].
///
/// 導入部分の[PageScopedWidget]。
///
/// [MasamuneIntroductionPage.query]でページ遷移可能です。
///
/// イントロダクション終了後のページを指定したい場合は[routeQuery]を指定してください。
/// [routeQuery]が[Null]の場合はイントロダクション終了後に前のページに戻ります。
///
/// ページとして利用したくない場合は[MasamuneIntroduction]をご利用ください。
@immutable
@PagePath(
  "tutorial",
  transition: TransitionQuery.fade,
)
class MasamuneIntroductionPage extends PageScopedWidget {
  /// [PageScopedWidget] in the introduction.
  ///
  /// Page transition is possible with [MasamuneIntroductionPage.query].
  ///
  /// If you want to specify the page after the introduction, specify [routeQuery].
  /// If [routeQuery] is [Null], it returns to the previous page after the introduction is finished.
  ///
  /// If you do not want to use it as a page, please use [MasamuneIntroduction].
  ///
  /// 導入部分の[PageScopedWidget]。
  ///
  /// [MasamuneIntroductionPage.query]でページ遷移可能です。
  ///
  /// イントロダクション終了後のページを指定したい場合は[routeQuery]を指定してください。
  /// [routeQuery]が[Null]の場合はイントロダクション終了後に前のページに戻ります。
  ///
  /// ページとして利用したくない場合は[MasamuneIntroduction]をご利用ください。
  const MasamuneIntroductionPage({
    super.key,
    this.routeQuery,
  });

  /// If you want to specify the page after the introduction, specify [routeQuery].
  /// If [routeQuery] is [Null], it returns to the previous page after the introduction is finished.
  ///
  /// イントロダクション終了後のページを指定したい場合は[routeQuery]を指定してください。
  /// [routeQuery]が[Null]の場合はイントロダクション終了後に前のページに戻ります。
  final RouteQuery? routeQuery;

  /// Used to transition to the MasamuneIntroductionPage screen.
  ///
  /// ```dart
  /// router.push(MasamuneIntroductionPage.query(parameters));    // Push page to MasamuneIntroductionPage.
  /// router.replace(MasamuneIntroductionPage.query(parameters)); // Replace page to MasamuneIntroductionPage.
  /// ```
  @pageRouteQuery
  static const query = _$MasamuneIntroductionPageQuery();

  @override
  Widget build(BuildContext context, PageRef ref) {
    return MasamuneIntroduction(routeQuery: routeQuery);
  }
}

/// [Widget] in the introduction.
///
/// If you want to specify the page after the introduction, specify [routeQuery].
/// If [routeQuery] is [Null], it returns to the previous page after the introduction is finished.
///
/// If you want to use it as a page, please use [MasamuneIntroductionPage].
///
/// 導入部分の[Widget]。
///
/// イントロダクション終了後のページを指定したい場合は[routeQuery]を指定してください。
/// [routeQuery]が[Null]の場合はイントロダクション終了後に前のページに戻ります。
///
/// ページとして利用したい場合は[MasamuneIntroductionPage]をご利用ください。
class MasamuneIntroduction extends StatefulWidget {
  /// [Widget] in the introduction.
  ///
  /// If you want to specify the page after the introduction, specify [routeQuery].
  /// If [routeQuery] is [Null], it returns to the previous page after the introduction is finished.
  ///
  /// If you want to use it as a page, please use [MasamuneIntroductionPage].
  ///
  /// 導入部分の[Widget]。
  ///
  /// イントロダクション終了後のページを指定したい場合は[routeQuery]を指定してください。
  /// [routeQuery]が[Null]の場合はイントロダクション終了後に前のページに戻ります。
  ///
  /// ページとして利用したい場合は[MasamuneIntroductionPage]をご利用ください。
  const MasamuneIntroduction({
    super.key,
    this.routeQuery,
    this.padding,
    this.contentPadding,
    this.titlePadding,
    this.imagePadding,
    this.bodyPadding,
    this.foregroundColor,
    this.backgroundColor,
    this.activeColor,
    this.background,
    this.enableSkip,
    this.imageDecoration,
    this.doneLabel,
    this.skipLabel,
  });

  /// If you want to specify the page after the introduction, specify [routeQuery].
  /// If [routeQuery] is [Null], it returns to the previous page after the introduction is finished.
  ///
  /// イントロダクション終了後のページを指定したい場合は[routeQuery]を指定してください。
  /// [routeQuery]が[Null]の場合はイントロダクション終了後に前のページに戻ります。
  final RouteQuery? routeQuery;

  /// Outer padding.
  ///
  /// 外側のパディング。
  final EdgeInsets? padding;

  /// Content Padding.
  ///
  /// コンテンツのパディング。
  final EdgeInsets? contentPadding;

  /// Title Padding.
  ///
  /// タイトルのパディング。
  final EdgeInsets? titlePadding;

  /// Image Padding.
  ///
  /// 画像のパディング。
  final EdgeInsets? imagePadding;

  /// Body Padding.
  ///
  /// 本文のパディング。
  final EdgeInsets? bodyPadding;

  /// Foreground Color.
  ///
  /// テキストの色。
  final Color? foregroundColor;

  /// Background Color.
  ///
  /// 背景の色。
  final Color? backgroundColor;

  /// Active Color.
  ///
  /// アクティブな色。
  final Color? activeColor;

  /// Background.
  ///
  /// 背景。
  final Widget? background;

  /// Enable Skip.
  ///
  /// スキップを有効にするかどうか。
  final bool? enableSkip;

  /// Image Decoration.
  ///
  /// 画像のデコレーション。
  final BoxDecoration? imageDecoration;

  /// Done Label.
  ///
  /// 完了ボタンのラベル。
  final LocalizedValue<String>? doneLabel;

  /// Skip Label.
  ///
  /// スキップボタンのラベル。
  final LocalizedValue<String>? skipLabel;

  @override
  State<StatefulWidget> createState() => _MasamuneIntroductionState();
}

class _MasamuneIntroductionState extends State<MasamuneIntroduction> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    final adapter =
        MasamuneAdapterScope.of<IntroductionMasamuneAdapter>(context);

    if (adapter == null) {
      return const SizedBox();
    }

    final background = widget.background ?? adapter.background;

    Widget contents = SafeArea(
      child: DefaultTextStyle(
        style: TextStyle(
          color: widget.foregroundColor ??
              adapter.foregroundColor ??
              Theme.of(context).textTheme.bodyMedium?.color,
        ),
        child: IconTheme(
          data: IconThemeData(
            color: widget.foregroundColor ??
                adapter.foregroundColor ??
                Theme.of(context).iconTheme.color,
          ),
          child: IntroductionScreen(
            key: _introKey,
            controlsPadding: widget.contentPadding ??
                adapter.contentPadding ??
                const EdgeInsets.all(16.0),
            globalBackgroundColor: background != null
                ? Colors.transparent
                : (widget.backgroundColor ?? adapter.backgroundColor),
            dotsDecorator: DotsDecorator(
              activeColor: widget.activeColor ??
                  adapter.activeColor ??
                  Theme.of(context).primaryColor,
            ),
            pages: [
              ...(adapter.items.value(context.locale) ?? []).map(
                (e) => e.toPageViewModel(
                  context,
                  titlePadding: widget.titlePadding ?? adapter.titlePadding,
                  imagePadding: widget.imagePadding ?? adapter.imagePadding,
                  bodyPadding: widget.bodyPadding ?? adapter.bodyPadding,
                  foregroundColor: widget.foregroundColor ??
                      adapter.foregroundColor ??
                      Theme.of(context).textTheme.bodyMedium?.color,
                  backgroundColor: background != null
                      ? Colors.transparent
                      : (widget.backgroundColor ?? adapter.backgroundColor),
                  pagePadding: widget.padding ??
                      adapter.pagePadding ??
                      const EdgeInsets.all(16.0),
                  imageDecoration:
                      widget.imageDecoration ?? adapter.imageDecoration,
                ),
              ),
            ],
            done: Text(
              widget.doneLabel?.value(context.locale) ??
                  adapter.doneLabel.value(context.locale) ??
                  "",
              style: TextStyle(
                color: widget.activeColor ??
                    adapter.activeColor ??
                    Theme.of(context).primaryColor,
              ),
            ),
            skip: Text(
              widget.skipLabel?.value(context.locale) ??
                  adapter.skipLabel.value(context.locale) ??
                  "",
              style: TextStyle(
                color: widget.activeColor ??
                    adapter.activeColor ??
                    Theme.of(context).primaryColor,
              ),
            ),
            onDone: () async {
              await adapter.onDone?.call();
              if (!context.mounted) {
                return;
              }
              if (widget.routeQuery == null) {
                context.router.pop();
              } else {
                unawaited(
                  context.router.replace(
                    widget.routeQuery!,
                  ),
                );
              }
            },
            onSkip: () async {
              await adapter.onSkip?.call();
              if (!context.mounted) {
                return;
              }
              if (widget.routeQuery == null) {
                context.router.pop();
              } else {
                unawaited(
                  context.router.replace(
                    widget.routeQuery!,
                  ),
                );
              }
            },
            showSkipButton: widget.enableSkip ?? adapter.enableSkip,
            showNextButton: false,
            showBackButton: false,
            showDoneButton: true,
          ),
        ),
      ),
    );

    if (background != null) {
      contents = Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          background,
          contents,
        ],
      );
    }

    return ColoredBox(
      color: widget.backgroundColor ??
          adapter.backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      child: contents,
    );
  }
}

extension on IntroductionItem {
  PageViewModel toPageViewModel(
    BuildContext context, {
    TextStyle? titleTextStyle,
    TextStyle? bodyTextStyle,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsets? titlePadding,
    EdgeInsets? imagePadding,
    EdgeInsets? bodyPadding,
    EdgeInsets? pagePadding,
    BoxDecoration? imageDecoration,
  }) {
    final appliedTitleTextStyle = titleTextStyle ??
        Theme.of(context).textTheme.titleLarge?.withBold() ??
        TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: foregroundColor,
        );
    final appliedBodyTextStyle = bodyTextStyle ??
        Theme.of(context).textTheme.bodyMedium ??
        TextStyle(
          fontSize: 16.0,
          color: foregroundColor,
        );
    return PageViewModel(
      titleWidget: title != null
          ? DefaultTextStyle(
              style: appliedTitleTextStyle.copyWith(color: foregroundColor),
              child: title!)
          : null,
      bodyWidget: body != null
          ? DefaultTextStyle(
              style: appliedBodyTextStyle.copyWith(color: foregroundColor),
              child: body!)
          : null,
      image: imageDecoration != null && image != null
          ? DecoratedBox(
              decoration: imageDecoration,
              position: DecorationPosition.foreground,
              child: imageDecoration.borderRadius != null
                  ? ClipRRect(
                      borderRadius: imageDecoration.borderRadius!,
                      child: image,
                    )
                  : image,
            )
          : image,
      footer: footer,
      decoration: PageDecoration(
        pageColor: backgroundColor,
        titleTextStyle: appliedTitleTextStyle.copyWith(color: foregroundColor),
        bodyTextStyle: appliedBodyTextStyle.copyWith(color: foregroundColor),
        imagePadding: imagePadding ?? const EdgeInsets.only(bottom: 24.0),
        titlePadding:
            titlePadding ?? const EdgeInsets.only(top: 16.0, bottom: 24.0),
        contentMargin: bodyPadding ?? const EdgeInsets.all(16.0),
        pageMargin: pagePadding ?? const EdgeInsets.only(bottom: 60.0),
        safeArea: 0,
      ),
      useScrollView: useScrollView,
      useRowInLandscape: useRowInLandscape,
    );
  }
}
