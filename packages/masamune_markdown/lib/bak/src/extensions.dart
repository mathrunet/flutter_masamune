// part of "/masamune_markdown.dart";

// /// Extension methods for QuillController.
// ///
// /// QuillControllerの拡張メソッド。
// extension QuillControllerExtension on QuillController {
//   /// Insert a mention.
//   ///
//   /// メンションを挿入します。
//   void insertMention(MarkdownMention mention) {
//     final lineStart = selection.start;
//     final lineEnd = selection.end;
//     final name = "@${mention.name.trim().trimString("@")}";
//     replaceText(lineStart, lineEnd - lineStart, name, null);
//     formatText(lineStart, name.length,
//         LinkAttribute("@${mention.id.trim().trimString("@")}"));
//   }

//   /// Unselect the text.
//   ///
//   /// テキストを選択解除します。
//   void unselect() {
//     updateSelection(
//       TextSelection.collapsed(offset: selection.extentOffset),
//       ChangeSource.local,
//     );
//   }

//   /// Add a formatted line.
//   ///
//   /// フォーマットされた行を追加します。
//   void addFormattedLine(Attribute? attribute,
//       {bool shouldNotifyListeners = true}) {
//     final text = document.toPlainText();
//     final lineEnd = text.indexOf("\n", selection.baseOffset);
//     final beforeLineEnd = lineEnd > 0 ? text[lineEnd - 1] : "";
//     if (beforeLineEnd == "\n") {
//       if (attribute == null) {
//         removeFormat();
//       } else {
//         formatText(lineEnd, 0, attribute);
//       }
//     } else {
//       replaceText(
//           lineEnd, 0, "\n", TextSelection.collapsed(offset: lineEnd + 1));
//       if (attribute == null) {
//         formatText(lineEnd + 1, 0, Attribute.h6);
//         formatText(lineEnd + 1, 0, Attribute.clone(Attribute.h6, null));
//       } else {
//         formatText(lineEnd + 1, 0, attribute);
//       }
//     }
//   }

//   /// Format a line.
//   ///
//   /// 行をフォーマットします。
//   void formatLine(Attribute? attribute, {bool shouldNotifyListeners = true}) {
//     final text = document.toPlainText();
//     final lineStart = selection.baseOffset > 0
//         ? (text.lastIndexOf("\n", selection.baseOffset - 1) + 1)
//         : 0;
//     final lineEnd = text.indexOf("\n", selection.baseOffset);
//     formatText(lineStart, lineEnd - lineStart, attribute,
//         shouldNotifyListeners: shouldNotifyListeners);
//   }

//   /// Remove a format selection.
//   ///
//   /// フォーマット選択を削除します。
//   void removeFormatSelection(Attribute attribute,
//       {bool shouldNotifyListeners = true}) {
//     final text = document.toPlainText();
//     final lineStart = selection.baseOffset > 0
//         ? (text.lastIndexOf("\n", selection.baseOffset - 1) + 1)
//         : 0;
//     final lineEnd = text.indexOf("\n", selection.baseOffset);
//     formatText(lineStart, lineEnd - lineStart, Attribute.clone(attribute, null),
//         shouldNotifyListeners: shouldNotifyListeners);
//   }

//   /// Remove a format.
//   ///
//   /// フォーマットを削除します。
//   void removeFormat({bool shouldNotifyListeners = true}) {
//     final text = document.toPlainText();
//     final lineStart = selection.baseOffset > 0
//         ? (text.lastIndexOf("\n", selection.baseOffset - 1) + 1)
//         : 0;
//     final lineEnd = text.indexOf("\n", selection.baseOffset);
//     formatText(lineStart, lineEnd - lineStart, Attribute.h6);
//     formatText(
//         lineStart, lineEnd - lineStart, Attribute.clone(Attribute.h6, null));
//     formatText(
//         lineStart, lineEnd - lineStart, Attribute.clone(Attribute.list, null));
//     formatText(lineStart, lineEnd - lineStart,
//         Attribute.clone(Attribute.codeBlock, null));
//     formatText(lineStart, lineEnd - lineStart,
//         Attribute.clone(Attribute.blockQuote, null));
//   }

//   /// Check if the selection has any format.
//   ///
//   /// 選択範囲にフォーマットがあるかどうかをチェックします。
//   bool removeBlockOnBackspace() {
//     final text = document.toPlainText();
//     final lineStart = selection.baseOffset > 0
//         ? (text.lastIndexOf("\n", selection.baseOffset - 1) + 1)
//         : 0;
//     final lineEnd = text.indexOf("\n", selection.baseOffset);
//     if (lineStart != lineEnd) {
//       return false;
//     }
//     final style = document
//         .collectStyle(lineStart, lineEnd - lineStart)
//         .mergeAll(toggledStyle);
//     final attributes = style.attributes;
//     final hit = attributes.isNotEmpty &&
//         attributes.values.any((e) {
//           return e.key == Attribute.checked.key ||
//               e.key == Attribute.codeBlock.key ||
//               e.key == Attribute.blockQuote.key ||
//               e.key == Attribute.link.key ||
//               e.key == Attribute.list.key ||
//               e.key == Attribute.h1.key ||
//               e.key == Attribute.h2.key ||
//               e.key == Attribute.h3.key ||
//               e.key == Attribute.h4.key ||
//               e.key == Attribute.h5.key ||
//               e.key == Attribute.h6.key;
//         });
//     if (hit) {
//       removeFormat();
//       return true;
//     }
//     return false;
//   }

//   /// Select the link before the current cursor position if it exists.
//   ///
//   /// 現在のカーソル位置より前にリンクがある場合、そのリンク部分を選択します。
//   bool removeLinkOnBackspace() {
//     final currentOffset = selection.baseOffset;

//     if (currentOffset <= 0) {
//       return false;
//     }

//     // カーソル位置の直前の文字がリンクかどうかをチェック
//     final charBeforeCursor = document.collectStyle(currentOffset - 1, 1);
//     if (charBeforeCursor.attributes[Attribute.link.key] == null) {
//       return false;
//     }

//     // リンクの開始位置を見つける（逆方向に検索）
//     int linkStart = currentOffset - 1;
//     while (linkStart > 0) {
//       final charStyle = document.collectStyle(linkStart - 1, 1);
//       if (charStyle.attributes[Attribute.link.key] == null) {
//         break;
//       }
//       linkStart--;
//     }

//     // リンクの終了位置を見つける（順方向に検索）
//     final textLength = document.length;
//     var linkEnd = currentOffset;
//     while (linkEnd < textLength) {
//       final charStyle = document.collectStyle(linkEnd, 1);
//       if (charStyle.attributes[Attribute.link.key] == null) {
//         break;
//       }
//       linkEnd++;
//     }

//     // リンク範囲を選択
//     if (linkStart < linkEnd) {
//       updateSelection(
//         TextSelection(baseOffset: linkStart, extentOffset: linkEnd),
//         ChangeSource.local,
//       );
//       formatText(linkStart, linkEnd - linkStart,
//           Attribute.clone(Attribute.link, null));
//       return true;
//     }

//     return false;
//   }

//   /// Insert image.
//   ///
//   /// 画像を挿入します。
//   void insertImage(Uri uri) {
//     final path = uri.toString();
//     if (path.isEmpty) {
//       return;
//     }
//     final lineStart = selection.baseOffset;
//     final lineEnd = selection.extentOffset;
//     replaceText(lineStart, lineEnd - lineStart, BlockEmbed.image(path), null);
//   }

//   /// Insert video.
//   ///
//   /// ビデオを挿入します。
//   void insertVideo(Uri uri) {
//     final path = uri.toString();
//     if (path.isEmpty) {
//       return;
//     }
//     final lineStart = selection.baseOffset;
//     final lineEnd = selection.extentOffset;
//     replaceText(lineStart, lineEnd - lineStart, BlockEmbed.video(path), null);
//   }

//   /// Check if the indent can be increased.
//   ///
//   /// インデントを増やせるかどうかをチェックします。
//   bool canIncreaseIndent() {
//     final style = getSelectionStyle();
//     final currentIndent = style.attributes[Attribute.indent.key];
//     if (currentIndent == null) {
//       return true;
//     }
//     return currentIndent.value < 5;
//   }

//   /// Check if the indent can be decreased.
//   ///
//   /// インデントを減らせるかどうかをチェックします。
//   bool canDecreaseIndent() {
//     final style = getSelectionStyle();
//     final currentIndent = style.attributes[Attribute.indent.key];
//     if (currentIndent == null) {
//       return false;
//     }
//     return currentIndent.value > 0;
//   }
// }
