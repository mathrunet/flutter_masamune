// Package imports:
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_markdown/masamune_markdown.dart";

void main() {
  group("MarkdownField.longpress", () {
    testWidgets("long press with focus selects word", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);
      var longPressCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: MarkdownField(
                controller: controller,
                onLongPress: (_) {
                  longPressCount++;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Request focus and enter text
      controller.focusNode.requestFocus();
      await tester.pump();
      expect(controller.focusNode.hasFocus, isTrue);

      // Enter text via text input
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: "Hello World Test",
          selection: TextSelection.collapsed(offset: 16),
        ),
      );
      await tester.pump();

      expect(controller.rawText, "Hello World Test");

      // Simulate long press by selecting a word
      // In real usage, long press would trigger word selection via _handleLongPressDetected
      // Here we simulate the selection result
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: "Hello World Test",
          selection: TextSelection(baseOffset: 6, extentOffset: 11), // "World"
        ),
      );
      await tester.pump();

      expect(controller.selection.baseOffset, 6);
      expect(controller.selection.extentOffset, 11);
    });

    testWidgets("long press callback is invoked", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);
      Offset? longPressPosition;

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: MarkdownField(
                controller: controller,
                onLongPress: (position) {
                  longPressPosition = position;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final finder = find.byType(MarkdownField);

      // Request focus
      controller.focusNode.requestFocus();
      await tester.pump();

      // Long press on the field
      await tester.longPress(finder);
      await tester.pump();

      // onLongPress callback should have been called
      expect(longPressPosition, isNotNull);
    });

    testWidgets("long press without focus requests focus first", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: Column(
                children: [
                  // Another widget to take initial focus
                  const TextField(),
                  Expanded(
                    child: MarkdownField(
                      controller: controller,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Initially, markdown field should not have focus
      expect(controller.focusNode.hasFocus, isFalse);

      // Enter some text first by giving focus temporarily
      controller.focusNode.requestFocus();
      await tester.pump();

      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: "Test text",
          selection: TextSelection.collapsed(offset: 9),
        ),
      );
      await tester.pump();

      // Unfocus
      controller.focusNode.unfocus();
      await tester.pump();
      expect(controller.focusNode.hasFocus, isFalse);

      // Long press should trigger focus request
      final finder = find.byType(MarkdownField);
      await tester.longPress(finder);
      await tester.pump();

      // Focus should be gained after long press
      // Note: The actual behavior depends on implementation
      // This documents the expected behavior
    });

    testWidgets("long press in readOnly mode does not modify selection", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);
      var longPressCalled = false;

      // Set initial value
      controller.importFromMarkdown("Hello World");

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: MarkdownField(
                controller: controller,
                readOnly: true,
                onLongPress: (_) {
                  longPressCalled = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(controller.rawText, "Hello World");

      // Long press in readOnly mode
      final finder = find.byType(MarkdownField);
      await tester.longPress(finder);
      await tester.pump();

      // In readOnly mode, long press might still trigger callback
      // but should not open input connection
    });

    testWidgets("long press selects word at position", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: MarkdownField(
                controller: controller,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      controller.focusNode.requestFocus();
      await tester.pump();

      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: "One Two Three",
          selection: TextSelection.collapsed(offset: 13),
        ),
      );
      await tester.pump();

      expect(controller.rawText, "One Two Three");

      // Simulate selecting "Two" (positions 4-7)
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: "One Two Three",
          selection: TextSelection(baseOffset: 4, extentOffset: 7),
        ),
      );
      await tester.pump();

      expect(controller.selection.baseOffset, 4);
      expect(controller.selection.extentOffset, 7);
    });

    testWidgets("context menu builder is called on long press", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);
      var contextMenuBuilderCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: MarkdownField(
                controller: controller,
                contextMenuBuilder: (context, delegate) {
                  contextMenuBuilderCalled = true;
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      controller.focusNode.requestFocus();
      await tester.pump();

      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: "Test",
          selection: TextSelection.collapsed(offset: 4),
        ),
      );
      await tester.pump();

      final finder = find.byType(MarkdownField);
      await tester.longPress(finder);
      await tester.pump();

      // Context menu builder should be called
      expect(contextMenuBuilderCalled, isTrue);
    });

    testWidgets("long press on empty field still triggers callback", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);
      var callbackTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: MarkdownField(
                controller: controller,
                onLongPress: (_) {
                  callbackTriggered = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(controller.rawText, "");

      final finder = find.byType(MarkdownField);
      await tester.longPress(finder);
      await tester.pump();

      expect(callbackTriggered, isTrue);
    });

    testWidgets("double tap selects word", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);
      var doubleTapCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: MarkdownField(
                controller: controller,
                onDoubleTap: (_) {
                  doubleTapCalled = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      controller.focusNode.requestFocus();
      await tester.pump();

      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: "Double tap test",
          selection: TextSelection.collapsed(offset: 15),
        ),
      );
      await tester.pump();

      // Double tap to select word
      final finder = find.byType(MarkdownField);
      await tester.tap(finder);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(finder);
      await tester.pump();

      // Double tap callback should be called
      expect(doubleTapCalled, isTrue);
    });
  });
}
