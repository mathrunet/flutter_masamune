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

  /// Convert the markdown value to a test JSON object.
  ///
  /// マークダウンのデータをテスト用のJSONオブジェクトに変換します。
  DynamicMap toDebug();

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

  /// The key for the indent.
  ///
  /// マークダウンのインデントのキー。
  static const String indentKey = "indent";

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
    this.properties = const [],
    this.editable = true,
  });

  /// Create a [MarkdownSpanValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownSpanValue]を作成します。
  factory MarkdownSpanValue.fromJson(DynamicMap json) {
    final properties =
        json.getAsList<DynamicMap>(MarkdownValue.propertyKey, []);
    return MarkdownSpanValue(
      id: json.get(MarkdownValue.idKey, ""),
      value: json.get(MarkdownValue.valueKey, ""),
      properties: MarkdownProperty.fromJson(
        properties,
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
    );
  }

  /// Create a [MarkdownSpanValue] with an empty value.
  ///
  /// [initialText]を指定した場合、[initialText]を設定します。
  /// [initialText]が指定されていない場合、空のスパンを作成します。
  factory MarkdownSpanValue.createEmpty({String? initialText}) {
    return MarkdownSpanValue(
      id: uuid(),
      value: initialText ?? "",
      properties: const [],
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
  final List<MarkdownProperty> properties;

  /// The text style of the markdown span value.
  ///
  /// マークダウンのスパンのテキストスタイル。
  TextStyle? textStyle(
    RenderContext context,
    MarkdownController controller,
    TextStyle? baseTextStyle,
  ) {
    for (final property in properties) {
      baseTextStyle = property.textStyle(context, controller, baseTextStyle);
    }
    return baseTextStyle;
  }

  /// The background color of the markdown span value.
  ///
  /// マークダウンのスパンの背景色。
  Color? backgroundColor(
    RenderContext context,
    MarkdownController controller,
    Color? baseBackgroundColor,
  ) {
    for (final property in properties) {
      baseBackgroundColor =
          property.backgroundColor(context, controller, baseBackgroundColor);
    }
    return baseBackgroundColor;
  }

  /// The background decoration of the markdown span value.
  ///
  /// マークダウンのスパンの背景装飾。
  BoxDecoration? backgroundDecoration(
    RenderContext context,
    MarkdownController controller,
    BoxDecoration? baseDecoration,
  ) {
    for (final property in properties) {
      final decoration =
          property.backgroundDecoration(context, controller, baseDecoration);
      if (decoration != null) {
        return decoration;
      }
    }
    return baseDecoration;
  }

  @override
  MarkdownSpanValue copyWith({
    String? id,
    String? value,
    List<MarkdownProperty>? properties,
  }) {
    return MarkdownSpanValue(
      id: id ?? this.id,
      value: value ?? this.value,
      properties: properties ?? this.properties,
    );
  }

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.valueKey: value,
      MarkdownValue.propertyKey: properties.map((e) => e.toJson()).toList(),
    };
  }

  @override
  DynamicMap toDebug() {
    return {
      MarkdownValue.typeKey: type,
      MarkdownValue.valueKey: value,
      MarkdownValue.propertyKey: properties.map((e) => e.toDebug()).toList(),
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
        other.properties.equalsTo(properties);
  }

  @override
  int get hashCode {
    var hash = super.hashCode ^ value.hashCode;
    for (final property in properties) {
      hash = hash ^ property.hashCode;
    }
    return hash;
  }

  @override
  String toString() {
    return "MarkdownSpanValue(value: $value, properties: $properties)";
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
    );
  }

  /// Create a [MarkdownLineValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownLineValue]を作成します。
  factory MarkdownLineValue.fromMarkdown(String markdown) {
    return MarkdownLineValue(
      id: uuid(),
      children: [
        ...markdown.split("\n").map(MarkdownSpanValue.fromMarkdown),
      ],
    );
  }

  /// If [initialText] is specified, [initialText] will be set to the first line.
  /// If [initialText] is not specified, an empty line will be created with no text.
  ///
  /// [initialText]を指定した場合、最初の行に[initialText]を設定します。
  /// [initialText]が指定されていない場合、空の行を作成します。
  factory MarkdownLineValue.createEmpty({
    String? initialText,
    List<MarkdownSpanValue>? children,
  }) {
    return MarkdownLineValue(
      id: uuid(),
      children: children ??
          [
            MarkdownSpanValue.createEmpty(initialText: initialText),
          ],
    );
  }

  @override
  String get type => "__text_line__";

  /// The children of the markdown 1 line value.
  ///
  /// マークダウンの１行の子要素。
  final List<MarkdownSpanValue> children;

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.childrenKey: children.map((e) => e.toJson()).toList(),
    };
  }

  @override
  DynamicMap toDebug() {
    return {
      MarkdownValue.typeKey: type,
      MarkdownValue.childrenKey: children.map((e) => e.toDebug()).toList(),
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
  }) {
    return MarkdownLineValue(
      id: id ?? this.id,
      children: children ?? this.children,
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
        children.equalsTo(other.children);
  }

  @override
  int get hashCode {
    var hash = super.hashCode;
    for (final child in children) {
      hash = hash ^ child.hashCode;
    }
    return hash;
  }

  @override
  String toString() {
    return "MarkdownLineValue(children: $children)";
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
    this.indent = 0,
  });

  /// If [initialText] is specified, [initialText] will be set to the first block.
  /// If [initialText] is not specified, an empty paragraph will be created with no text.
  ///
  /// [initialText]を指定した場合、最初のブロックに[initialText]を設定します。
  /// [initialText]が指定されていない場合、空の段落を作成します。
  factory MarkdownBlockValue.createEmpty({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownParagraphBlockValue(
      id: uuid(),
      children: children ??
          [
            MarkdownLineValue.createEmpty(initialText: initialText),
          ],
    );
  }

  /// The indent of the markdown block value.
  ///
  /// マークダウンのブロックのインデント。
  final int indent;

  /// Checks if the block can be indented.
  ///
  /// ブロックがインデントできるかどうかを確認します。
  bool get canIndent {
    return false;
  }

  /// Checks if the indent should be maintained.
  ///
  /// インデントが保持されるかどうかを確認します。
  bool get maintainIndent => false;

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.indentKey: indent,
    };
  }

  @override
  DynamicMap toDebug() {
    return {
      MarkdownValue.typeKey: type,
      MarkdownValue.indentKey: indent,
    };
  }

  /// Build the block layout.
  ///
  /// ブロックのレイアウトを作成します。
  BlockLayout? build(
    RenderContext context,
    MarkdownController controller,
    int textOffset,
  );

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

  /// The background color of the markdown span value.
  ///
  /// マークダウンのスパンの背景色。
  Color? backgroundColor(
    RenderContext context,
    MarkdownController controller,
  );

  /// Clone the markdown block value.
  ///
  /// マークダウンのブロックの値をクローンします。
  MarkdownBlockValue clone({
    String? id,
    int? indent,
    MarkdownLineValue? child,
    String? initialText,
  }) {
    final block = this;
    if (maintainIndent) {
      indent ??= this.indent;
    }
    if (block is MarkdownMultiLineBlockValue) {
      return block.copyWith(
        id: id ?? block.id,
        indent: indent,
        children: [
          child ?? MarkdownLineValue.createEmpty(initialText: initialText)
        ],
      );
    } else {
      return MarkdownParagraphBlockValue(
        id: id ?? block.id,
        children: [
          child ?? MarkdownLineValue.createEmpty(initialText: initialText)
        ],
      );
    }
  }

  /// Extract the lines from the markdown block value.
  ///
  /// マークダウンのブロックの行を抽出します。
  List<MarkdownLineValue>? extractLines() {
    return [];
  }

  @override
  MarkdownBlockValue copyWith({
    String? id,
    int? indent,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownBlockValue &&
        other.id == id &&
        other.type == type &&
        other.indent == indent;
  }

  @override
  int get hashCode => super.hashCode ^ indent.hashCode;

  @override
  String toString() {
    return "MarkdownBlockValue(indent: $indent)";
  }
}

/// A class for storing markdown multi line block value.
///
/// マークダウンの複数行のブロックの値を格納するクラス。
@immutable
abstract class MarkdownMultiLineBlockValue extends MarkdownBlockValue {
  /// A class for storing markdown multi line block value.
  ///
  /// マークダウンの複数行のブロックの値を格納するクラス。
  const MarkdownMultiLineBlockValue({
    required super.id,
    required this.children,
    super.indent = 0,
  });

  /// The children of the markdown block value.
  ///
  /// マークダウンのブロックの子要素。
  final List<MarkdownLineValue> children;

  @override
  MarkdownMultiLineBlockValue copyWith({
    String? id,
    int? indent,
    List<MarkdownLineValue>? children,
  });

  @override
  List<MarkdownLineValue>? extractLines() {
    return children;
  }

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.indentKey: indent,
      MarkdownValue.childrenKey: children.map((e) => e.toJson()).toList(),
    };
  }

  @override
  DynamicMap toDebug() {
    return {
      MarkdownValue.typeKey: type,
      MarkdownValue.indentKey: indent,
      MarkdownValue.childrenKey: children.map((e) => e.toDebug()).toList(),
    };
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
    );
  }

  /// If [initialText] is specified, [initialText] will be set to the first block.
  /// If [initialText] is not specified, an empty paragraph will be created with no text.
  ///
  /// [initialText]を指定した場合、最初の段落に[initialText]を設定します。
  /// [initialText]が指定されていない場合、空の段落を作成します。
  factory MarkdownFieldValue.createEmpty(
      {String? initialText, List<MarkdownBlockValue>? children}) {
    return MarkdownFieldValue(
      id: uuid(),
      children: children ??
          [
            MarkdownParagraphBlockValue.createEmpty(initialText: initialText),
          ],
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
    );
  }

  @override
  String get type => "__text_field__";

  /// The children of the markdown field value.
  ///
  /// マークダウンのフィールドの子要素。
  final List<MarkdownBlockValue> children;

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.childrenKey: children.map((e) => e.toJson()).toList(),
    };
  }

  @override
  DynamicMap toDebug() {
    return {
      MarkdownValue.typeKey: type,
      MarkdownValue.childrenKey: children.map((e) => e.toDebug()).toList(),
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
  }) {
    return MarkdownFieldValue(
      id: id ?? this.id,
      children: children ?? this.children,
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
        children.equalsTo(other.children);
  }

  @override
  int get hashCode {
    var hash = super.hashCode;
    for (final child in children) {
      hash = hash ^ child.hashCode;
    }
    return hash;
  }

  @override
  String toString() {
    return "MarkdownFieldValue(children: $children)";
  }
}

/// A class for storing markdown span property.
///
/// マークダウンのスパンのプロパティを格納するクラス。
@immutable
abstract class MarkdownProperty {
  /// A class for storing markdown span property.
  ///
  /// マークダウンのスパンのプロパティを格納するクラス。
  const MarkdownProperty();

  /// Create a [MarkdownProperty] from a [List<DynamicMap>].
  ///
  /// [List<DynamicMap>]から[MarkdownProperty]を作成します。
  static List<MarkdownProperty> fromJson(List<DynamicMap> json) {
    final properties = <MarkdownProperty>[];
    final tools = MarkdownMasamuneAdapter.findTools<MarkdownPropertyTools>(
      recursive: true,
    );
    for (final jsn in json) {
      for (final tool in tools) {
        final value = tool.convertFromJson(jsn);
        if (value != null) {
          properties.add(value);
        }
      }
    }
    return properties;
  }

  /// The type of the markdown property.
  ///
  /// マークダウンのプロパティの型。
  String get type;

  /// The key for the link.
  ///
  /// マークダウンのスパンのプロパティのリンクのキー。
  static const String linkKey = "link";

  /// The key for the mention.
  ///
  /// マークダウンのスパンのプロパティのメンションのキー。
  static const String mentionKey = "mention";

  /// The key for the type.
  ///
  /// マークダウンのプロパティの型のキー。
  static const String typeKey = "type";

  /// Convert the markdown property to a JSON object.
  ///
  /// マークダウンのプロパティをJSONオブジェクトに変換します。
  DynamicMap toJson() {
    return {
      MarkdownProperty.typeKey: type,
    };
  }

  /// Convert the markdown property to a test JSON object.
  ///
  /// マークダウンのプロパティをテスト用のJSONオブジェクトに変換します。
  DynamicMap toDebug() {
    return {
      MarkdownProperty.typeKey: type,
    };
  }

  /// Copy the markdown property with the given fields.
  ///
  /// 指定されたフィールドでマークダウンのプロパティをコピーします。
  MarkdownProperty copyWith();

  /// The text style of the markdown property.
  ///
  /// マークダウンのプロパティのテキストスタイル。
  TextStyle? textStyle(
    RenderContext context,
    MarkdownController controller,
    TextStyle? baseTextStyle,
  );

  /// The background color of the markdown property.
  ///
  /// マークダウンのプロパティの背景色。
  Color? backgroundColor(
    RenderContext context,
    MarkdownController controller,
    Color? baseBackgroundColor,
  );

  /// The background decoration of the markdown property.
  ///
  /// マークダウンのプロパティの背景装飾。
  BoxDecoration? backgroundDecoration(
    RenderContext context,
    MarkdownController controller,
    BoxDecoration? baseDecoration,
  ) {
    return null;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownProperty && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;

  @override
  String toString() {
    return "MarkdownProperty(type: $type)";
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

  /// Convert the markdown field value list to a test JSON object.
  ///
  /// マークダウンのフィールドの値のリストをテスト用のJSONオブジェクトに変換します。
  List<DynamicMap> toDebug() {
    return map((e) => e.toDebug()).toList();
  }

  /// Convert the markdown field value list to a markdown string.
  ///
  /// マークダウンのフィールドの値のリストをマークダウンの文字列に変換します。
  String toMarkdown() {
    return map((e) => e.toMarkdown()).join("\n");
  }

  /// Creates a deep copy of the given MarkdownFieldValue list.
  ///
  /// 指定されたMarkdownFieldValueリストのディープコピーを作成します。
  List<MarkdownFieldValue> clone() {
    final fields = this;
    return fields.map((field) {
      return field.copyWith(
        children: field.children.map<MarkdownBlockValue>((block) {
          if (block is MarkdownMultiLineBlockValue) {
            return block.copyWith(
              children: block.children.map<MarkdownLineValue>((line) {
                return line.copyWith(
                  children: line.children.map<MarkdownSpanValue>((span) {
                    return span.copyWith();
                  }).toList(),
                );
              }).toList(),
            );
          }
          return block.copyWith();
        }).toList(),
      );
    }).toList();
  }
}
