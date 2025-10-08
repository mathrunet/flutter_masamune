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

  /// Undo history stack (stored as deep copied MarkdownFieldValue objects).
  ///
  /// 元に戻す履歴スタック（ディープコピーされたMarkdownFieldValueオブジェクトとして保存）。
  final List<List<MarkdownFieldValue>> _undoStack = [];

  /// Redo history stack (stored as deep copied MarkdownFieldValue objects).
  ///
  /// やり直す履歴スタック（ディープコピーされたMarkdownFieldValueオブジェクトとして保存）。
  final List<List<MarkdownFieldValue>> _redoStack = [];

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
    final snapshot = _deepCopyFieldValues(_value);

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
  void replaceText(int start, int end, String text) {
    // Skip history saving during undo/redo operations
    if (!_isUndoRedoInProgress) {
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
        property: const MarkdownFieldProperty(
          backgroundColor: null,
          foregroundColor: null,
        ),
        children: [
          MarkdownParagraphBlockValue(
            id: uuid(),
            property: const MarkdownBlockProperty(
              backgroundColor: null,
              foregroundColor: null,
            ),
            children: [
              MarkdownLineValue(
                id: uuid(),
                property: const MarkdownLineProperty(
                  backgroundColor: null,
                  foregroundColor: null,
                ),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: text,
                    property: const MarkdownSpanProperty(
                      backgroundColor: null,
                      foregroundColor: null,
                    ),
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

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
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
        final lastBlock = blocks[endBlockIndex] as MarkdownParagraphBlockValue;
        final lastBlockText = StringBuffer();
        for (final line in lastBlock.children) {
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
        property: const MarkdownBlockProperty(
          backgroundColor: null,
          foregroundColor: null,
        ),
        children: [
          MarkdownLineValue(
            id: uuid(),
            property: const MarkdownLineProperty(
              backgroundColor: null,
              foregroundColor: null,
            ),
            children: [
              MarkdownSpanValue(
                id: uuid(),
                value: text,
                property: const MarkdownSpanProperty(
                  backgroundColor: null,
                  foregroundColor: null,
                ),
              ),
            ],
          ),
        ],
      );
      blocks.add(newBlock);

      final newField = MarkdownFieldValue(
        id: field.id,
        property: field.property,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // If selection spans multiple blocks, merge them
    if (startBlockIndex != endBlockIndex) {
      // Get text before start in start block
      final startBlock = blocks[startBlockIndex] as MarkdownParagraphBlockValue;
      final startBlockText = StringBuffer();
      for (final line in startBlock.children) {
        for (final span in line.children) {
          startBlockText.write(span.value);
        }
      }
      final startBlockTextStr = startBlockText.toString();
      final safeLocalStart = localStart.clamp(0, startBlockTextStr.length);
      final textBeforeStart = startBlockTextStr.substring(0, safeLocalStart);

      // Get text after end in end block
      final endBlock = blocks[endBlockIndex] as MarkdownParagraphBlockValue;
      final endBlockText = StringBuffer();
      for (final line in endBlock.children) {
        for (final span in line.children) {
          endBlockText.write(span.value);
        }
      }
      final endBlockTextStr = endBlockText.toString();
      final safeLocalEnd = localEnd.clamp(0, endBlockTextStr.length);
      final textAfterEnd = endBlockTextStr.substring(safeLocalEnd);

      // Merge: text before start + inserted text + text after end
      final mergedText = textBeforeStart + text + textAfterEnd;

      // If merged text is empty, just remove the blocks without creating a new one
      if (mergedText.isEmpty && text.isEmpty) {
        // Remove blocks from startBlockIndex to endBlockIndex (inclusive)
        blocks.removeRange(startBlockIndex, endBlockIndex + 1);

        // If all blocks were removed, create an empty block
        if (blocks.isEmpty) {
          blocks.add(MarkdownParagraphBlockValue(
            id: uuid(),
            property: const MarkdownBlockProperty(
              backgroundColor: null,
              foregroundColor: null,
            ),
            children: [
              MarkdownLineValue(
                id: uuid(),
                property: const MarkdownLineProperty(
                  backgroundColor: null,
                  foregroundColor: null,
                ),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: "",
                    property: const MarkdownSpanProperty(
                      backgroundColor: null,
                      foregroundColor: null,
                    ),
                  ),
                ],
              ),
            ],
          ));
        }
      } else {
        // Create new merged block
        final mergedBlock = MarkdownParagraphBlockValue(
          id: startBlock.id,
          property: startBlock.property,
          children: [
            MarkdownLineValue(
              id: uuid(),
              property: const MarkdownLineProperty(
                backgroundColor: null,
                foregroundColor: null,
              ),
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: mergedText,
                  property: const MarkdownSpanProperty(
                    backgroundColor: null,
                    foregroundColor: null,
                  ),
                ),
              ],
            ),
          ],
        );

        // Remove blocks from startBlockIndex to endBlockIndex (inclusive)
        blocks.removeRange(startBlockIndex, endBlockIndex + 1);

        // Insert merged block at startBlockIndex
        blocks.insert(startBlockIndex, mergedBlock);
      }

      // Update field
      final newField = MarkdownFieldValue(
        id: field.id,
        property: field.property,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // Single block edit
    final targetBlockIndex = startBlockIndex;

    // Update the target block
    final targetBlock = blocks[targetBlockIndex] as MarkdownParagraphBlockValue;

    // Get current text in the block
    final blockText = StringBuffer();
    for (var i = 0; i < targetBlock.children.length; i++) {
      final line = targetBlock.children[i];
      for (final span in line.children) {
        blockText.write(span.value);
      }
      if (i < targetBlock.children.length - 1) {
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
        property: field.property,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // Create new text
    final newText =
        oldText.substring(0, safeStart) + text + oldText.substring(safeEnd);

    // Create updated block with new text
    final newBlock = MarkdownParagraphBlockValue(
      id: targetBlock.id,
      property: targetBlock.property,
      children: [
        MarkdownLineValue(
          id: targetBlock.children.isNotEmpty
              ? targetBlock.children.first.id
              : uuid(),
          property: const MarkdownLineProperty(
            backgroundColor: null,
            foregroundColor: null,
          ),
          children: [
            MarkdownSpanValue(
              id: targetBlock.children.isNotEmpty &&
                      targetBlock.children.first.children.isNotEmpty
                  ? targetBlock.children.first.children.first.id
                  : uuid(),
              value: newText,
              property: const MarkdownSpanProperty(
                backgroundColor: null,
                foregroundColor: null,
              ),
            ),
          ],
        ),
      ],
    );

    // Update blocks list
    blocks[targetBlockIndex] = newBlock;

    // Update field
    final newField = MarkdownFieldValue(
      id: field.id,
      property: field.property,
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

      // Save current state to undo stack (deep copy)
      final currentSnapshot = _deepCopyFieldValues(_value);
      _undoStack.add(currentSnapshot);

      // Restore from redo stack
      final snapshot = _redoStack.removeLast();
      _value.clear();
      _value.addAll(snapshot);

      // Update selection to end of text
      if (_field != null) {
        final text = getPlainText();
        _field!._selection = TextSelection.collapsed(offset: text.length);
        _field!._composingRegion = null; // Clear composing region
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

      // Save current state to redo stack (deep copy)
      final currentSnapshot = _deepCopyFieldValues(_value);
      _redoStack.add(currentSnapshot);

      // Restore from undo stack
      final snapshot = _undoStack.removeLast();
      _value.clear();
      _value.addAll(snapshot);

      // Update selection to end of text
      if (_field != null) {
        final text = getPlainText();
        _field!._selection = TextSelection.collapsed(offset: text.length);
        _field!._composingRegion = null; // Clear composing region
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
  void insertBlock(MarkdownBlockTools tool, {int? offset}) {}

  /// Exchanges a block at the specified index.
  ///
  /// 指定されたインデックスのブロックを交換します。
  void exchangeBlock(MarkdownBlockTools block, {int? index}) {}

  /// Changes the inline text at the specified start and end positions.
  ///
  /// 指定された開始位置と終了位置のインラインテキストを変更します。
  void addInlineProperty(MarkdownInlineTools tool, {int? start, int? end}) {}

  /// Removes the inline property at the specified start and end positions.
  ///
  /// 指定された開始位置と終了位置のインラインプロパティを削除します。
  void removeInlineProperty(MarkdownInlineTools tool, {int? start, int? end}) {}

  /// Checks if the inline property exists at the specified start and end positions.
  ///
  /// 指定された開始位置と終了位置のインラインプロパティが存在するかどうかを確認します。
  bool hasInlineProperty(MarkdownInlineTools tool, {int? start, int? end}) =>
      false;

  /// Unselects the text.
  ///
  /// テキストの選択を解除します。
  void unselect() {
    notifyListeners();
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

    final text = getPlainText();
    final selectedText = selection.textInside(text);

    if (selectedText.isNotEmpty) {
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

    final selection = _field!._selection;
    if (!selection.isValid || selection.isCollapsed) {
      return;
    }

    final text = getPlainText();
    final selectedText = selection.textInside(text);

    if (selectedText.isNotEmpty) {
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

    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData == null || clipboardData.text == null) {
      return;
    }

    final text = clipboardData.text!;
    if (text.isEmpty) {
      return;
    }

    final selection = _field!._selection;
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
      replaceText(start, end, text);

      // Update cursor position to the end of pasted text
      _field!._selection = TextSelection.collapsed(offset: start + text.length);
    }

    _field!._updateRemoteEditingValue();
    notifyListeners();
  }

  /// Inserts a new paragraph block at the specified offset.
  ///
  /// 指定されたオフセット位置に新しい段落ブロックを挿入します。
  void insertNewLine(int offset) {
    // Save current state before modification (immediate for explicit actions)
    _saveToUndoStack(immediate: true);

    if (_value.isEmpty) {
      // Create initial structure with empty paragraph
      final field = MarkdownFieldValue(
        id: uuid(),
        property: const MarkdownFieldProperty(
          backgroundColor: null,
          foregroundColor: null,
        ),
        children: [
          MarkdownParagraphBlockValue(
            id: uuid(),
            property: const MarkdownBlockProperty(
              backgroundColor: null,
              foregroundColor: null,
            ),
            children: [
              MarkdownLineValue(
                id: uuid(),
                property: const MarkdownLineProperty(
                  backgroundColor: null,
                  foregroundColor: null,
                ),
                children: [
                  MarkdownSpanValue(
                    id: uuid(),
                    value: "",
                    property: const MarkdownSpanProperty(
                      backgroundColor: null,
                      foregroundColor: null,
                    ),
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
      // Offset is at the end, create new empty paragraph
      blocks.add(
        MarkdownParagraphBlockValue(
          id: uuid(),
          property: const MarkdownBlockProperty(
            backgroundColor: null,
            foregroundColor: null,
          ),
          children: [
            MarkdownLineValue(
              id: uuid(),
              property: const MarkdownLineProperty(
                backgroundColor: null,
                foregroundColor: null,
              ),
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "",
                  property: const MarkdownSpanProperty(
                    backgroundColor: null,
                    foregroundColor: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // Split the current block
      final oldBlock = blocks[blockIndex] as MarkdownParagraphBlockValue;

      // Create block with text before cursor
      final beforeBlock = MarkdownParagraphBlockValue(
        id: oldBlock.id,
        property: oldBlock.property,
        children: [
          MarkdownLineValue(
            id: uuid(),
            property: const MarkdownLineProperty(
              backgroundColor: null,
              foregroundColor: null,
            ),
            children: [
              MarkdownSpanValue(
                id: uuid(),
                value: textBeforeCursor!,
                property: const MarkdownSpanProperty(
                  backgroundColor: null,
                  foregroundColor: null,
                ),
              ),
            ],
          ),
        ],
      );

      // Create new block with text after cursor
      final afterBlock = MarkdownParagraphBlockValue(
        id: uuid(),
        property: oldBlock.property,
        children: [
          MarkdownLineValue(
            id: uuid(),
            property: const MarkdownLineProperty(
              backgroundColor: null,
              foregroundColor: null,
            ),
            children: [
              MarkdownSpanValue(
                id: uuid(),
                value: textAfterCursor!,
                property: const MarkdownSpanProperty(
                  backgroundColor: null,
                  foregroundColor: null,
                ),
              ),
            ],
          ),
        ],
      );

      // Replace old block with before and after blocks
      blocks[blockIndex] = beforeBlock;
      blocks.insert(blockIndex + 1, afterBlock);
    }

    // Update field with new blocks
    final newField = MarkdownFieldValue(
      id: field.id,
      property: field.property,
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

  @override
  void dispose() {
    // Cancel any pending history saves
    _historyDebounceTimer?.cancel();
    _historyDebounceTimer = null;
    _hasPendingHistorySave = false;

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
