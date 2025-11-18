part of "/masamune_markdown.dart";

const _kLinkMarkdownInlineToolsType = "__markdown_inline_link__";

/// Display the menu to link text [MarkdownTools].
///
/// テキストをリンクにするメニューを表示する[MarkdownTools]。
@immutable
class LinkMarkdownInlineTools
    extends MarkdownPropertyInlineTools<LinkMarkdownSpanProperty> {
  /// Display the menu to link text [MarkdownTools].
  ///
  /// テキストをリンクにするメニューを表示する[MarkdownTools]。
  const LinkMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "テキストのリンク",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Text Link",
        ),
      ]),
      icon: Icons.link,
    ),
  });

  @override
  String get id => _kLinkMarkdownInlineToolsType;

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
  LinkMarkdownSpanProperty? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownProperty.typeKey, nullOfString);
    if (type != id) {
      return null;
    }
    return LinkMarkdownSpanProperty.fromJson(json);
  }

  @override
  LinkMarkdownSpanProperty? convertFromMarkdown(String markdown) {
    return null;
  }

  @override
  DynamicMap? convertToJson(LinkMarkdownSpanProperty value) {
    if (value.type != id) {
      return null;
    }
    return value.toJson();
  }

  @override
  String? convertToMarkdown(LinkMarkdownSpanProperty value) {
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
      if (value != null) LinkMarkdownSpanProperty(link: value.toString()),
    ];
  }

  @override
  List<MarkdownProperty> removeProperty(List<MarkdownProperty> properties) {
    return properties.where((e) => e.type != id).toList();
  }
}

/// A class for storing link text markdown span property.
///
/// テキストをリンクにするマークダウンのスパンのプロパティを格納するクラス。
@immutable
class LinkMarkdownSpanProperty extends MarkdownProperty {
  /// A class for storing link text markdown span property.
  ///
  /// テキストをリンクにするマークダウンのスパンのプロパティを格納するクラス。
  const LinkMarkdownSpanProperty({
    required this.link,
  });

  /// Create a [LinkMarkdownSpanProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[LinkMarkdownSpanProperty]を作成します。
  factory LinkMarkdownSpanProperty.fromJson(DynamicMap json) {
    return LinkMarkdownSpanProperty(
      link: json.get(MarkdownProperty.linkKey, ""),
    );
  }

  /// The link of the link text markdown span property.
  ///
  /// テキストをリンクにするマークダウンのスパンのプロパティのリンク。
  final String link;

  @override
  LinkMarkdownSpanProperty copyWith({
    String? link,
  }) {
    return LinkMarkdownSpanProperty(
      link: link ?? this.link,
    );
  }

  @override
  String get type => _kLinkMarkdownInlineToolsType;

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
    return other is LinkMarkdownSpanProperty &&
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
