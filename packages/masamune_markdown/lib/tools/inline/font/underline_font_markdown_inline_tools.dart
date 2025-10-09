part of "/masamune_markdown.dart";

const _kUnderlineFontMarkdownInlineToolsType =
    "__markdown_inline_font_underline__";

/// Display the menu to underline font [MarkdownTools].
///
/// フォントを下線にするメニューを表示する[MarkdownTools]。
@immutable
class UnderlineFontMarkdownInlineTools
    extends MarkdownPropertyInlineTools<UnderlineFontMarkdownSpanProperty> {
  /// Display the menu to underline font [MarkdownTools].
  ///
  /// フォントを下線にするメニューを表示する[MarkdownTools]。
  const UnderlineFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの下線",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Underline",
        ),
      ]),
      icon: Icons.format_underline,
    ),
  });

  @override
  String get id => _kUnderlineFontMarkdownInlineToolsType;

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
  UnderlineFontMarkdownSpanProperty? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownProperty.typeKey, nullOfString);
    if (type != id) {
      return null;
    }
    return UnderlineFontMarkdownSpanProperty.fromJson(json);
  }

  @override
  UnderlineFontMarkdownSpanProperty? convertFromMarkdown(String markdown) {
    // TODO: implement convertFromMarkdown
    throw UnimplementedError();
  }

  @override
  DynamicMap? convertToJson(UnderlineFontMarkdownSpanProperty value) {
    if (value.type != id) {
      return null;
    }
    return {
      MarkdownProperty.typeKey: id,
    };
  }

  @override
  String? convertToMarkdown(UnderlineFontMarkdownSpanProperty value) {
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
      const UnderlineFontMarkdownSpanProperty(),
    ];
  }

  @override
  List<MarkdownProperty> removeProperty(List<MarkdownProperty> properties) {
    return properties.where((e) => e.type != id).toList();
  }
}

/// A class for storing underline font markdown span property.
///
/// フォントを下線にするマークダウンのスパンのプロパティを格納するクラス。
@immutable
class UnderlineFontMarkdownSpanProperty extends MarkdownProperty {
  /// A class for storing underline font markdown span property.
  ///
  /// フォントを下線にするマークダウンのスパンのプロパティを格納するクラス。
  const UnderlineFontMarkdownSpanProperty();

  /// Create a [UnderlineFontMarkdownSpanProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[UnderlineFontMarkdownSpanProperty]を作成します。
  factory UnderlineFontMarkdownSpanProperty.fromJson(DynamicMap json) {
    return const UnderlineFontMarkdownSpanProperty();
  }

  @override
  UnderlineFontMarkdownSpanProperty copyWith() {
    return const UnderlineFontMarkdownSpanProperty();
  }

  @override
  String get type => _kUnderlineFontMarkdownInlineToolsType;

  @override
  Color? backgroundColor(RenderContext context, MarkdownController controller,
      Color? baseBackgroundColor) {
    return baseBackgroundColor;
  }

  @override
  TextStyle? textStyle(RenderContext context, MarkdownController controller,
      TextStyle? baseTextStyle) {
    baseTextStyle ??= const TextStyle();
    return baseTextStyle.copyWith(decoration: TextDecoration.underline);
  }
}
