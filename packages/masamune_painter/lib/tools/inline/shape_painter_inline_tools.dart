part of "/masamune_painter.dart";

/// Display the Shapes menu [PainterTools].
///
/// 図形メニューを表示する[PainterTools]。
@immutable
class ShapePainterInlineTools extends PainterInlineTools {
  /// Display the Shapes menu [PainterTools].
  ///
  /// 図形メニューを表示する[PainterTools]。
  const ShapePainterInlineTools({
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
  });

  @override
  String get id => "__painter_shape_inline__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    final shapeTool =
        PainterMasamuneAdapter.findTool<ShapePainterPrimaryTools>();
    if (shapeTool == null) {
      return false;
    }
    if (ref.currentTool == null) {
      return false;
    }
    if (shapeTool.inlineTools.contains(ref.currentTool)) {
      return true;
    }
    final prevTool = ref.controller._prevTool;
    if (prevTool != null) {
      if (shapeTool.inlineTools.contains(prevTool)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    final shapeTool =
        PainterMasamuneAdapter.findTool<ShapePainterPrimaryTools>();
    if (shapeTool == null) {
      return Icon(config.icon);
    }
    final activeTool = shapeTool.inlineTools.firstWhereOrNull((e) {
      return e == ref.currentTool;
    });
    if (activeTool != null) {
      return activeTool.icon(context, ref);
    }
    final prevTool = ref.controller._prevTool;
    if (prevTool != null) {
      final activeTool = shapeTool.inlineTools.firstWhereOrNull((e) {
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
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {}

  @override
  Future<void> onActive(BuildContext context, PainterToolRef ref) async {
    ref.deleteMode();
  }

  @override
  Future<void> onDeactive(BuildContext context, PainterToolRef ref) async {
    ref.controller.unselect();
    ref.deleteMode();
  }
}
