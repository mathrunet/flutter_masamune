part of "/masamune_markdown.dart";

const _kLinkFontMarkdownInlineToolsType = "__markdown_inline_font_link__";

/// Display the menu to link font [MarkdownTools].
///
/// フォントをリンクにするメニューを表示する[MarkdownTools]。
@immutable
class LinkFontMarkdownInlineTools
    extends MarkdownPropertyInlineTools<LinkFontMarkdownSpanProperty> {
  /// Display the menu to link font [MarkdownTools].
  ///
  /// フォントをリンクにするメニューを表示する[MarkdownTools]。
  const LinkFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントのリンク",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Link",
        ),
      ]),
      icon: Icons.link,
    ),
  });

  @override
  String get id => "__markdown_inline_font_link__";

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
    ref.toggleLinkDialog();
  }

  @override
  Future<void> onDeactive(BuildContext context, MarkdownToolRef ref) async {
    ref.toggleLinkDialog();
  }

  @override
  LinkFontMarkdownSpanProperty? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownProperty.typeKey, nullOfString);
    if (type != id) {
      return null;
    }
    return LinkFontMarkdownSpanProperty.fromJson(json);
  }

  @override
  LinkFontMarkdownSpanProperty? convertFromMarkdown(String markdown) {
    // TODO: implement convertFromMarkdown
    throw UnimplementedError();
  }

  @override
  DynamicMap? convertToJson(LinkFontMarkdownSpanProperty value) {
    if (value.type != id) {
      return null;
    }
    return value.toJson();
  }

  @override
  String? convertToMarkdown(LinkFontMarkdownSpanProperty value) {
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
      if (value != null) LinkFontMarkdownSpanProperty(link: value.toString()),
    ];
  }

  @override
  List<MarkdownProperty> removeProperty(List<MarkdownProperty> properties) {
    return properties.where((e) => e.type != id).toList();
  }
}

/// A class for storing link font markdown span property.
///
/// フォントをリンクにするマークダウンのスパンのプロパティを格納するクラス。
@immutable
class LinkFontMarkdownSpanProperty extends MarkdownProperty {
  /// A class for storing link font markdown span property.
  ///
  /// フォントをリンクにするマークダウンのスパンのプロパティを格納するクラス。
  const LinkFontMarkdownSpanProperty({
    required this.link,
  });

  /// Create a [LinkFontMarkdownSpanProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[LinkFontMarkdownSpanProperty]を作成します。
  factory LinkFontMarkdownSpanProperty.fromJson(DynamicMap json) {
    return LinkFontMarkdownSpanProperty(
      link: json.get(MarkdownProperty.linkKey, ""),
    );
  }

  /// The link of the link font markdown span property.
  ///
  /// フォントをリンクにするマークダウンのスパンのプロパティのリンク。
  final String link;

  @override
  LinkFontMarkdownSpanProperty copyWith({
    String? link,
  }) {
    return LinkFontMarkdownSpanProperty(
      link: link ?? this.link,
    );
  }

  @override
  String get type => _kLinkFontMarkdownInlineToolsType;

  @override
  DynamicMap toJson() {
    return {
      ...super.toJson(),
      MarkdownProperty.linkKey: link,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is LinkFontMarkdownSpanProperty &&
        other.type == type &&
        other.link == link;
  }

  @override
  int get hashCode => type.hashCode ^ link.hashCode;

  @override
  String toString() {
    return "MarkdownSpanProperty(type: $type, link: $link)";
  }

  @override
  Color? backgroundColor(RenderContext context, MarkdownController controller,
      Color? baseBackgroundColor) {
    return baseBackgroundColor;
  }

  @override
  TextStyle? textStyle(RenderContext context, MarkdownController controller,
      TextStyle? baseTextStyle) {
    final theme = context.theme;
    baseTextStyle ??= const TextStyle();
    return baseTextStyle.copyWith(
      decoration: TextDecoration.underline,
      color: theme.colorScheme.primary,
      decorationColor: theme.colorScheme.primary,
    );
  }
}
