part of "/masamune_markdown.dart";

const _kBoldFontMarkdownInlineToolsType = "__markdown_inline_font_bold__";

/// Display the menu to bold font [MarkdownTools].
///
/// フォントを太字にするメニューを表示する[MarkdownTools]。
@immutable
class BoldFontMarkdownInlineTools
    extends MarkdownPropertyInlineTools<BoldFontMarkdownSpanProperty> {
  /// Display the menu to bold font [MarkdownTools].
  ///
  /// フォントを太字にするメニューを表示する[MarkdownTools]。
  const BoldFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの太字",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Bold",
        ),
      ]),
      icon: Icons.format_bold,
    ),
  });

  @override
  String get id => _kBoldFontMarkdownInlineToolsType;

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
  BoldFontMarkdownSpanProperty? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownProperty.typeKey, nullOfString);
    if (type != id) {
      return null;
    }
    return BoldFontMarkdownSpanProperty.fromJson(json);
  }

  @override
  BoldFontMarkdownSpanProperty? convertFromMarkdown(String markdown) {
    return null;
  }

  @override
  DynamicMap? convertToJson(BoldFontMarkdownSpanProperty value) {
    if (value.type != id) {
      return null;
    }
    return {
      MarkdownProperty.typeKey: id,
    };
  }

  @override
  String? convertToMarkdown(BoldFontMarkdownSpanProperty value) {
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
      const BoldFontMarkdownSpanProperty(),
    ];
  }

  @override
  List<MarkdownProperty> removeProperty(List<MarkdownProperty> properties) {
    return properties.where((e) => e.type != id).toList();
  }
}

/// A class for storing bold font markdown span property.
///
/// フォントを太字にするマークダウンのスパンのプロパティを格納するクラス。
@immutable
class BoldFontMarkdownSpanProperty extends MarkdownProperty {
  /// A class for storing bold font markdown span property.
  ///
  /// フォントを太字にするマークダウンのスパンのプロパティを格納するクラス。
  const BoldFontMarkdownSpanProperty();

  /// Create a [BoldFontMarkdownSpanProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[BoldFontMarkdownSpanProperty]を作成します。
  factory BoldFontMarkdownSpanProperty.fromJson(DynamicMap json) {
    return const BoldFontMarkdownSpanProperty();
  }

  @override
  BoldFontMarkdownSpanProperty copyWith() {
    return const BoldFontMarkdownSpanProperty();
  }

  @override
  String get type => _kBoldFontMarkdownInlineToolsType;

  @override
  Color? backgroundColor(RenderContext context, MarkdownController controller,
      Color? baseBackgroundColor) {
    return baseBackgroundColor;
  }

  @override
  TextStyle? textStyle(RenderContext context, MarkdownController controller,
      TextStyle? baseTextStyle) {
    baseTextStyle ??= const TextStyle();
    return baseTextStyle.copyWith(fontWeight: FontWeight.bold);
  }
}
