part of "/masamune_markdown.dart";

/// Represents a snapshot of document state and cursor position for undo/redo.
///
/// Undo/Redo用のドキュメント状態とカーソル位置のスナップショット。
class _HistorySnapshot {
  const _HistorySnapshot({
    required this.fieldValues,
    required this.cursorPosition,
  });

  final List<MarkdownFieldValue> fieldValues;
  final int cursorPosition;
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

  /// Internal clipboard storage for preserving span properties and block information.
  ///
  /// スパンのプロパティとブロック情報を保持するための内部クリップボードストレージ。
  _ClipboardData? _internalClipboard;

  /// Undo history stack (stored as deep copied MarkdownFieldValue objects and cursor positions).
  ///
  /// 元に戻す履歴スタック（ディープコピーされたMarkdownFieldValueオブジェクトとカーソル位置として保存）。
  final List<_HistorySnapshot> _undoStack = [];

  /// Redo history stack (stored as deep copied MarkdownFieldValue objects and cursor positions).
  ///
  /// やり直す履歴スタック（ディープコピーされたMarkdownFieldValueオブジェクトとカーソル位置として保存）。
  final List<_HistorySnapshot> _redoStack = [];

  /// Maximum number of history entries to keep.
  ///
  /// 保持する履歴エントリの最大数。
  static const int _maxHistorySize = 100;

  /// Timer for debouncing history saves.
  ///
  /// 履歴保存のデバウンス用タイマー。
  Timer? _historyDebounceTimer;

  /// Duration to wait before saving history.
  ///
  /// 履歴を保存するまでの待機時間。
  static const Duration _historyDebounceDuration = Duration(milliseconds: 500);

  /// Tracks if we have pending changes to save.
  ///
  /// 保存待ちの変更があるかどうかを追跡します。
  bool _hasPendingHistorySave = false;

  /// Flag to prevent saving history during undo/redo operations.
  ///
  /// Undo/Redo操作中に履歴保存を防ぐフラグ。
  bool _isUndoRedoInProgress = false;

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

  /// Creates a deep copy of the given MarkdownFieldValue list.
  ///
  /// 指定されたMarkdownFieldValueリストのディープコピーを作成します。
  List<MarkdownFieldValue> _deepCopyFieldValues(
      List<MarkdownFieldValue> fields) {
    return fields.map((field) {
      return field.copyWith(
        children: field.children.map<MarkdownBlockValue>((block) {
          if (block is MarkdownParagraphBlockValue) {
            return block.copyWith(
              children: block.children.map<MarkdownLineValue>((line) {
                return line.copyWith(
                  children: line.children.map<MarkdownSpanValue>((span) {
                    return span.copyWith();
                  }).toList(),
                );
              }).toList(),
            ) as MarkdownBlockValue;
          }
          // Add other block types as needed
          return block.copyWith() as MarkdownBlockValue;
        }).toList(),
      );
    }).toList();
  }

  /// Saves current state to undo stack immediately.
  ///
  /// 現在の状態を元に戻すスタックに即座に保存します。
  void _saveToUndoStackImmediate() {
    // Create a deep copy of current state
    final fieldValuesCopy = _deepCopyFieldValues(_value);

    // Get current cursor position
    final cursorPosition = _field?._selection.baseOffset ?? 0;

    final snapshot = _HistorySnapshot(
      fieldValues: fieldValuesCopy,
      cursorPosition: cursorPosition,
    );

    _undoStack.add(snapshot);

    // Limit stack size
    if (_undoStack.length > _maxHistorySize) {
      _undoStack.removeAt(0);
    }

    // Clear redo stack when new action is performed
    if (_redoStack.isNotEmpty) {
      _redoStack.clear();
    }
    _hasPendingHistorySave = false;
  }

  /// Schedules a history save with debouncing.
  ///
  /// デバウンスを使用して履歴保存をスケジュールします。
  void _scheduleHistorySave() {
    // Cancel existing timer if any
    _historyDebounceTimer?.cancel();

    // Mark that we have pending changes
    _hasPendingHistorySave = true;

    // Schedule a new save
    _historyDebounceTimer = Timer(_historyDebounceDuration, () {
      if (_hasPendingHistorySave) {
        _saveToUndoStackImmediate();
        // Notify listeners to update UI (e.g., undo/redo button states)
        notifyListeners();
      }
    });
  }

  /// Saves current state to undo stack (may be debounced).
  ///
  /// 現在の状態を元に戻すスタックに保存します（デバウンスされる場合があります）。
  void _saveToUndoStack({bool immediate = false}) {
    if (immediate) {
      _historyDebounceTimer?.cancel();
      _saveToUndoStackImmediate();
    } else {
      _scheduleHistorySave();
    }
  }

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
        debugPrint("🔍 replaceText: No-op replacement detected, skipping");
        return;
      }
    }

    // Skip history saving during undo/redo operations or when explicitly requested
    if (!_isUndoRedoInProgress && !skipHistory) {
      // Save current state before modification
      // For single character insertion/deletion, save immediately for fine-grained undo
      final isSingleCharEdit = text.length <= 1 && (end - start) <= 1;

      if (_undoStack.isEmpty) {
        // First edit - save initial empty/current state immediately BEFORE modification
        _saveToUndoStack(immediate: true);
      } else if (isSingleCharEdit) {
        // Single character edit - save immediately for fine-grained undo BEFORE modification
        _saveToUndoStack(immediate: true);
      } else {
        // Multi-character edit (e.g., paste, cut) - save immediately to ensure it's captured
        _saveToUndoStack(immediate: true);
      }
    }
    // Ensure we have a valid structure
    if (_value.isEmpty) {
      // Create initial structure
      final field = MarkdownFieldValue(
        id: uuid(),
        children: [
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: text,
                  ),
                ],
              ),
            ],
          ),
        ],
      );
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

    debugPrint(
        "🔍 replaceText: Analyzing blocks (total: ${blocks.length}, start=$start, end=$end)");
    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      if (block is MarkdownParagraphBlockValue ||
          block is MarkdownBulletedListBlockValue) {
        final blockText = StringBuffer();
        List<MarkdownLineValue> blockChildren;

        if (block is MarkdownParagraphBlockValue) {
          blockChildren = block.children;
        } else {
          blockChildren = (block as MarkdownBulletedListBlockValue).children;
        }

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

        debugPrint(
            "   Block $i: start=$blockStart, end=$blockEnd, length=$blockLength, text='${blockText.toString().replaceAll('\n', '\\n')}'");

        // Check if this block contains the start position
        if (startBlockIndex == null && blockEnd >= start) {
          startBlockIndex = i;
          localStart = start - blockStart;
          debugPrint(
              "      → Contains start position (localStart=$localStart)");
        }

        // Check if this block contains the end position
        if (blockEnd >= end) {
          endBlockIndex = i;
          endBlockStart = blockStart;
          localEnd = end - blockStart;
          debugPrint(
              "      → Contains end position (localEnd=$localEnd, endBlockStart=$endBlockStart)");
          break;
        }

        currentOffset += blockLength + 1; // +1 for newline between blocks
      }
    }
    debugPrint(
        "   Result: startBlockIndex=$startBlockIndex, endBlockIndex=$endBlockIndex");
    debugPrint(
        "   Check: startBlockIndex != endBlockIndex? ${startBlockIndex != endBlockIndex}");

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

        List<MarkdownLineValue> lastBlockChildren;
        if (lastBlock is MarkdownParagraphBlockValue) {
          lastBlockChildren = lastBlock.children;
        } else if (lastBlock is MarkdownBulletedListBlockValue) {
          lastBlockChildren = lastBlock.children;
        } else {
          lastBlockChildren = [];
        }

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
      final newBlock = MarkdownParagraphBlockValue(
        id: uuid(),
        children: [
          MarkdownLineValue(
            id: uuid(),
            children: [
              MarkdownSpanValue(
                id: uuid(),
                value: text,
              ),
            ],
          ),
        ],
      );
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
      debugPrint(
          "🔄 Multi-block operation: startBlock=$startBlockIndex, endBlock=$endBlockIndex, text='$text'");

      // Get text before start in start block
      final startBlock = blocks[startBlockIndex];
      final startBlockText = StringBuffer();

      // Extract children based on block type
      List<MarkdownLineValue> startBlockChildren;
      if (startBlock is MarkdownParagraphBlockValue) {
        startBlockChildren = startBlock.children;
      } else if (startBlock is MarkdownBulletedListBlockValue) {
        startBlockChildren = startBlock.children;
      } else {
        startBlockChildren = [];
      }

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
      List<MarkdownLineValue> endBlockChildren;
      if (endBlock is MarkdownParagraphBlockValue) {
        endBlockChildren = endBlock.children;
      } else if (endBlock is MarkdownBulletedListBlockValue) {
        endBlockChildren = endBlock.children;
      } else {
        endBlockChildren = [];
      }

      for (final line in endBlockChildren) {
        for (final span in line.children) {
          endBlockText.write(span.value);
        }
      }
      final endBlockTextStr = endBlockText.toString();
      final safeLocalEnd = localEnd.clamp(0, endBlockTextStr.length);
      final textAfterEnd = endBlockTextStr.substring(safeLocalEnd);

      debugPrint(
          "   textBeforeStart='$textBeforeStart', textAfterEnd='$textAfterEnd'");

      // Calculate what the merged text would be
      final potentialMergedText = textBeforeStart + text + textAfterEnd;

      // Get the original text across both blocks for comparison
      final originalText = StringBuffer();
      for (var i = startBlockIndex; i <= endBlockIndex; i++) {
        final block = blocks[i];

        // Extract children based on block type
        List<MarkdownLineValue> blockChildren;
        if (block is MarkdownParagraphBlockValue) {
          blockChildren = block.children;
        } else if (block is MarkdownBulletedListBlockValue) {
          blockChildren = block.children;
        } else {
          blockChildren = [];
        }

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

      debugPrint("   potentialMergedText='$potentialMergedText'");
      debugPrint("   originalTextStr='$originalTextStr'");
      debugPrint(
          "   Are they equal? ${potentialMergedText == originalTextStr}");

      // If the operation would result in the same text, don't merge blocks
      // This happens when selection handles are dragged without actually changing text
      if (potentialMergedText == originalTextStr) {
        debugPrint("   → Text unchanged, keeping original block structure");
        // Don't modify anything, just return
        notifyListeners();
        return;
      }

      // Check if we should keep blocks separate or merge them
      // Keep separate if: deletion AND both blocks have content remaining
      final shouldKeepSeparate =
          text.isEmpty && textBeforeStart.isNotEmpty && textAfterEnd.isNotEmpty;

      if (shouldKeepSeparate) {
        debugPrint(
            "   → Keeping blocks separate: before='$textBeforeStart', after='$textAfterEnd'");

        // Update first block with text before start, preserving block type
        final MarkdownBlockValue updatedFirstBlock;
        if (startBlock is MarkdownParagraphBlockValue) {
          updatedFirstBlock = MarkdownParagraphBlockValue(
            id: startBlock.id,
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: textBeforeStart,
                    properties: const [],
                  ),
                ],
              ),
            ],
          );
        } else if (startBlock is MarkdownBulletedListBlockValue) {
          updatedFirstBlock = MarkdownBulletedListBlockValue(
            id: startBlock.id,
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: textBeforeStart,
                    properties: const [],
                  ),
                ],
              ),
            ],
          );
        } else {
          // Fallback to paragraph for unknown types
          updatedFirstBlock = MarkdownParagraphBlockValue(
            id: startBlock.id,
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: textBeforeStart,
                    properties: const [],
                  ),
                ],
              ),
            ],
          );
        }

        // Update last block with text after end, preserving block type
        final MarkdownBlockValue updatedLastBlock;
        if (endBlock is MarkdownParagraphBlockValue) {
          updatedLastBlock = MarkdownParagraphBlockValue(
            id: endBlock.id,
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: textAfterEnd,
                    properties: const [],
                  ),
                ],
              ),
            ],
          );
        } else if (endBlock is MarkdownBulletedListBlockValue) {
          updatedLastBlock = MarkdownBulletedListBlockValue(
            id: endBlock.id,
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: textAfterEnd,
                    properties: const [],
                  ),
                ],
              ),
            ],
          );
        } else {
          // Fallback to paragraph for unknown types
          updatedLastBlock = MarkdownParagraphBlockValue(
            id: endBlock.id,
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: textAfterEnd,
                    properties: const [],
                  ),
                ],
              ),
            ],
          );
        }

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
        debugPrint(
            "   → Removing trailing newline from merged text (was: ${mergedText.length} chars)");
        mergedText = mergedText.substring(0, mergedText.length - 1);
        debugPrint("   → New merged text: ${mergedText.length} chars");
      }

      // If merged text is empty, just remove the blocks without creating a new one
      if (mergedText.isEmpty && text.isEmpty) {
        // Remove blocks from startBlockIndex to endBlockIndex (inclusive)
        blocks.removeRange(startBlockIndex, endBlockIndex + 1);

        // If all blocks were removed, create an empty block
        if (blocks.isEmpty) {
          blocks.add(MarkdownParagraphBlockValue(
            id: uuid(),
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: "",
                  ),
                ],
              ),
            ],
          ));
        }
      } else {
        // Create new merged block, preserving the type of the first block
        final MarkdownBlockValue mergedBlock;
        if (startBlock is MarkdownParagraphBlockValue) {
          mergedBlock = MarkdownParagraphBlockValue(
            id: startBlock.id,
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: mergedText,
                  ),
                ],
              ),
            ],
          );
        } else if (startBlock is MarkdownBulletedListBlockValue) {
          debugPrint(
              "   → Creating merged BulletedList block (preserving first block type)");
          mergedBlock = MarkdownBulletedListBlockValue(
            id: startBlock.id,
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: mergedText,
                  ),
                ],
              ),
            ],
          );
        } else {
          // Fallback to paragraph for unknown types
          mergedBlock = MarkdownParagraphBlockValue(
            id: startBlock.id,
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: mergedText,
                  ),
                ],
              ),
            ],
          );
        }

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
    List<MarkdownLineValue> targetBlockChildren;
    if (targetBlock is MarkdownParagraphBlockValue) {
      targetBlockChildren = targetBlock.children;
    } else if (targetBlock is MarkdownBulletedListBlockValue) {
      targetBlockChildren = targetBlock.children;
    } else {
      // Unknown block type, skip
      notifyListeners();
      return;
    }

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
      debugPrint(
          "   → Single block: Removing trailing newline (was: ${newText.length} chars)");
      newText = newText.substring(0, newText.length - 1);
      debugPrint("   → New text: ${newText.length} chars");
      removedTrailingNewline = true;
    }

    // If we removed a trailing newline, create a simple span with the new text
    // and skip the complex span merging logic (which would add the newline back)
    if (removedTrailingNewline) {
      debugPrint("   → Creating simple span from corrected text");

      final MarkdownBlockValue newBlock;
      if (targetBlock is MarkdownParagraphBlockValue) {
        newBlock = MarkdownParagraphBlockValue(
          id: targetBlock.id,
          children: [
            MarkdownLineValue(
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
          ],
        );
      } else {
        // BulletedList
        newBlock = MarkdownBulletedListBlockValue(
          id: targetBlock.id,
          children: [
            MarkdownLineValue(
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
          ],
        );
      }

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

    debugPrint("🔧 replaceText: Building new spans");
    debugPrint("  oldText: '$oldText' (${oldText.length} chars)");
    debugPrint("  newText will be: '$newText' (${newText.length} chars)");
    debugPrint("  safeStart=$safeStart, safeEnd=$safeEnd, text='$text'");
    debugPrint("  existingSpans.length=${existingSpans.length}");

    // Process existing spans and split them if necessary
    for (final span in existingSpans) {
      // Skip empty spans - they should be removed
      if (span.value.isEmpty) {
        continue;
      }

      final spanStart = currentPos;
      final spanEnd = currentPos + span.value.length;

      debugPrint(
          "    Processing span: '${span.value}' at pos $spanStart-$spanEnd");

      // Check if this span is affected by the replacement
      if (safeEnd < spanStart) {
        // Span is entirely after the replacement - keep as is
        debugPrint("      -> Span is after replacement, keeping as is");
        newSpans.add(span);
      } else if (safeStart >= spanEnd) {
        // Span is entirely before the replacement - keep as is
        debugPrint("      -> Span is before replacement, keeping as is");
        newSpans.add(span);

        // If we're inserting at the end of this span, add the new text after it
        if (safeStart == spanEnd && text.isNotEmpty) {
          debugPrint("      -> Inserting text after this span");
          newSpans.add(MarkdownSpanValue(
            id: uuid(),
            value: text,
            properties: const [],
          ));
        }
      } else if (safeStart == safeEnd &&
          safeStart == spanStart &&
          text.isNotEmpty) {
        // Special case: inserting at the exact start of a span (e.g., paste at offset 0)
        debugPrint("      -> Inserting text before this span");
        newSpans.add(MarkdownSpanValue(
          id: uuid(),
          value: text,
          properties: const [],
        ));
        newSpans.add(span);
      } else {
        debugPrint("      -> Span overlaps with replacement");
        // Span overlaps with the replacement range
        // Split into: before, replacement, after

        // Before replacement (if any)
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
            properties: const [], // New text has no properties
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

    debugPrint("  After processing spans: newSpans.length=${newSpans.length}");
    for (var i = 0; i < newSpans.length; i++) {
      debugPrint("    newSpans[$i]: '${newSpans[i].value}'");
    }

    // If replacement is at the end or in an empty block, add the text without properties
    if (newSpans.isEmpty && text.isNotEmpty) {
      debugPrint("  Adding text to empty newSpans");
      newSpans.add(MarkdownSpanValue(
        id: uuid(),
        value: text,
        properties: const [],
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
              properties: const [],
            )
          ];

    // Create updated block with new spans
    final MarkdownBlockValue newBlock;
    if (targetBlock is MarkdownParagraphBlockValue) {
      newBlock = MarkdownParagraphBlockValue(
        id: targetBlock.id,
        children: [
          MarkdownLineValue(
            id: targetBlockChildren.isNotEmpty
                ? targetBlockChildren.first.id
                : uuid(),
            children: finalSpans,
          ),
        ],
      );
    } else {
      // BulletedList
      newBlock = MarkdownBulletedListBlockValue(
        id: targetBlock.id,
        children: [
          MarkdownLineValue(
            id: targetBlockChildren.isNotEmpty
                ? targetBlockChildren.first.id
                : uuid(),
            children: finalSpans,
          ),
        ],
      );
    }

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

  /// Checks if the document can be redone.
  ///
  /// ドキュメントがやり直し可能かどうかを確認します。
  bool get canRedo => _redoStack.isNotEmpty;

  /// Checks if the document can be undone.
  ///
  /// ドキュメントが元に戻し可能かどうかを確認します。
  bool get canUndo => _undoStack.isNotEmpty;

  /// Redoes the document.
  ///
  /// ドキュメントをやり直します。
  void redo() {
    if (!canRedo) {
      return;
    }

    // Set flag to prevent history saves during redo
    _isUndoRedoInProgress = true;

    try {
      // Cancel any pending history saves
      _historyDebounceTimer?.cancel();
      _hasPendingHistorySave = false;

      // Save current state to undo stack (deep copy with cursor position)
      final currentFieldValuesCopy = _deepCopyFieldValues(_value);
      final currentCursorPosition = _field?._selection.baseOffset ?? 0;
      final currentSnapshot = _HistorySnapshot(
        fieldValues: currentFieldValuesCopy,
        cursorPosition: currentCursorPosition,
      );
      _undoStack.add(currentSnapshot);

      // Restore from redo stack
      final snapshot = _redoStack.removeLast();
      _value.clear();
      _value.addAll(snapshot.fieldValues);

      // Restore cursor position from snapshot and clear IME state
      if (_field != null) {
        final restoredPosition =
            snapshot.cursorPosition.clamp(0, getPlainText().length);
        _field!._selection = TextSelection.collapsed(offset: restoredPosition);
        _field!.clearComposingState(); // Clear IME composing state
        _field!._updateRemoteEditingValue();
      }

      notifyListeners();
    } finally {
      // Reset flag
      _isUndoRedoInProgress = false;
    }
  }

  /// Undoes the document.
  ///
  /// ドキュメントを元に戻します。
  void undo() {
    // If there are pending changes, save them first
    if (_hasPendingHistorySave) {
      _historyDebounceTimer?.cancel();
      _saveToUndoStackImmediate();
    }

    if (!canUndo) {
      return;
    }

    // Set flag to prevent history saves during undo
    _isUndoRedoInProgress = true;

    try {
      // Cancel any pending history saves
      _historyDebounceTimer?.cancel();
      _hasPendingHistorySave = false;

      final currentCursorPosition = _field?._selection.baseOffset ?? 0;

      // Save current state to redo stack (deep copy with cursor position)
      final currentFieldValuesCopy = _deepCopyFieldValues(_value);
      final currentSnapshot = _HistorySnapshot(
        fieldValues: currentFieldValuesCopy,
        cursorPosition: currentCursorPosition,
      );
      _redoStack.add(currentSnapshot);

      // Restore from undo stack
      final snapshot = _undoStack.removeLast();
      _value.clear();
      _value.addAll(snapshot.fieldValues);

      // Restore cursor position from snapshot and clear IME state
      if (_field != null) {
        final textLength = getPlainText().length;
        final restoredPosition = snapshot.cursorPosition.clamp(0, textLength);
        _field!._selection = TextSelection.collapsed(offset: restoredPosition);
        _field!.clearComposingState(); // Clear IME composing state
        _field!._updateRemoteEditingValue();
      }

      notifyListeners();
    } finally {
      // Reset flag
      _isUndoRedoInProgress = false;
    }
  }

  /// Checks if the block can be increased indent.
  ///
  /// ブロックがインデントを増やすことができるかどうかを確認します。
  bool get canIncreaseIndent {
    if (_field == null) {
      debugPrint("🔍 canIncreaseIndent: _field == null");
      return false;
    }

    final selection = _field!._selection;
    if (!selection.isValid) {
      debugPrint("🔍 canIncreaseIndent: selection.isValid == false");
      return false;
    }

    if (_value.isEmpty) {
      debugPrint("🔍 canIncreaseIndent: _value.isEmpty");
      return false;
    }

    final field = _value.first;
    final blocks = field.children;

    if (blocks.isEmpty) {
      debugPrint("🔍 canIncreaseIndent: blocks.isEmpty");
      return false;
    }

    // Find which blocks are selected
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);
    debugPrint("🔍 canIncreaseIndent: selectedBlocks=$selectedBlocks");
    if (selectedBlocks.isEmpty) {
      debugPrint("🔍 canIncreaseIndent: selectedBlocks.isEmpty");
      return false;
    }

    // Check if any selected block can increase indent (max indent is 5)
    for (final blockIndex in selectedBlocks) {
      if (blockIndex >= blocks.length) {
        continue;
      }
      final block = blocks[blockIndex];
      debugPrint(
          "🔍 canIncreaseIndent: block[$blockIndex]=${block.runtimeType}, indent=${block.indent}");
      if (block.indent < 5) {
        debugPrint("✅ canIncreaseIndent: true");
        return true;
      }
    }

    debugPrint("❌ canIncreaseIndent: false (all blocks have indent >= 5)");
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
    _saveToUndoStack(immediate: true);

    final selection = _field!._selection;
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Find which blocks are selected
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);

    // Increase indent for all selected blocks
    for (final blockIndex in selectedBlocks) {
      if (blockIndex < blocks.length) {
        final block = blocks[blockIndex];
        if (block.indent < 5) {
          if (block is MarkdownParagraphBlockValue) {
            blocks[blockIndex] = block.copyWith(indent: block.indent + 1);
          } else if (block is MarkdownBulletedListBlockValue) {
            blocks[blockIndex] = block.copyWith(indent: block.indent + 1);
          }
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
    _saveToUndoStack(immediate: true);

    final selection = _field!._selection;
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Find which blocks are selected
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);

    // Decrease indent for all selected blocks
    for (final blockIndex in selectedBlocks) {
      if (blockIndex < blocks.length) {
        final block = blocks[blockIndex];
        if (block.indent > 0) {
          if (block is MarkdownParagraphBlockValue) {
            blocks[blockIndex] = block.copyWith(indent: block.indent - 1);
          } else if (block is MarkdownBulletedListBlockValue) {
            blocks[blockIndex] = block.copyWith(indent: block.indent - 1);
          }
        }
      }
    }

    // Update the field
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

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
      List<MarkdownLineValue>? blockChildren;

      if (block is MarkdownParagraphBlockValue) {
        blockChildren = block.children;
      } else if (block is MarkdownBulletedListBlockValue) {
        blockChildren = block.children;
      }

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

  /// Inserts a block at the specified offset.
  ///
  /// 指定されたオフセット位置にブロックを挿入します。
  void insertBlock(MarkdownBlockTools tool, {int? offset}) {
    if (_field == null) {
      return;
    }

    // Save current state before modification
    if (!_isUndoRedoInProgress) {
      debugPrint("💾 insertBlock: Saving to undo stack");
      _saveToUndoStack(immediate: true);
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
    MarkdownBlockValue newBlock;

    if (tool is BulletedListAddMarkdownBlockTools) {
      newBlock = MarkdownBulletedListBlockValue(
        id: uuid(),
        children: [
          MarkdownLineValue(
            id: uuid(),
            children: [
              MarkdownSpanValue(
                id: uuid(),
                value: "",
              ),
            ],
          ),
        ],
      );
    } else {
      // Default to paragraph block
      newBlock = MarkdownParagraphBlockValue(
        id: uuid(),
        children: [
          MarkdownLineValue(
            id: uuid(),
            children: [
              MarkdownSpanValue(
                id: uuid(),
                value: "",
              ),
            ],
          ),
        ],
      );
    }

    // Insert the new block
    blocks.insert(insertionIndex, newBlock);

    // Update field
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    debugPrint("📦 insertBlock: Created new block at index $insertionIndex");
    debugPrint("   Total blocks: ${blocks.length}");
    debugPrint("   New block type: ${newBlock.type}");

    // Move cursor to the beginning of the new block (inside the block, not before it)
    if (_field != null) {
      var newCursorPosition = 0;
      // Calculate position up to (but not including) the new block
      for (var i = 0; i < insertionIndex; i++) {
        newCursorPosition +=
            _getBlockTextLength(blocks[i]) + 1; // +1 for newline
      }
      // Now newCursorPosition points to the start of the new block
      // No need to add anything - we want the cursor at position 0 within the new block

      debugPrint("   Setting cursor position to: $newCursorPosition");
      debugPrint("   Total text length: ${getPlainText().length}");

      _field!._selection = TextSelection.collapsed(offset: newCursorPosition);
    }

    // Check input connection state before notifyListeners
    final hasConnectionBefore = _field?._hasInputConnection ?? false;
    debugPrint(
        "📢 Before notifyListeners: _hasInputConnection=$hasConnectionBefore");

    // Notify listeners first to update UI state
    notifyListeners();

    // Check input connection state after notifyListeners
    final hasConnectionAfter = _field?._hasInputConnection ?? false;
    debugPrint(
        "📢 After notifyListeners: _hasInputConnection=$hasConnectionAfter");

    // Reopen IME connection after block insertion
    // This is needed because the toolbar hides the keyboard when showing block menu
    // which detaches the TextInputClient without closing the connection
    debugPrint("⌨️ Reopening input connection after block insertion");
    if (_field != null) {
      _field!.reopenInputConnection();
      final hasConnectionAfterReopen = _field!._hasInputConnection;
      debugPrint(
          "📢 After reopenInputConnection: _hasInputConnection=$hasConnectionAfterReopen");
    } else {
      debugPrint("⚠️ _field is null, cannot reopen input connection");
    }
  }

  /// Exchanges a block at the specified index.
  ///
  /// 指定されたインデックスのブロックを交換します。
  void exchangeBlock(MarkdownBlockTools tool, {int? index}) {
    if (_field == null) {
      return;
    }

    // Save current state before modification
    if (!_isUndoRedoInProgress) {
      debugPrint("💾 exchangeBlock: Saving to undo stack");
      _saveToUndoStack(immediate: true);
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
    MarkdownBlockValue newBlock;

    if (tool is BulletedListExchangeMarkdownBlockTools ||
        tool is BulletedListAddMarkdownBlockTools) {
      // Convert to BulletedList
      if (targetBlock is MarkdownParagraphBlockValue) {
        newBlock = MarkdownBulletedListBlockValue(
          id: targetBlock.id,
          children: targetBlock.children,
          indent: targetBlock.indent,
        );
      } else if (targetBlock is MarkdownBulletedListBlockValue) {
        // Already a bulleted list, no change needed
        return;
      } else {
        return;
      }
    } else if (tool is TextExchangeMarkdownBlockTools) {
      // Convert to Text (Paragraph)
      if (targetBlock is MarkdownBulletedListBlockValue) {
        newBlock = MarkdownParagraphBlockValue(
          id: targetBlock.id,
          children: targetBlock.children,
          indent: targetBlock.indent,
        );
      } else if (targetBlock is MarkdownParagraphBlockValue) {
        // Already a paragraph, no change needed
        return;
      } else {
        return;
      }
    } else {
      return;
    }

    // Replace the block
    blocks[targetBlockIndex] = newBlock;

    // Update field
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    debugPrint("🔄 exchangeBlock→${newBlock.runtimeType}");
    notifyListeners();
  }

  /// Changes the inline text at the specified start and end positions.
  ///
  /// 指定された開始位置と終了位置のインラインテキストを変更します。
  void addInlineProperty(MarkdownPropertyTools tool,
      {int? start, int? end, Object? value, bool skipHistory = false}) {
    if (_field == null) {
      return;
    }

    // Save current state before modification
    if (!_isUndoRedoInProgress && !skipHistory) {
      debugPrint("💾 addInlineProperty: Saving to undo stack");
      _saveToUndoStack(immediate: true);
    }

    // If there's composing text, just clear it
    // The text is already in the controller, no need to replace
    if (_field!.composingText != null) {
      debugPrint("🎨 addInlineProperty: clearing composing state");
      debugPrint("  composingText: '${_field!.composingText}'");
      debugPrint("  controller text: '${getPlainText()}'");

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
      if (block is MarkdownParagraphBlockValue) {
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
    if (!_isUndoRedoInProgress) {
      debugPrint("💾 removeInlineProperty: Saving to undo stack");
      _saveToUndoStack(immediate: true);
    }

    // If there's composing text, just clear it
    // The text is already in the controller, no need to replace
    if (_field!.composingText != null) {
      debugPrint("🎨 removeInlineProperty: clearing composing state");
      debugPrint("  composingText: '${_field!.composingText}'");
      debugPrint("  controller text: '${getPlainText()}'");

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
      if (block is MarkdownParagraphBlockValue) {
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
      if (block is MarkdownParagraphBlockValue) {
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

  /// Gets the text length of a block.
  ///
  /// ブロックのテキストの長さを取得します。
  int _getBlockTextLength(MarkdownBlockValue block) {
    if (block is MarkdownParagraphBlockValue) {
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
    } else if (block is MarkdownBulletedListBlockValue) {
      // For bulleted lists, calculate text length WITHOUT the marker
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

  /// Unselects the text.
  ///
  /// テキストの選択を解除します。
  void unselect() {
    notifyListeners();
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
      if (block is MarkdownParagraphBlockValue) {
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

  /// Copies the selected text to clipboard.
  ///
  /// 選択されたテキストをクリップボードにコピーします。
  Future<void> copy() async {
    if (_field == null) {
      return;
    }

    final selection = _field!._selection;

    if (!selection.isValid || selection.isCollapsed) {
      return;
    }

    // Get text including composing text during IME input
    final text = _field!.composingText ?? getPlainText();

    // Validate selection range
    if (selection.end > text.length) {
      return;
    }

    final selectedText = selection.textInside(text);

    if (selectedText.isNotEmpty) {
      // Extract spans with their properties
      final extractedSpans =
          _extractSpansFromSelection(selection.start, selection.end);

      // Check if entire block is selected
      final blockInfo = _isFullBlockSelected(selection.start, selection.end);
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
      _field!._selection = TextSelection.collapsed(offset: selection.end);
      _field!._updateRemoteEditingValue();
      notifyListeners();
    }
  }

  /// Cuts the selected text to clipboard and removes it.
  ///
  /// 選択されたテキストをクリップボードに切り取り、削除します。
  Future<void> cut() async {
    if (_field == null) {
      return;
    }

    // If there's composing text, commit it first before cutting
    if (_field!.composingText != null) {
      final composingText = _field!.composingText!;
      final currentText = getPlainText();

      // Commit the composing text to controller
      replaceText(0, currentText.length, composingText);

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

    // Get text including composing text during IME input
    final text = _field!.composingText ?? getPlainText();

    // Validate selection range
    if (selection.end > text.length) {
      return;
    }

    final selectedText = selection.textInside(text);

    if (selectedText.isNotEmpty) {
      // Extract spans with their properties
      // IMPORTANT: Must be done BEFORE replaceText, as replaceText may merge spans
      final extractedSpans =
          _extractSpansFromSelection(selection.start, selection.end);

      // Check if entire block is selected
      final blockInfo = _isFullBlockSelected(selection.start, selection.end);
      final blockType =
          (blockInfo?.isFullBlock ?? false) ? blockInfo?.blockType : null;

      // Store in internal clipboard with block information
      _internalClipboard = _ClipboardData(
        spans: extractedSpans,
        blockType: blockType,
      );

      debugPrint(
          "🔪 cut: Extracted ${extractedSpans.length} spans to internal clipboard");
      debugPrint("  Block type: ${blockType ?? 'none (partial selection)'}");
      for (var i = 0; i < extractedSpans.length; i++) {
        final span = extractedSpans[i];
        debugPrint(
            "  span[$i]: '${span.value}' with ${span.properties.length} properties");
        for (var prop in span.properties) {
          debugPrint("    - ${prop.type}");
        }
      }

      // Also copy plain text to system clipboard for external paste
      await Clipboard.setData(ClipboardData(text: selectedText));

      // Save current state before modification (replaceText will also save, so we skip it here)
      // Delete the selected text
      replaceText(selection.start, selection.end, "");

      // Update selection to collapsed at start position
      _field!._selection = TextSelection.collapsed(offset: selection.start);
      _field!._updateRemoteEditingValue();
    }
  }

  /// Pastes text from clipboard at the cursor position.
  ///
  /// クリップボードからカーソル位置にテキストをペーストします。
  Future<void> paste() async {
    if (_field == null) {
      return;
    }

    debugPrint("📋 paste() called");
    debugPrint("  Current selection: ${_field!._selection}");
    debugPrint("  Current text: '${getPlainText()}'");
    debugPrint("  composingText: '${_field!.composingText ?? 'null'}'");

    // If there's composing text, just clear it
    // The text is already in the controller, no need to replace
    if (_field!.composingText != null) {
      debugPrint("  Clearing composing state before paste");
      // Clear composing state
      _field!._composingText = null;
      _field!._composingRegion = null;

      // Keep the current selection
      _field!._updateRemoteEditingValue();
    }

    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

    if (clipboardData == null || clipboardData.text == null) {
      debugPrint("  No clipboard data");
      return;
    }

    final text = clipboardData.text!;
    debugPrint("  Clipboard text: '$text'");

    if (text.isEmpty) {
      debugPrint("  Clipboard text is empty");
      return;
    }

    final selection = _field!._selection;

    if (!selection.isValid) {
      debugPrint("  Selection is invalid");
      return;
    }

    // If there's a selection, replace it with pasted text
    // If cursor is collapsed, insert at cursor position
    final start = selection.start;
    final end = selection.end;
    debugPrint("  Pasting at position $start-$end");

    // Check if the pasted text contains newlines
    if (text.contains("\n")) {
      // Split by newlines and insert them one by one
      final lines = text.split("\n");

      // First, delete the selected text if any
      if (end > start) {
        replaceText(start, end, "");
      }

      var currentOffset = start;

      // Insert first line at the cursor position
      if (lines.isNotEmpty && lines.first.isNotEmpty) {
        replaceText(currentOffset, currentOffset, lines.first);
        currentOffset += lines.first.length;
      }

      // For each additional line, insert a new paragraph
      for (var i = 1; i < lines.length; i++) {
        insertNewLine(currentOffset);
        currentOffset++; // Account for the newline character

        if (lines[i].isNotEmpty) {
          replaceText(currentOffset, currentOffset, lines[i]);
          currentOffset += lines[i].length;
        }
      }

      // Update cursor position to the end of pasted text
      _field!._selection = TextSelection.collapsed(offset: currentOffset);
    } else {
      // Normal text paste without newlines
      // Check if we have internal clipboard data with properties
      if (_internalClipboard != null && _internalClipboard!.spans.isNotEmpty) {
        debugPrint(
            "  Using internal clipboard with ${_internalClipboard!.spans.length} spans");
        debugPrint("  Block type: ${_internalClipboard!.blockType ?? 'none'}");

        // If clipboard has block type information, create a new block
        if (_internalClipboard!.blockType != null) {
          debugPrint(
              "  Creating new block with type: ${_internalClipboard!.blockType}");
          _pasteAsBlock(start, end, _internalClipboard!.spans,
              _internalClipboard!.blockType!);
        } else {
          // Restore spans with their properties (partial selection)
          _pasteSpansWithProperties(start, end, _internalClipboard!.spans);
        }
      } else {
        debugPrint("  Using plain text paste");
        // Plain text paste (from external clipboard or no properties)
        replaceText(start, end, text);
      }

      // Update cursor position to the end of pasted text
      final newCursorPosition = start + text.length;
      _field!._selection = TextSelection.collapsed(offset: newCursorPosition);
    }

    _field!._updateRemoteEditingValue();
    notifyListeners();
  }

  /// Pastes spans with their properties at the specified position.
  ///
  /// 指定された位置にプロパティ付きのスパンをペーストします。
  void _pasteSpansWithProperties(
    int start,
    int end,
    List<MarkdownSpanValue> spans,
  ) {
    if (_value.isEmpty) {
      return;
    }

    // Save current state before modification
    _saveToUndoStack(immediate: true);

    final field = _value.first;
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
        currentOffset += _getBlockTextLength(block) + 1;
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
      replaceText(start, end, "");
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
    _value[0] = newField;
    notifyListeners();
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
    if (_value.isEmpty) {
      return;
    }

    // Save current state before modification
    _saveToUndoStack(immediate: true);

    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // Delete selected text if any
    if (end > start) {
      replaceText(start, end, "");
    }

    // Find the block index where we should insert the new block
    var currentOffset = 0;
    var insertAtBlockIndex = 0;

    for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
      final block = blocks[blockIndex];
      final blockLength = _getBlockTextLength(block);
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
    _value[0] = newField;
    notifyListeners();
  }

  /// Inserts a new paragraph block at the specified offset.
  ///
  /// 指定されたオフセット位置に新しい段落ブロックを挿入します。
  void insertNewLine(int offset) {
    debugPrint("⏎ insertNewLine called at offset: $offset");
    // Save current state before modification (immediate for explicit actions)
    _saveToUndoStack(immediate: true);

    if (_value.isEmpty) {
      debugPrint("  → Empty value, creating initial paragraph");
      // Create initial structure with empty paragraph
      final field = MarkdownFieldValue(
        id: uuid(),
        children: [
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: "",
                  ),
                ],
              ),
            ],
          ),
        ],
      );
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
      if (block is MarkdownParagraphBlockValue ||
          block is MarkdownBulletedListBlockValue) {
        final blockText = StringBuffer();

        // Extract children based on block type
        List<MarkdownLineValue> blockChildren;
        if (block is MarkdownParagraphBlockValue) {
          blockChildren = block.children;
        } else if (block is MarkdownBulletedListBlockValue) {
          blockChildren = block.children;
        } else {
          blockChildren = [];
        }

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
          debugPrint("  → Found block to split at index $i");
          debugPrint("     Block type: ${block.runtimeType}");
          debugPrint("     Text before cursor: '$textBeforeCursor'");
          debugPrint("     Text after cursor: '$textAfterCursor'");
          break;
        }

        currentOffset += blockLength;
      }
    }

    if (blockIndex == -1) {
      debugPrint("  → Cursor at end, creating new block after last block");
      // Offset is at the end, create new block
      // Check the type of the last block to inherit it for BulletedList
      final MarkdownBlockValue newBlock;
      if (blocks.isNotEmpty) {
        final lastBlock = blocks.last;
        debugPrint("     Last block type: ${lastBlock.runtimeType}");

        if (lastBlock is MarkdownBulletedListBlockValue) {
          debugPrint(
              "  → Creating new BulletedList block (inheriting from last block, indent=${lastBlock.indent})");
          newBlock = MarkdownBulletedListBlockValue(
            id: uuid(),
            indent: lastBlock.indent, // Inherit indent level
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: "",
                  ),
                ],
              ),
            ],
          );
        } else {
          debugPrint("  → Creating new Paragraph block (default)");
          newBlock = MarkdownParagraphBlockValue(
            id: uuid(),
            children: [
              MarkdownLineValue(
                id: uuid(),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: "",
                  ),
                ],
              ),
            ],
          );
        }
      } else {
        debugPrint("  → No blocks exist, creating Paragraph block");
        newBlock = MarkdownParagraphBlockValue(
          id: uuid(),
          children: [
            MarkdownLineValue(
              id: uuid(),
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "",
                ),
              ],
            ),
          ],
        );
      }
      blocks.add(newBlock);
    } else {
      // Split the current block
      final oldBlock = blocks[blockIndex];

      // Extract children based on block type
      List<MarkdownLineValue> oldBlockChildren;
      if (oldBlock is MarkdownParagraphBlockValue) {
        oldBlockChildren = oldBlock.children;
      } else if (oldBlock is MarkdownBulletedListBlockValue) {
        oldBlockChildren = oldBlock.children;
      } else {
        oldBlockChildren = [];
      }

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
      final MarkdownBlockValue beforeBlock;
      if (oldBlock is MarkdownParagraphBlockValue) {
        beforeBlock = MarkdownParagraphBlockValue(
          id: oldBlock.id,
          children: [
            MarkdownLineValue(
              id: uuid(),
              children: beforeSpans,
            ),
          ],
        );
      } else if (oldBlock is MarkdownBulletedListBlockValue) {
        beforeBlock = MarkdownBulletedListBlockValue(
          id: oldBlock.id,
          indent: oldBlock.indent, // Preserve indent level
          children: [
            MarkdownLineValue(
              id: uuid(),
              children: beforeSpans,
            ),
          ],
        );
      } else {
        // Fallback to paragraph
        beforeBlock = MarkdownParagraphBlockValue(
          id: oldBlock.id,
          children: [
            MarkdownLineValue(
              id: uuid(),
              children: beforeSpans,
            ),
          ],
        );
      }

      // Create new block with text after cursor
      // For BulletedList blocks, inherit the block type and indent level
      // For other blocks, create a paragraph
      final MarkdownBlockValue afterBlock;
      if (oldBlock is MarkdownBulletedListBlockValue) {
        debugPrint(
            "  → Creating new BulletedList block (inheriting block type and indent=${oldBlock.indent})");
        // Inherit BulletedList block type and indent level on new line
        afterBlock = MarkdownBulletedListBlockValue(
          id: uuid(),
          indent: oldBlock.indent, // Inherit indent level
          children: [
            MarkdownLineValue(
              id: uuid(),
              children: afterSpans,
            ),
          ],
        );
      } else {
        debugPrint("  → Creating new Paragraph block (default)");
        // Default to paragraph
        afterBlock = MarkdownParagraphBlockValue(
          id: uuid(),
          children: [
            MarkdownLineValue(
              id: uuid(),
              children: afterSpans,
            ),
          ],
        );
      }
      debugPrint("  → afterBlock type: ${afterBlock.runtimeType}");

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
        if (block is MarkdownParagraphBlockValue) {
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
        } else if (block is MarkdownBulletedListBlockValue) {
          // For bulleted lists, return text WITHOUT the marker
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

  /// Callback for when a link should be shown in a dialog.
  ///
  /// リンクをダイアログに表示する必要があるときのコールバック。
  void Function(String url)? _onShowLinkDialog;

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

  /// Checks if the cursor is at the end of a link and returns the link range.
  /// Used to implement link deletion behavior (select link on first backspace).
  ///
  /// カーソルがリンクの末尾にあるかチェックし、リンクの範囲を返します。
  /// リンク削除の挙動（最初のBackspaceでリンクを選択）を実装するために使用されます。
  TextRange? getLinkRangeBeforeCursor(int cursorOffset) {
    debugPrint(
        "🔎 getLinkRangeBeforeCursor: cursorOffset=$cursorOffset, _value.isEmpty=${_value.isEmpty}");
    if (_value.isEmpty || cursorOffset <= 0) {
      debugPrint("   → Returning null: empty value or invalid offset");
      return null;
    }

    // Check if the position just before the cursor is inside a link
    final checkOffset = cursorOffset - 1;
    debugPrint("   checkOffset=$checkOffset (cursorOffset - 1)");
    var currentOffset = 0;
    String? targetLinkUrl;
    int? linkStart;
    int? linkEnd;

    // Traverse through the markdown structure
    for (final fieldValue in _value) {
      final blocks = fieldValue.children;
      debugPrint("   Checking ${blocks.length} blocks");
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownParagraphBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          debugPrint("   Block $blockIndex: ${lines.length} lines");
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            debugPrint("      Line $lineIndex: ${line.children.length} spans");
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;
              debugPrint(
                  "         Span: '${span.value}' (start=$spanStart, end=$spanEnd)");

              // Check if checkOffset is within this span
              if (checkOffset >= spanStart && checkOffset < spanEnd) {
                debugPrint(
                    "         → checkOffset $checkOffset is in this span");
                // Check if this span has a link property
                for (final property in span.properties) {
                  if (property is LinkMarkdownSpanProperty) {
                    targetLinkUrl = property.link;
                    debugPrint("         → Found link: $targetLinkUrl");
                    break;
                  }
                }
                if (targetLinkUrl != null) {
                  break;
                } else {
                  debugPrint("         → No link property");
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
      debugPrint("   → No link found at checkOffset");
      return null;
    }
    debugPrint("   → Found link URL: $targetLinkUrl");

    // Second pass: find the full range of consecutive spans with the same link URL
    currentOffset = 0;
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

  /// Get the range of a mention immediately before the cursor.
  ///
  /// カーソルの直前にあるメンションの範囲を取得します。
  TextRange? getMentionRangeBeforeCursor(int cursorOffset) {
    debugPrint(
        "🔎 getMentionRangeBeforeCursor: cursorOffset=$cursorOffset, _value.isEmpty=${_value.isEmpty}");
    if (_value.isEmpty || cursorOffset <= 0) {
      debugPrint("   → Returning null: empty value or invalid offset");
      return null;
    }

    // Check if the position just before the cursor is inside a mention
    final checkOffset = cursorOffset - 1;
    debugPrint("   checkOffset=$checkOffset (cursorOffset - 1)");
    var currentOffset = 0;
    MarkdownMention? targetMention;
    int? mentionStart;
    int? mentionEnd;

    // Traverse through the markdown structure
    for (final fieldValue in _value) {
      final blocks = fieldValue.children;
      debugPrint("   Checking ${blocks.length} blocks");
      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final blockValue = blocks[blockIndex];
        if (blockValue is MarkdownParagraphBlockValue) {
          final paragraphBlock = blockValue;
          final lines = paragraphBlock.children;
          debugPrint("   Block $blockIndex: ${lines.length} lines");
          for (var lineIndex = 0; lineIndex < lines.length; lineIndex++) {
            final line = lines[lineIndex];
            debugPrint("      Line $lineIndex: ${line.children.length} spans");
            for (final span in line.children) {
              final spanLength = span.value.length;
              final spanStart = currentOffset;
              final spanEnd = currentOffset + spanLength;
              debugPrint(
                  "         Span: '${span.value}' (start=$spanStart, end=$spanEnd)");

              // Check if checkOffset is within this span
              if (checkOffset >= spanStart && checkOffset < spanEnd) {
                debugPrint(
                    "         → checkOffset $checkOffset is in this span");
                // Check if this span has a mention property
                for (final property in span.properties) {
                  if (property is MentionMarkdownSpanProperty) {
                    targetMention = property.mention;
                    debugPrint("         → Found mention: ${targetMention.id}");
                    break;
                  }
                }
                if (targetMention != null) {
                  break;
                } else {
                  debugPrint("         → No mention property");
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
      debugPrint("   → No mention found at checkOffset");
      return null;
    }
    debugPrint("   → Found mention ID: ${targetMention.id}");

    // Second pass: find the full range of consecutive spans with the same mention
    currentOffset = 0;
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

  @override
  void dispose() {
    // Cancel any pending history saves
    _historyDebounceTimer?.cancel();
    _historyDebounceTimer = null;
    _hasPendingHistorySave = false;

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
