part of '/masamune_markdown.dart';

/// An enumeration type for main Markdown tools.
///
/// マークダウンのメインツールの列挙型。
enum MarkdownToolMain {
  /// Add block tool.
  ///
  /// ブロック追加のツール。
  add,

  /// Font change tool.
  ///
  /// フォント変更のツール。
  font,

  /// Mention tool.
  ///
  /// メンションのツール。
  mention,

  /// Media tool.
  ///
  /// メディアのツール。
  media,

  /// Exchange tool.
  ///
  /// スタイル変更のツール。
  exchange,

  /// Undo tool.
  ///
  /// 元に戻すのツール。
  undo,

  /// Redo tool.
  ///
  /// やり直しのツール。
  redo,

  /// Indent up tool.
  ///
  /// インデントを増やすのツール。
  indentUp,

  /// Indent down tool.
  ///
  /// インデントを減らすのツール。
  indentDown;

  /// Get the label for the tool.
  ///
  /// ツールのラベルを取得します。
  String label(BuildContext context) {
    final adapter = MasamuneAdapterScope.of<MarkdownMasamuneAdapter>(context);
    final locale = context.locale;
    switch (this) {
      case MarkdownToolMain.add:
        return adapter?.toolsConfig.addLabel.title.value(locale) ?? "";
      case MarkdownToolMain.font:
        return adapter?.toolsConfig.fontLabel.title.value(locale) ?? "";
      case MarkdownToolMain.mention:
        return adapter?.toolsConfig.mentionLabel.title.value(locale) ?? "";
      case MarkdownToolMain.media:
        return adapter?.toolsConfig.mediaLabel.title.value(locale) ?? "";
      case MarkdownToolMain.exchange:
        return adapter?.toolsConfig.exchangeLabel.title.value(locale) ?? "";
      case MarkdownToolMain.undo:
        return adapter?.toolsConfig.undoLabel.title.value(locale) ?? "";
      case MarkdownToolMain.redo:
        return adapter?.toolsConfig.redoLabel.title.value(locale) ?? "";
      case MarkdownToolMain.indentUp:
        return adapter?.toolsConfig.indentUpLabel.title.value(locale) ?? "";
      case MarkdownToolMain.indentDown:
        return adapter?.toolsConfig.indentDownLabel.title.value(locale) ?? "";
    }
  }

  /// Get the icon for the tool.
  ///
  /// ツールのアイコンを取得します。
  IconData icon(BuildContext context) {
    final adapter = MasamuneAdapterScope.of<MarkdownMasamuneAdapter>(context);
    switch (this) {
      case MarkdownToolMain.add:
        return adapter?.toolsConfig.addLabel.icon ?? Icons.add;
      case MarkdownToolMain.font:
        return adapter?.toolsConfig.fontLabel.icon ?? FontAwesomeIcons.font;
      case MarkdownToolMain.mention:
        return adapter?.toolsConfig.mentionLabel.icon ?? FontAwesomeIcons.at;
      case MarkdownToolMain.media:
        return adapter?.toolsConfig.mediaLabel.icon ?? Icons.image;
      case MarkdownToolMain.exchange:
        return adapter?.toolsConfig.exchangeLabel.icon ?? Icons.repeat;
      case MarkdownToolMain.undo:
        return adapter?.toolsConfig.undoLabel.icon ?? Icons.undo;
      case MarkdownToolMain.redo:
        return adapter?.toolsConfig.redoLabel.icon ?? Icons.redo;
      case MarkdownToolMain.indentUp:
        return adapter?.toolsConfig.indentUpLabel.icon ??
            Icons.format_indent_increase;
      case MarkdownToolMain.indentDown:
        return adapter?.toolsConfig.indentDownLabel.icon ??
            Icons.format_indent_decrease;
    }
  }

  /// Check if the keyboard should be hidden when the tool is selected.
  ///
  /// ツールが選択されたときにキーボードを非表示にするかどうかを確認します。
  bool get hideKeyboardOnSelected {
    switch (this) {
      case MarkdownToolMain.add:
      case MarkdownToolMain.mention:
      case MarkdownToolMain.media:
      case MarkdownToolMain.exchange:
        return true;
      case MarkdownToolMain.font:
      case MarkdownToolMain.undo:
      case MarkdownToolMain.redo:
      case MarkdownToolMain.indentUp:
      case MarkdownToolMain.indentDown:
        return false;
    }
  }

  /// Check if the tool is enabled.
  ///
  /// ツールが有効かどうかを確認します。
  bool enabled(BuildContext context, MarkdownToolRef ref) {
    if (this == MarkdownToolMain.font) {
      if (ref.focuedState?.selectInMentionLink ?? false) {
        return false;
      }
    }
    return ref.focusedSelection != null;
  }

  /// Check if the tool is active.
  ///
  /// ツールがアクティブかどうかを確認します。
  bool active(BuildContext context, MarkdownToolRef ref) {
    switch (this) {
      case MarkdownToolMain.add:
      case MarkdownToolMain.mention:
      case MarkdownToolMain.media:
      case MarkdownToolMain.exchange:
      case MarkdownToolMain.font:
        return true;
      case MarkdownToolMain.undo:
        return ref.focusedController?.document.hasUndo ?? false;
      case MarkdownToolMain.redo:
        return ref.focusedController?.document.hasRedo ?? false;
      case MarkdownToolMain.indentUp:
        return ref.focusedController?.canIncreaseIndent() ?? false;
      case MarkdownToolMain.indentDown:
        return ref.focusedController?.canDecreaseIndent() ?? false;
    }
  }

  /// Execute the tool.
  ///
  /// ツールを実行します。
  void onTap(BuildContext context, MarkdownToolRef ref) {
    switch (this) {
      case MarkdownToolMain.add:
      case MarkdownToolMain.mention:
      case MarkdownToolMain.media:
      case MarkdownToolMain.exchange:
      case MarkdownToolMain.font:
        ref.toggleMode(this);
        break;
      case MarkdownToolMain.undo:
        ref.focusedController?.undo();
        break;
      case MarkdownToolMain.redo:
        ref.focusedController?.redo();
        break;
      case MarkdownToolMain.indentUp:
        ref.focusedController?.indentSelection(true);
        break;
      case MarkdownToolMain.indentDown:
        ref.focusedController?.indentSelection(false);
        break;
    }
  }
}
