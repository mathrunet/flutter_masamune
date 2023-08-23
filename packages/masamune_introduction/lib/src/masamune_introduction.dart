// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:introduction_screen/introduction_screen.dart';
import 'package:masamune/masamune.dart';

// Project imports:
import 'package:masamune_introduction/masamune_introduction.dart';

part 'masamune_introduction.page.dart';

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
  /// MasamuneIntroductionPage.query(parameters).push(router);    // Push page to MasamuneIntroductionPage.
  /// MasamuneIntroductionPage.query(parameters).replace(router); // Replace page to MasamuneIntroductionPage.
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
    this.padding = const EdgeInsets.all(16.0),
    this.contentPadding = const EdgeInsets.all(16.0),
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
  final EdgeInsets padding;

  /// Content Padding.
  ///
  /// コンテンツのパディング。
  final EdgeInsets contentPadding;

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

    return DefaultTextStyle(
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
      ),
      child: IconTheme(
        data: IconThemeData(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        child: IntroductionScreen(
          key: _introKey,
          bodyPadding: widget.padding,
          controlsPadding: widget.contentPadding,
          pages: [
            ...(adapter.items.value(context.locale) ?? []).map(
              (e) => e.toPageViewModel(context),
            ),
          ],
          done: Text(adapter.doneLabel.value(context.locale) ?? ""),
          skip: Text(adapter.skipLabel.value(context.locale) ?? ""),
          onDone: () {
            if (widget.routeQuery == null) {
              context.router.pop();
            } else {
              context.router.replace(
                widget.routeQuery!,
              );
            }
          },
          onSkip: () {
            if (widget.routeQuery == null) {
              context.router.pop();
            } else {
              context.router.replace(
                widget.routeQuery!,
              );
            }
          },
          showSkipButton: adapter.enableSkip,
          showNextButton: false,
          showBackButton: false,
          showDoneButton: true,
        ),
      ),
    );
  }
}

extension on IntroductionItem {
  PageViewModel toPageViewModel(
    BuildContext context, {
    TextStyle? titleTextStyle,
    TextStyle? bodyTextStyle,
  }) {
    return PageViewModel(
      titleWidget: title,
      bodyWidget: body,
      image: image,
      footer: footer,
      decoration: PageDecoration(
        titleTextStyle: titleTextStyle ??
            Theme.of(context).textTheme.titleLarge ??
            const TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
        bodyTextStyle: bodyTextStyle ??
            Theme.of(context).textTheme.bodyMedium ??
            const TextStyle(
              fontSize: 16.0,
            ),
      ),
      useScrollView: useScrollView,
      useRowInLandscape: useRowInLandscape,
    );
  }
}
