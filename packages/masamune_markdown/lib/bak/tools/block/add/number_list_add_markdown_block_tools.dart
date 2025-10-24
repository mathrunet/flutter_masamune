// part of "/masamune_markdown.dart";

// /// Display the menu to add numbered list blocks [MarkdownTools].
// ///
// /// 番号付きリストブロックを追加するメニューを表示する[MarkdownTools]。
// @immutable
// class NumberListAddMarkdownBlockTools extends MarkdownBlockTools {
//   /// Display the menu to add numbered list blocks [MarkdownTools].
//   ///
//   /// 番号付きリストブロックを追加するメニューを表示する[MarkdownTools]。
//   const NumberListAddMarkdownBlockTools({
//     super.config = const MarkdownToolLabelConfig(
//       title: LocalizedValue<String>([
//         LocalizedLocaleValue<String>(
//           Locale("ja", "JP"),
//           "番号付きリスト",
//         ),
//         LocalizedLocaleValue<String>(
//           Locale("en", "US"),
//           "Numbered List",
//         ),
//       ]),
//       icon: FontAwesomeIcons.listOl,
//     ),
//   });

//   @override
//   String get id => "__markdown_block_add_number_list__";

//   @override
//   bool shown(BuildContext context, MarkdownToolRef ref) => true;

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
//     ref.focusedController?.addFormattedLine(Attribute.ol);
//     ref.deleteMode();
//   }
// }
