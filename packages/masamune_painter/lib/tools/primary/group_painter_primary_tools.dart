part of "/masamune_painter.dart";

const _kGroupPainterPrimaryToolsId = "__painter_primary_group__";

/// Group tool for [FormPainterField].
///
/// [FormPainterField]のグループツール。
@immutable
class GroupPainterPrimaryTools extends PainterPrimaryTools
    implements PainterVariableTools<GroupPaintingValue> {
  /// Group tool for [FormPainterField].
  ///
  /// [FormPainterField]のグループツール。
  const GroupPainterPrimaryTools({
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
  });

  @override
  String get id => _kGroupPainterPrimaryToolsId;

  @override
  bool shown(BuildContext context, PainterToolRef ref) => false;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentTool is GroupPainterPrimaryTools;
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
  void onTap(BuildContext context, PainterToolRef ref) {
    ref.toggleMode(this);
  }

  @override
  bool get canDraw => false;

  @override
  GroupPaintingValue create({
    required Offset point,
    required PaintingProperty property,
    String? uid,
  }) {
    return GroupPaintingValue(
      id: uid ?? uuid(),
      property: property,
      start: point,
      end: point,
      children: const [],
      childValues: const [],
    );
  }

  @override
  GroupPaintingValue? convertFromJson(DynamicMap json) {
    final type = json.get(PaintingValue.typeKey, "");
    if (type == _kGroupPainterPrimaryToolsId) {
      return GroupPaintingValue.fromJson(json);
    }
    return null;
  }

  @override
  DynamicMap? convertToJson(PaintingValue value) {
    if (value is GroupPaintingValue) {
      return value.toJson();
    }
    return null;
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
    required this.childValues,
    super.name,
    this.expanded = true,
  });

  /// The IDs of child painting values in this group.
  ///
  /// このグループ内の子描画値のID。
  final List<String> children;

  /// The actual child painting values.
  ///
  /// 実際の子描画値。
  final List<PaintingValue> childValues;

  /// Whether this group is expanded in the layer list.
  ///
  /// レイヤーリストでこのグループが展開されているかどうか。
  final bool expanded;

  /// The key for the children.
  ///
  /// 子要素のキー。
  static const String childrenKey = "children";

  /// The key for the child values.
  ///
  /// 子要素の値のキー。
  static const String childValuesKey = "childValues";

  /// The key for the isExpanded.
  ///
  /// 展開状態のキー。
  static const String isExpandedKey = "isExpanded";

  /// Create a [GroupPaintingValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[GroupPaintingValue]を作成します。
  factory GroupPaintingValue.fromJson(DynamicMap json) {
    final properties = PaintingProperty.fromJson(
      json.getAsMap(PaintingValue.propertyKey),
    );

    // Restore child values from JSON
    final childValuesList = json.getAsList(childValuesKey, []);
    final childValues = <PaintingValue>[];
    for (final childJson in childValuesList) {
      if (childJson is! DynamicMap) {
        continue;
      }

      final type = childJson.get(PaintingValue.typeKey, "");
      final tool =
          PainterMasamuneAdapter.findTool(toolId: type, recursive: true);
      if (tool is PainterVariableTools) {
        final value = tool.convertFromJson(childJson);
        if (value != null) {
          childValues.add(value);
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
      children: json.getAsList(childrenKey, []).cast<String>(),
      childValues: childValues,
      expanded: json.get(isExpandedKey, true),
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

  @override
  DynamicMap toJson() {
    // Serialize child values
    final childValuesJson = childValues
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
      childrenKey: children,
      childValuesKey: childValuesJson,
      isExpandedKey: expanded,
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
    List<String>? children,
    List<PaintingValue>? childValues,
    bool? isExpanded,
  }) {
    return GroupPaintingValue(
      id: id ?? this.id,
      property: property ?? this.property,
      start: start ?? this.start,
      end: end ?? this.end,
      name: name ?? this.name,
      children: children ?? this.children,
      childValues: childValues ?? this.childValues,
      expanded: isExpanded ?? this.expanded,
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
    final movedChildren = childValues.map((child) {
      return child.updateOnMoving(delta: delta);
    }).toList();

    return copyWith(
      start: start + delta,
      end: end + delta,
      childValues: movedChildren,
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
    final resizedChildren = childValues.map((child) {
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
      childValues: resizedChildren,
    );
  }
}
