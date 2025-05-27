part of '/masamune_markdown.dart';

/// An enumeration type for changing Markdown block styles.
///
/// マークダウンのブロックスタイルを変更するための列挙型。
enum MarkdownToolExchange {
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
      case MarkdownToolExchange.text:
        return adapter?.toolsConfig.textLabel.title.value(locale) ?? "";
      case MarkdownToolExchange.h1:
        return adapter?.toolsConfig.h1Label.title.value(locale) ?? "";
      case MarkdownToolExchange.h2:
        return adapter?.toolsConfig.h2Label.title.value(locale) ?? "";
      case MarkdownToolExchange.h3:
        return adapter?.toolsConfig.h3Label.title.value(locale) ?? "";
      case MarkdownToolExchange.bulletedList:
        return adapter?.toolsConfig.bulletedListLabel.title.value(locale) ?? "";
      case MarkdownToolExchange.numberList:
        return adapter?.toolsConfig.numberListLabel.title.value(locale) ?? "";
      case MarkdownToolExchange.toggleList:
        return adapter?.toolsConfig.toggleListLabel.title.value(locale) ?? "";
      case MarkdownToolExchange.code:
        return adapter?.toolsConfig.codeLabel.title.value(locale) ?? "";
      case MarkdownToolExchange.quote:
        return adapter?.toolsConfig.quoteLabel.title.value(locale) ?? "";
    }
  }

  /// Get the icon for the tool.
  ///
  /// ツールのアイコンを取得します。
  IconData icon(BuildContext context) {
    final adapter = MasamuneAdapterScope.of<MarkdownMasamuneAdapter>(context);
    switch (this) {
      case MarkdownToolExchange.text:
        return adapter?.toolsConfig.textLabel.icon ?? Icons.title;
      case MarkdownToolExchange.h1:
        return adapter?.toolsConfig.h1Label.icon ?? FontAwesomeIcons.heading;
      case MarkdownToolExchange.h2:
        return adapter?.toolsConfig.h2Label.icon ?? FontAwesomeIcons.heading;
      case MarkdownToolExchange.h3:
        return adapter?.toolsConfig.h3Label.icon ?? FontAwesomeIcons.heading;
      case MarkdownToolExchange.bulletedList:
        return adapter?.toolsConfig.bulletedListLabel.icon ??
            FontAwesomeIcons.listUl;
      case MarkdownToolExchange.numberList:
        return adapter?.toolsConfig.numberListLabel.icon ??
            FontAwesomeIcons.listOl;
      case MarkdownToolExchange.toggleList:
        return adapter?.toolsConfig.toggleListLabel.icon ??
            FontAwesomeIcons.listCheck;
      case MarkdownToolExchange.code:
        return adapter?.toolsConfig.codeLabel.icon ?? FontAwesomeIcons.code;
      case MarkdownToolExchange.quote:
        return adapter?.toolsConfig.quoteLabel.icon ??
            FontAwesomeIcons.quoteLeft;
    }
  }

  /// Execute the tool.
  ///
  /// ツールを実行します。
  Future<void> onTap(BuildContext context, MarkdownToolRef ref) async {
    switch (this) {
      case MarkdownToolExchange.text:
        ref.focusedController?.removeFormat();
        break;
      case MarkdownToolExchange.h1:
        ref.focusedController?.formatLine(Attribute.h1);
        break;
      case MarkdownToolExchange.h2:
        ref.focusedController?.formatLine(Attribute.h2);
        break;
      case MarkdownToolExchange.h3:
        ref.focusedController?.formatLine(Attribute.h3);
        break;
      case MarkdownToolExchange.bulletedList:
        ref.focusedController?.formatLine(Attribute.ul);
        break;
      case MarkdownToolExchange.numberList:
        ref.focusedController?.formatLine(Attribute.ol);
        break;
      case MarkdownToolExchange.toggleList:
        ref.focusedController?.formatLine(Attribute.unchecked);
        break;
      case MarkdownToolExchange.code:
        ref.focusedController?.formatLine(Attribute.codeBlock);
        break;
      case MarkdownToolExchange.quote:
        ref.focusedController?.formatLine(Attribute.blockQuote);
        break;
    }
  }
}
