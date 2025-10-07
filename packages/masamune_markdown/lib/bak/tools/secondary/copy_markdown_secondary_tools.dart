// part of "/masamune_markdown.dart";

// /// Display the menu to copy text [MarkdownTools].
// ///
// /// テキストをコピーするメニューを表示する[MarkdownTools]。
// @immutable
// class CopyMarkdownSecondaryTools extends MarkdownSecondaryTools {
//   /// Display the menu to copy text [MarkdownTools].
//   ///
//   /// テキストをコピーするメニューを表示する[MarkdownTools]。
//   const CopyMarkdownSecondaryTools({
//     super.config = const MarkdownToolLabelConfig(
//       title: LocalizedValue<String>([
//         LocalizedLocaleValue<String>(
//           Locale("ja", "JP"),
//           "コピー",
//         ),
//         LocalizedLocaleValue<String>(
//           Locale("en", "US"),
//           "Copy",
//         ),
//       ]),
//       icon: Icons.copy,
//     ),
//   });

//   @override
//   String get id => "__markdown_copy__";

//   @override
//   bool shown(BuildContext context, MarkdownToolRef ref) {
//     return ref.isTextSelected;
//   }

//   @override
//   bool enabled(BuildContext context, MarkdownToolRef ref) => true;

//   @override
//   bool actived(BuildContext context, MarkdownToolRef ref) => true;

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
//     ref.focusedController?.clipboardSelection(true);
//     ref.focusedController?.unselect();
//   }
// }
