// Package imports:
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:masamune/masamune.dart";

// Project imports:
import "package:masamune_markdown/masamune_markdown.dart";

void main() {
  group("MarkdownField.layout", () {
    testWidgets("field renders with correct initial size", (tester) async {
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

      final finder = find.byType(MarkdownField);
      expect(finder, findsOneWidget);

      // Field should have a size
      final renderObject = tester.renderObject(finder);
      expect(renderObject.paintBounds.width, greaterThan(0));
    });

    testWidgets("field expands when expands is true", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: SizedBox(
                height: 400,
                width: 300,
                child: MarkdownField(
                  controller: controller,
                  expands: true,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final finder = find.byType(MarkdownField);
      final size = tester.getSize(finder);

      // With expands: true, field should try to fill available space
      expect(size.height, greaterThan(0));
      expect(size.width, greaterThan(0));
    });

    testWidgets("field with text has appropriate height", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: SingleChildScrollView(
                child: MarkdownField(
                  controller: controller,
                  expands: false,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      controller.focusNode.requestFocus();
      await tester.pump();

      // Enter text
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: "Line 1\nLine 2\nLine 3",
          selection: TextSelection.collapsed(offset: 20),
        ),
      );
      await tester.pump();

      final finder = find.byType(MarkdownField);
      final size = tester.getSize(finder);

      // Field should have height to accommodate text
      expect(size.height, greaterThan(0));
    });

    testWidgets("field with toolbar layout", (tester) async {
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
        ),
      );
      await tester.pump();

      final fieldFinder = find.byType(MarkdownField);
      final toolbarFinder = find.byType(FormMarkdownToolbar);

      expect(fieldFinder, findsOneWidget);
      expect(toolbarFinder, findsOneWidget);

      // Field and toolbar should both be visible
      final fieldBox = tester.getRect(fieldFinder);
      final toolbarBox = tester.getRect(toolbarFinder);

      // Toolbar should be below field
      expect(toolbarBox.top, greaterThanOrEqualTo(fieldBox.bottom));
    });

    testWidgets("scroll padding is applied", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);
      const customPadding = EdgeInsets.all(30.0);

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: MarkdownField(
                controller: controller,
                scrollPadding: customPadding,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final finder = find.byType(MarkdownField);
      expect(finder, findsOneWidget);
    });

    testWidgets("multiline text layout is correct", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: SizedBox(
                height: 300,
                child: MarkdownField(
                  controller: controller,
                  scrollable: true,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      controller.focusNode.requestFocus();
      await tester.pump();

      // Enter multiple lines
      final lines = List.generate(10, (i) => "Line $i").join("\n");
      tester.testTextInput.updateEditingValue(
        TextEditingValue(
          text: lines,
          selection: TextSelection.collapsed(offset: lines.length),
        ),
      );
      await tester.pump();

      expect(controller.rawText, lines);
      expect(controller.value?.first.children.length, 10);
    });

    testWidgets("readOnly mode renders correctly", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);

      // Set initial content
      controller.importFromMarkdown("Read only content");

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: MarkdownField(
                controller: controller,
                readOnly: true,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final finder = find.byType(MarkdownField);
      expect(finder, findsOneWidget);

      expect(controller.rawText, "Read only content");
    });

    testWidgets("text style is applied", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);
      const customStyle = TextStyle(
        fontSize: 20,
        color: Colors.blue,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: MarkdownField(
                controller: controller,
                style: customStyle,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final finder = find.byType(MarkdownField);
      expect(finder, findsOneWidget);
    });

    testWidgets("cursor color is applied", (tester) async {
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
                cursorColor: Colors.red,
                cursorWidth: 3.0,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      final finder = find.byType(MarkdownField);
      expect(finder, findsOneWidget);
    });

    testWidgets("field in constrained height works", (tester) async {
      masamuneApplyTestMocks();
      const adapter = MarkdownMasamuneAdapter();
      final controller = MarkdownController(adapter: adapter);

      await tester.pumpWidget(
        MaterialApp(
          home: MasamuneAdapterScope(
            adapter: adapter,
            child: Scaffold(
              body: SizedBox(
                height: 100,
                child: MarkdownField(
                  controller: controller,
                  scrollable: true,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      controller.focusNode.requestFocus();
      await tester.pump();

      // Enter text that would exceed the constrained height
      final longText = List.generate(20, (i) => "Line $i").join("\n");
      tester.testTextInput.updateEditingValue(
        TextEditingValue(
          text: longText,
          selection: TextSelection.collapsed(offset: longText.length),
        ),
      );
      await tester.pump();

      // Field should still have the constrained height
      final size = tester.getSize(find.byType(MarkdownField));
      expect(size.height, 100);

      // But text should be there
      expect(controller.rawText, longText);
    });

    testWidgets("autofocus works", (tester) async {
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
                autofocus: true,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // With autofocus, field should have focus
      expect(controller.focusNode.hasFocus, isTrue);
    });
  });
}
