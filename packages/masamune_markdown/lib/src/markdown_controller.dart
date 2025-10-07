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

  /// Default style for markdown.
  ///
  /// マークダウンのデフォルトのスタイル。
  MarkdownStyle get style => adapter.defaultStyle;

  /// This is used to control the focus of the markdown controller.
  ///
  /// これは、markdownコントローラーのフォーカスを制御するために使用されます。
  final FocusNode focusNode = FocusNode();

  /// Replaces text in the specified range.
  ///
  /// 指定された範囲のテキストを置換します。
  void replaceText(int start, int end, String text) {
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

    // Find which block contains the start position
    var currentOffset = 0;
    var targetBlockIndex = -1;
    var localStart = start;
    var localEnd = end;

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

        if (currentOffset + blockLength >= start) {
          // Found the target block
          targetBlockIndex = i;
          localStart = start - currentOffset;
          localEnd = end - currentOffset;
          break;
        }

        currentOffset += blockLength + 1; // +1 for newline between blocks
      }
    }

    if (targetBlockIndex == -1) {
      // Start position is beyond all blocks, append to last block
      targetBlockIndex = blocks.length - 1;
      localStart = start - currentOffset;
      localEnd = end - currentOffset;
    }

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

  /// Inserts a new paragraph block at the specified offset.
  ///
  /// 指定されたオフセット位置に新しい段落ブロックを挿入します。
  void insertNewLine(int offset) {
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
