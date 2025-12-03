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
    this.indentSpaceCount = 2,
    this.maxIndentLevel = 3,
    this.showDebugLogs = false,
    this.defaultPrimaryTools = const [
      AddMarkdownPrimaryTools(),
      FontMarkdownPrimaryTools(),
      MentionMarkdownPrimaryTools(),
      ExchangeMarkdownPrimaryTools(),
      UndoMarkdownPrimaryTools(),
      RedoMarkdownPrimaryTools(),
      IndentUpMarkdownPrimaryTools(),
      IndentDownMarkdownPrimaryTools(),
    ],
    this.defaultSecondaryTools = const [
      CopyMarkdownSecondaryTools(),
      CutMarkdownSecondaryTools(),
      PasteMarkdownSecondaryTools(),
      CloseMarkdownSecondaryTools(),
    ],
    this.defaultSelectInlineTools = const [
      BoldFontMarkdownInlineTools(),
      CodeFontMarkdownInlineTools(),
      ItalicFontMarkdownInlineTools(),
      StrikeFontMarkdownInlineTools(),
      UnderlineFontMarkdownInlineTools(),
      LinkMarkdownInlineTools(),
    ],
  });

  /// Whether to show debug logs.
  ///
  /// デバッグログを表示するかどうか。
  final bool showDebugLogs;

  /// Default primary tools for markdown.
  ///
  /// マークダウンのデフォルトのプライマリーツール。
  final List<MarkdownPrimaryTools> defaultPrimaryTools;

  /// Default secondary tools for markdown.
  ///
  /// マークダウンのデフォルトのセカンダリーツール。
  final List<MarkdownSecondaryTools> defaultSecondaryTools;

  /// Default select inline tools for markdown.
  ///
  /// マークダウンのデフォルトの選択インラインツール。
  final List<MarkdownInlineTools> defaultSelectInlineTools;

  /// Default style for markdown.
  ///
  /// マークダウンのデフォルトのスタイル。
  final MarkdownStyle defaultStyle;

  /// The limit of the image embed.
  ///
  /// 画像埋め込みのサイズ制限。
  final double imageLimit;

  /// The count of the indent space.
  ///
  /// インデントの空白の数。
  final int indentSpaceCount;

  /// The maximum level of the indent.
  ///
  /// インデントの最大レベル。
  final int maxIndentLevel;

  /// Find the markdown tool.
  ///
  /// マークダウンツールを取得します。
  static List<TTool> findTools<TTool extends MarkdownTools>({
    String? toolId,
    bool recursive = false,
  }) {
    final foundTools = <TTool>[];
    final primaryTools = _findTools<TTool>(
      primary.defaultPrimaryTools,
      toolId: toolId,
      recursive: recursive,
    );
    if (primaryTools.isNotEmpty) {
      foundTools.addAll(primaryTools);
    }
    final secondaryTool = _findTools<TTool>(
      primary.defaultSecondaryTools,
      toolId: toolId,
      recursive: recursive,
    );
    if (secondaryTool.isNotEmpty) {
      foundTools.addAll(secondaryTool);
    }
    final selectInlineTool = _findTools<TTool>(
      primary.defaultSelectInlineTools,
      toolId: toolId,
      recursive: recursive,
    );
    if (selectInlineTool.isNotEmpty) {
      foundTools.addAll(selectInlineTool);
    }
    return foundTools;
  }

  static List<TTool> _findTools<TTool extends MarkdownTools>(
    List<MarkdownTools> tools, {
    String? toolId,
    bool recursive = false,
  }) {
    final foundTools = <TTool>[];
    for (final tool in tools) {
      if (tool is TTool) {
        if (toolId == null || tool.id == toolId) {
          foundTools.add(tool);
        }
      }
      if (recursive) {
        if (tool is MarkdownPrimaryTools) {
          final inlineFound = _findTools<TTool>(
            tool.inlineTools ?? [],
            toolId: toolId,
            recursive: true,
          );
          if (inlineFound.isNotEmpty) {
            foundTools.addAll(inlineFound);
          }
          final blockFound = _findTools<TTool>(
            tool.blockTools ?? [],
            toolId: toolId,
            recursive: true,
          );
          if (blockFound.isNotEmpty) {
            foundTools.addAll(blockFound);
          }
        }
      }
    }
    return foundTools;
  }

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
