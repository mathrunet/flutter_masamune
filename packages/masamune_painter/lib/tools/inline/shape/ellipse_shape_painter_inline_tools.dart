part of "/masamune_painter.dart";

const _kEllipseShapePainterInlineToolsId = "__painter_shape_ellipse__";

/// Display the menu to draw an ellipse [PainterTools].
///
/// 楕円を描画するメニューを表示する[PainterTools]。
@immutable
class EllipseShapePainterInlineTools
    extends PainterVariableInlineTools<EllipsePaintingValue> {
  /// Display the menu to draw an ellipse [PainterTools].
  ///
  /// 楕円を描画するメニューを表示する[PainterTools]。
  const EllipseShapePainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "円",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Circle",
        ),
      ]),
      icon: Icons.circle,
    ),
  });

  @override
  String get id => _kEllipseShapePainterInlineToolsId;

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentTool == null;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    final theme = Theme.of(context);
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.dividerColor,
          width: 2,
        ),
      ),
    );
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
    ref.unselect();
    ref.toggleMode(this);
  }

  @override
  Future<void> onDeactive(BuildContext context, PainterToolRef ref) async {
    ref.deleteMode();
  }

  @override
  bool get canDraw => true;

  @override
  EllipsePaintingValue create({
    required Offset point,
    required PaintingProperty property,
    String? uid,
  }) {
    return EllipsePaintingValue(
      id: uid ?? uuid(),
      property: property,
      start: point,
      end: point,
    );
  }

  @override
  EllipsePaintingValue? convertFromJson(DynamicMap json) {
    final type = json.get(PaintingValue.typeKey, "");
    if (type == _kEllipseShapePainterInlineToolsId) {
      return EllipsePaintingValue.fromJson(json);
    }
    return null;
  }

  @override
  DynamicMap? convertToJson(PaintingValue value) {
    if (value is EllipsePaintingValue) {
      return value.toJson();
    }
    return null;
  }
}
