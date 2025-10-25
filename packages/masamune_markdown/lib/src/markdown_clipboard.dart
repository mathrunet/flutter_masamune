part of "/masamune_markdown.dart";

/// Controller for clipboard.
///
/// クリップボードのコントローラー。
class MarkdownClipboard {
  MarkdownClipboard._(this._controller);

  final MarkdownController _controller;

  MarkdownFieldState? get _field => _controller._field;

  static const _platform = PlatformInfo();

  /// Internal clipboard storage for preserving span properties and block information.
  ///
  /// スパンのプロパティとブロック情報を保持するための内部クリップボードストレージ。
  _ClipboardData? _internalClipboard;

  /// The raw text of the current clipboard.
  ///
  /// 現在のクリップボードの生テキスト。
  Future<String> get currentText async {
    if (_platform.isTest) {
      return _internalClipboard?.text ?? "";
    }
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    return clipboardData?.text ?? "";
  }

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

    // IME入力中の変換テキストを含むテキストを取得
    final text = field.composingText ?? _controller.rawText;

    // 選択範囲を検証
    if (selection.end > text.length) {
      return;
    }

    final selectedText = selection.textInside(text);

    if (selectedText.isNotEmpty) {
      // プロパティ付きのスパンを抽出
      final extractedSpans = _controller._extractSpansFromSelection(
          selection.start, selection.end);

      // ブロック全体が選択されているかをチェック
      final blockInfo =
          _controller._isFullBlockSelected(selection.start, selection.end);
      final blockType =
          (blockInfo?.isFullBlock ?? false) ? blockInfo?.blockType : null;

      // インデント情報を取得
      final indent = _getIndentAtSelection(selection.start, selection.end);

      // ブロック情報付きで内部クリップボードに保存
      _internalClipboard = _ClipboardData(
        spans: extractedSpans,
        blockType: blockType,
        indent: indent,
      );

      // 外部ペースト用にシステムクリップボードにもプレーンテキストをコピー
      if (!_platform.isTest) {
        await Clipboard.setData(ClipboardData(text: selectedText));
      }

      // コピー後にテキストの選択を解除
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

    // カット前に変換テキストがある場合は、まず確定する
    if (field.composingText != null) {
      final composingText = field.composingText!;
      final currentText = _controller.rawText;

      // 変換テキストをコントローラーに確定
      _controller.replaceText(0, currentText.length, composingText);

      // 変換状態をクリア
      field._composingText = null;
      field._composingRegion = null;

      // 現在の選択を維持
      field._updateRemoteEditingValue();
    }

    final selection = field._selection;

    if (!selection.isValid || selection.isCollapsed) {
      return;
    }

    // Get text including composing text during IME input
    final text = field.composingText ?? _controller.rawText;

    // Validate selection range
    if (selection.end > text.length) {
      return;
    }

    final selectedText = selection.textInside(text);

    if (selectedText.isNotEmpty) {
      // プロパティ付きのスパンを抽出
      // 重要: replaceTextの前に実行する必要がある（replaceTextがスパンをマージする可能性があるため）
      final extractedSpans = _controller._extractSpansFromSelection(
          selection.start, selection.end);

      // ブロック全体が選択されているかをチェック
      final blockInfo =
          _controller._isFullBlockSelected(selection.start, selection.end);
      final blockType =
          (blockInfo?.isFullBlock ?? false) ? blockInfo?.blockType : null;

      // インデント情報を取得
      final indent = _getIndentAtSelection(selection.start, selection.end);

      // ブロック情報付きで内部クリップボードに保存
      _internalClipboard = _ClipboardData(
        spans: extractedSpans,
        blockType: blockType,
        indent: indent,
      );

      // 外部ペースト用にシステムクリップボードにもプレーンテキストをコピー
      if (!_platform.isTest) {
        await Clipboard.setData(ClipboardData(text: selectedText));
      }

      // 変更前に現在の状態を保存（replaceTextも保存するため、ここではスキップ）
      // 選択されたテキストを削除
      _controller.replaceText(selection.start, selection.end, "");

      // 選択を開始位置で折りたたむように更新
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

    // 変換テキストがある場合は、クリアするだけ
    // テキストは既にコントローラーにあるため、置換は不要
    if (field.composingText != null) {
      // 変換状態をクリア
      field._composingText = null;
      field._composingRegion = null;

      // 現在の選択を維持
      field._updateRemoteEditingValue();
    }

    final selection = field._selection;
    if (!selection.isValid) {
      return;
    }

    final start = selection.start;
    final end = selection.end;
    final previousText = _controller.rawText;
    final removedLength = end > start ? end - start : 0;
    var modified = false;

    // テスト環境では内部クリップボードを使用する
    if (_platform.isTest) {
      if (_internalClipboard != null && _internalClipboard!.spans.isNotEmpty) {
        modified = true;
        // クリップボードにブロックタイプ情報がある場合、新しいブロックを作成
        if (_internalClipboard!.blockType != null) {
          _pasteAsBlock(
            start,
            end,
            _internalClipboard!.spans,
            _internalClipboard!.blockType!,
            indent: _internalClipboard!.indent,
          );
        } else {
          // プロパティ付きのスパンを復元（部分選択）
          _pasteSpansWithProperties(
            start,
            end,
            _internalClipboard!.spans,
            indent: _internalClipboard!.indent,
          );
        }
      } else {
        return;
      }
    } else {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

      if (clipboardData == null || clipboardData.text == null) {
        return;
      }

      final text = clipboardData.text!;
      if (text.isEmpty) {
        return;
      }

      modified = true;

      // ペーストしたテキストに改行が含まれているかチェック
      if (text.contains("\n")) {
        final lines = text.split("\n");

        if (end > start) {
          _controller.replaceText(start, end, "");
        }

        var currentOffset = start;

        if (lines.isNotEmpty && lines.first.isNotEmpty) {
          _controller.replaceText(currentOffset, currentOffset, lines.first);
          currentOffset += lines.first.length;
        }

        for (var i = 1; i < lines.length; i++) {
          _controller.insertNewLine(currentOffset);
          currentOffset++; // 改行文字を考慮

          if (lines[i].isNotEmpty) {
            _controller.replaceText(currentOffset, currentOffset, lines[i]);
            currentOffset += lines[i].length;
          }
        }
      } else if (_internalClipboard != null &&
          _internalClipboard!.spans.isNotEmpty) {
        if (_internalClipboard!.blockType != null) {
          _pasteAsBlock(
            start,
            end,
            _internalClipboard!.spans,
            _internalClipboard!.blockType!,
            indent: _internalClipboard!.indent,
          );
        } else {
          _pasteSpansWithProperties(
            start,
            end,
            _internalClipboard!.spans,
            indent: _internalClipboard!.indent,
          );
        }
      } else {
        _controller.replaceText(start, end, text);
      }
    }

    if (!modified) {
      return;
    }

    final newText = _controller.rawText;
    final insertedLength =
        newText.length - (previousText.length - removedLength);
    final newCursorPosition = (start + insertedLength).clamp(0, newText.length);
    field._selection = TextSelection.collapsed(offset: newCursorPosition);

    _field!._updateRemoteEditingValue();
    _controller._notifyListeners();
  }

  /// Pastes spans with their properties at the specified position.
  ///
  /// 指定された位置にプロパティ付きのスパンをペーストします。
  void _pasteSpansWithProperties(
    int start,
    int end,
    List<MarkdownSpanValue> spans, {
    int? indent,
  }) {
    if (_controller._value.isEmpty) {
      return;
    }

    final insertedText = spans.map((span) => span.value).join();
    final hasFormatting = spans.any((span) => span.properties.isNotEmpty);

    if (insertedText.contains("\n") && !hasFormatting && indent == null) {
      _controller.replaceText(start, end, insertedText);
      return;
    }

    if (insertedText.contains("\n")) {
      // 改行を含む場合は、複数ブロックとして挿入
      if (end > start) {
        _controller.replaceText(start, end, "");
      }

      var currentOffset = start;
      final lines = insertedText.split("\n");

      for (var i = 0; i < lines.length; i++) {
        if (i > 0) {
          _controller.insertNewLine(currentOffset);
          currentOffset++; // 改行文字を考慮

          // インデント情報を適用
          if (indent != null && indent > 0) {
            _applyIndentAtOffset(currentOffset, indent);
          }
        }

        if (lines[i].isNotEmpty) {
          _controller.replaceText(currentOffset, currentOffset, lines[i]);
          currentOffset += lines[i].length;
        }
      }

      return;
    }

    // 変更前に現在の状態を保存
    _controller.history.saveToUndoStack(immediate: true);

    final field = _controller._value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // 開始位置を含むブロックを検索
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

    // 選択されたテキストがあれば削除
    if (end > start) {
      _controller.replaceText(start, end, "");
      // 削除後に位置を再計算する必要がある
      // 簡単のため、開始位置に挿入する
    }

    // 挿入位置でターゲットスパンを分割
    final beforeText = targetSpan.value.substring(0, offsetInSpan);
    final afterText = targetSpan.value.substring(offsetInSpan);

    // 新しいスパンリストを構築
    final newSpans = <MarkdownSpanValue>[];

    // ターゲットの前のスパンを追加
    newSpans.addAll(lineSpans.take(targetSpanIndex));

    // 分割されたスパンの「前」部分を追加
    if (beforeText.isNotEmpty) {
      newSpans.add(targetSpan.copyWith(
        id: uuid(),
        value: beforeText,
      ));
    }

    // ペーストされたスパンを追加
    newSpans.addAll(spans);

    // 分割されたスパンの「後」部分を追加
    if (afterText.isNotEmpty) {
      newSpans.add(targetSpan.copyWith(
        id: uuid(),
        value: afterText,
      ));
    }

    // ターゲット後の残りのスパンを追加
    if (targetSpanIndex + 1 < lineSpans.length) {
      newSpans.addAll(lineSpans.skip(targetSpanIndex + 1));
    }

    // 同一プロパティの隣接スパンを統合
    final mergedSpans = _controller._mergeSpans(newSpans);

    final updatedLine = line.copyWith(children: mergedSpans);
    lines[targetLineIndex] = updatedLine;
    final updatedBlock = block.copyWith(children: lines);
    blocks[targetBlockIndex] = updatedBlock;

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
    String blockType, {
    int? indent,
  }) {
    if (_controller._value.isEmpty) {
      return;
    }

    // 変更前に現在の状態を保存
    _controller.history.saveToUndoStack(immediate: true);

    final field = _controller._value.first;
    final blocks = List<MarkdownBlockValue>.from(field.children);

    // 選択されたテキストがあれば削除
    if (end > start) {
      _controller.replaceText(start, end, "");
    }

    // 新しいブロックを挿入すべきブロックインデックスを検索
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

      currentOffset = blockEnd + 1; // 改行分+1
    }

    // ペーストされたスパンで新しい行を作成
    final newLine = MarkdownLineValue(
      id: uuid(),
      children: spans,
    );

    // ブロックタイプに基づいて新しいブロックを作成
    final blockTool =
        MarkdownMasamuneAdapter.findTools<MarkdownBlockVariableTools>(
      toolId: blockType,
    ).firstOrNull;
    var newBlock = blockTool != null
        ? blockTool.createBlockValue(children: [newLine])
        : MarkdownBlockValue.createEmpty(children: [newLine]);

    // インデント情報を適用
    if (indent != null && indent > 0 && newBlock is MarkdownParagraphBlockValue) {
      newBlock = newBlock.copyWith(indent: indent);
    }

    // 新しいブロックを挿入
    blocks.insert(insertAtBlockIndex, newBlock);

    final newField = field.copyWith(children: blocks);
    _controller._value[0] = newField;
    _controller._notifyListeners();
  }

  /// Gets the indent level at the selection.
  ///
  /// 選択範囲のインデントレベルを取得します。
  int? _getIndentAtSelection(int start, int end) {
    if (_controller._value.isEmpty) {
      return null;
    }

    var currentOffset = 0;
    int? indent;

    for (final field in _controller._value) {
      for (final block in field.children) {
        final blockLength = _controller._getBlockTextLength(block);
        final blockStart = currentOffset;
        final blockEnd = currentOffset + blockLength;

        // 選択範囲がこのブロックと重なるかチェック
        if (start < blockEnd && end > blockStart) {
          if (block is MarkdownParagraphBlockValue) {
            // 最初に見つかったブロックのインデントを返す
            // ブロック間をまたぐ場合は最初のブロックのインデントを使用
            if (indent == null && block.indent > 0) {
              indent = block.indent;
            }
          }
        }

        currentOffset = blockEnd + 1; // +1 for newline
      }
    }

    return indent;
  }

  /// Applies indent to the block at the specified offset.
  ///
  /// 指定されたオフセットのブロックにインデントを適用します。
  void _applyIndentAtOffset(int offset, int indent) {
    if (_controller._value.isEmpty) {
      return;
    }

    var currentOffset = 0;

    for (final field in _controller._value) {
      final blocks = List<MarkdownBlockValue>.from(field.children);

      for (var blockIndex = 0; blockIndex < blocks.length; blockIndex++) {
        final block = blocks[blockIndex];
        final blockLength = _controller._getBlockTextLength(block);
        final blockStart = currentOffset;
        final blockEnd = currentOffset + blockLength;

        // オフセットがこのブロック内にあるかチェック
        if (offset >= blockStart && offset <= blockEnd) {
          if (block is MarkdownParagraphBlockValue) {
            // インデントを適用
            blocks[blockIndex] = block.copyWith(indent: indent);
            final newField = field.copyWith(children: blocks);
            _controller._value[0] = newField;
            _controller._notifyListeners();
            return;
          }
        }

        currentOffset = blockEnd + 1; // +1 for newline
      }
    }
  }
}

/// Represents clipboard data with block information.
///
/// ブロック情報を含むクリップボードデータ。
class _ClipboardData {
  const _ClipboardData({
    required this.spans,
    this.blockType,
    this.indent,
  });

  /// The spans that were copied.
  ///
  /// コピーされたスパン。
  final List<MarkdownSpanValue> spans;

  /// The type of block if entire block was selected, null otherwise.
  ///
  /// ブロック全体が選択された場合のブロックタイプ、それ以外はnull。
  final String? blockType;

  /// The indent level of the copied content.
  ///
  /// コピーされたコンテンツのインデントレベル。
  final int? indent;

  /// The plain text of the clipboard data.
  ///
  /// クリップボードデータのプレーンテキスト。
  String get text => spans.map((span) => span.value).join();
}
