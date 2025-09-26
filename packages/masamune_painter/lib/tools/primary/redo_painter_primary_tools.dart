part of "/masamune_painter.dart";

/// Display the menu to redo [PainterTools].
///
/// やり直しメニューを表示する[PainterTools]。
@immutable
class RedoPainterPrimaryTools extends PainterPrimaryTools {
  /// Display the menu to redo [PainterTools].
  ///
  /// やり直しメニューを表示する[PainterTools]。
  const RedoPainterPrimaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "やり直し",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Redo",
        ),
      ]),
      icon: FontAwesomeIcons.arrowRotateRight,
    ),
  });

  @override
  String get id => "__painter_redo__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return true;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => ref.canRedo;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.currentTool == null;
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
    ref.redo();
  }
}
