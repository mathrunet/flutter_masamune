part of "/masamune_markdown.dart";

/// A field for editing Markdown content with block-based structure.
///
/// ブロックベースの構造でMarkdownコンテンツを編集するフィールド。
class MarkdownField extends StatefulWidget {
  /// Creates a [MarkdownField].
  ///
  /// [MarkdownField]を作成します。
  const MarkdownField({
    required this.controller,
    super.key,
    this.focusNode,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.maxLines,
    this.minLines,
    this.expands = false,
    this.scrollable = true,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.cursorWidth = 2.0,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.selectionColor,
    this.selectionControls,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.style,
    this.strutStyle,
    this.textWidthBasis = TextWidthBasis.parent,
    this.textHeightBehavior,
    this.scrollController,
    this.scrollPhysics,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
    this.onTapOutside,
    this.enabled,
    this.rendererIgnoresPointer = false,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.contextMenuBuilder,
    this.onLongPress,
    this.onDoubleTap,
  });

  /// Controller for the markdown editor.
  ///
  /// Markdownエディタのコントローラー。
  final MarkdownController controller;

  /// Focus node for the editor.
  ///
  /// エディタのフォーカスノード。
  final FocusNode? focusNode;

  /// Whether the text field is read-only.
  ///
  /// テキストフィールドが読み取り専用かどうか。
  final bool readOnly;

  /// Whether the text field should be autofocused.
  ///
  /// テキストフィールドがオートフォーカスされるべきかどうか。
  final bool autofocus;

  /// Whether to obscure the text being edited.
  ///
  /// 編集中のテキストを隠すかどうか。
  final bool obscureText;

  /// Whether to enable autocorrect.
  ///
  /// オートコレクトを有効にするかどうか。
  final bool autocorrect;

  /// Whether to enable suggestions.
  ///
  /// サジェストを有効にするかどうか。
  final bool enableSuggestions;

  /// Maximum number of lines.
  ///
  /// 最大行数。
  final int? maxLines;

  /// Minimum number of lines.
  ///
  /// 最小行数。
  final int? minLines;

  /// Whether the field should expand to fill the parent.
  ///
  /// フィールドが親を埋めるように拡張すべきかどうか。
  final bool expands;

  /// Whether the field should be scrollable.
  ///
  /// フィールドがスクロール可能かどうか。
  final bool scrollable;

  /// Text alignment.
  ///
  /// テキストの配置。
  final TextAlign textAlign;

  /// Text direction.
  ///
  /// テキストの方向。
  final TextDirection? textDirection;

  /// Cursor width.
  ///
  /// カーソルの幅。
  final double cursorWidth;

  /// Cursor height.
  ///
  /// カーソルの高さ。
  final double? cursorHeight;

  /// Cursor radius.
  ///
  /// カーソルの半径。
  final Radius? cursorRadius;

  /// Cursor color.
  ///
  /// カーソルの色。
  final Color? cursorColor;

  /// Selection color.
  ///
  /// 選択色。
  final Color? selectionColor;

  /// Selection controls.
  ///
  /// 選択コントロール。
  final TextSelectionControls? selectionControls;

  /// Keyboard type.
  ///
  /// キーボードタイプ。
  final TextInputType? keyboardType;

  /// Text input action.
  ///
  /// テキスト入力アクション。
  final TextInputAction? textInputAction;

  /// Text capitalization.
  ///
  /// テキストの大文字化。
  final TextCapitalization textCapitalization;

  /// Text style.
  ///
  /// テキストスタイル。
  final TextStyle? style;

  /// Strut style.
  ///
  /// ストラットスタイル。
  final StrutStyle? strutStyle;

  /// Text width basis.
  ///
  /// テキスト幅の基準。
  final TextWidthBasis textWidthBasis;

  /// Text height behavior.
  ///
  /// テキストの高さの動作。
  final TextHeightBehavior? textHeightBehavior;

  /// Scroll controller.
  ///
  /// スクロールコントローラー。
  final ScrollController? scrollController;

  /// Scroll physics.
  ///
  /// スクロール物理演算。
  final ScrollPhysics? scrollPhysics;

  /// Called when the text changes.
  ///
  /// テキストが変更されたときに呼ばれます。
  final ValueChanged<List<MarkdownFieldValue>>? onChanged;

  /// Called when editing is complete.
  ///
  /// 編集が完了したときに呼ばれます。
  final VoidCallback? onEditingComplete;

  /// Called when the user submits.
  ///
  /// ユーザーが送信したときに呼ばれます。
  final ValueChanged<List<MarkdownFieldValue>>? onSubmitted;

  /// Called when the user taps.
  ///
  /// ユーザーがタップしたときに呼ばれます。
  final VoidCallback? onTap;

  /// Called when the user taps outside.
  ///
  /// ユーザーが外側をタップしたときに呼ばれます。
  final TapRegionCallback? onTapOutside;

  /// Whether the field is enabled.
  ///
  /// フィールドが有効かどうか。
  final bool? enabled;

  /// Whether the renderer ignores pointer events.
  ///
  /// レンダラーがポインタイベントを無視するかどうか。
  final bool rendererIgnoresPointer;

  /// Padding for scrolling to reveal the cursor.
  ///
  /// カーソルを表示するためのスクロール時のパディング。
  final EdgeInsets scrollPadding;

  /// Whether to enable interactive selection.
  ///
  /// インタラクティブ選択を有効にするかどうか。
  final bool enableInteractiveSelection;

  /// Builder for the context menu.
  ///
  /// コンテキストメニューのビルダー。
  final Widget Function(
    BuildContext context,
    TextSelectionDelegate delegate,
  )? contextMenuBuilder;

  /// Called when a long press is detected.
  ///
  /// 長押しが検出されたときに呼ばれます。
  final void Function(Offset globalPosition)? onLongPress;

  /// Called when a double tap is detected.
  ///
  /// ダブルタップが検出されたときに呼ばれます。
  final void Function(Offset globalPosition)? onDoubleTap;

  @override
  State<MarkdownField> createState() => MarkdownFieldState();
}

/// State for MarkdownField.
///
/// MarkdownFieldのステート。
class MarkdownFieldState extends State<MarkdownField>
    with TickerProviderStateMixin
    implements TextInputClient, TextSelectionDelegate {
  late FocusNode _focusNode;
  late ScrollController _scrollController;
  TextInputConnection? _textInputConnection;

  /// Whether to cursor in link.
  ///
  /// カーソルがリンク内にあるかどうか。
  bool get cursorInLink {
    return false;
  }

  /// Whether to select in mention link.
  ///
  /// メンションリンクを選択するかどうか。
  bool get selectInMentionLink {
    return false;
  }

  // Selection state
  TextSelection _selection = const TextSelection.collapsed(offset: 0);
  TextSelection? _composingRegion;

  // Keep track of the last text value sent to/from the text input
  String _lastKnownText = "";

  // For tracking cursor blink
  bool _showCursor = true;
  late AnimationController _cursorBlinkController;

  // Context menu overlay
  OverlayEntry? _contextMenuOverlay;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? widget.controller.focusNode;
    _scrollController = widget.scrollController ?? ScrollController();
    widget.controller._registerField(this);
    _focusNode.addListener(_handleFocusChanged);
    widget.controller.addListener(_handleControllerChanged);

    // Setup cursor blink
    _cursorBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(_onCursorBlink);
  }

  @override
  void didUpdateWidget(MarkdownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChanged);
      _focusNode = widget.focusNode ?? widget.controller.focusNode;
      _focusNode.addListener(_handleFocusChanged);
    }
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller._unregisterField(this);
      widget.controller._registerField(this);
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    _hideContextMenu();
    _closeInputConnectionIfNeeded();
    _cursorBlinkController.dispose();
    widget.controller._unregisterField(this);
    _focusNode.removeListener(_handleFocusChanged);
    widget.controller.removeListener(_handleControllerChanged);
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _hideContextMenu() {
    _contextMenuOverlay?.remove();
    _contextMenuOverlay = null;
  }

  void _showContextMenu(Offset globalPosition) {
    _hideContextMenu();

    if (widget.contextMenuBuilder == null) {
      return;
    }

    final overlay = Overlay.of(context);

    _contextMenuOverlay = OverlayEntry(
      builder: (context) {
        return widget.contextMenuBuilder!(
          context,
          this,
        );
      },
    );

    overlay.insert(_contextMenuOverlay!);
  }

  void _onCursorBlink() {
    setState(() {
      _showCursor = _cursorBlinkController.value < 0.5;
    });
  }

  void _handleFocusChanged() {
    if (_focusNode.hasFocus) {
      _openInputConnection();
      _showCursor = true;
      _cursorBlinkController.reset();
      _cursorBlinkController.repeat();
    } else {
      _closeInputConnectionIfNeeded();
      _cursorBlinkController.stop();
      _showCursor = false;
    }
    setState(() {});
  }

  void _handleControllerChanged() {
    setState(() {});
  }

  void _openInputConnection() {
    if (!_hasInputConnection) {
      final textInputConfiguration = TextInputConfiguration(
        inputType: widget.keyboardType ?? TextInputType.multiline,
        obscureText: widget.obscureText,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        inputAction: widget.textInputAction ?? TextInputAction.newline,
        textCapitalization: widget.textCapitalization,
        keyboardAppearance: Theme.of(context).brightness == Brightness.dark
            ? Brightness.dark
            : Brightness.light,
      );
      _textInputConnection = TextInput.attach(this, textInputConfiguration);
      _textInputConnection!.show();
      // Initialize _lastKnownText before updating remote value
      _lastKnownText = _getPlainText();
      _updateRemoteEditingValue();
    }
  }

  void _closeInputConnectionIfNeeded() {
    if (_hasInputConnection) {
      _textInputConnection!.close();
      _textInputConnection = null;
    }
  }

  bool get _hasInputConnection =>
      _textInputConnection != null && _textInputConnection!.attached;

  void _updateRemoteEditingValue() {
    if (!_hasInputConnection) {
      return;
    }

    final text = _getPlainText();
    _lastKnownText = text;
    _textInputConnection!.setEditingState(
      TextEditingValue(
        text: text,
        selection: _selection,
        composing: _composingRegion != null
            ? TextRange(
                start: _composingRegion!.start,
                end: _composingRegion!.end,
              )
            : TextRange.empty,
      ),
    );
  }

  String _getPlainText() {
    return widget.controller.getPlainText();
  }

  // TextInputClient implementation
  @override
  void updateEditingValue(TextEditingValue value) {
    if (widget.readOnly) {
      return;
    }

    final oldText = _lastKnownText;
    final newText = value.text;

    if (oldText != newText) {
      // Text changed, update controller

      // Find the difference
      var start = 0;
      while (start < oldText.length &&
          start < newText.length &&
          oldText[start] == newText[start]) {
        start++;
      }

      var oldEnd = oldText.length;
      var newEnd = newText.length;
      while (oldEnd > start &&
          newEnd > start &&
          oldText[oldEnd - 1] == newText[newEnd - 1]) {
        oldEnd--;
        newEnd--;
      }

      final replacementText = newText.substring(start, newEnd);

      // Check if the replacement text contains a newline
      if (replacementText.contains("\n")) {
        // Split by newlines and insert them one by one
        final lines = replacementText.split("\n");

        // First, delete the old text if any
        if (oldEnd > start) {
          widget.controller.replaceText(start, oldEnd, "");
        }

        // Insert first line at the cursor position
        if (lines.isNotEmpty && lines.first.isNotEmpty) {
          widget.controller.replaceText(start, start, lines.first);
          start += lines.first.length;
        }

        // For each additional line, insert a new paragraph
        for (var i = 1; i < lines.length; i++) {
          widget.controller.insertNewLine(start);
          start++; // Account for the newline character

          if (lines[i].isNotEmpty) {
            widget.controller.replaceText(start, start, lines[i]);
            start += lines[i].length;
          }
        }

        // Update cursor position to the end of inserted text
        _selection = TextSelection.collapsed(offset: start);
        // Clear composing region after newline
        _composingRegion = null;
      } else {
        // Check if backspace deleted a block
        final blockCountBefore =
            widget.controller.value?.firstOrNull?.children.length ?? 0;

        // Normal text replacement
        widget.controller.replaceText(start, oldEnd, replacementText);

        final blockCountAfter =
            widget.controller.value?.firstOrNull?.children.length ?? 0;

        // If a block was deleted (backspace at empty block start)
        if (blockCountAfter < blockCountBefore &&
            oldEnd > start &&
            replacementText.isEmpty) {
          // Keep cursor at start position (blocks were merged)
          _selection = TextSelection.collapsed(offset: start);
          _composingRegion = null;
        } else {
          // Update cursor position and composing region
          _selection = value.selection;

          // Clear composing region when composing ends (start == -1)
          if (!value.composing.isValid || value.composing.start == -1) {
            _composingRegion = null;
          } else {
            _composingRegion = TextSelection(
              baseOffset: value.composing.start,
              extentOffset: value.composing.end,
            );
          }
        }
      }

      widget.onChanged?.call(widget.controller.value ?? []);
      _updateRemoteEditingValue();

      // Trigger rebuild to reflect changes
      setState(() {});
    } else {
      // Only selection or composing region changed
      _selection = value.selection;

      // Clear composing region when composing ends (start == -1)
      if (!value.composing.isValid || value.composing.start == -1) {
        _composingRegion = null;
      } else {
        _composingRegion = TextSelection(
          baseOffset: value.composing.start,
          extentOffset: value.composing.end,
        );
      }

      // Update remote value to sync with IME
      _updateRemoteEditingValue();
      setState(() {});
    }
  }

  @override
  void didChangeInputControl(
    TextInputControl? oldControl,
    TextInputControl? newControl,
  ) {
    // Handle input control changes
  }

  @override
  void performAction(TextInputAction action) {
    switch (action) {
      case TextInputAction.newline:
        if (!widget.readOnly) {
          // Insert a new paragraph at the current cursor position
          widget.controller.insertNewLine(_selection.baseOffset);
          // Move cursor to the next line
          _selection =
              TextSelection.collapsed(offset: _selection.baseOffset + 1);
          _updateRemoteEditingValue();
          widget.onChanged?.call(widget.controller.value ?? []);
          setState(() {});
        }
        break;
      case TextInputAction.done:
      case TextInputAction.go:
      case TextInputAction.search:
      case TextInputAction.send:
        widget.onEditingComplete?.call();
        break;
      default:
        break;
    }
  }

  @override
  void performPrivateCommand(String action, Map<String, dynamic> data) {
    // Handle platform-specific commands if needed
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    // TODO: implement floating cursor for iOS
  }

  @override
  void connectionClosed() {
    if (_hasInputConnection) {
      _textInputConnection!.connectionClosedReceived();
      _textInputConnection = null;
    }
  }

  @override
  AutofillScope? get currentAutofillScope => null;

  @override
  TextEditingValue get currentTextEditingValue => TextEditingValue(
        text: _getPlainText(),
        selection: _selection,
        composing: _composingRegion != null
            ? TextRange(
                start: _composingRegion!.start,
                end: _composingRegion!.end,
              )
            : TextRange.empty,
      );

  @override
  void showAutocorrectionPromptRect(int start, int end) {
    // TODO: implement autocorrection prompt
  }

  @override
  void insertTextPlaceholder(Size size) {
    // TODO: implement text placeholder for iOS
  }

  @override
  void removeTextPlaceholder() {
    // TODO: implement text placeholder for iOS
  }

  @override
  void showToolbar() {
    // TODO: implement toolbar
  }

  @override
  void insertContent(KeyboardInsertedContent content) {
    // TODO: implement keyboard inserted content
  }

  @override
  void performSelector(String selectorName) {
    // Handle selector for iOS
  }

  // TextSelectionDelegate implementation
  @override
  TextEditingValue get textEditingValue => currentTextEditingValue;

  set textEditingValue(TextEditingValue value) {
    updateEditingValue(value);
  }

  @override
  void copySelection(SelectionChangedCause cause) {
    final text = _selection.textInside(_getPlainText());
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
    }
  }

  @override
  void cutSelection(SelectionChangedCause cause) {
    if (widget.readOnly) {
      return;
    }
    widget.controller.cut();
  }

  @override
  Future<void> pasteText(SelectionChangedCause cause) async {
    if (widget.readOnly) {
      return;
    }
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null && data.text != null) {
      // TODO: implement actual paste
    }
  }

  @override
  void selectAll(SelectionChangedCause cause) {
    final text = _getPlainText();
    _selection = TextSelection(
      baseOffset: 0,
      extentOffset: text.length,
    );
    setState(() {});
    _updateRemoteEditingValue();
  }

  @override
  void bringIntoView(TextPosition position) {
    // TODO: implement auto-scroll to cursor
  }

  @override
  void hideToolbar([bool hideHandles = true]) {
    // TODO: implement toolbar hiding
  }

  @override
  bool get cutEnabled => !widget.readOnly && _selection.isValid;

  @override
  bool get copyEnabled => _selection.isValid;

  @override
  bool get pasteEnabled => !widget.readOnly;

  @override
  bool get selectAllEnabled => true;

  @override
  bool get liveTextInputEnabled => false;

  @override
  bool get lookUpEnabled => true;

  @override
  bool get searchWebEnabled => true;

  @override
  bool get shareEnabled => true;

  @override
  void userUpdateTextEditingValue(
    TextEditingValue value,
    SelectionChangedCause cause,
  ) {
    updateEditingValue(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultStyle = widget.style ?? theme.textTheme.bodyLarge;
    final cursorColor = widget.cursorColor ?? theme.colorScheme.primary;
    final selectionColor = widget.selectionColor ??
        theme.textSelectionTheme.selectionColor ??
        theme.colorScheme.primary.withValues(alpha: 0.4);

    final showCursor = _focusNode.hasFocus && _showCursor;

    Widget child = _MarkdownRenderObjectWidget(
      controller: widget.controller,
      focusNode: _focusNode,
      selection: _selection,
      composingRegion: _composingRegion,
      showCursor: showCursor,
      expands: widget.expands,
      style: defaultStyle!,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: cursorColor,
      selectionColor: selectionColor,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection ?? Directionality.of(context),
      textWidthBasis: widget.textWidthBasis,
      textHeightBehavior: widget.textHeightBehavior,
      strutStyle: widget.strutStyle,
      onSelectionChanged: (selection, cause) {
        setState(() {
          _selection = selection;
          _cursorBlinkController.reset();
          _cursorBlinkController.repeat();
        });

        // When selection changes by tap/drag, clear composing region to commit IME text
        // タップやドラッグでカーソルが移動した場合、コンポージングをクリアしてIMEテキストを確定
        if (cause == SelectionChangedCause.tap ||
            cause == SelectionChangedCause.drag ||
            cause == SelectionChangedCause.toolbar) {
          _composingRegion = null;
        }

        _updateRemoteEditingValue();
        // Notify controller listeners so that toolbar can update based on selection state
        // ツールバーが選択状態に基づいて更新できるようにコントローラーのリスナーに通知
        widget.controller.notifySelectionChanged();
      },
      onTap: () {
        _hideContextMenu();
        if (!_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
        widget.onTap?.call();
      },
      onLongPress: (globalPosition) {
        widget.onLongPress?.call(globalPosition);
        if (widget.contextMenuBuilder != null) {
          _showContextMenu(globalPosition);
        }
      },
      onDoubleTap: (globalPosition) {
        widget.onDoubleTap?.call(globalPosition);
      },
    );

    if (widget.scrollable &&
        (widget.scrollController != null || !widget.expands)) {
      child = SingleChildScrollView(
        controller: _scrollController,
        physics: widget.scrollPhysics,
        padding: widget.scrollPadding,
        child: child,
      );
    }

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      child: child,
    );
  }
}

/// Internal RenderObjectWidget for markdown editing.
///
/// Markdown編集用の内部RenderObjectWidget。
class _MarkdownRenderObjectWidget extends LeafRenderObjectWidget {
  const _MarkdownRenderObjectWidget({
    required this.controller,
    required this.focusNode,
    required this.selection,
    required this.showCursor,
    required this.expands,
    required this.style,
    required this.cursorWidth,
    required this.cursorColor,
    required this.selectionColor,
    required this.textAlign,
    required this.textDirection,
    required this.textWidthBasis,
    required this.onSelectionChanged,
    required this.onTap,
    this.composingRegion,
    this.cursorHeight,
    this.cursorRadius,
    this.textHeightBehavior,
    this.strutStyle,
    this.onLongPress,
    this.onDoubleTap,
  });

  final MarkdownController controller;
  final FocusNode focusNode;
  final TextSelection selection;
  final TextSelection? composingRegion;
  final bool showCursor;
  final bool expands;
  final TextStyle style;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color cursorColor;
  final Color selectionColor;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final StrutStyle? strutStyle;
  final SelectionChangedCallback onSelectionChanged;
  final VoidCallback? onTap;
  final void Function(Offset globalPosition)? onLongPress;
  final void Function(Offset globalPosition)? onDoubleTap;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMarkdownEditor(
      controller: controller,
      focusNode: focusNode,
      selection: selection,
      composingRegion: composingRegion,
      showCursor: showCursor,
      expands: expands,
      style: style,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      selectionColor: selectionColor,
      textAlign: textAlign,
      textDirection: textDirection,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      strutStyle: strutStyle,
      onSelectionChanged: onSelectionChanged,
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMarkdownEditor renderObject,
  ) {
    renderObject
      ..controller = controller
      ..focusNode = focusNode
      ..selection = selection
      ..composingRegion = composingRegion
      ..showCursor = showCursor
      ..expands = expands
      ..style = style
      ..cursorWidth = cursorWidth
      ..cursorHeight = cursorHeight
      ..cursorRadius = cursorRadius
      ..cursorColor = cursorColor
      ..selectionColor = selectionColor
      ..textAlign = textAlign
      ..textDirection = textDirection
      ..textWidthBasis = textWidthBasis
      ..textHeightBehavior = textHeightBehavior
      ..strutStyle = strutStyle
      .._onSelectionChanged = onSelectionChanged
      .._onTap = onTap
      .._onLongPress = onLongPress
      .._onDoubleTap = onDoubleTap;
  }
}

/// RenderBox for markdown editor.
///
/// Markdownエディタ用のRenderBox。
class _RenderMarkdownEditor extends RenderBox {
  _RenderMarkdownEditor({
    required MarkdownController controller,
    required FocusNode focusNode,
    required TextSelection selection,
    required bool showCursor,
    required bool expands,
    required TextStyle style,
    required double cursorWidth,
    required Color cursorColor,
    required Color selectionColor,
    required TextAlign textAlign,
    required TextDirection textDirection,
    required TextWidthBasis textWidthBasis,
    required SelectionChangedCallback onSelectionChanged,
    required VoidCallback? onTap,
    TextSelection? composingRegion,
    double? cursorHeight,
    Radius? cursorRadius,
    TextHeightBehavior? textHeightBehavior,
    StrutStyle? strutStyle,
    void Function(Offset globalPosition)? onLongPress,
    void Function(Offset globalPosition)? onDoubleTap,
  })  : _controller = controller,
        _focusNode = focusNode,
        _selection = selection,
        _composingRegion = composingRegion,
        _showCursor = showCursor,
        _expands = expands,
        _style = style,
        _cursorWidth = cursorWidth,
        _cursorHeight = cursorHeight,
        _cursorRadius = cursorRadius,
        _cursorColor = cursorColor,
        _selectionColor = selectionColor,
        _textAlign = textAlign,
        _textDirection = textDirection,
        _textWidthBasis = textWidthBasis,
        _textHeightBehavior = textHeightBehavior,
        _strutStyle = strutStyle,
        _onSelectionChanged = onSelectionChanged,
        _onTap = onTap,
        _onLongPress = onLongPress,
        _onDoubleTap = onDoubleTap;

  MarkdownController _controller;
  MarkdownController get controller => _controller;
  set controller(MarkdownController value) {
    if (_controller == value) {
      return;
    }
    _controller.removeListener(_handleControllerChanged);
    _controller = value;
    _controller.addListener(_handleControllerChanged);
    markNeedsPaint();
  }

  FocusNode _focusNode;
  FocusNode get focusNode => _focusNode;
  set focusNode(FocusNode value) {
    if (_focusNode == value) {
      return;
    }
    _focusNode = value;
  }

  TextSelection _selection;
  TextSelection get selection => _selection;
  set selection(TextSelection value) {
    if (_selection == value) {
      return;
    }
    _selection = value;
    markNeedsPaint();
  }

  TextSelection? _composingRegion;
  TextSelection? get composingRegion => _composingRegion;
  set composingRegion(TextSelection? value) {
    if (_composingRegion == value) {
      return;
    }
    _composingRegion = value;
    markNeedsPaint();
  }

  bool _showCursor;
  bool get showCursor => _showCursor;
  set showCursor(bool value) {
    if (_showCursor == value) {
      return;
    }
    _showCursor = value;
    markNeedsPaint();
  }

  bool _expands;
  bool get expands => _expands;
  set expands(bool value) {
    if (_expands == value) {
      return;
    }
    _expands = value;
  }

  TextStyle _style;
  TextStyle get style => _style;
  set style(TextStyle value) {
    if (_style == value) {
      return;
    }
    _style = value;
    _blockLayouts = [];
    markNeedsLayout();
  }

  double _cursorWidth;
  double get cursorWidth => _cursorWidth;
  set cursorWidth(double value) {
    if (_cursorWidth == value) {
      return;
    }
    _cursorWidth = value;
    markNeedsPaint();
  }

  double? _cursorHeight;
  double? get cursorHeight => _cursorHeight;
  set cursorHeight(double? value) {
    if (_cursorHeight == value) {
      return;
    }
    _cursorHeight = value;
    markNeedsPaint();
  }

  Radius? _cursorRadius;
  Radius? get cursorRadius => _cursorRadius;
  set cursorRadius(Radius? value) {
    if (_cursorRadius == value) {
      return;
    }
    _cursorRadius = value;
    markNeedsPaint();
  }

  Color _cursorColor;
  Color get cursorColor => _cursorColor;
  set cursorColor(Color value) {
    if (_cursorColor == value) {
      return;
    }
    _cursorColor = value;
    markNeedsPaint();
  }

  Color _selectionColor;
  Color get selectionColor => _selectionColor;
  set selectionColor(Color value) {
    if (_selectionColor == value) {
      return;
    }
    _selectionColor = value;
    markNeedsPaint();
  }

  TextAlign _textAlign;
  TextAlign get textAlign => _textAlign;
  set textAlign(TextAlign value) {
    if (_textAlign == value) {
      return;
    }
    _textAlign = value;
    markNeedsLayout();
  }

  TextDirection _textDirection;
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  TextWidthBasis _textWidthBasis;
  TextWidthBasis get textWidthBasis => _textWidthBasis;
  set textWidthBasis(TextWidthBasis value) {
    if (_textWidthBasis == value) {
      return;
    }
    _textWidthBasis = value;
    markNeedsLayout();
  }

  TextHeightBehavior? _textHeightBehavior;
  TextHeightBehavior? get textHeightBehavior => _textHeightBehavior;
  set textHeightBehavior(TextHeightBehavior? value) {
    if (_textHeightBehavior == value) {
      return;
    }
    _textHeightBehavior = value;
    markNeedsLayout();
  }

  StrutStyle? _strutStyle;
  StrutStyle? get strutStyle => _strutStyle;
  set strutStyle(StrutStyle? value) {
    if (_strutStyle == value) {
      return;
    }
    _strutStyle = value;
    markNeedsLayout();
  }

  SelectionChangedCallback _onSelectionChanged;

  VoidCallback? _onTap;

  void Function(Offset globalPosition)? _onLongPress;

  void Function(Offset globalPosition)? _onDoubleTap;

  // Block layout information
  List<_BlockLayout> _blockLayouts = [];

  // Tap tracking
  Offset? _lastTapDownPosition;
  int? _lastTapTime;
  Timer? _longPressTimer;
  bool _longPressDetected = false;
  bool _doubleTapDetected = false;

  // Selection handle tracking
  Offset? _startHandlePosition;
  Offset? _endHandlePosition;
  bool _isDraggingStartHandle = false;
  bool _isDraggingEndHandle = false;

  // Double tap tracking
  static const _doubleTapTimeout = Duration(milliseconds: 300);
  static const _longPressTimeout = Duration(milliseconds: 500);
  static const _handleRadius = 8.0;

  void _handleControllerChanged() {
    _blockLayouts = []; // Clear cache when controller changes
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void detach() {
    _longPressTimer?.cancel();
    _controller.removeListener(_handleControllerChanged);
    super.detach();
  }

  List<_BlockLayout> _buildBlockLayouts() {
    if (_blockLayouts.isNotEmpty) {
      return _blockLayouts;
    }

    final fields = _controller.value ?? [];
    final layouts = <_BlockLayout>[];
    var textOffset = 0;

    // If there are no fields or no blocks, create a dummy empty paragraph block for cursor rendering
    if (fields.isEmpty || fields.every((f) => f.children.isEmpty)) {
      // Get block style from controller
      final padding = (_controller.style.paragraph.padding ?? EdgeInsets.zero)
          as EdgeInsets;
      final margin =
          (_controller.style.paragraph.margin ?? EdgeInsets.zero) as EdgeInsets;

      // Build text style
      final baseStyle = _controller.style.paragraph.textStyle ?? _style;
      final textStyle = baseStyle.copyWith(
        color: _controller.style.paragraph.foregroundColor ?? baseStyle.color,
      );

      // Create text painter for empty block
      final painter = TextPainter(
        text: TextSpan(text: "", style: textStyle),
        textAlign: _textAlign,
        textDirection: _textDirection,
        textWidthBasis: _textWidthBasis,
        textHeightBehavior: _textHeightBehavior,
        strutStyle: _strutStyle,
      );

      // Create a dummy block for layout purposes
      const dummyBlock = MarkdownParagraphBlockValue(
        id: "dummy",
        property: MarkdownBlockProperty(),
        children: [
          MarkdownLineValue(
            id: "dummy-line",
            property: MarkdownLineProperty(),
            children: [
              MarkdownSpanValue(
                id: "dummy-span",
                value: "",
                property: MarkdownSpanProperty(),
              ),
            ],
          ),
        ],
      );

      layouts.add(_BlockLayout(
        block: dummyBlock,
        painter: painter,
        textOffset: 0,
        textLength: 0,
        padding: padding,
        margin: margin,
      ));

      _blockLayouts = layouts;
      return layouts;
    }

    for (final field in fields) {
      for (final block in field.children) {
        if (block is MarkdownParagraphBlockValue) {
          // Get block text
          final blockText = StringBuffer();
          for (var i = 0; i < block.children.length; i++) {
            final line = block.children[i];
            for (final span in line.children) {
              blockText.write(span.value);
            }
            if (i < block.children.length - 1) {
              blockText.writeln();
            }
          }

          final text = blockText.toString();

          // Get block style from controller
          var padding = (_controller.style.paragraph.padding ?? EdgeInsets.zero)
              as EdgeInsets;
          final margin = (_controller.style.paragraph.margin ?? EdgeInsets.zero)
              as EdgeInsets;

          // Apply indent
          final indentWidth = block.indent * _controller.style.indentWidth;
          padding = padding.copyWith(left: padding.left + indentWidth);

          // Build text style
          final baseStyle = _controller.style.paragraph.textStyle ?? _style;
          final textStyle = baseStyle.copyWith(
            color:
                _controller.style.paragraph.foregroundColor ?? baseStyle.color,
          );

          // Create text painter for this block
          final painter = TextPainter(
            text: TextSpan(text: text, style: textStyle),
            textAlign: _textAlign,
            textDirection: _textDirection,
            textWidthBasis: _textWidthBasis,
            textHeightBehavior: _textHeightBehavior,
            strutStyle: _strutStyle,
          );

          layouts.add(_BlockLayout(
            block: block,
            painter: painter,
            textOffset: textOffset,
            textLength: text.length,
            padding: padding,
            margin: margin,
          ));

          textOffset += text.length + 1; // +1 for newline between blocks
        }
      }
    }

    _blockLayouts = layouts;
    return layouts;
  }

  @override
  void performLayout() {
    final layouts = _buildBlockLayouts();

    var totalHeight = 0.0;
    final maxWidth = constraints.maxWidth;

    for (final layout in layouts) {
      // Add margin top
      totalHeight += layout.margin.top;

      // Layout text painter with padding
      final contentWidth = maxWidth - layout.padding.horizontal;
      layout.painter.layout(
        minWidth: contentWidth,
        maxWidth: contentWidth,
      );

      // Calculate block height with padding
      final blockHeight = layout.painter.height +
          layout.padding.vertical +
          layout.margin.bottom;
      layout.offset = Offset(0, totalHeight + layout.padding.top);
      layout.height = blockHeight;

      totalHeight += blockHeight;
    }

    // If expands is true, use the maximum available height
    // Otherwise, use the actual content height
    final height = _expands ? constraints.maxHeight : totalHeight;

    size = constraints.constrain(Size(
      constraints.maxWidth,
      height,
    ));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final canvas = context.canvas;
    // Use already computed layouts from performLayout
    final layouts = _blockLayouts;

    var currentTextOffset = 0;

    // Reset handle positions
    _startHandlePosition = null;
    _endHandlePosition = null;

    for (final layout in layouts) {
      final blockOffset =
          offset + layout.offset + Offset(layout.padding.left, 0);

      // Draw block background if any
      if (layout.block.property.backgroundColor != null) {
        final blockRect = Rect.fromLTWH(
          offset.dx,
          offset.dy + layout.offset.dy - layout.padding.top,
          size.width,
          layout.height,
        );
        canvas.drawRect(
          blockRect,
          Paint()..color = layout.block.property.backgroundColor!,
        );
      }

      // Calculate selection for this block
      final blockStart = currentTextOffset;
      final blockEnd = currentTextOffset + layout.textLength;

      // Draw selection for this block
      if (_selection.isValid && !_selection.isCollapsed) {
        if (_selection.start < blockEnd && _selection.end > blockStart) {
          final localStart =
              (_selection.start - blockStart).clamp(0, layout.textLength);
          final localEnd =
              (_selection.end - blockStart).clamp(0, layout.textLength);

          final localSelection = TextSelection(
            baseOffset: localStart,
            extentOffset: localEnd,
          );

          final boxes = layout.painter.getBoxesForSelection(localSelection);
          final paint = Paint()..color = _selectionColor;

          // Draw selection with extended vertical height (padding included)
          for (final box in boxes) {
            final boxRect = box.toRect().shift(blockOffset);
            // Extend vertically to include padding
            final extendedRect = Rect.fromLTRB(
              boxRect.left,
              offset.dy + layout.offset.dy - layout.padding.top,
              boxRect.right,
              offset.dy +
                  layout.offset.dy +
                  layout.painter.height +
                  layout.padding.bottom,
            );
            canvas.drawRect(extendedRect, paint);
          }

          // Calculate handle positions at the top of the selection
          // Store positions in local coordinates (without offset)
          // Only show start handle if this block contains the actual start of the selection
          if (_selection.start >= blockStart && _selection.start < blockEnd) {
            // Start handle - position at the top left of selection
            final startOffset = layout.painter.getOffsetForCaret(
              TextPosition(offset: localStart),
              Rect.zero,
            );
            _startHandlePosition = Offset(layout.padding.left,
                    layout.offset.dy - layout.padding.top) +
                Offset(startOffset.dx, 0);
          }
          // Only show end handle if this block contains the actual end of the selection
          if (_selection.end > blockStart && _selection.end <= blockEnd) {
            // End handle - position at the top right of selection
            final endOffset = layout.painter.getOffsetForCaret(
              TextPosition(offset: localEnd),
              Rect.zero,
            );
            _endHandlePosition = Offset(layout.padding.left,
                    layout.offset.dy - layout.padding.top) +
                Offset(endOffset.dx, 0);
          }
        }
      }

      // Draw text
      layout.painter.paint(canvas, blockOffset);

      // Draw cursor for this block
      if (_showCursor &&
          _selection.isValid &&
          _selection.isCollapsed &&
          _selection.baseOffset >= blockStart &&
          _selection.baseOffset <= blockEnd) {
        final localOffset = _selection.baseOffset - blockStart;
        final cursorOffset = layout.painter.getOffsetForCaret(
          TextPosition(offset: localOffset),
          Rect.zero,
        );
        final cursorHeight =
            _cursorHeight ?? layout.painter.preferredLineHeight;
        final cursorRect = Rect.fromLTWH(
          blockOffset.dx + cursorOffset.dx,
          blockOffset.dy + cursorOffset.dy,
          _cursorWidth,
          cursorHeight,
        );

        final paint = Paint()..color = _cursorColor;
        if (_cursorRadius != null) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(cursorRect, _cursorRadius!),
            paint,
          );
        } else {
          canvas.drawRect(cursorRect, paint);
        }
      }

      currentTextOffset = blockEnd + 1; // +1 for newline between blocks
    }

    // Draw selection handles
    if (_selection.isValid && !_selection.isCollapsed) {
      final handlePaint = Paint()
        ..color = _cursorColor
        ..style = PaintingStyle.fill;

      // Draw start handle (add offset for drawing)
      if (_startHandlePosition != null) {
        _drawSelectionHandle(
          canvas,
          offset + _startHandlePosition!,
          handlePaint,
          isLeft: true,
        );
      }

      // Draw end handle (add offset for drawing)
      if (_endHandlePosition != null) {
        _drawSelectionHandle(
          canvas,
          offset + _endHandlePosition!,
          handlePaint,
          isLeft: false,
        );
      }
    }
  }

  void _drawSelectionHandle(
    Canvas canvas,
    Offset position,
    Paint paint, {
    required bool isLeft,
  }) {
    // Draw circle handle at the top
    canvas.drawCircle(position, _handleRadius, paint);

    // Draw line extending downward from handle
    final lineStart = position;
    final lineEnd = Offset(position.dx, position.dy + _handleRadius * 3);
    canvas.drawLine(
      lineStart,
      lineEnd,
      paint..strokeWidth = 2.0,
    );
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  void handleEvent(PointerEvent event, BoxHitTestEntry entry) {
    assert(debugHandleEvent(event, entry), "");
    if (event is PointerDownEvent) {
      _handleTapDown(event);
    } else if (event is PointerUpEvent) {
      _handleTapUp(event);
    } else if (event is PointerMoveEvent) {
      _handleDragUpdate(event);
    } else if (event is PointerCancelEvent) {
      _handlePointerCancel(event);
    }
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    _longPressTimer?.cancel();
    _longPressTimer = null;
    _lastTapDownPosition = null;
    _longPressDetected = false;
    _doubleTapDetected = false;
    _isDraggingStartHandle = false;
    _isDraggingEndHandle = false;
  }

  int? _getTextOffsetForPosition(Offset position) {
    final layouts = _blockLayouts;
    var currentTextOffset = 0;

    for (final layout in layouts) {
      final blockOffset = layout.offset + Offset(layout.padding.left, 0);
      final blockBottom = blockOffset.dy + layout.painter.height;
      // Define the actual text area boundaries (excluding padding)
      final blockTop = layout.offset.dy - layout.padding.top;

      if (position.dy >= blockOffset.dy && position.dy <= blockBottom) {
        // Get the actual text width by checking where the last character is
        final textLength = layout.textLength;
        double actualTextRight = layout.padding.left;
        if (textLength > 0) {
          // Get the position of the last character
          final lastCharOffset = layout.painter.getOffsetForCaret(
            TextPosition(offset: textLength),
            Rect.zero,
          );
          actualTextRight = layout.padding.left + lastCharOffset.dx;
        }

        // Check if position is within the horizontal text bounds
        if (position.dx < layout.padding.left ||
            position.dx > actualTextRight) {
          // If expands is true, treat empty space as end of text (for full-width tap area)
          // Otherwise return null to deselect
          if (_expands) {
            return currentTextOffset + textLength;
          } else {
            return null;
          }
        }
        // Position is within this block's text area
        final localPosition = position - blockOffset;
        final textPosition = layout.painter.getPositionForOffset(localPosition);
        return currentTextOffset + textPosition.offset;
      } else if (position.dy >= blockTop &&
          position.dy <
              layout.offset.dy +
                  layout.painter.height +
                  layout.padding.bottom) {
        // Position is in vertical padding area
        // If expands is true, treat as end of text
        if (_expands) {
          return currentTextOffset + layout.textLength;
        } else {
          return null;
        }
      }

      currentTextOffset +=
          layout.textLength + 1; // +1 for newline between blocks
    }

    // Position is after all blocks (below the last text block)
    // This is still within the editor field area, so:
    // - If expands is true: return end of text (cursor at end)
    // - If expands is false: return null to deselect
    if (_expands && layouts.isNotEmpty) {
      final lastOffset = currentTextOffset > 0 ? currentTextOffset - 1 : 0;
      return lastOffset;
    } else {
      return null;
    }
  }

  void _handleTapDown(PointerDownEvent event) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final position = globalToLocal(event.position);

    // Check if tapping on selection handles
    // Check both handles and select the closer one if both are in range
    final startDistance = _startHandlePosition != null
        ? (position - _startHandlePosition!).distance
        : double.infinity;
    final endDistance = _endHandlePosition != null
        ? (position - _endHandlePosition!).distance
        : double.infinity;

    if (startDistance < _handleRadius * 3 || endDistance < _handleRadius * 3) {
      // Select the closer handle
      if (startDistance < endDistance) {
        _isDraggingStartHandle = true;
      } else {
        _isDraggingEndHandle = true;
      }
      return;
    }

    // Reset flags
    _longPressDetected = false;
    _doubleTapDetected = false;
    _isDraggingStartHandle = false;
    _isDraggingEndHandle = false;

    // Check for double tap
    if (_lastTapTime != null &&
        _lastTapDownPosition != null &&
        now - _lastTapTime! < _doubleTapTimeout.inMilliseconds &&
        (position - _lastTapDownPosition!).distance < 20) {
      // Double tap detected
      _doubleTapDetected = true;
      _handleDoubleTapDetected(event.position);
      _lastTapTime = null;
      _lastTapDownPosition = null;
      _longPressTimer?.cancel();
      return;
    }

    _lastTapDownPosition = position;
    _lastTapTime = now;

    // Start long press timer
    _longPressTimer?.cancel();
    _longPressTimer = Timer(_longPressTimeout, () {
      _longPressDetected = true;
      _handleLongPressDetected(event.position);
    });
  }

  void _handleTapUp(PointerUpEvent event) {
    _longPressTimer?.cancel();
    _longPressTimer = null;

    // Reset handle dragging flags
    if (_isDraggingStartHandle || _isDraggingEndHandle) {
      _isDraggingStartHandle = false;
      _isDraggingEndHandle = false;
      return;
    }

    // If long press or double tap was detected, don't process as normal tap
    if (_longPressDetected || _doubleTapDetected) {
      _longPressDetected = false;
      _doubleTapDetected = false;
      return;
    }

    if (_lastTapDownPosition == null) {
      return;
    }

    final position = globalToLocal(event.position);

    // Check if it's a drag (moved too far from tap down position)
    if ((position - _lastTapDownPosition!).distance > 10) {
      return;
    }

    final textOffset = _getTextOffsetForPosition(position);

    _onTap?.call();

    if (textOffset != null) {
      // Tapped on text, set cursor position
      _onSelectionChanged(
        TextSelection.collapsed(offset: textOffset),
        SelectionChangedCause.tap,
      );
    } else {
      // Tapped on empty space (padding/margin), clear selection
      _onSelectionChanged(
        const TextSelection.collapsed(offset: 0),
        SelectionChangedCause.tap,
      );
    }
  }

  void _handleDoubleTapDetected(Offset globalPosition) {
    final position = globalToLocal(globalPosition);
    final textOffset = _getTextOffsetForPosition(position);

    if (textOffset != null) {
      // Select word at position
      final text = _controller.getPlainText();
      final wordBoundary = _getWordBoundary(text, textOffset);

      _onSelectionChanged(
        TextSelection(
          baseOffset: wordBoundary.start,
          extentOffset: wordBoundary.end,
        ),
        SelectionChangedCause.doubleTap,
      );
    }
    // Call onDoubleTap callback even if tapping on empty space
    _onDoubleTap?.call(globalPosition);
  }

  void _handleLongPressDetected(Offset globalPosition) {
    final position = globalToLocal(globalPosition);
    final textOffset = _getTextOffsetForPosition(position);

    if (textOffset != null) {
      // Select word at position
      final text = _controller.getPlainText();
      final wordBoundary = _getWordBoundary(text, textOffset);

      _onSelectionChanged(
        TextSelection(
          baseOffset: wordBoundary.start,
          extentOffset: wordBoundary.end,
        ),
        SelectionChangedCause.longPress,
      );
    }
    // Call onLongPress callback even if pressing on empty space
    _onLongPress?.call(globalPosition);
  }

  TextRange _getWordBoundary(String text, int offset) {
    // Word boundary detection
    var start = offset;
    var end = offset;

    // Find start of word
    while (start > 0 && !_isWordBoundary(text[start - 1])) {
      start--;
    }

    // Find end of word
    while (end < text.length && !_isWordBoundary(text[end])) {
      end++;
    }

    return TextRange(start: start, end: end);
  }

  bool _isWordBoundary(String char) {
    // Consider whitespace, punctuation as word boundaries
    return char == " " ||
        char == "\n" ||
        char == "\t" ||
        char == "." ||
        char == "," ||
        char == "!" ||
        char == "?" ||
        char == ";" ||
        char == ":" ||
        char == "-" ||
        char == "(" ||
        char == ")" ||
        char == "[" ||
        char == "]" ||
        char == "{" ||
        char == "}" ||
        char == "<" ||
        char == ">" ||
        char == "/" ||
        char == "\\" ||
        char == "|" ||
        char == "@" ||
        char == "#" ||
        char == "\$" ||
        char == "%" ||
        char == "^" ||
        char == "&" ||
        char == "*" ||
        char == "+" ||
        char == "=" ||
        char == "~" ||
        char == "`" ||
        char == "\"" ||
        char == "'";
  }

  void _handleDragUpdate(PointerMoveEvent event) {
    final position = globalToLocal(event.position);

    // Handle selection handle dragging
    if (_isDraggingStartHandle || _isDraggingEndHandle) {
      final textOffset = _getTextOffsetForPosition(position);

      if (textOffset != null) {
        if (_isDraggingStartHandle) {
          // Update start of selection
          final newStart = textOffset.clamp(0, _selection.end);
          _onSelectionChanged(
            TextSelection(
              baseOffset: newStart,
              extentOffset: _selection.end,
            ),
            SelectionChangedCause.drag,
          );
        } else if (_isDraggingEndHandle) {
          // Update end of selection
          final newEnd =
              textOffset.clamp(_selection.start, _getPlainText().length);
          _onSelectionChanged(
            TextSelection(
              baseOffset: _selection.start,
              extentOffset: newEnd,
            ),
            SelectionChangedCause.drag,
          );
        }
      }
      // Force repaint to update handle positions
      markNeedsPaint();
      return;
    }

    if (_lastTapDownPosition == null) {
      return;
    }

    // Cancel long press if moved too far
    if ((position - _lastTapDownPosition!).distance > 10) {
      _longPressTimer?.cancel();
      _longPressTimer = null;
    }

    final textOffset = _getTextOffsetForPosition(position);

    // Only update selection if drag is within text area
    if (textOffset != null) {
      if (_selection.isCollapsed) {
        // Start selection from tap down position
        final downOffset = _getTextOffsetForPosition(_lastTapDownPosition!);
        if (downOffset != null) {
          _onSelectionChanged(
            TextSelection(
              baseOffset: downOffset,
              extentOffset: textOffset,
            ),
            SelectionChangedCause.drag,
          );
        }
      } else {
        // Extend selection
        _onSelectionChanged(
          TextSelection(
            baseOffset: _selection.baseOffset,
            extentOffset: textOffset,
          ),
          SelectionChangedCause.drag,
        );
      }
    }
  }

  String _getPlainText() {
    return _controller.getPlainText();
  }
}

/// Layout information for a single markdown block.
///
/// 単一のマークダウンブロックのレイアウト情報。
class _BlockLayout {
  _BlockLayout({
    required this.block,
    required this.painter,
    required this.textOffset,
    required this.textLength,
    required this.padding,
    required this.margin,
  });

  /// The markdown block.
  ///
  /// マークダウンブロック。
  final MarkdownParagraphBlockValue block;

  /// Text painter for this block.
  ///
  /// このブロックのテキストペインター。
  final TextPainter painter;

  /// Text offset in the overall document.
  ///
  /// ドキュメント全体でのテキストオフセット。
  final int textOffset;

  /// Length of text in this block.
  ///
  /// このブロックのテキストの長さ。
  final int textLength;

  /// Padding for this block.
  ///
  /// このブロックのパディング。
  final EdgeInsets padding;

  /// Margin for this block.
  ///
  /// このブロックのマージン。
  final EdgeInsets margin;

  /// Offset where this block is positioned.
  ///
  /// このブロックが配置されるオフセット。
  Offset offset = Offset.zero;

  /// Height of this block including padding and margin.
  ///
  /// パディングとマージンを含むこのブロックの高さ。
  double height = 0;
}
