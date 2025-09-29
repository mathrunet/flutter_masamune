part of "/masamune_painter.dart";

/// Display the menu to undo [PainterTools].
///
/// 元に戻すメニューを表示する[PainterTools]。
@immutable
class BackgroundColorPainterPrimaryTools extends PainterPrimaryTools {
  /// Display the menu to undo [PainterTools].
  ///
  /// 元に戻すメニューを表示する[PainterTools]。
  const BackgroundColorPainterPrimaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "背景色",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Background Color",
        ),
      ]),
      icon: Icons.format_color_fill,
    ),
  });

  @override
  String get id => "__painter_background_color__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
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
    if (ref.currentValues.isNotEmpty) {
      final color = ref.currentValueBackgroundColor;

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
      final disabled = ref.currentToolBackgroundColor.a <= 0.0;
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
              color: ref.currentToolBackgroundColor,
              child: Icon(
                config.icon,
                size: 18,
                color: ref.currentToolBackgroundColor.a < 0.5
                    ? theme.colorTheme?.onBackground ?? Colors.transparent
                    : ref.currentToolBackgroundColor.computeLuminance() > 0.5
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
    if (ref.currentValues.isNotEmpty) {
      await Modal.show(
        context,
        modal: ColorPickerModal(
          ref: ref,
          activeTool: this,
          onRetrieveColor: () {
            return ref.currentValueBackgroundColor;
          },
          onColorChanged: (color) {
            ref.setValueProperty(backgroundColor: color);
          },
        ),
      );
    } else {
      await Modal.show(
        context,
        modal: ColorPickerModal(
          ref: ref,
          activeTool: this,
          onRetrieveColor: () {
            return ref.currentToolBackgroundColor;
          },
          onColorChanged: (color) {
            ref.setToolProperty(backgroundColor: color);
          },
        ),
      );
    }
  }
}
