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
    this.defaultPrimaryTools = const [
      SelectPainterPrimaryTools(),
      ShapePainterPrimaryTools(),
    ],
    this.defaultSecondaryTools = const [
      CopyPainterSecondaryTools(),
      CutPainterSecondaryTools(),
      PastePainterSecondaryTools(),
    ],
  });

  /// Primary tools for painter.
  ///
  /// 描画ツールのプライマリーツール。
  final List<PainterPrimaryTools> defaultPrimaryTools;

  /// Secondary tools for painter.
  ///
  /// 描画ツールのセカンダリーツール。
  final List<PainterSecondaryTools> defaultSecondaryTools;

  /// The default size of the canvas.
  ///
  /// キャンバスのデフォルトサイズ。
  final Size defaultCanvasSize;

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
