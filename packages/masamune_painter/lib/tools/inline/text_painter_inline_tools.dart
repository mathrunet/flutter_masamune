part of "/masamune_painter.dart";

/// Display the text menu [PainterTools].
///
/// テキストメニューを表示する[PainterTools]。
@immutable
class TextPainterInlineTools extends PainterInlineTools {
  /// Display the text menu [PainterTools].
  ///
  /// テキストメニューを表示する[PainterTools]。
  const TextPainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "テキスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Text",
        ),
      ]),
      icon: FontAwesomeIcons.font,
    ),
  });

  @override
  String get id => "__painter_text_inline__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentTool is TextPainterInlineTools ||
        ref.controller.currentTool is TextPainterPrimaryTools ||
        ref.controller._prevTool is TextPainterInlineTools ||
        ref.controller._prevTool is TextPainterPrimaryTools;
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
    // テキスト編集を終了してから選択解除
    ref.deleteMode();
    ref.controller.unselect();
  }
}
