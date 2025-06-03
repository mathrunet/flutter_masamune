part of "/masamune_markdown.dart";

/// An enumeration type for sub tools.
///
/// サブツールの列挙型。
enum MarkdownToolSub {
  /// Copy the text.
  ///
  /// テキストをコピーします。
  copy,

  /// Cut the text.
  ///
  /// テキストを切り取ります。
  cut,

  /// Paste the text.
  ///
  /// テキストを貼り付けます。
  paste,

  /// Close the keyboard.
  ///
  /// キーボードを閉じます。
  close;

  /// Check if the tool should be shown.
  ///
  /// ツールが表示されるかどうかを確認します。
  bool show(BuildContext context, MarkdownToolRef ref) {
    switch (this) {
      case MarkdownToolSub.copy:
      case MarkdownToolSub.cut:
        return ref.isTextSelected;
      case MarkdownToolSub.paste:
        return ref.isKeyboardShowing && ref.canPaste;
      case MarkdownToolSub.close:
        return ref.isKeyboardShowing;
    }
  }

  /// Get the label for the tool.
  ///
  /// ツールのラベルを取得します。
  String label(BuildContext context) {
    final adapter = MasamuneAdapterScope.of<MarkdownMasamuneAdapter>(context);
    final locale = context.locale;
    switch (this) {
      case MarkdownToolSub.copy:
        return adapter?.toolsConfig.copyLabel.title.value(locale) ?? "";
      case MarkdownToolSub.paste:
        return adapter?.toolsConfig.pasteLabel.title.value(locale) ?? "";
      case MarkdownToolSub.cut:
        return adapter?.toolsConfig.cutLabel.title.value(locale) ?? "";
      case MarkdownToolSub.close:
        return adapter?.toolsConfig.closeKeyboardLabel.title.value(locale) ??
            "";
    }
  }

  /// Get the icon for the tool.
  ///
  /// ツールのアイコンを取得します。
  IconData icon(BuildContext context) {
    final adapter = MasamuneAdapterScope.of<MarkdownMasamuneAdapter>(context);
    switch (this) {
      case MarkdownToolSub.copy:
        return adapter?.toolsConfig.copyLabel.icon ?? Icons.copy;
      case MarkdownToolSub.paste:
        return adapter?.toolsConfig.pasteLabel.icon ?? Icons.paste;
      case MarkdownToolSub.cut:
        return adapter?.toolsConfig.cutLabel.icon ?? Icons.cut;
      case MarkdownToolSub.close:
        return adapter?.toolsConfig.closeKeyboardLabel.icon ??
            Icons.keyboard_hide;
    }
  }

  /// Execute the tool.
  ///
  /// ツールを実行します。
  void onTap(BuildContext context, MarkdownToolRef ref) {
    switch (this) {
      case MarkdownToolSub.copy:
        ref.focusedController?.clipboardSelection(true);
        ref.focusedController?.unselect();
        break;
      case MarkdownToolSub.cut:
        ref.focusedController?.clipboardSelection(false);
        ref.focusedController?.unselect();
        break;
      case MarkdownToolSub.paste:
        ref.focusedController?.clipboardPaste();
        break;
      case MarkdownToolSub.close:
        ref.closeKeyboard();
        break;
    }
  }
}
