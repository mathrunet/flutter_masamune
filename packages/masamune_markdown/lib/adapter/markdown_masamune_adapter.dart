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
    this.toolsConfig = const MarkdownToolsConfig(),
  });

  /// Configuration for Markdown tools.
  ///
  /// Set the label and icon for each tool using [MarkdownToolLabelConfig].
  ///
  /// Markdownツールの設定。
  ///
  /// [MarkdownToolLabelConfig]を使用して、各ツールのラベルとアイコンを設定します。
  final MarkdownToolsConfig toolsConfig;

  /// You can retrieve the [MarkdownMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[MarkdownMasamuneAdapter]を取得することができます。
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
