part of "/masamune_painter.dart";

/// Display the menu to draw a 10px solid line [PainterTools].
///
/// 10px実線を描画するメニューを表示する[PainterTools]。
@immutable
class Solid10pxLinePainterBlockTools extends PainterLineBlockTools {
  /// Display the menu to draw a 10px solid line [PainterTools].
  ///
  /// 10px実線を描画するメニューを表示する[PainterTools]。
  const Solid10pxLinePainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "10px実線",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "10px Solid Line",
        ),
      ]),
      icon: Icons.line_weight,
    ),
  });

  @override
  String get id => "__painter_block_line_solid_10px__";

  @override
  double get strokeWidth => 10.0;

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.currentLine == this;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    final theme = Theme.of(context);
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        border: Border.all(
            color: theme.colorTheme?.onBackground ?? Colors.transparent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("10px", style: theme.textTheme.labelSmall?.smallize(3)),
          Container(
            height: 5,
            color: theme.colorTheme?.onBackground,
          ),
        ],
      ),
    );
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {
    ref.setProperty(line: this);
    ref.deleteMode();
  }
}
