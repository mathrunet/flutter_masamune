part of masamune.component.mobile;

/// Widget which extended [Text] for Path.
class UIText extends StatefulWidget {
  /// Widget which extended [Text] for Path.
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
    this.minLines,
    this.textWidthBasis,
  }) : super(key: key);

  /// Text to be auto link
  final String text;

  /// Called when the user taps on link.
  final OnOpenLinkFunction? onTap;

  /// Called when the user long-press on link.
  final OnOpenLinkFunction? onLongPress;

  /// Style of link text
  final TextStyle? linkStyle;

  /// Style of highlighted link text
  final TextStyle? highlightedLinkStyle;

  /// {@macro flutter.material.SelectableText.style}
  final TextStyle? style;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  final TextAlign? textAlign;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.textScaleFactor}
  final double? textScaleFactor;

  /// {@macro flutter.widgets.editableText.minLines}
  final int? minLines;

  /// {@macro flutter.widgets.editableText.maxLines}
  final int? maxLines;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// Font size of the text.
  final double? fontSize;

  /// Text color.
  final Color? color;

  /// The width of the text.
  final FontWeight? fontWeight;

  /// Link color.
  final Color? linkColor;

  /// The color of the highlighted text.
  final Color? highlightedColor;

  /// If you want to shorten the URL, use `true`.
  final bool shrinkUrl;

  /// `true` if you want to enable HashTag.
  final bool enableHashTag;

  /// If you want to enable mentions, use `true`.
  final bool enableMention;

  /// Text Height.
  final double? height;

  /// If you want to localize automatically, use `true`.
  final bool autoLocalize;

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// Subclasses should override this method to return a newly created
  /// instance of their associated [State] subclass:
  ///
  /// ```dart
  /// @override
  /// _MyState createState() => _MyState();
  /// ```
  ///
  /// The framework can call this method multiple times over the lifetime of
  /// a [StatefulWidget]. For example, if the widget is inserted into the tree
  /// in multiple locations, the framework will create a separate [State] object
  /// for each location. Similarly, if the widget is removed from the tree and
  /// later inserted into the tree again, the framework will call [createState]
  /// again to create a fresh [State] object, simplifying the lifecycle of
  /// [State] objects.
  @override
  State<StatefulWidget> createState() => _UITextState();
}

class _UITextState extends State<UIText> {
  late String _regexString;

  @override
  void initState() {
    super.initState();
    final regex = <String>[];
    if (widget.enableMention) {
      regex.add(r"@[\\w]+");
    }
    if (widget.enableHashTag) {
      regex.add(r"#[\\w]+");
    }
    regex.add(AutoLinkUtils.urlRegExpPattern);
    _regexString = regex.join("|");
  }

  @override
  Widget build(BuildContext context) {
    return SelectableAutoLinkText(
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
      onTransformDisplayLink: widget.shrinkUrl ? AutoLinkUtils.shrinkUrl : null,
      linkStyle: widget.linkStyle ??
          TextStyle(
            color: widget.linkColor ?? Colors.blueAccent,
          ),
      highlightedLinkStyle: widget.highlightedLinkStyle ??
          TextStyle(
            color: widget.linkColor ?? Colors.blueAccent,
            backgroundColor:
                widget.highlightedColor ?? Colors.blueAccent.withAlpha(0x33),
          ),
      linkRegExpPattern: _regexString,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      textScaleFactor: widget.textScaleFactor,
      maxLines: widget.maxLines,
      textWidthBasis: widget.textWidthBasis,
      onTap: widget.onTap ??
          (url) {
            if (url.startsWith("http")) {
              openURL(url);
            } else {
              context.navigator.pushNamed(url);
            }
          },
      onLongPress: widget.onLongPress ?? (url) => share(text: url),
    );
  }
}
