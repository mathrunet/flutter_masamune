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
    if (ref.currentValues.isNotEmpty) {
      final theme = Theme.of(context);
      return ref.currentValueLine?.icon(context, ref) ??
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              border: Border.all(
                  color: theme.colorTheme?.onBackground ?? Colors.transparent),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: 0.25,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("???",
                            style: theme.textTheme.labelSmall?.smallize(3)),
                        Container(
                          height: 1,
                          color: theme.colorTheme?.onBackground,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.question_mark,
                    size: 18,
                    color: theme.colorTheme?.onBackground ?? Colors.transparent,
                  ),
                ),
              ],
            ),
          );
    } else {
      return ref.currentToolLine.icon(context, ref);
    }
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
