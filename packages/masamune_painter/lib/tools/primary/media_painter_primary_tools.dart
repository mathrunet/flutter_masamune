part of "/masamune_painter.dart";

const _kMediaPainterPrimaryToolsId = "__painter_media__";

/// Display the menu to select media [PainterTools].
///
/// メディアを選択するメニューを表示する[PainterTools]。
@immutable
class MediaPainterPrimaryTools
    extends PainterVariablePrimaryTools<MediaPaintingValue> {
  /// Display the menu to select media [PainterTools].
  ///
  /// メディアを選択するメニューを表示する[PainterTools]。
  const MediaPainterPrimaryTools({
    required this.blockTools,
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "メディア",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Media",
        ),
      ]),
      icon: FontAwesomeIcons.image,
    ),
  });

  /// Tools for selecting media.
  ///
  /// メディアを選択するツール。
  @override
  final List<PainterBlockTools> blockTools;

  @override
  String get id => _kMediaPainterPrimaryToolsId;

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentTool is MediaPainterInlineTools ||
        ref.controller.currentTool is MediaPainterPrimaryTools ||
        ref.controller._prevTool is MediaPainterInlineTools ||
        ref.controller._prevTool is MediaPainterPrimaryTools;
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
  MediaPaintingValue create({
    required Offset point,
    required PaintingProperty property,
    String? uid,
    Uri? uri,
  }) {
    return MediaPaintingValue(
      id: uid ?? uuid(),
      property: property,
      start: point,
      end: point,
      path: uri,
    );
  }

  @override
  MediaPaintingValue? convertFromJson(DynamicMap json) {
    final type = json.get(PaintingValue.typeKey, "");
    if (type == _kMediaPainterPrimaryToolsId) {
      return MediaPaintingValue.fromJson(json);
    }
    return null;
  }

  @override
  DynamicMap? convertToJson(PaintingValue value) {
    if (value is MediaPaintingValue) {
      return value.toJson();
    }
    return null;
  }
}
