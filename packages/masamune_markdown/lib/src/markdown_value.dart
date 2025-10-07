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
    this.start,
    this.end,
  });

  /// The id of the painting value.
  ///
  /// 描画用のデータのID。
  final String id;

  /// The type of the markdown value.
  ///
  /// マークダウンのデータの型。
  String get type;

  /// The start point of the markdown value.
  ///
  /// マークダウンのデータの開始点。
  final Offset? start;

  /// The end point of the markdown value.
  ///
  /// マークダウンのデータの終了点。
  final Offset? end;

  /// Convert the markdown value to a JSON object.
  ///
  /// マークダウンのデータをJSONオブジェクトに変換します。
  DynamicMap toJson();

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownValue && other.id == id && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ type.hashCode;
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
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.valueKey: value,
      MarkdownValue.propertyKey: property.toJson(),
    };
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
  });

  /// The property of the markdown block value.
  ///
  /// マークダウンのブロックのプロパティ。
  final MarkdownBlockProperty property;
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
  });

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
    return MarkdownFieldValue(
      id: json.get(MarkdownValue.idKey, ""),
      // ToDo: implement
      children: const [],
      property: MarkdownFieldProperty.fromJson(
          json.getAsMap(MarkdownValue.propertyKey)),
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

  /// Convert the markdown property to a JSON object.
  ///
  /// マークダウンのプロパティをJSONオブジェクトに変換します。
  DynamicMap toJson();
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
    required super.backgroundColor,
    required super.foregroundColor,
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
    required super.backgroundColor,
    required super.foregroundColor,
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
    required super.backgroundColor,
    required super.foregroundColor,
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
    required super.backgroundColor,
    required super.foregroundColor,
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
}
