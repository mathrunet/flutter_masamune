part of "/masamune_markdown.dart";

/// Adapter for displaying and editing Markdown.
///
/// Internally, it uses the `flutter_quill` and `markdown_widget` packages.
///
/// Markdownを表示および編集するためのアダプター。
///
/// 内部的には`flutter_quill`および`markdown_widget`のパッケージを利用しています。
class MarkdownMasamuneAdapter extends MasamuneAdapter {
  /// Adapter for displaying and editing Markdown.
  ///
  /// Internally, it uses the `flutter_quill` and `markdown_widget` packages.
  ///
  /// Markdownを表示および編集するためのアダプター。
  ///
  /// 内部的には`flutter_quill`および`markdown_widget`のパッケージを利用しています。
  const MarkdownMasamuneAdapter({
    this.defaultStyle = const MarkdownStyle(),
    this.imageLimit = 256,
  });

  /// Default style for markdown.
  ///
  /// マークダウンのデフォルトのスタイル。
  final MarkdownStyle defaultStyle;

  /// The limit of the image embed.
  ///
  /// 画像埋め込みのサイズ制限。
  final double imageLimit;

  /// You can retrieve the [MarkdownMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[MarkdownMasamuneAdapter]を取得することができます。
  // ignore: prefer_constructors_over_static_methods
  static MarkdownMasamuneAdapter get primary {
    assert(
      _primary != null,
      "MarkdownMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary ?? const MarkdownMasamuneAdapter();
  }

  static MarkdownMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is MarkdownMasamuneAdapter) {
      MarkdownMasamuneAdapter._primary ??= adapter;
    }
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<MarkdownMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
