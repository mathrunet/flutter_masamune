part of "/masamune_markdown.dart";

/// An enumeration type for adding Markdown block styles.
///
/// マークダウンのブロックスタイルを追加するための列挙型。
enum MarkdownToolAdd {
  /// Text tool.
  ///
  /// テキストのスタイルを変更します。
  text,

  /// Heading 1 style.
  ///
  /// 見出し1のスタイルを変更します。
  h1,

  /// Heading 2 style.
  ///
  /// 見出し2のスタイルを変更します。
  h2,

  /// Heading 3 style.
  ///
  /// 見出し3のスタイルを変更します。
  h3,

  /// Bulleted list style.
  ///
  /// 箇条書きのスタイルを変更します。
  bulletedList,

  /// Number list style.
  ///
  /// 番号付きリストのスタイルを変更します。
  numberList,

  /// Toggle list style.
  ///
  /// チェックボックスのスタイルを変更します。
  toggleList,

  /// Code style.
  ///
  /// コードのスタイルを変更します。
  code,

  /// Quote style.
  ///
  /// 引用のスタイルを変更します。
  quote;

  /// Get the label for the tool.
  ///
  /// ツールのラベルを取得します。
  String label(BuildContext context) {
    final adapter = MasamuneAdapterScope.of<MarkdownMasamuneAdapter>(context);
    final locale = context.locale;
    switch (this) {
      case MarkdownToolAdd.text:
        return adapter?.toolsConfig.textLabel.title.value(locale) ?? "";
      case MarkdownToolAdd.h1:
        return adapter?.toolsConfig.h1Label.title.value(locale) ?? "";
      case MarkdownToolAdd.h2:
        return adapter?.toolsConfig.h2Label.title.value(locale) ?? "";
      case MarkdownToolAdd.h3:
        return adapter?.toolsConfig.h3Label.title.value(locale) ?? "";
      case MarkdownToolAdd.bulletedList:
        return adapter?.toolsConfig.bulletedListLabel.title.value(locale) ?? "";
      case MarkdownToolAdd.numberList:
        return adapter?.toolsConfig.numberListLabel.title.value(locale) ?? "";
      case MarkdownToolAdd.toggleList:
        return adapter?.toolsConfig.toggleListLabel.title.value(locale) ?? "";
      case MarkdownToolAdd.code:
        return adapter?.toolsConfig.codeLabel.title.value(locale) ?? "";
      case MarkdownToolAdd.quote:
        return adapter?.toolsConfig.quoteLabel.title.value(locale) ?? "";
    }
  }

  /// Get the icon for the tool.
  ///
  /// ツールのアイコンを取得します。
  IconData icon(BuildContext context) {
    final adapter = MasamuneAdapterScope.of<MarkdownMasamuneAdapter>(context);
    switch (this) {
      case MarkdownToolAdd.text:
        return adapter?.toolsConfig.textLabel.icon ?? Icons.title;
      case MarkdownToolAdd.h1:
        return adapter?.toolsConfig.h1Label.icon ?? FontAwesomeIcons.heading;
      case MarkdownToolAdd.h2:
        return adapter?.toolsConfig.h2Label.icon ?? FontAwesomeIcons.heading;
      case MarkdownToolAdd.h3:
        return adapter?.toolsConfig.h3Label.icon ?? FontAwesomeIcons.heading;
      case MarkdownToolAdd.bulletedList:
        return adapter?.toolsConfig.bulletedListLabel.icon ??
            FontAwesomeIcons.listUl;
      case MarkdownToolAdd.numberList:
        return adapter?.toolsConfig.numberListLabel.icon ??
            FontAwesomeIcons.listOl;
      case MarkdownToolAdd.toggleList:
        return adapter?.toolsConfig.toggleListLabel.icon ??
            FontAwesomeIcons.listCheck;
      case MarkdownToolAdd.code:
        return adapter?.toolsConfig.codeLabel.icon ?? FontAwesomeIcons.code;
      case MarkdownToolAdd.quote:
        return adapter?.toolsConfig.quoteLabel.icon ??
            FontAwesomeIcons.quoteLeft;
    }
  }

  /// Execute the tool.
  ///
  /// ツールを実行します。
  Future<void> onTap(BuildContext context, MarkdownToolRef ref) async {
    switch (this) {
      case MarkdownToolAdd.text:
        ref.focusedController?.addFormattedLine(null);
        break;
      case MarkdownToolAdd.h1:
        ref.focusedController?.addFormattedLine(Attribute.h1);
        break;
      case MarkdownToolAdd.h2:
        ref.focusedController?.addFormattedLine(Attribute.h2);
        break;
      case MarkdownToolAdd.h3:
        ref.focusedController?.addFormattedLine(Attribute.h3);
        break;
      case MarkdownToolAdd.bulletedList:
        ref.focusedController?.addFormattedLine(Attribute.ul);
        break;
      case MarkdownToolAdd.numberList:
        ref.focusedController?.addFormattedLine(Attribute.ol);
        break;
      case MarkdownToolAdd.toggleList:
        ref.focusedController?.addFormattedLine(Attribute.checked);
        break;
      case MarkdownToolAdd.code:
        ref.focusedController?.addFormattedLine(Attribute.codeBlock);
        break;
      case MarkdownToolAdd.quote:
        ref.focusedController?.addFormattedLine(Attribute.blockQuote);
        break;
    }
  }
}
