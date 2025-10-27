import "package:katana/katana.dart";
import "package:masamune_markdown/masamune_markdown.dart";
import "package:flutter_test/flutter_test.dart";

import "functions.dart";

void main() {
  testWidgets("MarkdownField.blockProperty.numberList.insert",
      (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    expect(controller.selection.baseOffset, 3);
    expect(controller.plainText, "aaa");
    expect(controller.rawText, "aaa");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
        ]).toDebug()
      ],
    );
    controller.insertBlock(const NumberListAddMarkdownBlockTools());
    expect(controller.selection.baseOffset, 4);
    expect(controller.plainText, "aaa\n");
    expect(controller.rawText, "aaa\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "", lineIndex: 0),
        ]).toDebug()
      ],
    );
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    controller.insertBlock(const NumberListAddMarkdownBlockTools());
    expect(controller.selection.baseOffset, 8);
    expect(controller.plainText, "aaa\nbbb\n");
    expect(controller.rawText, "aaa\nbbb\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(initialText: "", lineIndex: 1),
        ]).toDebug()
      ],
    );
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 11);
    expect(controller.plainText, "aaa\nbbb\nccc");
    expect(controller.rawText, "aaa\nbbb\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(initialText: "ccc", lineIndex: 1),
        ]).toDebug()
      ],
    );
  });

  testWidgets("MarkdownField.blockProperty.numberList.exchange",
      (tester) async {
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
    await input.cursorAt(5);
    expect(controller.selection.baseOffset, 5);
    controller.exchangeBlock(const NumberListExchangeMarkdownBlockTools());
    expect(controller.selection.baseOffset, 5);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    await input.cursorAt(1);
    expect(controller.selection.baseOffset, 1);
    controller.exchangeBlock(const NumberListExchangeMarkdownBlockTools());
    expect(controller.selection.baseOffset, 1);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownNumberListBlockValue.createEmpty(initialText: "aaa", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    controller.exchangeBlock(const TextExchangeMarkdownBlockTools());
    expect(controller.selection.baseOffset, 1);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    await input.cursorAt(5);
    expect(controller.selection.baseOffset, 5);
    controller.exchangeBlock(const TextExchangeMarkdownBlockTools());
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
  });

  testWidgets("MarkdownField.blockProperty.numberList.newLine",
      (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    controller.insertBlock(const NumberListAddMarkdownBlockTools());
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    await input.enterText("\n");
    expect(controller.selection.baseOffset, 8);
    expect(controller.plainText, "aaa\nbbb\n");
    expect(controller.rawText, "aaa\nbbb\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(initialText: "", lineIndex: 1),
        ]).toDebug()
      ],
    );
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 11);
    expect(controller.plainText, "aaa\nbbb\nccc");
    expect(controller.rawText, "aaa\nbbb\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(initialText: "ccc", lineIndex: 1),
        ]).toDebug()
      ],
    );
    await input.enterText("\n");
    await input.enterText("\n");
    expect(controller.selection.baseOffset, 13);
    expect(controller.plainText, "aaa\nbbb\nccc\n\n");
    expect(controller.rawText, "aaa\nbbb\nccc\n\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(initialText: "ccc", lineIndex: 1),
          MarkdownNumberListBlockValue.createEmpty(initialText: "", lineIndex: 2),
          MarkdownNumberListBlockValue.createEmpty(initialText: "", lineIndex: 3),
        ]).toDebug()
      ],
    );
  });

  testWidgets("MarkdownField.blockProperty.numberList.cutCopyAndPaste",
      (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    controller.insertBlock(const NumberListAddMarkdownBlockTools());
    await input.enterText("bbb");
    controller.insertBlock(const NumberListAddMarkdownBlockTools());
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 11);
    expect(controller.plainText, "aaa\nbbb\nccc");
    expect(controller.rawText, "aaa\nbbb\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(initialText: "ccc", lineIndex: 1),
        ]).toDebug()
      ],
    );
    await input.selectAt(2, 9);
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 9);
    await controller.clipboard.cut();
    expect(await controller.clipboard.currentText, "a\nbbb\nc");
    expect(controller.selection.baseOffset, 2);
    expect(controller.plainText, "aa\ncc");
    expect(controller.rawText, "aa\ncc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "cc", lineIndex: 1),
        ]).toDebug()
      ],
    );
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 9);
    expect(controller.plainText, "aaa\nbbb\nc\ncc");
    expect(controller.rawText, "aaa\nbbb\nc\ncc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "c"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "cc", lineIndex: 1),
        ]).toDebug()
      ],
    );
    await input.selectAt(4, 7);
    expect(controller.selection.baseOffset, 4);
    expect(controller.selection.extentOffset, 7);
    await controller.clipboard.copy();
    expect(await controller.clipboard.currentText, "bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.selection.extentOffset, 7);
    expect(controller.plainText, "aaa\nbbb\nc\ncc");
    expect(controller.rawText, "aaa\nbbb\nc\ncc");
    await input.cursorAt(12);
    expect(controller.selection.baseOffset, 12);
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 16);
    expect(controller.plainText, "aaa\nbbb\nc\ncc\nbbb");
    expect(controller.rawText, "aaa\nbbb\nc\ncc\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "c"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "cc", lineIndex: 1),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
  });

  testWidgets("MarkdownField.blockProperty.numberList.indent",
      (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    controller.insertBlock(const NumberListAddMarkdownBlockTools());
    await input.enterText("bbb");
    controller.insertBlock(const NumberListAddMarkdownBlockTools());
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 11);
    expect(controller.plainText, "aaa\nbbb\nccc");
    expect(controller.rawText, "aaa\nbbb\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(initialText: "ccc", lineIndex: 1),
        ]).toDebug()
      ],
    );
    await input.cursorAt(5);
    expect(controller.selection.baseOffset, 5);
    controller.increaseIndent();
    expect(controller.selection.baseOffset, 5);
    expect(controller.plainText, "aaa\n  bbb\nccc");
    expect(controller.rawText, "aaa\nbbb\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
            lineIndex: 0,
          ),
          MarkdownNumberListBlockValue.createEmpty(initialText: "ccc", lineIndex: 1),
        ]).toDebug()
      ],
    );
    controller.insertBlock(const NumberListAddMarkdownBlockTools());
    expect(controller.selection.baseOffset, 8);
    expect(controller.rawText, "aaa\nbbb\n\nccc");
    expect(controller.plainText, "aaa\n  bbb\n  \nccc");
    await input.enterText("ddd");
    expect(controller.selection.baseOffset, 11);
    expect(controller.plainText, "aaa\n  bbb\n  ddd\nccc");
    expect(controller.rawText, "aaa\nbbb\nddd\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
            lineIndex: 0,
          ),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "ddd")],
            indent: 1,
            lineIndex: 1,
          ),
          MarkdownNumberListBlockValue.createEmpty(initialText: "ccc", lineIndex: 1),
        ]).toDebug()
      ],
    );
    controller.increaseIndent();
    expect(controller.selection.baseOffset, 11);
    expect(controller.plainText, "aaa\n  bbb\n    ddd\nccc");
    expect(controller.rawText, "aaa\nbbb\nddd\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
            lineIndex: 0,
          ),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "ddd")],
            indent: 2,
            lineIndex: 1,
          ),
          MarkdownNumberListBlockValue.createEmpty(initialText: "ccc", lineIndex: 1),
        ]).toDebug()
      ],
    );
    controller.insertBlock(const NumberListAddMarkdownBlockTools());
    await input.enterText("eee");
    controller.decreaseIndent();
    expect(controller.selection.baseOffset, 15);
    expect(controller.plainText, "aaa\n  bbb\n    ddd\n  eee\nccc");
    expect(controller.rawText, "aaa\nbbb\nddd\neee\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
            lineIndex: 0,
          ),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "ddd")],
            indent: 2,
            lineIndex: 1,
          ),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "eee")],
            indent: 1,
            lineIndex: 2,
          ),
          MarkdownNumberListBlockValue.createEmpty(initialText: "ccc", lineIndex: 1),
        ]).toDebug()
      ],
    );
    controller.decreaseIndent();
    expect(controller.selection.baseOffset, 15);
    expect(controller.plainText, "aaa\n  bbb\n    ddd\neee\nccc");
    expect(controller.rawText, "aaa\nbbb\nddd\neee\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
            lineIndex: 0,
          ),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "ddd")],
            indent: 2,
            lineIndex: 1,
          ),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "eee")],
            indent: 0,
            lineIndex: 2,
          ),
          MarkdownNumberListBlockValue.createEmpty(initialText: "ccc", lineIndex: 1),
        ]).toDebug()
      ],
    );
  });

  testWidgets("MarkdownField.blockProperty.numberList.undoRedo",
      (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    controller.insertBlock(const NumberListAddMarkdownBlockTools());
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    controller.history.undo();
    expect(controller.plainText, "aaa\n");
    expect(controller.rawText, "aaa\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "", lineIndex: 0),
        ]).toDebug()
      ],
    );
    controller.history.redo();
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    await input.cursorAt(1);
    expect(controller.selection.baseOffset, 1);
    controller.exchangeBlock(const NumberListExchangeMarkdownBlockTools());
    expect(controller.selection.baseOffset, 1);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownNumberListBlockValue.createEmpty(initialText: "aaa", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    controller.history.undo();
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    controller.history.redo();
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownNumberListBlockValue.createEmpty(initialText: "aaa", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
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
          MarkdownNumberListBlockValue.createEmpty(initialText: "aaa", lineIndex: 0),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
            lineIndex: 0,
          ),
        ]).toDebug()
      ],
    );
    controller.history.undo();
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownNumberListBlockValue.createEmpty(initialText: "aaa", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    controller.history.redo();
    expect(controller.plainText, "aaa\n  bbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownNumberListBlockValue.createEmpty(initialText: "aaa", lineIndex: 0),
          MarkdownNumberListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
            lineIndex: 0,
          ),
        ]).toDebug()
      ],
    );
  });

  test("MarkdownNumberListBlockValue marker conversion", () {
    final block = MarkdownNumberListBlockValue.createEmpty();

    // Test numeric markers (level 0)
    expect(block.getMarkerForIndent(0, 0), "1.");
    expect(block.getMarkerForIndent(0, 1), "2.");
    expect(block.getMarkerForIndent(0, 2), "3.");
    expect(block.getMarkerForIndent(0, 9), "10.");

    // Test alphabetic markers (level 1)
    expect(block.getMarkerForIndent(1, 0), "a.");
    expect(block.getMarkerForIndent(1, 1), "b.");
    expect(block.getMarkerForIndent(1, 25), "z.");
    expect(block.getMarkerForIndent(1, 26), "aa.");
    expect(block.getMarkerForIndent(1, 27), "ab.");

    // Test roman numeral markers (level 2)
    expect(block.getMarkerForIndent(2, 0), "i.");
    expect(block.getMarkerForIndent(2, 1), "ii.");
    expect(block.getMarkerForIndent(2, 2), "iii.");
    expect(block.getMarkerForIndent(2, 3), "iv.");
    expect(block.getMarkerForIndent(2, 4), "v.");
    expect(block.getMarkerForIndent(2, 8), "ix.");
    expect(block.getMarkerForIndent(2, 9), "x.");

    // Test looping back to level 0 (indent 3)
    expect(block.getMarkerForIndent(3, 0), "1.");
    expect(block.getMarkerForIndent(3, 1), "2.");

    // Test looping back to level 1 (indent 4)
    expect(block.getMarkerForIndent(4, 0), "a.");
    expect(block.getMarkerForIndent(4, 1), "b.");

    // Test looping back to level 2 (indent 5)
    expect(block.getMarkerForIndent(5, 0), "i.");
    expect(block.getMarkerForIndent(5, 1), "ii.");
  });

  test("MarkdownNumberListBlockValue alphabet conversion", () {
    final block = MarkdownNumberListBlockValue.createEmpty();

    expect(block.toAlphabet(1), "a");
    expect(block.toAlphabet(2), "b");
    expect(block.toAlphabet(26), "z");
    expect(block.toAlphabet(27), "aa");
    expect(block.toAlphabet(28), "ab");
    expect(block.toAlphabet(52), "az");
    expect(block.toAlphabet(53), "ba");
  });

  test("MarkdownNumberListBlockValue roman numeral conversion", () {
    final block = MarkdownNumberListBlockValue.createEmpty();

    expect(block.toRoman(1), "i");
    expect(block.toRoman(2), "ii");
    expect(block.toRoman(3), "iii");
    expect(block.toRoman(4), "iv");
    expect(block.toRoman(5), "v");
    expect(block.toRoman(9), "ix");
    expect(block.toRoman(10), "x");
    expect(block.toRoman(50), "l");
    expect(block.toRoman(100), "c");
    expect(block.toRoman(500), "d");
    expect(block.toRoman(1000), "m");
  });
}