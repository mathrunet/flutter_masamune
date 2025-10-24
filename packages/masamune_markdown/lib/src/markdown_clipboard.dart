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
    final text = field.composingText ?? _controller.getPlainText();

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

      // ブロック情報付きで内部クリップボードに保存
      _internalClipboard = _ClipboardData(
        spans: extractedSpans,
        blockType: blockType,
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
      final currentText = _controller.getPlainText();

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
    final text = field.composingText ?? _controller.getPlainText();

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

      // ブロック情報付きで内部クリップボードに保存
      _internalClipboard = _ClipboardData(
        spans: extractedSpans,
        blockType: blockType,
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
      debugPrint("  Clearing composing state before paste");
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

    // 選択がある場合は、ペーストしたテキストで置換
    // カーソルが折りたたまれている場合は、カーソル位置に挿入
    final start = selection.start;
    final end = selection.end;

    // テスト環境では内部クリップボードを使用する
    if (_platform.isTest) {
      if (_internalClipboard != null && _internalClipboard!.spans.isNotEmpty) {
        // クリップボードにブロックタイプ情報がある場合、新しいブロックを作成
        if (_internalClipboard!.blockType != null) {
          _pasteAsBlock(start, end, _internalClipboard!.spans,
              _internalClipboard!.blockType!);
        } else {
          // プロパティ付きのスパンを復元（部分選択）
          _pasteSpansWithProperties(start, end, _internalClipboard!.spans);
        }
      }
      return;
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

    // ペーストしたテキストに改行が含まれているかチェック
    if (text.contains("\n")) {
      // 改行で分割して一つずつ挿入
      final lines = text.split("\n");

      // まず、選択されたテキストがあれば削除
      if (end > start) {
        _controller.replaceText(start, end, "");
      }

      var currentOffset = start;

      // カーソル位置に最初の行を挿入
      if (lines.isNotEmpty && lines.first.isNotEmpty) {
        _controller.replaceText(currentOffset, currentOffset, lines.first);
        currentOffset += lines.first.length;
      }

      // 追加の各行に対して、新しい段落を挿入
      for (var i = 1; i < lines.length; i++) {
        _controller.insertNewLine(currentOffset);
        currentOffset++; // 改行文字を考慮

        if (lines[i].isNotEmpty) {
          _controller.replaceText(currentOffset, currentOffset, lines[i]);
          currentOffset += lines[i].length;
        }
      }

      // ペーストしたテキストの末尾にカーソル位置を更新
      field._selection = TextSelection.collapsed(offset: currentOffset);
    } else {
      // 改行なしの通常テキストペースト
      // プロパティ付きの内部クリップボードデータがあるかチェック
      if (_internalClipboard != null && _internalClipboard!.spans.isNotEmpty) {
        // クリップボードにブロックタイプ情報がある場合、新しいブロックを作成
        if (_internalClipboard!.blockType != null) {
          _pasteAsBlock(start, end, _internalClipboard!.spans,
              _internalClipboard!.blockType!);
        } else {
          // プロパティ付きのスパンを復元（部分選択）
          _pasteSpansWithProperties(start, end, _internalClipboard!.spans);
        }
      } else {
        // プレーンテキストペースト（外部クリップボードまたはプロパティなし）
        _controller.replaceText(start, end, text);
      }

      // ペーストしたテキストの末尾にカーソル位置を更新
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

    // 新しいスパンで行を更新
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
    final newBlock = blockTool != null
        ? blockTool.createBlockValue(children: [newLine])
        : MarkdownBlockValue.createEmpty(children: [newLine]);

    // 新しいブロックを挿入
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
