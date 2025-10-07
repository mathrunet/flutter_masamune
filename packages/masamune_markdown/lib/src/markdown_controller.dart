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

  /// This is used to control the focus of the markdown controller.
  ///
  /// これは、markdownコントローラーのフォーカスを制御するために使用されます。
  final FocusNode focusNode = FocusNode();

  /// Replaces text in the specified range.
  ///
  /// 指定された範囲のテキストを置換します。
  void replaceText(int start, int end, String text) {
    // Ensure we have a valid structure
    if (_value.isEmpty ||
        _value.first.children.isEmpty ||
        _value.first.children.first is! MarkdownParagraphBlockValue) {
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

    // Update the first span
    final field = _value.first;
    final block = field.children.first as MarkdownParagraphBlockValue;

    if (block.children.isEmpty) {
      // Create first line if needed
      final newLine = MarkdownLineValue(
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
      );

      final newBlock = MarkdownParagraphBlockValue(
        id: block.id,
        property: block.property,
        children: [newLine],
      );

      final newField = MarkdownFieldValue(
        id: field.id,
        property: field.property,
        children: [newBlock],
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    final line = block.children.first;
    if (line.children.isEmpty) {
      // Create first span if needed
      final newSpan = MarkdownSpanValue(
        id: uuid(),
        value: text,
        property: const MarkdownSpanProperty(
          backgroundColor: null,
          foregroundColor: null,
        ),
      );

      final newLine = MarkdownLineValue(
        id: line.id,
        property: line.property,
        children: [newSpan],
      );

      final newBlock = MarkdownParagraphBlockValue(
        id: block.id,
        property: block.property,
        children: [newLine],
      );

      final newField = MarkdownFieldValue(
        id: field.id,
        property: field.property,
        children: [newBlock],
      );

      _value[0] = newField;
      notifyListeners();
      return;
    }

    // Update existing span
    final span = line.children.first;
    final oldText = span.value;

    // Ensure indices are within bounds
    final safeStart = start.clamp(0, oldText.length);
    final safeEnd = end.clamp(0, oldText.length);

    final newText =
        oldText.substring(0, safeStart) + text + oldText.substring(safeEnd);

    final newSpan = MarkdownSpanValue(
      id: span.id,
      value: newText,
      property: span.property,
      editable: span.editable,
    );

    final newLine = MarkdownLineValue(
      id: line.id,
      property: line.property,
      children: [newSpan],
    );

    final newBlock = MarkdownParagraphBlockValue(
      id: block.id,
      property: block.property,
      children: [newLine],
    );

    final newField = MarkdownFieldValue(
      id: field.id,
      property: field.property,
      children: [newBlock],
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
