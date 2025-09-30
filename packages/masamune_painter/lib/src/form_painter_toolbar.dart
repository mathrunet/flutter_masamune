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
  PainterController get controller => widget.controller;

  @override
  void toggleMode(PainterTools tool) {
    setState(() {
      widget.controller._prevTool = null;
      if (tool == widget.controller._currentTool) {
        if (_showBlockMenu) {
          if (_blockMenuToggleDuration != null) {
            _blockMenuHeight = 0;
            _blockMenuToggleDuration = _kBlockMenuToggleDuration;
          }
          _showBlockMenu = false;
        } else {
          if ((tool is PainterPrimaryTools && tool.blockTools.isNotEmpty) ||
              (tool is PainterInlinePrimaryTools &&
                  tool.blockTools.isNotEmpty)) {
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
          // blockToolsを持つツールでない場合のみBlockMenuを閉じる
          final hasBlockTools = (tool is PainterPrimaryTools &&
                  tool.blockTools.isNotEmpty) ||
              (tool is PainterInlinePrimaryTools && tool.blockTools.isNotEmpty);
          if (!hasBlockTools) {
            if (_blockMenuToggleDuration != null) {
              _blockMenuHeight = 0;
              _blockMenuToggleDuration = _kBlockMenuToggleDuration;
            }
            _showBlockMenu = false;
          }
        } else {
          if ((tool is PainterPrimaryTools && tool.blockTools.isNotEmpty) ||
              (tool is PainterInlinePrimaryTools &&
                  tool.blockTools.isNotEmpty)) {
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
    await widget.controller.clipboard.copy();
    setState(() {});
  }

  @override
  Future<void> cut() async {
    await widget.controller.clipboard.cut();
    setState(() {});
  }

  @override
  Future<void> paste() async {
    await widget.controller.clipboard.paste();
    setState(() {});
  }

  @override
  void undo() {
    widget.controller.history.undo();
    setState(() {});
  }

  @override
  void redo() {
    widget.controller.history.redo();
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
    return tools.mapAndRemoveEmpty((e) {
      if (!e.shown(context, this)) {
        return null;
      }
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
            ...tools.mapAndRemoveEmpty((e) {
              if (!e.shown(context, this)) {
                return null;
              }
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
  PainterToolInlineMode? get toolInlineMode {
    final currentTool = widget.controller._currentTool;
    final currentValues = widget.controller.currentValues;
    if (currentValues.isNotEmpty) {
      return PainterToolInlineMode.select;
    }
    if (currentTool == null) {
      return null;
    }
    if (currentTool is SelectPainterPrimaryTools ||
        currentTool is SelectPainterInlineTools) {
      return PainterToolInlineMode.select;
    }
    final shapeTool =
        PainterMasamuneAdapter.findTool<ShapePainterPrimaryTools>();
    if (shapeTool != null) {
      if (shapeTool.inlineTools.contains(currentTool)) {
        return PainterToolInlineMode.shape;
      }
      final prevTool = widget.controller._prevTool;
      if (prevTool != null && shapeTool.inlineTools.contains(prevTool)) {
        return PainterToolInlineMode.shape;
      }
    }
    if (currentTool is TextPainterPrimaryTools ||
        currentTool is TextPainterInlineTools) {
      return PainterToolInlineMode.text;
    }
    return null;
  }

  List<PainterInlineTools>? _getInlineTools(PainterToolInlineMode? mode) {
    switch (mode) {
      case PainterToolInlineMode.select:
        return widget.controller.adapter.defaultSelectInlineTools;
      case PainterToolInlineMode.shape:
        return widget.controller.adapter.defaultShapeInlineTools;
      case PainterToolInlineMode.text:
        return widget.controller.adapter.defaultTextInlineTools;
      default:
        final currentTool = widget.controller._currentTool;
        if (currentTool is PainterPrimaryTools) {
          return currentTool.inlineTools;
        }
        if (currentTool is PainterInlinePrimaryTools) {
          final prevTool = controller._prevTool;
          if (prevTool != null && prevTool is PainterPrimaryTools) {
            return prevTool.inlineTools;
          }
        }
        return null;
    }
  }

  List<PainterBlockTools>? _getBlockTools(PainterToolInlineMode? mode) {
    final currentTool = widget.controller._currentTool;
    final currentValues = widget.controller.currentValues;
    if (currentTool is PainterPrimaryTools) {
      return currentTool.blockTools;
    }
    if (currentTool is PainterInlinePrimaryTools) {
      return currentTool.blockTools;
    }
    if (currentValues.isNotEmpty) {
      final selectPainterPrimaryTools =
          widget.controller.adapter.defaultPrimaryTools.firstWhereOrNull(
        (e) => e is SelectPainterPrimaryTools,
      );
      if (selectPainterPrimaryTools != null) {
        return selectPainterPrimaryTools.blockTools;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = _blockMenuHeight + _kToolbarHeight;

    final toolMode = toolInlineMode;

    final inlineTools = _getInlineTools(toolMode);
    final blockTools = _getBlockTools(toolMode);

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

  /// Get the controller.
  ///
  /// コントローラーを取得します。
  PainterController get controller;

  /// Get the tool mode.
  ///
  /// ツールモードを取得します。
  PainterToolInlineMode? get toolInlineMode;

  /// Deselect object.
  ///
  /// オブジェクトの選択を解除します。
  void unselect();

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

  /// Undo the last action.
  ///
  /// 最後のアクションを元に戻します。
  void undo();

  /// Redo the last undone action.
  ///
  /// 最後に元に戻したアクションをやり直します。
  void redo();
}
