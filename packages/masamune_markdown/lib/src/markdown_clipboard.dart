part of "/masamune_markdown.dart";

/// Controller for clipboard.
///
/// クリップボードのコントローラー。
class MarkdownClipboard {
  MarkdownClipboard._(this._controller);

  final MarkdownController _controller;

  MarkdownFieldState? get _field => _controller._field;

  /// Internal clipboard storage for preserving span properties and block information.
  ///
  /// スパンのプロパティとブロック情報を保持するための内部クリップボードストレージ。
  _ClipboardData? _internalClipboard;

  /// Copies the selected text to clipboard.
  ///
  /// 選択されたテキストをクリップボードにコピーします。
  Future<void> copy() async {
    final field = _field;
    if (field == null) {
      return;
    }

    final selection = field._selection;

    if (!selection.isValid || selection.isCollapsed) {
      return;
    }

    // Get text including composing text during IME input
    final text = field.composingText ?? _controller.getPlainText();

    // Validate selection range
    if (selection.end > text.length) {
      return;
    }

    final selectedText = selection.textInside(text);

    if (selectedText.isNotEmpty) {
      // Extract spans with their properties
      final extractedSpans = _controller._extractSpansFromSelection(
          selection.start, selection.end);

      // Check if entire block is selected
      final blockInfo =
          _controller._isFullBlockSelected(selection.start, selection.end);
      final blockType =
          (blockInfo?.isFullBlock ?? false) ? blockInfo?.blockType : null;

      // Store in internal clipboard with block information
      _internalClipboard = _ClipboardData(
        spans: extractedSpans,
        blockType: blockType,
      );

      // Also copy plain text to system clipboard for external paste
      await Clipboard.setData(ClipboardData(text: selectedText));

      // Unselect text after copying
      field._selection = TextSelection.collapsed(offset: selection.end);
      field._updateRemoteEditingValue();
      _controller._notifyListeners();
    }
  }

  /// Cuts the selected text to clipboard and removes it.
  ///
  /// 選択されたテキストをクリップボードに切り取り、削除します。
  Future<void> cut() async {
    final field = _field;
    if (field == null) {
      return;
    }

    // If there's composing text, commit it first before cutting
    if (field.composingText != null) {
      final composingText = field.composingText!;
      final currentText = _controller.getPlainText();

      // Commit the composing text to controller
      _controller.replaceText(0, currentText.length, composingText);

      // Clear composing state
      field._composingText = null;
      field._composingRegion = null;

      // Keep the current selection
      field._updateRemoteEditingValue();
    }

    final selection = field._selection;

    if (!selection.isValid || selection.isCollapsed) {
      return;
    }

    // Get text including composing text during IME input
    final text = field.composingText ?? _controller.getPlainText();

    // Validate selection range
    if (selection.end > text.length) {
      return;
    }

    final selectedText = selection.textInside(text);

    if (selectedText.isNotEmpty) {
      // Extract spans with their properties
      // IMPORTANT: Must be done BEFORE replaceText, as replaceText may merge spans
      final extractedSpans = _controller._extractSpansFromSelection(
          selection.start, selection.end);

      // Check if entire block is selected
      final blockInfo =
          _controller._isFullBlockSelected(selection.start, selection.end);
      final blockType =
          (blockInfo?.isFullBlock ?? false) ? blockInfo?.blockType : null;

      // Store in internal clipboard with block information
      _internalClipboard = _ClipboardData(
        spans: extractedSpans,
        blockType: blockType,
      );

      // Also copy plain text to system clipboard for external paste
      await Clipboard.setData(ClipboardData(text: selectedText));

      // Save current state before modification (replaceText will also save, so we skip it here)
      // Delete the selected text
      _controller.replaceText(selection.start, selection.end, "");

      // Update selection to collapsed at start position
      field._selection = TextSelection.collapsed(offset: selection.start);
      field._updateRemoteEditingValue();
    }
  }

  /// Pastes text from clipboard at the cursor position.
  ///
  /// クリップボードからカーソル位置にテキストをペーストします。
  Future<void> paste() async {
    final field = _field;
    if (field == null) {
      return;
    }

    // If there's composing text, just clear it
    // The text is already in the controller, no need to replace
    if (field.composingText != null) {
      debugPrint("  Clearing composing state before paste");
      // Clear composing state
      field._composingText = null;
      field._composingRegion = null;

      // Keep the current selection
      field._updateRemoteEditingValue();
    }

    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

    if (clipboardData == null || clipboardData.text == null) {
      debugPrint("  No clipboard data");
      return;
    }

    final text = clipboardData.text!;
    if (text.isEmpty) {
      return;
    }

    final selection = field._selection;
    if (!selection.isValid) {
      return;
    }

    // If there's a selection, replace it with pasted text
    // If cursor is collapsed, insert at cursor position
    final start = selection.start;
    final end = selection.end;

    // Check if the pasted text contains newlines
    if (text.contains("\n")) {
      // Split by newlines and insert them one by one
      final lines = text.split("\n");

      // First, delete the selected text if any
      if (end > start) {
        _controller.replaceText(start, end, "");
      }

      var currentOffset = start;

      // Insert first line at the cursor position
      if (lines.isNotEmpty && lines.first.isNotEmpty) {
        _controller.replaceText(currentOffset, currentOffset, lines.first);
        currentOffset += lines.first.length;
      }

      // For each additional line, insert a new paragraph
      for (var i = 1; i < lines.length; i++) {
        _controller.insertNewLine(currentOffset);
        currentOffset++; // Account for the newline character

        if (lines[i].isNotEmpty) {
          _controller.replaceText(currentOffset, currentOffset, lines[i]);
          currentOffset += lines[i].length;
        }
      }

      // Update cursor position to the end of pasted text
      field._selection = TextSelection.collapsed(offset: currentOffset);
    } else {
      // Normal text paste without newlines
      // Check if we have internal clipboard data with properties
      if (_internalClipboard != null && _internalClipboard!.spans.isNotEmpty) {
        // If clipboard has block type information, create a new block
        if (_internalClipboard!.blockType != null) {
          _pasteAsBlock(start, end, _internalClipboard!.spans,
              _internalClipboard!.blockType!);
        } else {
          // Restore spans with their properties (partial selection)
          _pasteSpansWithProperties(start, end, _internalClipboard!.spans);
        }
      } else {
        // Plain text paste (from external clipboard or no properties)
        _controller.replaceText(start, end, text);
      }

      // Update cursor position to the end of pasted text
      final newCursorPosition = start + text.length;
      field._selection = TextSelection.collapsed(offset: newCursorPosition);
    }

    _field!._updateRemoteEditingValue();
    _controller._notifyListeners();
  }

  /// Pastes spans with their properties at the specified position.
  ///
  /// 指定された位置にプロパティ付きのスパンをペーストします。
  void _pasteSpansWithProperties(
    int start,
    int end,
    List<MarkdownSpanValue> spans,
  ) {
    if (_controller._value.isEmpty) {
      return;
    }

    // Save current state before modification
    _controller.history.saveToUndoStack(immediate: true);

    final field = _controller._value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Find which block contains the start position
    var currentOffset = 0;
    var targetBlockIndex = -1;
    var targetLineIndex = -1;
    var targetSpanIndex = -1;
    var offsetInSpan = 0;

    for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
      final block = blocks[blockIndex];
      if (block is MarkdownParagraphBlockValue) {
        final lines = List<MarkdownLineValue>.from(block.children);

        for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
          final line = lines[lineIndex];
          var lineOffset = currentOffset;

          for (var spanIndex = 0;
              spanIndex < line.children.length;
              spanIndex++) {
            final span = line.children[spanIndex];
            final spanStart = lineOffset;
            final spanEnd = lineOffset + span.value.length;

            if (start >= spanStart && start <= spanEnd) {
              targetBlockIndex = blockIndex;
              targetLineIndex = lineIndex;
              targetSpanIndex = spanIndex;
              offsetInSpan = start - spanStart;
              break;
            }

            lineOffset += span.value.length;
          }

          if (targetBlockIndex >= 0) {
            break;
          }
        }

        if (targetBlockIndex >= 0) {
          break;
        }
        currentOffset += _controller._getBlockTextLength(block) + 1;
      }
    }

    if (targetBlockIndex < 0) {
      debugPrint("  Could not find target position for paste");
      return;
    }

    final block = blocks[targetBlockIndex] as MarkdownParagraphBlockValue;
    final lines = List<MarkdownLineValue>.from(block.children);
    final line = lines[targetLineIndex];
    final lineSpans = List<MarkdownSpanValue>.from(line.children);
    final targetSpan = lineSpans[targetSpanIndex];

    // Delete selected text if any
    if (end > start) {
      _controller.replaceText(start, end, "");
      // Need to recalculate position after deletion
      // For simplicity, we'll just insert at start
    }

    // Split the target span at the insertion point
    final beforeText = targetSpan.value.substring(0, offsetInSpan);
    final afterText = targetSpan.value.substring(offsetInSpan);

    // Build new spans list
    final newSpans = <MarkdownSpanValue>[];

    // Add spans before the target
    newSpans.addAll(lineSpans.take(targetSpanIndex));

    // Add the "before" part of the split span
    if (beforeText.isNotEmpty) {
      newSpans.add(targetSpan.copyWith(
        id: uuid(),
        value: beforeText,
      ));
    }

    // Add the pasted spans
    newSpans.addAll(spans);

    // Add the "after" part of the split span
    if (afterText.isNotEmpty) {
      newSpans.add(targetSpan.copyWith(
        id: uuid(),
        value: afterText,
      ));
    }

    // Add remaining spans after the target
    if (targetSpanIndex + 1 < lineSpans.length) {
      newSpans.addAll(lineSpans.skip(targetSpanIndex + 1));
    }

    // Update the line with new spans
    lines[targetLineIndex] = line.copyWith(children: newSpans);
    blocks[targetBlockIndex] = block.copyWith(children: lines);

    final newField = field.copyWith(children: blocks);
    _controller._value[0] = newField;
    _controller._notifyListeners();
  }

  /// Pastes spans as a new block with the specified block type.
  ///
  /// 指定されたブロックタイプで新しいブロックとしてスパンをペーストします。
  void _pasteAsBlock(
    int start,
    int end,
    List<MarkdownSpanValue> spans,
    String blockType,
  ) {
    if (_controller._value.isEmpty) {
      return;
    }

    // Save current state before modification
    _controller.history.saveToUndoStack(immediate: true);

    final field = _controller._value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Delete selected text if any
    if (end > start) {
      _controller.replaceText(start, end, "");
    }

    // Find the block index where we should insert the new block
    var currentOffset = 0;
    var insertAtBlockIndex = 0;

    for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
      final block = blocks[blockIndex];
      final blockLength = _controller._getBlockTextLength(block);
      final blockEnd = currentOffset + blockLength;

      if (start <= blockEnd) {
        insertAtBlockIndex = blockIndex + 1;
        break;
      }

      currentOffset = blockEnd + 1; // +1 for newline
    }

    // Create a new line with the pasted spans
    final newLine = MarkdownLineValue(
      id: uuid(),
      children: spans,
    );

    // Create a new block based on the block type
    final MarkdownBlockValue newBlock;
    if (blockType == "__markdown_block_bulleted_list__") {
      newBlock = MarkdownBulletedListBlockValue(
        id: uuid(),
        children: [newLine],
      );
    } else if (blockType == "__markdown_block_paragraph__") {
      newBlock = MarkdownParagraphBlockValue(
        id: uuid(),
        children: [newLine],
      );
    } else {
      // Default to paragraph for unknown types
      newBlock = MarkdownParagraphBlockValue(
        id: uuid(),
        children: [newLine],
      );
    }

    // Insert the new block
    blocks.insert(insertAtBlockIndex, newBlock);

    final newField = field.copyWith(children: blocks);
    _controller._value[0] = newField;
    _controller._notifyListeners();
  }
}

/// Represents clipboard data with block information.
///
/// ブロック情報を含むクリップボードデータ。
class _ClipboardData {
  const _ClipboardData({
    required this.spans,
    this.blockType,
  });

  /// The spans that were copied.
  ///
  /// コピーされたスパン。
  final List<MarkdownSpanValue> spans;

  /// The type of block if entire block was selected, null otherwise.
  ///
  /// ブロック全体が選択された場合のブロックタイプ、それ以外はnull。
  final String? blockType;
}
