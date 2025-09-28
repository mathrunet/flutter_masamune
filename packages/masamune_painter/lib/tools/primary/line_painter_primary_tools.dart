part of "/masamune_painter.dart";

/// Display the menu to undo [PainterTools].
///
/// 元に戻すメニューを表示する[PainterTools]。
@immutable
class LinePainterPrimaryTools extends PainterPrimaryTools {
  /// Display the menu to undo [PainterTools].
  ///
  /// 元に戻すメニューを表示する[PainterTools]。
  const LinePainterPrimaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "線",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Line",
        ),
      ]),
      icon: FontAwesomeIcons.line,
    ),
  });

  @override
  List<PainterBlockTools> get blockTools => const [
        Solid1pxLinePainterBlockTools(),
        Solid10pxLinePainterBlockTools(),
      ];

  @override
  String get id => "__painter_line__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return true;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.currentTool is LinePainterPrimaryTools;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    return ref.currentLine.icon(context, ref);
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
}
