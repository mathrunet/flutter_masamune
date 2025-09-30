part of "/masamune_painter.dart";

/// Display the menu to draw a 10px font [PainterTools].
///
/// 10pxフォントを描画するメニューを表示する[PainterTools]。
@immutable
class Size10pxFontPainterBlockTools extends PainterFontSizeBlockTools {
  /// Display the menu to draw a 10px font [PainterTools].
  ///
  /// 10pxフォントを描画するメニューを表示する[PainterTools]。
  const Size10pxFontPainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "10px",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "10px",
        ),
      ]),
      icon: Icons.line_weight,
    ),
  });

  @override
  String get id => "__painter_block_text_size_10px__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    if (ref.controller.currentValues.isNotEmpty) {
      return ref.controller.property.currentValueLine == this;
    } else {
      return ref.controller.property.currentToolLine == this;
    }
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {}

  @override
  // TODO: implement fontSize
  double get fontSize => throw UnimplementedError();

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    // TODO: implement icon
    throw UnimplementedError();
  }
}
