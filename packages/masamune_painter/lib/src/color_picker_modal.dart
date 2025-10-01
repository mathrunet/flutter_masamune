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
    this.onColorChanged,
    this.onRetrieveColor,
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
  final PainterTools activeTool;

  /// Submit label.
  ///
  /// 確定ボタンのラベル。
  final Widget? submitLabel;

  /// Submit icon.
  ///
  /// 確定ボタンのアイコン。
  final Widget? submitIcon;

  /// Color changed.
  ///
  /// 色が変更された。
  final void Function(Color color)? onColorChanged;

  /// Retrieve color.
  ///
  /// 色を取得する。
  final Color? Function()? onRetrieveColor;

  @override
  Widget build(BuildContext context, ModalRef ref) {
    final theme = Theme.of(context);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          final color = onRetrieveColor?.call();
          if (color != null) {
            this.ref.controller.colorPalette.add(color);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 16),
                  Container(
                    height: 26,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorTheme?.onBackground ??
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
                          style:
                              theme.textTheme.titleMedium ?? const TextStyle(),
                          child: activeTool.label(context, this.ref),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ref.close();
                    },
                    icon: submitIcon ?? const Icon(Icons.close),
                  ),
                ],
              ),
              ListenableBuilder(
                listenable: this.ref.controller,
                builder: (context, _) {
                  return Indent(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ColorPicker(
                        pickerColor:
                            onRetrieveColor?.call() ?? Colors.transparent,
                        onColorChanged: (color) {
                          onColorChanged?.call(color);
                        },
                        pickerAreaHeightPercent: 0.8,
                        enableAlpha: true,
                        displayThumbColor: true,
                        labelTypes: const [],
                        paletteType: PaletteType.hsv,
                      ),
                      if (this
                          .ref
                          .controller
                          .colorPalette
                          .value
                          .isNotEmpty) ...[
                        ...this
                            .ref
                            .controller
                            .colorPalette
                            .value
                            .split(5)
                            .map((r) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...r.map(
                                  (e) => SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: GestureDetector(
                                      onTap: () {
                                        onColorChanged?.call(e);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: e,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: theme
                                                    .colorTheme?.onBackground ??
                                                theme.colorScheme.outline,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
