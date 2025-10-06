part of "/masamune_painter.dart";

/// Display the menu to select shape [PainterTools].
///
/// 図形を選択するメニューを表示する[PainterTools]。
@immutable
class ShapePainterPrimaryTools extends PainterPrimaryTools {
  /// Display the menu to select shape [PainterTools].
  ///
  /// 図形を選択するメニューを表示する[PainterTools]。
  const ShapePainterPrimaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "図形",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Shape",
        ),
      ]),
      icon: FontAwesomeIcons.shapes,
    ),
    this.inlineTools = const [
      BackPainterInlineTools(),
      RectangleShapePainterInlineTools(),
      EllipseShapePainterInlineTools(),
    ],
  });

  @override
  final List<PainterInlineTools> inlineTools;

  @override
  String get id => "__painter_shape__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    if (ref.controller.currentTool == null) {
      return false;
    }
    if (inlineTools.contains(ref.controller.currentTool)) {
      return true;
    }
    final prevTool = ref.controller._prevTool;
    if (prevTool != null) {
      if (inlineTools.contains(prevTool)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    final activeTool = inlineTools.firstWhereOrNull((e) {
      return e == ref.controller.currentTool;
    });
    if (activeTool != null) {
      return activeTool.icon(context, ref);
    }
    final prevTool = ref.controller._prevTool;
    if (prevTool != null) {
      final activeTool = inlineTools.firstWhereOrNull((e) {
        return e == prevTool;
      });
      if (activeTool != null) {
        return activeTool.icon(context, ref);
      }
    }
    return Icon(config.icon);
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final activeTool = inlineTools.firstWhereOrNull((e) {
      return e == ref.controller.currentTool;
    });
    if (activeTool != null) {
      return activeTool.label(context, ref);
    }
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {
    ref.toggleMode(this);
  }

  @override
  bool get canSelect => true;
}
