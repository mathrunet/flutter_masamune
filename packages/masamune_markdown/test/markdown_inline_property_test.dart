// Package imports:
import "package:flutter_test/flutter_test.dart";
import "package:katana/katana.dart";

// Project imports:
import "package:masamune_markdown/masamune_markdown.dart";
import "functions.dart";

void main() {
  testWidgets("MarkdownField.inlineProperty.singleLine", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 6);
    await input.selectAt(1, 3);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    controller.addInlineProperty(
      const BoldFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    expect(controller.plainText, "aaabbb");
    expect(controller.rawText, "aaabbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    BoldFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "bbb",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    await input.selectAt(4, 6);
    expect(controller.selection.baseOffset, 4);
    expect(controller.selection.extentOffset, 6);
    controller.addInlineProperty(
      const ItalicFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 4);
    expect(controller.selection.extentOffset, 6);
    expect(controller.plainText, "aaabbb");
    expect(controller.rawText, "aaabbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    BoldFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "bb",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    await input.selectAt(2, 5);
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 5);
    controller.addInlineProperty(
      const CodeFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 5);
    expect(controller.plainText, "aaabbb");
    expect(controller.rawText, "aaabbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [
                    BoldFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [
                    BoldFontMarkdownSpanProperty(),
                    CodeFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    CodeFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                    CodeFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    await input.selectAt(1, 3);
    expect(
      controller.hasInlineProperty(
        const BoldFontMarkdownInlineTools(),
      ),
      isTrue,
    );
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    controller.removeInlineProperty(
      const BoldFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    expect(
      controller.hasInlineProperty(
        const BoldFontMarkdownInlineTools(),
      ),
      isFalse,
    );
    expect(controller.plainText, "aaabbb");
    expect(controller.rawText, "aaabbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "ab",
                  properties: const [
                    CodeFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                    CodeFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    await input.selectAll();
    expect(
      controller.hasInlineProperty(
        const ItalicFontMarkdownInlineTools(),
      ),
      isFalse,
    );
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 6);
    controller.addInlineProperty(
      const ItalicFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 6);
    expect(
      controller.hasInlineProperty(
        const ItalicFontMarkdownInlineTools(),
      ),
      isTrue,
    );
    expect(controller.plainText, "aaabbb");
    expect(controller.rawText, "aaabbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "abb",
                  properties: const [
                    CodeFontMarkdownSpanProperty(),
                    ItalicFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
  });
  testWidgets("MarkdownField.inlineProperty.multiLine", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    await input.enterText("\n");
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    await input.selectAt(2, 5);
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 5);
    controller.addInlineProperty(
      const StrikeFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 5);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "bb",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    await input.selectAt(1, 6);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 6);
    controller.addInlineProperty(
      const UnderlineFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 6);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [
                    UnderlineFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                    UnderlineFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                    UnderlineFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    UnderlineFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    await input.selectAt(1, 3);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    expect(
        controller.hasInlineProperty(
          const UnderlineFontMarkdownInlineTools(),
        ),
        isTrue);
    controller.removeInlineProperty(
      const UnderlineFontMarkdownInlineTools(),
    );
    expect(
        controller.hasInlineProperty(
          const UnderlineFontMarkdownInlineTools(),
        ),
        isFalse);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                    UnderlineFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    UnderlineFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    await input.selectAll();
    expect(
      controller.hasInlineProperty(
        const UnderlineFontMarkdownInlineTools(),
      ),
      isFalse,
    );
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 7);
    controller.addInlineProperty(
      const UnderlineFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 0);
    expect(controller.selection.extentOffset, 7);
    expect(
      controller.hasInlineProperty(
        const UnderlineFontMarkdownInlineTools(),
      ),
      isTrue,
    );
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    UnderlineFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                    UnderlineFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                    UnderlineFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "bb",
                  properties: const [
                    UnderlineFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    controller.removeInlineProperty(
      const UnderlineFontMarkdownInlineTools(),
    );
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "bb",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
  });
  testWidgets("MarkdownField.inlineProperty.copyCutAndPaste", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    await input.enterText("\n");
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    await input.selectAt(2, 5);
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 5);
    controller.addInlineProperty(
      const StrikeFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 2);
    expect(controller.selection.extentOffset, 5);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "bb",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    await input.selectAt(1, 3);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    await controller.clipboard.cut();
    expect(controller.selection.baseOffset, 1);
    expect(await controller.clipboard.currentText, "aa");
    expect(controller.rawText, "a\nbbb");
    expect(controller.plainText, "a\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "bb",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    await input.selectAt(3, 5);
    expect(controller.selection.baseOffset, 3);
    expect(controller.selection.extentOffset, 5);
    await controller.clipboard.paste();
    expect(controller.selection.baseOffset, 5);
    expect(controller.selection.extentOffset, 5);
    expect(controller.plainText, "a\nbaa");
    expect(controller.rawText, "a\nbaa");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [
                    StrikeFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
  });
  testWidgets("MarkdownField.inlineProperty.indent", (tester) async {
    final context = await buildMarkdownField(tester);
    final controller = context.controller;
    final input = context.input;

    await input.enterText("aaa");
    await input.enterText("\n");
    await input.enterText("bbb");
    expect(controller.selection.baseOffset, 7);
    controller.increaseIndent();
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
    controller.addInlineProperty(
      const LinkMarkdownInlineTools(),
    );
  });
  testWidgets("MarkdownField.inlineProperty.link", (tester) async {
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
    await input.selectAt(1, 3);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    controller.updateLinkUrl("https://example.com");
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    LinkMarkdownSpanProperty(link: "https://example.com"),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug(),
      ],
    );
    await input.selectAt(5, 6);
    expect(controller.selection.baseOffset, 5);
    expect(controller.selection.extentOffset, 6);
    controller.updateLinkUrl("https://example.org");
    expect(controller.selection.baseOffset, 5);
    expect(controller.selection.extentOffset, 6);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    LinkMarkdownSpanProperty(link: "https://example.com"),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    LinkMarkdownSpanProperty(link: "https://example.org"),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    await input.selectAt(1, 3);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    controller.updateLinkUrl(null);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    LinkMarkdownSpanProperty(link: "https://example.org"),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
  });
  testWidgets("MarkdownField.inlineProperty.mention", (tester) async {
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
    await input.cursorAt(1);
    expect(controller.selection.baseOffset, 1);
    const mention1 = MarkdownMention(
      id: "user1",
      name: "John",
    );
    controller.insertMention(mention1);
    expect(controller.selection.baseOffset, 6);
    expect(controller.plainText, "a@Johnaa\nbbb");
    expect(controller.rawText, "a@Johnaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "@John",
                  properties: const [
                    MentionMarkdownSpanProperty(mention: mention1),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug(),
      ],
    );
    await input.cursorAt(10);
    expect(controller.selection.baseOffset, 10);
    const mention2 = MarkdownMention(
      id: "user2",
      name: "Alice",
    );
    controller.insertMention(mention2);
    expect(controller.selection.baseOffset, 16);
    expect(controller.plainText, "a@Johnaa\nb@Alicebb");
    expect(controller.rawText, "a@Johnaa\nb@Alicebb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "@John",
                  properties: const [
                    MentionMarkdownSpanProperty(mention: mention1),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "@Alice",
                  properties: const [
                    MentionMarkdownSpanProperty(mention: mention2),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "bb",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
  });
  testWidgets("MarkdownField.inlineProperty.undoRedo", (tester) async {
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
    await input.selectAt(1, 3);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    controller.addInlineProperty(
      const BoldFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    BoldFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug(),
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
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
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
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    BoldFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug(),
      ],
    );
    await input.selectAt(5, 6);
    expect(controller.selection.baseOffset, 5);
    expect(controller.selection.extentOffset, 6);
    controller.addInlineProperty(
      const ItalicFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 5);
    expect(controller.selection.extentOffset, 6);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    BoldFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    controller.history.undo();
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    BoldFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(initialText: "bbb"),
        ]).toDebug(),
      ],
    );
    controller.history.redo();
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    BoldFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    await input.selectAt(1, 3);
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    controller.removeInlineProperty(
      const BoldFontMarkdownInlineTools(),
    );
    expect(controller.selection.baseOffset, 1);
    expect(controller.selection.extentOffset, 3);
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(initialText: "aaa"),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
    controller.history.undo();
    expect(controller.plainText, "aaa\nbbb");
    expect(controller.rawText, "aaa\nbbb");
    expect(
      controller.value?.toDebug(),
      [
        MarkdownFieldValue.createEmpty(children: [
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "a",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "aa",
                  properties: const [
                    BoldFontMarkdownSpanProperty(),
                  ],
                ),
              ],
            ),
          ]),
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
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
          MarkdownParagraphBlockValue.createEmpty(children: [
            MarkdownLineValue.createEmpty(
              children: [
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [
                    ItalicFontMarkdownSpanProperty(),
                  ],
                ),
                MarkdownSpanValue(
                  id: uuid(),
                  value: "b",
                  properties: const [],
                ),
              ],
            ),
          ]),
        ]).toDebug(),
      ],
    );
  });
}
