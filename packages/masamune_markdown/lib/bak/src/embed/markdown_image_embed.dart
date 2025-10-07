// part of "/masamune_markdown.dart";

// /// A builder for image embed.
// ///
// /// 画像埋め込みのビルダー。
// @immutable
// class MarkdownImageEmbed extends EmbedBuilder {
//   /// A builder for image embed.
//   ///
//   /// 画像埋め込みのビルダー。
//   const MarkdownImageEmbed({
//     this.limit = 256,
//   });

//   /// The limit of the image embed.
//   ///
//   /// 画像埋め込みのサイズ制限。
//   final double limit;

//   @override
//   String get key => BlockEmbed.imageType;

//   @override
//   bool get expanded => false;

//   @override
//   String toPlainText(Embed node) {
//     return node.value.data?.toString() ?? "";
//   }

//   @override
//   Widget build(
//     BuildContext context,
//     EmbedContext embedContext,
//   ) {
//     final imageSource = embedContext.node.value.data?.toString() ?? "";

//     if (imageSource.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     return Image(
//       image: Asset.image(imageSource),
//       width: limit,
//       height: limit,
//       fit: BoxFit.contain,
//       alignment: Alignment.centerLeft,
//     );
//   }
// }
