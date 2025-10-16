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

  // Keep track of composing text during IME input
  String? _composingText;

  /// Returns the current composing text during IME input, or null if not composing.
  ///
  /// IME入力中の変換テキストを返します。変換中でない場合はnullを返します。
  String? get composingText => _composingText;

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
    final textLength = text.length;

    // Clamp selection and composing region to valid text range
    // Only clamp if values are actually out of bounds to preserve IME state
    final clampedSelection = TextSelection(
      baseOffset: _selection.baseOffset.clamp(0, textLength),
      extentOffset: _selection.extentOffset.clamp(0, textLength),
    );

    final clampedComposing = _composingRegion != null &&
            _composingRegion!.start <= textLength &&
            _composingRegion!.end <= textLength
        ? TextRange(
            start: _composingRegion!.start,
            end: _composingRegion!.end,
          )
        : (_composingRegion != null
            ? TextRange(
                start: _composingRegion!.start.clamp(0, textLength),
                end: _composingRegion!.end.clamp(0, textLength),
              )
            : TextRange.empty);

    _textInputConnection!.setEditingState(
      TextEditingValue(
        text: text,
        selection: clampedSelection,
        composing: clampedComposing,
      ),
    );
  }

  String _getPlainText() {
    // Always use controller's text, which is now updated during IME composing
    final plainText = widget.controller.getPlainText();

    // Debug: Check consistency between _composingText and controller
    if (_composingText != null && _composingText != plainText) {
      debugPrint("⚠️ IME/Controller inconsistency detected:");
      debugPrint(
          "  _composingText: '$_composingText' (${_composingText!.length} chars)");
      debugPrint("  controller text: '$plainText' (${plainText.length} chars)");
      debugPrint("  Stack trace: ${StackTrace.current}");
    }

    return plainText;
  }

  // TextInputClient implementation
  @override
  void updateEditingValue(TextEditingValue value) {
    if (widget.readOnly) {
      return;
    }

    // Get the actual current text
    // During IME composing, use _composingText if available
    // Otherwise use the controller's text
    final oldText = _composingText ?? widget.controller.getPlainText();
    final newText = value.text;

    // Check if we're currently composing
    final isComposing = value.composing.isValid && value.composing.start != -1;

    if (oldText != newText) {
      // Text changed

      if (isComposing) {
        // During IME composing, update BOTH _composingText and controller
        // This preserves block structure during IME input
        if (_composingText == null) {
          debugPrint("🎯 IME composing started");
        }
        _composingText = newText;
        _selection = value.selection;
        _composingRegion = TextSelection(
          baseOffset: value.composing.start,
          extentOffset: value.composing.end,
        );

        // Find the difference and update controller
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

        // Update controller to maintain block structure
        widget.controller.replaceText(start, oldEnd, replacementText);

        // Trigger rebuild to show composing text
        setState(() {});
      } else {
        // Composition ended or normal text input - update controller

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
          // Check if this is a backspace/delete operation at the end of a link
          final isDeletion = replacementText.isEmpty && oldEnd > start;

          // Use the new cursor position from the value, or fall back to the current selection
          final cursorOffset = value.selection.isCollapsed
              ? value.selection.baseOffset
              : value.selection.end;

          debugPrint(
              "🔍 Checking deletion: isDeletion=$isDeletion, cursorOffset=$cursorOffset, _selection.isCollapsed=${_selection.isCollapsed}");

          // Only check for link deletion when the cursor is collapsed (no selection)
          // AND we haven't already selected a link range
          if (isDeletion && value.selection.isCollapsed) {
            // Check if cursor is at the end of a link
            debugPrint("   Calling getLinkRangeBeforeCursor($cursorOffset)");
            final linkRange =
                widget.controller.getLinkRangeBeforeCursor(cursorOffset);
            debugPrint("   Result: $linkRange");
            if (linkRange != null) {
              // Check if the current selection already matches the link range
              // If so, allow deletion to proceed
              final alreadySelected = _selection.baseOffset == linkRange.start &&
                  _selection.extentOffset == linkRange.end;

              if (!alreadySelected) {
                // Select the entire link instead of deleting
                debugPrint(
                    "🔗 Backspace at end of link - selecting link range: $linkRange");
                _selection = TextSelection(
                  baseOffset: linkRange.start,
                  extentOffset: linkRange.end,
                );
                _composingRegion = null;
                _updateRemoteEditingValue();
                setState(() {});
                return; // Don't delete, just select
              } else {
                debugPrint("   Link already selected, allowing deletion");
              }
            } else {
              debugPrint("   No link found before cursor");
            }
          }

          // Check if backspace deleted a block
          final blockCountBefore =
              widget.controller.value?.firstOrNull?.children.length ?? 0;

          debugPrint(
              "📝 Before replaceText: start=$start, oldEnd=$oldEnd, replacementText='$replacementText', blockCountBefore=$blockCountBefore");

          // Normal text replacement
          widget.controller.replaceText(start, oldEnd, replacementText);

          final blockCountAfter =
              widget.controller.value?.firstOrNull?.children.length ?? 0;

          debugPrint(
              "📝 After replaceText: blockCountAfter=$blockCountAfter, value.selection=${value.selection}");

          // If a block was deleted (backspace at empty block start)
          if (blockCountAfter < blockCountBefore &&
              oldEnd > start &&
              replacementText.isEmpty) {
            // Blocks were deleted/merged
            // Check if the remaining text ends with a trailing newline (orphaned from deleted block)
            final currentText = widget.controller.getPlainText();
            debugPrint(
                "   → Block deleted, currentText length=${currentText.length}, ends with newline=${currentText.endsWith('\n')}");

            if (currentText.endsWith("\n") && currentText.isNotEmpty) {
              // Remove the trailing newline
              final newTextWithoutTrailingNewline =
                  currentText.substring(0, currentText.length - 1);
              debugPrint(
                  "   → Removing trailing newline, new length=${newTextWithoutTrailingNewline.length}");

              // Replace all text to remove the trailing newline
              widget.controller.replaceText(
                  0, currentText.length, newTextWithoutTrailingNewline);

              // Position cursor at the end of the remaining text (without the newline)
              _selection = TextSelection.collapsed(
                  offset: newTextWithoutTrailingNewline.length);
              debugPrint(
                  "   → Cursor positioned at end: ${newTextWithoutTrailingNewline.length}");
            } else {
              // Keep cursor at start position (blocks were merged normally)
              debugPrint("   → No trailing newline, setting cursor to start=$start");
              _selection = TextSelection.collapsed(offset: start);
            }
            _composingRegion = null;
          } else {
            // Update cursor position and composing region
            debugPrint(
                "   → No block deleted or not a deletion, using value.selection=${value.selection}");
            _selection = value.selection;
            _composingRegion = null;
          }
        }

        widget.onChanged?.call(widget.controller.value ?? []);

        // Clear composing text after updating controller
        if (_composingText != null) {
          debugPrint("✅ IME composing ended and committed (text changed)");
        }
        _composingText = null;

        // Update remote value after composing ends
        _updateRemoteEditingValue();

        // Trigger rebuild to reflect changes
        setState(() {});
      }
    } else {
      // Only selection or composing region changed
      _selection = value.selection;

      // Check if composing just ended (we had composing text, but now composition is invalid)
      if (_composingText != null &&
          (!value.composing.isValid || value.composing.start == -1)) {
        // Composition ended
        final textToCommit = _composingText!;
        final currentText = widget.controller.getPlainText();

        // If text is already committed (textToCommit == currentText),
        // no need to call replaceText, just clear composing state
        if (textToCommit == currentText) {
          // Text already matches, just clear composing state
          debugPrint("✅ IME composing ended (text already committed)");
          _composingText = null;
          _composingRegion = null;

          // Update cursor to end of text
          _selection = TextSelection.collapsed(offset: textToCommit.length);

          // Update remote value
          _updateRemoteEditingValue();

          setState(() {});
        } else {
          // Text doesn't match, need to commit
          debugPrint("⚠️ IME composing ended with text mismatch:");
          debugPrint("  textToCommit: '$textToCommit'");
          debugPrint("  currentText: '$currentText'");

          // Set cursor to start position before committing
          // This ensures the history saves the correct cursor position (0)
          _selection = TextSelection.collapsed(offset: currentText.length);

          // Replace the entire text with the committed text
          widget.controller.replaceText(0, currentText.length, textToCommit);

          widget.onChanged?.call(widget.controller.value ?? []);

          // Clear composing state
          _composingText = null;
          _composingRegion = null;

          // Update cursor to end of committed text
          _selection = TextSelection.collapsed(offset: textToCommit.length);

          // Update remote value
          _updateRemoteEditingValue();

          setState(() {});
        }
      } else if (!value.composing.isValid || value.composing.start == -1) {
        // Composing ended but we had no composing text
        _composingRegion = null;
        _updateRemoteEditingValue();
        setState(() {});
      } else {
        // Still composing
        _composingRegion = TextSelection(
          baseOffset: value.composing.start,
          extentOffset: value.composing.end,
        );
        setState(() {});
      }
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

          // Clear composing state when inserting newline
          if (_composingText != null) {
            debugPrint("🔄 Newline inserted, clearing composing state");
            debugPrint("  _composingText was: '$_composingText'");
          }
          _composingText = null;
          _composingRegion = null;

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
      composingText: _composingText,
      showCursor: showCursor,
      expands: widget.expands,
      style: defaultStyle!,
      cursorWidth: widget.cursorWidth,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorColor: cursorColor,
      theme: theme,
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
      enabled: widget.enabled ?? true,
      readOnly: widget.readOnly,
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
    required this.theme,
    required this.textAlign,
    required this.textDirection,
    required this.textWidthBasis,
    required this.onSelectionChanged,
    required this.onTap,
    required this.enabled,
    required this.readOnly,
    this.composingRegion,
    this.composingText,
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
  final String? composingText;
  final bool showCursor;
  final bool expands;
  final TextStyle style;
  final double cursorWidth;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final Color cursorColor;
  final Color selectionColor;
  final ThemeData theme;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final TextWidthBasis textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final StrutStyle? strutStyle;
  final SelectionChangedCallback onSelectionChanged;
  final VoidCallback? onTap;
  final void Function(Offset globalPosition)? onLongPress;
  final void Function(Offset globalPosition)? onDoubleTap;
  final bool enabled;
  final bool readOnly;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMarkdownEditor(
      controller: controller,
      focusNode: focusNode,
      selection: selection,
      composingRegion: composingRegion,
      composingText: composingText,
      showCursor: showCursor,
      expands: expands,
      style: style,
      cursorWidth: cursorWidth,
      cursorHeight: cursorHeight,
      cursorRadius: cursorRadius,
      cursorColor: cursorColor,
      selectionColor: selectionColor,
      theme: theme,
      textAlign: textAlign,
      textDirection: textDirection,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      strutStyle: strutStyle,
      onSelectionChanged: onSelectionChanged,
      onTap: onTap,
      onLongPress: onLongPress,
      onDoubleTap: onDoubleTap,
      enabled: enabled,
      readOnly: readOnly,
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
      ..composingText = composingText
      ..showCursor = showCursor
      ..expands = expands
      ..style = style
      ..cursorWidth = cursorWidth
      ..cursorHeight = cursorHeight
      ..cursorRadius = cursorRadius
      ..cursorColor = cursorColor
      ..selectionColor = selectionColor
      ..theme = theme
      ..textAlign = textAlign
      ..textDirection = textDirection
      ..textWidthBasis = textWidthBasis
      ..textHeightBehavior = textHeightBehavior
      ..strutStyle = strutStyle
      .._onSelectionChanged = onSelectionChanged
      .._onTap = onTap
      .._onLongPress = onLongPress
      .._onDoubleTap = onDoubleTap
      ..enabled = enabled
      ..readOnly = readOnly;
  }
}

/// RenderBox for markdown editor.
///
/// Markdownエディタ用のRenderBox。
class _RenderMarkdownEditor extends RenderBox implements RenderContext {
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
    required ThemeData theme,
    required TextAlign textAlign,
    required TextDirection textDirection,
    required TextWidthBasis textWidthBasis,
    required SelectionChangedCallback onSelectionChanged,
    required VoidCallback? onTap,
    required bool enabled,
    required bool readOnly,
    TextSelection? composingRegion,
    String? composingText,
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
        _composingText = composingText,
        _showCursor = showCursor,
        _expands = expands,
        _style = style,
        _cursorWidth = cursorWidth,
        _cursorHeight = cursorHeight,
        _cursorRadius = cursorRadius,
        _cursorColor = cursorColor,
        _theme = theme,
        _selectionColor = selectionColor,
        _textAlign = textAlign,
        _textDirection = textDirection,
        _textWidthBasis = textWidthBasis,
        _textHeightBehavior = textHeightBehavior,
        _strutStyle = strutStyle,
        _onSelectionChanged = onSelectionChanged,
        _onTap = onTap,
        _onLongPress = onLongPress,
        _onDoubleTap = onDoubleTap,
        _enabled = enabled,
        _readOnly = readOnly;

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

  @override
  FocusNode get focusNode => _focusNode;
  set focusNode(FocusNode value) {
    if (_focusNode == value) {
      return;
    }
    _focusNode = value;
  }

  FocusNode _focusNode;

  @override
  TextSelection get selection => _selection;
  set selection(TextSelection value) {
    if (_selection == value) {
      return;
    }
    _selection = value;
    markNeedsPaint();
  }

  TextSelection _selection;

  @override
  TextSelection? get composingRegion => _composingRegion;
  set composingRegion(TextSelection? value) {
    if (_composingRegion == value) {
      return;
    }
    _composingRegion = value;
    markNeedsPaint();
  }

  TextSelection? _composingRegion;

  String? get composingText => _composingText;
  set composingText(String? value) {
    if (_composingText == value) {
      return;
    }
    _composingText = value;
    _blockLayouts = []; // Clear cache when composing text changes
    markNeedsLayout();
  }

  String? _composingText;

  @override
  bool get showCursor => _showCursor;
  set showCursor(bool value) {
    if (_showCursor == value) {
      return;
    }
    _showCursor = value;
    markNeedsPaint();
  }

  bool _showCursor;

  @override
  bool get expands => _expands;
  set expands(bool value) {
    if (_expands == value) {
      return;
    }
    _expands = value;
  }

  bool _expands;

  @override
  TextStyle get style => _style;
  set style(TextStyle value) {
    if (_style == value) {
      return;
    }
    _style = value;
    _blockLayouts = [];
    markNeedsLayout();
  }

  TextStyle _style;

  @override
  double get cursorWidth => _cursorWidth;
  set cursorWidth(double value) {
    if (_cursorWidth == value) {
      return;
    }
    _cursorWidth = value;
    markNeedsPaint();
  }

  double _cursorWidth;

  @override
  double? get cursorHeight => _cursorHeight;
  set cursorHeight(double? value) {
    if (_cursorHeight == value) {
      return;
    }
    _cursorHeight = value;
    markNeedsPaint();
  }

  double? _cursorHeight;

  @override
  Radius? get cursorRadius => _cursorRadius;
  set cursorRadius(Radius? value) {
    if (_cursorRadius == value) {
      return;
    }
    _cursorRadius = value;
    markNeedsPaint();
  }

  Radius? _cursorRadius;

  @override
  Color get cursorColor => _cursorColor;
  set cursorColor(Color value) {
    if (_cursorColor == value) {
      return;
    }
    _cursorColor = value;
    markNeedsPaint();
  }

  Color _cursorColor;

  @override
  Color get selectionColor => _selectionColor;
  set selectionColor(Color value) {
    if (_selectionColor == value) {
      return;
    }
    _selectionColor = value;
    markNeedsPaint();
  }

  Color _selectionColor;

  @override
  ThemeData get theme => _theme;
  set theme(ThemeData value) {
    if (_theme == value) {
      return;
    }
    _theme = value;
    markNeedsPaint();
  }

  ThemeData _theme;

  @override
  TextAlign get textAlign => _textAlign;
  set textAlign(TextAlign value) {
    if (_textAlign == value) {
      return;
    }
    _textAlign = value;
    markNeedsLayout();
  }

  TextAlign _textAlign;

  @override
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  TextDirection _textDirection;

  @override
  TextWidthBasis get textWidthBasis => _textWidthBasis;
  set textWidthBasis(TextWidthBasis value) {
    if (_textWidthBasis == value) {
      return;
    }
    _textWidthBasis = value;
    markNeedsLayout();
  }

  TextWidthBasis _textWidthBasis;

  @override
  TextHeightBehavior? get textHeightBehavior => _textHeightBehavior;
  set textHeightBehavior(TextHeightBehavior? value) {
    if (_textHeightBehavior == value) {
      return;
    }
    _textHeightBehavior = value;
    markNeedsLayout();
  }

  TextHeightBehavior? _textHeightBehavior;

  @override
  StrutStyle? get strutStyle => _strutStyle;
  set strutStyle(StrutStyle? value) {
    if (_strutStyle == value) {
      return;
    }
    _strutStyle = value;
    markNeedsLayout();
  }

  StrutStyle? _strutStyle;

  SelectionChangedCallback _onSelectionChanged;

  VoidCallback? _onTap;

  void Function(Offset globalPosition)? _onLongPress;

  void Function(Offset globalPosition)? _onDoubleTap;

  bool _enabled;
  bool get enabled => _enabled;
  set enabled(bool value) {
    if (_enabled == value) {
      return;
    }
    debugPrint(
        "🔄 MarkdownField enabled changed: $_enabled -> $value (controller.hashCode: ${_controller.hashCode})");
    _enabled = value;
    markNeedsPaint();
  }

  bool _readOnly;
  bool get readOnly => _readOnly;
  set readOnly(bool value) {
    if (_readOnly == value) {
      return;
    }
    debugPrint(
        "🔄 MarkdownField readOnly changed: $_readOnly -> $value (controller.hashCode: ${_controller.hashCode})");
    _readOnly = value;
    markNeedsPaint();
  }

  // Block layout information
  List<_BlockLayout> _blockLayouts = [];

  // Tap tracking
  Offset? _lastTapDownPosition;
  int? _lastTapTime;
  Timer? _longPressTimer;
  bool _longPressDetected = false;

  // Track last link dialog show time to prevent duplicate calls
  int _lastLinkDialogShowTime = 0;
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

    // IMPORTANT: Always use controller's block structure, even during IME composing
    // The composing text will be rendered using the controller's structure
    // This ensures multi-line structure is preserved during IME input

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
        children: [
          MarkdownLineValue(
            id: "dummy-line",
            children: [
              MarkdownSpanValue(
                id: "dummy-span",
                value: "",
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
        spans: const [],
      ));

      _blockLayouts = layouts;
      return layouts;
    }

    for (final field in fields) {
      for (final block in field.children) {
        if (block is MarkdownParagraphBlockValue) {
          // Get block style from controller
          var padding = (_controller.style.paragraph.padding ?? EdgeInsets.zero)
              as EdgeInsets;
          final margin = (_controller.style.paragraph.margin ?? EdgeInsets.zero)
              as EdgeInsets;

          // Apply indent
          final indentWidth = block.indent * _controller.style.indentWidth;
          padding = padding.copyWith(left: padding.left + indentWidth);

          // Build base text style
          final baseStyle = _controller.style.paragraph.textStyle ?? _style;
          final baseTextStyle = baseStyle.copyWith(
            color:
                _controller.style.paragraph.foregroundColor ?? baseStyle.color,
          );

          // Build TextSpan tree with individual styles for each span
          final textSpans = <TextSpan>[];
          final spanInfos = <_SpanInfo>[];
          var totalLength = 0;

          for (var i = 0; i < block.children.length; i++) {
            final line = block.children[i];
            for (final span in line.children) {
              // Apply span-specific style
              final spanStyle =
                  span.textStyle(this, _controller, baseTextStyle);

              textSpans.add(TextSpan(
                text: span.value,
                style: spanStyle,
              ));

              // Store span info
              spanInfos.add(_SpanInfo(
                span: span,
                localOffset: totalLength,
                length: span.value.length,
              ));

              totalLength += span.value.length;
            }
            if (i < block.children.length - 1) {
              textSpans.add(TextSpan(text: "\n", style: baseTextStyle));
              totalLength += 1;
            }
          }

          // Create text painter for this block
          final painter = TextPainter(
            text: TextSpan(children: textSpans, style: baseTextStyle),
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
            textLength: totalLength,
            padding: padding,
            margin: margin,
            spans: spanInfos,
          ));

          textOffset += totalLength + 1; // +1 for newline between blocks
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

    for (var i = 0; i < layouts.length; i++) {
      final layout = layouts[i];

      // Add margin top
      totalHeight += layout.margin.top;

      // Add padding top
      totalHeight += layout.padding.top;

      // Layout text painter with padding
      final contentWidth = maxWidth - layout.padding.horizontal;
      layout.painter.layout(
        minWidth: contentWidth,
        maxWidth: contentWidth,
      );

      // Store the offset where the text content starts (after padding)
      layout.offset = Offset(0, totalHeight);

      // Calculate total block height with padding
      final blockHeight = layout.painter.height +
          layout.padding.vertical +
          layout.margin.bottom;
      layout.height = blockHeight;

      // Move totalHeight to the end of this block
      totalHeight +=
          layout.painter.height + layout.padding.bottom + layout.margin.bottom;
    }

    // If expands is true and maxHeight is finite, use the maximum available height
    // Otherwise, use the actual content height
    final height = _expands && constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : totalHeight;

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

    for (var i = 0; i < layouts.length; i++) {
      final layout = layouts[i];

      // layout.offset.dy points to where text content starts (after padding top)
      final blockOffset =
          offset + layout.offset + Offset(layout.padding.left, 0);

      // Draw block background if any
      final backgroundColor = layout.block.backgroundColor(this, controller);
      if (backgroundColor != null) {
        // Background should cover entire block including padding
        final blockRect = Rect.fromLTWH(
          offset.dx,
          offset.dy + layout.offset.dy - layout.padding.top,
          size.width,
          layout.height,
        );
        canvas.drawRect(
          blockRect,
          Paint()..color = backgroundColor,
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

          // Draw selection boxes as returned by TextPainter
          // This correctly handles text wrapping within the block
          for (final box in boxes) {
            final boxRect = box.toRect().shift(blockOffset);
            canvas.drawRect(boxRect, paint);
          }

          // Calculate handle positions at the selection start/end
          // Store positions in local coordinates (without offset)
          // Only show start handle if this block contains the actual start of the selection
          if (_selection.start >= blockStart && _selection.start < blockEnd) {
            // Start handle - use actual caret position including Y coordinate
            final startOffset = layout.painter.getOffsetForCaret(
              TextPosition(offset: localStart),
              Rect.zero,
            );
            _startHandlePosition =
                Offset(layout.padding.left, layout.offset.dy) + startOffset;
          }
          // Only show end handle if this block contains the actual end of the selection
          if (_selection.end > blockStart && _selection.end <= blockEnd) {
            // End handle - use actual caret position including Y coordinate
            final endOffset = layout.painter.getOffsetForCaret(
              TextPosition(offset: localEnd),
              Rect.zero,
            );
            _endHandlePosition =
                Offset(layout.padding.left, layout.offset.dy) + endOffset;
          }
        }
      }

      // Draw span background decorations
      // Merge adjacent spans with the same decoration type
      final decorationGroups = <_DecorationGroup>[];
      BoxDecoration? currentDecoration;
      int? groupStart;
      int? groupEnd;

      for (var i = 0; i < layout.spans.length; i++) {
        final spanInfo = layout.spans[i];
        final decoration =
            spanInfo.span.backgroundDecoration(this, _controller, null);

        // Check if this span has a code decoration
        final hasCodeDecoration = spanInfo.span.properties
            .any((p) => p.type == "__markdown_inline_font_code__");

        if (hasCodeDecoration && decoration != null) {
          if (currentDecoration == null) {
            // Start new group
            currentDecoration = decoration;
            groupStart = spanInfo.localOffset;
            groupEnd = spanInfo.localOffset + spanInfo.length;
          } else {
            // Extend current group
            groupEnd = spanInfo.localOffset + spanInfo.length;
          }
        } else {
          // End current group if exists
          if (currentDecoration != null &&
              groupStart != null &&
              groupEnd != null) {
            decorationGroups.add(_DecorationGroup(
              decoration: currentDecoration,
              start: groupStart,
              end: groupEnd,
            ));
            currentDecoration = null;
            groupStart = null;
            groupEnd = null;
          }
        }
      }

      // Add last group if exists
      if (currentDecoration != null && groupStart != null && groupEnd != null) {
        decorationGroups.add(_DecorationGroup(
          decoration: currentDecoration,
          start: groupStart,
          end: groupEnd,
        ));
      }

      // Draw merged decoration groups
      for (final group in decorationGroups) {
        final spanSelection = TextSelection(
          baseOffset: group.start,
          extentOffset: group.end,
        );
        final boxes = layout.painter.getBoxesForSelection(spanSelection);
        for (final box in boxes) {
          var boxRect = box.toRect().shift(blockOffset);
          // Add 2px padding
          boxRect = boxRect.inflate(2.0);
          final paint = Paint();
          if (group.decoration.color != null) {
            paint.color = group.decoration.color!;
          }
          if (group.decoration.borderRadius != null) {
            final rRect = (group.decoration.borderRadius as BorderRadius)
                .toRRect(boxRect);
            canvas.drawRRect(rRect, paint);
          } else {
            canvas.drawRect(boxRect, paint);
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
      // layout.offset.dy is where text content starts (after padding top)
      final blockOffset = layout.offset + Offset(layout.padding.left, 0);
      final blockBottom = blockOffset.dy + layout.painter.height;
      // Block top includes the padding area above the text
      final blockTop = layout.offset.dy - layout.padding.top;

      if (position.dy >= blockOffset.dy && position.dy <= blockBottom) {
        // Position is within this block's text area
        // TextPainter.getPositionForOffset handles text wrapping correctly
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

  String? _getLinkAtOffset(int targetOffset) {
    debugPrint("🔎 _getLinkAtOffset: targetOffset=$targetOffset");
    final controllerValue = _controller.value;
    if (controllerValue == null || controllerValue.isEmpty) {
      debugPrint("   → Controller value is null or empty");
      return null;
    }

    var currentOffset = 0;

    // Traverse through MarkdownFieldValue items
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      // Traverse through blocks in each MarkdownFieldValue
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        // Only handle paragraph blocks for now
        if (blockValue is MarkdownParagraphBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          debugPrint("   Paragraph block $blockIndex with ${lines.length} lines");
          // Traverse through lines
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            debugPrint("   Line $lineIndex (currentOffset=$currentOffset):");
            // Traverse through spans
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;
              debugPrint("      Span: '${span.value}' (start=$spanStart, end=$spanEnd, length=$spanLength)");

              // Check if target offset is within this span
              if (targetOffset >= spanStart && targetOffset < spanEnd) {
                debugPrint("      → Target offset $targetOffset is in this span");
                // Check if this span has a link property
                for (final property in span.properties) {
                  if (property is LinkFontMarkdownSpanProperty) {
                    debugPrint("      → Found link: ${property.link}");
                    return property.link;
                  }
                }
                // Found the span but no link property
                debugPrint("      → No link property in this span");
                return null;
              }

              currentOffset += spanLength;
            }

            // Add 1 for newline only if this is not the last line in the block
            if (lineIndex < lines.length - 1) {
              debugPrint("      Adding newline within block (currentOffset: $currentOffset -> ${currentOffset + 1})");
              currentOffset += 1;
            }
          }

          // Add 1 for newline after each paragraph block (except the last one)
          if (blockIndex < blocks.length - 1) {
            debugPrint("   Adding newline after block (currentOffset: $currentOffset -> ${currentOffset + 1})");
            currentOffset += 1;
          } else {
            debugPrint("   Last block, no newline added (currentOffset stays: $currentOffset)");
          }
        }
      }
    }

    debugPrint("   → No link found at targetOffset");
    return null;
  }

  /// Get the text range of a link at the given offset.
  ///
  /// 指定されたオフセットにあるリンクのテキスト範囲を取得します。
  TextRange? _getLinkRangeAtOffset(int targetOffset) {
    debugPrint("🔍 _getLinkRangeAtOffset: targetOffset=$targetOffset");
    final controllerValue = _controller.value;
    if (controllerValue == null || controllerValue.isEmpty) {
      return null;
    }

    var currentOffset = 0;
    String? targetLinkUrl;
    int? linkStart;
    int? linkEnd;

    // First pass: find the link URL at target offset
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownParagraphBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;

              // Check if target offset is within this span
              if (targetOffset >= spanStart && targetOffset < spanEnd) {
                // Check if this span has a link property
                for (final property in span.properties) {
                  if (property is LinkFontMarkdownSpanProperty) {
                    targetLinkUrl = property.link;
                    break;
                  }
                }
                if (targetLinkUrl != null) {
                  break;
                }
              }

              currentOffset += spanLength;
            }
            if (targetLinkUrl != null) {
              break;
            }
            // Add 1 for newline only if this is not the last line in the block
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          if (targetLinkUrl != null) {
            break;
          }
          // Add 1 for newline after each paragraph block (except the last one)
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
      if (targetLinkUrl != null) {
        break;
      }
    }

    // If no link found at target offset, return null
    if (targetLinkUrl == null) {
      return null;
    }

    // Second pass: find the full range of consecutive spans with the same link URL
    debugPrint("   🔍 Second pass: finding full range for link: $targetLinkUrl");
    currentOffset = 0;
    for (final fieldValue in controllerValue) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownParagraphBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          debugPrint("      Paragraph block $blockIndex with ${lines.length} lines");
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            debugPrint("      Line $lineIndex (currentOffset=$currentOffset):");
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;
              debugPrint("         Span: '${span.value}' (start=$spanStart, end=$spanEnd)");

              // Check if this span has the same link URL
              var hasTargetLink = false;
              for (final property in span.properties) {
                if (property is LinkFontMarkdownSpanProperty &&
                    property.link == targetLinkUrl) {
                  hasTargetLink = true;
                  break;
                }
              }

              if (hasTargetLink) {
                // Expand the link range
                linkStart ??= spanStart;
                // Don't include trailing newline in link range
                linkEnd = spanEnd;
                debugPrint("         → Has target link. linkStart=$linkStart, linkEnd=$linkEnd");
              } else if (linkStart != null) {
                // We've found the end of the consecutive link spans
                // But only return if we've already passed the target offset
                debugPrint("         → No target link. linkStart was $linkStart, currentOffset=$currentOffset, targetOffset=$targetOffset");
                if (currentOffset > targetOffset) {
                  debugPrint("         → Returning early: TextRange(start: $linkStart, end: $linkEnd)");
                  return TextRange(start: linkStart, end: linkEnd!);
                }
                // Reset for next potential link range
                linkStart = null;
                linkEnd = null;
              }

              currentOffset += spanLength;
            }
            // Add 1 for newline only if this is not the last line in the block
            if (lineIndex < lines.length - 1) {
              debugPrint("         Adding newline within block (currentOffset: $currentOffset -> ${currentOffset + 1})");
              currentOffset += 1;
            }
          }
          // Add 1 for newline after each paragraph block (except the last one)
          if (blockIndex < blocks.length - 1) {
            debugPrint("      Adding newline after block (currentOffset: $currentOffset -> ${currentOffset + 1})");
            currentOffset += 1;
          } else {
            debugPrint("      Last block, no newline added (currentOffset stays: $currentOffset)");
          }
        }
      }
    }

    // Return the range if we found one
    if (linkStart != null && linkEnd != null) {
      debugPrint("   → Found link range: start=$linkStart, end=$linkEnd");
      return TextRange(start: linkStart, end: linkEnd);
    }

    debugPrint("   → No link found at targetOffset");
    return null;
  }

  /// Launch URL in the default browser or appropriate application.
  ///
  /// URLをデフォルトのブラウザまたは適切なアプリケーションで開きます。
  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        debugPrint("Cannot launch URL: $url");
      }
    } catch (e) {
      debugPrint("Error launching URL: $e");
    }
  }

  void _handleTapUp(PointerUpEvent event) {
    debugPrint("📍 _handleTapUp called (controller.hashCode: ${_controller.hashCode})");

    _longPressTimer?.cancel();
    _longPressTimer = null;

    // Reset handle dragging flags
    if (_isDraggingStartHandle || _isDraggingEndHandle) {
      debugPrint("   → Skipping: handle dragging");
      _isDraggingStartHandle = false;
      _isDraggingEndHandle = false;
      return;
    }

    // If long press or double tap was detected, don't process as normal tap
    if (_longPressDetected || _doubleTapDetected) {
      debugPrint("   → Skipping: long press or double tap detected");
      _longPressDetected = false;
      _doubleTapDetected = false;
      return;
    }

    if (_lastTapDownPosition == null) {
      debugPrint("   → Skipping: no tap down position");
      return;
    }

    final position = globalToLocal(event.position);

    // Check if it's a drag (moved too far from tap down position)
    if ((position - _lastTapDownPosition!).distance > 10) {
      debugPrint("   → Skipping: drag detected (distance: ${(position - _lastTapDownPosition!).distance})");
      return;
    }

    final textOffset = _getTextOffsetForPosition(position);
    debugPrint("   textOffset=$textOffset");

    _onTap?.call();

    if (textOffset != null) {
      // Check if tapped on a link
      final linkUrl = _getLinkAtOffset(textOffset);
      if (linkUrl != null && linkUrl.isNotEmpty) {
        // Determine behavior based on enabled and readOnly state
        debugPrint(
            "🔗 Link tapped on field (controller.hashCode: ${_controller.hashCode})");
        debugPrint("   enabled=$_enabled, readOnly=$_readOnly");
        debugPrint("   focusNode.hasFocus=${_focusNode.hasFocus}");
        debugPrint("   url=$linkUrl");

        if (!_enabled || _readOnly) {
          // When disabled or read-only: open the link
          debugPrint(
              "   → Opening link because enabled=$_enabled or readOnly=$_readOnly");
          _launchUrl(linkUrl);
        } else {
          // When enabled and not read-only: select the link text and show dialog
          debugPrint("   → Showing link dialog");
          final linkRange = _getLinkRangeAtOffset(textOffset);
          if (linkRange != null) {
            // Prevent duplicate calls within 500ms
            final now = DateTime.now().millisecondsSinceEpoch;
            if (now - _lastLinkDialogShowTime < 500) {
              debugPrint("   → Skipping duplicate link dialog call (within 500ms)");
              return;
            }
            _lastLinkDialogShowTime = now;

            // Select the link text
            _onSelectionChanged(
              TextSelection(
                baseOffset: linkRange.start,
                extentOffset: linkRange.end,
              ),
              SelectionChangedCause.tap,
            );

            // Notify controller to show link dialog
            debugPrint("   → Calling controller.showLinkDialog");
            _controller.showLinkDialog(linkUrl);
          }
        }
        return;
      }

      // Tapped on text, set cursor position
      debugPrint("   → Setting cursor position at offset $textOffset");
      _onSelectionChanged(
        TextSelection.collapsed(offset: textOffset),
        SelectionChangedCause.tap,
      );
    } else {
      // Tapped on empty space (padding/margin), clear selection
      debugPrint("   → Clearing selection (tapped on empty space)");
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
      // Use _getPlainText() to include composing text during IME input
      final text = _getPlainText();

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
      // Use _getPlainText() to include composing text during IME input
      final text = _getPlainText();

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

    // Handle empty text or invalid offset
    if (text.isEmpty || offset < 0 || offset > text.length) {
      return TextRange.empty;
    }

    var start = offset;
    var end = offset;

    // Find start of word
    while (start > 0 &&
        start <= text.length &&
        !_isWordBoundary(text[start - 1])) {
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
    // If composing text exists, use it for display during IME conversion
    if (_composingText != null && _composingText!.isNotEmpty) {
      return _composingText!;
    }
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
    required this.spans,
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

  /// Spans with their local offsets and lengths.
  ///
  /// ローカルオフセットと長さを持つスパン。
  final List<_SpanInfo> spans;

  /// Offset where this block is positioned.
  ///
  /// このブロックが配置されるオフセット。
  Offset offset = Offset.zero;

  /// Height of this block including padding and margin.
  ///
  /// パディングとマージンを含むこのブロックの高さ。
  double height = 0;
}

/// Information about a span in a block.
///
/// ブロック内のスパンに関する情報。
class _SpanInfo {
  _SpanInfo({
    required this.span,
    required this.localOffset,
    required this.length,
  });

  /// The markdown span.
  ///
  /// マークダウンスパン。
  final MarkdownSpanValue span;

  /// Local offset within the block.
  ///
  /// ブロック内のローカルオフセット。
  final int localOffset;

  /// Length of the span text.
  ///
  /// スパンテキストの長さ。
  final int length;
}

/// Information about a merged decoration group.
///
/// マージされた装飾グループに関する情報。
class _DecorationGroup {
  _DecorationGroup({
    required this.decoration,
    required this.start,
    required this.end,
  });

  /// The background decoration.
  ///
  /// 背景装飾。
  final BoxDecoration decoration;

  /// Start offset of the group.
  ///
  /// グループの開始オフセット。
  final int start;

  /// End offset of the group.
  ///
  /// グループの終了オフセット。
  final int end;
}

/// Context for rendering.
///
/// レンダリングのコンテキスト。
abstract class RenderContext {
  /// Context for rendering.
  ///
  /// レンダリングのコンテキスト。
  const RenderContext();

  /// Focus node for the editor.
  ///
  /// エディタのフォーカスノード。
  FocusNode get focusNode;

  /// Selection for the editor.
  ///
  /// エディタの選択。
  TextSelection get selection;

  /// Composing region for the editor.
  ///
  /// エディタのコンポージングリージョン。
  TextSelection? get composingRegion;

  /// Whether to show the cursor.
  ///
  /// カーソルを表示するかどうか。
  bool get showCursor;

  /// Whether to expand the editor.
  ///
  /// エディタを展開するかどうか。
  bool get expands;

  /// Style for the editor.
  ///
  /// エディタのスタイル。
  TextStyle get style;

  /// Width of the cursor.
  ///
  /// カーソルの幅。
  double get cursorWidth;

  /// Height of the cursor.
  ///
  /// カーソルの高さ。
  double? get cursorHeight;

  /// Radius of the cursor.
  ///
  /// カーソルの半径。
  Radius? get cursorRadius;

  /// Color of the cursor.
  ///
  /// カーソルの色。
  Color get cursorColor;

  /// Color of the selection.
  ///
  /// 選択の色。
  Color get selectionColor;

  /// App theme of the editor.
  ///
  /// アプリのテーマ。
  ThemeData get theme;

  /// Alignment of the text.
  ///
  /// テキストの配置。
  TextAlign get textAlign;

  /// Direction of the text.
  ///
  /// テキストの方向。
  TextDirection get textDirection;

  /// Width basis of the text.
  ///
  /// テキストの幅の基準。
  TextWidthBasis get textWidthBasis;

  /// Height behavior of the text.
  ///
  /// テキストの高さの振る舞い。
  TextHeightBehavior? get textHeightBehavior;

  /// Strut style of the text.
  ///
  /// テキストのストライドスタイル。
  StrutStyle? get strutStyle;
}
