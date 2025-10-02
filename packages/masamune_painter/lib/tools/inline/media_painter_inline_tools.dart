part of "/masamune_painter.dart";

/// Display the media menu [PainterTools].
///
/// メディアメニューを表示する[PainterTools]。
@immutable
class MediaPainterInlineTools extends PainterInlineTools {
  /// Display the media menu [PainterTools].
  ///
  /// メディアメニューを表示する[PainterTools]。
  const MediaPainterInlineTools({
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

  @override
  String get id => "__painter_media_inline__";

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
  void onTap(BuildContext context, PainterToolRef ref) {}

  @override
  Future<void> onActive(BuildContext context, PainterToolRef ref) async {
    ref.deleteMode();
  }

  @override
  Future<void> onDeactive(BuildContext context, PainterToolRef ref) async {
    ref.deleteMode();
    ref.controller.unselectAll();
  }
}
