// Package imports:
import "package:flutter_test/flutter_test.dart";

// Project imports:
import "package:masamune_markdown/masamune_markdown.dart";
import "functions.dart";

void main() {
  testWidgets("MarkdownField.blockProperty.headline1.insert", (tester) async {
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
    controller.insertBlock(MarkdownHeadline1BlockValue.createEmpty(indent: currentBlock1?.indent ?? 0));
    expect(controller.selection.baseOffset, 4);
    expect(controller.plainText, "aaa\n");
    expect(controller.rawText, "aaa\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: ""),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    final currentBlock2 = controller.getCurrentBlock();
    controller.insertBlock(MarkdownHeadline1BlockValue.createEmpty(indent: currentBlock2?.indent ?? 0));
    expect(controller.selection.baseOffset, 8);
    expect(controller.plainText, "aaa\nbbb\n");
    expect(controller.rawText, "aaa\nbbb\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: ""),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: "ccc"),
        ]).toDebug()
      ],
    );
  });
  testWidgets("MarkdownField.blockProperty.headline1.exchange", (tester) async {
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
    controller.exchangeBlock(MarkdownHeadline1BlockValue(
      id: currentBlock3.id,
      indent: currentBlock3.indent,
      children: currentBlock3.extractLines() ?? [],
    ));
    expect(controller.selection.baseOffset, 5);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.cursorAt(1);
    expect(controller.selection.baseOffset, 1);
    final currentBlock4 = controller.getCurrentBlock<MarkdownBlockValue>()!;
    controller.exchangeBlock(MarkdownHeadline1BlockValue(
      id: currentBlock4.id,
      indent: currentBlock4.indent,
      children: currentBlock4.extractLines() ?? [],
    ));
    expect(controller.selection.baseOffset, 1);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownHeadline1BlockValue.createEmpty(initialText: "aaa"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
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
  testWidgets("MarkdownField.blockProperty.headline1.newLine", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    final currentBlock7 = controller.getCurrentBlock();
    controller.insertBlock(MarkdownHeadline1BlockValue.createEmpty(indent: currentBlock7?.indent ?? 0));
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
          MarkdownParagraphBlockValue.createEmpty(initialText: ""),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "ccc"),
        ]).toDebug()
      ],
    );
  });
  testWidgets("MarkdownField.blockProperty.headline1.cutCopyAndPaste",
      (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    final currentBlock8 = controller.getCurrentBlock();
    controller.insertBlock(MarkdownHeadline1BlockValue.createEmpty(indent: currentBlock8?.indent ?? 0));
    await input.enterText("bbb");
    final currentBlock9 = controller.getCurrentBlock();
    controller.insertBlock(MarkdownHeadline1BlockValue.createEmpty(indent: currentBlock9?.indent ?? 0));
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 11);
    expect(controller.plainText, "aaa\nbbb\nccc");
    expect(controller.rawText, "aaa\nbbb\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: "ccc"),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: "cc"),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: "cc"),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: "cc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
  });
  testWidgets("MarkdownField.blockProperty.headline1.undoRedo", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    final currentBlock10 = controller.getCurrentBlock();
    controller.insertBlock(MarkdownHeadline1BlockValue.createEmpty(indent: currentBlock10?.indent ?? 0));
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: ""),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.cursorAt(1);
    expect(controller.selection.baseOffset, 1);
    final currentBlock11 = controller.getCurrentBlock<MarkdownBlockValue>()!;
    controller.exchangeBlock(MarkdownHeadline1BlockValue(
      id: currentBlock11.id,
      indent: currentBlock11.indent,
      children: currentBlock11.extractLines() ?? [],
    ));
    expect(controller.selection.baseOffset, 1);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownHeadline1BlockValue.createEmpty(initialText: "aaa"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownHeadline1BlockValue.createEmpty(initialText: "aaa"),
          MarkdownHeadline1BlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
  });
}
