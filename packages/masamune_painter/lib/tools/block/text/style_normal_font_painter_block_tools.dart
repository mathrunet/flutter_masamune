part of "/masamune_painter.dart";

/// Display the menu to draw a normal font [PainterTools].
///
/// 標準フォントを描画するメニューを表示する[PainterTools]。
@immutable
class StyleNormalFontPainterBlockTools extends PainterFontStyleBlockTools {
  /// Display the menu to draw a normal font [PainterTools].
  ///
  /// 標準フォントを描画するメニューを表示する[PainterTools]。
  const StyleNormalFontPainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "標準",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Normal",
        ),
      ]),
      icon: Icons.line_weight,
    ),
  });

  @override
  String get id => "__painter_block_text_style_normal__";

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
  Widget icon(BuildContext context, PainterToolRef ref) {
    // TODO: implement icon
    throw UnimplementedError();
  }
}
