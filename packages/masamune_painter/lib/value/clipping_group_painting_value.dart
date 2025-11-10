part of "/masamune_painter.dart";

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

      // Check if child is a GroupPaintingValue first
      if (type == _kGroupPainterPrimaryToolsId ||
          type == _kClippingGroupPainterPrimaryToolsId) {
        children.add(GroupPaintingValue.fromJson(childJson));
        continue;
      }

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
    final clipShapeJson = json.getAsMap(ClippingGroupPaintingValue.clipperKey);
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
    // Apply offset to children recursively if provided
    final updatedChildren = offset != null && children == null
        ? this.children.map((child) => child.copyWith(offset: offset)).toList()
        : (children ?? this.children);

    // Apply offset to clipper as well if provided
    final updatedClipper = offset != null && clipper == null
        ? this.clipper.copyWith(offset: offset)
        : (clipper ?? this.clipper);

    return ClippingGroupPaintingValue(
      id: id ?? this.id,
      property: property ?? this.property,
      start: (start ?? this.start) + (offset ?? Offset.zero),
      end: (end ?? this.end) + (offset ?? Offset.zero),
      name: name ?? this.name,
      children: updatedChildren,
      expanded: expanded ?? this.expanded,
      clipper: updatedClipper,
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
