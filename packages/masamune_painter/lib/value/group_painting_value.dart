part of "/masamune_painter.dart";

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

      // Check if child is a GroupPaintingValue first
      if (childType == _kGroupPainterPrimaryToolsId ||
          childType == _kClippingGroupPainterPrimaryToolsId) {
        children.add(GroupPaintingValue.fromJson(childJson));
        continue;
      }

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
    // Apply offset to children recursively if provided
    final updatedChildren = offset != null && children == null
        ? this.children.map((child) => child.copyWith(offset: offset)).toList()
        : (children ?? this.children);

    return GroupPaintingValue(
      id: id ?? this.id,
      property: property ?? this.property,
      start: (start ?? this.start) + (offset ?? Offset.zero),
      end: (end ?? this.end) + (offset ?? Offset.zero),
      name: name ?? this.name,
      children: updatedChildren,
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
