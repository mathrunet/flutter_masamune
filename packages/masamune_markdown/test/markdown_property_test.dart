import "package:masamune_markdown/masamune_markdown.dart";
import "package:flutter_test/flutter_test.dart";

import "functions.dart";

void main() {
  testWidgets("MarkdownField.input", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;

    tester.testTextInput.enterText("aaa");
    await tester.pump();
    expect(controller.getPlainText(), "aaa");

    final value = controller.value;
    expect(value, isNotNull);
    expect(
      value!.toDebug(),
      [MarkdownFieldValue.createEmpty(initialText: "aaa").toDebug()],
    );
  });
  testWidgets("MarkdownField.newline", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;

    tester.testTextInput.enterText("aaa\nbbb");
    await tester.pump();

    final value = controller.value;
    expect(value, isNotNull);
    expect(
      value!.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
  });
}
