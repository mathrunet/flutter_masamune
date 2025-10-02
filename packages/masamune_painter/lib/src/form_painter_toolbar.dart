part of "/masamune_painter.dart";

const _kToolbarHeight = kToolbarHeight;
const _kBlockMenuToggleDuration = Duration(milliseconds: 200);

/// Toolbar for [FormPainterField].
///
/// Pass a [PainterController] and provide the same controller to [FormPainterField].
///
/// The contents of the tools are changed by the various settings of [PainterMasamuneAdapter]. You can also change the contents of the tools by specifying [primaryTools] and [secondaryTools].
///
/// You can change the toolbar's style with [style]. By specifying [textFieldHintLabel], you can display a hint label when entering text.
///
/// [FormPainterField]用のツールバー。
///
/// [PainterController]を渡し同じコントローラーを[FormPainterField]に渡してください。
///
/// ツールの内容は[PainterMasamuneAdapter]の各種設定で変更されます。また[primaryTools]と[secondaryTools]を指定することでツールの内容を変更することができます。
///
///　[style]でツールバーのスタイルを変更することができます。[textFieldHintLabel]を指定するとテキスト入力時のヒントラベルを表示することができます。
class FormPainterToolbar extends StatefulWidget {
  /// Toolbar for [FormPainterField].
  ///
  /// Pass a [PainterController] and provide the same controller to [FormPainterField].
  ///
  /// The contents of the tools are changed by the various settings of [PainterMasamuneAdapter]. You can also change the contents of the tools by specifying [primaryTools] and [secondaryTools].
  ///
  /// You can change the toolbar's style with [style]. By specifying [textFieldHintLabel], you can display a hint label when entering text.
  ///
  /// [FormPainterField]用のツールバー。
  ///
  /// [PainterController]を渡し同じコントローラーを[FormPainterField]に渡してください。
  ///
  /// ツールの内容は[PainterMasamuneAdapter]の各種設定で変更されます。また[primaryTools]と[secondaryTools]を指定することでツールの内容を変更することができます。
  ///
  ///　[style]でツールバーのスタイルを変更することができます。[textFieldHintLabel]を指定するとテキスト入力時のヒントラベルを表示することができます。
  const FormPainterToolbar({
    required this.controller,
    this.primaryTools,
    this.secondaryTools,
    this.selectInlineTools,
    this.shapeInlineTools,
    this.textInlineTools,
    this.mediaInlineTools,
    this.style,
    this.textFieldHintLabel,
    super.key,
  });

  /// Primary tools for the toolbar.
  ///
  /// ツールバーのプライマリーツール。
  final List<PainterPrimaryTools>? primaryTools;

  /// Secondary tools for the toolbar.
  ///
  /// ツールバーのセカンダリーツール。
  final List<PainterSecondaryTools>? secondaryTools;

  /// Default select inline tools for painter.
  ///
  /// 描画ツールの選択インラインツール。
  final List<PainterInlineTools>? selectInlineTools;

  /// Default shape inline tools for painter.
  ///
  /// 描画ツールの図形インラインツール。
  final List<PainterInlineTools>? shapeInlineTools;

  /// Default text inline tools for painter.
  ///
  /// 描画ツールのテキストインラインツール。
  final List<PainterInlineTools>? textInlineTools;

  /// Media inline tool for drawing tools.
  ///
  /// 描画ツールのメディアインラインツール。
  final List<PainterInlineTools>? mediaInlineTools;

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

  /// Hint text for the text field.
  ///
  /// テキストフィールドのヒントテキスト。
  final String? textFieldHintLabel;

  @override
  State<FormPainterToolbar> createState() => FormPainterToolbarState();
}

/// State of [FormPainterToolbar].
///
/// [FormPainterToolbar]の状態。
class FormPainterToolbarState extends State<FormPainterToolbar>
    with WidgetsBindingObserver
    implements PainterToolRef {
  bool _showBlockMenu = false;
  double _blockMenuHeight = 0;
  Duration? _blockMenuToggleDuration;
  _TextSetting? _textSetting;
  double _previousViewInsets = 0;

  @override
  void initState() {
    super.initState();
    widget.controller._registerToolbar(this);
    widget.controller.addListener(_handleControllerStateOnChanged);
    widget.controller._onDragEndCallback.add(_handleOnDragEnd);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(FormPainterToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller._unregisterToolbar(this);
      oldWidget.controller.removeListener(_handleControllerStateOnChanged);
      oldWidget.controller._onDragEndCallback.remove(_handleOnDragEnd);
      widget.controller._registerToolbar(this);
      widget.controller.addListener(_handleControllerStateOnChanged);
      widget.controller._onDragEndCallback.add(_handleOnDragEnd);
    }
  }

  @override
  void dispose() {
    widget.controller._unregisterToolbar(this);
    widget.controller.removeListener(_handleControllerStateOnChanged);
    widget.controller._onDragEndCallback.remove(_handleOnDragEnd);
    WidgetsBinding.instance.removeObserver(this);
    _textSetting?.cancel();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // キーボードの表示状態の変化を検知
    final currentViewInsets = View.of(context).viewInsets.bottom;
    if (currentViewInsets > _previousViewInsets && _showBlockMenu) {
      // キーボードが開いた場合、ブロックメニューを閉じる
      setState(() {
        if (_blockMenuToggleDuration != null) {
          _blockMenuHeight = 0;
          _blockMenuToggleDuration = _kBlockMenuToggleDuration;
        }
        _showBlockMenu = false;
        // ブロックメニューを開いていたツールを非アクティブにする
        widget.controller._currentTool = null;
      });
    }
    _previousViewInsets = currentViewInsets;
  }

  @override
  PainterController get controller => widget.controller;

  @override
  void toggleMode(PainterTools tool) {
    setState(() {
      // テキスト編集を終了
      if (_textSetting != null &&
          widget.controller._currentTool is! TextPainterPrimaryTools &&
          tool is! TextPainterPrimaryTools &&
          widget.controller._currentTool is! TextPainterInlineTools &&
          tool is! TextPainterInlineTools) {
        _finishTextEditing();
      }
      widget.controller._prevTool = null;
      if (tool == widget.controller._currentTool) {
        if (_showBlockMenu) {
          if (_blockMenuToggleDuration != null) {
            _blockMenuHeight = 0;
            _blockMenuToggleDuration = _kBlockMenuToggleDuration;
          }
          _showBlockMenu = false;
          // ブロックメニューを閉じた後、テキストオブジェクトが選択されている場合はテキストフィールドを再表示
          _restoreTextEditingIfNeeded();
        } else {
          if ((tool is PainterPrimaryTools && tool.blockTools.isNotEmpty) ||
              (tool is PainterInlinePrimaryTools &&
                  tool.blockTools.isNotEmpty)) {
            if (_blockMenuHeight == 0) {
              _blockMenuHeight = context.mediaQuery.size.height / 3.0;
              _blockMenuToggleDuration = _kBlockMenuToggleDuration;
            }
            _showBlockMenu = true;
            // ブロックメニュー表示時にパンを調整
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _adjustPanForBlockMenu();
            });
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
            // ブロックメニューを閉じた後、テキストオブジェクトが選択されている場合はテキストフィールドを再表示
            _restoreTextEditingIfNeeded();
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
            // ブロックメニュー表示時にパンを調整
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _adjustPanForBlockMenu();
            });
          }
        }
        widget.controller._currentTool = tool;
      }
    });
  }

  @override
  void deleteMode() {
    setState(() {
      // テキスト編集を終了
      if (_textSetting != null) {
        _finishTextEditing();
      }
      if (_blockMenuToggleDuration != null) {
        _blockMenuHeight = 0;
        _blockMenuToggleDuration = _kBlockMenuToggleDuration;
      }
      widget.controller._currentTool = null;
      _showBlockMenu = false;
      // ブロックメニューを閉じた後、テキストオブジェクトが選択されている場合はテキストフィールドを再表示
      _restoreTextEditingIfNeeded();
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

  void _handleControllerStateOnChanged() {
    final currentValue = widget.controller.currentValues.firstOrNull;

    // 選択が変わった場合、以前のテキスト編集を終了
    if (_textSetting != null) {
      if (currentValue == null || currentValue.id != _textSetting!.value.id) {
        _finishTextEditing();
        // 新しいテキストオブジェクトが選択されている場合は続行
        // そうでない場合は終了
        if (currentValue == null || currentValue is! TextPaintingValue) {
          return;
        }
      } else {
        // 同じテキストオブジェクトが選択されている場合は何もしない
        return;
      }
    }
  }

  void _handleOnDragEnd() {
    // テキスト矩形が作成された後、または単独でテキストオブジェクトが選択された後にテキスト入力を開始
    if (widget.controller.currentValues.length == 1 &&
        widget.controller.currentValues.first is TextPaintingValue) {
      final textValue =
          widget.controller.currentValues.first as TextPaintingValue;
      // テキストツールで作成中、または既存のテキストを選択した場合
      final isCreating =
          widget.controller._currentTool is TextPainterPrimaryTools;
      final isSelecting =
          widget.controller._currentTool is SelectPainterPrimaryTools ||
              widget.controller._currentTool is SelectPainterInlineTools ||
              widget.controller._currentTool == null;

      if (isCreating || isSelecting) {
        if (textValue.rect.width >= textValue.minimumSize.width &&
            textValue.rect.height >= textValue.minimumSize.height) {
          setState(() {
            _textSetting = _TextSetting(
              value: textValue,
            );
            _textSetting!.focusNode.requestFocus();
            _textSetting!.textEditingController.addListener(_handleTextChanged);
          });
          // テキスト編集開始時にパンを調整
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _adjustPanForTextEditing();
          });
        }
      }
    }
  }

  void _handleTextChanged() {
    if (_textSetting == null) {
      return;
    }
    final currentText = _textSetting!.textEditingController.text;
    final currentValue = widget.controller.currentValues.firstOrNull;
    if (currentValue is TextPaintingValue && currentValue.text != currentText) {
      // テキストを更新（履歴には保存しない）
      final updatedValue = currentValue.copyWith(text: currentText);
      widget.controller.updateCurrentValue(updatedValue);
    }
  }

  void _finishTextEditing() {
    if (_textSetting == null) {
      return;
    }
    _textSetting!.textEditingController.removeListener(_handleTextChanged);
    _textSetting!.cancel();
    _textSetting = null;
    // 履歴に保存
    widget.controller.saveCurrentValue(saveToHistory: true);
  }

  void _restoreTextEditingIfNeeded() {
    // テキストオブジェクトが単独で選択されている場合、テキストフィールドを再表示
    if (_textSetting == null &&
        widget.controller.currentValues.length == 1 &&
        widget.controller.currentValues.first is TextPaintingValue) {
      final textValue =
          widget.controller.currentValues.first as TextPaintingValue;
      if (textValue.rect.width >= textValue.minimumSize.width &&
          textValue.rect.height >= textValue.minimumSize.height) {
        _textSetting = _TextSetting(
          value: textValue,
        );
        _textSetting!.focusNode.requestFocus();
        _textSetting!.textEditingController.addListener(_handleTextChanged);
        // テキスト編集開始時にパンを調整
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _adjustPanForTextEditing();
        });
      }
    }
  }

  void _adjustPanForTextEditing() {
    if (_textSetting == null || widget.controller._currentState == null) {
      return;
    }

    final textValue = _textSetting!.value;
    final fieldState = widget.controller._currentState!;

    // キャンバス（FormPainterField）のRenderBoxを取得
    final fieldContext = fieldState.context;
    final fieldRenderBox = fieldContext.findRenderObject() as RenderBox?;
    if (fieldRenderBox == null) {
      return;
    }

    // 現在のビューの情報を取得
    final viewInsets = View.of(fieldContext).viewInsets.bottom;
    final blockTools = _getBlockTools(inlineMode);
    final hasBlockTools = blockTools != null && blockTools.isNotEmpty;

    // ツールバーとテキストフィールドの高さを計算
    var uiHeight = _kToolbarHeight;
    if (hasBlockTools) {
      uiHeight += _blockMenuHeight;
    }
    // テキストフィールドの高さ
    uiHeight += _kToolbarHeight * 2.2;

    // キーボードとUIの合計高さ
    final totalBottomHeight = viewInsets + uiHeight;

    // キャンバスのサイズを取得
    final canvasSize = fieldRenderBox.size;

    // 表示可能領域の高さを計算
    final availableHeight = canvasSize.height - totalBottomHeight;

    // 表示可能領域の中央のY座標（キャンバス座標系）
    final visibleAreaCenterY = availableHeight / 2;

    // テキストオブジェクトの位置を変換後の座標で取得
    final textRect = textValue.rect;
    final transformedRect = fieldState._transformRect(textRect);

    // テキストオブジェクトの中心のY座標
    final textCenterY = transformedRect.center.dy;

    // テキストオブジェクトの中心を表示可能領域の中央に配置
    final deltaY = visibleAreaCenterY - textCenterY;

    // パンを調整（わずかな差でも調整）
    if (deltaY.abs() > 1.0) {
      fieldState._adjustPan(Offset(0, deltaY));
    }
  }

  void _adjustPanForBlockMenu() {
    if (widget.controller._currentState == null) {
      return;
    }

    final fieldState = widget.controller._currentState!;
    final currentValues = widget.controller.currentValues;

    // 選択中のオブジェクトがない場合は何もしない
    if (currentValues.isEmpty) {
      return;
    }

    // キャンバス（FormPainterField）のRenderBoxを取得
    final fieldContext = fieldState.context;
    final fieldRenderBox = fieldContext.findRenderObject() as RenderBox?;
    if (fieldRenderBox == null) {
      return;
    }

    // 現在のビューの情報を取得
    final viewInsets = View.of(fieldContext).viewInsets.bottom;

    // ツールバーとブロックメニューの高さを計算
    var uiHeight = _kToolbarHeight;
    uiHeight += _blockMenuHeight;

    // キーボードとUIの合計高さ
    final totalBottomHeight = viewInsets + uiHeight;

    // キャンバスのサイズを取得
    final canvasSize = fieldRenderBox.size;

    // 表示可能領域の高さを計算
    final availableHeight = canvasSize.height - totalBottomHeight;

    // 表示可能領域の中央のY座標（キャンバス座標系）
    final visibleAreaCenterY = availableHeight / 2;

    // 選択中のオブジェクトの境界を取得
    Rect targetRect;
    if (currentValues.length == 1) {
      targetRect = currentValues.first.rect;
    } else {
      // 複数選択の場合は全体の境界を使用
      final bounds = widget.controller.selectionBounds;
      if (bounds == null) {
        return;
      }
      targetRect = bounds;
    }

    // オブジェクトの位置を変換後の座標で取得
    final transformedRect = fieldState._transformRect(targetRect);

    // オブジェクトの中心のY座標
    final objectCenterY = transformedRect.center.dy;

    // オブジェクトの中心を表示可能領域の中央に配置
    final deltaY = visibleAreaCenterY - objectCenterY;

    // パンを調整（わずかな差でも調整）
    if (deltaY.abs() > 1.0) {
      fieldState._adjustPan(Offset(0, deltaY));
    }
  }

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

  Widget _buildTextDialog(
    BuildContext context,
    ThemeData theme,
    bool hasBlockTools,
  ) {
    return Positioned(
      left: 0,
      top: 0,
      right: 0,
      bottom: hasBlockTools
          ? (_blockMenuHeight + _kToolbarHeight)
          : _kToolbarHeight,
      child: Container(
        decoration: BoxDecoration(
          color: widget.style?.backgroundColor ??
              theme.colorTheme?.background ??
              theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: (widget.style?.borderColor ??
                      theme.colorTheme?.outline ??
                      theme.colorScheme.outline)
                  .withAlpha(128),
            ),
          ),
        ),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
        child: FormTextField(
          focusNode: _textSetting?.focusNode,
          controller: _textSetting?.textEditingController,
          keyboardType: TextInputType.multiline,
          expands: true,
          hintText: widget.textFieldHintLabel,
          style: FormStyle(
            textAlignVertical: TextAlignVertical.top,
            borderStyle: FormInputBorderStyle.none,
            borderRadius: BorderRadius.circular(0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            backgroundColor:
                widget.style?.backgroundColor ?? theme.colorTheme?.background,
          ),
        ),
      ),
    );
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
  PainterInlineMode? get inlineMode {
    final currentTool = widget.controller._currentTool;
    final currentValues = widget.controller.currentValues;
    if (currentValues.isNotEmpty) {
      return PainterInlineMode.select;
    }
    if (currentTool == null) {
      return null;
    }
    if (currentTool is SelectPainterPrimaryTools ||
        currentTool is SelectPainterInlineTools) {
      return PainterInlineMode.select;
    }
    final shapeTool =
        PainterMasamuneAdapter.findTool<ShapePainterPrimaryTools>();
    if (shapeTool != null) {
      if (shapeTool.inlineTools.contains(currentTool)) {
        return PainterInlineMode.shape;
      }
      final prevTool = widget.controller._prevTool;
      if (prevTool != null && shapeTool.inlineTools.contains(prevTool)) {
        return PainterInlineMode.shape;
      }
    }
    if (currentTool is TextPainterPrimaryTools ||
        currentTool is TextPainterInlineTools) {
      return PainterInlineMode.text;
    }
    if (currentTool is MediaPainterPrimaryTools ||
        currentTool is MediaPainterInlineTools) {
      return PainterInlineMode.media;
    }
    final prevTool = widget.controller._prevTool;
    if (prevTool != null &&
        (prevTool is MediaPainterPrimaryTools ||
            prevTool is MediaPainterInlineTools)) {
      return PainterInlineMode.media;
    }
    return null;
  }

  List<PainterInlineTools>? _getInlineTools(PainterInlineMode? mode) {
    switch (mode) {
      case PainterInlineMode.select:
        return widget.selectInlineTools ??
            widget.controller.adapter.defaultSelectInlineTools;
      case PainterInlineMode.shape:
        return widget.shapeInlineTools ??
            widget.controller.adapter.defaultShapeInlineTools;
      case PainterInlineMode.text:
        return widget.textInlineTools ??
            widget.controller.adapter.defaultTextInlineTools;
      case PainterInlineMode.media:
        return widget.mediaInlineTools ??
            widget.controller.adapter.defaultMediaInlineTools;
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

  List<PainterBlockTools>? _getBlockTools(PainterInlineMode? mode) {
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
    final toolMode = inlineMode;

    final inlineTools = _getInlineTools(toolMode);
    final blockTools = _getBlockTools(toolMode);

    var height = _kToolbarHeight;
    // ブロックメニューが実際に表示される場合のみ高さを加算
    if (blockTools != null && blockTools.isNotEmpty) {
      height += _blockMenuHeight;
    }
    if (_textSetting != null) {
      // テキストフィールドの高さ：3行分 + パディング + ボーダー
      // フォントサイズを考慮した概算
      height += _kToolbarHeight * 2.2;
    }

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
              if (_textSetting != null) ...[
                _buildTextDialog(
                  context,
                  theme,
                  blockTools != null && blockTools.isNotEmpty,
                ),
              ],
              Positioned(
                left: 0,
                right: 0,
                bottom: (blockTools != null && blockTools.isNotEmpty)
                    ? _blockMenuHeight
                    : 0,
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
  PainterInlineMode? get inlineMode;

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

class _TextSetting {
  _TextSetting({
    required this.value,
  }) {
    textEditingController.text = value.text;
  }

  final TextPaintingValue value;
  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  void cancel() {
    textEditingController.dispose();
    focusNode.dispose();
  }
}
