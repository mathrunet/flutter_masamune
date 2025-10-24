part of "/masamune_markdown.dart";

const _kItalicFontMarkdownInlineToolsType = "__markdown_inline_font_italic__";

/// Display the menu to italic font [MarkdownTools].
///
/// フォントを斜体にするメニューを表示する[MarkdownTools]。
@immutable
class ItalicFontMarkdownInlineTools
    extends MarkdownPropertyInlineTools<ItalicFontMarkdownSpanProperty> {
  /// Display the menu to italic font [MarkdownTools].
  ///
  /// フォントを斜体にするメニューを表示する[MarkdownTools]。
  const ItalicFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの斜体",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Italic",
        ),
      ]),
      icon: Icons.format_italic,
    ),
  });

  @override
  String get id => _kItalicFontMarkdownInlineToolsType;

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) {
    return ref.controller.hasInlineProperty(this);
  }

  @override
  Widget icon(BuildContext context, MarkdownToolRef ref) {
    return Icon(config.icon);
  }

  @override
  Widget label(BuildContext context, MarkdownToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, MarkdownToolRef ref) {}

  @override
  Future<void> onActive(BuildContext context, MarkdownToolRef ref) async {
    ref.controller.addInlineProperty(this);
  }

  @override
  Future<void> onDeactive(BuildContext context, MarkdownToolRef ref) async {
    ref.controller.removeInlineProperty(this);
  }

  @override
  ItalicFontMarkdownSpanProperty? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownProperty.typeKey, nullOfString);
    if (type != id) {
      return null;
    }
    return ItalicFontMarkdownSpanProperty.fromJson(json);
  }

  @override
  ItalicFontMarkdownSpanProperty? convertFromMarkdown(String markdown) {
    // TODO: implement convertFromMarkdown
    throw UnimplementedError();
  }

  @override
  DynamicMap? convertToJson(ItalicFontMarkdownSpanProperty value) {
    if (value.type != id) {
      return null;
    }
    return {
      MarkdownProperty.typeKey: id,
    };
  }

  @override
  String? convertToMarkdown(ItalicFontMarkdownSpanProperty value) {
    // TODO: implement convertToMarkdown
    throw UnimplementedError();
  }

  @override
  List<MarkdownProperty> addProperty(List<MarkdownProperty> properties,
      {Object? value}) {
    if (properties.any((e) => e.type == id)) {
      return properties;
    }
    return [
      ...properties,
      const ItalicFontMarkdownSpanProperty(),
    ];
  }

  @override
  List<MarkdownProperty> removeProperty(List<MarkdownProperty> properties) {
    return properties.where((e) => e.type != id).toList();
  }
}

/// A class for storing italic font markdown span property.
///
/// フォントを斜体にするマークダウンのスパンのプロパティを格納するクラス。
@immutable
class ItalicFontMarkdownSpanProperty extends MarkdownProperty {
  /// A class for storing italic font markdown span property.
  ///
  /// フォントを斜体にするマークダウンのスパンのプロパティを格納するクラス。
  const ItalicFontMarkdownSpanProperty();

  /// Create a [ItalicFontMarkdownSpanProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[ItalicFontMarkdownSpanProperty]を作成します。
  factory ItalicFontMarkdownSpanProperty.fromJson(DynamicMap json) {
    return const ItalicFontMarkdownSpanProperty();
  }

  @override
  ItalicFontMarkdownSpanProperty copyWith() {
    return const ItalicFontMarkdownSpanProperty();
  }

  @override
  String get type => _kItalicFontMarkdownInlineToolsType;

  @override
  Color? backgroundColor(RenderContext context, MarkdownController controller,
      Color? baseBackgroundColor) {
    return baseBackgroundColor;
  }

  @override
  TextStyle? textStyle(RenderContext context, MarkdownController controller,
      TextStyle? baseTextStyle) {
    baseTextStyle ??= const TextStyle();
    return baseTextStyle.copyWith(fontStyle: FontStyle.italic);
  }
}
