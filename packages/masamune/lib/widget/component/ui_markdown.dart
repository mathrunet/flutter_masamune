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
    this.linkTextStyle,
  });

  final String text;
  final bool selectable;
  final void Function(String url)? onTapLink;
  final double imageWidth;
  final MarkdownCheckboxBuilder? checkboxBuilder;
  final Color? color;
  final double? fontSize;
  final TextStyle? linkTextStyle;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
      child: MarkdownBody(
        data: text,
        styleSheet: MarkdownStyleSheet.fromTheme(
          Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.apply(
                  fontSizeDelta: fontSize == null
                      ? 0.0
                      : (fontSize! -
                          (Theme.of(context).textTheme.bodyText1?.fontSize ??
                              12)),
                  bodyColor: color,
                  displayColor: color,
                ),
          ),
        ).copyWith(
          a: linkTextStyle,
        ),
        selectable: selectable,
        imageBuilder: (uri, title, alt) {
          return Image(
            image: Asset.image(uri.toString()),
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
