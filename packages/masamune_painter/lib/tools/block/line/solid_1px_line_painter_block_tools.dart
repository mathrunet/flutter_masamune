part of "/masamune_painter.dart";

/// Display the menu to draw a 1px solid line [PainterTools].
///
/// 1px実線を描画するメニューを表示する[PainterTools]。
@immutable
class Solid1pxLinePainterBlockTools extends PainterLineBlockTools {
  /// Display the menu to draw a 1px solid line [PainterTools].
  ///
  /// 1px実線を描画するメニューを表示する[PainterTools]。
  const Solid1pxLinePainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "1px実線",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "1px Solid Line",
        ),
      ]),
      icon: Icons.line_weight,
    ),
  });

  @override
  String get id => "__painter_block_line_solid_1px__";

  @override
  double get strokeWidth => 1.0;

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    if (ref.currentValues.isNotEmpty) {
      return ref.currentValueLine == this;
    } else {
      return ref.currentToolLine == this;
    }
  }

  @override
  Widget strokeIcon(
    BuildContext context,
    PainterToolRef ref, {
    Color? color,
  }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "1px",
          style: theme.textTheme.labelSmall?.smallize(3).copyWith(color: color),
        ),
        Container(
          height: 1,
          color: color ?? theme.colorTheme?.onBackground,
        ),
      ],
    );
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {
    if (ref.currentValues.isNotEmpty) {
      ref.setValueProperty(tool: this);
    } else {
      ref.setToolProperty(tool: this);
    }
    final prevTool = ref.controller._prevTool;
    if (prevTool != null) {
      ref.toggleMode(prevTool);
    } else {
      ref.deleteMode();
    }
  }
}
