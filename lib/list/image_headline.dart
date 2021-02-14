part of masamune.list;

// /// Headline with an image in the background.
// class ImageHeadline extends StatelessWidget {
//   /// Headline with an image in the background.
//   const ImageHeadline({
//     this.height = 50,
//     this.dividerColor,
//     required this.image,
//     required this.label,
//     this.outlineWidth = 2,
//     this.fontSize = 18,
//     this.outlineColor,
//     this.labelColor,
//     this.padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//     this.fontWeight = FontWeight.bold,
//   });

//   /// Height.
//   final double height;

//   /// Image border color.
//   final Color? dividerColor;

//   /// Image.
//   final ImageProvider image;

//   /// Headline label.
//   final String label;

//   /// Label color.
//   final Color? labelColor;

//   /// Label outline color.
//   final Color? outlineColor;

//   /// The size of the label outline.
//   final double outlineWidth;

//   /// Font size.
//   final double fontSize;

//   /// Font weight.
//   final FontWeight fontWeight;

//   /// Padding.
//   final EdgeInsetsGeometry padding;

//   /// Build widget.
//   ///
//   /// [context]: Build context.
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       decoration: BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: dividerColor ?? context.theme.dividerColor,
//             width: 1,
//           ),
//           bottom: BorderSide(
//             color: dividerColor ?? context.theme.dividerColor,
//             width: 1,
//           ),
//         ),
//         image: DecorationImage(
//           image: image,
//           fit: BoxFit.cover,
//         ),
//       ),
//       alignment: Alignment.bottomLeft,
//       padding: padding,
//       child: BorderedText(
//         strokeWidth: outlineWidth,
//         strokeColor: outlineColor ?? context.theme.colorScheme.onBackground,
//         child: Text(
//           label,
//           style: TextStyle(
//             color: labelColor ?? context.theme.colorScheme.background,
//             fontSize: fontSize,
//             fontWeight: fontWeight,
//           ),
//         ),
//       ),
//     );
//   }
// }
