part of '/masamune_introduction.dart';

/// Items for setting up the introductory page.
///
/// 導入ページ設定用のアイテム。
@immutable
class IntroductionItem {
  /// Items for setting up the introductory page.
  ///
  /// 導入ページ設定用のアイテム。
  const IntroductionItem({
    this.title,
    this.body,
    this.image,
    this.footer,
    this.useRowInLandscape = false,
    this.useScrollView = true,
  });

  /// Page Title.
  ///
  /// ページタイトル。
  final Widget? title;

  /// Page body.
  ///
  /// ページの本文。
  final Widget? body;

  /// Featured image on page.
  ///
  /// ページのフィーチャー画像。
  final Widget? image;

  /// Page footer.
  ///
  /// ページのフッター。
  final Widget? footer;

  /// Set to `true` if you want to use scroll view.
  ///
  /// スクロールビューを利用したい場合`true`にする。
  final bool useScrollView;

  /// Set to `true` if you want to make it horizontal when displayed in landscape mode.
  ///
  /// 横画面時に横並びにしたい場合`true`にする。
  final bool useRowInLandscape;
}
