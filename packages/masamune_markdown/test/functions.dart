import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:masamune/masamune.dart";
import "package:masamune_markdown/masamune_markdown.dart";

class TestTextInputHelper {
  TestTextInputHelper(this.tester);

  final WidgetTester tester;

  String _text = "";
  int _cursorBaseOffset = 0;
  int _cursorExtentOffset = 0;

  void _syncWithEditingState() {
    final state = tester.testTextInput.editingState;
    if (state == null) {
      return;
    }
    final text = state["text"] as String?;
    if (text != null) {
      _text = text;
    }
    final selectionBase = state["selectionBase"] as int?;
    final selectionExtent = state["selectionExtent"] as int?;
    if (selectionBase != null) {
      _cursorBaseOffset = selectionBase;
    }
    if (selectionExtent != null) {
      _cursorExtentOffset = selectionExtent;
    }
  }

  TextSelection _collapsedSelection(int offset) => TextSelection(
        baseOffset: offset,
        extentOffset: offset,
      );

  // テキストを追加で入力する
  Future<void> enterText(String text) async {
    _syncWithEditingState();
    final currentText = _text;
    final start = _cursorBaseOffset < _cursorExtentOffset
        ? _cursorBaseOffset
        : _cursorExtentOffset;
    final end = _cursorBaseOffset > _cursorExtentOffset
        ? _cursorBaseOffset
        : _cursorExtentOffset;
    final newText = currentText.replaceRange(start, end, text);
    final collapsedOffset = start + text.length;
    _text = newText;
    _cursorBaseOffset = collapsedOffset;
    _cursorExtentOffset = collapsedOffset;
    tester.testTextInput.updateEditingValue(
      TextEditingValue(
        text: newText,
        selection: _collapsedSelection(collapsedOffset),
      ),
    );
    await tester.pump();
  }

  // 一文字削除する
  Future<void> deleteText({int count = 1}) async {
    _syncWithEditingState();
    if (_text.isEmpty) {
      return;
    }
    for (var i = 0; i < count; i++) {
      final start = _cursorBaseOffset < _cursorExtentOffset
          ? _cursorBaseOffset
          : _cursorExtentOffset;
      final end = _cursorBaseOffset > _cursorExtentOffset
          ? _cursorBaseOffset
          : _cursorExtentOffset;
      if (start != end) {
        _text = _text.replaceRange(start, end, "");
        _cursorBaseOffset = start;
        _cursorExtentOffset = start;
      } else if (start > 0) {
        final deleteStart = start - 1;
        _text = _text.replaceRange(deleteStart, start, "");
        _cursorBaseOffset = deleteStart;
        _cursorExtentOffset = deleteStart;
      }
      tester.testTextInput.updateEditingValue(
        TextEditingValue(
          text: _text,
          selection: _collapsedSelection(_cursorExtentOffset),
        ),
      );
      await tester.pump();
    }
  }

  Future<void> cursorAt(int offset) async {
    _syncWithEditingState();
    final length = _text.length;
    if (offset < 0 || offset > length) {
      return;
    }
    _cursorBaseOffset = offset;
    _cursorExtentOffset = offset;
    final selection = TextSelection(baseOffset: offset, extentOffset: offset);
    final value = TextEditingValue(
      text: _text,
      selection: selection,
    );
    tester.testTextInput.updateEditingValue(value);
    await tester.pump();
  }

  Future<void> cursorAtLast() async {
    await cursorAt(_text.length);
  }

  Future<void> cursorAtFirst() async {
    await cursorAt(0);
  }

  Future<void> cursorAtMiddle() async {
    await cursorAt(_text.length ~/ 2);
  }

  Future<void> selectAt(int start, int end) async {
    _syncWithEditingState();
    if (start < 0 || end < 0 || start > end || end > _text.length) {
      return;
    }
    _cursorBaseOffset = start;
    _cursorExtentOffset = end;
    final selection = TextSelection(
      baseOffset: _cursorBaseOffset,
      extentOffset: _cursorExtentOffset,
    );
    final value = TextEditingValue(
      text: _text,
      selection: selection,
    );
    tester.testTextInput.updateEditingValue(value);
    await tester.pump();
  }

  Future<void> selectAll() async {
    await selectAt(0, _text.length);
  }

  Future<void> selectNone() async {
    await selectAt(0, 0);
  }
}

/// Will create a widget for testing Markdown.
///
/// Markdownのテストを行うためのウィジェットを作成します。
Future<
    ({
      Finder finder,
      MarkdownFieldState state,
      MarkdownController controller,
      TestTextInputHelper input
    })> buildMarkdownField(WidgetTester tester) async {
  masamuneApplyTestMocks();
  const adapter = MarkdownMasamuneAdapter();
  final controller = MarkdownController(adapter: adapter);
  await tester.pumpWidget(
    MaterialApp(
      home: MasamuneAdapterScope(
        adapter: adapter,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: MarkdownField(
                controller: controller,
              ),
            ),
            FormMarkdownToolbar(
              controller: controller,
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();

  final field = find.byType(MarkdownField);
  await tester.tap(field);
  await tester.pump();

  // タップでフォーカスが当たらないケースがあるため明示的にフォーカスを要求。
  controller.focusNode.requestFocus();
  await tester.pump();

  expect(controller.focusNode.hasFocus, isTrue);
  expect(tester.testTextInput.isRegistered, isTrue);
  final input = TestTextInputHelper(tester);
  return (
    finder: field,
    controller: controller,
    state: tester.state<MarkdownFieldState>(field),
    input: input,
  );
}
