part of "/masamune_painter.dart";

const _kRectangleShapePainterInlineToolsId = "__painter_shape_rectangle__";

/// Display the menu to draw a rectangle [PainterTools].
///
/// 四角形を描画するメニューを表示する[PainterTools]。
@immutable
class RectangleShapePainterInlineTools
    extends PainterVariableInlineTools<RectanglePaintingValue> {
  /// Display the menu to draw a rectangle [PainterTools].
  ///
  /// 四角形を描画するメニューを表示する[PainterTools]。
  const RectangleShapePainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "四角形",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Rectangle",
        ),
      ]),
      icon: Icons.rectangle,
    ),
  });

  @override
  String get id => _kRectangleShapePainterInlineToolsId;

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
        borderRadius: BorderRadius.circular(0),
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
  RectanglePaintingValue create({
    required Offset point,
    required PaintingProperty property,
    String? uid,
  }) {
    return RectanglePaintingValue(
      id: uid ?? uuid(),
      property: property,
      start: point,
      end: point,
    );
  }

  @override
  RectanglePaintingValue? convertFromJson(DynamicMap json) {
    final type = json.get(PaintingValue.typeKey, "");
    if (type == _kRectangleShapePainterInlineToolsId) {
      return RectanglePaintingValue.fromJson(json);
    }
    return null;
  }

  @override
  DynamicMap? convertToJson(PaintingValue value) {
    if (value is RectanglePaintingValue) {
      return value.toJson();
    }
    return null;
  }
}
