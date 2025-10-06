part of "/masamune_painter.dart";

/// Adapter for displaying and editing Markdown.
///
/// Internally, it uses the `flutter_quill` and `markdown_widget` packages.
///
/// Markdownを表示および編集するためのアダプター。
///
/// 内部的には`flutter_quill`および`markdown_widget`のパッケージを利用しています。
class PainterMasamuneAdapter extends MasamuneAdapter {
  /// Adapter for displaying and editing Markdown.
  ///
  /// Internally, it uses the `flutter_quill` and `markdown_widget` packages.
  ///
  /// Markdownを表示および編集するためのアダプター。
  ///
  /// 内部的には`flutter_quill`および`markdown_widget`のパッケージを利用しています。
  const PainterMasamuneAdapter({
    this.defaultCanvasSize = const Size(1024, 1024),
    this.defaultBackgroundColor = Colors.transparent,
    this.defaultForegroundColor = Colors.black,
    this.defaultImagePlaceholder = "assets/image.png",
    this.defaultLine = const Solid1pxLinePainterBlockTools(),
    PainterMediaDatabase? mediaDatabase,
    this.defaultParagraphAlign =
        const ParagraphAlignLeftTextPainterBlockTools(),
    this.defaultFontSize = const Size10pxFontPainterBlockTools(),
    this.defaultFontStyle = const StyleNormalFontPainterBlockTools(),
    this.maxColorHistory = 10,
    this.maxActionHistory = 50,
    this.defaultPrimaryTools = const [
      SelectPainterPrimaryTools(),
      ShapePainterPrimaryTools(),
      TextPainterPrimaryTools(),
      UndoPainterPrimaryTools(),
      RedoPainterPrimaryTools(),
    ],
    this.defaultSecondaryTools = const [
      CopyPainterSecondaryTools(),
      CutPainterSecondaryTools(),
      PastePainterSecondaryTools(),
    ],
    this.defaultSelectInlineTools = const [
      SelectPainterInlineTools(),
      BackgroundPropertyColorPainterInlineTools(),
      ForegroundPropertyColorPainterInlineTools(),
      LinePropertyPainterInlineTools(),
      FontSizePropertyPainterInlineTools(),
      FontStylePropertyPainterInlineTools(),
      ParagraphAlignPropertyPainterInlineTools(),
      GroupPropertyPainterInlineTools(),
      FilterPropertyPainterInlineTools(),
      LayerForwardPropertyPainterInlineTools(),
      LayerBackwardPropertyPainterInlineTools(),
    ],
    this.defaultShapeInlineTools = const [
      ShapePainterInlineTools(),
      BackgroundPropertyColorPainterInlineTools(),
      ForegroundPropertyColorPainterInlineTools(),
      LinePropertyPainterInlineTools(),
    ],
    this.defaultTextInlineTools = const [
      TextPainterInlineTools(),
      ForegroundPropertyColorPainterInlineTools(),
      FontSizePropertyPainterInlineTools(),
      FontStylePropertyPainterInlineTools(),
      ParagraphAlignPropertyPainterInlineTools(),
    ],
    this.defaultMediaInlineTools = const [
      MediaPainterInlineTools(),
      ForegroundPropertyColorPainterInlineTools(),
      LinePropertyPainterInlineTools(),
    ],
  }) : _mediaDatabase = mediaDatabase;

  /// The media database for caching media to be loaded by a painter.
  ///
  /// ペインターで読み込むメディアをキャッシュするためのデータベース。
  PainterMediaDatabase get mediaDatabase {
    final database = _mediaDatabase ?? sharedMediaDatabase;
    return database;
  }

  final PainterMediaDatabase? _mediaDatabase;

  /// The shared media database for caching media to be loaded by a painter.
  ///
  /// ペインターで読み込むメディアをキャッシュするための共有データベース。
  static final PainterMediaDatabase sharedMediaDatabase =
      PainterMediaDatabase();

  /// Primary tools for painter.
  ///
  /// 描画ツールのプライマリーツール。
  final List<PainterPrimaryTools> defaultPrimaryTools;

  /// Secondary tools for painter.
  ///
  /// 描画ツールのセカンダリーツール。
  final List<PainterSecondaryTools> defaultSecondaryTools;

  /// Default select inline tools for painter.
  ///
  /// 描画ツールの選択インラインツール。
  final List<PainterInlineTools> defaultSelectInlineTools;

  /// Default shape inline tools for painter.
  ///
  /// 描画ツールの図形インラインツール。
  final List<PainterInlineTools> defaultShapeInlineTools;

  /// Default text inline tools for painter.
  ///
  /// 描画ツールのテキストインラインツール。
  final List<PainterInlineTools> defaultTextInlineTools;

  /// Media inline tool for drawing tools.
  ///
  /// 描画ツールのメディアインラインツール。
  final List<PainterInlineTools> defaultMediaInlineTools;

  /// The default size of the canvas.
  ///
  /// キャンバスのデフォルトサイズ。
  final Size defaultCanvasSize;

  /// The default background color for drawing.
  ///
  /// 描画用のデフォルト背景色。
  final Color defaultBackgroundColor;

  /// The default foreground color for drawing.
  ///
  /// 描画用のデフォルト前景色。
  final Color defaultForegroundColor;

  /// The default line block tools for drawing.
  ///
  /// 描画用のデフォルト線ブロックツール。
  final PainterLineBlockTools defaultLine;

  /// The default paragraph align block tools for drawing.
  ///
  /// 描画用のデフォルト段落揃えブロックツール。
  final PainterParagraphAlignBlockTools defaultParagraphAlign;

  /// The default font size block tools for drawing.
  ///
  /// 描画用のデフォルトフォントサイズブロックツール。
  final PainterFontSizeBlockTools defaultFontSize;

  /// The default font style block tools for drawing.
  ///
  /// 描画用のデフォルトフォントスタイルブロックツール。
  final PainterFontStyleBlockTools defaultFontStyle;

  /// The maximum number of color history.
  ///
  /// 色履歴の最大数。
  final int maxColorHistory;

  /// Maximum number of history entries to keep.
  ///
  /// 保持する履歴エントリの最大数。
  final int maxActionHistory;

  /// The default image placeholder.
  ///
  /// デフォルトの画像プレースホルダー。
  final String defaultImagePlaceholder;

  /// Find the shape tool.
  ///
  /// 図形ツールを取得します。
  static TTool? findTool<TTool extends PainterTools>({
    String? toolId,
    bool recursive = false,
  }) {
    final primaryTool = _findTool<TTool>(
      primary.defaultPrimaryTools,
      toolId: toolId,
      recursive: recursive,
    );
    if (primaryTool != null) {
      return primaryTool;
    }
    final secondaryTool = _findTool<TTool>(
      primary.defaultSecondaryTools,
      toolId: toolId,
      recursive: recursive,
    );
    if (secondaryTool != null) {
      return secondaryTool;
    }
    final selectInlineTool = _findTool<TTool>(
      primary.defaultSelectInlineTools,
      toolId: toolId,
      recursive: recursive,
    );
    if (selectInlineTool != null) {
      return selectInlineTool;
    }
    final shapeInlineTool = _findTool<TTool>(
      primary.defaultShapeInlineTools,
      toolId: toolId,
      recursive: recursive,
    );
    if (shapeInlineTool != null) {
      return shapeInlineTool;
    }
    final textInlineTool = _findTool<TTool>(
      primary.defaultTextInlineTools,
      toolId: toolId,
      recursive: recursive,
    );
    if (textInlineTool != null) {
      return textInlineTool;
    }
    return null;
  }

  static TTool? _findTool<TTool extends PainterTools>(
    List<PainterTools> tools, {
    String? toolId,
    bool recursive = false,
  }) {
    for (final tool in tools) {
      if (tool is TTool) {
        if (toolId == null || tool.id == toolId) {
          return tool;
        }
      }
      if (recursive) {
        if (tool is PainterPrimaryTools) {
          final inlineFound = _findTool<TTool>(
            tool.inlineTools ?? [],
            toolId: toolId,
            recursive: true,
          );
          if (inlineFound != null) {
            return inlineFound;
          }
          final blockFound = _findTool<TTool>(
            tool.blockTools ?? [],
            toolId: toolId,
            recursive: true,
          );
          if (blockFound != null) {
            return blockFound;
          }
        }
        if (tool is PainterInlinePrimaryTools) {
          final found = _findTool<TTool>(
            tool.blockTools ?? [],
            toolId: toolId,
            recursive: true,
          );
          if (found != null) {
            return found;
          }
        }
      }
    }
    return null;
  }

  /// You can retrieve the [PainterMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[PainterMasamuneAdapter]を取得することができます。
  // ignore: prefer_constructors_over_static_methods
  static PainterMasamuneAdapter get primary {
    assert(
      _primary != null,
      "PainterMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary ?? const PainterMasamuneAdapter();
  }

  static PainterMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is PainterMasamuneAdapter) {
      PainterMasamuneAdapter._primary ??= adapter;
    }
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<PainterMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
