part of "/masamune_painter.dart";

const _kToolbarHeight = kToolbarHeight;
const _kBlockMenuToggleDuration = Duration(milliseconds: 200);

/// Markdown toolbar.
///
/// Pass the [MarkdownController] and the same controller to [FormMarkdownField].
///
/// Design and wording can be changed via [MarkdownMasamuneAdapter.toolsConfig].
///
/// By specifying [mentionBuilder], a list of mentions can be displayed.
///
/// You can use block styles for `h1`, `h2`, `h3`, and quotes and code blocks.
/// You can insert image and video media.
/// You can use font styles such as `bold`, `italic`, `underline`, `strike`, `link`, `code`.
///
/// Painter用のツールバー。
///
/// [PainterController]を渡し同じコントローラーを[FormPainterField]に渡してください。
///
/// デザイン及び文言は[MarkdownMasamuneAdapter.toolsConfig]経由で変更されます。
///
/// [mentionBuilder]を指定することでメンションのリストを表示することができます。
///
/// `h1`, `h2`, `h3`および引用やコードのブロックスタイルを使用することができます。
/// 画像や映像のメディアを挿入することができます。
/// `bold`, `italic`, `underline`, `strike`, `link`, `code`のフォントスタイルを使用することができます。
class FormPainterToolbar extends StatefulWidget {
  /// Markdown toolbar.
  ///
  /// Pass the [MarkdownController] and the same controller to [FormMarkdownField].
  ///
  /// Design and wording can be changed via [MarkdownMasamuneAdapter.toolsConfig].
  ///
  /// By specifying [mentionBuilder], a list of mentions can be displayed.
  ///
  /// You can use block styles for `h1`, `h2`, `h3`, and quotes and code blocks.
  /// You can insert image and video media.
  /// You can use font styles such as `bold`, `italic`, `underline`, `strike`, `link`, `code`.
  ///
  /// Markdown用のツールバー。
  ///
  /// [MarkdownController]を渡し同じコントローラーを[FormMarkdownField]に渡してください。
  ///
  /// デザイン及び文言は[MarkdownMasamuneAdapter.toolsConfig]経由で変更されます。
  ///
  /// [mentionBuilder]を指定することでメンションのリストを表示することができます。
  ///
  /// `h1`, `h2`, `h3`および引用やコードのブロックスタイルを使用することができます。
  /// 画像や映像のメディアを挿入することができます。
  /// `bold`, `italic`, `underline`, `strike`, `link`, `code`のフォントスタイルを使用することができます。
  const FormPainterToolbar({
    required this.controller,
    this.primaryTools,
    this.secondaryTools,
    super.key,
    this.style,
  });

  /// Primary tools for the toolbar.
  ///
  /// ツールバーのプライマリーツール。
  final List<PainterPrimaryTools>? primaryTools;

  /// Secondary tools for the toolbar.
  ///
  /// ツールバーのセカンダリーツール。
  final List<PainterSecondaryTools>? secondaryTools;

  /// [PainterController] for the toolbar.
  ///
  /// Pass the same one to [FormPainterField].
  ///
  /// ツールバー用の[PainterController]。
  ///
  /// 同じものを[FormPainterField]に渡します。
  final PainterController controller;

  /// Style of the toolbar.
  ///
  /// ツールバーのスタイル。
  final FormStyle? style;

  @override
  State<FormPainterToolbar> createState() => _FormPainterToolbarState();
}

class _FormPainterToolbarState extends State<FormPainterToolbar>
    implements PainterToolRef {
  bool _showBlockMenu = false;
  double _blockMenuHeight = 0;
  Duration? _blockMenuToggleDuration;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerStateOnChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerStateOnChanged);
    super.dispose();
  }

  @override
  bool get canPaste => widget.controller.canPaste;

  @override
  bool get canUndo => widget.controller.canUndo;

  @override
  bool get canRedo => widget.controller.canRedo;

  @override
  List<PaintingValue> get currentValues => widget.controller.currentValues;

  @override
  PainterTools? get currentTool => widget.controller._currentTool;

  @override
  Color get currentBackgroundColor => widget.controller.currentBackgroundColor;

  @override
  Color get currentForegroundColor => widget.controller.currentForegroundColor;

  @override
  PainterLineBlockTools get currentLine => widget.controller.currentLine;

  @override
  void setProperty({
    Color? backgroundColor,
    Color? foregroundColor,
    PainterLineBlockTools? line,
  }) {
    widget.controller.setProperty(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      line: line,
    );
  }

  @override
  void toggleMode(PainterTools tool) {
    setState(() {
      if (tool == widget.controller._currentTool) {
        if (_showBlockMenu) {
          if (_blockMenuToggleDuration != null) {
            _blockMenuHeight = 0;
            _blockMenuToggleDuration = _kBlockMenuToggleDuration;
          }
          _showBlockMenu = false;
        } else {
          if (tool is PainterPrimaryTools && tool.blockTools.isNotEmpty) {
            if (_blockMenuHeight == 0) {
              _blockMenuHeight = context.mediaQuery.size.height / 3.0;
              _blockMenuToggleDuration = _kBlockMenuToggleDuration;
            }
            _showBlockMenu = true;
          }
        }
        widget.controller._currentTool = null;
      } else {
        if (_showBlockMenu) {
          if (tool is! PainterPrimaryTools || tool.blockTools.isEmpty) {
            if (_blockMenuToggleDuration != null) {
              _blockMenuHeight = 0;
              _blockMenuToggleDuration = _kBlockMenuToggleDuration;
            }
            _showBlockMenu = false;
          }
        } else {
          if (tool is PainterPrimaryTools && tool.blockTools.isNotEmpty) {
            _showBlockMenu = true;
            if (_blockMenuHeight == 0) {
              _blockMenuHeight = context.mediaQuery.size.height / 3.0;
              _blockMenuToggleDuration = _kBlockMenuToggleDuration;
            }
          }
        }
        widget.controller._currentTool = tool;
      }
    });
  }

  @override
  void deleteMode() {
    setState(() {
      if (_blockMenuToggleDuration != null) {
        _blockMenuHeight = 0;
        _blockMenuToggleDuration = _kBlockMenuToggleDuration;
      }
      widget.controller._currentTool = null;
      _showBlockMenu = false;
    });
  }

  @override
  void unselect() {
    widget.controller.unselect();
  }

  @override
  Future<void> copy() async {
    await widget.controller.copy();
    setState(() {});
  }

  @override
  Future<void> cut() async {
    await widget.controller.cut();
    setState(() {});
  }

  @override
  Future<void> paste() async {
    await widget.controller.paste();
    setState(() {});
  }

  @override
  void deleteSelected() {
    widget.controller.deleteSelected();
    setState(() {});
  }

  @override
  Future<void> copyAsImage() async {
    await widget.controller.copyAsImage();
    setState(() {});
  }

  @override
  Future<Uint8List?> exportAsImage({
    double scale = 1.0,
    Color? backgroundColor,
  }) async {
    return await widget.controller.exportSelectionAsImage(
      scale: scale,
      backgroundColor: backgroundColor,
    );
  }

  @override
  void undo() {
    widget.controller.undo();
    setState(() {});
  }

  @override
  void redo() {
    widget.controller.redo();
    setState(() {});
  }

  void _handleControllerStateOnChanged() {}

  Iterable<Widget> _buildPrimaryTools(BuildContext context, ThemeData theme) {
    final primaryTools =
        widget.primaryTools ?? widget.controller.adapter.defaultPrimaryTools;
    return primaryTools.mapAndRemoveEmpty((e) {
      if (!e.shown(context, this)) {
        return null;
      }
      if (!e.enabled(context, this)) {
        return IconButton(
          onPressed: null,
          icon: e.icon(context, this),
        );
      } else if (e.actived(context, this)) {
        return IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: widget.style?.activeBackgroundColor ??
                theme.colorTheme?.primary ??
                theme.colorScheme.primary,
            foregroundColor: widget.style?.activeColor ??
                theme.colorTheme?.onPrimary ??
                theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            e.onTap(context, this);
          },
          icon: e.icon(context, this),
        );
      } else {
        return IconButton(
          onPressed: () {
            e.onTap(context, this);
          },
          icon: e.icon(context, this),
        );
      }
    });
  }

  Iterable<Widget> _buildSecondaryTools(BuildContext context, ThemeData theme) {
    final secondaryTools = widget.secondaryTools ??
        widget.controller.adapter.defaultSecondaryTools;
    final subMenu = secondaryTools.mapAndRemoveEmpty((e) {
      if (e.shown(context, this)) {
        return IconButton(
          onPressed: () {
            e.onTap(context, this);
          },
          icon: e.icon(context, this),
        );
      }
      return null;
    });
    if (subMenu.isNotEmpty) {
      return [
        VerticalDivider(
          width: 1,
          color: (widget.style?.borderColor ?? theme.colorScheme.outline)
              .withAlpha(128),
        ),
        ...subMenu,
      ];
    }
    return [];
  }

  Iterable<Widget> _buildInlineTools(
    BuildContext context,
    ThemeData theme,
    List<PainterInlineTools> tools,
  ) {
    return tools.map((e) {
      if (e.actived(context, this)) {
        return IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: widget.style?.activeBackgroundColor ??
                theme.colorTheme?.primary ??
                theme.colorScheme.primary,
            foregroundColor: widget.style?.activeColor ??
                theme.colorTheme?.onPrimary ??
                theme.colorScheme.onPrimary,
          ),
          onPressed: () {
            e.onDeactive(context, this);
          },
          icon: e.icon(context, this),
        );
      } else {
        return IconButton(
          onPressed: () {
            e.onActive(context, this);
          },
          icon: e.icon(context, this),
        );
      }
    });
  }

  Widget _buildBlockTools(
    BuildContext context,
    ThemeData theme,
    List<PainterBlockTools> tools,
  ) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: (widget.style?.borderColor ??
                      theme.colorTheme?.outline ??
                      theme.colorScheme.outline)
                  .withAlpha(128),
            ),
          ),
        ),
        height: _blockMenuHeight,
        width: double.infinity,
        child: GridView.extent(
          maxCrossAxisExtent: 240,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 3,
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + context.mediaQuery.viewPadding.bottom,
          ),
          children: [
            ...tools.map((e) {
              final actived = e.actived(context, this);
              if (actived) {
                return InkWell(
                  onTap: () {
                    e.onTap(context, this);
                  },
                  child: IconTheme(
                    data: IconThemeData(
                      color: theme.colorScheme.onPrimary,
                    ),
                    child: DefaultTextStyle(
                      style: (theme.textTheme.labelMedium ?? const TextStyle())
                          .withColor(theme.colorScheme.onPrimary),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: e.icon(context, this),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: DefaultTextStyle(
                                style: (theme.textTheme.labelMedium ??
                                        const TextStyle())
                                    .withColor(theme.colorScheme.onPrimary),
                                child: e.label(context, this),
                              ),
                            ),
                            const SizedBox(width: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return InkWell(
                onTap: () {
                  e.onTap(context, this);
                },
                child: IconTheme(
                  data: IconThemeData(
                    color: theme.colorTheme?.onBackground,
                  ),
                  child: DefaultTextStyle(
                    style: (theme.textTheme.labelMedium ?? const TextStyle())
                        .copyWith(color: theme.colorTheme?.onBackground),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: widget.style?.subBackgroundColor ??
                            widget.style?.backgroundColor ??
                            theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: e.icon(context, this),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: DefaultTextStyle(
                              style: theme.textTheme.labelMedium ??
                                  const TextStyle(),
                              child: e.label(context, this),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = _blockMenuHeight + _kToolbarHeight;

    final inlineTools = widget.controller._currentTool != null &&
            widget.controller._currentTool is PainterPrimaryTools
        ? (widget.controller._currentTool as PainterPrimaryTools).inlineTools
        : null;
    final blockTools = widget.controller._currentTool is PainterPrimaryTools
        ? (widget.controller._currentTool as PainterPrimaryTools).blockTools
        : null;

    return IconTheme(
      data: IconThemeData(
        color: widget.style?.color ?? theme.colorTheme?.onBackground,
      ),
      child: DefaultTextStyle(
        style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.style?.color ?? theme.colorTheme?.onBackground,
            ) ??
            TextStyle(
              color: widget.style?.color ?? theme.colorTheme?.onBackground,
            ),
        child: AnimatedContainer(
          duration: _blockMenuToggleDuration ?? Duration.zero,
          curve: Curves.easeInOut,
          color: widget.style?.backgroundColor ?? theme.colorTheme?.background,
          height: height,
          child: Stack(
            children: [
              if (blockTools != null && blockTools.isNotEmpty) ...[
                _buildBlockTools(context, theme, blockTools),
              ],
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: Container(
                  color: widget.style?.backgroundColor ??
                      theme.colorTheme?.background,
                  height: _kToolbarHeight,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (inlineTools != null) ...[
                                ..._buildInlineTools(
                                    context, theme, inlineTools),
                              ] else ...[
                                ..._buildPrimaryTools(context, theme),
                              ],
                            ],
                          ),
                        ),
                      ),
                      ..._buildSecondaryTools(context, theme),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A reference class for Painter tools.
///
/// 描画ツールの参照クラス。
abstract class PainterToolRef {
  const PainterToolRef._();

  /// Toggle the mode.
  ///
  /// モードを切り替えます。
  void toggleMode(PainterTools tool);

  /// Delete the mode.
  ///
  /// モードを削除します。
  void deleteMode();

  /// Deselect object.
  ///
  /// オブジェクトの選択を解除します。
  void unselect();

  /// Get the current mode.
  ///
  /// 現在のモードを取得します。
  PainterTools? get currentTool;

  /// Get the current value.
  ///
  /// 現在の値を取得します。
  List<PaintingValue> get currentValues;

  /// The background color of the current values.
  ///
  /// 現在の値の背景色。
  Color get currentBackgroundColor;

  /// The foreground color of the current values.
  ///
  /// 現在の値の前景色。
  Color get currentForegroundColor;

  /// The line block tools of the current values.
  ///
  /// 現在の値の線ブロックツール。
  PainterLineBlockTools get currentLine;

  /// Set the property of the current values.
  ///
  /// 現在の値のプロパティを設定します。
  void setProperty({
    Color? backgroundColor,
    Color? foregroundColor,
    PainterLineBlockTools? line,
  });

  /// Check if the clipboard can be pasted.
  ///
  /// クリップボードに貼り付け可能かどうかを確認します。
  bool get canPaste;

  /// Check if undo is available.
  ///
  /// Undoが利用可能かどうかを確認します。
  bool get canUndo;

  /// Check if redo is available.
  ///
  /// Redoが利用可能かどうかを確認します。
  bool get canRedo;

  /// Copy selected values to clipboard.
  ///
  /// 選択した値をクリップボードにコピーします。
  Future<void> copy();

  /// Cut selected values to clipboard.
  ///
  /// 選択した値をクリップボードにカットします。
  Future<void> cut();

  /// Paste values from clipboard.
  ///
  /// クリップボードから値をペーストします。
  Future<void> paste();

  /// Delete selected values.
  ///
  /// 選択した値を削除します。
  void deleteSelected();

  /// Copy selected values as image to clipboard.
  ///
  /// 選択した値を画像としてクリップボードにコピーします。
  Future<void> copyAsImage();

  /// Export selected values as image.
  ///
  /// 選択した値を画像としてエクスポートします。
  Future<Uint8List?> exportAsImage({double scale, Color? backgroundColor});

  /// Undo the last action.
  ///
  /// 最後のアクションを元に戻します。
  void undo();

  /// Redo the last undone action.
  ///
  /// 最後に元に戻したアクションをやり直します。
  void redo();
}
