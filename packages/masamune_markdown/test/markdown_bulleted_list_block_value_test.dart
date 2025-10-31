// Package imports:
import "package:flutter_test/flutter_test.dart";
import "package:katana/katana.dart";

// Project imports:
import "package:masamune_markdown/masamune_markdown.dart";
import "functions.dart";

void main() {
  testWidgets("MarkdownField.blockProperty.bulletedList.insert",
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
    controller.insertBlock(const BulletedListAddMarkdownBlockTools());
    expect(controller.selection.baseOffset, 4);
    expect(controller.plainText, "aaa\n");
    expect(controller.rawText, "aaa\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: ""),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    controller.insertBlock(const BulletedListAddMarkdownBlockTools());
    expect(controller.selection.baseOffset, 8);
    expect(controller.plainText, "aaa\nbbb\n");
    expect(controller.rawText, "aaa\nbbb\n");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: ""),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "ccc"),
        ]).toDebug()
      ],
    );
  });
  testWidgets("MarkdownField.blockProperty.bulletedList.exchange",
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
    controller.exchangeBlock(const BulletedListExchangeMarkdownBlockTools());
    expect(controller.selection.baseOffset, 5);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.cursorAt(1);
    expect(controller.selection.baseOffset, 1);
    controller.exchangeBlock(const BulletedListExchangeMarkdownBlockTools());
    expect(controller.selection.baseOffset, 1);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownBulletedListBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
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
  testWidgets("MarkdownField.blockProperty.bulletedList.newLine",
      (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    controller.insertBlock(const BulletedListAddMarkdownBlockTools());
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: ""),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "ccc"),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "ccc"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: ""),
          MarkdownBulletedListBlockValue.createEmpty(initialText: ""),
        ]).toDebug()
      ],
    );
  });
  testWidgets("MarkdownField.blockProperty.bulletedList.cutCopyAndPaste",
      (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    controller.insertBlock(const BulletedListAddMarkdownBlockTools());
    await input.enterText("bbb");
    controller.insertBlock(const BulletedListAddMarkdownBlockTools());
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 11);
    expect(controller.plainText, "aaa\nbbb\nccc");
    expect(controller.rawText, "aaa\nbbb\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "ccc"),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "cc"),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "cc"),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "cc"),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
  });
  testWidgets("MarkdownField.blockProperty.bulletedList.indent",
      (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    controller.insertBlock(const BulletedListAddMarkdownBlockTools());
    await input.enterText("bbb");
    controller.insertBlock(const BulletedListAddMarkdownBlockTools());
    await input.enterText("ccc");
    expect(controller.selection.baseOffset, 11);
    expect(controller.plainText, "aaa\nbbb\nccc");
    expect(controller.rawText, "aaa\nbbb\nccc");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "ccc"),
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
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "ccc"),
        ]).toDebug()
      ],
    );
    controller.insertBlock(const BulletedListAddMarkdownBlockTools());
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
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "ddd")],
            indent: 1,
          ),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "ccc"),
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
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "ddd")],
            indent: 2,
          ),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "ccc"),
        ]).toDebug()
      ],
    );
    controller.insertBlock(const BulletedListAddMarkdownBlockTools());
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
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "ddd")],
            indent: 2,
          ),
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "eee")],
            indent: 1,
          ),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "ccc"),
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
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "ddd")],
            indent: 2,
          ),
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "eee")],
            indent: 0,
          ),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "ccc"),
        ]).toDebug()
      ],
    );
  });
  testWidgets("MarkdownField.blockProperty.bulletedList.undoRedo",
      (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    controller.insertBlock(const BulletedListAddMarkdownBlockTools());
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: ""),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug()
      ],
    );
    await input.cursorAt(1);
    expect(controller.selection.baseOffset, 1);
    controller.exchangeBlock(const BulletedListExchangeMarkdownBlockTools());
    expect(controller.selection.baseOffset, 1);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownBulletedListBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownBulletedListBlockValue.createEmpty(initialText: "aaa"),
          MarkdownBulletedListBlockValue(
            id: uuid(),
            children: [MarkdownLineValue.createEmpty(initialText: "bbb")],
            indent: 1,
          ),
        ]).toDebug()
      ],
    );
  });
}
