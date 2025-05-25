part of '/masamune_markdown.dart';

enum MarkdownToolFont {
  back,
  bold,
  italic,
  underline,
  strike,
  link,
  code;

  /// Get the label for the tool.
  ///
  /// ツールのラベルを取得します。
  String label(BuildContext context) {
    final adapter = MasamuneAdapterScope.of<MarkdownMasamuneAdapter>(context);
    final locale = context.locale;
    switch (this) {
      case MarkdownToolFont.back:
        return adapter?.toolsConfig.fontBackLabel.title.value(locale) ?? "";
      case MarkdownToolFont.bold:
        return adapter?.toolsConfig.fontBoldLabel.title.value(locale) ?? "";
      case MarkdownToolFont.italic:
        return adapter?.toolsConfig.fontItalicLabel.title.value(locale) ?? "";
      case MarkdownToolFont.underline:
        return adapter?.toolsConfig.fontUnderlineLabel.title.value(locale) ??
            "";
      case MarkdownToolFont.strike:
        return adapter?.toolsConfig.fontStrikeLabel.title.value(locale) ?? "";
      case MarkdownToolFont.link:
        return adapter?.toolsConfig.fontLinkLabel.title.value(locale) ?? "";
      case MarkdownToolFont.code:
        return adapter?.toolsConfig.fontInlineCodeLabel.title.value(locale) ??
            "";
    }
  }

  /// Get the icon for the tool.
  ///
  /// ツールのアイコンを取得します。
  IconData icon(BuildContext context) {
    final adapter = MasamuneAdapterScope.of<MarkdownMasamuneAdapter>(context);
    switch (this) {
      case MarkdownToolFont.back:
        return adapter?.toolsConfig.fontBackLabel.icon ?? Icons.arrow_back_ios;
      case MarkdownToolFont.bold:
        return adapter?.toolsConfig.fontBoldLabel.icon ?? Icons.format_bold;
      case MarkdownToolFont.italic:
        return adapter?.toolsConfig.fontItalicLabel.icon ?? Icons.format_italic;
      case MarkdownToolFont.underline:
        return adapter?.toolsConfig.fontUnderlineLabel.icon ??
            Icons.format_underline;
      case MarkdownToolFont.strike:
        return adapter?.toolsConfig.fontStrikeLabel.icon ??
            Icons.format_strikethrough;
      case MarkdownToolFont.link:
        return adapter?.toolsConfig.fontLinkLabel.icon ?? Icons.link;
      case MarkdownToolFont.code:
        return adapter?.toolsConfig.fontInlineCodeLabel.icon ?? Icons.code;
    }
  }

  /// Check if the tool is active.
  ///
  /// ツールがアクティブかどうかを確認します。
  bool active(BuildContext context, MarkdownToolRef ref) {
    switch (this) {
      case MarkdownToolFont.back:
        return false;
      case MarkdownToolFont.bold:
        return ref.activeAttribute(Attribute.bold);
      case MarkdownToolFont.italic:
        return ref.activeAttribute(Attribute.italic);
      case MarkdownToolFont.underline:
        return ref.activeAttribute(Attribute.underline);
      case MarkdownToolFont.strike:
        return ref.activeAttribute(Attribute.strikeThrough);
      case MarkdownToolFont.link:
        return ref.activeAttribute(Attribute.link);
      case MarkdownToolFont.code:
        return ref.activeAttribute(Attribute.inlineCode);
    }
  }

  /// Active the tool.
  ///
  /// ツールをアクティブにします。
  Future<void> onActive(BuildContext context, MarkdownToolRef ref) async {
    switch (this) {
      case MarkdownToolFont.back:
        ref.focusedController?.unselect();
        ref.deleteMode();
        break;
      case MarkdownToolFont.bold:
        ref.focusedController?.formatSelection(Attribute.bold);
        break;
      case MarkdownToolFont.italic:
        ref.focusedController?.formatSelection(Attribute.italic);
        break;
      case MarkdownToolFont.underline:
        ref.focusedController?.formatSelection(Attribute.underline);
        break;
      case MarkdownToolFont.strike:
        ref.focusedController?.formatSelection(Attribute.strikeThrough);
        break;
      case MarkdownToolFont.link:
        ref.focusedController?.formatSelection(Attribute.link);
        break;
      case MarkdownToolFont.code:
        ref.focusedController?.formatSelection(Attribute.inlineCode);
        break;
    }
  }

  /// Deactive the tool.
  ///
  /// ツールを非アクティブにします。
  Future<void> onDeactive(BuildContext context, MarkdownToolRef ref) async {
    switch (this) {
      case MarkdownToolFont.back:
        ref.focusedController?.unselect();
        ref.deleteMode();
        break;
      case MarkdownToolFont.bold:
        ref.focusedController?.removeFormatSelection(Attribute.bold);
        break;
      case MarkdownToolFont.italic:
        ref.focusedController?.removeFormatSelection(Attribute.italic);
        break;
      case MarkdownToolFont.underline:
        ref.focusedController?.removeFormatSelection(Attribute.underline);
        break;
      case MarkdownToolFont.strike:
        ref.focusedController?.removeFormatSelection(Attribute.strikeThrough);
        break;
      case MarkdownToolFont.link:
        ref.focusedController?.removeFormatSelection(Attribute.link);
        break;
      case MarkdownToolFont.code:
        ref.focusedController?.removeFormatSelection(Attribute.inlineCode);
        break;
    }
  }
}
