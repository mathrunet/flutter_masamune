import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:masamune/masamune.dart";
import "package:masamune_markdown/masamune_markdown.dart";

Future<
    ({
      Finder finder,
      MarkdownFieldState state,
      MarkdownController controller
    })> buildMarkdownField(WidgetTester tester) async {
  const adapter = MarkdownMasamuneAdapter();
  final controller = MarkdownController(adapter: adapter);
  await tester.pumpWidget(
    MaterialApp(
      home: MasamuneAdapterScope(
        adapter: adapter,
        child: MarkdownField(
          controller: controller,
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
  return (
    finder: field,
    controller: controller,
    state: tester.state<MarkdownFieldState>(field)
  );
}
