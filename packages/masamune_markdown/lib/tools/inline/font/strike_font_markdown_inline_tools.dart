part of "/masamune_markdown.dart";

const _kStrikeFontMarkdownInlineToolsType = "__markdown_inline_font_strike__";

/// Display the menu to strike font [MarkdownTools].
///
/// フォントを取り消し線にするメニューを表示する[MarkdownTools]。
@immutable
class StrikeFontMarkdownInlineTools
    extends MarkdownPropertyInlineTools<StrikeFontMarkdownSpanProperty> {
  /// Display the menu to strike font [MarkdownTools].
  ///
  /// フォントを取り消し線にするメニューを表示する[MarkdownTools]。
  const StrikeFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの取り消し線",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Strike",
        ),
      ]),
      icon: Icons.format_strikethrough,
    ),
  });

  @override
  String get id => _kStrikeFontMarkdownInlineToolsType;

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
  StrikeFontMarkdownSpanProperty? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownProperty.typeKey, nullOfString);
    if (type != id) {
      return null;
    }
    return StrikeFontMarkdownSpanProperty.fromJson(json);
  }

  @override
  StrikeFontMarkdownSpanProperty? convertFromMarkdown(String markdown) {
    // TODO: implement convertFromMarkdown
    throw UnimplementedError();
  }

  @override
  DynamicMap? convertToJson(StrikeFontMarkdownSpanProperty value) {
    if (value.type != id) {
      return null;
    }
    return {
      MarkdownProperty.typeKey: id,
    };
  }

  @override
  String? convertToMarkdown(StrikeFontMarkdownSpanProperty value) {
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
      const StrikeFontMarkdownSpanProperty(),
    ];
  }

  @override
  List<MarkdownProperty> removeProperty(List<MarkdownProperty> properties) {
    return properties.where((e) => e.type != id).toList();
  }
}

/// A class for storing strike font markdown span property.
///
/// フォントを取り消し線にするマークダウンのスパンのプロパティを格納するクラス。
@immutable
class StrikeFontMarkdownSpanProperty extends MarkdownProperty {
  /// A class for storing strike font markdown span property.
  ///
  /// フォントを取り消し線にするマークダウンのスパンのプロパティを格納するクラス。
  const StrikeFontMarkdownSpanProperty();

  /// Create a [StrikeFontMarkdownSpanProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[StrikeFontMarkdownSpanProperty]を作成します。
  factory StrikeFontMarkdownSpanProperty.fromJson(DynamicMap json) {
    return const StrikeFontMarkdownSpanProperty();
  }

  @override
  StrikeFontMarkdownSpanProperty copyWith() {
    return const StrikeFontMarkdownSpanProperty();
  }

  @override
  String get type => _kStrikeFontMarkdownInlineToolsType;

  @override
  Color? backgroundColor(RenderContext context, MarkdownController controller,
      Color? baseBackgroundColor) {
    return baseBackgroundColor;
  }

  @override
  TextStyle? textStyle(RenderContext context, MarkdownController controller,
      TextStyle? baseTextStyle) {
    baseTextStyle ??= const TextStyle();
    return baseTextStyle.copyWith(decoration: TextDecoration.lineThrough);
  }
}
