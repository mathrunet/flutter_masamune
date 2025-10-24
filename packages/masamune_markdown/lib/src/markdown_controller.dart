part of "/masamune_markdown.dart";

/// Controller for [FormMarkdownField].
///
/// By passing this, you can integrate with [FormMarkdownToolbar] tools.
///
/// Also, you can control multiple [FormMarkdownField] instances with a single [FormMarkdownToolbar] tool.
///
/// [FormMarkdownField]用のコントローラー。
///
/// これを渡すことで[FormMarkdownToolbar]のツールと連携することができます。
///
/// また、複数の[FormMarkdownField]を一つの[FormMarkdownToolbar]のツールでコントロールすることができます。
class MarkdownController extends MasamuneControllerBase<
    List<MarkdownFieldValue>, MarkdownMasamuneAdapter> {
  /// Controller for [FormMarkdownField].
  ///
  /// By passing this, you can integrate with [FormMarkdownToolbar] tools.
  ///
  /// Also, you can control multiple [FormMarkdownField] instances with a single [FormMarkdownToolbar] tool.
  ///
  /// [FormMarkdownField]用のコントローラー。
  ///
  /// これを渡すことで[FormMarkdownToolbar]のツールと連携することができます。
  ///
  /// また、複数の[FormMarkdownField]を一つの[FormMarkdownToolbar]のツールでコントロールすることができます。
  MarkdownController({super.adapter});

  /// Query for MarkdownController.
  ///
  /// ```dart
  /// appRef.controller(MarkdownController.query(parameters));     // Get from application scope.
  /// ref.app.controller(MarkdownController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(MarkdownController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$MarkdownControllerQuery();

  @override
  MarkdownMasamuneAdapter get primaryAdapter => MarkdownMasamuneAdapter.primary;

  @override
  List<MarkdownFieldValue>? get value => _value;

  final List<MarkdownFieldValue> _value = [];

  /// History of clipboard of [MarkdownController].
  ///
  /// [MarkdownController]のクリップボード履歴。
  late final MarkdownClipboard clipboard = MarkdownClipboard._(this);

  /// History of [MarkdownController].
  ///
  /// [MarkdownController]の履歴。
  late final MarkdownHistory history = MarkdownHistory._(this);

  /// Default style for markdown.
  ///
  /// マークダウンのデフォルトのスタイル。
  MarkdownStyle get style => adapter.defaultStyle;

  /// This is used to control the focus of the markdown controller.
  ///
  /// これは、markdownコントローラーのフォーカスを制御するために使用されます。
  final FocusNode focusNode = FocusNode();

  void _registerField(MarkdownFieldState state) {
    _field = state;
  }

  void _unregisterField(MarkdownFieldState state) {
    _field = null;
  }

  MarkdownFieldState? _field;

  /// Replaces text in the specified range.
  ///
  /// 指定された範囲のテキストを置換します。
  void replaceText(int start, int end, String text,
      {bool skipHistory = false}) {
    // Early return if this is a no-op replacement (same text at same position)
    // This prevents unnecessary span merging during selection operations
    if (start == 0 && _value.isNotEmpty) {
      final currentText = getPlainText();
      if (end == currentText.length && text == currentText) {
        return;
      }
    }

    // Skip history saving during undo/redo operations or when explicitly requested
    if (!history.inProgress && !skipHistory) {
      // Save current state before modification
      // For single character insertion/deletion, save immediately for fine-grained undo
      final isSingleCharEdit = text.length <= 1 && (end - start) <= 1;

      if (history.undoStack.isEmpty) {
        // First edit - save initial empty/current state immediately BEFORE modification
        history.saveToUndoStack(immediate: true);
      } else if (isSingleCharEdit) {
        // Single character edit - save immediately for fine-grained undo BEFORE modification
        history.saveToUndoStack(immediate: true);
      } else {
        // Multi-character edit (e.g., paste, cut) - save immediately to ensure it's captured
        history.saveToUndoStack(immediate: true);
      }
    }
    // Ensure we have a valid structure
    if (_value.isEmpty) {
      // Create initial structure
      final field = MarkdownFieldValue.createEmpty(text);
      _value.clear();
      _value.add(field);
      notifyListeners();
      return;
    }

    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Find which blocks contain the start and end positions
    var currentOffset = 0;
    int? startBlockIndex;
    int? endBlockIndex;
    int? endBlockStart;
    var localStart = 0;
    var localEnd = 0;

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      if (block is MarkdownMultiLineBlockValue ||
          block is MarkdownSingleLineBlockValue) {
        final blockText = StringBuffer();
        final blockChildren = block.extractLines() ?? [];

        for (var j = 0; j < blockChildren.length; j++) {
          final line = blockChildren[j];
          for (final span in line.children) {
            blockText.write(span.value);
          }
          if (j < blockChildren.length - 1) {
            blockText.writeln();
          }
        }

        final blockLength = blockText.toString().length;
        final blockStart = currentOffset;
        final blockEnd = currentOffset + blockLength;

        // Check if this block contains the start position
        if (startBlockIndex == null && blockEnd >= start) {
          startBlockIndex = i;
          localStart = start - blockStart;
        }

        // Check if this block contains the end position
        if (blockEnd >= end) {
          endBlockIndex = i;
          endBlockStart = blockStart;
          localEnd = end - blockStart;
          break;
        }

        currentOffset += blockLength + 1; // +1 for newline between blocks
      }
    }

    if (startBlockIndex == null) {
      if (blocks.isEmpty) {
        startBlockIndex = 0;
        localStart = 0;
      } else {
        startBlockIndex = blocks.length - 1;
        localStart = 0;
      }
    }
    if (endBlockIndex == null || endBlockStart == null) {
      if (blocks.isEmpty) {
        endBlockIndex = 0;
        localEnd = 0;
      } else {
        endBlockIndex = blocks.length - 1;
        final lastBlock = blocks[endBlockIndex];
        final lastBlockText = StringBuffer();

        final lastBlockChildren = lastBlock.extractLines() ?? [];

        for (final line in lastBlockChildren) {
          for (final span in line.children) {
            lastBlockText.write(span.value);
          }
        }
        localEnd = lastBlockText.length;
      }
    }

    // If blocks is empty, create a new block with the text
    if (blocks.isEmpty) {
      final newBlock = MarkdownBlockValue.createEmpty(text);
      blocks.add(newBlock);

      final newField = MarkdownFieldValue(
        id: field.id,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // If selection spans multiple blocks, merge them
    if (startBlockIndex != endBlockIndex) {
      // Get text before start in start block
      final startBlock = blocks[startBlockIndex];
      final startBlockText = StringBuffer();

      // Extract children based on block type
      final startBlockChildren = startBlock.extractLines() ?? [];

      for (final line in startBlockChildren) {
        for (final span in line.children) {
          startBlockText.write(span.value);
        }
      }
      final startBlockTextStr = startBlockText.toString();
      final safeLocalStart = localStart.clamp(0, startBlockTextStr.length);
      final textBeforeStart = startBlockTextStr.substring(0, safeLocalStart);

      // Get text after end in end block
      final endBlock = blocks[endBlockIndex];
      final endBlockText = StringBuffer();

      // Extract children based on block type
      final endBlockChildren = endBlock.extractLines() ?? [];

      for (final line in endBlockChildren) {
        for (final span in line.children) {
          endBlockText.write(span.value);
        }
      }
      final endBlockTextStr = endBlockText.toString();
      final safeLocalEnd = localEnd.clamp(0, endBlockTextStr.length);
      final textAfterEnd = endBlockTextStr.substring(safeLocalEnd);

      // Calculate what the merged text would be
      final potentialMergedText = textBeforeStart + text + textAfterEnd;

      // Get the original text across both blocks for comparison
      final originalText = StringBuffer();
      for (var i = startBlockIndex; i <= endBlockIndex; i++) {
        final block = blocks[i];

        // Extract children based on block type
        final blockChildren = block.extractLines() ?? [];

        for (final line in blockChildren) {
          for (final span in line.children) {
            originalText.write(span.value);
          }
        }
        if (i < endBlockIndex) {
          originalText.write("\n"); // Add newline between blocks
        }
      }
      final originalTextStr = originalText.toString();

      // If the operation would result in the same text, don't merge blocks
      // This happens when selection handles are dragged without actually changing text
      if (potentialMergedText == originalTextStr) {
        notifyListeners();
        return;
      }

      // Check if we should keep blocks separate or merge them
      // Keep separate if: deletion AND both blocks have content remaining
      final shouldKeepSeparate =
          text.isEmpty && textBeforeStart.isNotEmpty && textAfterEnd.isNotEmpty;

      if (shouldKeepSeparate) {
        // Update first block with text before start, preserving block type
        final updatedFirstBlock =
            startBlock.clone(initialText: textBeforeStart);

        // Update last block with text after end, preserving block type
        final updatedLastBlock = endBlock.clone(initialText: textAfterEnd);

        // Remove all blocks in the range
        blocks.removeRange(startBlockIndex, endBlockIndex + 1);

        // Insert updated blocks
        blocks.insert(startBlockIndex, updatedLastBlock);
        blocks.insert(startBlockIndex, updatedFirstBlock);

        final newField = MarkdownFieldValue(
          id: field.id,
          children: blocks,
        );

        _value[0] = newField;
        notifyListeners();
        return;
      }

      // Merge: text before start + inserted text + text after end
      var mergedText = textBeforeStart + text + textAfterEnd;

      // If we're deleting (text is empty) and the merged text ends with a newline,
      // and there's no text after the end (we deleted everything after the newline),
      // remove the trailing newline
      if (text.isEmpty &&
          textAfterEnd.isEmpty &&
          mergedText.endsWith("\n") &&
          mergedText.isNotEmpty) {
        mergedText = mergedText.substring(0, mergedText.length - 1);
      }

      // If merged text is empty, just remove the blocks without creating a new one
      if (mergedText.isEmpty && text.isEmpty) {
        // Remove blocks from startBlockIndex to endBlockIndex (inclusive)
        blocks.removeRange(startBlockIndex, endBlockIndex + 1);

        // If all blocks were removed, create an empty block
        if (blocks.isEmpty) {
          blocks.add(MarkdownBlockValue.createEmpty());
        }
      } else {
        // Create new merged block, preserving the type of the first block
        final mergedBlock = startBlock.clone(initialText: mergedText);

        // Remove blocks from startBlockIndex to endBlockIndex (inclusive)
        blocks.removeRange(startBlockIndex, endBlockIndex + 1);

        // Insert merged block at startBlockIndex
        blocks.insert(startBlockIndex, mergedBlock);
      }

      // Update field
      final newField = MarkdownFieldValue(
        id: field.id,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // Single block edit
    final targetBlockIndex = startBlockIndex;

    // Update the target block
    final targetBlock = blocks[targetBlockIndex];

    // Get children based on block type
    if (targetBlock is! MarkdownMultiLineBlockValue &&
        targetBlock is! MarkdownSingleLineBlockValue) {
      notifyListeners();
      return;
    }
    final targetBlockChildren = targetBlock.extractLines() ?? [];

    // Get current text in the block
    final blockText = StringBuffer();
    for (var i = 0; i < targetBlockChildren.length; i++) {
      final line = targetBlockChildren[i];
      for (final span in line.children) {
        blockText.write(span.value);
      }
      if (i < targetBlockChildren.length - 1) {
        blockText.writeln();
      }
    }

    final oldText = blockText.toString();

    // Ensure indices are within bounds
    final safeStart = localStart.clamp(0, oldText.length);
    final safeEnd = localEnd.clamp(0, oldText.length);

    // Check if backspace at the beginning of an empty or near-empty block
    if (safeStart == 0 &&
        safeEnd == 0 &&
        text.isEmpty &&
        targetBlockIndex > 0 &&
        oldText.isEmpty) {
      // Delete the current empty block and merge with previous block
      blocks.removeAt(targetBlockIndex);

      // Update field
      final newField = MarkdownFieldValue(
        id: field.id,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // Create new text
    var newText =
        oldText.substring(0, safeStart) + text + oldText.substring(safeEnd);

    // Check if we need to remove a trailing newline
    var removedTrailingNewline = false;
    if (text.isEmpty && newText.endsWith("\n") && newText.isNotEmpty) {
      newText = newText.substring(0, newText.length - 1);
      removedTrailingNewline = true;
    }

    // If we removed a trailing newline, create a simple span with the new text
    // and skip the complex span merging logic (which would add the newline back)
    if (removedTrailingNewline) {
      final MarkdownBlockValue newBlock = targetBlock.clone(
        child: MarkdownLineValue(
          id: targetBlockChildren.isNotEmpty
              ? targetBlockChildren.first.id
              : uuid(),
          children: [
            MarkdownSpanValue(
              id: uuid(),
              value: newText,
              properties: const [],
            ),
          ],
        ),
      );

      blocks[targetBlockIndex] = newBlock;

      final newField = MarkdownFieldValue(
        id: field.id,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // Collect existing spans with their properties
    final existingSpans = <MarkdownSpanValue>[];
    for (final line in targetBlockChildren) {
      existingSpans.addAll(line.children);
    }

    // Build new spans based on text changes
    final newSpans = <MarkdownSpanValue>[];
    var currentPos = 0;

    // Process existing spans and split them if necessary
    for (final span in existingSpans) {
      // Skip empty spans - they should be removed
      if (span.value.isEmpty) {
        continue;
      }

      final spanStart = currentPos;
      final spanEnd = currentPos + span.value.length;

      // Check if this span is affected by the replacement
      if (safeEnd < spanStart) {
        newSpans.add(span);
      } else if (safeStart >= spanEnd) {
        newSpans.add(span);

        // If we're inserting at the end of this span, add the new text after it
        if (safeStart == spanEnd && text.isNotEmpty) {
          newSpans.add(MarkdownSpanValue(
            id: uuid(),
            value: text,
          ));
        }
      } else if (safeStart == safeEnd &&
          safeStart == spanStart &&
          text.isNotEmpty) {
        newSpans.add(MarkdownSpanValue(
          id: uuid(),
          value: text,
        ));
        newSpans.add(span);
      } else {
        if (spanStart < safeStart) {
          final beforeText = span.value.substring(0, safeStart - spanStart);
          newSpans.add(span.copyWith(
            id: uuid(),
            value: beforeText,
          ));
        }

        // Replacement text (without properties from original span)
        if (text.isNotEmpty && safeStart >= spanStart && safeStart < spanEnd) {
          newSpans.add(MarkdownSpanValue(
            id: uuid(),
            value: text,
          ));
        }

        // After replacement (if any)
        if (spanEnd > safeEnd) {
          final afterText = span.value.substring(safeEnd - spanStart);
          newSpans.add(span.copyWith(
            id: uuid(),
            value: afterText,
          ));
        }
      }

      currentPos += span.value.length;
    }

    // If replacement is at the end or in an empty block, add the text without properties
    if (newSpans.isEmpty && text.isNotEmpty) {
      newSpans.add(MarkdownSpanValue(
        id: uuid(),
        value: text,
      ));
    }

    // Merge consecutive spans with the same properties
    final mergedSpans = _mergeSpans(newSpans);

    // Ensure we have at least one span
    final finalSpans = mergedSpans.isNotEmpty
        ? mergedSpans
        : [
            MarkdownSpanValue(
              id: uuid(),
              value: newText,
            )
          ];

    // Create updated block with new spans
    final MarkdownBlockValue newBlock = targetBlock.clone(
      child: MarkdownLineValue(
        id: targetBlockChildren.isNotEmpty
            ? targetBlockChildren.first.id
            : uuid(),
        children: finalSpans,
      ),
    );

    // Update blocks list
    blocks[targetBlockIndex] = newBlock;

    // Update field
    final newField = MarkdownFieldValue(
      id: field.id,
      children: blocks,
    );

    _value[0] = newField;
    notifyListeners();
  }

  /// Checks if the block can be increased indent.
  ///
  /// ブロックがインデントを増やすことができるかどうかを確認します。
  bool get canIncreaseIndent {
    if (_field == null) {
      return false;
    }

    final selection = _field!._selection;
    if (!selection.isValid) {
      return false;
    }

    if (_value.isEmpty) {
      return false;
    }

    final field = _value.first;
    final blocks = field.children;

    if (blocks.isEmpty) {
      return false;
    }

    // Find which blocks are selected
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);
    if (selectedBlocks.isEmpty) {
      return false;
    }

    // Check if any selected block can increase indent (max indent is 5)
    for (final blockIndex in selectedBlocks) {
      if (blockIndex >= blocks.length) {
        continue;
      }
      final block = blocks[blockIndex];
      if (block.indent < 5) {
        return true;
      }
    }
    return false;
  }

  /// Checks if the block can be decreased indent.
  ///
  /// ブロックがインデントを減らすことができるかどうかを確認します。
  bool get canDecreaseIndent {
    if (_field == null) {
      return false;
    }

    final selection = _field!._selection;
    if (!selection.isValid) {
      return false;
    }

    if (_value.isEmpty) {
      return false;
    }

    final field = _value.first;
    final blocks = field.children;

    if (blocks.isEmpty) {
      return false;
    }

    // Find which blocks are selected
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);
    if (selectedBlocks.isEmpty) {
      return false;
    }

    // Check if any selected block can decrease indent (min indent is 0)
    for (final blockIndex in selectedBlocks) {
      if (blockIndex >= blocks.length) {
        continue;
      }
      final block = blocks[blockIndex];
      if (block.indent > 0) {
        return true;
      }
    }

    return false;
  }

  /// Increases the indent of the block.
  ///
  /// ブロックのインデントを増やします。
  void increaseIndent() {
    if (!canIncreaseIndent) {
      return;
    }

    // Save current state before modification
    history.saveToUndoStack(immediate: true);

    final selection = _field!._selection;
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Find which blocks are selected
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);

    // Increase indent for all selected blocks
    for (final blockIndex in selectedBlocks) {
      if (blockIndex < blocks.length) {
        final block = blocks[blockIndex];
        if (block.indent < 5 && block.canIndent) {
          blocks[blockIndex] = block.copyWith(indent: block.indent + 1);
        }
      }
    }

    // Update the field
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    notifyListeners();
  }

  /// Decreases the indent of the block.
  ///
  /// ブロックのインデントを減らします。
  void decreaseIndent() {
    if (!canDecreaseIndent) {
      return;
    }

    // Save current state before modification
    history.saveToUndoStack(immediate: true);

    final selection = _field!._selection;
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Find which blocks are selected
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);

    // Decrease indent for all selected blocks
    for (final blockIndex in selectedBlocks) {
      if (blockIndex < blocks.length) {
        final block = blocks[blockIndex];
        if (block.indent > 0 && block.canIndent) {
          blocks[blockIndex] = block.copyWith(indent: block.indent - 1);
        }
      }
    }

    // Update the field
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    notifyListeners();
  }

  /// Inserts a block at the specified offset.
  ///
  /// 指定されたオフセット位置にブロックを挿入します。
  void insertBlock(MarkdownBlockTools tool, {int? offset}) {
    if (_field == null) {
      return;
    }

    // Save current state before modification
    if (!history.inProgress) {
      history.saveToUndoStack(immediate: true);
    }

    // Ensure we have a valid structure
    if (_value.isEmpty) {
      _value.add(MarkdownFieldValue(
        id: uuid(),
        children: const [],
      ));
    }

    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Determine insertion position
    int insertionIndex;
    if (offset != null) {
      // Find block index from offset
      var currentOffset = 0;
      insertionIndex = blocks.length; // Default to end

      for (var i = 0; i < blocks.length; i++) {
        final block = blocks[i];
        final blockLength = _getBlockTextLength(block);
        final blockEnd = currentOffset + blockLength;

        if (offset >= currentOffset && offset <= blockEnd) {
          insertionIndex = i + 1; // Insert after this block
          break;
        }

        currentOffset = blockEnd + 1; // +1 for newline between blocks
      }
    } else {
      // Use cursor position
      final selection = _field!._selection;
      final cursorPosition = selection.baseOffset;

      var currentOffset = 0;
      insertionIndex = blocks.length; // Default to end

      for (var i = 0; i < blocks.length; i++) {
        final block = blocks[i];
        final blockLength = _getBlockTextLength(block);
        final blockEnd = currentOffset + blockLength;

        if (cursorPosition >= currentOffset && cursorPosition <= blockEnd) {
          insertionIndex = i + 1; // Insert after current block
          break;
        }

        currentOffset = blockEnd + 1; // +1 for newline between blocks
      }
    }

    // Create new block based on tool type
    final newBlock = tool.addBlock();
    blocks.insert(insertionIndex, newBlock);

    // Update field
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    // Move cursor to the beginning of the new block (inside the block, not before it)
    if (_field != null) {
      var newCursorPosition = 0;
      // Calculate position up to (but not including) the new block
      for (var i = 0; i < insertionIndex; i++) {
        newCursorPosition +=
            _getBlockTextLength(blocks[i]) + 1; // +1 for newline
      }

      _field!._selection = TextSelection.collapsed(offset: newCursorPosition);
    }

    // Notify listeners first to update UI state
    notifyListeners();

    _field?.reopenInputConnection();
  }

  /// Exchanges a block at the specified index.
  ///
  /// 指定されたインデックスのブロックを交換します。
  void exchangeBlock(MarkdownBlockTools tool, {int? index}) {
    if (_field == null) {
      return;
    }

    // Save current state before modification
    if (!history.inProgress) {
      history.saveToUndoStack(immediate: true);
    }

    if (_value.isEmpty) {
      return;
    }

    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    if (blocks.isEmpty) {
      return;
    }

    // Find block index from cursor position or use provided index
    int targetBlockIndex;
    if (index != null) {
      targetBlockIndex = index;
    } else {
      final selection = _field!._selection;
      final cursorPosition = selection.baseOffset;

      // Find which block contains the cursor
      var currentOffset = 0;
      targetBlockIndex = 0;

      for (var i = 0; i < blocks.length; i++) {
        final block = blocks[i];
        final blockLength = _getBlockTextLength(block);
        final blockEnd = currentOffset + blockLength;

        if (cursorPosition >= currentOffset && cursorPosition <= blockEnd) {
          targetBlockIndex = i;
          break;
        }

        currentOffset = blockEnd + 1; // +1 for newline between blocks
      }
    }

    if (targetBlockIndex >= blocks.length) {
      return;
    }

    final targetBlock = blocks[targetBlockIndex];

    // Convert block based on tool type
    final newBlock = tool.exchangeBlock(targetBlock);

    if (newBlock == null) {
      return;
    }

    // Replace the block
    blocks[targetBlockIndex] = newBlock;

    // Update field
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    notifyListeners();
  }

  /// Changes the inline text at the specified start and end positions.
  ///
  /// 指定された開始位置と終了位置のインラインテキストを変更します。
  void addInlineProperty(
    MarkdownPropertyTools tool, {
    int? start,
    int? end,
    Object? value,
    bool skipHistory = false,
  }) {
    if (_field == null) {
      return;
    }

    // Save current state before modification
    if (!history.inProgress && !skipHistory) {
      history.saveToUndoStack(immediate: true);
    }

    // If there's composing text, just clear it
    // The text is already in the controller, no need to replace
    if (_field!.composingText != null) {
      // Clear composing state
      _field!._composingText = null;
      _field!._composingRegion = null;

      // Keep the current selection
      _field!._updateRemoteEditingValue();
    }

    final selection = _field!._selection;

    // If start and end are explicitly provided, use them
    // Otherwise, use the current selection
    final selectionStart = start ?? selection.start;
    final selectionEnd = end ?? selection.end;

    // If neither explicit range nor valid selection is provided, return
    if (start == null &&
        end == null &&
        (!selection.isValid || selection.isCollapsed)) {
      return;
    }

    // If we have explicit start/end but they're equal, return
    if (selectionStart == selectionEnd) {
      return;
    }

    if (_value.isEmpty) {
      return;
    }

    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Find which blocks contain the selection
    var currentOffset = 0;

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      if (block is MarkdownMultiLineBlockValue) {
        final blockStart = currentOffset;
        final blockLength = _getBlockTextLength(block);
        final blockEnd = blockStart + blockLength;

        // Skip blocks that are entirely before or after the selection
        if (blockEnd < selectionStart || blockStart > selectionEnd) {
          currentOffset = blockEnd + 1; // +1 for newline between blocks
          continue;
        }

        final lines = List<MarkdownLineValue>.from(block.children);
        final updatedLines = <MarkdownLineValue>[];

        for (final line in lines) {
          final spans = List<MarkdownSpanValue>.from(line.children);
          final updatedSpans = <MarkdownSpanValue>[];
          var lineOffset = currentOffset;

          for (final span in spans) {
            final spanStart = lineOffset;
            final spanEnd = lineOffset + span.value.length;

            // Check if this span has a mention property
            // Mentions should not be modified by other inline properties
            final hasMentionProperty =
                span.properties.any((p) => p is MentionMarkdownSpanProperty);

            // Check if this span overlaps with the selection
            if (selectionEnd <= spanStart || selectionStart >= spanEnd) {
              // No overlap, keep the span as is
              updatedSpans.add(span);
            } else if (hasMentionProperty) {
              // This span has a mention property, keep it as is
              // Mentions cannot have other inline properties applied
              updatedSpans.add(span);
            } else {
              // There is overlap, split the span
              final overlapStart =
                  selectionStart > spanStart ? selectionStart : spanStart;
              final overlapEnd =
                  selectionEnd < spanEnd ? selectionEnd : spanEnd;

              // Before selection
              if (spanStart < overlapStart) {
                final beforeText =
                    span.value.substring(0, overlapStart - spanStart);
                updatedSpans.add(span.copyWith(
                  id: uuid(),
                  value: beforeText,
                ));
              }

              // Selected part with updated property
              final selectedText = span.value
                  .substring(overlapStart - spanStart, overlapEnd - spanStart);
              final updatedProperty =
                  _applyInlineProperty(tool, span.properties, value: value);
              updatedSpans.add(span.copyWith(
                id: uuid(),
                value: selectedText,
                properties: updatedProperty,
              ));

              // After selection
              if (spanEnd > overlapEnd) {
                final afterText = span.value.substring(overlapEnd - spanStart);
                updatedSpans.add(span.copyWith(
                  id: uuid(),
                  value: afterText,
                ));
              }
            }

            lineOffset += span.value.length;
          }

          // Merge consecutive spans with the same property
          final mergedSpans = _mergeSpans(updatedSpans);
          updatedLines.add(line.copyWith(children: mergedSpans));
        }

        blocks[i] = block.copyWith(children: updatedLines);
        currentOffset += _getBlockTextLength(block) + 1; // +1 for newline
      } else if (block is MarkdownSingleLineBlockValue) {
        // TODO: Implement single line block
      }
    }

    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    notifyListeners();
  }

  /// Removes the inline property at the specified start and end positions.
  ///
  /// 指定された開始位置と終了位置のインラインプロパティを削除します。
  void removeInlineProperty(MarkdownPropertyTools tool,
      {int? start, int? end}) {
    if (_field == null) {
      return;
    }

    // Save current state before modification
    if (!history.inProgress) {
      history.saveToUndoStack(immediate: true);
    }

    // If there's composing text, just clear it
    // The text is already in the controller, no need to replace
    if (_field!.composingText != null) {
      // Clear composing state
      _field!._composingText = null;
      _field!._composingRegion = null;

      // Keep the current selection
      _field!._updateRemoteEditingValue();
    }

    final selection = _field!._selection;

    if (!selection.isValid || selection.isCollapsed) {
      return;
    }

    final selectionStart = start ?? selection.start;
    final selectionEnd = end ?? selection.end;

    if (_value.isEmpty) {
      return;
    }

    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Find which blocks contain the selection
    var currentOffset = 0;

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      if (block is MarkdownMultiLineBlockValue) {
        final lines = List<MarkdownLineValue>.from(block.children);
        final updatedLines = <MarkdownLineValue>[];

        for (final line in lines) {
          final spans = List<MarkdownSpanValue>.from(line.children);
          final updatedSpans = <MarkdownSpanValue>[];
          var lineOffset = currentOffset;

          for (final span in spans) {
            final spanStart = lineOffset;
            final spanEnd = lineOffset + span.value.length;

            // Check if this span has a mention property
            // Mentions should not be modified by other inline properties
            final hasMentionProperty =
                span.properties.any((p) => p is MentionMarkdownSpanProperty);

            // Check if this span overlaps with the selection
            if (selectionEnd <= spanStart || selectionStart >= spanEnd) {
              // No overlap, keep the span as is
              updatedSpans.add(span);
            } else if (hasMentionProperty) {
              // This span has a mention property, keep it as is
              // Mentions cannot have other inline properties removed
              updatedSpans.add(span);
            } else {
              // There is overlap, split the span
              final overlapStart =
                  selectionStart > spanStart ? selectionStart : spanStart;
              final overlapEnd =
                  selectionEnd < spanEnd ? selectionEnd : spanEnd;

              // Before selection
              if (spanStart < overlapStart) {
                final beforeText =
                    span.value.substring(0, overlapStart - spanStart);
                updatedSpans.add(span.copyWith(
                  id: uuid(),
                  value: beforeText,
                ));
              }

              // Selected part with property removed
              final selectedText = span.value
                  .substring(overlapStart - spanStart, overlapEnd - spanStart);
              final updatedProperty =
                  _removeInlineProperty(tool, span.properties);
              updatedSpans.add(span.copyWith(
                id: uuid(),
                value: selectedText,
                properties: updatedProperty,
              ));

              // After selection
              if (spanEnd > overlapEnd) {
                final afterText = span.value.substring(overlapEnd - spanStart);
                updatedSpans.add(span.copyWith(
                  id: uuid(),
                  value: afterText,
                ));
              }
            }

            lineOffset += span.value.length;
          }

          // Merge consecutive spans with the same property
          final mergedSpans = _mergeSpans(updatedSpans);
          updatedLines.add(line.copyWith(children: mergedSpans));
        }

        blocks[i] = block.copyWith(children: updatedLines);
        currentOffset += _getBlockTextLength(block) + 1; // +1 for newline
      } else if (block is MarkdownSingleLineBlockValue) {
        // TODO: Implement single line block
      }
    }

    final newField = field.copyWith(children: blocks);
    _value[0] = newField;
    notifyListeners();
  }

  /// Checks if the inline property exists at the specified start and end positions.
  ///
  /// 指定された開始位置と終了位置のインラインプロパティが存在するかどうかを確認します。
  bool hasInlineProperty(MarkdownPropertyTools tool, {int? start, int? end}) {
    if (_field == null) {
      return false;
    }

    // If there's composing text (IME input in progress), return false
    // because properties cannot be applied to uncommitted text
    if (_field!.composingText != null) {
      return false;
    }

    final selection = _field!._selection;
    if (!selection.isValid || selection.isCollapsed) {
      return false;
    }

    final selectionStart = start ?? selection.start;
    final selectionEnd = end ?? selection.end;

    if (_value.isEmpty) {
      return false;
    }

    final field = _value.first;
    final blocks = field.children;

    var currentOffset = 0;
    var allHaveProperty = true;
    var hasNonMentionSpan = false;

    for (final block in blocks) {
      if (block is MarkdownMultiLineBlockValue) {
        for (final line in block.children) {
          var lineOffset = currentOffset;

          for (final span in line.children) {
            final spanStart = lineOffset;
            final spanEnd = lineOffset + span.value.length;

            // Check if this span overlaps with the selection
            if (selectionEnd > spanStart && selectionStart < spanEnd) {
              // Check if this span has a mention property
              // Mentions should be excluded from property checking
              final hasMentionProperty =
                  span.properties.any((p) => p is MentionMarkdownSpanProperty);

              if (!hasMentionProperty) {
                // This is a non-mention span, check if it has the property
                hasNonMentionSpan = true;
                if (!_hasInlineProperty(tool, span.properties)) {
                  allHaveProperty = false;
                  break;
                }
              }
            }

            lineOffset += span.value.length;
          }

          if (!allHaveProperty) {
            break;
          }
        }

        currentOffset += _getBlockTextLength(block) + 1; // +1 for newline
        if (!allHaveProperty) {
          break;
        }
      } else if (block is MarkdownSingleLineBlockValue) {
        // TODO: Implement single line block
      }
    }

    // If all spans in selection are mentions, return false
    // Only return true if there's at least one non-mention span with the property
    return hasNonMentionSpan && allHaveProperty;
  }

  /// Applies the inline property from the tool to the given property.
  ///
  /// ツールからインラインプロパティを適用します。
  List<MarkdownProperty> _applyInlineProperty(
    MarkdownPropertyTools tool,
    List<MarkdownProperty> properties, {
    Object? value,
  }) {
    return tool.addProperty(properties, value: value);
  }

  /// Removes the inline property from the tool from the given property.
  ///
  /// ツールからインラインプロパティを削除します。
  List<MarkdownProperty> _removeInlineProperty(
    MarkdownPropertyTools tool,
    List<MarkdownProperty> properties,
  ) {
    return tool.removeProperty(properties);
  }

  /// Checks if the given property has the inline property from the tool.
  ///
  /// 与えられたプロパティがツールからのインラインプロパティを持っているかどうかを確認します。
  bool _hasInlineProperty(
    MarkdownPropertyTools tool,
    List<MarkdownProperty> properties,
  ) {
    return properties.any((e) => e.type == tool.id);
  }

  /// Unselects the text.
  ///
  /// テキストの選択を解除します。
  void unselect() {
    notifyListeners();
  }

  /// Inserts a new paragraph block at the specified offset.
  ///
  /// 指定されたオフセット位置に新しい段落ブロックを挿入します。
  void insertNewLine(int offset) {
    // Save current state before modification (immediate for explicit actions)
    history.saveToUndoStack(immediate: true);

    if (_value.isEmpty) {
      // Create initial structure with empty paragraph
      final field = MarkdownFieldValue.createEmpty();
      _value.clear();
      _value.add(field);
      notifyListeners();
      return;
    }

    // Get current field
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Find which block and position to split
    var currentOffset = 0;
    var blockIndex = -1;
    String? textBeforeCursor;
    String? textAfterCursor;

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      if (block is MarkdownMultiLineBlockValue) {
        final blockText = StringBuffer();

        // Extract children based on block type
        final blockChildren = block.extractLines();

        for (var j = 0; j < blockChildren.length; j++) {
          final line = blockChildren[j];
          for (final span in line.children) {
            blockText.write(span.value);
          }
          if (j < blockChildren.length - 1) {
            blockText.writeln();
          }
        }

        final blockTextStr = blockText.toString();
        final blockLength = blockTextStr.length;

        if (currentOffset + blockLength >= offset) {
          // Found the block to split
          blockIndex = i;
          final localOffset = offset - currentOffset;
          textBeforeCursor = blockTextStr.substring(0, localOffset);
          textAfterCursor = blockTextStr.substring(localOffset);
          break;
        }

        currentOffset += blockLength;
      }
    }

    if (blockIndex == -1) {
      // Offset is at the end, create new block
      // Check the type of the last block to inherit it for BulletedList
      final newBlock = blocks.lastOrNull?.clone();
      if (newBlock != null) {
        blocks.add(newBlock);
      }
    } else {
      // Split the current block
      final oldBlock = blocks[blockIndex];

      // Extract children based on block type
      final oldBlockChildren = oldBlock.extractLines() ?? [];

      // Collect existing spans
      final existingSpans = <MarkdownSpanValue>[];
      for (final line in oldBlockChildren) {
        existingSpans.addAll(line.children);
      }

      // Find the split position within spans
      final beforeSpans = <MarkdownSpanValue>[];
      final afterSpans = <MarkdownSpanValue>[];
      var currentPos = 0;
      final localOffset = offset - currentOffset;

      for (final span in existingSpans) {
        final spanStart = currentPos;
        final spanEnd = currentPos + span.value.length;

        if (spanEnd <= localOffset) {
          // Span is entirely before the split - keep in before block with properties
          beforeSpans.add(span);
        } else if (spanStart >= localOffset) {
          // Span is entirely after the split - move to after block without properties
          afterSpans.add(span.copyWith(
            id: uuid(),
            properties: const [], // Remove properties from text after newline
          ));
        } else {
          // Split the span at the cursor position
          final beforeText = span.value.substring(0, localOffset - spanStart);
          final afterText = span.value.substring(localOffset - spanStart);

          if (beforeText.isNotEmpty) {
            beforeSpans.add(span.copyWith(
              id: uuid(),
              value: beforeText,
            ));
          }

          if (afterText.isNotEmpty) {
            afterSpans.add(MarkdownSpanValue(
              id: uuid(),
              value: afterText,
              properties: const [], // New line starts without properties
            ));
          }
        }

        currentPos += span.value.length;
      }

      // Ensure we have at least one span in each block
      if (beforeSpans.isEmpty) {
        beforeSpans.add(MarkdownSpanValue(
          id: uuid(),
          value: textBeforeCursor!,
          properties: const [],
        ));
      }
      if (afterSpans.isEmpty) {
        afterSpans.add(MarkdownSpanValue(
          id: uuid(),
          value: textAfterCursor!,
          properties: const [],
        ));
      }

      // Create block with text before cursor (preserving properties, block type, and indent)
      final beforeBlock = oldBlock.clone(
        child: MarkdownLineValue(
          id: uuid(),
          children: beforeSpans,
        ),
      );

      // Create new block with text after cursor
      // For BulletedList blocks, inherit the block type and indent level
      // For other blocks, create a paragraph
      final afterBlock = oldBlock.clone(
        child: MarkdownLineValue(
          id: uuid(),
          children: afterSpans,
        ),
      );

      // Replace old block with before and after blocks
      blocks[blockIndex] = beforeBlock;
      blocks.insert(blockIndex + 1, afterBlock);
    }

    // Update field with new blocks
    final newField = MarkdownFieldValue(
      id: field.id,
      children: blocks,
    );

    _value[0] = newField;
    notifyListeners();
  }

  /// Gets plain text representation of the content.
  ///
  /// コンテンツのプレーンテキスト表現を取得します。
  String getPlainText() {
    final buffer = StringBuffer();
    for (final field in _value) {
      for (var i = 0; i < field.children.length; i++) {
        final block = field.children[i];
        if (block is MarkdownMultiLineBlockValue) {
          for (var j = 0; j < block.children.length; j++) {
            final line = block.children[j];
            for (final span in line.children) {
              buffer.write(span.value);
            }
            // Add newline except for the last line in the block
            if (j < block.children.length - 1) {
              buffer.writeln();
            }
          }
        }
        // Add newline between blocks except for the last block
        if (i < field.children.length - 1) {
          buffer.writeln();
        }
      }
    }
    return buffer.toString();
  }

  /// Notifies listeners that the selection state has changed.
  ///
  /// This is useful for updating the toolbar when text selection changes.
  ///
  /// 選択状態が変更されたことをリスナーに通知します。
  ///
  /// テキスト選択が変更されたときにツールバーを更新するのに便利です。
  void notifySelectionChanged() {
    notifyListeners();
  }

  /// Sets the callback for when a link dialog should be shown.
  ///
  /// リンクダイアログを表示する必要があるときのコールバックを設定します。
  void setLinkDialogCallback(void Function(String url)? callback) {
    _onShowLinkDialog = callback;
  }

  /// Shows the link dialog with the given URL.
  ///
  /// 指定されたURLでリンクダイアログを表示します。
  void showLinkDialog(String url) {
    _onShowLinkDialog?.call(url);
  }

  /// Callback for when a link should be shown in a dialog.
  ///
  /// リンクをダイアログに表示する必要があるときのコールバック。
  void Function(String url)? _onShowLinkDialog;

  /// Checks if the cursor is at the end of a link and returns the link range.
  /// Used to implement link deletion behavior (select link on first backspace).
  ///
  /// カーソルがリンクの末尾にあるかチェックし、リンクの範囲を返します。
  /// リンク削除の挙動（最初のBackspaceでリンクを選択）を実装するために使用されます。
  TextRange? getLinkRangeBeforeCursor(int cursorOffset) {
    if (_value.isEmpty || cursorOffset <= 0) {
      return null;
    }

    // Check if the position just before the cursor is inside a link
    final checkOffset = cursorOffset - 1;
    var currentOffset = 0;
    String? targetLinkUrl;
    int? linkStart;
    int? linkEnd;

    // Traverse through the markdown structure
    for (final fieldValue in _value) {
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

              // Check if checkOffset is within this span
              if (checkOffset >= spanStart && checkOffset < spanEnd) {
                // Check if this span has a link property
                for (final property in span.properties) {
                  if (property is LinkMarkdownSpanProperty) {
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

    if (targetLinkUrl == null) {
      return null;
    }

    // Second pass: find the full range of consecutive spans with the same link URL
    currentOffset = 0;
    for (final fieldValue in _value) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownMultiLineBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;

              // Check if this span has the same link URL
              var hasTargetLink = false;
              for (final property in span.properties) {
                if (property is LinkMarkdownSpanProperty &&
                    property.link == targetLinkUrl) {
                  hasTargetLink = true;
                  break;
                }
              }

              if (hasTargetLink) {
                // Expand the link range
                linkStart ??= spanStart;
                linkEnd = spanEnd;
              } else if (linkStart != null) {
                // We've found the end of the consecutive link spans
                // But only return if we've already passed the check offset
                if (currentOffset > checkOffset) {
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
              currentOffset += 1;
            }
          }
          // Add 1 for newline after each paragraph block (except the last one)
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
    }

    // Return the range if we found one
    if (linkStart != null && linkEnd != null) {
      return TextRange(start: linkStart, end: linkEnd);
    }

    return null;
  }

  /// Inserts a mention at the given offset.
  ///
  /// 指定されたオフセットにメンションを挿入します。
  void insertMention(MarkdownMention mention) {
    final field = _field;
    if (field == null) {
      return;
    }
    // Insert mention at current cursor position
    final selection = field._selection;
    if (selection.isCollapsed) {
      final cursorPosition = selection.baseOffset;
      // Insert mention text: @{mention.name}
      final mentionText = "@${mention.name}";

      // Validation: Ensure mention text doesn't contain newlines
      if (mentionText.contains("\n")) {
        return;
      }

      // Insert mention text and property as atomic operation
      // (combine both into single undo history entry)
      // Replace any selected text or insert at cursor
      replaceText(
        cursorPosition,
        cursorPosition,
        mentionText,
      );
      // Add mention property (skip history since replaceText already saved)
      addInlineProperty(
        const MentionMarkdownPrimaryTools(),
        start: cursorPosition,
        end: cursorPosition + mentionText.length,
        value: mention,
        skipHistory: true,
      );
      // Move cursor to after the mention
      field._selection = TextSelection.collapsed(
        offset: cursorPosition + mentionText.length,
      );
      field._updateRemoteEditingValue();
    }
  }

  /// Get the range of a mention immediately before the cursor.
  ///
  /// カーソルの直前にあるメンションの範囲を取得します。
  TextRange? getMentionRangeBeforeCursor(int cursorOffset) {
    if (_value.isEmpty || cursorOffset <= 0) {
      return null;
    }

    // Check if the position just before the cursor is inside a mention
    final checkOffset = cursorOffset - 1;
    var currentOffset = 0;
    MarkdownMention? targetMention;
    int? mentionStart;
    int? mentionEnd;

    // Traverse through the markdown structure
    for (final fieldValue in _value) {
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

              // Check if checkOffset is within this span
              if (checkOffset >= spanStart && checkOffset < spanEnd) {
                // Check if this span has a mention property
                for (final property in span.properties) {
                  if (property is MentionMarkdownSpanProperty) {
                    targetMention = property.mention;
                    break;
                  }
                }
                if (targetMention != null) {
                  break;
                }
              }

              currentOffset += spanLength;
            }
            if (targetMention != null) {
              break;
            }
            // Add 1 for newline only if this is not the last line in the block
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          if (targetMention != null) {
            break;
          }
          // Add 1 for newline after each paragraph block (except the last one)
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
      if (targetMention != null) {
        break;
      }
    }

    if (targetMention == null) {
      return null;
    }

    // Second pass: find the full range of consecutive spans with the same mention
    currentOffset = 0;
    for (final fieldValue in _value) {
      final blocks = fieldValue.children;
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownMultiLineBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;

              // Check if this span has the same mention
              var hasTargetMention = false;
              for (final property in span.properties) {
                if (property is MentionMarkdownSpanProperty &&
                    property.mention.id == targetMention.id) {
                  hasTargetMention = true;
                  break;
                }
              }

              if (hasTargetMention) {
                // Expand the mention range
                mentionStart ??= spanStart;
                mentionEnd = spanEnd;
              } else if (mentionStart != null) {
                // We've found the end of the consecutive mention spans
                // But only return if we've already passed the check offset
                if (currentOffset > checkOffset) {
                  return TextRange(start: mentionStart, end: mentionEnd!);
                }
                // Reset for next potential mention range
                mentionStart = null;
                mentionEnd = null;
              }

              currentOffset += spanLength;
            }
            // Add 1 for newline only if this is not the last line in the block
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          // Add 1 for newline after each paragraph block (except the last one)
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
    }

    // Return the range if we found one
    if (mentionStart != null && mentionEnd != null) {
      return TextRange(start: mentionStart, end: mentionEnd);
    }

    return null;
  }

  void _notifyListeners() {
    notifyListeners();
  }

  /// Gets the list of block indices that are within the selection range.
  ///
  /// 選択範囲内にあるブロックのインデックスのリストを取得します。
  List<int> _getSelectedBlocks(int start, int end) {
    if (_value.isEmpty) {
      return [];
    }

    final field = _value.first;
    final blocks = field.children;
    final selectedBlockIndices = <int>[];

    var currentOffset = 0;

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      final blockChildren = block.extractLines();

      if (blockChildren != null) {
        final blockText = StringBuffer();
        for (var j = 0; j < blockChildren.length; j++) {
          final line = blockChildren[j];
          for (final span in line.children) {
            blockText.write(span.value);
          }
          if (j < blockChildren.length - 1) {
            blockText.writeln();
          }
        }

        final blockLength = blockText.toString().length;
        final blockStart = currentOffset;
        final blockEnd = currentOffset + blockLength;

        // Check if this block is within the selection
        // A block is selected if the selection overlaps with it
        if ((start >= blockStart && start <= blockEnd) ||
            (end >= blockStart && end <= blockEnd) ||
            (start <= blockStart && end >= blockEnd)) {
          selectedBlockIndices.add(i);
        }

        currentOffset += blockLength + 1; // +1 for newline between blocks
      }
    }

    return selectedBlockIndices;
  }

  /// Gets the text length of a block.
  ///
  /// ブロックのテキストの長さを取得します。
  int _getBlockTextLength(MarkdownBlockValue block) {
    if (block is MarkdownMultiLineBlockValue) {
      final blockText = StringBuffer();
      for (var j = 0; j < block.children.length; j++) {
        final line = block.children[j];
        for (final span in line.children) {
          blockText.write(span.value);
        }
        if (j < block.children.length - 1) {
          blockText.writeln();
        }
      }
      return blockText.toString().length;
    }
    return 0;
  }

  /// Merges consecutive spans with the same property.
  ///
  /// 同じプロパティを持つ連続したスパンをマージします。
  List<MarkdownSpanValue> _mergeSpans(List<MarkdownSpanValue> spans) {
    if (spans.isEmpty) {
      return spans;
    }

    final merged = <MarkdownSpanValue>[];
    var current = spans.first;

    for (var i = 1; i < spans.length; i++) {
      final next = spans[i];
      if (current.properties.equalsTo(next.properties)) {
        // Merge
        current = current.copyWith(value: current.value + next.value);
      } else {
        merged.add(current);
        current = next;
      }
    }
    merged.add(current);

    return merged;
  }

  /// Extracts spans from the selected range, preserving their properties.
  ///
  /// 選択範囲からスパンを抽出し、そのプロパティを保持します。
  List<MarkdownSpanValue> _extractSpansFromSelection(int start, int end) {
    if (_value.isEmpty) {
      return [];
    }

    final field = _value.first;
    final blocks = field.children;
    final extractedSpans = <MarkdownSpanValue>[];

    var currentOffset = 0;

    for (final block in blocks) {
      if (block is MarkdownMultiLineBlockValue) {
        for (final line in block.children) {
          var lineOffset = currentOffset;

          for (final span in line.children) {
            final spanStart = lineOffset;
            final spanEnd = lineOffset + span.value.length;

            // Check if this span overlaps with the selection
            if (end > spanStart && start < spanEnd) {
              // Calculate the overlap
              final overlapStart = start > spanStart ? start : spanStart;
              final overlapEnd = end < spanEnd ? end : spanEnd;

              // Extract the overlapping portion
              final extractedText = span.value.substring(
                overlapStart - spanStart,
                overlapEnd - spanStart,
              );

              // Create a new span with the extracted text and same properties
              extractedSpans.add(span.copyWith(
                id: uuid(),
                value: extractedText,
              ));
            }

            lineOffset += span.value.length;
          }
        }

        currentOffset += _getBlockTextLength(block) + 1; // +1 for newline
      }
    }

    return extractedSpans;
  }

  /// Checks if the selection encompasses an entire block.
  ///
  /// 選択範囲がブロック全体を含むかどうかをチェックします。
  ({bool isFullBlock, String? blockType})? _isFullBlockSelected(
      int start, int end) {
    if (_value.isEmpty) {
      return null;
    }

    var currentOffset = 0;

    for (final field in _value) {
      for (final block in field.children) {
        final blockLength = _getBlockTextLength(block);
        final blockStart = currentOffset;
        final blockEnd = currentOffset + blockLength;

        // Check if selection exactly matches this block
        if (start == blockStart && end == blockEnd) {
          return (isFullBlock: true, blockType: block.type);
        }

        currentOffset = blockEnd + 1; // +1 for newline
      }
    }

    return (isFullBlock: false, blockType: null);
  }

  @override
  void dispose() {
    // Cancel any pending history saves
    history.dispose();

    // Clear callback
    _onShowLinkDialog = null;

    // Dispose focus node
    focusNode.dispose();

    super.dispose();
  }
}

@immutable
class _$MarkdownControllerQuery {
  const _$MarkdownControllerQuery();

  @useResult
  _$_MarkdownControllerQuery call({MarkdownMasamuneAdapter? adapter}) =>
      _$_MarkdownControllerQuery(
        hashCode.toString(),
        adapter: adapter,
      );
}

@immutable
class _$_MarkdownControllerQuery
    extends ControllerQueryBase<MarkdownController> {
  const _$_MarkdownControllerQuery(this._name, {this.adapter});

  final String _name;

  final MarkdownMasamuneAdapter? adapter;

  @override
  MarkdownController Function() call(Ref ref) {
    return () => MarkdownController(adapter: adapter);
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
