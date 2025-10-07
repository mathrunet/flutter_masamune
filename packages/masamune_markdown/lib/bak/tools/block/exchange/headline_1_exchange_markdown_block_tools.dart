// part of "/masamune_markdown.dart";

// /// Display the menu to exchange headline 1 blocks [MarkdownTools].
// ///
// /// 見出し1ブロックを変更するメニューを表示する[MarkdownTools]。
// @immutable
// class Headline1ExchangeMarkdownBlockTools extends MarkdownBlockTools {
//   /// Display the menu to exchange headline 1 blocks [MarkdownTools].
//   ///
//   /// 見出し1ブロックを変更するメニューを表示する[MarkdownTools]。
//   const Headline1ExchangeMarkdownBlockTools({
//     super.config = const MarkdownToolLabelConfig(
//       title: LocalizedValue<String>([
//         LocalizedLocaleValue<String>(
//           Locale("ja", "JP"),
//           "見出し1",
//         ),
//         LocalizedLocaleValue<String>(
//           Locale("en", "US"),
//           "Heading 1",
//         ),
//       ]),
//       icon: FontAwesomeIcons.heading,
//     ),
//   });

//   @override
//   String get id => "__markdown_block_exchange_headline_1__";

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
//     ref.focusedController?.formatLine(Attribute.h1);
//     ref.deleteMode();
//   }
// }
