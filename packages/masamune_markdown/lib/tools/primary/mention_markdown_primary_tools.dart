part of "/masamune_markdown.dart";

const _kMentionMarkdownPrimaryToolsType = "__markdown_mention__";

/// Display the menu to mention [MarkdownTools].
///
/// メンションを表示するメニューを表示する[MarkdownTools]。
@immutable
class MentionMarkdownPrimaryTools
    extends MarkdownPropertyPrimaryTools<MentionMarkdownSpanProperty> {
  /// Display the menu to mention [MarkdownTools].
  ///
  /// メンションを表示するメニューを表示する[MarkdownTools]。
  const MentionMarkdownPrimaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "メンション",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Mention",
        ),
      ]),
      icon: FontAwesomeIcons.at,
    ),
  });

  @override
  String get id => _kMentionMarkdownPrimaryToolsType;

  @override
  bool get hideKeyboardOnSelected => true;

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) {
    return ref.mentionBuilder != null;
  }

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) {
    return ref.selection != null;
  }

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) => true;

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
  void onTap(BuildContext context, MarkdownToolRef ref) {
    ref.toggleMode(this);
  }

  @override
  MentionMarkdownSpanProperty? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownProperty.typeKey, nullOfString);
    if (type != id) {
      return null;
    }
    return MentionMarkdownSpanProperty.fromJson(json);
  }

  @override
  MentionMarkdownSpanProperty? convertFromMarkdown(String markdown) {
    return null;
  }

  @override
  DynamicMap? convertToJson(MentionMarkdownSpanProperty value) {
    if (value.type != id) {
      return null;
    }
    return value.toJson();
  }

  @override
  String? convertToMarkdown(MentionMarkdownSpanProperty value) {
    // TODO: implement convertToMarkdown
    throw UnimplementedError();
  }

  @override
  List<MarkdownProperty> addProperty(List<MarkdownProperty> properties,
      {Object? value}) {
    if (properties.any((e) => e.type == id)) {
      return properties;
    }
    if (value is! MarkdownMention) {
      return [
        ...properties,
      ];
    }
    return [
      ...properties,
      MentionMarkdownSpanProperty(mention: value),
    ];
  }

  @override
  List<MarkdownProperty> removeProperty(List<MarkdownProperty> properties) {
    return properties.where((e) => e.type != id).toList();
  }
}

/// A class for storing mention markdown span property.
///
/// メンションを表示するマークダウンのスパンのプロパティを格納するクラス。
@immutable
class MentionMarkdownSpanProperty extends MarkdownProperty {
  /// A class for storing mention markdown span property.
  ///
  /// メンションを表示するマークダウンのスパンのプロパティを格納するクラス。
  const MentionMarkdownSpanProperty({
    required this.mention,
  });

  /// Create a [MentionMarkdownSpanProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MentionMarkdownSpanProperty]を作成します。
  factory MentionMarkdownSpanProperty.fromJson(DynamicMap json) {
    final mention = json.getAsMap(MarkdownProperty.mentionKey);
    return MentionMarkdownSpanProperty(
      mention: MarkdownMention.fromJson(mention),
    );
  }

  /// The mention of the mention markdown span property.
  ///
  /// メンションを表示するマークダウンのスパンのプロパティのメンション。
  final MarkdownMention mention;

  @override
  MentionMarkdownSpanProperty copyWith({
    MarkdownMention? mention,
  }) {
    return MentionMarkdownSpanProperty(
      mention: mention ?? this.mention,
    );
  }

  @override
  String get type => _kMentionMarkdownPrimaryToolsType;

  @override
  DynamicMap toJson() {
    return {
      ...super.toJson(),
      MarkdownProperty.mentionKey: mention.toJson(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MentionMarkdownSpanProperty &&
        other.type == type &&
        other.mention == mention;
  }

  @override
  int get hashCode => type.hashCode ^ mention.hashCode;

  @override
  String toString() {
    return "MarkdownSpanProperty(type: $type, mention: $mention)";
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
