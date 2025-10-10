part of "/masamune_markdown.dart";

const _kCodeFontMarkdownInlineToolsType = "__markdown_inline_font_code__";

/// Display the menu to code font [MarkdownTools].
///
/// フォントをコードにするメニューを表示する[MarkdownTools]。
@immutable
class CodeFontMarkdownInlineTools
    extends MarkdownPropertyInlineTools<CodeFontMarkdownSpanProperty> {
  /// Display the menu to code font [MarkdownTools].
  ///
  /// フォントをコードにするメニューを表示する[MarkdownTools]。
  const CodeFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントのインラインコード",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Inline Code",
        ),
      ]),
      icon: Icons.code,
    ),
  });

  @override
  String get id => _kCodeFontMarkdownInlineToolsType;

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
  CodeFontMarkdownSpanProperty? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownProperty.typeKey, nullOfString);
    if (type != id) {
      return null;
    }
    return CodeFontMarkdownSpanProperty.fromJson(json);
  }

  @override
  CodeFontMarkdownSpanProperty? convertFromMarkdown(String markdown) {
    // TODO: implement convertFromMarkdown
    throw UnimplementedError();
  }

  @override
  DynamicMap? convertToJson(CodeFontMarkdownSpanProperty value) {
    if (value.type != id) {
      return null;
    }
    return {
      MarkdownProperty.typeKey: id,
    };
  }

  @override
  String? convertToMarkdown(CodeFontMarkdownSpanProperty value) {
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
      const CodeFontMarkdownSpanProperty(),
    ];
  }

  @override
  List<MarkdownProperty> removeProperty(List<MarkdownProperty> properties) {
    return properties.where((e) => e.type != id).toList();
  }
}

/// A class for storing code font markdown span property.
///
/// フォントをコードにするマークダウンのスパンのプロパティを格納するクラス。
@immutable
class CodeFontMarkdownSpanProperty extends MarkdownProperty {
  /// A class for storing code font markdown span property.
  ///
  /// フォントをコードにするマークダウンのスパンのプロパティを格納するクラス。
  const CodeFontMarkdownSpanProperty();

  /// Create a [CodeFontMarkdownSpanProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[CodeFontMarkdownSpanProperty]を作成します。
  factory CodeFontMarkdownSpanProperty.fromJson(DynamicMap json) {
    return const CodeFontMarkdownSpanProperty();
  }

  @override
  CodeFontMarkdownSpanProperty copyWith() {
    return const CodeFontMarkdownSpanProperty();
  }

  @override
  String get type => _kCodeFontMarkdownInlineToolsType;

  @override
  Color? backgroundColor(RenderContext context, MarkdownController controller,
      Color? baseBackgroundColor) {
    return null;
  }

  @override
  TextStyle? textStyle(RenderContext context, MarkdownController controller,
      TextStyle? baseTextStyle) {
    baseTextStyle ??= const TextStyle();
    final theme = context.theme;
    return baseTextStyle.copyWith(
      color: theme.colorTheme?.primary ?? theme.colorScheme.primary,
    );
  }

  @override
  BoxDecoration? backgroundDecoration(RenderContext context,
      MarkdownController controller, BoxDecoration? baseDecoration) {
    final theme = context.theme;
    final textStyle = controller.style.paragraph.textStyle ??
        const TextStyle(fontSize: 16.0);
    final fontSize = textStyle.fontSize ?? 16.0;
    final borderRadius = fontSize / 8.0;
    return BoxDecoration(
      color: theme.colorTheme?.surface ?? theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}
