part of "/masamune_markdown.dart";

/// A class for storing markdown data.
///
/// マークダウンのデータを格納するクラス。
@immutable
abstract class MarkdownValue {
  /// A class for storing markdown data.
  ///
  /// マークダウンのデータを格納するクラス。
  const MarkdownValue({
    required this.id,
  });

  /// The id of the painting value.
  ///
  /// 描画用のデータのID。
  final String id;

  /// The type of the markdown value.
  ///
  /// マークダウンのデータの型。
  String get type;

  /// Convert the markdown value to a JSON object.
  ///
  /// マークダウンのデータをJSONオブジェクトに変換します。
  DynamicMap toJson();

  /// Convert the markdown value to a markdown string.
  ///
  /// マークダウンのデータをマークダウンの文字列に変換します。
  String toMarkdown();

  /// The key for the type.
  ///
  /// マークダウンのデータの型のキー。
  static const String typeKey = "type";

  /// The key for the id.
  ///
  /// マークダウンのデータのIDのキー。
  static const String idKey = "id";

  /// The key for the name.
  ///
  /// マークダウンのデータの名前のキー。
  static const String valueKey = "value";

  /// The key for the property.
  ///
  /// マークダウンのデータのプロパティのキー。
  static const String propertyKey = "property";

  /// The key for the path.
  ///
  /// マークダウンのデータのパスのキー。
  static const String pathKey = "path";

  /// The key for the children.
  ///
  /// マークダウンの子要素のキー。
  static const String childrenKey = "children";

  /// The key for the isExpanded.
  ///
  /// マークダウンの展開状態のキー。
  static const String expandedKey = "expanded";

  /// Copy the markdown value with the given fields.
  ///
  /// 指定されたフィールドでマークダウンの値をコピーします。
  MarkdownValue copyWith({
    String? id,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownValue && other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;

  @override
  String toString() {
    return "MarkdownValue(id: $id, type: $type)";
  }
}

/// A class for storing markdown span value.
///
/// マークダウンのスパンの値を格納するクラス。
@immutable
class MarkdownSpanValue extends MarkdownValue {
  /// A class for storing markdown span value.
  ///
  /// マークダウンのスパンの値を格納するクラス。
  const MarkdownSpanValue({
    required super.id,
    required this.value,
    required this.property,
    this.editable = true,
  });

  /// Create a [MarkdownSpanValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownSpanValue]を作成します。
  factory MarkdownSpanValue.fromJson(DynamicMap json) {
    return MarkdownSpanValue(
      id: json.get(MarkdownValue.idKey, ""),
      value: json.get(MarkdownValue.valueKey, ""),
      property: MarkdownSpanProperty.fromJson(
        json.getAsMap(MarkdownValue.propertyKey),
      ),
    );
  }

  /// Create a [MarkdownSpanValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownSpanValue]を作成します。
  factory MarkdownSpanValue.fromMarkdown(String markdown) {
    return MarkdownSpanValue(
      id: uuid(),
      value: markdown,
      property: const MarkdownSpanProperty(),
    );
  }

  @override
  String get type => "__text_span__";

  /// The editable of the markdown span value.
  ///
  /// マークダウンのスパンの編集可能なフラグ。
  final bool editable;

  /// The value of the markdown span value.
  ///
  /// マークダウンのスパンの値。
  final String value;

  /// The property of the markdown span value.
  ///
  /// マークダウンのスパンのプロパティ。
  final MarkdownSpanProperty property;

  @override
  MarkdownSpanValue copyWith({
    String? id,
    String? value,
    MarkdownSpanProperty? property,
  }) {
    return MarkdownSpanValue(
      id: id ?? this.id,
      value: value ?? this.value,
      property: property ?? this.property,
    );
  }

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.valueKey: value,
      MarkdownValue.propertyKey: property.toJson(),
    };
  }

  @override
  String toMarkdown() {
    return value;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownSpanValue &&
        other.id == id &&
        other.type == type &&
        other.value == value &&
        other.property == property;
  }

  @override
  int get hashCode => value.hashCode ^ property.hashCode;

  @override
  String toString() {
    return "MarkdownSpanValue(value: $value, property: $property)";
  }
}

/// A class for storing markdown paragraph value.
///
/// マークダウンの段落の値を格納するクラス。
@immutable
class MarkdownLineValue extends MarkdownValue {
  /// A class for storing markdown paragraph value.
  ///
  /// マークダウンの段落の値を格納するクラス。
  const MarkdownLineValue({
    required super.id,
    required this.children,
    required this.property,
  });

  /// Create a [MarkdownLineValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownLineValue]を作成します。
  factory MarkdownLineValue.fromJson(DynamicMap json) {
    return MarkdownLineValue(
      id: json.get(MarkdownValue.idKey, ""),
      children: json
          .getAsList(MarkdownValue.childrenKey, [])
          .map((e) => MarkdownSpanValue.fromJson(e))
          .toList(),
      property: MarkdownLineProperty.fromJson(
        json.getAsMap(MarkdownValue.propertyKey),
      ),
    );
  }

  /// Create a [MarkdownLineValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownLineValue]を作成します。
  factory MarkdownLineValue.fromMarkdown(String markdown) {
    final tools =
        MarkdownMasamuneAdapter.findTools<MarkdownVariableInlineTools>();
    final children = <MarkdownSpanValue>[];
    for (final tool in tools) {
      final value = tool.convertFromMarkdown(markdown);
      if (value != null) {
        children.add(value);
      }
    }
    return MarkdownLineValue(
      id: uuid(),
      children: children,
      property: const MarkdownLineProperty(),
    );
  }

  @override
  String get type => "__text_line__";

  /// The children of the markdown 1 line value.
  ///
  /// マークダウンの１行の子要素。
  final List<MarkdownSpanValue> children;

  /// The property of the markdown 1 line value.
  ///
  /// マークダウンの１行のプロパティ。
  final MarkdownLineProperty property;

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.childrenKey: children.map((e) => e.toJson()).toList(),
      MarkdownValue.propertyKey: property.toJson(),
    };
  }

  @override
  String toMarkdown() {
    return children.map((e) => e.toMarkdown()).join("\n");
  }

  @override
  MarkdownLineValue copyWith({
    String? id,
    List<MarkdownSpanValue>? children,
    MarkdownLineProperty? property,
  }) {
    return MarkdownLineValue(
      id: id ?? this.id,
      children: children ?? this.children,
      property: property ?? this.property,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownLineValue &&
        other.id == id &&
        other.type == type &&
        children.equalsTo(other.children) &&
        other.property == property;
  }

  @override
  int get hashCode => children.hashCode ^ property.hashCode;

  @override
  String toString() {
    return "MarkdownLineValue(children: $children, property: $property)";
  }
}

/// A class for storing markdown block value.
///
/// マークダウンのブロックの値を格納するクラス。
@immutable
abstract class MarkdownBlockValue extends MarkdownValue {
  /// A class for storing markdown block value.
  ///
  /// マークダウンのブロックの値を格納するクラス。
  const MarkdownBlockValue({
    required super.id,
    required this.property,
    this.indent = 0,
  });

  /// The indent of the markdown block value.
  ///
  /// マークダウンのブロックのインデント。
  final int indent;

  /// The property of the markdown block value.
  ///
  /// マークダウンのブロックのプロパティ。
  final MarkdownBlockProperty property;

  /// The padding of the markdown block value.
  ///
  /// マークダウンのブロックのパディング。
  EdgeInsetsGeometry padding(
    BuildContext context,
    MarkdownController controller,
  );

  /// The margin of the markdown block value.
  ///
  /// マークダウンのブロックのマージン。
  EdgeInsetsGeometry margin(
    BuildContext context,
    MarkdownController controller,
  );

  /// The text style of the markdown block value.
  ///
  /// マークダウンのブロックのテキストスタイル。
  TextStyle textStyle(
    BuildContext context,
    MarkdownController controller,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownBlockValue &&
        other.id == id &&
        other.type == type &&
        other.property == property;
  }

  @override
  int get hashCode => property.hashCode;

  @override
  String toString() {
    return "MarkdownBlockValue(property: $property)";
  }
}

/// A class for storing markdown paragraph block value.
///
/// マークダウンの段落ブロックの値を格納するクラス。
@immutable
class MarkdownParagraphBlockValue extends MarkdownBlockValue {
  /// A class for storing markdown paragraph block value.
  ///
  /// マークダウンの段落ブロックの値を格納するクラス。
  const MarkdownParagraphBlockValue({
    required super.id,
    required this.children,
    required super.property,
    super.indent = 0,
  });

  /// Create a [MarkdownParagraphBlockValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownParagraphBlockValue]を作成します。
  factory MarkdownParagraphBlockValue.fromJson(DynamicMap json) {
    return MarkdownParagraphBlockValue(
      id: json.get(MarkdownValue.idKey, ""),
      children: json
          .getAsList<DynamicMap>(MarkdownValue.childrenKey, [])
          .map(MarkdownLineValue.fromJson)
          .toList(),
      property: MarkdownBlockProperty.fromJson(
        json.getAsMap(MarkdownValue.propertyKey),
      ),
    );
  }

  /// Create a [MarkdownParagraphBlockValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownParagraphBlockValue]を作成します。
  factory MarkdownParagraphBlockValue.fromMarkdown(String markdown) {
    return MarkdownParagraphBlockValue(
      id: uuid(),
      children: [
        ...markdown.split("\n").map(MarkdownLineValue.fromMarkdown),
      ],
      property: const MarkdownBlockProperty(),
    );
  }

  @override
  String get type => "__text_block_paragraph__";

  /// The children of the markdown block value.
  ///
  /// マークダウンのブロックの子要素。
  final List<MarkdownLineValue> children;

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.childrenKey: children.map((e) => e.toJson()).toList(),
      MarkdownValue.propertyKey: property.toJson(),
    };
  }

  @override
  EdgeInsetsGeometry padding(
    BuildContext context,
    MarkdownController controller,
  ) {
    return controller.style.paragraph.padding ?? EdgeInsets.zero;
  }

  @override
  EdgeInsetsGeometry margin(
    BuildContext context,
    MarkdownController controller,
  ) {
    return controller.style.paragraph.margin ?? EdgeInsets.zero;
  }

  @override
  TextStyle textStyle(
    BuildContext context,
    MarkdownController controller,
  ) {
    final theme = Theme.of(context);
    return (controller.style.paragraph.textStyle ??
            theme.textTheme.bodyMedium ??
            const TextStyle())
        .copyWith(
      color: controller.style.paragraph.foregroundColor,
    );
  }

  @override
  String toMarkdown() {
    return children.map((e) => e.toMarkdown()).join("\n");
  }

  @override
  MarkdownParagraphBlockValue copyWith({
    String? id,
    int? indent,
    List<MarkdownLineValue>? children,
    MarkdownBlockProperty? property,
  }) {
    return MarkdownParagraphBlockValue(
      id: id ?? this.id,
      indent: indent ?? this.indent,
      children: children ?? this.children,
      property: property ?? this.property,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownParagraphBlockValue &&
        other.id == id &&
        other.type == type &&
        children.equalsTo(other.children) &&
        other.property == property;
  }

  @override
  int get hashCode => children.hashCode ^ property.hashCode;

  @override
  String toString() {
    return "MarkdownParagraphBlockValue(children: $children, property: $property)";
  }
}

/// A class for storing markdown field value.
///
/// マークダウンのフィールドの値を格納するクラス。
@immutable
class MarkdownFieldValue extends MarkdownValue {
  /// A class for storing markdown field value.
  ///
  /// マークダウンのフィールドの値を格納するクラス。
  const MarkdownFieldValue({
    required super.id,
    required this.children,
    required this.property,
  });

  /// Create a [MarkdownFieldValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownFieldValue]を作成します。
  factory MarkdownFieldValue.fromJson(DynamicMap json) {
    final tools =
        MarkdownMasamuneAdapter.findTools<MarkdownBlockVariableTools>();
    final children = <MarkdownBlockValue>[];
    for (final tool in tools) {
      final value = tool.convertFromJson(json);
      if (value != null) {
        children.add(value);
      }
    }
    return MarkdownFieldValue(
      id: json.get(MarkdownValue.idKey, ""),
      children: children,
      property: MarkdownFieldProperty.fromJson(
          json.getAsMap(MarkdownValue.propertyKey)),
    );
  }

  /// Create a [MarkdownFieldValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownFieldValue]を作成します。
  factory MarkdownFieldValue.fromMarkdown(String markdown) {
    final tools =
        MarkdownMasamuneAdapter.findTools<MarkdownBlockVariableTools>();
    final children = <MarkdownBlockValue>[];
    for (final tool in tools) {
      final value = tool.convertFromMarkdown(markdown);
      if (value != null) {
        children.add(value);
      }
    }
    return MarkdownFieldValue(
      id: uuid(),
      children: children,
      property: const MarkdownFieldProperty(),
    );
  }

  @override
  String get type => "__text_field__";

  /// The children of the markdown field value.
  ///
  /// マークダウンのフィールドの子要素。
  final List<MarkdownBlockValue> children;

  /// The property of the markdown field value.
  ///
  /// マークダウンのフィールドのプロパティ。
  final MarkdownFieldProperty property;

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.childrenKey: children.map((e) => e.toJson()).toList(),
      MarkdownValue.propertyKey: property.toJson(),
    };
  }

  @override
  String toMarkdown() {
    return children.map((e) => e.toMarkdown()).join("\n");
  }

  @override
  MarkdownFieldValue copyWith({
    String? id,
    List<MarkdownBlockValue>? children,
    MarkdownFieldProperty? property,
  }) {
    return MarkdownFieldValue(
      id: id ?? this.id,
      children: children ?? this.children,
      property: property ?? this.property,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownFieldValue &&
        other.id == id &&
        other.type == type &&
        children.equalsTo(other.children) &&
        other.property == property;
  }

  @override
  int get hashCode => children.hashCode ^ property.hashCode;

  @override
  String toString() {
    return "MarkdownFieldValue(children: $children, property: $property)";
  }
}

/// A class for storing markdown property.
///
/// マークダウンのプロパティを格納するクラス。
@immutable
abstract class MarkdownProperty {
  /// A class for storing markdown property.
  ///
  /// マークダウンのプロパティを格納するクラス。
  const MarkdownProperty({
    this.backgroundColor,
    this.foregroundColor,
  });

  /// The background color of the markdown property.
  ///
  /// マークダウンのプロパティの背景色。
  final Color? backgroundColor;

  /// The foreground color of the markdown property.
  ///
  /// マークダウンのプロパティの前景色。
  final Color? foregroundColor;

  /// The key for the background color.
  ///
  /// マークダウンのプロパティの背景色のキー。
  static const String backgroundColorKey = "backgroundColor";

  /// The key for the foreground color.
  ///
  /// マークダウンのプロパティの前景色のキー。
  static const String foregroundColorKey = "foregroundColor";

  /// The key for the padding.
  ///
  /// マークダウンのプロパティのパディングのキー。
  static const String paddingKey = "padding";

  /// The key for the margin.
  ///
  /// マークダウンのプロパティのマージンのキー。
  static const String marginKey = "margin";

  /// The left key of a Markdown property.
  ///
  /// マークダウンのプロパティの左のキー。
  static const String leftKey = "left";

  /// The right key of a Markdown property.
  ///
  /// マークダウンのプロパティの右のキー。
  static const String rightKey = "right";

  /// The top key of a Markdown property.
  ///
  /// マークダウンのプロパティの上のキー。
  static const String topKey = "top";

  /// The bottom key of a Markdown property.
  ///
  /// マークダウンのプロパティの下のキー。
  static const String bottomKey = "bottom";

  /// Convert the markdown property to a JSON object.
  ///
  /// マークダウンのプロパティをJSONオブジェクトに変換します。
  DynamicMap toJson();

  /// Copy the markdown property with the given fields.
  ///
  /// 指定されたフィールドでマークダウンのプロパティをコピーします。
  MarkdownProperty copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownProperty &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor;
  }

  @override
  int get hashCode => backgroundColor.hashCode ^ foregroundColor.hashCode;

  @override
  String toString() {
    return "MarkdownProperty(backgroundColor: $backgroundColor, foregroundColor: $foregroundColor)";
  }
}

/// A class for storing markdown span property.
///
/// マークダウンのスパンのプロパティを格納するクラス。
@immutable
class MarkdownSpanProperty extends MarkdownProperty {
  /// A class for storing markdown span property.
  ///
  /// マークダウンのスパンのプロパティを格納するクラス。
  const MarkdownSpanProperty({
    super.backgroundColor,
    super.foregroundColor,
  });

  /// Create a [MarkdownProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownProperty]を作成します。
  factory MarkdownSpanProperty.fromJson(DynamicMap json) {
    final backgroundColor =
        json.get(MarkdownProperty.backgroundColorKey, nullOfNum)?.toInt();
    final foregroundColor =
        json.get(MarkdownProperty.foregroundColorKey, nullOfNum)?.toInt();
    return MarkdownSpanProperty(
      backgroundColor: backgroundColor != null ? Color(backgroundColor) : null,
      foregroundColor: foregroundColor != null ? Color(foregroundColor) : null,
    );
  }

  @override
  DynamicMap toJson() {
    return {
      MarkdownProperty.backgroundColorKey: backgroundColor?.toInt(),
      MarkdownProperty.foregroundColorKey: foregroundColor?.toInt(),
    };
  }

  @override
  MarkdownSpanProperty copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return MarkdownSpanProperty(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownSpanProperty &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor;
  }

  @override
  int get hashCode => backgroundColor.hashCode ^ foregroundColor.hashCode;

  @override
  String toString() {
    return "MarkdownSpanProperty(backgroundColor: $backgroundColor, foregroundColor: $foregroundColor)";
  }
}

/// A class for storing markdown 1 line property.
///
/// マークダウンの１行のプロパティを格納するクラス。
@immutable
class MarkdownLineProperty extends MarkdownProperty {
  /// A class for storing markdown 1 line property.
  ///
  /// マークダウンの１行のプロパティを格納するクラス。
  const MarkdownLineProperty({
    super.backgroundColor,
    super.foregroundColor,
  });

  /// Create a [MarkdownLineProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownLineProperty]を作成します。
  factory MarkdownLineProperty.fromJson(DynamicMap json) {
    final backgroundColor =
        json.get(MarkdownProperty.backgroundColorKey, nullOfNum)?.toInt();
    final foregroundColor =
        json.get(MarkdownProperty.foregroundColorKey, nullOfNum)?.toInt();
    return MarkdownLineProperty(
      backgroundColor: backgroundColor != null ? Color(backgroundColor) : null,
      foregroundColor: foregroundColor != null ? Color(foregroundColor) : null,
    );
  }

  @override
  DynamicMap toJson() {
    return {
      MarkdownProperty.backgroundColorKey: backgroundColor?.toInt(),
      MarkdownProperty.foregroundColorKey: foregroundColor?.toInt(),
    };
  }

  @override
  MarkdownLineProperty copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return MarkdownLineProperty(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownLineProperty &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor;
  }

  @override
  int get hashCode => backgroundColor.hashCode ^ foregroundColor.hashCode;

  @override
  String toString() {
    return "MarkdownLineProperty(backgroundColor: $backgroundColor, foregroundColor: $foregroundColor)";
  }
}

/// A class for storing markdown block property.
///
/// マークダウンのブロックのプロパティを格納するクラス。
@immutable
class MarkdownBlockProperty extends MarkdownProperty {
  /// A class for storing markdown block property.
  ///
  /// マークダウンのブロックのプロパティを格納するクラス。
  const MarkdownBlockProperty({
    super.backgroundColor,
    super.foregroundColor,
  });

  /// Create a [MarkdownBlockProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownBlockProperty]を作成します。
  factory MarkdownBlockProperty.fromJson(DynamicMap json) {
    final backgroundColor =
        json.get(MarkdownProperty.backgroundColorKey, nullOfNum)?.toInt();
    final foregroundColor =
        json.get(MarkdownProperty.foregroundColorKey, nullOfNum)?.toInt();

    return MarkdownBlockProperty(
      backgroundColor: backgroundColor != null ? Color(backgroundColor) : null,
      foregroundColor: foregroundColor != null ? Color(foregroundColor) : null,
    );
  }

  @override
  DynamicMap toJson() {
    return {
      MarkdownProperty.backgroundColorKey: backgroundColor?.toInt(),
      MarkdownProperty.foregroundColorKey: foregroundColor?.toInt(),
    };
  }

  @override
  MarkdownBlockProperty copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return MarkdownBlockProperty(
        backgroundColor: backgroundColor, foregroundColor: foregroundColor);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownBlockProperty &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor;
  }

  @override
  int get hashCode => backgroundColor.hashCode ^ foregroundColor.hashCode;

  @override
  String toString() {
    return "MarkdownBlockProperty(backgroundColor: $backgroundColor, foregroundColor: $foregroundColor)";
  }
}

/// A class for storing markdown field property.
///
/// マークダウンのフィールドのプロパティを格納するクラス。
@immutable
class MarkdownFieldProperty extends MarkdownProperty {
  /// A class for storing markdown field property.
  ///
  /// マークダウンのフィールドのプロパティを格納するクラス。
  const MarkdownFieldProperty({
    super.backgroundColor,
    super.foregroundColor,
  });

  /// Create a [MarkdownFieldProperty] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownFieldProperty]を作成します。
  factory MarkdownFieldProperty.fromJson(DynamicMap json) {
    final backgroundColor =
        json.get(MarkdownProperty.backgroundColorKey, nullOfNum)?.toInt();
    final foregroundColor =
        json.get(MarkdownProperty.foregroundColorKey, nullOfNum)?.toInt();
    return MarkdownFieldProperty(
      backgroundColor: backgroundColor != null ? Color(backgroundColor) : null,
      foregroundColor: foregroundColor != null ? Color(foregroundColor) : null,
    );
  }

  @override
  DynamicMap toJson() {
    return {
      MarkdownProperty.backgroundColorKey: backgroundColor?.toInt(),
      MarkdownProperty.foregroundColorKey: foregroundColor?.toInt(),
    };
  }

  @override
  MarkdownFieldProperty copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
  }) {
    return MarkdownFieldProperty(
        backgroundColor: backgroundColor, foregroundColor: foregroundColor);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownFieldProperty &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor;
  }

  @override
  int get hashCode => backgroundColor.hashCode ^ foregroundColor.hashCode;

  @override
  String toString() {
    return "MarkdownFieldProperty(backgroundColor: $backgroundColor, foregroundColor: $foregroundColor)";
  }
}

/// Extension methods for [List<MarkdownFieldValue>].
///
/// [List<MarkdownFieldValue>]の拡張メソッド。
extension MarkdownFieldValueListExtension on List<MarkdownFieldValue> {
  /// Convert the markdown field value list to a JSON object.
  ///
  /// マークダウンのフィールドの値のリストをJSONオブジェクトに変換します。
  List<DynamicMap> toJson() {
    return map((e) => e.toJson()).toList();
  }

  /// Convert the markdown field value list to a markdown string.
  ///
  /// マークダウンのフィールドの値のリストをマークダウンの文字列に変換します。
  String toMarkdown() {
    return map((e) => e.toMarkdown()).join("\n");
  }
}
