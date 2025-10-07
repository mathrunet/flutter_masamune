// part of "/masamune_markdown.dart";

// /// Display the menu to exchange quote blocks [MarkdownTools].
// ///
// /// 引用ブロックを変更するメニューを表示する[MarkdownTools]。
// @immutable
// class QuoteExchangeMarkdownBlockTools extends MarkdownBlockTools {
//   /// Display the menu to exchange quote blocks [MarkdownTools].
//   ///
//   /// 引用ブロックを変更するメニューを表示する[MarkdownTools]。
//   const QuoteExchangeMarkdownBlockTools({
//     super.config = const MarkdownToolLabelConfig(
//       title: LocalizedValue<String>([
//         LocalizedLocaleValue<String>(
//           Locale("ja", "JP"),
//           "引用",
//         ),
//         LocalizedLocaleValue<String>(
//           Locale("en", "US"),
//           "Quote",
//         ),
//       ]),
//       icon: FontAwesomeIcons.quoteLeft,
//     ),
//   });

//   @override
//   String get id => "__markdown_block_exchange_quote__";

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
//     ref.focusedController?.formatLine(Attribute.blockQuote);
//     ref.deleteMode();
//   }
// }
