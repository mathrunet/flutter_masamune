import "package:masamune_markdown/masamune_markdown.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  setUpAll(() {
    // Initialize the adapter for all tests
    const adapter = MarkdownMasamuneAdapter();
    adapter.onInitScope(adapter);
  });

  test("MarkdownFieldValue.fromMarkdown - Simple paragraph", () {
    const markdown = "This is a simple paragraph";
    final result = MarkdownFieldValue.fromMarkdown(markdown);

    expect(result.children.length, 1);
    expect(result.children[0], isA<MarkdownParagraphBlockValue>());
  });

  test("MarkdownFieldValue.fromMarkdown - Inline properties", () {
    const markdown = "This is **bold** and *italic* text with `code`";
    final result = MarkdownFieldValue.fromMarkdown(markdown);

    expect(result.children.length, 1);
    final block = result.children[0] as MarkdownParagraphBlockValue;
    expect(block.children.length, 1);

    final line = block.children[0];
    expect(line.children.length, 6); // "This is ", "bold", " and ", "italic", " text with ", "code"

    expect(line.children[1].properties.length, 1);
    expect(line.children[1].properties[0], isA<BoldFontMarkdownSpanProperty>());

    expect(line.children[3].properties.length, 1);
    expect(line.children[3].properties[0], isA<ItalicFontMarkdownSpanProperty>());

    expect(line.children[5].properties.length, 1);
    expect(line.children[5].properties[0], isA<CodeFontMarkdownSpanProperty>());
  });

  test("MarkdownFieldValue.fromMarkdown - Heading 1", () {
    const markdown = "# Heading 1";
    final result = MarkdownFieldValue.fromMarkdown(markdown);

    expect(result.children.length, 1);
    expect(result.children[0], isA<MarkdownHeadline1BlockValue>());
  });

  test("MarkdownFieldValue.fromMarkdown - Bulleted list", () {
    const markdown = "- Item 1\n- Item 2\n- Item 3";
    final result = MarkdownFieldValue.fromMarkdown(markdown);

    expect(result.children.length, 3);
    expect(result.children[0], isA<MarkdownBulletedListBlockValue>());
    expect(result.children[1], isA<MarkdownBulletedListBlockValue>());
    expect(result.children[2], isA<MarkdownBulletedListBlockValue>());
  });

  test("MarkdownFieldValue.fromMarkdown - Code block", () {
    const markdown = """
```dart
void main() {
  print('Hello');
}
```
""";
    final result = MarkdownFieldValue.fromMarkdown(markdown.trim());

    expect(result.children.length, 1);
    expect(result.children[0], isA<MarkdownCodeBlockValue>());
    final codeBlock = result.children[0] as MarkdownCodeBlockValue;
    expect(codeBlock.language, "dart");
  });

  test("MarkdownFieldValue.fromMarkdown - Consecutive quotes", () {
    const markdown = """
> Line 1
> Line 2
> Line 3
""";
    final result = MarkdownFieldValue.fromMarkdown(markdown.trim());

    expect(result.children.length, 1);
    expect(result.children[0], isA<MarkdownQuoteBlockValue>());
    final quoteBlock = result.children[0] as MarkdownQuoteBlockValue;
    expect(quoteBlock.children.length, 3);
  });

  test("MarkdownFieldValue.fromMarkdown - Image in text splits blocks", () {
    const markdown = "Before text ![image](http://example.com/image.png) After text";
    final result = MarkdownFieldValue.fromMarkdown(markdown);

    expect(result.children.length, 3);
    expect(result.children[0], isA<MarkdownParagraphBlockValue>());
    expect(result.children[1], isA<MarkdownImageBlockValue>());
    expect(result.children[2], isA<MarkdownParagraphBlockValue>());
  });

  test("MarkdownFieldValue.fromMarkdown - Mixed block types", () {
    const markdown = """
# Heading
Some paragraph text
- Bullet 1
- Bullet 2
> Quote line
""";
    final result = MarkdownFieldValue.fromMarkdown(markdown.trim());

    expect(result.children.length, 5);
    expect(result.children[0], isA<MarkdownHeadline1BlockValue>());
    expect(result.children[1], isA<MarkdownParagraphBlockValue>());
    expect(result.children[2], isA<MarkdownBulletedListBlockValue>());
    expect(result.children[3], isA<MarkdownBulletedListBlockValue>());
    expect(result.children[4], isA<MarkdownQuoteBlockValue>());
  });

  test("MarkdownFieldValue.fromMarkdown - Link", () {
    const markdown = "Check out [this link](https://example.com)";
    final result = MarkdownFieldValue.fromMarkdown(markdown);

    expect(result.children.length, 1);
    final block = result.children[0] as MarkdownParagraphBlockValue;
    final line = block.children[0];

    expect(line.children.length, 2); // "Check out ", "this link"
    expect(line.children[1].properties.length, 1);
    expect(line.children[1].properties[0], isA<LinkMarkdownSpanProperty>());
    final linkProp = line.children[1].properties[0] as LinkMarkdownSpanProperty;
    expect(linkProp.link, "https://example.com");
  });

  test("MarkdownFieldValue.fromMarkdown - Strikethrough", () {
    const markdown = "This is ~~strikethrough~~ text";
    final result = MarkdownFieldValue.fromMarkdown(markdown);

    expect(result.children.length, 1);
    final block = result.children[0] as MarkdownParagraphBlockValue;
    final line = block.children[0];

    expect(line.children.length, 3); // "This is ", "strikethrough", " text"
    expect(line.children[1].properties.length, 1);
    expect(line.children[1].properties[0], isA<StrikeFontMarkdownSpanProperty>());
  });

  test("MarkdownFieldValue.fromMarkdown - Empty string", () {
    const markdown = "";
    final result = MarkdownFieldValue.fromMarkdown(markdown);

    expect(result.children.length, 1);
    expect(result.children[0], isA<MarkdownParagraphBlockValue>());
  });

  test("MarkdownFieldValue.fromMarkdown - Toggle list", () {
    const markdown = "[x] Completed task\n[ ] Pending task";
    final result = MarkdownFieldValue.fromMarkdown(markdown);

    expect(result.children.length, 2);
    expect(result.children[0], isA<MarkdownToggleListBlockValue>());
    expect(result.children[1], isA<MarkdownToggleListBlockValue>());

    final completedTask = result.children[0] as MarkdownToggleListBlockValue;
    final pendingTask = result.children[1] as MarkdownToggleListBlockValue;

    expect(completedTask.checked, true);
    expect(pendingTask.checked, false);
  });
}
