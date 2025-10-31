// Flutter imports:
import "package:flutter/material.dart";

// Package imports:
import "package:flutter_test/flutter_test.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_markdown/masamune_markdown.dart";

/// Helper for testing TextInput.
///
/// TextInputのテストを行うためのヘルパー。
class TestTextInputHelper {
  /// Helper for testing TextInput.
  ///
  /// TextInputのテストを行うためのヘルパー。
  TestTextInputHelper(this.tester, this.controller);

  final WidgetTester tester;
  final MarkdownController controller;

  TextSelection _collapsedSelection(int offset) => TextSelection(
        baseOffset: offset,
        extentOffset: offset,
      );

  // テキストを追加で入力する
  Future<void> enterText(String text) async {
    final currentText = controller.rawText;
    var cursorBaseOffset = controller.selection.baseOffset;
    var cursorExtentOffset = controller.selection.extentOffset;
    final start = cursorBaseOffset < cursorExtentOffset
        ? cursorBaseOffset
        : cursorExtentOffset;
    final end = cursorBaseOffset > cursorExtentOffset
        ? cursorBaseOffset
        : cursorExtentOffset;
    final newText = currentText.replaceRange(start, end, text);
    final collapsedOffset = start + text.length;
    cursorBaseOffset = collapsedOffset;
    cursorExtentOffset = collapsedOffset;
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
    var currentText = controller.rawText;
    if (currentText.isEmpty) {
      return;
    }
    var cursorBaseOffset = controller.selection.baseOffset;
    var cursorExtentOffset = controller.selection.extentOffset;
    for (var i = 0; i < count; i++) {
      final start = cursorBaseOffset < cursorExtentOffset
          ? cursorBaseOffset
          : cursorExtentOffset;
      final end = cursorBaseOffset > cursorExtentOffset
          ? cursorBaseOffset
          : cursorExtentOffset;
      if (start != end) {
        currentText = currentText.replaceRange(start, end, "");
        cursorBaseOffset = start;
        cursorExtentOffset = start;
      } else if (start > 0) {
        final deleteStart = start - 1;
        currentText = currentText.replaceRange(deleteStart, start, "");
        cursorBaseOffset = deleteStart;
        cursorExtentOffset = deleteStart;
      }
      tester.testTextInput.updateEditingValue(
        TextEditingValue(
          text: currentText,
          selection: _collapsedSelection(cursorExtentOffset),
        ),
      );
      await tester.pump();
    }
  }

  Future<void> cursorAt(int offset) async {
    final currentText = controller.rawText;
    final length = currentText.length;
    if (offset < 0 || offset > length) {
      return;
    }
    final selection = TextSelection(baseOffset: offset, extentOffset: offset);
    final value = TextEditingValue(
      text: currentText,
      selection: selection,
    );
    tester.testTextInput.updateEditingValue(value);
    await tester.pump();
  }

  Future<void> cursorAtLast() async {
    await cursorAt(controller.rawText.length);
  }

  Future<void> cursorAtFirst() async {
    await cursorAt(0);
  }

  Future<void> cursorAtMiddle() async {
    await cursorAt(controller.rawText.length ~/ 2);
  }

  Future<void> selectAt(int start, int end) async {
    final currentText = controller.rawText;
    if (start < 0 || end < 0 || start > end || end > currentText.length) {
      return;
    }
    final selection = TextSelection(
      baseOffset: start,
      extentOffset: end,
    );
    final value = TextEditingValue(
      text: currentText,
      selection: selection,
    );
    tester.testTextInput.updateEditingValue(value);
    await tester.pump();
  }

  Future<void> selectAll() async {
    await selectAt(0, controller.rawText.length);
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
      MarkdownFieldState field,
      FormMarkdownToolbarState toolbar,
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

  final finder = find.byType(MarkdownField);
  final toolbar = find.byType(FormMarkdownToolbar);
  await tester.tap(finder);
  await tester.pump();

  // タップでフォーカスが当たらないケースがあるため明示的にフォーカスを要求。
  controller.focusNode.requestFocus();
  await tester.pump();

  expect(controller.focusNode.hasFocus, isTrue);
  expect(tester.testTextInput.isRegistered, isTrue);
  final input = TestTextInputHelper(tester, controller);
  return (
    finder: finder,
    controller: controller,
    field: tester.state<MarkdownFieldState>(finder),
    toolbar: tester.state<FormMarkdownToolbarState>(toolbar),
    input: input,
  );
}
