import "package:masamune/masamune.dart";
import "package:masamune_markdown/masamune_markdown.dart";
import "package:flutter_test/flutter_test.dart";

import "functions.dart";

void main() {
  testWidgets("MarkdownField.field.inputAndDelete", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    await input.enterText("bbb");
    await input.deleteText(count: 3);
    expect(controller.getPlainText(), "aaa");

    expect(
      controller.value?.toDebug(),
      [MarkdownFieldValue.createEmpty(initialText: "aaa").toDebug()],
    );
  });
  testWidgets("MarkdownField.field.newline", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    await input.enterText("\n");
    await input.enterText("bbb");
    await input.deleteText(count: 2);
    tester.testTextInput.enterText("aaa\nb");
    await tester.pump();

    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "b"),
        ]).toDebug()
      ],
    );
    await input.deleteText(count: 2);
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
        ]).toDebug()
      ],
    );
    await input.enterText("\n");
    await input.enterText("\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(),
          MarkdownParagraphBlockValue.createEmpty(),
        ]).toDebug()
      ],
    );
    await input.enterText("ccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(),
          MarkdownParagraphBlockValue.createEmpty(initialText: "ccc"),
        ]).toDebug()
      ],
    );
  });
  testWidgets("MarkdownField.field.cursor", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    await input.enterText("\n");
    await input.enterText("bbb");
    tester.testTextInput.enterText("aaa\nbbb");
    await tester.pump();

    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.cursorAt(1);
    await input.enterText("ccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "acccaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.cursorAt(9);
    await input.enterText("ddd");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "acccaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbdddb"),
        ]).toDebug()
      ],
    );
    await input.cursorAt(3);
    await input.enterText("\n");
    await input.enterText("eee");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "acc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "eeecaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbdddb"),
        ]).toDebug()
      ],
    );
  });
  testWidgets("MarkdownField.field.selection", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    await input.enterText("\n");
    await input.enterText("bbb");
    tester.testTextInput.enterText("aaa\nbbb");
    await tester.pump();

    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.selectAt(0, 2);
    await input.enterText("ccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "ccca"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.selectAt(1, 3);
    await input.deleteText(count: 2);
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "a"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.selectAt(0, 3);
    await input.enterText("ccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "cccbb"),
        ]).toDebug()
      ],
    );
    await input.selectAt(1, 2);
    await input.enterText("\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "c"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "cbb"),
        ]).toDebug()
      ],
    );
    await input.selectAll();
    await input.deleteText();
    expect(
      controller.value?.toDebug(),
      [MarkdownFieldValue.createEmpty().toDebug()],
    );
  });
  testWidgets("MarkdownField.field.cut", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    await input.enterText("bbb");
    await input.selectAt(0, 2);
    await controller.clipboard.cut();

    expect(
      controller.value?.toDebug(),
      [MarkdownFieldValue.createEmpty(initialText: "abbb").toDebug()],
    );
    await input.cursorAtLast();
    await controller.clipboard.paste();
    expect(
      controller.value?.toDebug(),
      [MarkdownFieldValue.createEmpty(initialText: "abbbaa").toDebug()],
    );
  });
}
