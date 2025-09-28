part of "/masamune_painter.dart";

/// Color picker modal.
///
/// A modal for selecting a color.
///
/// カラーピッカーモーダル。
///
/// 色を選択するためのモーダル。
@immutable
class ColorPickerModal extends Modal {
  /// Color picker modal.
  ///
  /// A modal for selecting a color.
  ///
  /// カラーピッカーモーダル。
  ///
  /// 色を選択するためのモーダル。
  const ColorPickerModal({
    required this.ref,
    required this.activeTool,
    this.submitLabel,
    this.submitIcon,
  });

  /// Current color.
  ///
  /// 現在の色。
  final PainterToolRef ref;

  /// Active tool.
  ///
  /// 現在のツール。
  final PainterPrimaryTools activeTool;

  /// Submit label.
  ///
  /// 確定ボタンのラベル。
  final Widget? submitLabel;

  /// Submit icon.
  ///
  /// 確定ボタンのアイコン。
  final Widget? submitIcon;

  @override
  Widget build(BuildContext context, ModalRef ref) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    if (activeTool is BackgroundColorPainterPrimaryTools) {
                      this.ref.controller.addColorToHistory(
                            this.ref.currentBackgroundColor,
                          );
                    } else {
                      this.ref.controller.addColorToHistory(
                            this.ref.currentForegroundColor,
                          );
                    }
                    ref.close();
                  },
                  icon: submitIcon ?? const Icon(Icons.close),
                ),
                const Spacer(),
                Container(
                  height: 26,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorTheme?.onBackground ??
                          Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(activeTool.config.icon, size: 18),
                      const SizedBox(width: 8),
                      DefaultTextStyle(
                        style: theme.textTheme.titleMedium ?? const TextStyle(),
                        child: activeTool.label(context, this.ref),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            Indent(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListenableBuilder(
                  listenable: this.ref.controller,
                  builder: (context, _) {
                    if (activeTool is BackgroundColorPainterPrimaryTools) {
                      return ColorPicker(
                        pickerColor: this.ref.currentBackgroundColor,
                        onColorChanged: (Color newColor) {
                          this.ref.setProperty(backgroundColor: newColor);
                        },
                        pickerAreaHeightPercent: 0.8,
                        enableAlpha: true,
                        displayThumbColor: true,
                        labelTypes: const [],
                        paletteType: PaletteType.hsv,
                      );
                    } else {
                      return ColorPicker(
                        pickerColor: this.ref.currentForegroundColor,
                        onColorChanged: (Color newColor) {
                          this.ref.setProperty(foregroundColor: newColor);
                        },
                        pickerAreaHeightPercent: 0.8,
                        enableAlpha: true,
                        displayThumbColor: true,
                        labelTypes: const [],
                        paletteType: PaletteType.hsv,
                      );
                    }
                  },
                ),
                if (this.ref.controller.colorHistory.isNotEmpty) ...[
                  ...this.ref.controller.colorHistory.split(5).map((r) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...r.map((e) => SizedBox(
                                width: 28,
                                height: 28,
                                child: GestureDetector(
                                  onTap: () {
                                    this.ref.setProperty(backgroundColor: e);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: e,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: theme.colorTheme?.onBackground ??
                                            theme.colorScheme.outline,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
