part of "/masamune_painter.dart";

const _kGroupPainterPrimaryToolsId = "__painter_property_group__";
const _kClippingGroupPainterPrimaryToolsId =
    "__painter_property_clipping_group__";

/// Display group properties [PainterTools].
///
/// グループのプロパティを表示する[PainterTools]。
@immutable
class GroupPropertyPainterInlineTools extends PainterInlinePrimaryTools {
  /// Display group properties [PainterTools].
  ///
  /// グループのプロパティを表示する[PainterTools]。
  const GroupPropertyPainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "グループ",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Group",
        ),
      ]),
      icon: Icons.group,
    ),
    this.blockTools = const [
      GroupingGroupPainterBlockTools(),
      UngroupGroupPainterBlockTools(),
      ClipplingGroupPainterBlockTools(),
    ],
  });

  @override
  final List<PainterBlockTools> blockTools;

  @override
  String get id => "__painter_property_group__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentUngroupedValues.length > 1 ||
        ref.controller.currentValues.any((e) => e is GroupPaintingValue);
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentTool is GroupPropertyPainterInlineTools;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    return Icon(config.icon);
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {}

  @override
  Future<void> onActive(BuildContext context, PainterToolRef ref) async {
    // 他のPainterInlinePrimaryToolsから切り替える場合は_prevToolを保持
    final currentTool = ref.controller.currentTool;
    final shouldPreservePrevTool =
        currentTool is PainterInlinePrimaryTools && currentTool != this;
    final prevToolToPreserve =
        shouldPreservePrevTool ? ref.controller._prevTool : currentTool;
    ref.toggleMode(this);
    ref.controller._prevTool = prevToolToPreserve;
  }

  @override
  Future<void> onDeactive(BuildContext context, PainterToolRef ref) async {
    final prevTool = ref.controller._prevTool;
    if (prevTool != null) {
      ref.toggleMode(prevTool);
    } else {
      ref.toggleMode(this);
    }
  }
}

/// A class for storing group drawing data.
///
/// グループ描画用のデータを格納するクラス。
@immutable
class GroupPaintingValue extends PaintingValue {
  /// A class for storing group drawing data.
  ///
  /// グループ描画用のデータを格納するクラス。
  const GroupPaintingValue({
    required super.id,
    required super.property,
    required super.start,
    required super.end,
    required this.children,
    super.name,
    this.expanded = true,
  });

  /// Create a [GroupPaintingValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[GroupPaintingValue]を作成します。
  factory GroupPaintingValue.fromJson(DynamicMap json) {
    // Check if this is a ClippingGroupPaintingValue
    final type = json.get(PaintingValue.typeKey, "");
    if (type == _kClippingGroupPainterPrimaryToolsId) {
      return ClippingGroupPaintingValue.fromJson(json);
    }

    final properties = PaintingProperty.fromJson(
      json.getAsMap(PaintingValue.propertyKey),
    );

    // Restore child values from JSON
    final childrenJson =
        json.getAsList<DynamicMap>(PaintingValue.childrenKey, []);
    final children = <PaintingValue>[];
    for (final childJson in childrenJson) {
      final childType = childJson.get(PaintingValue.typeKey, "");
      final tool =
          PainterMasamuneAdapter.findTool(toolId: childType, recursive: true);
      if (tool is PainterVariableTools) {
        final value = tool.convertFromJson(childJson);
        if (value != null) {
          children.add(value);
        }
      }
    }

    return GroupPaintingValue(
      id: json.get(PaintingValue.idKey, ""),
      property: properties,
      start: Offset(
        json.get(PaintingValue.startXKey, 0.0),
        json.get(PaintingValue.startYKey, 0.0),
      ),
      end: Offset(
        json.get(PaintingValue.endXKey, 0.0),
        json.get(PaintingValue.endYKey, 0.0),
      ),
      name: json.get(PaintingValue.nameKey, nullOfString),
      expanded: json.get(PaintingValue.expandedKey, true),
      children: children,
    );
  }

  @override
  String get type => _kGroupPainterPrimaryToolsId;

  @override
  PaintingValueCategory get category => PaintingValueCategory.shape;

  @override
  Rect get rect {
    return Rect.fromPoints(start, end);
  }

  @override
  double get minimumArea => 0.0;

  @override
  Size get minimumSize => Size.zero;

  /// The actual child painting values.
  ///
  /// 実際の子描画値。
  final List<PaintingValue> children;

  /// Whether this group is expanded in the layer list.
  ///
  /// レイヤーリストでこのグループが展開されているかどうか。
  final bool expanded;

  @override
  DynamicMap toJson() {
    // Serialize child values
    final childrenJson = children
        .map((child) {
          final tool = PainterMasamuneAdapter.findTool(
              toolId: child.type, recursive: true);
          if (tool is PainterVariableTools) {
            return tool.convertToJson(child);
          }
          return null;
        })
        .whereType<DynamicMap>()
        .toList();

    return {
      PaintingValue.typeKey: type,
      PaintingValue.idKey: id,
      PaintingValue.propertyKey: property.toJson(),
      PaintingValue.startXKey: start.dx,
      PaintingValue.startYKey: start.dy,
      PaintingValue.endXKey: end.dx,
      PaintingValue.endYKey: end.dy,
      if (name != null) PaintingValue.nameKey: name,
      PaintingValue.childrenKey: childrenJson,
      PaintingValue.expandedKey: expanded,
    };
  }

  @override
  DynamicMap toDebug() {
    // Serialize child values
    final childrenJson = children
        .map((child) {
          final tool = PainterMasamuneAdapter.findTool(
              toolId: child.type, recursive: true);
          if (tool is PainterVariableTools) {
            return tool.convertToJson(child);
          }
          return null;
        })
        .whereType<DynamicMap>()
        .toList();

    return {
      PaintingValue.typeKey: type,
      PaintingValue.propertyKey: property.toJson(),
      PaintingValue.startXKey: start.dx,
      PaintingValue.startYKey: start.dy,
      PaintingValue.endXKey: end.dx,
      PaintingValue.endYKey: end.dy,
      if (name != null) PaintingValue.nameKey: name,
      PaintingValue.childrenKey: childrenJson,
      PaintingValue.expandedKey: expanded,
    };
  }

  @override
  GroupPaintingValue copyWith({
    Offset? offset,
    PaintingProperty? property,
    Offset? start,
    Offset? end,
    String? id,
    String? name,
    List<PaintingValue>? children,
    bool? expanded,
  }) {
    return GroupPaintingValue(
      id: id ?? this.id,
      property: property ?? this.property,
      start: start ?? this.start,
      end: end ?? this.end,
      name: name ?? this.name,
      children: children ?? this.children,
      expanded: expanded ?? this.expanded,
    );
  }

  @override
  Widget get icon => const Icon(Icons.folder);

  @override
  Rect? paint(Canvas canvas) {
    // Groups don't paint anything themselves
    return null;
  }

  @override
  GroupPaintingValue updateOnCreating({
    required Offset startPoint,
    required Offset currentPoint,
  }) {
    return this;
  }

  @override
  GroupPaintingValue updateOnMoving({
    required Offset delta,
  }) {
    // Move all children with the group
    final movedChildren = children.map((child) {
      return child.updateOnMoving(delta: delta);
    }).toList();

    return copyWith(
      start: start + delta,
      end: end + delta,
      children: movedChildren,
    );
  }

  @override
  GroupPaintingValue updateOnResizing({
    required Offset currentPoint,
    required PainterResizeDirection direction,
    required Offset startPoint,
    required Offset endPoint,
  }) {
    // Calculate the dimensions for resizing
    final oldWidth = (end.dx - start.dx).abs();
    final oldHeight = (end.dy - start.dy).abs();

    final newRect = Rect.fromPoints(startPoint, endPoint);
    final newWidth = newRect.width;
    final newHeight = newRect.height;

    if (oldWidth == 0 || oldHeight == 0) {
      return this;
    }

    // Transform all children
    final resizedChildren = children.map((child) {
      final childRect = child.rect;

      // Calculate relative position within the group
      final relativeLeft = (childRect.left - start.dx) / oldWidth;
      final relativeTop = (childRect.top - start.dy) / oldHeight;
      final relativeRight = (childRect.right - start.dx) / oldWidth;
      final relativeBottom = (childRect.bottom - start.dy) / oldHeight;

      // Calculate new absolute position
      final newLeft = startPoint.dx + (relativeLeft * newWidth);
      final newTop = startPoint.dy + (relativeTop * newHeight);
      final newRight = startPoint.dx + (relativeRight * newWidth);
      final newBottom = startPoint.dy + (relativeBottom * newHeight);

      return child.copyWith(
        start: Offset(newLeft, newTop),
        end: Offset(newRight, newBottom),
      );
    }).toList();

    return copyWith(
      start: startPoint,
      end: endPoint,
      children: resizedChildren,
    );
  }
}

/// A class for storing clipping group drawing data.
///
/// クリッピンググループ描画用のデータを格納するクラス。
@immutable
class ClippingGroupPaintingValue extends GroupPaintingValue {
  /// A class for storing clipping group drawing data.
  ///
  /// クリッピンググループ描画用のデータを格納するクラス。
  const ClippingGroupPaintingValue({
    required super.id,
    required super.property,
    required super.start,
    required super.end,
    required super.children,
    required this.clipper,
    super.name,
    super.expanded = true,
  });

  /// Create a [ClippingGroupPaintingValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[ClippingGroupPaintingValue]を作成します。
  factory ClippingGroupPaintingValue.fromJson(DynamicMap json) {
    final properties = PaintingProperty.fromJson(
      json.getAsMap(PaintingValue.propertyKey),
    );

    // Restore child values from JSON
    final childrenJson =
        json.getAsList<DynamicMap>(PaintingValue.childrenKey, []);
    final children = <PaintingValue>[];
    for (final childJson in childrenJson) {
      final type = childJson.get(PaintingValue.typeKey, "");
      final tool =
          PainterMasamuneAdapter.findTool(toolId: type, recursive: true);
      if (tool is PainterVariableTools) {
        final value = tool.convertFromJson(childJson);
        if (value != null) {
          children.add(value);
        }
      }
    }

    // Restore clipShape from JSON
    final clipShapeJson = json.getAsMap(clipperKey);
    final clipShapeType = clipShapeJson.get(PaintingValue.typeKey, "");
    final clipShapeTool =
        PainterMasamuneAdapter.findTool(toolId: clipShapeType, recursive: true);
    PaintingValue? clipShape;
    if (clipShapeTool is PainterVariableTools) {
      clipShape = clipShapeTool.convertFromJson(clipShapeJson);
    }

    if (clipShape == null) {
      throw Exception("ClipShape not found in JSON");
    }

    return ClippingGroupPaintingValue(
      id: json.get(PaintingValue.idKey, ""),
      property: properties,
      start: Offset(
        json.get(PaintingValue.startXKey, 0.0),
        json.get(PaintingValue.startYKey, 0.0),
      ),
      end: Offset(
        json.get(PaintingValue.endXKey, 0.0),
        json.get(PaintingValue.endYKey, 0.0),
      ),
      name: json.get(PaintingValue.nameKey, nullOfString),
      expanded: json.get(PaintingValue.expandedKey, true),
      children: children,
      clipper: clipShape,
    );
  }

  /// The key for the clipShape.
  ///
  /// クリップシェイプのキー。
  static const String clipperKey = "clipper";

  /// The shape used for clipping.
  ///
  /// クリッピングに使用するシェイプ。
  final PaintingValue clipper;

  @override
  String get type => _kClippingGroupPainterPrimaryToolsId;

  @override
  Widget get icon => const Icon(Icons.crop);

  @override
  DynamicMap toJson() {
    // Serialize child values
    final childrenJson = children
        .map((child) {
          final tool = PainterMasamuneAdapter.findTool(
              toolId: child.type, recursive: true);
          if (tool is PainterVariableTools) {
            return tool.convertToJson(child);
          }
          return null;
        })
        .whereType<DynamicMap>()
        .toList();

    // Serialize clipShape
    final clipperTool =
        PainterMasamuneAdapter.findTool(toolId: clipper.type, recursive: true);
    DynamicMap? clipperJson;
    if (clipperTool is PainterVariableTools) {
      clipperJson = clipperTool.convertToJson(clipper);
    }

    return {
      PaintingValue.typeKey: type,
      PaintingValue.idKey: id,
      PaintingValue.propertyKey: property.toJson(),
      PaintingValue.startXKey: start.dx,
      PaintingValue.startYKey: start.dy,
      PaintingValue.endXKey: end.dx,
      PaintingValue.endYKey: end.dy,
      if (name != null) PaintingValue.nameKey: name,
      PaintingValue.childrenKey: childrenJson,
      PaintingValue.expandedKey: expanded,
      if (clipperJson != null) clipperKey: clipperJson,
    };
  }

  @override
  ClippingGroupPaintingValue copyWith({
    Offset? offset,
    PaintingProperty? property,
    Offset? start,
    Offset? end,
    String? id,
    String? name,
    List<PaintingValue>? children,
    bool? expanded,
    PaintingValue? clipper,
  }) {
    return ClippingGroupPaintingValue(
      id: id ?? this.id,
      property: property ?? this.property,
      start: start ?? this.start,
      end: end ?? this.end,
      name: name ?? this.name,
      children: children ?? this.children,
      expanded: expanded ?? this.expanded,
      clipper: clipper ?? this.clipper,
    );
  }

  @override
  Rect? paint(Canvas canvas) {
    // Clipping groups don't paint anything themselves
    // Clipping and child painting are handled by FormPainterField._paintValue()
    return null;
  }

  @override
  ClippingGroupPaintingValue updateOnMoving({
    required Offset delta,
  }) {
    // Move all children with the group
    final movedChildren = children.map((child) {
      return child.updateOnMoving(delta: delta);
    }).toList();

    // Move clipShape as well
    final movedClipShape = clipper.updateOnMoving(delta: delta);

    return copyWith(
      start: start + delta,
      end: end + delta,
      children: movedChildren,
      clipper: movedClipShape,
    );
  }

  @override
  ClippingGroupPaintingValue updateOnResizing({
    required Offset currentPoint,
    required PainterResizeDirection direction,
    required Offset startPoint,
    required Offset endPoint,
  }) {
    // For ClippingGroup, only resize the clipShape by default
    // (when the group itself is selected without children)
    // Resizing with children is handled by PainterController.resizeSelectedValues
    final resizedClipShape = clipper.updateOnResizing(
      currentPoint: currentPoint,
      direction: direction,
      startPoint: startPoint,
      endPoint: endPoint,
    );

    return copyWith(
      clipper: resizedClipShape,
      start: resizedClipShape.start,
      end: resizedClipShape.end,
    );
  }
}
