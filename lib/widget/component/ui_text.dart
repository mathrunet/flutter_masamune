part of masamune;

// /// Widget which extended [Text] for Path.
class UIText extends StatefulWidget {
  /// Widget which extended [Text] for Path
  const UIText(
    this.text, {
    Key? key,
    this.autoLocalize = true,
    this.shrinkUrl = false,
    this.enableHashTag = false,
    this.enableMention = false,
    this.linkStyle,
    this.highlightedLinkStyle,
    this.height,
    this.linkColor,
    this.highlightedColor,
    this.onTap,
    this.onLongPress,
    this.style,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.textScaleFactor,
    this.maxLines,
    this.textWidthBasis,
  }) : super(key: key);

  final String text;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final double? textScaleFactor;
  final double? fontSize;
  final int? maxLines;
  final Color? color;
  final FontWeight? fontWeight;
  final TextWidthBasis? textWidthBasis;
  final void Function(String value)? onTap;
  final void Function(String value)? onLongPress;
  final TextStyle? linkStyle;
  final TextStyle? highlightedLinkStyle;
  final Color? linkColor;
  final Color? highlightedColor;
  final bool shrinkUrl;
  final bool enableHashTag;
  final bool enableMention;
  final double? height;
  final bool autoLocalize;

  @override
  State<StatefulWidget> createState() => _UITextState();
}

class _UITextState extends State<UIText> {
  // late String _regexString;

  // @override
  // void initState() {
  //   super.initState();
  //   final regex = <String>[];
  //   if (widget.enableMention) {
  //     regex.add(r"@[\\w]+");
  //   }
  //   if (widget.enableHashTag) {
  //     regex.add(r"#[\\w]+");
  //   }
  //   regex.add(AutoLinkUtils.urlRegExpPattern);
  //   _regexString = regex.join("|");
  // }

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      widget.autoLocalize ? widget.text.localize() : widget.text,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      key: widget.key,
      style: widget.style?.copyWith(
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            color: widget.color,
            height: widget.height,
          ) ??
          TextStyle(
            color: widget.color,
            fontSize: widget.fontSize,
            fontWeight: widget.fontWeight,
            height: widget.height,
          ),
      // onTransformDisplayLink: widget.shrinkUrl ? AutoLinkUtils.shrinkUrl : null,
      // linkStyle: widget.linkStyle ??
      //     TextStyle(
      //       color: widget.linkColor ?? Colors.blueAccent,
      //     ),
      // highlightedLinkStyle: widget.highlightedLinkStyle ??
      //     TextStyle(
      //       color: widget.linkColor ?? Colors.blueAccent,
      //       backgroundColor:
      //           widget.highlightedColor ?? Colors.blueAccent.withAlpha(0x33),
      //     ),
      // linkRegExpPattern: _regexString,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      // textDirection: widget.textDirection,
      textScaleFactor: widget.textScaleFactor,
      maxLines: widget.maxLines,
      textWidthBasis: widget.textWidthBasis,
      // onTap: widget.onTap ??
      //     (url) {
      //       if (url.startsWith("http")) {
      //         openURL(url);
      //       } else {
      //         context.navigator.pushNamed(url);
      //       }
      //     },
      // onLongPress: widget.onLongPress ?? (url) => Share.share(url),
    );
  }
}
