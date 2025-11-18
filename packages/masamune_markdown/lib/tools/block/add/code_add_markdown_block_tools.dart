part of "/masamune_markdown.dart";

/// Display the menu to add code blocks [MarkdownTools].
///
/// コードブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class CodeAddMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownCodeBlockValue> {
  /// Display the menu to add code blocks [MarkdownTools].
  ///
  /// コードブロックを追加するメニューを表示する[MarkdownTools]。
  const CodeAddMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "コード",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Code",
        ),
      ]),
      icon: FontAwesomeIcons.code,
    ),
  });

  @override
  String get id => "__markdown_block_add_code__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) => true;

  @override
  Widget icon(BuildContext context, MarkdownToolRef ref) {
    return Icon(config.icon);
  }

  @override
  Widget label(BuildContext context, MarkdownToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, MarkdownToolRef ref) {
    ref.controller.insertBlock(this);
    ref.deleteMode();
  }

  @override
  MarkdownBlockValue addBlock({MarkdownBlockValue? source}) {
    return MarkdownCodeBlockValue.createEmpty(
      indent: source?.indent ?? 0,
    );
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    if (target is MarkdownCodeBlockValue) {
      return null;
    }
    return MarkdownCodeBlockValue(
      id: target.id,
      indent: target.indent,
      children: target.extractLines() ?? [],
    );
  }

  @override
  MarkdownCodeBlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kCodeBlockType) {
      return null;
    }
    return MarkdownCodeBlockValue.fromJson(json);
  }

  @override
  ({MarkdownCodeBlockValue? value, int linesConsumed})? convertFromMarkdown(
    MarkdownParseContext context,
  ) {
    final line = context.currentLine.trim();

    // Check if this is a code block opening (```)
    if (!line.startsWith("```")) {
      return null;
    }

    // Extract language from opening line
    final language = line.substring(3).trim();

    // Collect code lines until closing ```
    final codeLines = <String>[];
    var consumed = 1; // Start with 1 for the opening ``` line

    while (context.currentIndex + consumed < context.lines.length) {
      final nextLine = context.lines[context.currentIndex + consumed];

      // Check for closing ```
      if (nextLine.trim().startsWith("```")) {
        consumed++; // Include the closing ``` line
        break;
      }

      codeLines.add(nextLine);
      consumed++;
    }

    // Build the full markdown string for parsing
    final fullMarkdown = "```$language\n${codeLines.join("\n")}\n```";

    return (
      value: MarkdownCodeBlockValue.fromMarkdown(fullMarkdown),
      linesConsumed: consumed,
    );
  }

  @override
  MarkdownCodeBlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownCodeBlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
