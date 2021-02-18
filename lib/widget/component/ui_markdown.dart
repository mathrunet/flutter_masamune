part of masamune;

/// Widgets that can use markdown notation.
///
/// See below for description.
/// [https://qiita.com/tbpgr/items/989c6badefff69377da7]
class UIMarkdown extends StatelessWidget {
  /// Widgets that can use markdown notation.
  ///
  /// See below for description.
  /// [https://qiita.com/tbpgr/items/989c6badefff69377da7]
  const UIMarkdown(
    this.text, {
    this.selectable = true,
    this.onTapLink,
    this.imageWidth = 200,
    this.checkboxBuilder,
    this.color,
    this.fontSize,
  });

  final String text;
  final bool selectable;
  final void Function(String url)? onTapLink;
  final double imageWidth;
  final MarkdownCheckboxBuilder? checkboxBuilder;
  final Color? color;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
      child: MarkdownBody(
        data: text,
        selectable: selectable,
        imageBuilder: (uri, title, alt) {
          return Image(
            image: NetworkOrAsset.image(uri.toString()),
            width: imageWidth,
          );
        },
        onTapLink: (text, href, title) {
          if (href == null) {
            return;
          }
          if (onTapLink != null) {
            onTapLink?.call(href);
          } else if (href.startsWith("http")) {
            openURL(href);
          } else {
            context.navigator.pushNamed(href);
          }
        },
        checkboxBuilder: checkboxBuilder,
        shrinkWrap: true,
        fitContent: true,
      ),
    );
  }
}
