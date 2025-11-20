// Package imports:
import "package:flutter_test/flutter_test.dart";
import "package:katana/katana.dart";

// Project imports:
import "package:masamune_markdown/masamune_markdown.dart";
import "functions.dart";

void main() {
  testWidgets("MarkdownField.blockProperty.numberList.insert", (tester) async {
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
    final currentBlock1 = controller.getCurrentBlock();
    var lineIndex1 = 0;
    if (currentBlock1 is MarkdownNumberListBlockValue) {
      lineIndex1 = currentBlock1.lineIndex + 1;
    }
    controller.insertBlock(MarkdownNumberListBlockValue.createEmpty(
      indent: currentBlock1?.indent ?? 0,
      lineIndex: lineIndex1,
    ));
    expect(controller.selection.baseOffset, 4);
    expect(controller.plainText, "aaa\n");
    expect(controller.rawText, "aaa\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "", lineIndex: 0),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    final currentBlock2 = controller.getCurrentBlock();
    var lineIndex2 = 0;
    if (currentBlock2 is MarkdownNumberListBlockValue) {
      lineIndex2 = currentBlock2.lineIndex + 1;
    }
    controller.insertBlock(MarkdownNumberListBlockValue.createEmpty(
      indent: currentBlock2?.indent ?? 0,
      lineIndex: lineIndex2,
    ));
    expect(controller.selection.baseOffset, 8);
    expect(controller.plainText, "aaa\nbbb\n");
    expect(controller.rawText, "aaa\nbbb\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "", lineIndex: 1),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "ccc", lineIndex: 1),
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
    final currentBlock3 = controller.getCurrentBlock<MarkdownBlockValue>()!;
    controller.exchangeBlock(MarkdownNumberListBlockValue(
      id: currentBlock3.id,
      indent: currentBlock3.indent,
      children: currentBlock3.extractLines() ?? [],
      lineIndex: 0,
    ));
    expect(controller.selection.baseOffset, 5);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    await input.cursorAt(1);
    expect(controller.selection.baseOffset, 1);
    final currentBlock4 = controller.getCurrentBlock<MarkdownBlockValue>()!;
    controller.exchangeBlock(MarkdownNumberListBlockValue(
      id: currentBlock4.id,
      indent: currentBlock4.indent,
      children: currentBlock4.extractLines() ?? [],
      lineIndex: 0,
    ));
    expect(controller.selection.baseOffset, 1);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "aaa", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    final currentBlock5 = controller.getCurrentBlock<MarkdownBlockValue>()!;
    controller.exchangeBlock(MarkdownParagraphBlockValue(
      id: currentBlock5.id,
      indent: currentBlock5.indent,
      children: currentBlock5.extractLines() ?? [],
    ));
    expect(controller.selection.baseOffset, 1);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    await input.cursorAt(5);
    expect(controller.selection.baseOffset, 5);
    final currentBlock6 = controller.getCurrentBlock<MarkdownBlockValue>()!;
    controller.exchangeBlock(MarkdownParagraphBlockValue(
      id: currentBlock6.id,
      indent: currentBlock6.indent,
      children: currentBlock6.extractLines() ?? [],
    ));
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

  testWidgets("MarkdownField.blockProperty.numberList.newLine", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    final currentBlock7 = controller.getCurrentBlock();
    var lineIndex7 = 0;
    if (currentBlock7 is MarkdownNumberListBlockValue) {
      lineIndex7 = currentBlock7.lineIndex + 1;
    }
    controller.insertBlock(MarkdownNumberListBlockValue.createEmpty(
      indent: currentBlock7?.indent ?? 0,
      lineIndex: lineIndex7,
    ));
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "", lineIndex: 1),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "ccc", lineIndex: 1),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "ccc", lineIndex: 1),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "", lineIndex: 2),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "", lineIndex: 3),
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
    final currentBlock8 = controller.getCurrentBlock();
    var lineIndex8 = 0;
    if (currentBlock8 is MarkdownNumberListBlockValue) {
      lineIndex8 = currentBlock8.lineIndex + 1;
    }
    controller.insertBlock(MarkdownNumberListBlockValue.createEmpty(
      indent: currentBlock8?.indent ?? 0,
      lineIndex: lineIndex8,
    ));
    await input.enterText("bbb");
    final currentBlock9 = controller.getCurrentBlock();
    var lineIndex9 = 0;
    if (currentBlock9 is MarkdownNumberListBlockValue) {
      lineIndex9 = currentBlock9.lineIndex + 1;
    }
    controller.insertBlock(MarkdownNumberListBlockValue.createEmpty(
      indent: currentBlock9?.indent ?? 0,
      lineIndex: lineIndex9,
    ));
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 11);
    expect(controller.plainText, "aaa\nbbb\nccc");
    expect(controller.rawText, "aaa\nbbb\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "ccc", lineIndex: 1),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "cc", lineIndex: 1),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "cc", lineIndex: 1),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "cc", lineIndex: 1),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
  });

  testWidgets("MarkdownField.blockProperty.numberList.indent", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    final currentBlock10 = controller.getCurrentBlock();
    var lineIndex10 = 0;
    if (currentBlock10 is MarkdownNumberListBlockValue) {
      lineIndex10 = currentBlock10.lineIndex + 1;
    }
    controller.insertBlock(MarkdownNumberListBlockValue.createEmpty(
      indent: currentBlock10?.indent ?? 0,
      lineIndex: lineIndex10,
    ));
    await input.enterText("bbb");
    final currentBlock11 = controller.getCurrentBlock();
    var lineIndex11 = 0;
    if (currentBlock11 is MarkdownNumberListBlockValue) {
      lineIndex11 = currentBlock11.lineIndex + 1;
    }
    controller.insertBlock(MarkdownNumberListBlockValue.createEmpty(
      indent: currentBlock11?.indent ?? 0,
      lineIndex: lineIndex11,
    ));
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 11);
    expect(controller.plainText, "aaa\nbbb\nccc");
    expect(controller.rawText, "aaa\nbbb\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "ccc", lineIndex: 1),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "ccc", lineIndex: 1),
        ]).toDebug()
      ],
    );
    final currentBlock12 = controller.getCurrentBlock();
    var lineIndex12 = 0;
    if (currentBlock12 is MarkdownNumberListBlockValue) {
      lineIndex12 = currentBlock12.lineIndex + 1;
    }
    controller.insertBlock(MarkdownNumberListBlockValue.createEmpty(
      indent: currentBlock12?.indent ?? 0,
      lineIndex: lineIndex12,
    ));
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "ccc", lineIndex: 1),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "ccc", lineIndex: 1),
        ]).toDebug()
      ],
    );
    final currentBlock13 = controller.getCurrentBlock();
    var lineIndex13 = 0;
    if (currentBlock13 is MarkdownNumberListBlockValue) {
      lineIndex13 = currentBlock13.lineIndex + 1;
    }
    controller.insertBlock(MarkdownNumberListBlockValue.createEmpty(
      indent: currentBlock13?.indent ?? 0,
      lineIndex: lineIndex13,
    ));
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "ccc", lineIndex: 1),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "ccc", lineIndex: 1),
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
    final currentBlock14 = controller.getCurrentBlock();
    var lineIndex14 = 0;
    if (currentBlock14 is MarkdownNumberListBlockValue) {
      lineIndex14 = currentBlock14.lineIndex + 1;
    }
    controller.insertBlock(MarkdownNumberListBlockValue.createEmpty(
      indent: currentBlock14?.indent ?? 0,
      lineIndex: lineIndex14,
    ));
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "", lineIndex: 0),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
        ]).toDebug()
      ],
    );
    await input.cursorAt(1);
    expect(controller.selection.baseOffset, 1);
    final currentBlock15 = controller.getCurrentBlock<MarkdownBlockValue>()!;
    controller.exchangeBlock(MarkdownNumberListBlockValue(
      id: currentBlock15.id,
      indent: currentBlock15.indent,
      children: currentBlock15.extractLines() ?? [],
      lineIndex: 0,
    ));
    expect(controller.selection.baseOffset, 1);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "aaa", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "aaa", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "aaa", lineIndex: 0),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "aaa", lineIndex: 0),
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "bbb", lineIndex: 0),
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
          MarkdownNumberListBlockValue.createEmpty(
              initialText: "aaa", lineIndex: 0),
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
