// part of "/masamune_markdown.dart";

// /// Display the menu to exchange bulleted list blocks [MarkdownTools].
// ///
// /// 箇条書きリストブロックを変更するメニューを表示する[MarkdownTools]。
// @immutable
// class BulletedListExchangeMarkdownBlockTools extends MarkdownBlockTools {
//   /// Display the menu to exchange bulleted list blocks [MarkdownTools].
//   ///
//   /// 箇条書きリストブロックを変更するメニューを表示する[MarkdownTools]。
//   const BulletedListExchangeMarkdownBlockTools({
//     super.config = const MarkdownToolLabelConfig(
//       title: LocalizedValue<String>([
//         LocalizedLocaleValue<String>(
//           Locale("ja", "JP"),
//           "箇条書きリスト",
//         ),
//         LocalizedLocaleValue<String>(
//           Locale("en", "US"),
//           "Bulleted List",
//         ),
//       ]),
//       icon: FontAwesomeIcons.listUl,
//     ),
//   });

//   @override
//   String get id => "__markdown_block_exchange_bulleted_list__";

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
//     ref.focusedController?.formatLine(Attribute.ul);
//     ref.deleteMode();
//   }
// }
