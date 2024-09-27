part of '/masamune_introduction.dart';

/// Initialize [MasamuneAdapter] to handle the introduction tutorial.
///
/// 導入のチュートリアルを取り扱うための初期設定を行う[MasamuneAdapter]。
class IntroductionMasamuneAdapter extends MasamuneAdapter {
  /// Initialize [MasamuneAdapter] to handle the introduction tutorial.
  ///
  /// 導入のチュートリアルを取り扱うための初期設定を行う[MasamuneAdapter]。
  const IntroductionMasamuneAdapter({
    required this.items,
    this.enableSkip = true,
    required this.doneLabel,
    this.backgroundColor,
    this.foregroundColor,
    this.activeColor,
    required this.skipLabel,
    this.titlePadding,
    this.imagePadding,
    this.bodyPadding,
    this.pagePadding,
    this.contentPadding,
  });

  /// Foreground color.
  ///
  /// 前景色。
  final Color? foregroundColor;

  /// Active color.
  ///
  /// アクティブな色。
  final Color? activeColor;

  /// Background color.
  ///
  /// 背景色。
  final Color? backgroundColor;

  /// List of tutorial pages.
  ///
  /// チュートリアルのページ一覧。
  final LocalizedValue<List<IntroductionItem>> items;

  /// Set to `true` if skippable.
  ///
  /// スキップ可能な場合`true`にする。
  final bool enableSkip;

  /// Generator of completion button labels.
  ///
  /// 完了ボタンのラベルのジェネレーター.
  final LocalizedValue<String> doneLabel;

  /// Generator of skip button labels.
  ///
  /// スキップボタンのラベルのジェネレーター。
  final LocalizedValue<String> skipLabel;

  /// Title padding.
  ///
  /// タイトルのパディング。
  final EdgeInsets? titlePadding;

  /// Image padding.
  ///
  /// 画像のパディング。
  final EdgeInsets? imagePadding;

  /// Body padding.
  ///
  /// ボディのパディング。
  final EdgeInsets? bodyPadding;

  /// Page padding.
  ///
  /// ページのパディング。
  final EdgeInsets? pagePadding;

  /// Content padding.
  ///
  /// コンテンツのパディング。
  final EdgeInsets? contentPadding;

  /// You can retrieve the [IntroductionMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[IntroductionMasamuneAdapter]を取得することができます。
  static IntroductionMasamuneAdapter get primary {
    assert(
      _primary != null,
      "IntroductionMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static IntroductionMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! IntroductionMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<IntroductionMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
