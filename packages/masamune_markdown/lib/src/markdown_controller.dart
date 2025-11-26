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
  MarkdownController({
    super.adapter,
    List<MarkdownFieldValue>? initialValue,
    String? initialMarkdown,
    DynamicMap? initialJson,
  }) {
    if (initialValue != null) {
      _value.addAll(initialValue);
    }
    if (initialMarkdown != null) {
      importFromMarkdown(initialMarkdown);
    }
    if (initialJson != null) {
      importFromJson(initialJson);
    }
  }

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

  /// Get the plain text of the markdown controller.
  ///
  /// Indentation is applied.
  ///
  /// マークダウンコントローラーのプレーンテキストを取得します。
  ///
  /// インデントは適用されます。
  String get plainText =>
      _value._textBuilder(StringBuffer(), indent: true).toString();

  /// Get the plain text of the markdown controller.
  ///
  /// Indentation is not applied.
  ///
  /// マークダウンコントローラーのプレーンテキストを取得します。
  ///
  /// インデントは適用されません。
  String get rawText =>
      _value._textBuilder(StringBuffer(), indent: false).toString();

  /// History of clipboard of [MarkdownController].
  ///
  /// [MarkdownController]のクリップボード履歴。
  late final MarkdownClipboard clipboard = MarkdownClipboard._(this);

  /// History of [MarkdownController].
  ///
  /// [MarkdownController]の履歴。
  late final MarkdownHistory history = MarkdownHistory._(this);

  /// Get the selection of the markdown controller.
  ///
  /// マークダウンコントローラーの選択を取得します。
  TextSelection get selection =>
      _field?._selection ?? const TextSelection.collapsed(offset: 0);

  /// Set the selection of the markdown controller.
  ///
  /// マークダウンコントローラーの選択を設定します。
  void setSelection(TextSelection selection) {
    if (_field != null) {
      _field!._selection = selection;
      _field!._updateRemoteEditingValue();
    }
  }

  /// Get the current block at the specified offset or cursor position.
  ///
  /// 指定されたオフセットまたはカーソル位置にある現在のブロックを取得します。
  TValue? getCurrentBlock<TValue extends MarkdownBlockValue>({int? offset}) {
    if (_field == null) {
      return null;
    }

    if (_value.isEmpty) {
      return null;
    }

    // Determine target offset
    final targetOffset = offset ?? selection.baseOffset;

    // Get blocks (works for both single and multi-field)
    final blocks = _isSingleField ? _value.first.children : _getAllBlocks();

    if (blocks.isEmpty) {
      return null;
    }

    // Find block at offset
    var currentOffset = 0;

    for (final block in blocks) {
      final blockLength = _getBlockTextLength(block);
      final blockEnd = currentOffset + blockLength;

      if (targetOffset >= currentOffset && targetOffset <= blockEnd) {
        return block is TValue ? block : null;
      }

      currentOffset = blockEnd + 1; // +1 for newline between blocks
    }

    // If offset is beyond all blocks, return last block
    final lastBlock = blocks.last;
    return lastBlock is TValue ? lastBlock : null;
  }

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

  /// Import from markdown.
  ///
  /// マークダウンからインポートします。
  void importFromMarkdown(String markdown) {
    final field = MarkdownFieldValue.fromMarkdown(markdown);
    _value.clear();
    _value.add(field);
    notifyListeners();
  }

  /// Import from JSON.
  ///
  /// [DynamicMap]からインポートします。
  void importFromJson(DynamicMap json) {
    final field = MarkdownFieldValue.fromJson(json);
    _value.clear();
    _value.add(field);
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

    final blocks = _isSingleField ? _value.first.children : _getAllBlocks();

    if (blocks.isEmpty) {
      return false;
    }

    // 選択されているブロックを検索
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);
    if (selectedBlocks.isEmpty) {
      return false;
    }

    // 選択されたブロックのいずれかがインデントを増やせるかチェック
    // canIndent=falseのブロック（見出しなど）はインデントできない
    // 最大インデントは5
    for (final blockIndex in selectedBlocks) {
      if (blockIndex >= blocks.length) {
        continue;
      }
      final block = blocks[blockIndex];
      if (block.canIndent && block.indent < 5) {
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

    final blocks = _isSingleField ? _value.first.children : _getAllBlocks();

    if (blocks.isEmpty) {
      return false;
    }

    // 選択されているブロックを検索
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);
    if (selectedBlocks.isEmpty) {
      return false;
    }

    // 選択されたブロックのいずれかがインデントを減らせるかチェック
    // canIndent=falseのブロック（見出しなど）はインデントできない
    // 最小インデントは0
    for (final blockIndex in selectedBlocks) {
      if (blockIndex >= blocks.length) {
        continue;
      }
      final block = blocks[blockIndex];
      if (block.canIndent && block.indent > 0) {
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

    // 変更前に現在の状態を保存
    history.saveToUndoStack(immediate: true);

    // Single field: existing logic
    if (_isSingleField) {
      return _increaseIndentSingleField();
    }

    // Multiple fields: new logic
    return _increaseIndentMultiField();
  }

  void _increaseIndentSingleField() {
    final selection = _field!._selection;
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // 選択されているブロックを検索
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);

    // 選択されたすべてのブロックのインデントを増やす
    for (final blockIndex in selectedBlocks) {
      if (blockIndex < blocks.length) {
        final block = blocks[blockIndex];
        if (block.indent < adapter.maxIndentLevel && block.canIndent) {
          blocks[blockIndex] = block.copyWith(indent: block.indent + 1);
        }
      }
    }

    // フィールドを更新
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    notifyListeners();
  }

  void _increaseIndentMultiField() {
    final selection = _field!._selection;
    final allBlocks = _getAllBlocks();

    // 選択されているブロックを検索
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);

    // 選択されたすべてのブロックのインデントを増やす
    for (final blockIndex in selectedBlocks) {
      if (blockIndex < allBlocks.length) {
        final block = allBlocks[blockIndex];
        if (block.indent < adapter.maxIndentLevel && block.canIndent) {
          allBlocks[blockIndex] = block.copyWith(indent: block.indent + 1);
        }
      }
    }

    // Redistribute blocks across fields
    _updateBlocksAcrossFields(allBlocks);
    notifyListeners();
  }

  /// Decreases the indent of the block.
  ///
  /// ブロックのインデントを減らします。
  void decreaseIndent() {
    if (!canDecreaseIndent) {
      return;
    }

    // 変更前に現在の状態を保存
    history.saveToUndoStack(immediate: true);

    // Single field: existing logic
    if (_isSingleField) {
      return _decreaseIndentSingleField();
    }

    // Multiple fields: new logic
    return _decreaseIndentMultiField();
  }

  void _decreaseIndentSingleField() {
    final selection = _field!._selection;
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // 選択されているブロックを検索
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);

    // 選択されたすべてのブロックのインデントを減らす
    for (final blockIndex in selectedBlocks) {
      if (blockIndex < blocks.length) {
        final block = blocks[blockIndex];
        if (block.indent > 0 && block.canIndent) {
          blocks[blockIndex] = block.copyWith(indent: block.indent - 1);
        }
      }
    }

    // フィールドを更新
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    notifyListeners();
  }

  void _decreaseIndentMultiField() {
    final selection = _field!._selection;
    final allBlocks = _getAllBlocks();

    // 選択されているブロックを検索
    final selectedBlocks = _getSelectedBlocks(selection.start, selection.end);

    // 選択されたすべてのブロックのインデントを減らす
    for (final blockIndex in selectedBlocks) {
      if (blockIndex < allBlocks.length) {
        final block = allBlocks[blockIndex];
        if (block.indent > 0 && block.canIndent) {
          allBlocks[blockIndex] = block.copyWith(indent: block.indent - 1);
        }
      }
    }

    // Redistribute blocks across fields
    _updateBlocksAcrossFields(allBlocks);
    notifyListeners();
  }

  /// Inserts a block at the specified offset.
  ///
  /// 指定されたオフセット位置にブロックを挿入します。
  TValue? insertBlock<TValue extends MarkdownBlockValue>(TValue block,
      {int? offset}) {
    if (_field == null) {
      return null;
    }

    // 変更前に現在の状態を保存
    if (!history.inProgress) {
      history.saveToUndoStack(immediate: true);
    }

    // 有効な構造があることを確認
    if (_value.isEmpty) {
      _value.add(MarkdownFieldValue(
        id: uuid(),
        children: const [],
      ));
    }

    // 単一フィールドの場合：既存のロジック
    if (_isSingleField) {
      return _insertBlockSingleField<TValue>(block, offset);
    }

    // 複数フィールドの場合：新しいロジック
    return _insertBlockMultiField<TValue>(block, offset);
  }

  TValue? _insertBlockSingleField<TValue extends MarkdownBlockValue>(
      TValue block, int? offset) {
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // 挿入位置を決定
    int insertionIndex;
    if (offset != null) {
      // オフセットからブロックインデックスを検索
      var currentOffset = 0;
      insertionIndex = blocks.length; // デフォルトは末尾

      for (var i = 0; i < blocks.length; i++) {
        final currentBlock = blocks[i];
        final blockLength = _getBlockTextLength(currentBlock);
        final blockEnd = currentOffset + blockLength;

        if (offset >= currentOffset && offset <= blockEnd) {
          insertionIndex = i + 1; // このブロックの後に挿入
          break;
        }

        currentOffset = blockEnd + 1; // ブロック間の改行分+1
      }
    } else {
      // カーソル位置を使用
      final selection = _field!._selection;
      final cursorPosition = selection.baseOffset;

      var currentOffset = 0;
      insertionIndex = blocks.length; // デフォルトは末尾

      for (var i = 0; i < blocks.length; i++) {
        final currentBlock = blocks[i];
        final blockLength = _getBlockTextLength(currentBlock);
        final blockEnd = currentOffset + blockLength;

        if (cursorPosition >= currentOffset && cursorPosition <= blockEnd) {
          insertionIndex = i + 1; // 現在のブロックの後に挿入
          break;
        }

        currentOffset = blockEnd + 1; // ブロック間の改行分+1
      }
    }

    // ブロックを挿入
    blocks.insert(insertionIndex, block);

    // フィールドを更新
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    // 新しいブロックの先頭にカーソルを移動（ブロックの前ではなく、ブロック内）
    if (_field != null) {
      var newCursorPosition = 0;
      // 新しいブロックまで（含まない）の位置を計算
      for (var i = 0; i < insertionIndex; i++) {
        newCursorPosition += _getBlockTextLength(blocks[i]) + 1; // 改行分+1
      }

      _field!._selection = TextSelection.collapsed(offset: newCursorPosition);
    }

    // UI状態を更新するために最初にリスナーに通知
    notifyListeners();

    _field?.reopenInputConnection();
    return block;
  }

  TValue? _insertBlockMultiField<TValue extends MarkdownBlockValue>(
      TValue block, int? offset) {
    final blocks = List<MarkdownBlockValue>.from(_getAllBlocks());

    // 挿入位置を決定
    int insertionIndex;
    if (offset != null) {
      // オフセットからブロックインデックスを検索
      var currentOffset = 0;
      insertionIndex = blocks.length; // デフォルトは末尾

      for (var i = 0; i < blocks.length; i++) {
        final currentBlock = blocks[i];
        final blockLength = _getBlockTextLength(currentBlock);
        final blockEnd = currentOffset + blockLength;

        if (offset >= currentOffset && offset <= blockEnd) {
          insertionIndex = i + 1; // このブロックの後に挿入
          break;
        }

        currentOffset = blockEnd + 1; // ブロック間の改行分+1
      }
    } else {
      // カーソル位置を使用
      final selection = _field!._selection;
      final cursorPosition = selection.baseOffset;

      var currentOffset = 0;
      insertionIndex = blocks.length; // デフォルトは末尾

      for (var i = 0; i < blocks.length; i++) {
        final currentBlock = blocks[i];
        final blockLength = _getBlockTextLength(currentBlock);
        final blockEnd = currentOffset + blockLength;

        if (cursorPosition >= currentOffset && cursorPosition <= blockEnd) {
          insertionIndex = i + 1; // 現在のブロックの後に挿入
          break;
        }

        currentOffset = blockEnd + 1; // ブロック間の改行分+1
      }
    }

    // ブロックを挿入
    blocks.insert(insertionIndex, block);

    // ブロックをフィールドに再配分
    _updateBlocksAcrossFields(blocks);

    // 新しいブロックの先頭にカーソルを移動（ブロックの前ではなく、ブロック内）
    if (_field != null) {
      var newCursorPosition = 0;
      // 新しいブロックまで（含まない）の位置を計算
      for (var i = 0; i < insertionIndex; i++) {
        newCursorPosition += _getBlockTextLength(blocks[i]) + 1; // 改行分+1
      }

      _field!._selection = TextSelection.collapsed(offset: newCursorPosition);
    }

    // UI状態を更新するために最初にリスナーに通知
    notifyListeners();

    _field?.reopenInputConnection();
    return block;
  }

  /// Exchanges a block at the specified index.
  ///
  /// 指定されたインデックスのブロックを交換します。
  TValue? exchangeBlock<TValue extends MarkdownBlockValue>(
    TValue block, {
    int? index,
  }) {
    if (_field == null) {
      return null;
    }

    // 変更前に現在の状態を保存
    if (!history.inProgress) {
      history.saveToUndoStack(immediate: true);
    }

    if (_value.isEmpty) {
      return null;
    }

    // 単一フィールドの場合：既存のロジック
    if (_isSingleField) {
      return _exchangeBlockSingleField<TValue>(block, index);
    }

    // 複数フィールドの場合：新しいロジック
    return _exchangeBlockMultiField<TValue>(block, index);
  }

  TValue? _exchangeBlockSingleField<TValue extends MarkdownBlockValue>(
      TValue block, int? index) {
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    if (blocks.isEmpty) {
      return null;
    }

    // カーソル位置からブロックインデックスを検索、または提供されたインデックスを使用
    int targetBlockIndex;
    if (index != null) {
      targetBlockIndex = index;
    } else {
      final selection = _field!._selection;
      final cursorPosition = selection.baseOffset;

      // カーソルを含むブロックを検索
      var currentOffset = 0;
      targetBlockIndex = 0;

      for (var i = 0; i < blocks.length; i++) {
        final currentBlock = blocks[i];
        final blockLength = _getBlockTextLength(currentBlock);
        final blockEnd = currentOffset + blockLength;

        if (cursorPosition >= currentOffset && cursorPosition <= blockEnd) {
          targetBlockIndex = i;
          break;
        }

        currentOffset = blockEnd + 1; // ブロック間の改行分+1
      }
    }

    if (targetBlockIndex >= blocks.length) {
      return null;
    }

    // ブロックを置換
    blocks[targetBlockIndex] = block;

    // フィールドを更新
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    notifyListeners();
    return block;
  }

  TValue? _exchangeBlockMultiField<TValue extends MarkdownBlockValue>(
      TValue block, int? index) {
    final blocks = List<MarkdownBlockValue>.from(_getAllBlocks());

    if (blocks.isEmpty) {
      return null;
    }

    // カーソル位置からブロックインデックスを検索、または提供されたインデックスを使用
    int targetBlockIndex;
    if (index != null) {
      targetBlockIndex = index;
    } else {
      final selection = _field!._selection;
      final cursorPosition = selection.baseOffset;

      // カーソルを含むブロックを検索
      var currentOffset = 0;
      targetBlockIndex = 0;

      for (var i = 0; i < blocks.length; i++) {
        final currentBlock = blocks[i];
        final blockLength = _getBlockTextLength(currentBlock);
        final blockEnd = currentOffset + blockLength;

        if (cursorPosition >= currentOffset && cursorPosition <= blockEnd) {
          targetBlockIndex = i;
          break;
        }

        currentOffset = blockEnd + 1; // ブロック間の改行分+1
      }
    }

    if (targetBlockIndex >= blocks.length) {
      return null;
    }

    // ブロックを置換
    blocks[targetBlockIndex] = block;

    // ブロックをフィールドに再配分
    _updateBlocksAcrossFields(blocks);

    notifyListeners();
    return block;
  }

  /// Replace the Markdown block from [from] to [to].
  ///
  /// マークダウンのブロックを[from]から[to]に置き換えます。
  TValue? replaceBlock<TValue extends MarkdownBlockValue>(
    MarkdownBlockValue from,
    MarkdownBlockValue to,
  ) {
    if (_field == null) {
      return null;
    }

    if (_value.isEmpty) {
      return null;
    }

    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    if (blocks.isEmpty) {
      return null;
    }

    for (var i = 0; i < blocks.length; i++) {
      if (blocks[i] == from) {
        blocks[i] = to;
        break;
      }
    }

    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    notifyListeners();
    if (to is TValue) {
      return to;
    }
    return null;
  }

  /// Inserts an image block at the current cursor position.
  ///
  /// 現在のカーソル位置に画像ブロックを挿入します。
  MarkdownImageBlockValue? insertImage(Uri uri) {
    if (_field == null) {
      return null;
    }

    // 変更前に現在の状態を保存
    if (!history.inProgress) {
      history.saveToUndoStack(immediate: true);
    }

    // 有効な構造があることを確認
    if (_value.isEmpty) {
      _value.add(MarkdownFieldValue(
        id: uuid(),
        children: const [],
      ));
    }

    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);
    final selection = _field!._selection;
    final cursorPosition = selection.baseOffset;

    // 挿入位置を決定
    int insertionIndex = blocks.length;
    var currentOffset = 0;

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      final blockLength = _getBlockTextLength(block);
      final blockEnd = currentOffset + blockLength;

      if (cursorPosition >= currentOffset && cursorPosition <= blockEnd) {
        insertionIndex = i + 1; // 現在のブロックの後に挿入
        break;
      }

      currentOffset = blockEnd + 1; // ブロック間の改行分+1
    }

    // 新しい画像ブロックを作成
    final newBlock = MarkdownImageBlockValue.createEmpty(uri: uri);
    blocks.insert(insertionIndex, newBlock);

    // 画像ブロックの後に空の段落ブロックを追加
    final emptyParagraph = MarkdownParagraphBlockValue.createEmpty();
    blocks.insert(insertionIndex + 1, emptyParagraph);

    // フィールドを更新
    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    // 画像ブロックの後の段落ブロックにカーソルを移動
    if (_field != null) {
      var newCursorPosition = 0;
      // 画像ブロックの次のブロック（空の段落）の先頭にカーソルを配置
      for (var i = 0; i <= insertionIndex; i++) {
        newCursorPosition += _getBlockTextLength(blocks[i]) + 1;
      }

      _field!._selection = TextSelection.collapsed(offset: newCursorPosition);
    }

    notifyListeners();
    return newBlock;
  }

  /// Replaces text in the specified range.
  ///
  /// 指定された範囲のテキストを置換します。
  void replaceText(
    int start,
    int end,
    String text, {
    bool skipHistory = false,
  }) {
    // 何も変更しない置換の場合は早期リターン（同じ位置に同じテキスト）
    // これにより選択操作中の不要なスパンマージを防ぐ
    if (start == 0 && _value.isNotEmpty) {
      final currentText = rawText;
      if (end == currentText.length && text == currentText) {
        return;
      }
    }

    // Undo/Redo操作中または明示的に要求された場合は履歴保存をスキップ
    if (!history.inProgress && !skipHistory) {
      // 変更前に現在の状態を保存
      // 単一文字の挿入/削除の場合、細かいUndoのために即座に保存
      final isSingleCharEdit = text.length <= 1 && (end - start) <= 1;

      if (history.undoStack.isEmpty) {
        // 最初の編集 - 変更前に初期空/現在の状態を即座に保存
        history.saveToUndoStack(immediate: true);
      } else if (isSingleCharEdit) {
        // 単一文字編集 - 変更前に細かいUndoのために即座に保存
        history.saveToUndoStack(immediate: true);
      } else {
        // 複数文字編集（例: ペースト、カット） - 確実にキャプチャするために即座に保存
        history.saveToUndoStack(immediate: true);
      }
    }
    // 有効な構造があることを確認
    if (_value.isEmpty) {
      // 初期構造を作成
      final field = MarkdownFieldValue.createEmpty(initialText: text);
      _value.clear();
      _value.add(field);
      notifyListeners();
      return;
    }

    // 単一フィールドの場合：既存のロジックをそのまま使用（後方互換性）
    if (_isSingleField) {
      _replaceTextSingleField(start, end, text);
      return;
    }

    // 複数フィールドの場合：新しいロジック
    _replaceTextMultiField(start, end, text);
  }

  /// Replaces text in a single field (backward compatibility mode).
  ///
  /// 単一フィールドでテキストを置換します（後方互換性モード）。
  void _replaceTextSingleField(int start, int end, String text) {
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // 開始位置と終了位置を含むブロックを検索
    var currentOffset = 0;
    int? startBlockIndex;
    int? endBlockIndex;
    int? endBlockStart;
    var localStart = 0;
    var localEnd = 0;

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      if (block is MarkdownMultiLineBlockValue) {
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

        // Special case: if we're inserting at a position that's exactly after a block
        // and before the next block (i.e., at the newline position), and the next block
        // exists and is empty, we should insert into that next block
        if (startBlockIndex == null &&
            start == blockEnd + 1 &&
            start == end &&
            i + 1 < blocks.length) {
          final nextBlock = blocks[i + 1];
          if (nextBlock is MarkdownMultiLineBlockValue) {
            final nextBlockChildren = nextBlock.extractLines() ?? [];
            final nextBlockText = StringBuffer();
            for (final line in nextBlockChildren) {
              for (final span in line.children) {
                nextBlockText.write(span.value);
              }
            }
            if (nextBlockText.toString().isEmpty) {
              // Insert into the empty next block
              startBlockIndex = i + 1;
              localStart = 0;
              endBlockIndex = i + 1;
              endBlockStart = blockEnd + 1;
              localEnd = 0;
              break;
            }
          }
        }

        // このブロックが開始位置を含むかチェック
        if (startBlockIndex == null && blockEnd >= start) {
          startBlockIndex = i;
          localStart = start - blockStart;
        }

        // このブロックが終了位置を含むかチェック
        if (blockEnd >= end) {
          endBlockIndex = i;
          endBlockStart = blockStart;
          localEnd = end - blockStart;
          break;
        }

        currentOffset += blockLength + 1; // ブロック間の改行分+1
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

    // blocksが空の場合、テキストで新しいブロックを作成
    if (blocks.isEmpty) {
      final newBlock = MarkdownBlockValue.createEmpty(initialText: text);
      blocks.add(newBlock);

      final newField = MarkdownFieldValue(
        id: field.id,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // 選択が複数のブロックにまたがる場合、マージする
    if (startBlockIndex != endBlockIndex) {
      // 開始ブロックの開始前のテキストを取得
      final startBlock = blocks[startBlockIndex];
      final startBlockText = StringBuffer();

      // ブロックタイプに基づいて子要素を抽出
      final startBlockChildren = startBlock.extractLines() ?? [];

      for (final line in startBlockChildren) {
        for (final span in line.children) {
          startBlockText.write(span.value);
        }
      }
      final startBlockTextStr = startBlockText.toString();
      final safeLocalStart = localStart.clamp(0, startBlockTextStr.length);
      final textBeforeStart = startBlockTextStr.substring(0, safeLocalStart);

      // 終了ブロックの終了後のテキストを取得
      final endBlock = blocks[endBlockIndex];
      final endBlockText = StringBuffer();

      // ブロックタイプに基づいて子要素を抽出
      final endBlockChildren = endBlock.extractLines() ?? [];

      for (final line in endBlockChildren) {
        for (final span in line.children) {
          endBlockText.write(span.value);
        }
      }
      final endBlockTextStr = endBlockText.toString();
      final safeLocalEnd = localEnd.clamp(0, endBlockTextStr.length);
      final textAfterEnd = endBlockTextStr.substring(safeLocalEnd);

      // マージされたテキストがどうなるかを計算
      final potentialMergedText = textBeforeStart + text + textAfterEnd;

      // 比較のために両方のブロックにまたがる元のテキストを取得
      final originalText = StringBuffer();
      for (var i = startBlockIndex; i <= endBlockIndex; i++) {
        final block = blocks[i];

        // ブロックタイプに基づいて子要素を抽出
        final blockChildren = block.extractLines() ?? [];

        for (final line in blockChildren) {
          for (final span in line.children) {
            originalText.write(span.value);
          }
        }
        if (i < endBlockIndex) {
          originalText.write("\n"); // ブロック間に改行を追加
        }
      }
      final originalTextStr = originalText.toString();

      // 操作が同じテキストになる場合は、ブロックをマージしない
      // これは選択ハンドルがドラッグされたがテキストが実際には変更されなかった場合に発生する
      if (potentialMergedText == originalTextStr) {
        notifyListeners();
        return;
      }

      // ブロックを別々に保つかマージするかをチェック
      // 別々に保つ条件: 削除 かつ 両方のブロックに内容が残っている
      final isAdjacentBlocks = endBlockIndex == startBlockIndex + 1;
      final shouldKeepSeparate = text.isEmpty &&
          textBeforeStart.isNotEmpty &&
          textAfterEnd.isNotEmpty &&
          !isAdjacentBlocks;

      if (shouldKeepSeparate) {
        // ブロックタイプを保持して、開始前のテキストで最初のブロックを更新
        final updatedFirstBlock =
            startBlock.clone(initialText: textBeforeStart);

        // ブロックタイプを保持して、終了後のテキストで最後のブロックを更新
        final updatedLastBlock = endBlock.clone(initialText: textAfterEnd);

        // 範囲内のすべてのブロックを削除
        blocks.removeRange(startBlockIndex, endBlockIndex + 1);

        // 更新されたブロックを挿入
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

      // マージ: 開始前のテキスト + 挿入されたテキスト + 終了後のテキスト
      var mergedText = textBeforeStart + text + textAfterEnd;

      // 削除している（textが空）かつマージされたテキストが改行で終わり、
      // 終了後にテキストがない（改行後のすべてを削除した）場合、
      // 末尾の改行を削除
      if (text.isEmpty &&
          textAfterEnd.isEmpty &&
          mergedText.endsWith("\n") &&
          mergedText.isNotEmpty) {
        mergedText = mergedText.substring(0, mergedText.length - 1);
      }

      final originalRange =
          blocks.sublist(startBlockIndex, endBlockIndex + 1).toList();

      // startBlockIndexからendBlockIndexまでのブロックを削除（両端を含む）
      blocks.removeRange(startBlockIndex, endBlockIndex + 1);

      if (mergedText.isEmpty && text.isEmpty) {
        // すべてのブロックが削除された場合、空のブロックを作成
        if (blocks.isEmpty) {
          blocks.add(MarkdownBlockValue.createEmpty());
        }
      } else {
        final segments = mergedText.split("\n");
        for (var i = 0; i < segments.length; i++) {
          final segment = segments[i];
          final template = originalRange[
              (i < originalRange.length) ? i : originalRange.length - 1];
          final newBlock = template.clone(initialText: segment);
          blocks.insert(startBlockIndex + i, newBlock);
        }
      }

      // フィールドを更新
      final newField = MarkdownFieldValue(
        id: field.id,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // 単一ブロックの編集
    final targetBlockIndex = startBlockIndex;

    // ターゲットブロックを更新
    final targetBlock = blocks[targetBlockIndex];

    // ブロックタイプに基づいて子要素を取得
    if (targetBlock is! MarkdownMultiLineBlockValue) {
      notifyListeners();
      return;
    }
    final targetBlockChildren = targetBlock.extractLines() ?? [];

    // ブロック内の現在のテキストを取得
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

    // インデックスが範囲内にあることを確認
    final safeStart = localStart.clamp(0, oldText.length);
    final safeEnd = localEnd.clamp(0, oldText.length);

    // 空または空に近いブロックの先頭でバックスペースかチェック
    if (safeStart == 0 &&
        safeEnd == 0 &&
        text.isEmpty &&
        targetBlockIndex > 0 &&
        oldText.isEmpty) {
      // 現在の空のブロックを削除して前のブロックとマージ
      blocks.removeAt(targetBlockIndex);

      // フィールドを更新
      final newField = MarkdownFieldValue(
        id: field.id,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // 新しいテキストを作成
    var newText =
        oldText.substring(0, safeStart) + text + oldText.substring(safeEnd);

    // 削除された文字列を取得
    final deletedText = oldText.substring(safeStart, safeEnd);

    // 空ブロックを削除するかどうかを決定：
    // - 最初のブロック（index 0）が空になった場合：削除
    // - 削除されたテキストに改行が含まれている場合：ブロックマージなので削除
    // - 削除されたテキストに改行がない場合：空行として保持（削除しない）
    if (newText.isEmpty &&
        text.isEmpty &&
        blocks.length > 1 &&
        (targetBlockIndex == 0 || deletedText.contains("\n"))) {
      // 最初のブロックまたは改行を含む削除の場合、空ブロックを削除
      blocks.removeAt(targetBlockIndex);

      final newField = MarkdownFieldValue(
        id: field.id,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    } else if (newText.isEmpty && !deletedText.contains("\n")) {
      // 削除されたテキストに改行がない場合、空ブロックを保持
      // （ユーザーが空の行で入力を続けられるようにするため）
      // 何もせず、下のロジックで空ブロックが作成される
    }

    // 末尾の改行を削除する必要があるかチェック
    var removedTrailingNewline = false;
    if (text.isEmpty && newText.endsWith("\n") && newText.isNotEmpty) {
      newText = newText.substring(0, newText.length - 1);
      removedTrailingNewline = true;
    }

    // 末尾の改行を削除した場合、新しいテキストでシンプルなスパンを作成し、
    // 複雑なスパンマージロジックをスキップ（改行が追加され戻されるのを防ぐ）
    if (removedTrailingNewline) {
      final MarkdownBlockValue newBlock = targetBlock.clone(
        child: MarkdownLineValue(
          id: targetBlockChildren.isNotEmpty
              ? targetBlockChildren.first.id
              : uuid(),
          children: [
            MarkdownSpanValue.createEmpty(initialText: newText),
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

    // For multi-line text with newlines, use direct approach instead of span processing
    if (newText.contains("\n") && !targetBlock.insertBlockOnNewLine) {
      final lines = newText.split("\n");
      final newChildren = lines
          .map((lineText) => MarkdownLineValue.createEmpty(
                children: [
                  MarkdownSpanValue.createEmpty(initialText: lineText),
                ],
              ))
          .toList();

      final updatedBlock = targetBlock.copyWith(children: newChildren);
      blocks[targetBlockIndex] = updatedBlock;

      final newField = MarkdownFieldValue(
        id: field.id,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // プロパティ付きの既存スパンを収集
    final existingSpans = <MarkdownSpanValue>[];
    for (final line in targetBlockChildren) {
      existingSpans.addAll(line.children);
    }

    // For multi-line blocks, adjust safeStart/safeEnd to account for newlines
    // oldText includes newlines between lines, but span processing doesn't
    var adjustedSafeStart = safeStart;
    var adjustedSafeEnd = safeEnd;
    if (targetBlockChildren.length > 1) {
      // Count how many newlines are before safeStart and safeEnd
      var currentTextPos = 0;
      var currentSpanPos = 0;
      for (var i = 0; i < targetBlockChildren.length; i++) {
        final line = targetBlockChildren[i];
        var lineLength = 0;
        for (final span in line.children) {
          lineLength += span.value.length;
        }

        // Update adjustedSafeStart if we haven't passed it yet
        if (currentTextPos + lineLength >= safeStart &&
            adjustedSafeStart == safeStart) {
          adjustedSafeStart = currentSpanPos + (safeStart - currentTextPos);
        }

        // Update adjustedSafeEnd if we haven't passed it yet
        if (currentTextPos + lineLength >= safeEnd &&
            adjustedSafeEnd == safeEnd) {
          adjustedSafeEnd = currentSpanPos + (safeEnd - currentTextPos);
        }

        currentTextPos += lineLength;
        currentSpanPos += lineLength;

        // Add newline (except after last line)
        if (i < targetBlockChildren.length - 1) {
          currentTextPos += 1; // newline in oldText
          // No newline in span concatenation
        }
      }

      // Handle case where safeStart/safeEnd are at the very end
      if (safeStart >= currentTextPos) {
        adjustedSafeStart = currentSpanPos;
      }
      if (safeEnd >= currentTextPos) {
        adjustedSafeEnd = currentSpanPos;
      }
    }

    // テキスト変更に基づいて新しいスパンを構築
    final newSpans = <MarkdownSpanValue>[];
    var currentPos = 0;

    // 既存のスパンを処理し、必要に応じて分割
    // Use adjustedSafeStart/adjustedSafeEnd for multi-line blocks
    final effectiveSafeStart =
        targetBlockChildren.length > 1 ? adjustedSafeStart : safeStart;
    final effectiveSafeEnd =
        targetBlockChildren.length > 1 ? adjustedSafeEnd : safeEnd;

    for (final span in existingSpans) {
      // 空のスパンをスキップ - 削除すべき
      if (span.value.isEmpty) {
        continue;
      }

      final spanStart = currentPos;
      final spanEnd = currentPos + span.value.length;

      // このスパンが置換の影響を受けるかチェック
      if (effectiveSafeEnd < spanStart) {
        newSpans.add(span);
      } else if (effectiveSafeStart >= spanEnd) {
        newSpans.add(span);

        // このスパンの末尾に挿入する場合、その後に新しいテキストを追加
        if (effectiveSafeStart == spanEnd && text.isNotEmpty) {
          newSpans.add(MarkdownSpanValue(
            id: uuid(),
            value: text,
          ));
        }
      } else if (effectiveSafeStart == effectiveSafeEnd &&
          effectiveSafeStart == spanStart &&
          text.isNotEmpty) {
        newSpans.add(MarkdownSpanValue(
          id: uuid(),
          value: text,
        ));
        newSpans.add(span);
      } else {
        if (spanStart < effectiveSafeStart) {
          final beforeText =
              span.value.substring(0, effectiveSafeStart - spanStart);
          newSpans.add(span.copyWith(
            id: uuid(),
            value: beforeText,
          ));
        }

        // 置換テキスト（元のスパンからのプロパティなし）
        if (text.isNotEmpty &&
            effectiveSafeStart >= spanStart &&
            effectiveSafeStart < spanEnd) {
          newSpans.add(MarkdownSpanValue(
            id: uuid(),
            value: text,
          ));
        }

        // 置換後（もしあれば）
        if (spanEnd > effectiveSafeEnd) {
          final afterText = span.value.substring(effectiveSafeEnd - spanStart);
          newSpans.add(span.copyWith(
            id: uuid(),
            value: afterText,
          ));
        }
      }

      currentPos += span.value.length;
    }

    // 置換が末尾または空のブロックにある場合、プロパティなしでテキストを追加
    if (newSpans.isEmpty && text.isNotEmpty) {
      newSpans.add(MarkdownSpanValue(
        id: uuid(),
        value: text,
      ));
    }

    // 同じプロパティを持つ連続するスパンをマージ
    final mergedSpans = _mergeSpans(newSpans);

    // 少なくとも1つのスパンがあることを確認
    final finalSpans = mergedSpans.isNotEmpty
        ? mergedSpans
        : [
            MarkdownSpanValue(
              id: uuid(),
              value: newText,
            )
          ];

    final splitLineSpans = _splitSpansByNewline(finalSpans);

    if (splitLineSpans.length > 1) {
      // Check if this block should add lines instead of creating new blocks
      if (!targetBlock.insertBlockOnNewLine) {
        // Add lines within the same block (for code blocks, etc.)
        final newChildren = splitLineSpans
            .map((spans) => MarkdownLineValue.createEmpty(
                  children: List<MarkdownSpanValue>.from(spans),
                ))
            .toList();

        final updatedBlock = targetBlock.copyWith(children: newChildren);
        blocks[targetBlockIndex] = updatedBlock;

        final newField = MarkdownFieldValue(
          id: field.id,
          children: blocks,
        );

        _value[0] = newField;
        notifyListeners();
        return;
      }

      var segments = splitLineSpans;
      var insertIndex = targetBlockIndex;

      final leadingEmpty = _groupIsEmpty(segments.first);
      final trailingEmpty = _groupIsEmpty(segments.last);

      if (leadingEmpty && segments.length > 1) {
        blocks.removeAt(targetBlockIndex);
        segments = segments.sublist(1);
      }

      if (trailingEmpty && segments.length > 1) {
        segments = segments.sublist(0, segments.length - 1);
      }

      if (blocks.isEmpty || targetBlockIndex >= blocks.length) {
        blocks.insert(
          targetBlockIndex,
          targetBlock.clone(
            child: MarkdownLineValue.createEmpty().copyWith(
              children: List<MarkdownSpanValue>.from(segments.first),
            ),
          ),
        );
        insertIndex = targetBlockIndex + 1;
        segments = segments.sublist(1);
      } else {
        final templateLine = targetBlockChildren.isNotEmpty
            ? targetBlockChildren.first
            : MarkdownLineValue.createEmpty();
        final updatedFirstBlock = targetBlock.clone(
          child: templateLine.copyWith(
            children: List<MarkdownSpanValue>.from(segments.first),
          ),
        );
        blocks[targetBlockIndex] = updatedFirstBlock;
        insertIndex = targetBlockIndex + 1;
        segments = segments.sublist(1);
      }

      for (final segment in segments) {
        final newBlock = targetBlock.clone(
          child: MarkdownLineValue.createEmpty().copyWith(
            children: List<MarkdownSpanValue>.from(segment),
          ),
        );
        blocks.insert(insertIndex, newBlock);
        insertIndex++;
      }

      final newField = MarkdownFieldValue(
        id: field.id,
        children: blocks,
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // 新しいスパンで更新されたブロックを作成
    final MarkdownBlockValue newBlock = targetBlock.clone(
      child: MarkdownLineValue(
        id: targetBlockChildren.isNotEmpty
            ? targetBlockChildren.first.id
            : uuid(),
        children: finalSpans,
      ),
    );

    // ブロックリストを更新
    blocks[targetBlockIndex] = newBlock;

    // フィールドを更新
    final newField = MarkdownFieldValue(
      id: field.id,
      children: blocks,
    );

    _value[0] = newField;
    notifyListeners();
  }

  /// Replaces text across multiple fields.
  ///
  /// 複数フィールドにまたがってテキストを置換します。
  void _replaceTextMultiField(int start, int end, String text) {
    // Get all blocks from all fields as a flat list
    final blocks = List<MarkdownBlockValue>.from(_getAllBlocks());

    // 開始位置と終了位置を含むブロックを検索
    var currentOffset = 0;
    int? startBlockIndex;
    int? endBlockIndex;
    int? endBlockStart;
    var localStart = 0;
    var localEnd = 0;

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      if (block is MarkdownMultiLineBlockValue) {
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

        // Special case: if we're inserting at a position that's exactly after a block
        // and before the next block (i.e., at the newline position), and the next block
        // exists and is empty, we should insert into that next block
        if (startBlockIndex == null &&
            start == blockEnd + 1 &&
            start == end &&
            i + 1 < blocks.length) {
          final nextBlock = blocks[i + 1];
          if (nextBlock is MarkdownMultiLineBlockValue) {
            final nextBlockChildren = nextBlock.extractLines() ?? [];
            final nextBlockText = StringBuffer();
            for (final line in nextBlockChildren) {
              for (final span in line.children) {
                nextBlockText.write(span.value);
              }
            }
            if (nextBlockText.toString().isEmpty) {
              // Insert into the empty next block
              startBlockIndex = i + 1;
              localStart = 0;
              endBlockIndex = i + 1;
              endBlockStart = blockEnd + 1;
              localEnd = 0;
              break;
            }
          }
        }

        // このブロックが開始位置を含むかチェック
        if (startBlockIndex == null && blockEnd >= start) {
          startBlockIndex = i;
          localStart = start - blockStart;
        }

        // このブロックが終了位置を含むかチェック
        if (blockEnd >= end) {
          endBlockIndex = i;
          endBlockStart = blockStart;
          localEnd = end - blockStart;
          break;
        }

        currentOffset += blockLength + 1; // ブロック間の改行分+1
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

    // blocksが空の場合、テキストで新しいブロックを作成
    if (blocks.isEmpty) {
      final newBlock = MarkdownBlockValue.createEmpty(initialText: text);
      blocks.add(newBlock);

      _updateBlocksAcrossFields(blocks);
      notifyListeners();
      return;
    }

    // 選択が複数のブロックにまたがる場合、マージする
    if (startBlockIndex != endBlockIndex) {
      // 開始ブロックの開始前のテキストを取得
      final startBlock = blocks[startBlockIndex];
      final startBlockText = StringBuffer();

      // ブロックタイプに基づいて子要素を抽出
      final startBlockChildren = startBlock.extractLines() ?? [];

      for (final line in startBlockChildren) {
        for (final span in line.children) {
          startBlockText.write(span.value);
        }
      }
      final startBlockTextStr = startBlockText.toString();
      final safeLocalStart = localStart.clamp(0, startBlockTextStr.length);
      final textBeforeStart = startBlockTextStr.substring(0, safeLocalStart);

      // 終了ブロックの終了後のテキストを取得
      final endBlock = blocks[endBlockIndex];
      final endBlockText = StringBuffer();

      // ブロックタイプに基づいて子要素を抽出
      final endBlockChildren = endBlock.extractLines() ?? [];

      for (final line in endBlockChildren) {
        for (final span in line.children) {
          endBlockText.write(span.value);
        }
      }
      final endBlockTextStr = endBlockText.toString();
      final safeLocalEnd = localEnd.clamp(0, endBlockTextStr.length);
      final textAfterEnd = endBlockTextStr.substring(safeLocalEnd);

      // マージされたテキストがどうなるかを計算
      final potentialMergedText = textBeforeStart + text + textAfterEnd;

      // 比較のために両方のブロックにまたがる元のテキストを取得
      final originalText = StringBuffer();
      for (var i = startBlockIndex; i <= endBlockIndex; i++) {
        final block = blocks[i];

        // ブロックタイプに基づいて子要素を抽出
        final blockChildren = block.extractLines() ?? [];

        for (final line in blockChildren) {
          for (final span in line.children) {
            originalText.write(span.value);
          }
        }
        if (i < endBlockIndex) {
          originalText.write("\n"); // ブロック間に改行を追加
        }
      }
      final originalTextStr = originalText.toString();

      // 操作が同じテキストになる場合は、ブロックをマージしない
      // これは選択ハンドルがドラッグされたがテキストが実際には変更されなかった場合に発生する
      if (potentialMergedText == originalTextStr) {
        notifyListeners();
        return;
      }

      // ブロックを別々に保つかマージするかをチェック
      // 別々に保つ条件: 削除 かつ 両方のブロックに内容が残っている
      final isAdjacentBlocks = endBlockIndex == startBlockIndex + 1;
      final shouldKeepSeparate = text.isEmpty &&
          textBeforeStart.isNotEmpty &&
          textAfterEnd.isNotEmpty &&
          !isAdjacentBlocks;

      if (shouldKeepSeparate) {
        // ブロックタイプを保持して、開始前のテキストで最初のブロックを更新
        final updatedFirstBlock =
            startBlock.clone(initialText: textBeforeStart);

        // ブロックタイプを保持して、終了後のテキストで最後のブロックを更新
        final updatedLastBlock = endBlock.clone(initialText: textAfterEnd);

        // 範囲内のすべてのブロックを削除
        blocks.removeRange(startBlockIndex, endBlockIndex + 1);

        // 更新されたブロックを挿入
        blocks.insert(startBlockIndex, updatedLastBlock);
        blocks.insert(startBlockIndex, updatedFirstBlock);

        _updateBlocksAcrossFields(blocks);
        notifyListeners();
        return;
      }

      // マージ: 開始前のテキスト + 挿入されたテキスト + 終了後のテキスト
      var mergedText = textBeforeStart + text + textAfterEnd;

      // 削除している（textが空）かつマージされたテキストが改行で終わり、
      // 終了後にテキストがない（改行後のすべてを削除した）場合、
      // 末尾の改行を削除
      if (text.isEmpty &&
          textAfterEnd.isEmpty &&
          mergedText.endsWith("\n") &&
          mergedText.isNotEmpty) {
        mergedText = mergedText.substring(0, mergedText.length - 1);
      }

      final originalRange =
          blocks.sublist(startBlockIndex, endBlockIndex + 1).toList();

      // startBlockIndexからendBlockIndexまでのブロックを削除（両端を含む）
      blocks.removeRange(startBlockIndex, endBlockIndex + 1);

      if (mergedText.isEmpty && text.isEmpty) {
        // すべてのブロックが削除された場合、空のブロックを作成
        if (blocks.isEmpty) {
          blocks.add(MarkdownBlockValue.createEmpty());
        }
      } else {
        final segments = mergedText.split("\n");
        for (var i = 0; i < segments.length; i++) {
          final segment = segments[i];
          final template = originalRange[
              (i < originalRange.length) ? i : originalRange.length - 1];
          final newBlock = template.clone(initialText: segment);
          blocks.insert(startBlockIndex + i, newBlock);
        }
      }

      // ブロックをフィールドに再配分
      _updateBlocksAcrossFields(blocks);
      notifyListeners();
      return;
    }

    // 単一ブロックの編集
    final targetBlockIndex = startBlockIndex;

    // ターゲットブロックを更新
    final targetBlock = blocks[targetBlockIndex];

    // ブロックタイプに基づいて子要素を取得
    if (targetBlock is! MarkdownMultiLineBlockValue) {
      notifyListeners();
      return;
    }
    final targetBlockChildren = targetBlock.extractLines() ?? [];

    // ブロック内の現在のテキストを取得
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

    // インデックスが範囲内にあることを確認
    final safeStart = localStart.clamp(0, oldText.length);
    final safeEnd = localEnd.clamp(0, oldText.length);

    // 空または空に近いブロックの先頭でバックスペースかチェック
    if (safeStart == 0 &&
        safeEnd == 0 &&
        text.isEmpty &&
        targetBlockIndex > 0 &&
        oldText.isEmpty) {
      // 現在の空のブロックを削除して前のブロックとマージ
      blocks.removeAt(targetBlockIndex);

      _updateBlocksAcrossFields(blocks);
      notifyListeners();
      return;
    }

    // 新しいテキストを作成
    var newText =
        oldText.substring(0, safeStart) + text + oldText.substring(safeEnd);

    // 削除された文字列を取得
    final deletedText = oldText.substring(safeStart, safeEnd);

    // 空ブロックを削除するかどうかを決定：
    // - 最初のブロック（index 0）が空になった場合：削除
    // - 削除されたテキストに改行が含まれている場合：ブロックマージなので削除
    // - 削除されたテキストに改行がない場合：空行として保持（削除しない）
    if (newText.isEmpty &&
        text.isEmpty &&
        blocks.length > 1 &&
        (targetBlockIndex == 0 || deletedText.contains("\n"))) {
      // 最初のブロックまたは改行を含む削除の場合、空ブロックを削除
      blocks.removeAt(targetBlockIndex);

      _updateBlocksAcrossFields(blocks);
      notifyListeners();
      return;
    } else if (newText.isEmpty && !deletedText.contains("\n")) {
      // 削除されたテキストに改行がない場合、空ブロックを保持
      // （ユーザーが空の行で入力を続けられるようにするため）
      // 何もせず、下のロジックで空ブロックが作成される
    }

    // 末尾の改行を削除する必要があるかチェック
    var removedTrailingNewline = false;
    if (text.isEmpty && newText.endsWith("\n") && newText.isNotEmpty) {
      newText = newText.substring(0, newText.length - 1);
      removedTrailingNewline = true;
    }

    // 末尾の改行を削除した場合、新しいテキストでシンプルなスパンを作成し、
    // 複雑なスパンマージロジックをスキップ（改行が追加され戻されるのを防ぐ）
    if (removedTrailingNewline) {
      final newBlock = targetBlock.clone(
        child: MarkdownLineValue(
          id: targetBlockChildren.isNotEmpty
              ? targetBlockChildren.first.id
              : uuid(),
          children: [
            MarkdownSpanValue.createEmpty(initialText: newText),
          ],
        ),
      );

      blocks[targetBlockIndex] = newBlock;

      _updateBlocksAcrossFields(blocks);
      notifyListeners();
      return;
    }

    // For multi-line text with newlines, use direct approach instead of span processing
    if (newText.contains("\n") && !targetBlock.insertBlockOnNewLine) {
      final lines = newText.split("\n");
      final newChildren = lines
          .map((lineText) => MarkdownLineValue.createEmpty(
                children: [
                  MarkdownSpanValue.createEmpty(initialText: lineText),
                ],
              ))
          .toList();

      final updatedBlock = targetBlock.copyWith(children: newChildren);
      blocks[targetBlockIndex] = updatedBlock;

      _updateBlocksAcrossFields(blocks);
      notifyListeners();
      return;
    }

    // プロパティ付きの既存スパンを収集
    final existingSpans = <MarkdownSpanValue>[];
    for (final line in targetBlockChildren) {
      existingSpans.addAll(line.children);
    }

    // For multi-line blocks, adjust safeStart/safeEnd to account for newlines
    // oldText includes newlines between lines, but span processing doesn't
    var adjustedSafeStart = safeStart;
    var adjustedSafeEnd = safeEnd;
    if (targetBlockChildren.length > 1) {
      // Count how many newlines are before safeStart and safeEnd
      var currentTextPos = 0;
      var currentSpanPos = 0;
      for (var i = 0; i < targetBlockChildren.length; i++) {
        final line = targetBlockChildren[i];
        var lineLength = 0;
        for (final span in line.children) {
          lineLength += span.value.length;
        }

        // Update adjustedSafeStart if we haven't passed it yet
        if (currentTextPos + lineLength >= safeStart &&
            adjustedSafeStart == safeStart) {
          adjustedSafeStart = currentSpanPos + (safeStart - currentTextPos);
        }

        // Update adjustedSafeEnd if we haven't passed it yet
        if (currentTextPos + lineLength >= safeEnd &&
            adjustedSafeEnd == safeEnd) {
          adjustedSafeEnd = currentSpanPos + (safeEnd - currentTextPos);
        }

        currentTextPos += lineLength;
        currentSpanPos += lineLength;

        // Add newline (except after last line)
        if (i < targetBlockChildren.length - 1) {
          currentTextPos += 1; // newline in oldText
          // No newline in span concatenation
        }
      }

      // Handle case where safeStart/safeEnd are at the very end
      if (safeStart >= currentTextPos) {
        adjustedSafeStart = currentSpanPos;
      }
      if (safeEnd >= currentTextPos) {
        adjustedSafeEnd = currentSpanPos;
      }
    }

    // テキスト変更に基づいて新しいスパンを構築
    final newSpans = <MarkdownSpanValue>[];
    var currentPos = 0;

    // 既存のスパンを処理し、必要に応じて分割
    // Use adjustedSafeStart/adjustedSafeEnd for multi-line blocks
    final effectiveSafeStart =
        targetBlockChildren.length > 1 ? adjustedSafeStart : safeStart;
    final effectiveSafeEnd =
        targetBlockChildren.length > 1 ? adjustedSafeEnd : safeEnd;

    for (final span in existingSpans) {
      // 空のスパンをスキップ - 削除すべき
      if (span.value.isEmpty) {
        continue;
      }

      final spanStart = currentPos;
      final spanEnd = currentPos + span.value.length;

      // このスパンが置換の影響を受けるかチェック
      if (effectiveSafeEnd < spanStart) {
        newSpans.add(span);
      } else if (effectiveSafeStart >= spanEnd) {
        newSpans.add(span);

        // このスパンの末尾に挿入する場合、その後に新しいテキストを追加
        if (effectiveSafeStart == spanEnd && text.isNotEmpty) {
          newSpans.add(MarkdownSpanValue(
            id: uuid(),
            value: text,
          ));
        }
      } else if (effectiveSafeStart == effectiveSafeEnd &&
          effectiveSafeStart == spanStart &&
          text.isNotEmpty) {
        newSpans.add(MarkdownSpanValue(
          id: uuid(),
          value: text,
        ));
        newSpans.add(span);
      } else {
        if (spanStart < effectiveSafeStart) {
          final beforeText =
              span.value.substring(0, effectiveSafeStart - spanStart);
          newSpans.add(span.copyWith(
            id: uuid(),
            value: beforeText,
          ));
        }

        // 置換テキスト（元のスパンからのプロパティなし）
        if (text.isNotEmpty &&
            effectiveSafeStart >= spanStart &&
            effectiveSafeStart < spanEnd) {
          newSpans.add(MarkdownSpanValue(
            id: uuid(),
            value: text,
          ));
        }

        // 置換後（もしあれば）
        if (spanEnd > effectiveSafeEnd) {
          final afterText = span.value.substring(effectiveSafeEnd - spanStart);
          newSpans.add(span.copyWith(
            id: uuid(),
            value: afterText,
          ));
        }
      }

      currentPos += span.value.length;
    }

    // 置換が末尾または空のブロックにある場合、プロパティなしでテキストを追加
    if (newSpans.isEmpty && text.isNotEmpty) {
      newSpans.add(MarkdownSpanValue(
        id: uuid(),
        value: text,
      ));
    }

    // 同じプロパティを持つ連続するスパンをマージ
    final mergedSpans = _mergeSpans(newSpans);

    // 少なくとも1つのスパンがあることを確認
    final finalSpans = mergedSpans.isNotEmpty
        ? mergedSpans
        : [
            MarkdownSpanValue(
              id: uuid(),
              value: newText,
            )
          ];

    final splitLineSpans = _splitSpansByNewline(finalSpans);

    if (splitLineSpans.length > 1) {
      // Check if this block should add lines instead of creating new blocks
      if (!targetBlock.insertBlockOnNewLine) {
        // Add lines within the same block (for code blocks, etc.)
        final newChildren = splitLineSpans
            .map((spans) => MarkdownLineValue.createEmpty(
                  children: List<MarkdownSpanValue>.from(spans),
                ))
            .toList();

        final updatedBlock = targetBlock.copyWith(children: newChildren);
        blocks[targetBlockIndex] = updatedBlock;

        _updateBlocksAcrossFields(blocks);
        notifyListeners();
        return;
      }

      var segments = splitLineSpans;
      var insertIndex = targetBlockIndex;

      final leadingEmpty = _groupIsEmpty(segments.first);
      final trailingEmpty = _groupIsEmpty(segments.last);

      if (leadingEmpty && segments.length > 1) {
        blocks.removeAt(targetBlockIndex);
        segments = segments.sublist(1);
      }

      if (trailingEmpty && segments.length > 1) {
        segments = segments.sublist(0, segments.length - 1);
      }

      if (blocks.isEmpty || targetBlockIndex >= blocks.length) {
        blocks.insert(
          targetBlockIndex,
          targetBlock.clone(
            child: MarkdownLineValue.createEmpty().copyWith(
              children: List<MarkdownSpanValue>.from(segments.first),
            ),
          ),
        );
        insertIndex = targetBlockIndex + 1;
        segments = segments.sublist(1);
      } else {
        final templateLine = targetBlockChildren.isNotEmpty
            ? targetBlockChildren.first
            : MarkdownLineValue.createEmpty();
        final updatedFirstBlock = targetBlock.clone(
          child: templateLine.copyWith(
            children: List<MarkdownSpanValue>.from(segments.first),
          ),
        );
        blocks[targetBlockIndex] = updatedFirstBlock;
        insertIndex = targetBlockIndex + 1;
        segments = segments.sublist(1);
      }

      for (final segment in segments) {
        final newBlock = targetBlock.clone(
          child: MarkdownLineValue.createEmpty().copyWith(
            children: List<MarkdownSpanValue>.from(segment),
          ),
        );
        blocks.insert(insertIndex, newBlock);
        insertIndex++;
      }

      _updateBlocksAcrossFields(blocks);
      notifyListeners();
      return;
    }

    // 新しいスパンで更新されたブロックを作成
    final newBlock = targetBlock.clone(
      child: MarkdownLineValue(
        id: targetBlockChildren.isNotEmpty
            ? targetBlockChildren.first.id
            : uuid(),
        children: finalSpans,
      ),
    );

    // ブロックリストを更新
    blocks[targetBlockIndex] = newBlock;

    // ブロックをフィールドに再配分
    _updateBlocksAcrossFields(blocks);
    notifyListeners();
  }

  /// Updates the title of the link.
  ///
  /// リンクのタイトルを更新します。
  void updateLinkTitle(String title) {
    final selection = _field?._selection;
    if (selection == null || !selection.isValid || selection.isCollapsed) {
      return;
    }

    // 選択されたテキストを新しいタイトルに置き換え
    replaceText(selection.start, selection.end, title);

    // 選択範囲を新しいテキスト範囲に更新
    // 注意: MarkdownFieldStateに直接の選択更新メソッドは存在しない
    // 選択範囲はコントローラーのreplaceTextメソッドによって更新される
    _field?._selection = TextSelection(
      baseOffset: selection.start,
      extentOffset: selection.start + title.length,
    );
  }

  /// Updates the URL of the link.
  ///
  /// リンクのURLを更新します。
  void updateLinkUrl(String? url) {
    final selection = _field?._selection;

    if (selection == null || !selection.isValid || selection.isCollapsed) {
      return;
    }

    if (url == null || url.isEmpty) {
      // リンクプロパティを削除
      const linkTool = LinkMarkdownInlineTools();
      removeInlineProperty(linkTool);
    } else {
      // まず既存のリンクプロパティを削除
      const linkTool = LinkMarkdownInlineTools();
      removeInlineProperty(linkTool);

      // 次にURL付きの新しいリンクプロパティを追加
      // URL値でプロパティを手動更新する必要がある
      _addLinkProperty(url, selection.start, selection.end);
    }
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

    // 変更前に現在の状態を保存
    if (!history.inProgress && !skipHistory) {
      history.saveToUndoStack(immediate: true);
    }

    // 変換テキストがある場合は、クリアするだけ
    // テキストは既にコントローラーにあるため、置換は不要
    if (_field!.composingText != null) {
      // 変換状態をクリア
      _field!._composingText = null;
      _field!._composingRegion = null;

      // 現在の選択を維持
      _field!._updateRemoteEditingValue();
    }

    final selection = _field!._selection;

    // 開始と終了が明示的に提供されている場合はそれを使用
    // そうでない場合は現在の選択を使用
    final selectionStart = start ?? selection.start;
    final selectionEnd = end ?? selection.end;

    // 明示的な範囲も有効な選択も提供されていない場合はリターン
    if (start == null &&
        end == null &&
        (!selection.isValid || selection.isCollapsed)) {
      return;
    }

    // 明示的な開始/終了があるが等しい場合はリターン
    if (selectionStart == selectionEnd) {
      return;
    }

    if (_value.isEmpty) {
      return;
    }

    // Single field: existing logic
    if (_isSingleField) {
      return _addInlinePropertySingleField(
          tool, selectionStart, selectionEnd, value);
    }

    // Multiple fields: new logic
    return _addInlinePropertyMultiField(
        tool, selectionStart, selectionEnd, value);
  }

  void _addInlinePropertySingleField(MarkdownPropertyTools tool,
      int selectionStart, int selectionEnd, Object? value) {
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // 選択を含むブロックを検索
    var currentOffset = 0;

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      if (block is MarkdownMultiLineBlockValue) {
        final blockStart = currentOffset;
        final blockLength = _getBlockTextLength(block);
        final blockEnd = blockStart + blockLength;

        // 選択の前後に完全にあるブロックをスキップ
        if (blockEnd < selectionStart || blockStart > selectionEnd) {
          currentOffset = blockEnd + 1; // ブロック間の改行分+1
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

            // このスパンがメンションプロパティを持つかチェック
            // メンションは他のインラインプロパティで変更されるべきではない
            final hasMentionProperty =
                span.properties.any((p) => p is MentionMarkdownSpanProperty);

            // このスパンが選択と重なるかチェック
            if (selectionEnd <= spanStart || selectionStart >= spanEnd) {
              // 重なりなし、スパンをそのまま保持
              updatedSpans.add(span);
            } else if (hasMentionProperty) {
              // このスパンはメンションプロパティを持つ、そのまま保持
              // メンションには他のインラインプロパティを適用できない
              updatedSpans.add(span);
            } else {
              // 重なりあり、スパンを分割
              final overlapStart =
                  selectionStart > spanStart ? selectionStart : spanStart;
              final overlapEnd =
                  selectionEnd < spanEnd ? selectionEnd : spanEnd;

              // 選択前
              if (spanStart < overlapStart) {
                final beforeText =
                    span.value.substring(0, overlapStart - spanStart);
                updatedSpans.add(span.copyWith(
                  id: uuid(),
                  value: beforeText,
                ));
              }

              // 更新されたプロパティを持つ選択部分
              final selectedText = span.value
                  .substring(overlapStart - spanStart, overlapEnd - spanStart);
              final updatedProperty =
                  _applyInlineProperty(tool, span.properties, value: value);
              updatedSpans.add(span.copyWith(
                id: uuid(),
                value: selectedText,
                properties: updatedProperty,
              ));

              // 選択後
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

          // 同じプロパティを持つ連続するスパンをマージ
          final mergedSpans = _mergeSpans(updatedSpans);
          updatedLines.add(line.copyWith(children: mergedSpans));
        }

        blocks[i] = block.copyWith(children: updatedLines);
        currentOffset += _getBlockTextLength(block) + 1; // 改行分+1
      }
    }

    final newField = field.copyWith(children: blocks);
    _value[0] = newField;

    notifyListeners();
  }

  void _addInlinePropertyMultiField(MarkdownPropertyTools tool,
      int selectionStart, int selectionEnd, Object? value) {
    final allBlocks = _getAllBlocks();

    // 選択を含むブロックを検索
    var currentOffset = 0;

    for (var i = 0; i < allBlocks.length; i++) {
      final block = allBlocks[i];
      if (block is MarkdownMultiLineBlockValue) {
        final blockStart = currentOffset;
        final blockLength = _getBlockTextLength(block);
        final blockEnd = blockStart + blockLength;

        // 選択の前後に完全にあるブロックをスキップ
        if (blockEnd < selectionStart || blockStart > selectionEnd) {
          currentOffset = blockEnd + 1; // ブロック間の改行分+1
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

            // このスパンがメンションプロパティを持つかチェック
            // メンションは他のインラインプロパティで変更されるべきではない
            final hasMentionProperty =
                span.properties.any((p) => p is MentionMarkdownSpanProperty);

            // このスパンが選択と重なるかチェック
            if (selectionEnd <= spanStart || selectionStart >= spanEnd) {
              // 重なりなし、スパンをそのまま保持
              updatedSpans.add(span);
            } else if (hasMentionProperty) {
              // このスパンはメンションプロパティを持つ、そのまま保持
              // メンションには他のインラインプロパティを適用できない
              updatedSpans.add(span);
            } else {
              // 重なりあり、スパンを分割
              final overlapStart =
                  selectionStart > spanStart ? selectionStart : spanStart;
              final overlapEnd =
                  selectionEnd < spanEnd ? selectionEnd : spanEnd;

              // 選択前
              if (spanStart < overlapStart) {
                final beforeText =
                    span.value.substring(0, overlapStart - spanStart);
                updatedSpans.add(span.copyWith(
                  id: uuid(),
                  value: beforeText,
                ));
              }

              // 更新されたプロパティを持つ選択部分
              final selectedText = span.value
                  .substring(overlapStart - spanStart, overlapEnd - spanStart);
              final updatedProperty =
                  _applyInlineProperty(tool, span.properties, value: value);
              updatedSpans.add(span.copyWith(
                id: uuid(),
                value: selectedText,
                properties: updatedProperty,
              ));

              // 選択後
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

          // 同じプロパティを持つ連続するスパンをマージ
          final mergedSpans = _mergeSpans(updatedSpans);
          updatedLines.add(line.copyWith(children: mergedSpans));
        }

        allBlocks[i] = block.copyWith(children: updatedLines);
        currentOffset += _getBlockTextLength(block) + 1; // 改行分+1
      }
    }

    // Redistribute blocks across fields
    _updateBlocksAcrossFields(allBlocks);
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

    // 変更前に現在の状態を保存
    if (!history.inProgress) {
      history.saveToUndoStack(immediate: true);
    }

    // 変換テキストがある場合は、クリアするだけ
    // テキストは既にコントローラーにあるため、置換は不要
    if (_field!.composingText != null) {
      // 変換状態をクリア
      _field!._composingText = null;
      _field!._composingRegion = null;

      // 現在の選択を維持
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

    // Single field: existing logic
    if (_isSingleField) {
      return _removeInlinePropertySingleField(
          tool, selectionStart, selectionEnd);
    }

    // Multiple fields: new logic
    return _removeInlinePropertyMultiField(tool, selectionStart, selectionEnd);
  }

  void _removeInlinePropertySingleField(
      MarkdownPropertyTools tool, int selectionStart, int selectionEnd) {
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // 選択を含むブロックを検索
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

            // このスパンがメンションプロパティを持つかチェック
            // メンションは他のインラインプロパティで変更されるべきではない
            final hasMentionProperty =
                span.properties.any((p) => p is MentionMarkdownSpanProperty);

            // このスパンが選択と重なるかチェック
            if (selectionEnd <= spanStart || selectionStart >= spanEnd) {
              // 重なりなし、スパンをそのまま保持
              updatedSpans.add(span);
            } else if (hasMentionProperty) {
              // このスパンはメンションプロパティを持つ、そのまま保持
              // メンションからは他のインラインプロパティを削除できない
              updatedSpans.add(span);
            } else {
              // 重なりあり、スパンを分割
              final overlapStart =
                  selectionStart > spanStart ? selectionStart : spanStart;
              final overlapEnd =
                  selectionEnd < spanEnd ? selectionEnd : spanEnd;

              // 選択前
              if (spanStart < overlapStart) {
                final beforeText =
                    span.value.substring(0, overlapStart - spanStart);
                updatedSpans.add(span.copyWith(
                  id: uuid(),
                  value: beforeText,
                ));
              }

              // プロパティが削除された選択部分
              final selectedText = span.value
                  .substring(overlapStart - spanStart, overlapEnd - spanStart);
              final updatedProperty =
                  _removeInlineProperty(tool, span.properties);
              updatedSpans.add(span.copyWith(
                id: uuid(),
                value: selectedText,
                properties: updatedProperty,
              ));

              // 選択後
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

          // 同じプロパティを持つ連続するスパンをマージ
          final mergedSpans = _mergeSpans(updatedSpans);
          updatedLines.add(line.copyWith(children: mergedSpans));
        }

        blocks[i] = block.copyWith(children: updatedLines);
        currentOffset += _getBlockTextLength(block) + 1; // 改行分+1
      }
    }

    final newField = field.copyWith(children: blocks);
    _value[0] = newField;
    notifyListeners();
  }

  void _removeInlinePropertyMultiField(
      MarkdownPropertyTools tool, int selectionStart, int selectionEnd) {
    final allBlocks = _getAllBlocks();

    // 選択を含むブロックを検索
    var currentOffset = 0;

    for (var i = 0; i < allBlocks.length; i++) {
      final block = allBlocks[i];
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

            // このスパンがメンションプロパティを持つかチェック
            // メンションは他のインラインプロパティで変更されるべきではない
            final hasMentionProperty =
                span.properties.any((p) => p is MentionMarkdownSpanProperty);

            // このスパンが選択と重なるかチェック
            if (selectionEnd <= spanStart || selectionStart >= spanEnd) {
              // 重なりなし、スパンをそのまま保持
              updatedSpans.add(span);
            } else if (hasMentionProperty) {
              // このスパンはメンションプロパティを持つ、そのまま保持
              // メンションからは他のインラインプロパティを削除できない
              updatedSpans.add(span);
            } else {
              // 重なりあり、スパンを分割
              final overlapStart =
                  selectionStart > spanStart ? selectionStart : spanStart;
              final overlapEnd =
                  selectionEnd < spanEnd ? selectionEnd : spanEnd;

              // 選択前
              if (spanStart < overlapStart) {
                final beforeText =
                    span.value.substring(0, overlapStart - spanStart);
                updatedSpans.add(span.copyWith(
                  id: uuid(),
                  value: beforeText,
                ));
              }

              // プロパティが削除された選択部分
              final selectedText = span.value
                  .substring(overlapStart - spanStart, overlapEnd - spanStart);
              final updatedProperty =
                  _removeInlineProperty(tool, span.properties);
              updatedSpans.add(span.copyWith(
                id: uuid(),
                value: selectedText,
                properties: updatedProperty,
              ));

              // 選択後
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

          // 同じプロパティを持つ連続するスパンをマージ
          final mergedSpans = _mergeSpans(updatedSpans);
          updatedLines.add(line.copyWith(children: mergedSpans));
        }

        allBlocks[i] = block.copyWith(children: updatedLines);
        currentOffset += _getBlockTextLength(block) + 1; // 改行分+1
      }
    }

    // Redistribute blocks across fields
    _updateBlocksAcrossFields(allBlocks);
    notifyListeners();
  }

  /// Checks if the inline property exists at the specified start and end positions.
  ///
  /// 指定された開始位置と終了位置のインラインプロパティが存在するかどうかを確認します。
  bool hasInlineProperty(MarkdownPropertyTools tool, {int? start, int? end}) {
    if (_field == null) {
      return false;
    }

    // 変換テキストがある場合（IME入力中）、falseを返す
    // プロパティは未確定のテキストには適用できないため
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

    final blocks = _isSingleField ? _value.first.children : _getAllBlocks();

    var currentOffset = 0;
    var allHaveProperty = true;
    var hasNonMentionSpan = false;

    for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
      final block = blocks[blockIndex];
      if (block is MarkdownMultiLineBlockValue) {
        // final blockLength = _getBlockTextLength(block);
        // final blockStart = currentOffset;

        for (final line in block.children) {
          var lineOffset = currentOffset;

          for (final span in line.children) {
            final spanStart = lineOffset;
            final spanEnd = lineOffset + span.value.length;

            // このスパンが選択と重なるかチェック
            if (selectionEnd > spanStart && selectionStart < spanEnd) {
              // このスパンがメンションプロパティを持つかチェック
              // メンションはプロパティチェックから除外すべき
              final hasMentionProperty =
                  span.properties.any((p) => p is MentionMarkdownSpanProperty);

              if (!hasMentionProperty) {
                // これは非メンションスパン、プロパティを持つかチェック
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

        currentOffset += _getBlockTextLength(block) + 1; // 改行分+1
        if (!allHaveProperty) {
          break;
        }
      }
    }

    // 選択内のすべてのスパンがメンションの場合、falseを返す
    // プロパティを持つ非メンションスパンが少なくとも1つある場合のみtrueを返す
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

  void _addLinkProperty(String url, int start, int end) {
    if (value?.isEmpty ?? true) {
      return;
    }

    // Single field: existing logic
    if (_isSingleField) {
      return _addLinkPropertySingleField(url, start, end);
    }

    // Multiple fields: new logic
    return _addLinkPropertyMultiField(url, start, end);
  }

  void _addLinkPropertySingleField(String url, int start, int end) {
    final field = value!.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    var currentOffset = 0;
    const toolId = _kLinkMarkdownInlineToolsType;

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

            if (end <= spanStart || start >= spanEnd) {
              updatedSpans.add(span);
            } else {
              final overlapStart = start > spanStart ? start : spanStart;
              final overlapEnd = end < spanEnd ? end : spanEnd;

              if (spanStart < overlapStart) {
                final beforeText =
                    span.value.substring(0, overlapStart - spanStart);
                updatedSpans.add(span.copyWith(
                  id: uuid(),
                  value: beforeText,
                ));
              }

              final selectedText = span.value
                  .substring(overlapStart - spanStart, overlapEnd - spanStart);

              // URL付きのリンクプロパティを追加
              final linkProperty = LinkMarkdownSpanProperty(link: url);
              final newProperties = [
                ...span.properties.where((p) => p.type != toolId),
                linkProperty,
              ];

              updatedSpans.add(span.copyWith(
                id: uuid(),
                value: selectedText,
                properties: newProperties,
              ));

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

          updatedLines.add(line.copyWith(children: updatedSpans));
        }

        blocks[i] = block.copyWith(children: updatedLines);
        currentOffset += _getBlockTextLength(block) + 1;
      }
    }

    final newField = field.copyWith(children: blocks);

    // コントローラーの値を直接更新
    _value[0] = newField;

    // フィールドに通知して強制的に再ビルド
    _field?._updateRemoteEditingValue();
  }

  void _addLinkPropertyMultiField(String url, int start, int end) {
    final allBlocks = _getAllBlocks();

    var currentOffset = 0;
    const toolId = _kLinkMarkdownInlineToolsType;

    for (var i = 0; i < allBlocks.length; i++) {
      final block = allBlocks[i];
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

            if (end <= spanStart || start >= spanEnd) {
              updatedSpans.add(span);
            } else {
              final overlapStart = start > spanStart ? start : spanStart;
              final overlapEnd = end < spanEnd ? end : spanEnd;

              if (spanStart < overlapStart) {
                final beforeText =
                    span.value.substring(0, overlapStart - spanStart);
                updatedSpans.add(span.copyWith(
                  id: uuid(),
                  value: beforeText,
                ));
              }

              final selectedText = span.value
                  .substring(overlapStart - spanStart, overlapEnd - spanStart);

              // URL付きのリンクプロパティを追加
              final linkProperty = LinkMarkdownSpanProperty(link: url);
              final newProperties = [
                ...span.properties.where((p) => p.type != toolId),
                linkProperty,
              ];

              updatedSpans.add(span.copyWith(
                id: uuid(),
                value: selectedText,
                properties: newProperties,
              ));

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

          updatedLines.add(line.copyWith(children: updatedSpans));
        }

        allBlocks[i] = block.copyWith(children: updatedLines);
        currentOffset += _getBlockTextLength(block) + 1;
      }
    }

    // Redistribute blocks across fields
    _updateBlocksAcrossFields(allBlocks);

    // フィールドに通知して強制的に再ビルド
    _field?._updateRemoteEditingValue();
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
    // 変更前に現在の状態を保存（明示的なアクションの場合は即座に）
    history.saveToUndoStack(immediate: true);

    if (_value.isEmpty) {
      // 空の段落で初期構造を作成
      final field = MarkdownFieldValue.createEmpty();
      _value.clear();
      _value.add(field);
      notifyListeners();
      return;
    }

    // Single field: existing logic
    if (_isSingleField) {
      return _insertNewLineSingleField(offset);
    }

    // Multiple fields: new logic
    return _insertNewLineMultiField(offset);
  }

  void _insertNewLineSingleField(int offset) {
    // 現在のフィールドを取得
    final field = _value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // 分割するブロックと位置を検索
    var currentOffset = 0;
    var blockIndex = -1;
    String? textBeforeCursor;
    String? textAfterCursor;

    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      if (block is MarkdownMultiLineBlockValue) {
        final blockText = StringBuffer();

        // ブロックタイプに基づいて子要素を抽出
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

        final blockTextStr = blockText.toString();
        final blockLength = blockTextStr.length;

        if (currentOffset + blockLength >= offset) {
          // 分割するブロックを発見
          blockIndex = i;
          final localOffset = offset - currentOffset;
          textBeforeCursor = blockTextStr.substring(0, localOffset);
          textAfterCursor = blockTextStr.substring(localOffset);
          break;
        }

        currentOffset += blockLength + 1; // ブロック間の改行分+1
      }
    }

    if (blockIndex == -1) {
      // オフセットが末尾、新しいブロックを作成
      // BulletedListの場合、最後のブロックのタイプを継承するためにチェック
      final lastBlock = blocks.lastOrNull;
      if (lastBlock?.maintainTypeOnNewLine ?? true) {
        final newBlock = lastBlock?.clone();
        if (newBlock != null) {
          blocks.add(newBlock);
        }
      } else {
        blocks.add(MarkdownParagraphBlockValue(
          id: uuid(),
          children: [
            MarkdownLineValue.createEmpty(initialText: textAfterCursor),
          ],
        ));
      }
    } else {
      // 現在のブロックを分割
      final oldBlock = blocks[blockIndex];

      // Check if this block type should add a line instead of creating a new block
      if (!oldBlock.insertBlockOnNewLine &&
          oldBlock is MarkdownMultiLineBlockValue) {
        // Add a new line within the same block (for code blocks, etc.)
        final oldBlockChildren = oldBlock.extractLines() ?? [];

        // Find which line the cursor is in
        var lineCurrentOffset = 0;
        var lineIndex = -1;
        for (var i = 0; i < oldBlockChildren.length; i++) {
          final line = oldBlockChildren[i];
          final lineText = line.children.map((span) => span.value).join();
          final lineLength = lineText.length;

          final localOffset = offset - currentOffset;
          if (lineCurrentOffset + lineLength >= localOffset) {
            lineIndex = i;
            break;
          }

          lineCurrentOffset += lineLength + 1; // +1 for newline
        }

        if (lineIndex == -1) {
          lineIndex = oldBlockChildren.length - 1;
          lineCurrentOffset = oldBlockChildren
              .take(lineIndex)
              .map((line) =>
                  line.children.map((span) => span.value).join().length + 1)
              .fold(0, (a, b) => a + b);
        }

        // Split the line at the cursor position
        final targetLine = oldBlockChildren[lineIndex];
        final lineLocalOffset = offset - currentOffset - lineCurrentOffset;

        final beforeSpans = <MarkdownSpanValue>[];
        final afterSpans = <MarkdownSpanValue>[];
        var spanPos = 0;

        for (final span in targetLine.children) {
          final spanStart = spanPos;
          final spanEnd = spanPos + span.value.length;

          if (spanEnd <= lineLocalOffset) {
            beforeSpans.add(span);
          } else if (spanStart >= lineLocalOffset) {
            afterSpans.add(span.copyWith(
              id: uuid(),
              properties: const [],
            ));
          } else {
            // Split span at cursor
            final beforeText =
                span.value.substring(0, lineLocalOffset - spanStart);
            final afterText = span.value.substring(lineLocalOffset - spanStart);

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
                properties: const [],
              ));
            }
          }

          spanPos += span.value.length;
        }

        // Ensure at least one span in each line
        if (beforeSpans.isEmpty) {
          beforeSpans.add(MarkdownSpanValue(
            id: uuid(),
            value: "",
            properties: const [],
          ));
        }
        if (afterSpans.isEmpty) {
          afterSpans.add(MarkdownSpanValue(
            id: uuid(),
            value: "",
            properties: const [],
          ));
        }

        // Create new line list with split lines
        final newChildren = <MarkdownLineValue>[
          ...oldBlockChildren.take(lineIndex),
          MarkdownLineValue.createEmpty(children: beforeSpans),
          MarkdownLineValue.createEmpty(children: afterSpans),
          ...oldBlockChildren.skip(lineIndex + 1),
        ];

        // Update the block with new children
        blocks[blockIndex] = oldBlock.copyWith(children: newChildren);
      } else {
        // Original behavior: create a new block
        // ブロックタイプに基づいて子要素を抽出
        final oldBlockChildren = oldBlock.extractLines() ?? [];

        // 既存のスパンを収集
        final existingSpans = <MarkdownSpanValue>[];
        for (final line in oldBlockChildren) {
          existingSpans.addAll(line.children);
        }

        // スパン内の分割位置を検索
        final beforeSpans = <MarkdownSpanValue>[];
        final afterSpans = <MarkdownSpanValue>[];
        var currentPos = 0;
        final localOffset = offset - currentOffset;

        for (final span in existingSpans) {
          final spanStart = currentPos;
          final spanEnd = currentPos + span.value.length;

          if (spanEnd <= localOffset) {
            // スパンが分割前に完全にある - プロパティ付きで前のブロックに保持
            beforeSpans.add(span);
          } else if (spanStart >= localOffset) {
            // スパンが分割後に完全にある - プロパティなしで後のブロックに移動
            afterSpans.add(span.copyWith(
              id: uuid(),
              properties: const [], // 改行後のテキストからプロパティを削除
            ));
          } else {
            // カーソル位置でスパンを分割
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
                properties: const [], // 新しい行はプロパティなしで始まる
              ));
            }
          }

          currentPos += span.value.length;
        }

        // 各ブロックに少なくとも1つのスパンがあることを確認
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

        // カーソル前のテキストでブロックを作成（プロパティ、ブロックタイプ、インデントを保持）
        if (oldBlock.maintainTypeOnNewLine) {
          final beforeBlock = oldBlock.clone(
            child: MarkdownLineValue.createEmpty(
              children: beforeSpans,
            ),
          );

          // カーソル後のテキストで新しいブロックを作成
          // BulletedListブロックの場合、ブロックタイプとインデントレベルを継承
          // その他のブロックの場合、段落を作成
          final afterBlock = oldBlock.clone(
            child: MarkdownLineValue.createEmpty(
              children: afterSpans,
            ),
          );

          // 古いブロックを前後のブロックで置換
          blocks[blockIndex] = beforeBlock;
          blocks.insert(blockIndex + 1, afterBlock);
        } else {
          final beforeBlock = oldBlock.clone(
            child: MarkdownLineValue.createEmpty(
              children: beforeSpans,
            ),
          );
          final afterBlock = MarkdownParagraphBlockValue.createEmpty(
            children: [
              MarkdownLineValue.createEmpty(
                children: afterSpans,
              ),
            ],
          );

          // 古いブロックを前後のブロックで置換
          blocks[blockIndex] = beforeBlock;
          blocks.insert(blockIndex + 1, afterBlock);
        }
      }
    }

    // 新しいブロックでフィールドを更新
    final newField = MarkdownFieldValue(
      id: field.id,
      children: blocks,
    );

    _value[0] = newField;

    // 新しいブロック（分割後のブロック）の先頭にカーソルを移動
    // offset + 1 は新しいブロックの開始位置（改行文字の次）
    if (_field != null) {
      _field!._selection = TextSelection.collapsed(offset: offset + 1);
    }

    notifyListeners();
  }

  void _insertNewLineMultiField(int offset) {
    // Get all blocks across all fields
    final allBlocks = _getAllBlocks();

    // 分割するブロックと位置を検索
    var currentOffset = 0;
    var blockIndex = -1;
    String? textBeforeCursor;
    String? textAfterCursor;

    for (var i = 0; i < allBlocks.length; i++) {
      final block = allBlocks[i];
      if (block is MarkdownMultiLineBlockValue) {
        final blockText = StringBuffer();

        // ブロックタイプに基づいて子要素を抽出
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

        final blockTextStr = blockText.toString();
        final blockLength = blockTextStr.length;

        if (currentOffset + blockLength >= offset) {
          // 分割するブロックを発見
          blockIndex = i;
          final localOffset = offset - currentOffset;
          textBeforeCursor = blockTextStr.substring(0, localOffset);
          textAfterCursor = blockTextStr.substring(localOffset);
          break;
        }

        currentOffset += blockLength + 1; // ブロック間の改行分+1
      }
    }

    if (blockIndex == -1) {
      // オフセットが末尾、新しいブロックを作成
      // BulletedListの場合、最後のブロックのタイプを継承するためにチェック
      final lastBlock = allBlocks.lastOrNull;
      if (lastBlock?.maintainTypeOnNewLine ?? true) {
        final newBlock = lastBlock?.clone();
        if (newBlock != null) {
          allBlocks.add(newBlock);
        }
      } else {
        allBlocks.add(MarkdownParagraphBlockValue(
          id: uuid(),
          children: [
            MarkdownLineValue.createEmpty(initialText: textAfterCursor),
          ],
        ));
      }
    } else {
      // 現在のブロックを分割
      final oldBlock = allBlocks[blockIndex];

      // Check if this block type should add a line instead of creating a new block
      if (!oldBlock.insertBlockOnNewLine &&
          oldBlock is MarkdownMultiLineBlockValue) {
        // Add a new line within the same block (for code blocks, etc.)
        final oldBlockChildren = oldBlock.extractLines() ?? [];

        // Find which line the cursor is in
        var lineCurrentOffset = 0;
        var lineIndex = -1;
        for (var i = 0; i < oldBlockChildren.length; i++) {
          final line = oldBlockChildren[i];
          final lineText = line.children.map((span) => span.value).join();
          final lineLength = lineText.length;

          final localOffset = offset - currentOffset;
          if (lineCurrentOffset + lineLength >= localOffset) {
            lineIndex = i;
            break;
          }

          lineCurrentOffset += lineLength + 1; // +1 for newline
        }

        if (lineIndex == -1) {
          lineIndex = oldBlockChildren.length - 1;
          lineCurrentOffset = oldBlockChildren
              .take(lineIndex)
              .map((line) =>
                  line.children.map((span) => span.value).join().length + 1)
              .fold(0, (a, b) => a + b);
        }

        // Split the line at the cursor position
        final targetLine = oldBlockChildren[lineIndex];
        final lineLocalOffset = offset - currentOffset - lineCurrentOffset;

        final beforeSpans = <MarkdownSpanValue>[];
        final afterSpans = <MarkdownSpanValue>[];
        var spanPos = 0;

        for (final span in targetLine.children) {
          final spanStart = spanPos;
          final spanEnd = spanPos + span.value.length;

          if (spanEnd <= lineLocalOffset) {
            beforeSpans.add(span);
          } else if (spanStart >= lineLocalOffset) {
            afterSpans.add(span.copyWith(
              id: uuid(),
              properties: const [],
            ));
          } else {
            // Split span at cursor
            final beforeText =
                span.value.substring(0, lineLocalOffset - spanStart);
            final afterText = span.value.substring(lineLocalOffset - spanStart);

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
                properties: const [],
              ));
            }
          }

          spanPos += span.value.length;
        }

        // Ensure at least one span in each line
        if (beforeSpans.isEmpty) {
          beforeSpans.add(MarkdownSpanValue(
            id: uuid(),
            value: "",
            properties: const [],
          ));
        }
        if (afterSpans.isEmpty) {
          afterSpans.add(MarkdownSpanValue(
            id: uuid(),
            value: "",
            properties: const [],
          ));
        }

        // Create new line list with split lines
        final newChildren = <MarkdownLineValue>[
          ...oldBlockChildren.take(lineIndex),
          MarkdownLineValue.createEmpty(children: beforeSpans),
          MarkdownLineValue.createEmpty(children: afterSpans),
          ...oldBlockChildren.skip(lineIndex + 1),
        ];

        // Update the block with new children
        allBlocks[blockIndex] = oldBlock.copyWith(children: newChildren);
      } else {
        // Original behavior: create a new block
        // ブロックタイプに基づいて子要素を抽出
        final oldBlockChildren = oldBlock.extractLines() ?? [];

        // 既存のスパンを収集
        final existingSpans = <MarkdownSpanValue>[];
        for (final line in oldBlockChildren) {
          existingSpans.addAll(line.children);
        }

        // スパン内の分割位置を検索
        final beforeSpans = <MarkdownSpanValue>[];
        final afterSpans = <MarkdownSpanValue>[];
        var currentPos = 0;
        final localOffset = offset - currentOffset;

        for (final span in existingSpans) {
          final spanStart = currentPos;
          final spanEnd = currentPos + span.value.length;

          if (spanEnd <= localOffset) {
            // スパンが分割前に完全にある - プロパティ付きで前のブロックに保持
            beforeSpans.add(span);
          } else if (spanStart >= localOffset) {
            // スパンが分割後に完全にある - プロパティなしで後のブロックに移動
            afterSpans.add(span.copyWith(
              id: uuid(),
              properties: const [], // 改行後のテキストからプロパティを削除
            ));
          } else {
            // カーソル位置でスパンを分割
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
                properties: const [], // 新しい行はプロパティなしで始まる
              ));
            }
          }

          currentPos += span.value.length;
        }

        // 各ブロックに少なくとも1つのスパンがあることを確認
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

        // カーソル前のテキストでブロックを作成（プロパティ、ブロックタイプ、インデントを保持）
        if (oldBlock.maintainTypeOnNewLine) {
          final beforeBlock = oldBlock.clone(
            child: MarkdownLineValue.createEmpty(
              children: beforeSpans,
            ),
          );

          // カーソル後のテキストで新しいブロックを作成
          // BulletedListブロックの場合、ブロックタイプとインデントレベルを継承
          // その他のブロックの場合、段落を作成
          final afterBlock = oldBlock.clone(
            child: MarkdownLineValue.createEmpty(
              children: afterSpans,
            ),
          );

          // 古いブロックを前後のブロックで置換
          allBlocks[blockIndex] = beforeBlock;
          allBlocks.insert(blockIndex + 1, afterBlock);
        } else {
          final beforeBlock = oldBlock.clone(
            child: MarkdownLineValue.createEmpty(
              children: beforeSpans,
            ),
          );
          final afterBlock = MarkdownParagraphBlockValue.createEmpty(
            children: [
              MarkdownLineValue.createEmpty(
                children: afterSpans,
              ),
            ],
          );

          // 古いブロックを前後のブロックで置換
          allBlocks[blockIndex] = beforeBlock;
          allBlocks.insert(blockIndex + 1, afterBlock);
        }
      }
    }

    // Redistribute blocks across fields
    _updateBlocksAcrossFields(allBlocks);

    // 新しいブロック（分割後のブロック）の先頭にカーソルを移動
    // offset + 1 は新しいブロックの開始位置（改行文字の次）
    if (_field != null) {
      _field!._selection = TextSelection.collapsed(offset: offset + 1);
    }

    notifyListeners();
  }

  /// Toggles the checked state of the block.
  ///
  /// Toggles the current value if `[checked]` is not specified.
  ///
  /// ブロックのチェック状態をトグルします。
  ///
  /// [checked]が指定されていない場合は現在の値を参照してトグルします。
  void toggleBlock(MarkdownToggleListBlockValue block, {bool? checked}) {
    if (_value.isEmpty) {
      return;
    }

    // Single field: existing logic
    if (_isSingleField) {
      return _toggleBlockSingleField(block, checked);
    }

    // Multiple fields: new logic
    return _toggleBlockMultiField(block, checked);
  }

  void _toggleBlockSingleField(
      MarkdownToggleListBlockValue block, bool? checked) {
    final field = _value.first;

    // Find the block index in the children list
    final blockIndex = field.children.indexWhere((b) => b.id == block.id);
    if (blockIndex == -1) {
      return;
    }

    // Create a new block with toggled checked state
    final newChecked = checked ?? !block.checked;
    final newBlock = block.copyWith(checked: newChecked);

    // Create a new children list with the updated block
    final newChildren = List<MarkdownBlockValue>.from(field.children);
    newChildren[blockIndex] = newBlock;

    // Update the field with new children
    final newField = field.copyWith(children: newChildren);
    _value[0] = newField;
    notifyListeners();
  }

  void _toggleBlockMultiField(
      MarkdownToggleListBlockValue block, bool? checked) {
    // Get all blocks across all fields
    final allBlocks = _getAllBlocks();

    // Find the block index in the all blocks list
    final blockIndex = allBlocks.indexWhere((b) => b.id == block.id);
    if (blockIndex == -1) {
      return;
    }

    // Create a new block with toggled checked state
    final newChecked = checked ?? !block.checked;
    final newBlock = block.copyWith(checked: newChecked);

    // Update the block in the list
    allBlocks[blockIndex] = newBlock;

    // Redistribute blocks across fields
    _updateBlocksAcrossFields(allBlocks);
    notifyListeners();
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

    // カーソル直前の位置がリンク内にあるかチェック
    final checkOffset = cursorOffset - 1;
    var currentOffset = 0;
    String? targetLinkUrl;
    int? linkStart;
    int? linkEnd;

    // マークダウン構造を走査
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

              // checkOffsetがこのスパン内にあるかチェック
              if (checkOffset >= spanStart && checkOffset < spanEnd) {
                // このスパンがリンクプロパティを持つかチェック
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
            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          if (targetLinkUrl != null) {
            break;
          }
          // 各段落ブロックの後に改行分+1（最後のものを除く）
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

    // 2回目のパス: 同じリンクURLを持つ連続するスパンの完全な範囲を検索
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

              // このスパンが同じリンクURLを持つかチェック
              var hasTargetLink = false;
              for (final property in span.properties) {
                if (property is LinkMarkdownSpanProperty &&
                    property.link == targetLinkUrl) {
                  hasTargetLink = true;
                  break;
                }
              }

              if (hasTargetLink) {
                // リンク範囲を拡張
                linkStart ??= spanStart;
                linkEnd = spanEnd;
              } else if (linkStart != null) {
                // 連続するリンクスパンの終わりを発見
                // ただし、checkOffsetを既に通過している場合のみ返す
                if (currentOffset > checkOffset) {
                  return TextRange(start: linkStart, end: linkEnd!);
                }
                // 次の潜在的なリンク範囲のためにリセット
                linkStart = null;
                linkEnd = null;
              }

              currentOffset += spanLength;
            }
            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          // 各段落ブロックの後に改行分+1（最後のものを除く）
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
    }

    // 見つかった場合は範囲を返す
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
    // 現在のカーソル位置にメンションを挿入
    final selection = field._selection;
    if (selection.isCollapsed) {
      final cursorPosition = selection.baseOffset;
      // メンションテキストを挿入: @{mention.name}
      final mentionText = "@${mention.name}";

      // 検証: メンションテキストに改行が含まれていないことを確認
      if (mentionText.contains("\n")) {
        return;
      }

      // メンションテキストとプロパティをアトミック操作として挿入
      // （両方を単一のUndo履歴エントリに結合）
      // 選択されたテキストを置換またはカーソル位置に挿入
      replaceText(
        cursorPosition,
        cursorPosition,
        mentionText,
      );
      // メンションプロパティを追加（replaceTextが既に保存しているため履歴をスキップ）
      addInlineProperty(
        const MentionMarkdownPrimaryTools(),
        start: cursorPosition,
        end: cursorPosition + mentionText.length,
        value: mention,
        skipHistory: true,
      );
      // カーソルをメンションの後に移動
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

    // カーソル直前の位置がメンション内にあるかチェック
    final checkOffset = cursorOffset - 1;
    var currentOffset = 0;
    MarkdownMention? targetMention;
    int? mentionStart;
    int? mentionEnd;

    // マークダウン構造を走査
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

              // checkOffsetがこのスパン内にあるかチェック
              if (checkOffset >= spanStart && checkOffset < spanEnd) {
                // このスパンがメンションプロパティを持つかチェック
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
            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          if (targetMention != null) {
            break;
          }
          // 各段落ブロックの後に改行分+1（最後のものを除く）
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

    // 2回目のパス: 同じメンションを持つ連続するスパンの完全な範囲を検索
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

              // このスパンが同じメンションを持つかチェック
              var hasTargetMention = false;
              for (final property in span.properties) {
                if (property is MentionMarkdownSpanProperty &&
                    property.mention.id == targetMention.id) {
                  hasTargetMention = true;
                  break;
                }
              }

              if (hasTargetMention) {
                // メンション範囲を拡張
                mentionStart ??= spanStart;
                mentionEnd = spanEnd;
              } else if (mentionStart != null) {
                // 連続するメンションスパンの終わりを発見
                // ただし、checkOffsetを既に通過している場合のみ返す
                if (currentOffset > checkOffset) {
                  return TextRange(start: mentionStart, end: mentionEnd!);
                }
                // 次の潜在的なメンション範囲のためにリセット
                mentionStart = null;
                mentionEnd = null;
              }

              currentOffset += spanLength;
            }
            // ブロック内の最後の行でない場合のみ改行分+1
            if (lineIndex < lines.length - 1) {
              currentOffset += 1;
            }
          }
          // 各段落ブロックの後に改行分+1（最後のものを除く）
          if (blockIndex < blocks.length - 1) {
            currentOffset += 1;
          }
        }
      }
    }

    // 見つかった場合は範囲を返す
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

    final blocks = _isSingleField ? _value.first.children : _getAllBlocks();
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

        // このブロックが選択内にあるかチェック
        // 選択と重なる場合、ブロックは選択されている
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
        // マージ
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

    final blocks = _isSingleField ? _value.first.children : _getAllBlocks();
    final extractedSpans = <MarkdownSpanValue>[];

    var currentOffset = 0;

    for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
      final block = blocks[blockIndex];
      if (block is MarkdownMultiLineBlockValue) {
        final blockLength = _getBlockTextLength(block);
        final blockStart = currentOffset;
        // final blockEnd = blockStart + blockLength;

        var lineOffset = blockStart;
        for (var lineIndex = 0;
            lineIndex < block.children.length;
            lineIndex++) {
          final line = block.children[lineIndex];

          for (final span in line.children) {
            final spanStart = lineOffset;
            final spanEnd = lineOffset + span.value.length;

            // このスパンが選択と重なるかチェック
            if (end > spanStart && start < spanEnd) {
              // 重なりを計算
              final overlapStart = start > spanStart ? start : spanStart;
              final overlapEnd = end < spanEnd ? end : spanEnd;

              // 重なっている部分を抽出
              final extractedText = span.value.substring(
                overlapStart - spanStart,
                overlapEnd - spanStart,
              );

              // 抽出されたテキストと同じプロパティで新しいスパンを作成
              extractedSpans.add(span.copyWith(
                id: uuid(),
                value: extractedText,
              ));
            }

            lineOffset += span.value.length;
          }
          if (lineIndex < block.children.length - 1) {
            lineOffset += 1; // Account for newline between lines
          }
        }

        // ブロック境界の改行が選択に含まれる場合は追加
        if (blockIndex < blocks.length - 1 &&
            end > blockStart + blockLength &&
            start <= blockStart + blockLength) {
          extractedSpans.add(
            MarkdownSpanValue.createEmpty(initialText: "\n"),
          );
        }

        currentOffset = blockStart + blockLength + 1; // +1 for newline
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

        // 選択がこのブロックと正確に一致するかチェック
        if (start == blockStart && end == blockEnd) {
          return (isFullBlock: true, blockType: block.type);
        }

        currentOffset = blockEnd + 1; // +1 for newline
      }
    }

    return (isFullBlock: false, blockType: null);
  }

  // ========================================================================
  // Multi-Field Support Helper Methods
  // 複数フィールド対応のヘルパーメソッド
  // ========================================================================

  /// Returns true if the controller has only one field (backward compatibility mode).
  ///
  /// コントローラーが単一フィールドのみを持つ場合にtrueを返す（後方互換性モード）。
  bool get _isSingleField => _value.length <= 1;

  /// Gets all blocks across all fields as a flat list.
  ///
  /// すべてのフィールドのすべてのブロックをフラットなリストとして取得します。
  List<MarkdownBlockValue> _getAllBlocks() {
    final result = <MarkdownBlockValue>[];

    for (final field in _value) {
      result.addAll(field.children);
    }

    return result;
  }

  /// Updates the _value by distributing blocks back to fields.
  ///
  /// This method takes a flat list of blocks and distributes them back to the original fields
  /// based on the original field structure. Blocks can be added or removed, and this method
  /// will attempt to maintain the field boundaries as much as possible.
  ///
  /// ブロックをフィールドに配分して _value を更新します。
  ///
  /// このメソッドはブロックのフラットなリストを受け取り、元のフィールド構造に基づいて
  /// 元のフィールドに配分します。ブロックの追加や削除が可能で、このメソッドは
  /// 可能な限りフィールドの境界を維持しようとします。
  void _updateBlocksAcrossFields(List<MarkdownBlockValue> allBlocks) {
    if (_value.isEmpty) {
      // Create a new field with all blocks
      _value.add(MarkdownFieldValue(
        id: uuid(),
        children: allBlocks,
      ));
      return;
    }

    // Calculate the original distribution of blocks per field
    final originalBlockCounts = _value.map((f) => f.children.length).toList();
    final totalOriginalBlocks =
        originalBlockCounts.fold(0, (sum, count) => sum + count);

    if (totalOriginalBlocks == 0) {
      // All fields were empty, put all blocks in the first field
      _value[0] = _value[0].copyWith(children: allBlocks);
      return;
    }

    // Distribute blocks back to fields proportionally
    var blockIndex = 0;
    for (var fieldIndex = 0; fieldIndex < _value.length; fieldIndex++) {
      final originalCount = originalBlockCounts[fieldIndex];
      final field = _value[fieldIndex];

      if (fieldIndex == _value.length - 1) {
        // Last field gets all remaining blocks
        final remainingBlocks = allBlocks.sublist(blockIndex);
        _value[fieldIndex] = field.copyWith(children: remainingBlocks);
      } else {
        // Calculate how many blocks this field should get
        final ratio = originalCount / totalOriginalBlocks;
        var targetCount = (allBlocks.length * ratio).round();

        // Ensure we don't exceed available blocks
        targetCount = targetCount.clamp(0, allBlocks.length - blockIndex);

        // Ensure at least some blocks if the field originally had blocks
        if (originalCount > 0 &&
            targetCount == 0 &&
            blockIndex < allBlocks.length) {
          targetCount = 1;
        }

        final fieldBlocks = allBlocks.sublist(
          blockIndex,
          blockIndex + targetCount,
        );
        _value[fieldIndex] = field.copyWith(children: fieldBlocks);
        blockIndex += targetCount;
      }
    }
  }

  @override
  void dispose() {
    // 保留中の履歴保存をキャンセル
    history.dispose();

    // コールバックをクリア
    _onShowLinkDialog = null;

    // フォーカスノードを破棄
    focusNode.dispose();

    super.dispose();
  }
}

List<List<MarkdownSpanValue>> _splitSpansByNewline(
  List<MarkdownSpanValue> spans,
) {
  final result = <List<MarkdownSpanValue>>[];
  var current = <MarkdownSpanValue>[];

  void flush() {
    if (current.isEmpty) {
      current = [MarkdownSpanValue.createEmpty(initialText: "")];
    }
    result.add(current);
    current = <MarkdownSpanValue>[];
  }

  for (final span in spans) {
    final value = span.value;
    if (!value.contains("\n")) {
      current.add(span);
      continue;
    }

    var remaining = value;
    while (true) {
      final index = remaining.indexOf("\n");
      if (index == -1) {
        if (remaining.isNotEmpty) {
          current.add(span.copyWith(
            id: uuid(),
            value: remaining,
          ));
        }
        break;
      }

      final before = remaining.substring(0, index);
      if (before.isNotEmpty) {
        current.add(span.copyWith(
          id: uuid(),
          value: before,
        ));
      }
      flush();
      remaining = remaining.substring(index + 1);
      if (remaining.isEmpty) {
        flush();
        break;
      }
    }
  }

  if (current.isNotEmpty) {
    flush();
  }

  if (result.isEmpty) {
    result.add([MarkdownSpanValue.createEmpty(initialText: "")]);
  }

  // Remove leading/trailing empty groups when there are other non-empty groups.
  if (result.length > 1) {
    while (result.length > 1 && _groupIsEmpty(result.first)) {
      result.removeAt(0);
    }
    while (result.length > 1 && _groupIsEmpty(result.last)) {
      result.removeLast();
    }
  }

  return result;
}

bool _groupIsEmpty(List<MarkdownSpanValue> group) {
  if (group.isEmpty) {
    return true;
  }
  for (final span in group) {
    if (span.value.isNotEmpty) {
      return false;
    }
  }
  return true;
}

@immutable
class _$MarkdownControllerQuery {
  const _$MarkdownControllerQuery();

  @useResult
  _$_MarkdownControllerQuery call({
    MarkdownMasamuneAdapter? adapter,
    List<MarkdownFieldValue>? initialValue,
    String? initialMarkdown,
    DynamicMap? initialJson,
  }) =>
      _$_MarkdownControllerQuery(
        hashCode.toString(),
        adapter: adapter,
        initialValue: initialValue,
        initialMarkdown: initialMarkdown,
        initialJson: initialJson,
      );
}

@immutable
class _$_MarkdownControllerQuery
    extends ControllerQueryBase<MarkdownController> {
  const _$_MarkdownControllerQuery(
    this._name, {
    this.adapter,
    this.initialValue,
    this.initialMarkdown,
    this.initialJson,
  });

  final String _name;

  final MarkdownMasamuneAdapter? adapter;

  final List<MarkdownFieldValue>? initialValue;
  final String? initialMarkdown;
  final DynamicMap? initialJson;

  @override
  MarkdownController Function() call(Ref ref) {
    return () => MarkdownController(
          adapter: adapter,
          initialValue: initialValue,
          initialMarkdown: initialMarkdown,
          initialJson: initialJson,
        );
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
