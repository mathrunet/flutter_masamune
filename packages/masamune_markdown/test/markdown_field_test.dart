import "package:katana/katana.dart";
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
    expect(controller.selection.baseOffset, 6);
    expect(controller.rawText, "aaabbb");
    expect(controller.plainText, "aaabbb");
    await input.deleteText(count: 3);
    expect(controller.rawText, "aaa");
    expect(controller.plainText, "aaa");
    expect(controller.selection.baseOffset, 3);

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
    expect(controller.selection.baseOffset, 7);
    expect(controller.rawText, "aaa\nbbb");
    expect(controller.plainText, "aaa\nbbb");
    await input.deleteText(count: 2);
    expect(controller.rawText, "aaa\nb");
    expect(controller.plainText, "aaa\nb");
    expect(controller.selection.baseOffset, 5);

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
    expect(controller.selection.baseOffset, 3);
    expect(controller.rawText, "aaa");
    expect(controller.plainText, "aaa");
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
    expect(controller.selection.baseOffset, 5);
    expect(controller.rawText, "aaa\n\n");
    expect(controller.plainText, "aaa\n\n");
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
    expect(controller.selection.baseOffset, 8);
    expect(controller.rawText, "aaa\n\nccc");
    expect(controller.plainText, "aaa\n\nccc");
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
    expect(controller.selection.baseOffset, 7);
    expect(controller.rawText, "aaa\nbbb");
    expect(controller.plainText, "aaa\nbbb");

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
    expect(controller.selection.baseOffset, 1);
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 4);
    expect(controller.plainText, "acccaa\nbbb");
    expect(controller.rawText, "acccaa\nbbb");
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
    expect(controller.selection.baseOffset, 9);
    await input.enterText("ddd");
    expect(controller.selection.baseOffset, 12);
    expect(controller.plainText, "acccaa\nbbdddb");
    expect(controller.rawText, "acccaa\nbbdddb");
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
    expect(controller.selection.baseOffset, 3);
    await input.enterText("\n");
    await input.enterText("eee");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "acc\neeecaa\nbbdddb");
    expect(controller.rawText, "acc\neeecaa\nbbdddb");
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
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");

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
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 2);
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 3);
    expect(controller.plainText, "ccca\nbbb");
    expect(controller.rawText, "ccca\nbbb");
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
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    await input.deleteText(count: 2);
    expect(controller.selection.baseOffset, 0);
    expect(controller.plainText, "a\nbbb");
    expect(controller.rawText, "a\nbbb");
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
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 3);
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 3);
    expect(controller.plainText, "cccbb");
    expect(controller.rawText, "cccbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "cccbb"),
        ]).toDebug()
      ],
    );
    await input.selectAt(1, 2);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 2);
    await input.enterText("\n");
    expect(controller.selection.baseOffset, 2);
    expect(controller.plainText, "c\ncbb");
    expect(controller.rawText, "c\ncbb");
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
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 5);
    await input.deleteText();
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 0);
    expect(controller.plainText, "");
    expect(controller.rawText, "");
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
    expect(controller.selection.baseOffset, 6);
    await input.selectAt(0, 2);
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 2);
    await controller.clipboard.cut();
    expect(controller.selection.extentOffset, 0);
    expect(await controller.clipboard.currentText, "aa");
    expect(controller.selection.baseOffset, 0);
    expect(controller.rawText, "abbb");
    expect(controller.plainText, "abbb");

    expect(
      controller.value?.toDebug(),
      [MarkdownFieldValue.createEmpty(initialText: "abbb").toDebug()],
    );
    await input.cursorAtLast();
    expect(controller.selection.baseOffset, 4);
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 6);
    expect(controller.rawText, "abbbaa");
    expect(controller.plainText, "abbbaa");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "abbbaa"),
        ]).toDebug()
      ],
    );
    await input.enterText("cc");
    expect(controller.selection.baseOffset, 8);
    expect(controller.rawText, "abbbaacc");
    expect(controller.plainText, "abbbaacc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "abbbaacc"),
        ]).toDebug()
      ],
    );
    await input.enterText("\n");
    expect(controller.selection.baseOffset, 9);
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 11);
    expect(controller.rawText, "abbbaacc\naa");
    expect(controller.plainText, "abbbaacc\naa");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "abbbaacc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
        ]).toDebug()
      ],
    );
    await input.enterText("\n");
    expect(controller.selection.baseOffset, 12);
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 14);
    expect(controller.rawText, "abbbaacc\naa\naa");
    expect(controller.plainText, "abbbaacc\naa\naa");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "abbbaacc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
        ]).toDebug()
      ],
    );
    await input.selectAt(10, 13);
    expect(controller.selection.baseOffset, 10);
    expect(controller.selection.extentOffset, 13);
    await controller.clipboard.cut();
    expect(controller.selection.baseOffset, 10);
    expect(await controller.clipboard.currentText, "a\na");
    expect(controller.rawText, "abbbaacc\naa");
    expect(controller.plainText, "abbbaacc\naa");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "abbbaacc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
        ]).toDebug()
      ],
    );
    await input.cursorAtLast();
    expect(controller.selection.baseOffset, 11);
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 14);
    expect(controller.rawText, "abbbaacc\naaa\na");
    expect(controller.plainText, "abbbaacc\naaa\na");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "abbbaacc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "a"),
        ]).toDebug()
      ],
    );
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 17);
    expect(controller.rawText, "abbbaacc\naaa\naa\na");
    expect(controller.plainText, "abbbaacc\naaa\naa\na");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "abbbaacc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "a"),
        ]).toDebug()
      ],
    );
    await input.cursorAt(3);
    expect(controller.selection.baseOffset, 3);
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 6);
    expect(controller.rawText, "abba\nabaacc\naaa\naa\na");
    expect(controller.plainText, "abba\nabaacc\naaa\naa\na");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "abba"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "abaacc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "a"),
        ]).toDebug()
      ],
    );
    await input.selectAt(2, 3);
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 3);
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 5);
    expect(controller.rawText, "aba\naa\nabaacc\naaa\naa\na");
    expect(controller.plainText, "aba\naa\nabaacc\naaa\naa\na");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aba"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "abaacc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "a"),
        ]).toDebug()
      ],
    );
    await input.selectAt(2, 11);
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 11);
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 5);
    expect(controller.rawText, "aba\nacc\naaa\naa\na");
    expect(controller.plainText, "aba\nacc\naaa\naa\na");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aba"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "acc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "a"),
        ]).toDebug()
      ],
    );
    await input.selectAt(0, 3);
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 3);
    await controller.clipboard.cut();
    expect(await controller.clipboard.currentText, "aba");
    expect(controller.selection.baseOffset, 0);
    expect(controller.rawText, "acc\naaa\naa\na");
    expect(controller.plainText, "acc\naaa\naa\na");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "acc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "a"),
        ]).toDebug()
      ],
    );
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 4);
    expect(controller.rawText, "acc\naba\naaa\naa\na");
    expect(controller.plainText, "acc\naba\naaa\naa\na");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "acc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aba"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "a"),
        ]).toDebug()
      ],
    );
    await input.selectAt(1, 3);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    await controller.clipboard.copy();
    expect(await controller.clipboard.currentText, "cc");
    expect(controller.selection.baseOffset, 3);
    expect(controller.selection.extentOffset, 3);
    await input.cursorAtLast();
    expect(controller.selection.baseOffset, 16);
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 18);
    expect(controller.rawText, "acc\naba\naaa\naa\nacc");
    expect(controller.plainText, "acc\naba\naaa\naa\nacc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "acc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aba"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "acc"),
        ]).toDebug()
      ],
    );
    await input.selectAt(2, 5);
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 5);
    await controller.clipboard.copy();
    expect(await controller.clipboard.currentText, "c\na");
    expect(controller.selection.baseOffset, 5);
    expect(controller.selection.extentOffset, 5);
    await input.cursorAt(10);
    expect(controller.selection.baseOffset, 10);
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 13);
    expect(controller.rawText, "acc\naba\naac\naa\naa\nacc");
    expect(controller.plainText, "acc\naba\naac\naa\naa\nacc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "acc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aba"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aac"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "acc"),
        ]).toDebug()
      ],
    );
  });
  testWidgets("MarkdownField.field.indent", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    await input.enterText("\n");
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.cursorAt(0);
    expect(controller.selection.baseOffset, 0);
    controller.increaseIndent();
    expect(controller.selection.baseOffset, 0);
    expect(controller.plainText, "  aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "aaa")],
            indent: 1,
          ),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.cursorAt(1);
    expect(controller.selection.baseOffset, 1);
    controller.increaseIndent();
    expect(controller.selection.baseOffset, 1);
    expect(controller.plainText, "    aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "aaa")],
            indent: 2,
          ),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.selectAt(0, 2);
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 2);
    controller.decreaseIndent();
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 2);
    expect(controller.plainText, "  aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "aaa")],
            indent: 1,
          ),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.selectAt(5, 6);
    expect(controller.selection.baseOffset, 5);
    expect(controller.selection.extentOffset, 6);
    controller.increaseIndent();
    expect(controller.selection.baseOffset, 5);
    expect(controller.selection.extentOffset, 6);
    expect(controller.plainText, "  aaa\n  bbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "aaa")],
            indent: 1,
          ),
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
        ]).toDebug()
      ],
    );
    await input.selectAt(2, 6);
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 6);
    controller.increaseIndent();
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 6);
    expect(controller.plainText, "    aaa\n    bbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "aaa")],
            indent: 2,
          ),
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 2,
          ),
        ]).toDebug()
      ],
    );
    await input.selectAt(3, 5);
    expect(controller.selection.baseOffset, 3);
    expect(controller.selection.extentOffset, 5);
    controller.decreaseIndent();
    expect(controller.selection.baseOffset, 3);
    expect(controller.selection.extentOffset, 5);
    expect(controller.plainText, "  aaa\n  bbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "aaa")],
            indent: 1,
          ),
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
        ]).toDebug()
      ],
    );
  });
  testWidgets("MarkdownField.field.undoRedo", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    await input.enterText("\n");
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    controller.history.undo();
    expect(controller.selection.baseOffset, 4);
    expect(controller.plainText, "aaa\n");
    expect(controller.rawText, "aaa\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: ""),
        ]).toDebug()
      ],
    );
    controller.history.redo();
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.cursorAt(5);
    expect(controller.selection.baseOffset, 5);
    controller.increaseIndent();
    expect(controller.selection.baseOffset, 5);
    expect(controller.plainText, "aaa\n  bbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
        ]).toDebug()
      ],
    );
    controller.history.undo();
    expect(controller.selection.baseOffset, 5);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    controller.history.redo();
    expect(controller.selection.baseOffset, 5);
    expect(controller.plainText, "aaa\n  bbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
        ]).toDebug()
      ],
    );
    await input.selectAt(2, 5);
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 5);
    await controller.clipboard.cut();
    expect(await controller.clipboard.currentText, "a\nb");
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 2);
    expect(controller.plainText, "aabb");
    expect(controller.rawText, "aabb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aabb"),
        ]).toDebug()
      ],
    );
    controller.history.undo();
    expect(controller.selection.baseOffset, 2);
    expect(controller.plainText, "aaa\n  bbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
        ]).toDebug()
      ],
    );
    controller.history.redo();
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 2);
    expect(controller.plainText, "aabb");
    expect(controller.rawText, "aabb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aabb"),
        ]).toDebug()
      ],
    );
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 5);
    expect(controller.selection.extentOffset, 5);
    expect(controller.plainText, "aaa\n  bbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
        ]).toDebug()
      ],
    );
  });
}
