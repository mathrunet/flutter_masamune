import "package:masamune_markdown/masamune_markdown.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  setUpAll(() {
    // Initialize the adapter for all tests
    const adapter = MarkdownMasamuneAdapter();
    adapter.onInitScope(adapter);
  });

  group("Roundtrip tests - fromMarkdown -> toMarkdown", () {
    test("Simple paragraph", () {
      const markdown = "This is a simple paragraph";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Inline properties - Bold", () {
      const markdown = "This is **bold** text";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Inline properties - Italic", () {
      const markdown = "This is *italic* text";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Inline properties - Code", () {
      const markdown = "This is `code` text";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Inline properties - Strikethrough", () {
      const markdown = "This is ~~strikethrough~~ text";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Inline properties - Link", () {
      const markdown = "Check out [this link](https://example.com)";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Inline properties - Multiple in one line", () {
      const markdown = "This is **bold** and *italic* text with `code`";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Inline properties - Combined bold, italic, code", () {
      const markdown = "Text with **bold**, *italic*, and `code` all together";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });
  });

  group("Block level tests", () {
    test("Heading 1", () {
      const markdown = "# Heading 1";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Heading 2", () {
      const markdown = "## Heading 2";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Heading 3", () {
      const markdown = "### Heading 3";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Bulleted list", () {
      const markdown = "- Item 1\n- Item 2\n- Item 3";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Number list", () {
      const markdown = "1. Item 1\n2. Item 2\n3. Item 3";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Toggle list", () {
      const markdown = "[x] Completed task\n[ ] Pending task";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Code block", () {
      const markdown = "```dart\nvoid main() {\n  print('Hello');\n}\n```";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Quote", () {
      const markdown = "> Line 1\n> Line 2\n> Line 3";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Image", () {
      const markdown = "![image](http://example.com/image.png)";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });
  });

  group("Mixed content tests", () {
    test("Multiple blocks", () {
      const markdown = "# Heading\nSome paragraph text\n- Bullet 1\n- Bullet 2";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Blocks with inline properties", () {
      const markdown = "# Heading with **bold**\nParagraph with *italic*\n- List with `code`";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Quote with inline properties", () {
      const markdown = "> This is a **bold** quote\n> With *italic* text\n> And `code`";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });
  });

  group("Edge cases", () {
    test("Empty markdown", () {
      const markdown = "";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      // Empty string creates an empty paragraph
      expect(output, "");
    });

    test("Text with special characters", () {
      const markdown = "Text with & < > special chars";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Multiple consecutive inline properties", () {
      const markdown = "**bold1** **bold2** *italic1* *italic2*";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Link with special characters in URL", () {
      const markdown = "[link](https://example.com/path?query=value&other=test)";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Code block with language", () {
      const markdown = "```javascript\nconsole.log('test');\n```";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });
  });

  group("Double roundtrip tests - ensure idempotency", () {
    test("Double roundtrip - paragraph with inline properties", () {
      const markdown = "Text with **bold** and *italic*";

      // First roundtrip
      final value1 = MarkdownFieldValue.fromMarkdown(markdown);
      final output1 = value1.toMarkdown();

      // Second roundtrip
      final value2 = MarkdownFieldValue.fromMarkdown(output1);
      final output2 = value2.toMarkdown();

      expect(output1, markdown);
      expect(output2, markdown);
      expect(output1, output2);
    });

    test("Double roundtrip - mixed blocks", () {
      const markdown = "# Heading\nParagraph\n- List item";

      // First roundtrip
      final value1 = MarkdownFieldValue.fromMarkdown(markdown);
      final output1 = value1.toMarkdown();

      // Second roundtrip
      final value2 = MarkdownFieldValue.fromMarkdown(output1);
      final output2 = value2.toMarkdown();

      expect(output1, markdown);
      expect(output2, markdown);
      expect(output1, output2);
    });
  });

  group("Number list auto-numbering tests", () {
    test("Number list interrupted by paragraph", () {
      const markdown = "1. Item 1\n2. Item 2\nSome paragraph\n1. Item 3\n2. Item 4";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Number list interrupted by heading", () {
      const markdown = "1. Item 1\n2. Item 2\n# Heading\n1. Item 3\n2. Item 4";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Number list interrupted by bulleted list", () {
      const markdown = "1. Item 1\n2. Item 2\n- Bullet item\n1. Item 3\n2. Item 4";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Multiple consecutive number list groups", () {
      const markdown = "1. Group 1 Item 1\n2. Group 1 Item 2\nParagraph break\n1. Group 2 Item 1\n2. Group 2 Item 2";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Long number list", () {
      final markdown = List.generate(10, (i) => "${i + 1}. Item ${i + 1}").join("\n");
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Number list with inline properties", () {
      const markdown = "1. Item with **bold**\n2. Item with *italic*\n3. Item with `code`";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });

    test("Mixed list types maintain separate numbering", () {
      const markdown = "1. Number 1\n2. Number 2\n- Bullet\n1. Number 3\n2. Number 4";
      final value = MarkdownFieldValue.fromMarkdown(markdown);
      final output = value.toMarkdown();
      expect(output, markdown);
    });
  });
}
