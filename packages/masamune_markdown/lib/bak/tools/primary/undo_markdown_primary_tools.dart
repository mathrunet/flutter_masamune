// part of "/masamune_markdown.dart";

// /// Display the menu to undo [MarkdownTools].
// ///
// /// 元に戻すメニューを表示する[MarkdownTools]。
// @immutable
// class UndoMarkdownPrimaryTools extends MarkdownPrimaryTools {
//   /// Display the menu to undo [MarkdownTools].
//   ///
//   /// 元に戻すメニューを表示する[MarkdownTools]。
//   const UndoMarkdownPrimaryTools({
//     super.config = const MarkdownToolLabelConfig(
//       title: LocalizedValue<String>([
//         LocalizedLocaleValue<String>(
//           Locale("ja", "JP"),
//           "元に戻す",
//         ),
//         LocalizedLocaleValue<String>(
//           Locale("en", "US"),
//           "Undo",
//         ),
//       ]),
//       icon: Icons.undo,
//     ),
//   });

//   @override
//   String get id => "__markdown_undo__";

//   @override
//   bool get hideKeyboardOnSelected => false;

//   @override
//   bool shown(BuildContext context, MarkdownToolRef ref) => true;

//   @override
//   bool enabled(BuildContext context, MarkdownToolRef ref) {
//     return ref.focusedSelection != null;
//   }

//   @override
//   bool actived(BuildContext context, MarkdownToolRef ref) {
//     return ref.focusedController?.document.hasUndo ?? false;
//   }

//   @override
//   Widget icon(BuildContext context, MarkdownToolRef ref) {
//     return Icon(config.icon);
//   }

//   @override
//   Widget label(BuildContext context, MarkdownToolRef ref) {
//     final locale = context.locale;
//     return Text(config.title.value(locale) ?? "");
//   }

//   @override
//   void onTap(BuildContext context, MarkdownToolRef ref) {
//     ref.focusedController?.undo();
//   }
// }
