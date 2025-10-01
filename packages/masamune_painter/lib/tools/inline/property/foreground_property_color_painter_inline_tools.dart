part of "/masamune_painter.dart";

/// Display foreground color properties [PainterTools].
///
/// 前景色のプロパティを表示する[PainterTools]。
@immutable
class ForegroundPropertyColorPainterInlineTools extends PainterInlineTools {
  /// Display foreground color properties [PainterTools].
  ///
  /// 前景色のプロパティを表示する[PainterTools]。
  const ForegroundPropertyColorPainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "前景色",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Foreground Color",
        ),
      ]),
      icon: Icons.border_color,
    ),
  });

  @override
  String get id => "__painter_property_foreground_color__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    final inlineMode = ref.inlineMode;
    if (inlineMode == PainterInlineMode.select) {
      final values = ref.controller.currentValues;
      if (values.any((e) =>
          e.category == PaintingValueCategory.text ||
          e.category == PaintingValueCategory.shape)) {
        return true;
      }
      return false;
    }
    return true;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return false;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    // 選択されている場合はそのプロパティを表示
    final theme = Theme.of(context);
    if (ref.controller.currentValues.isNotEmpty) {
      final color = ref.controller.property.currentValueForegroundColor;

      if (color == null) {
        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorTheme?.onBackground ?? Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: 0.25,
                    child: Icon(
                      config.icon,
                      size: 18,
                      color:
                          theme.colorTheme?.onBackground ?? Colors.transparent,
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
          ),
        );
      } else {
        final disabled = color.a <= 0.0;
        return Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorTheme?.onBackground ?? Colors.transparent,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Opacity(
              opacity: disabled ? 0.25 : 1,
              child: ColoredBox(
                color: color,
                child: Icon(
                  config.icon,
                  size: 18,
                  color: color.a < 0.5
                      ? theme.colorTheme?.onBackground ?? Colors.transparent
                      : color.computeLuminance() > 0.5
                          ? kBlackColor
                          : kWhiteColor,
                ),
              ),
            ),
          ),
        );
      }
      // それ以外はデフォルトのプロパティを表示
    } else {
      final disabled =
          ref.controller.property.currentToolForegroundColor.a <= 0.0;
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          border: Border.all(
            color: theme.colorTheme?.onBackground ?? Colors.transparent,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Opacity(
            opacity: disabled ? 0.25 : 1,
            child: ColoredBox(
              color: ref.controller.property.currentToolForegroundColor,
              child: Icon(
                config.icon,
                size: 18,
                color:
                    ref.controller.property.currentToolForegroundColor.a < 0.5
                        ? theme.colorTheme?.onBackground ?? Colors.transparent
                        : ref.controller.property.currentToolForegroundColor
                                    .computeLuminance() >
                                0.5
                            ? kBlackColor
                            : kWhiteColor,
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) async {
    // カラーピッカーダイアログを表示
    if (ref.controller.currentValues.isNotEmpty) {
      await Modal.show(
        context,
        barrierDismissible: true,
        modal: ColorPickerModal(
          ref: ref,
          activeTool: this,
          onRetrieveColor: () {
            return ref.controller.property.currentValueForegroundColor;
          },
          onColorChanged: (color) {
            ref.controller.property.setValues(foregroundColor: color);
          },
        ),
      );
    } else {
      await Modal.show(
        context,
        barrierDismissible: true,
        modal: ColorPickerModal(
          ref: ref,
          activeTool: this,
          onRetrieveColor: () {
            return ref.controller.property.currentToolForegroundColor;
          },
          onColorChanged: (color) {
            ref.controller.property.setTool(foregroundColor: color);
          },
        ),
      );
    }
  }

  @override
  Future<void> onActive(BuildContext context, PainterToolRef ref) async {
    onTap(context, ref);
  }

  @override
  Future<void> onDeactive(BuildContext context, PainterToolRef ref) async {
    onTap(context, ref);
  }
}
