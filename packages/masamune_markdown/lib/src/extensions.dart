part of '/masamune_markdown.dart';

extension QuillControllerExtension on QuillController {
  void insertMention(MarkdownMention mention) {
    final lineStart = selection.start;
    final lineEnd = selection.end;
    final name = "@${mention.name.trim().trimString("@")}";
    replaceText(lineStart, lineEnd - lineStart, name, null);
    formatText(lineStart, name.length,
        LinkAttribute("@${mention.id.trim().trimString("@")}"));
  }

  void unselect() {
    updateSelection(
      TextSelection.collapsed(offset: selection.extentOffset),
      ChangeSource.local,
    );
  }

  void addFormattedLine(Attribute? attribute,
      {bool shouldNotifyListeners = true}) {
    final text = document.toPlainText();
    final lineEnd = text.indexOf("\n", selection.baseOffset);
    final beforeLineEnd = lineEnd > 0 ? text[lineEnd - 1] : "";
    if (beforeLineEnd == "\n") {
      if (attribute == null) {
        removeFormat();
      } else {
        formatText(lineEnd, 0, attribute);
      }
    } else {
      replaceText(
          lineEnd, 0, "\n", TextSelection.collapsed(offset: lineEnd + 1));
      if (attribute == null) {
        formatText(lineEnd + 1, 0, Attribute.h6);
        formatText(lineEnd + 1, 0, Attribute.clone(Attribute.h6, null));
      } else {
        formatText(lineEnd + 1, 0, attribute);
      }
    }
  }

  void formatLine(Attribute? attribute, {bool shouldNotifyListeners = true}) {
    final text = document.toPlainText();
    final lineStart = text.lastIndexOf("\n", selection.baseOffset - 1) + 1;
    final lineEnd = text.indexOf("\n", selection.baseOffset);
    formatText(lineStart, lineEnd - lineStart, attribute,
        shouldNotifyListeners: shouldNotifyListeners);
  }

  void removeFormatSelection(Attribute attribute,
      {bool shouldNotifyListeners = true}) {
    final text = document.toPlainText();
    final lineStart = text.lastIndexOf("\n", selection.baseOffset - 1) + 1;
    final lineEnd = text.indexOf("\n", selection.baseOffset);
    formatText(lineStart, lineEnd - lineStart, Attribute.clone(attribute, null),
        shouldNotifyListeners: shouldNotifyListeners);
  }

  void removeFormat({bool shouldNotifyListeners = true}) {
    final text = document.toPlainText();
    final lineStart = text.lastIndexOf("\n", selection.baseOffset - 1) + 1;
    final lineEnd = text.indexOf("\n", selection.baseOffset);
    formatText(lineStart, lineEnd - lineStart, Attribute.h6);
    formatText(
        lineStart, lineEnd - lineStart, Attribute.clone(Attribute.h6, null));
  }

  /// Check if the indent can be increased.
  ///
  /// インデントを増やせるかどうかをチェックします。
  bool canIncreaseIndent() {
    final style = getSelectionStyle();
    final currentIndent = style.attributes[Attribute.indent.key];
    if (currentIndent == null) {
      return true;
    }
    return currentIndent.value < 5;
  }

  /// Check if the indent can be decreased.
  ///
  /// インデントを減らせるかどうかをチェックします。
  bool canDecreaseIndent() {
    final style = getSelectionStyle();
    final currentIndent = style.attributes[Attribute.indent.key];
    if (currentIndent == null) {
      return false;
    }
    return currentIndent.value > 0;
  }
}
